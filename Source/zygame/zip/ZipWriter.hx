package zygame.zip;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.zip.Entry;
import haxe.zip.Writer;
import haxe.io.BufferInput;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.zip.Compress;
import haxe.zip.InflateImpl;

#if lime
#if (lime >= "7.0.0")
import lime._internal.format.Deflate;
#else
import lime.utils.compress.Deflate;
#end
#end

/**
 * Write a Zip File 来自https://github.com/starburst997/haxe-zip/blob/master/src/zip/ZipWriter.hx
 */
class ZipWriter extends Writer {
	var output:BytesOutput;

	public function new() {
		output = new BytesOutput();

		super(output);
	}

	public static inline function rawCompress(bytes:Bytes) {
		#if js
		// Haxe Deflate is currently unoptimized, use pako instead,
		// didn't want 3rd party library but it works very well so...
		var data = untyped __js__("pako.deflateRaw")(bytes.getData());
		return Bytes.ofData(data);
		#elseif lime
		return Deflate.compress(bytes);
		#elseif (cpp || neko)
		// Is this better than OpenFL CFFI ???
		// Did not test it but I would assume it's not since OpenFL don't use it...
		var data = Compress.run(bytes, 9);
		return data.sub(2, data.length - 6);
		#elseif flash
		// Flash Native, maybe DeflateStream using Memory the proper way
		// like it was before I change it to make it cross platform would be?
		var data = bytes.getData();
		data.deflate();
		return Bytes.ofData(data);
		#else
		// Pure Haxe, should work everywhere else (VERY UNOPTIMIZED!!!)
		// But allow for step by step compression, could be nice for extremely huge file?
		var deflateStream = DeflateStream.create(NORMAL);
		deflateStream.write(new BytesInput(bytes));

		return deflateStream.finalize();
		#end
	}

	// Add a Bytes Entry
	public function addBytes(bytes:Bytes, name:String, compressed:Bool = true, date:Date = null):Void {
		var crc = haxe.crypto.Crc32.make(bytes);
		var data = compressed ? rawCompress(bytes) : bytes;

		var e:Entry = {
			fileName: name,
			fileSize: bytes.length,
			fileTime: date == null ? Date.now() : date,
			compressed: compressed,
			dataSize: data.length,
			data: data,
			crc32: crc
		};

		writeEntryHeader(e);
		o.writeFullBytes(data, 0, data.length);
	}

	// Add a String Entry
	public function addString(string:String, name:String, compressed:Bool = true, date:Date = null):Void {
		addBytes(Bytes.ofString(string), name, compressed, date);
	}

	// Finalize Zip returning the Bytes
	public function finalize():Bytes {
		writeCDR();

		#if js
		// For some reason, JS saves a bunch of zero at the end
		var length = output.length;
		var bytes = output.getBytes();

		var finalBytes = Bytes.alloc(length);
		finalBytes.blit(0, bytes, 0, length);

		return finalBytes;
		#else
		return output.getBytes();
		#end
	}

	// Allow optimization when Entry has no Data
	public override function writeEntryHeader(f:Entry) {
		var o = this.o;
		var flags = 0;
		if (f.extraFields != null) {
			for (e in f.extraFields)
				switch (e) {
					case FUtf8:
						flags |= 0x800;
					default:
				}
		}
		o.writeInt32(0x04034B50);
		o.writeUInt16(0x0014); // version
		o.writeUInt16(flags); // flags

		// Modification
		if (f.crc32 == null) {
			if (f.compressed)
				throw "CRC32 must be processed before compression";
			if (f.data != null)
				f.crc32 = haxe.crypto.Crc32.make(f.data);
		}
		if (f.data != null) {
			if (!f.compressed)
				f.fileSize = f.data.length;
			f.dataSize = f.data.length;
		}

		/*if( f.data == null ) {
				f.fileSize = 0;
				f.dataSize = 0;
				f.crc32 = 0;
				f.compressed = false;
				f.data = haxe.io.Bytes.alloc(0);
			} else {
				if( f.crc32 == null ) {
					if( f.compressed ) throw "CRC32 must be processed before compression";
					f.crc32 = haxe.crypto.Crc32.make(f.data);
				}
				if( !f.compressed )
					f.fileSize = f.data.length;
				f.dataSize = f.data.length;
		}*/
		// --

		o.writeUInt16(f.compressed ? 8 : 0);
		writeZipDate(f.fileTime);
		o.writeInt32(f.crc32);
		o.writeInt32(f.dataSize);
		o.writeInt32(f.fileSize);
		o.writeUInt16(f.fileName.length);
		var e = new haxe.io.BytesOutput();
		if (f.extraFields != null) {
			for (f in f.extraFields)
				switch (f) {
					case FInfoZipUnicodePath(name, crc):
						var namebytes = haxe.io.Bytes.ofString(name);
						e.writeUInt16(0x7075);
						e.writeUInt16(namebytes.length + 5);
						e.writeByte(1); // version
						e.writeInt32(crc);
						e.write(namebytes);
					case FUnknown(tag, bytes):
						e.writeUInt16(tag);
						e.writeUInt16(bytes.length);
						e.write(bytes);
					case FUtf8:
						// nothing
				}
		}
		var ebytes = e.getBytes();
		o.writeUInt16(ebytes.length);
		o.writeString(f.fileName);
		o.write(ebytes);
		files.add({
			name: f.fileName,
			compressed: f.compressed,
			clen: f.data != null ? f.data.length : f.dataSize,
			size: f.fileSize,
			crc: f.crc32,
			date: f.fileTime,
			fields: ebytes
		});
	}
}

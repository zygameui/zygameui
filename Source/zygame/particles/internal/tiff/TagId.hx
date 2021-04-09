package zygame.particles.internal.tiff;

@:enum
abstract TagId(Int) {
    // hex representation, type, number of values
    var NewSubFileType = 254; // 0x00fe, LONG, 1
    var SubFileType = 255; // 0x00ff, SHORT, 1
    var ImageWidth = 256; // 0x0100, SHORT or LONG, 1
    var ImageLength = 257; // 0x0101, SHORT or LONG, 1
    var BitsPerSample = 258; // 0x0102, SHORT, SamplesPerPixel
    var Compression = 259; // 0x0103, SHORT, 1
    var PhotometricInterpretation = 262; // 0x0106, SHORT, 1
    var Thresholding = 263; // 0x0107, SHORT, 1
    var CellWidth = 264; // 0x0108, SHORT, 1
    var CellLength = 265; // 0x0109, SHORT, 1
    var FillOrder = 266; // 0x010a, SHORT, 1
    var DocumentName = 269; // 0x010d, ASCII
    var ImageDescription = 270; // 0x010e, ASCII
    var Make = 271; // 0x010f, ASCII
    var Model = 272; // 0x0110, ASCII
    var StripOffsets = 273; // 0x0111, SHORT or LONG, StripsPerImage
    var Orientation = 274; // 0x0112, SHORT, 1
    var SamplesPerPixel = 277; // 0x0115, SHORT, 1
    var RowsPerStrip = 278; // 0x0116, SHORT or LONG, 1
    var StripByteCounts = 279; // 0x0117, LONG or SHORT, StripsPerImage
    var MinSampleValue = 280; // 0x0118, SHORT, SamplesPerPixel
    var MaxSampleValue = 281; // 0x0119, SHORT, SamplesPerPixel
    var XResolution = 282; // 0x011a, RATIONAL, 1
    var YResolution = 283; // 0x011b, RATIONAL, 1
    var PlanarConfiguration = 284; // 0x011c, SHORT, 1
    var PageName = 285; // 0x011d, ASCII
    var XPosition = 286; // 0x011e, RATIONAL
    var YPosition = 287; // 0x011f, RATIONAL
    var FreeOffsets = 288; // 0x0120, LONG
    var FreeByteCounts = 289; // 0x0121, LONG
    var GrayResponseUnit = 290; // 0x0122, SHORT, 1
    var GrayResponseCurve = 291; // 0x0123, SHORT, pow(2, BitsPerSample)
    var T4Options = 292; // 0x0124, LONG, 1
    var T6Options = 293; // 0x0125, LONG, 1
    var ResolutionUnit = 296; // 0x0128, SHORT, 1
    var PageNumber = 297; // 0x0129, SHORT, 2
    var TransferFunction = 301; // 0x012d, SHORT, {1 or SamplesPerPixel} * pow(2, BitsPerSample)
    var Software = 305; // 0x0131, ASCII
    var DateTime = 306; // 0x0132, ASCII, 20
    var Artist = 315; // 0x013b, ASCII
    var HostComputer = 316; // 0x013c, ASCII
    var Predictor = 317; // 0x013d, SHORT, 1
    var WhitePoint = 318; // 0x013e, RATIONAL, 2
    var PrimaryChromaticities = 319; // 0x013f, RATIONAL, 6
    var ColorMap = 320; // 0x0140, SHORT, 3 * pow(2, BitsPerSample)
    var HalftoneHints = 321; // 0x0141, SHORT, 2
    var TileWidth = 322; // 0x0142, SHORT or LONG, 1
    var TileLength = 323; // 0x0143, SHORT or LONG, 1
    var TileOffsets = 324; // 0x0144, LONG, TilesPerImage
    var TileByteCounts = 325; // 0x0145, SHORT or LONG, TilesPerImage
    var InkSet = 332; // 0x014c, SHORT, 1
    var InkNames = 333; // 0x014d, ASCII, total number of characters in all ink name strings, including zeros
    var NumberOfInks = 334; // 0x014e, SHORT, 1
    var DotRange = 336; // 0x0150, BYTE or SHORT, {2 or 2 * NumberOfInks}
    var TargetPrinter = 337; // 0x0151, ASCII, any
    var ExtraSamples = 338; // 0x0152, BYTE, number of extra components per pixel
    var SampleFormat = 339; // 0x0153, SHORT, SamplesPerPixel
    var SMinSampleValue = 340; // 0x0154, Any, SamplesPerPixel
    var SMaxSampleValue = 341; // 0x0155, Any, SamplesPerPixel
    var TransferRange = 342; // 0x0156, SHORT, 6
    var JPEGProc = 512; // 0x0200, SHORT, 1
    var JPEGInterchangeFormat = 513; // 0x0201, LONG, 1
    var JPEGInterchangeFormatLength = 514; // 0x0202, LONG, 1
    var JPEGRestartInterval = 515; // 0x0203, SHORT, 1
    var JPEGLosslessPredictors = 517; // 0x0205, SHORT, SamplesPerPixel
    var JPEGPointTransforms = 518; // 0x0206, SHORT, SamplesPerPixel
    var JPEGQTables = 519; // 0x0207, LONG, SamplesPerPixel
    var JPEGDCTTables = 520; // 0x0208, LONG, SamplesPerPixel
    var JPEGACTTables = 521; // 0x0209, LONG, SamplesPerPixel
    var YCbCrCoefficients = 529; // 0x0211, RATIONAL, 3
    var YCbCrSubSampling = 530; // 0x0212, SHORT, 2
    var YCbCrPositioning = 531; // 0x0213, SHORT, 1
    var ReferenceBlackWhite = 532; // 0x0214, LONG, 2 * SamplesPerPixel
    var Copyright = 33432; // 0x08298, ASCII, any
}

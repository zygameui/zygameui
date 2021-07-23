Cur_Dir=$(cd "$(dirname "$0")"; pwd) 
cd $Cur_Dir;

#得到所有import
function getImport(){
	# echo "路径：""$1 | $2";
	for file in $1/*; do
		#statements
		if [[ -d $file ]]; then
			#statements
			getImport $file $2
		elif [[ "$file" =~ ".hx" ]]; then
			if [[ ! "$file" =~ "import" ]]; then
			src=${file};
			src=${src//$2\//}
			src=${src////.};
			src=${src//.hx/}
			echo "import "$src";";
			fi
		fi
	done
}

data="package zygame.core;"`getImport Source Source`
# data=$data`getImport /Users/grtf/haxelib/qqplaycore/src /Users/grtf/haxelib/qqplaycore/src;`
# data=$data`getImport /Users/grtf/haxelib/wechatcore/src /Users/grtf/haxelib/wechatcore/src;`

echo "生成Imports";
echo $data > Source/zygame/core/ImportAll.hx;
echo "编译中";
lime build html5;
if [[ $? -eq 1 ]]; then
	echo "发生异常";
	exit $?;
fi
echo "生成Doc";
haxelib run dox -i bin -o docs -in zygame -in KengSDK -in UMengSDK -in qq -in wx
echo "生成结束";

rm -rf Export
rm -rf bin
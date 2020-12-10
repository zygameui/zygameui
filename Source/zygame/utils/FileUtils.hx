package zygame.utils;

import lime.ui.FileDialog;
import lime.ui.FileDialogType;
import zygame.utils.Log;

/**
 *  文件管理系统
 */
class FileUtils {

    /**
     *  选择文件夹
     *  @param title - 
     *  @param call - 
     */
    public static function browseDirectory(title:String,call:String->Void):Void
    {
        var dialog:FileDialog = new FileDialog();
        dialog.onSelect.add(function(path:String):Void{
            if(call != null)
                call(path);
        });
        dialog.browse(FileDialogType.OPEN_DIRECTORY,null,null,title);
    }

    /**
     * 检查资源是否存在，支持安卓的路径判定
     * @param path 
     */
    public static function exists(path:String):Bool
    {
        #if (kengsdk && android)
        return AndroidUtils.exists(path);
        #elseif cpp
        return sys.FileSystem.exists(path);
        #else
        return false;
        #end
    }

}
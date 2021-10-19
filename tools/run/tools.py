import sys

import math as python_lib_Math
import math as Math
from os import path as python_lib_os_Path
import inspect as python_lib_Inspect
import chardet as python_Chardet
import getpass as python_GetPass
import urllib.request as python_HttpDownload
import sys as python_lib_Sys
import traceback as python_lib_Traceback
import pandas as python_Pandas
import xlrd as python_XlsData
import builtins as python_lib_Builtins
import functools as python_lib_Functools
import json as python_lib_Json
import os as python_lib_Os
import random as python_lib_Random
import re as python_lib_Re
import shutil as python_lib_Shutil
import socket as python_lib_Socket
import ssl as python_lib_Ssl
import subprocess as python_lib_Subprocess
from datetime import datetime as python_lib_datetime_Datetime
from datetime import timezone as python_lib_datetime_Timezone
from io import BufferedReader as python_lib_io_BufferedReader
from io import BufferedWriter as python_lib_io_BufferedWriter
from io import StringIO as python_lib_io_StringIO
from io import TextIOWrapper as python_lib_io_TextIOWrapper
from socket import socket as python_lib_socket_Socket
from ssl import SSLContext as python_lib_ssl_SSLContext
from subprocess import Popen as python_lib_subprocess_Popen
import urllib.parse as python_lib_urllib_Parse


class _hx_AnonObject:
    _hx_disable_getattr = False
    def __init__(self, fields):
        self.__dict__ = fields
    def __repr__(self):
        return repr(self.__dict__)
    def __contains__(self, item):
        return item in self.__dict__
    def __getitem__(self, item):
        return self.__dict__[item]
    def __getattr__(self, name):
        if (self._hx_disable_getattr):
            raise AttributeError('field does not exist')
        else:
            return None
    def _hx_hasattr(self,field):
        self._hx_disable_getattr = True
        try:
            getattr(self, field)
            self._hx_disable_getattr = False
            return True
        except AttributeError:
            self._hx_disable_getattr = False
            return False



_hx_classes = {}


class Enum:
    _hx_class_name = "Enum"
    __slots__ = ("tag", "index", "params")
    _hx_fields = ["tag", "index", "params"]
    _hx_methods = ["__str__"]

    def __init__(self,tag,index,params):
        self.tag = tag
        self.index = index
        self.params = params

    def __str__(self):
        if (self.params is None):
            return self.tag
        else:
            return self.tag + '(' + (', '.join(str(v) for v in self.params)) + ')'

Enum._hx_class = Enum
_hx_classes["Enum"] = Enum


class Build:
    _hx_class_name = "Build"
    __slots__ = ("isBuilded", "buildPlatform")
    _hx_fields = ["isBuilded", "buildPlatform"]
    _hx_methods = ["buildPlatformAssets", "buildHtml5", "action", "clearDir"]
    _hx_statics = ["currentBuild", "platforms", "run", "mainFileName", "clear", "buildIos", "buildAndroid", "buildHashlink", "buildElectron"]

    def __init__(self,args):
        self.buildPlatform = None
        self.isBuilded = False
        haxe_Log.trace(("BUILDING " + Std.string(args)),_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 48, 'className': "Build", 'methodName': "new"}))
        _this = (args[1] if 1 < len(args) else None)
        buildAgs = _this.split(":")
        Sys.setCwd((args[2] if 2 < len(args) else None))
        if (len(args) < 3):
            _this = Build.platforms
            raise haxe_Exception.thrown(("参数不足，请参考`haxelib run zygameui -build 平台`命令\n 已支持平台：" + HxOverrides.stringOrNull(" ".join([python_Boot.toString1(x1,'') for x1 in _this]))))
        if (python_internal_ArrayImpl.indexOf(Build.platforms,(buildAgs[0] if 0 < len(buildAgs) else None),None) == -1):
            _this = Build.platforms
            raise haxe_Exception.thrown((((("平台`" + HxOverrides.stringOrNull((args[1] if 1 < len(args) else None))) + "`无效，不存在于`") + HxOverrides.stringOrNull(" ".join([python_Boot.toString1(x1,'') for x1 in _this]))) + "`当中"))
        if (not sys_FileSystem.exists((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "zproject.xml"))):
            raise haxe_Exception.thrown("项目不存在有效的zproject.xml配置")
        target = ((buildAgs[1] if 1 < len(buildAgs) else None) if ((len(buildAgs) > 1)) else (buildAgs[0] if 0 < len(buildAgs) else None))
        xml = Xml.parse(sys_io_File.getContent((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "zproject.xml")))
        xml.firstElement().insertChild(Xml.parse((("<define name=\"" + HxOverrides.stringOrNull((("html5-platform" if ((target == "html5")) else target)))) + "\"/>")),0)
        xml.firstElement().insertChild(Xml.parse("<define name=\"zybuild\"/>"),0)
        sys_io_File.saveContent((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "project.xml"),haxe_xml_Printer.print(xml))
        dir = ((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/") + ("null" if target is None else target))
        if ((args[1] if 1 < len(args) else None) == "html5"):
            dir = (("null" if dir is None else dir) + "/bin")
        Defines.define("zybuild")
        Defines.define((args[1] if 1 < len(args) else None))
        self.action(xml.firstElement(),args,dir)
        c = (args[1] if 1 < len(args) else None)
        startIndex = None
        if (((c.find(":") if ((startIndex is None)) else HxString.indexOfImpl(c,":",startIndex))) != -1):
            startIndex1 = None
            _hx_len = None
            if (startIndex1 is None):
                _hx_len = c.rfind(":", 0, len(c))
            else:
                i = c.rfind(":", 0, (startIndex1 + 1))
                startLeft = (max(0,((startIndex1 + 1) - len(":"))) if ((i == -1)) else (i + 1))
                check = c.find(":", startLeft, len(c))
                _hx_len = (check if (((check > i) and ((check <= startIndex1)))) else i)
            c = HxString.substr(c,0,_hx_len)
        c1 = c
        _hx_local_1 = len(c1)
        if (_hx_local_1 == 7):
            if (c1 == "android"):
                self.buildPlatform = "android"
                Build.buildAndroid()
            else:
                self.buildPlatform = "html5"
                self.buildHtml5()
        elif (_hx_local_1 == 3):
            if (c1 == "ios"):
                self.buildPlatform = "ios"
                Build.buildIos()
            else:
                self.buildPlatform = "html5"
                self.buildHtml5()
        elif (_hx_local_1 == 8):
            if (c1 == "electron"):
                self.buildPlatform = "electron"
                Build.buildElectron()
            else:
                self.buildPlatform = "html5"
                self.buildHtml5()
        elif (_hx_local_1 == 2):
            if (c1 == "hl"):
                self.buildPlatform = "hl"
                Build.buildHashlink()
            else:
                self.buildPlatform = "html5"
                self.buildHtml5()
        else:
            self.buildPlatform = "html5"
            self.buildHtml5()
        self.buildPlatformAssets(args,dir)
        self.isBuilded = True
        self.action(xml.firstElement(),args,dir,True)
        if (Build.currentBuild is not None):
            Build.currentBuild.buildAfter()
        Build.clear(dir)
        haxe_Log.trace("\n\n -- 编译结束 --",_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 98, 'className': "Build", 'methodName': "new"}))

    def buildPlatformAssets(self,args,dir):
        if ((args[1] if 1 < len(args) else None) == "html5"):
            return
        haxe_Log.trace("开始编译平台资源",_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 119, 'className': "Build", 'methodName': "buildPlatformAssets"}))
        if (not sys_FileSystem.exists(dir)):
            sys_FileSystem.createDirectory(dir)
        if (Build.mainFileName is None):
            raise haxe_Exception.thrown("Build.mainFileName is NULL!")
        python_FileUtils.copyDic("Export/html5/bin/lib",dir)
        python_FileUtils.copyFile((((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/") + HxOverrides.stringOrNull(Build.mainFileName)) + ".js"),dir)
        platformName = (args[1] if 1 < len(args) else None)
        platformName = (HxOverrides.stringOrNull(HxString.substr(platformName,0,1).upper()) + HxOverrides.stringOrNull(HxString.substr(platformName,1,None).lower()))
        cls = Type.resolveClass(("platforms." + ("null" if platformName is None else platformName)))
        if (cls is not None):
            haxe_Log.trace((("RUN " + ("null" if platformName is None else platformName)) + " ACTION"),_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 132, 'className': "Build", 'methodName': "buildPlatformAssets"}))
            Build.currentBuild = cls(*[args, dir])
        else:
            haxe_Log.trace((("RUN " + ("null" if platformName is None else platformName)) + " FAIL"),_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 135, 'className': "Build", 'methodName': "buildPlatformAssets"}))

    def buildHtml5(self):
        haxe_Log.trace("开始编译HTML5",_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 209, 'className': "Build", 'methodName': "buildHtml5"}))
        args = Sys.args()
        code = 0
        if (python_internal_ArrayImpl.indexOf(args,"-final",None) != -1):
            code = Sys.command("lime build html5 -final")
        else:
            code = Sys.command("lime build html5")
        haxe_Log.trace(("BUILDED " + Std.string(code)),_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 216, 'className': "Build", 'methodName': "buildHtml5"}))
        if (code != 0):
            raise haxe_Exception.thrown("编译发生了错误！")

    def action(self,xml,args,dir,after = None):
        if (after is None):
            after = False
        item = xml.elements()
        while item.hasNext():
            item1 = item.next()
            if (not Defines.cheak(item1)):
                continue
            if (item1.nodeType != Xml.Element):
                raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((item1.nodeType is None)) else _Xml_XmlType_Impl_.toString(item1.nodeType))))))
            _g = item1.nodeName
            _hx_local_0 = len(_g)
            if (_hx_local_0 == 5):
                if (_g == "clear"):
                    if after:
                        path1 = ((("null" if dir is None else dir) + "/") + HxOverrides.stringOrNull(item1.get("path")))
                        igone = None
                        if item1.exists("igone"):
                            _this1 = item1.get("igone")
                            igone = _this1.split(",")
                        else:
                            igone = []
                        self.clearDir(path1,igone)
                elif (_g == "shell"):
                    code = 0
                    if (item1.get("after") == "true"):
                        if after:
                            code = Sys.command(item1.get("command"))
                    elif (not after):
                        code = Sys.command(item1.get("command"))
                    if ((code != 0) and ((item1.get("try") == "true"))):
                        raise haxe_Exception.thrown("编译失败！")
            elif (_hx_local_0 == 4):
                if (_g == "copy"):
                    if after:
                        path2 = ((("null" if dir is None else dir) + "/") + HxOverrides.stringOrNull(item1.get("rename")))
                        srcPath = item1.get("path")
                        haxe_Log.trace(((("copy " + ("null" if srcPath is None else srcPath)) + " to ") + ("null" if path2 is None else path2)),_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 231, 'className': "Build", 'methodName': "action"}))
                        if sys_FileSystem.isDirectory(srcPath):
                            python_FileUtils.copyDic(srcPath,path2)
                        else:
                            python_FileUtils.copyFile(srcPath,path2)
            elif (_hx_local_0 == 3):
                if (_g == "app"):
                    if (item1.exists("file") and Defines.cheak(item1)):
                        Build.mainFileName = item1.get("file")
            elif (_hx_local_0 == 7):
                if (_g == "include"):
                    xmlPath = item1.get("path")
                    xml = Xml.parse(sys_io_File.getContent(xmlPath))
                    haxe_Log.trace(("include xml parsing:" + ("null" if xmlPath is None else xmlPath)),_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 280, 'className': "Build", 'methodName': "action"}))
                    self.action(xml.firstElement(),args,dir,after)
            elif (_hx_local_0 == 6):
                if (_g == "assets"):
                    if ((((self.buildPlatform == "html5") and self.isBuilded) and ((Build.currentBuild is not None))) and item1.exists("cp")):
                        cp = None
                        if (item1.get("cp") is not None):
                            _this = item1.get("cp")
                            cp = _this.split(" ")
                        else:
                            cp = []
                        if ((python_internal_ArrayImpl.indexOf(cp,(args[1] if 1 < len(args) else None),None) != -1) or ((python_internal_ArrayImpl.indexOf(cp,"all",None) != -1))):
                            filepath = (item1.get("rename") if (item1.exists("rename")) else item1.get("path"))
                            path = ((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/") + ("null" if filepath is None else filepath))
                            haxe_Log.trace(("CP " + ("null" if path is None else path)),_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 268, 'className': "Build", 'methodName': "action", 'customParams': ["root=", Build.currentBuild.root]}))
                            if sys_FileSystem.isDirectory(path):
                                python_FileUtils.copyDic(path,(((("null" if dir is None else dir) + "/") + HxOverrides.stringOrNull(Build.currentBuild.root)) if ((Build.currentBuild.root is not None)) else dir))
                            else:
                                python_FileUtils.copyFile(path,(((((("null" if dir is None else dir) + "/") + HxOverrides.stringOrNull(Build.currentBuild.root)) + "/") + ("null" if filepath is None else filepath)) if ((Build.currentBuild.root is not None)) else ((("null" if dir is None else dir) + "/") + ("null" if filepath is None else filepath))))
                elif (_g == "define"):
                    if (not after):
                        Defines.define(item1.get("name"),item1.get("value"))
            else:
                pass
            self.action(item1,args,dir,after)

    def clearDir(self,dir,igone):
        if (sys_FileSystem.exists(dir) == False):
            return
        if (sys_FileSystem.isDirectory(dir) == False):
            sys_FileSystem.deleteFile(dir)
            return
        files = sys_FileSystem.readDirectory(dir)
        _g = 0
        while (_g < len(files)):
            file = (files[_g] if _g >= 0 and _g < len(files) else None)
            _g = (_g + 1)
            if sys_FileSystem.isDirectory(((("null" if dir is None else dir) + "/") + ("null" if file is None else file))):
                self.clearDir(((("null" if dir is None else dir) + "/") + ("null" if file is None else file)),igone)
            else:
                isClear = True
                _g1 = 0
                while (_g1 < len(igone)):
                    item = (igone[_g1] if _g1 >= 0 and _g1 < len(igone) else None)
                    _g1 = (_g1 + 1)
                    _this = ((("null" if dir is None else dir) + "/") + ("null" if file is None else file))
                    startIndex = None
                    if (((_this.find(item) if ((startIndex is None)) else HxString.indexOfImpl(_this,item,startIndex))) != -1):
                        isClear = False
                if isClear:
                    sys_FileSystem.deleteFile(((("null" if dir is None else dir) + "/") + ("null" if file is None else file)))
        if (len(sys_FileSystem.readDirectory(dir)) == 0):
            sys_FileSystem.deleteDirectory(dir)
    currentBuild = None

    @staticmethod
    def run(args):
        Build(args)

    @staticmethod
    def clear(dir):
        if sys_FileSystem.isDirectory(dir):
            dirs = sys_FileSystem.readDirectory(dir)
            _g = 0
            while (_g < len(dirs)):
                d = (dirs[_g] if _g >= 0 and _g < len(dirs) else None)
                _g = (_g + 1)
                Build.clear(((("null" if dir is None else dir) + "/") + ("null" if d is None else d)))
        else:
            startIndex = None
            if (((dir.find("._") if ((startIndex is None)) else HxString.indexOfImpl(dir,"._",startIndex))) != -1):
                haxe_Log.trace("删除",_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 108, 'className': "Build", 'methodName': "clear", 'customParams': [dir]}))
                sys_FileSystem.deleteFile(dir)

    @staticmethod
    def buildIos():
        haxe_Log.trace("开始编译IOS",_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 143, 'className': "Build", 'methodName': "buildIos"}))
        if sys_FileSystem.exists("Export/ios"):
            sys_FileSystem.rename("Export/ios","Export/ios_temp")
        args = Sys.args()
        if (python_internal_ArrayImpl.indexOf(args,"-debug",None) != -1):
            Sys.command("lime build ios -debug")
        else:
            Sys.command("lime build ios")
        if sys_FileSystem.exists("Export/ios_temp"):
            sys_FileSystem.rename("Export/ios","Export/ios_temp1")
            sys_FileSystem.rename("Export/ios_temp","Export/ios")
            python_FileUtils.copyDic((("Export/ios_temp1/" + HxOverrides.stringOrNull(Build.mainFileName)) + "/assets"),("Export/ios/" + HxOverrides.stringOrNull(Build.mainFileName)))
            python_FileUtils.copyDic((("Export/ios_temp1/" + HxOverrides.stringOrNull(Build.mainFileName)) + "/haxe"),("Export/ios/" + HxOverrides.stringOrNull(Build.mainFileName)))
            python_FileUtils.copyDic((("Export/ios_temp1/" + HxOverrides.stringOrNull(Build.mainFileName)) + "/Images.xcassets"),("Export/ios/" + HxOverrides.stringOrNull(Build.mainFileName)))
            python_FileUtils.removeDic("Export/ios_temp1")

    @staticmethod
    def buildAndroid():
        haxe_Log.trace("开始编译ANDROID",_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 171, 'className': "Build", 'methodName': "buildAndroid"}))
        args = Sys.args()
        if (python_internal_ArrayImpl.indexOf(args,"-final",None) != -1):
            Sys.command("lime build android -final")
        elif (python_internal_ArrayImpl.indexOf(args,"-debug",None) != -1):
            Sys.command("lime build android -debug")
        else:
            Sys.command("lime build android")

    @staticmethod
    def buildHashlink():
        haxe_Log.trace("开始编译HashLink",_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 185, 'className': "Build", 'methodName': "buildHashlink"}))
        args = Sys.args()
        if (python_internal_ArrayImpl.indexOf(args,"-debug",None) != -1):
            Sys.command("lime build hl -debug")
        else:
            Sys.command("lime build hl")

    @staticmethod
    def buildElectron():
        haxe_Log.trace("开始编译Electron",_hx_AnonObject({'fileName': "src/Build.hx", 'lineNumber': 197, 'className': "Build", 'methodName': "buildElectron"}))
        args = Sys.args()
        if (python_internal_ArrayImpl.indexOf(args,"-final",None) != -1):
            Sys.command("lime build electron -final")
        else:
            Sys.command("lime build electron")

Build._hx_class = Build
_hx_classes["Build"] = Build


class Class: pass


class Date:
    _hx_class_name = "Date"
    __slots__ = ("date", "dateUTC")
    _hx_fields = ["date", "dateUTC"]
    _hx_methods = ["toString"]
    _hx_statics = ["makeLocal"]

    def __init__(self,year,month,day,hour,_hx_min,sec):
        self.dateUTC = None
        if (year < python_lib_datetime_Datetime.min.year):
            year = python_lib_datetime_Datetime.min.year
        if (day == 0):
            day = 1
        self.date = Date.makeLocal(python_lib_datetime_Datetime(year,(month + 1),day,hour,_hx_min,sec,0))
        self.dateUTC = self.date.astimezone(python_lib_datetime_Timezone.utc)

    def toString(self):
        return self.date.strftime("%Y-%m-%d %H:%M:%S")

    @staticmethod
    def makeLocal(date):
        try:
            return date.astimezone()
        except BaseException as _g:
            tzinfo = python_lib_datetime_Datetime.now(python_lib_datetime_Timezone.utc).astimezone().tzinfo
            return date.replace(**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'tzinfo': tzinfo})))

Date._hx_class = Date
_hx_classes["Date"] = Date


class haxe_IMap:
    _hx_class_name = "haxe.IMap"
    __slots__ = ()
haxe_IMap._hx_class = haxe_IMap
_hx_classes["haxe.IMap"] = haxe_IMap


class haxe_ds_StringMap:
    _hx_class_name = "haxe.ds.StringMap"
    __slots__ = ("h",)
    _hx_fields = ["h"]
    _hx_methods = ["keys"]
    _hx_interfaces = [haxe_IMap]

    def __init__(self):
        self.h = dict()

    def keys(self):
        return python_HaxeIterator(iter(self.h.keys()))

haxe_ds_StringMap._hx_class = haxe_ds_StringMap
_hx_classes["haxe.ds.StringMap"] = haxe_ds_StringMap


class Defines:
    _hx_class_name = "Defines"
    __slots__ = ()
    _hx_statics = ["defineMaps", "define", "isDefine", "cheak", "cheakDefineAnd", "cheakDefineOr"]

    @staticmethod
    def define(name,value = None):
        haxe_Log.trace(((("Define " + ("null" if name is None else name)) + "=") + ("null" if value is None else value)),_hx_AnonObject({'fileName': "src/Defines.hx", 'lineNumber': 8, 'className': "Defines", 'methodName': "define"}))
        Defines.defineMaps.h[name] = value

    @staticmethod
    def isDefine(name):
        return (name in Defines.defineMaps.h)

    @staticmethod
    def cheak(item):
        if (item.nodeType != Xml.Element):
            raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((item.nodeType is None)) else _Xml_XmlType_Impl_.toString(item.nodeType))))))
        if (item.nodeName == "assets"):
            return True
        result = (False if ((item.exists("if") or item.exists("unless"))) else True)
        if item.exists("if"):
            data = item.get("if")
            startIndex = None
            if (((data.find("||") if ((startIndex is None)) else HxString.indexOfImpl(data,"||",startIndex))) != -1):
                if Defines.cheakDefineOr(item.get("if")):
                    result = True
            elif Defines.cheakDefineAnd(item.get("if")):
                result = True
        if ((result == False) and item.exists("unless")):
            if (not Defines.cheakDefineOr(item.get("unless"))):
                result = True
        return result

    @staticmethod
    def cheakDefineAnd(data):
        array = data.split(" ")
        _g = 0
        while (_g < len(array)):
            s = (array[_g] if _g >= 0 and _g < len(array) else None)
            _g = (_g + 1)
            if (s == "||"):
                continue
            if (not (s in Defines.defineMaps.h)):
                return False
        return True

    @staticmethod
    def cheakDefineOr(data):
        array = data.split(" ")
        _g = 0
        while (_g < len(array)):
            s = (array[_g] if _g >= 0 and _g < len(array) else None)
            _g = (_g + 1)
            if (s in Defines.defineMaps.h):
                return True
        return False
Defines._hx_class = Defines
_hx_classes["Defines"] = Defines


class EReg:
    _hx_class_name = "EReg"
    __slots__ = ("pattern", "matchObj", "_hx_global")
    _hx_fields = ["pattern", "matchObj", "global"]
    _hx_methods = ["replace"]

    def __init__(self,r,opt):
        self.matchObj = None
        self._hx_global = False
        options = 0
        _g = 0
        _g1 = len(opt)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = (-1 if ((i >= len(opt))) else ord(opt[i]))
            if (c == 109):
                options = (options | python_lib_Re.M)
            if (c == 105):
                options = (options | python_lib_Re.I)
            if (c == 115):
                options = (options | python_lib_Re.S)
            if (c == 117):
                options = (options | python_lib_Re.U)
            if (c == 103):
                self._hx_global = True
        self.pattern = python_lib_Re.compile(r,options)

    def replace(self,s,by):
        _this = by.split("$$")
        by = "_hx_#repl#__".join([python_Boot.toString1(x1,'') for x1 in _this])
        def _hx_local_0(x):
            res = by
            g = x.groups()
            _g = 0
            _g1 = len(g)
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                gs = g[i]
                if (gs is None):
                    continue
                delimiter = ("$" + HxOverrides.stringOrNull(str((i + 1))))
                _this = (list(res) if ((delimiter == "")) else res.split(delimiter))
                res = gs.join([python_Boot.toString1(x1,'') for x1 in _this])
            _this = res.split("_hx_#repl#__")
            res = "$".join([python_Boot.toString1(x1,'') for x1 in _this])
            return res
        replace = _hx_local_0
        return python_lib_Re.sub(self.pattern,replace,s,(0 if (self._hx_global) else 1))

EReg._hx_class = EReg
_hx_classes["EReg"] = EReg


class Lambda:
    _hx_class_name = "Lambda"
    __slots__ = ()
    _hx_statics = ["exists"]

    @staticmethod
    def exists(it,f):
        x = HxOverrides.iterator(it)
        while x.hasNext():
            x1 = x.next()
            if f(x1):
                return True
        return False
Lambda._hx_class = Lambda
_hx_classes["Lambda"] = Lambda


class Reflect:
    _hx_class_name = "Reflect"
    __slots__ = ()
    _hx_statics = ["field", "setField", "setProperty", "isFunction", "compareMethods"]

    @staticmethod
    def field(o,field):
        return python_Boot.field(o,field)

    @staticmethod
    def setField(o,field,value):
        setattr(o,(("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field)),value)

    @staticmethod
    def setProperty(o,field,value):
        field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
        if isinstance(o,_hx_AnonObject):
            setattr(o,field1,value)
        elif hasattr(o,("set_" + ("null" if field1 is None else field1))):
            getattr(o,("set_" + ("null" if field1 is None else field1)))(value)
        else:
            setattr(o,field1,value)

    @staticmethod
    def isFunction(f):
        if (not ((python_lib_Inspect.isfunction(f) or python_lib_Inspect.ismethod(f)))):
            return python_Boot.hasField(f,"func_code")
        else:
            return True

    @staticmethod
    def compareMethods(f1,f2):
        if HxOverrides.eq(f1,f2):
            return True
        if (isinstance(f1,python_internal_MethodClosure) and isinstance(f2,python_internal_MethodClosure)):
            m1 = f1
            m2 = f2
            if HxOverrides.eq(m1.obj,m2.obj):
                return (m1.func == m2.func)
            else:
                return False
        if ((not Reflect.isFunction(f1)) or (not Reflect.isFunction(f2))):
            return False
        return False
Reflect._hx_class = Reflect
_hx_classes["Reflect"] = Reflect


class Std:
    _hx_class_name = "Std"
    __slots__ = ()
    _hx_statics = ["isOfType", "string", "parseInt"]

    @staticmethod
    def isOfType(v,t):
        if ((v is None) and ((t is None))):
            return False
        if (t is None):
            return False
        if (t == Dynamic):
            return (v is not None)
        isBool = isinstance(v,bool)
        if ((t == Bool) and isBool):
            return True
        if ((((not isBool) and (not (t == Bool))) and (t == Int)) and isinstance(v,int)):
            return True
        vIsFloat = isinstance(v,float)
        tmp = None
        tmp1 = None
        if (((not isBool) and vIsFloat) and (t == Int)):
            f = v
            tmp1 = (((f != Math.POSITIVE_INFINITY) and ((f != Math.NEGATIVE_INFINITY))) and (not python_lib_Math.isnan(f)))
        else:
            tmp1 = False
        if tmp1:
            tmp1 = None
            try:
                tmp1 = int(v)
            except BaseException as _g:
                tmp1 = None
            tmp = (v == tmp1)
        else:
            tmp = False
        if ((tmp and ((v <= 2147483647))) and ((v >= -2147483648))):
            return True
        if (((not isBool) and (t == Float)) and isinstance(v,(float, int))):
            return True
        if (t == str):
            return isinstance(v,str)
        isEnumType = (t == Enum)
        if ((isEnumType and python_lib_Inspect.isclass(v)) and hasattr(v,"_hx_constructs")):
            return True
        if isEnumType:
            return False
        isClassType = (t == Class)
        if ((((isClassType and (not isinstance(v,Enum))) and python_lib_Inspect.isclass(v)) and hasattr(v,"_hx_class_name")) and (not hasattr(v,"_hx_constructs"))):
            return True
        if isClassType:
            return False
        tmp = None
        try:
            tmp = isinstance(v,t)
        except BaseException as _g:
            tmp = False
        if tmp:
            return True
        if python_lib_Inspect.isclass(t):
            cls = t
            loop = None
            def _hx_local_1(intf):
                f = (intf._hx_interfaces if (hasattr(intf,"_hx_interfaces")) else [])
                if (f is not None):
                    _g = 0
                    while (_g < len(f)):
                        i = (f[_g] if _g >= 0 and _g < len(f) else None)
                        _g = (_g + 1)
                        if (i == cls):
                            return True
                        else:
                            l = loop(i)
                            if l:
                                return True
                    return False
                else:
                    return False
            loop = _hx_local_1
            currentClass = v.__class__
            result = False
            while (currentClass is not None):
                if loop(currentClass):
                    result = True
                    break
                currentClass = python_Boot.getSuperClass(currentClass)
            return result
        else:
            return False

    @staticmethod
    def string(s):
        return python_Boot.toString1(s,"")

    @staticmethod
    def parseInt(x):
        if (x is None):
            return None
        try:
            return int(x)
        except BaseException as _g:
            base = 10
            _hx_len = len(x)
            foundCount = 0
            sign = 0
            firstDigitIndex = 0
            lastDigitIndex = -1
            previous = 0
            _g = 0
            _g1 = _hx_len
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                c = (-1 if ((i >= len(x))) else ord(x[i]))
                if (((c > 8) and ((c < 14))) or ((c == 32))):
                    if (foundCount > 0):
                        return None
                    continue
                else:
                    c1 = c
                    if (c1 == 43):
                        if (foundCount == 0):
                            sign = 1
                        elif (not (((48 <= c) and ((c <= 57))))):
                            if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                break
                    elif (c1 == 45):
                        if (foundCount == 0):
                            sign = -1
                        elif (not (((48 <= c) and ((c <= 57))))):
                            if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                break
                    elif (c1 == 48):
                        if (not (((foundCount == 0) or (((foundCount == 1) and ((sign != 0))))))):
                            if (not (((48 <= c) and ((c <= 57))))):
                                if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                    break
                    elif ((c1 == 120) or ((c1 == 88))):
                        if ((previous == 48) and ((((foundCount == 1) and ((sign == 0))) or (((foundCount == 2) and ((sign != 0))))))):
                            base = 16
                        elif (not (((48 <= c) and ((c <= 57))))):
                            if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                                break
                    elif (not (((48 <= c) and ((c <= 57))))):
                        if (not (((base == 16) and ((((97 <= c) and ((c <= 122))) or (((65 <= c) and ((c <= 90))))))))):
                            break
                if (((foundCount == 0) and ((sign == 0))) or (((foundCount == 1) and ((sign != 0))))):
                    firstDigitIndex = i
                foundCount = (foundCount + 1)
                lastDigitIndex = i
                previous = c
            if (firstDigitIndex <= lastDigitIndex):
                digits = HxString.substring(x,firstDigitIndex,(lastDigitIndex + 1))
                try:
                    return (((-1 if ((sign == -1)) else 1)) * int(digits,base))
                except BaseException as _g:
                    return None
            return None
Std._hx_class = Std
_hx_classes["Std"] = Std


class Float: pass


class Int: pass


class Bool: pass


class Dynamic: pass


class StringBuf:
    _hx_class_name = "StringBuf"
    __slots__ = ("b",)
    _hx_fields = ["b"]
    _hx_methods = ["get_length"]

    def __init__(self):
        self.b = python_lib_io_StringIO()

    def get_length(self):
        pos = self.b.tell()
        self.b.seek(0,2)
        _hx_len = self.b.tell()
        self.b.seek(pos,0)
        return _hx_len

StringBuf._hx_class = StringBuf
_hx_classes["StringBuf"] = StringBuf


class StringTools:
    _hx_class_name = "StringTools"
    __slots__ = ()
    _hx_statics = ["htmlEscape", "isSpace", "ltrim", "rtrim", "trim", "lpad", "replace"]

    @staticmethod
    def htmlEscape(s,quotes = None):
        buf_b = python_lib_io_StringIO()
        _g_offset = 0
        _g_s = s
        while (_g_offset < len(_g_s)):
            index = _g_offset
            _g_offset = (_g_offset + 1)
            code = ord(_g_s[index])
            code1 = code
            if (code1 == 34):
                if quotes:
                    buf_b.write("&quot;")
                else:
                    buf_b.write("".join(map(chr,[code])))
            elif (code1 == 38):
                buf_b.write("&amp;")
            elif (code1 == 39):
                if quotes:
                    buf_b.write("&#039;")
                else:
                    buf_b.write("".join(map(chr,[code])))
            elif (code1 == 60):
                buf_b.write("&lt;")
            elif (code1 == 62):
                buf_b.write("&gt;")
            else:
                buf_b.write("".join(map(chr,[code])))
        return buf_b.getvalue()

    @staticmethod
    def isSpace(s,pos):
        if (((len(s) == 0) or ((pos < 0))) or ((pos >= len(s)))):
            return False
        c = HxString.charCodeAt(s,pos)
        if (not (((c > 8) and ((c < 14))))):
            return (c == 32)
        else:
            return True

    @staticmethod
    def ltrim(s):
        l = len(s)
        r = 0
        while ((r < l) and StringTools.isSpace(s,r)):
            r = (r + 1)
        if (r > 0):
            return HxString.substr(s,r,(l - r))
        else:
            return s

    @staticmethod
    def rtrim(s):
        l = len(s)
        r = 0
        while ((r < l) and StringTools.isSpace(s,((l - r) - 1))):
            r = (r + 1)
        if (r > 0):
            return HxString.substr(s,0,(l - r))
        else:
            return s

    @staticmethod
    def trim(s):
        return StringTools.ltrim(StringTools.rtrim(s))

    @staticmethod
    def lpad(s,c,l):
        if (len(c) <= 0):
            return s
        buf = StringBuf()
        l = (l - len(s))
        while (buf.get_length() < l):
            s1 = Std.string(c)
            buf.b.write(s1)
        s1 = Std.string(s)
        buf.b.write(s1)
        return buf.b.getvalue()

    @staticmethod
    def replace(s,sub,by):
        _this = (list(s) if ((sub == "")) else s.split(sub))
        return by.join([python_Boot.toString1(x1,'') for x1 in _this])
StringTools._hx_class = StringTools
_hx_classes["StringTools"] = StringTools


class sys_FileSystem:
    _hx_class_name = "sys.FileSystem"
    __slots__ = ()
    _hx_statics = ["exists", "rename", "absolutePath", "isDirectory", "createDirectory", "deleteFile", "deleteDirectory", "readDirectory"]

    @staticmethod
    def exists(path):
        return python_lib_os_Path.exists(path)

    @staticmethod
    def rename(path,newPath):
        python_lib_Os.rename(path,newPath)

    @staticmethod
    def absolutePath(relPath):
        if haxe_io_Path.isAbsolute(relPath):
            return relPath
        return haxe_io_Path.join([Sys.getCwd(), relPath])

    @staticmethod
    def isDirectory(path):
        return python_lib_os_Path.isdir(path)

    @staticmethod
    def createDirectory(path):
        python_lib_Os.makedirs(path,511,True)

    @staticmethod
    def deleteFile(path):
        python_lib_Os.remove(path)

    @staticmethod
    def deleteDirectory(path):
        python_lib_Os.rmdir(path)

    @staticmethod
    def readDirectory(path):
        return python_lib_Os.listdir(path)
sys_FileSystem._hx_class = sys_FileSystem
_hx_classes["sys.FileSystem"] = sys_FileSystem


class Sys:
    _hx_class_name = "Sys"
    __slots__ = ()
    _hx_statics = ["args", "getCwd", "setCwd", "systemName", "command"]

    @staticmethod
    def args():
        argv = python_lib_Sys.argv
        return argv[1:None]

    @staticmethod
    def getCwd():
        return python_lib_Os.getcwd()

    @staticmethod
    def setCwd(s):
        python_lib_Os.chdir(s)

    @staticmethod
    def systemName():
        _g = python_lib_Sys.platform
        x = _g
        if x.startswith("linux"):
            return "Linux"
        else:
            _g1 = _g
            _hx_local_0 = len(_g1)
            if (_hx_local_0 == 5):
                if (_g1 == "win32"):
                    return "Windows"
                else:
                    raise haxe_Exception.thrown("not supported platform")
            elif (_hx_local_0 == 6):
                if (_g1 == "cygwin"):
                    return "Windows"
                elif (_g1 == "darwin"):
                    return "Mac"
                else:
                    raise haxe_Exception.thrown("not supported platform")
            else:
                raise haxe_Exception.thrown("not supported platform")

    @staticmethod
    def command(cmd,args = None):
        if (args is None):
            return python_lib_Subprocess.call(cmd,**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'shell': True})))
        else:
            return python_lib_Subprocess.call(([cmd] + args))
Sys._hx_class = Sys
_hx_classes["Sys"] = Sys


class Tools:
    _hx_class_name = "Tools"
    __slots__ = ()
    _hx_statics = ["authorizationMaps", "webPath", "haxelib", "version", "main", "showLibs", "updateLib", "updatedev", "uploadlib", "uploadOSS"]
    webPath = None

    @staticmethod
    def main():
        Tools.haxelib = (("/Users/" + HxOverrides.stringOrNull(python_GetPass.getuser())) + "/.haxelib")
        if sys_FileSystem.exists(Tools.haxelib):
            Tools.haxelib = sys_io_File.getContent(Tools.haxelib)
            Tools.haxelib = StringTools.replace(Tools.haxelib," ","")
        else:
            Tools.haxelib = sys_FileSystem.absolutePath("")
            _this = Tools.haxelib
            _this1 = Tools.haxelib
            startIndex1 = None
            _hx_len = None
            if (startIndex1 is None):
                _hx_len = _this1.rfind("/zygameui", 0, len(_this1))
            else:
                i = _this1.rfind("/zygameui", 0, (startIndex1 + 1))
                startLeft = (max(0,((startIndex1 + 1) - len("/zygameui"))) if ((i == -1)) else (i + 1))
                check = _this1.find("/zygameui", startLeft, len(_this1))
                _hx_len = (check if (((check > i) and ((check <= startIndex1)))) else i)
            Tools.haxelib = HxString.substr(_this,0,_hx_len)
        authorization = None
        if sys_FileSystem.exists((HxOverrides.stringOrNull(Tools.haxelib) + "/zygameui/.dev")):
            authorization = sys_io_File.getContent((HxOverrides.stringOrNull(Tools.haxelib) + "/zygameui/.dev"))
        elif sys_FileSystem.exists((HxOverrides.stringOrNull(Tools.haxelib) + "/zygameui/.current")):
            authorization = sys_io_File.getContent((HxOverrides.stringOrNull(Tools.haxelib) + "/zygameui/.current"))
            authorization = StringTools.replace(authorization,".",",")
            authorization = ((HxOverrides.stringOrNull(Tools.haxelib) + "/zygameui/") + ("null" if authorization is None else authorization))
        if sys_FileSystem.exists((("null" if authorization is None else authorization) + "/authorization")):
            authorization = sys_io_File.getContent((("null" if authorization is None else authorization) + "/authorization"))
            authorizationData = authorization.split("\n")
            _g = 0
            while (_g < len(authorizationData)):
                s = (authorizationData[_g] if _g >= 0 and _g < len(authorizationData) else None)
                _g = (_g + 1)
                arr = s.split("=")
                v = (arr[1] if 1 < len(arr) else None)
                Tools.authorizationMaps.h[(arr[0] if 0 < len(arr) else None)] = v
        Tools.webPath = Tools.authorizationMaps.h.get("haxelib",None)
        haxe_Log.trace("authorization=",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 51, 'className': "Tools", 'methodName': "main", 'customParams': [authorization]}))
        haxe_Log.trace(("haxelib:" + HxOverrides.stringOrNull(Tools.haxelib)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 52, 'className': "Tools", 'methodName': "main"}))
        haxe_Log.trace(("args:" + Std.string(Sys.args())),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 53, 'className': "Tools", 'methodName': "main"}))
        args = Sys.args()
        if (len(args) == 1):
            haxe_Log.trace(("version:" + HxOverrides.stringOrNull(Tools.version)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 56, 'className': "Tools", 'methodName': "main"}))
            haxe_Log.trace("帮助列表：\n            -inittask 初始化VSCODE的task.json文件\n            -build 用于生成不同平台命令（通用）\n            -upload 库名 秘钥 :用于上传相关的库到自开发库中（需要得到授权才能够更新到自开发库）\n            -updatedev 库名 :用于下载线上最新的版本到haxelib开发版本中（需要得到授权才能够更新到自开发库）\n            -updatelib :用于更新所有的自有开发库（需要得到授权才能够更新到自开发库）\n            -libs :显示所有库版本情况（需要得到授权）",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 57, 'className': "Tools", 'methodName': "main"}))
            return
        command = (args[0] if 0 < len(args) else None)
        command1 = command
        _hx_local_1 = len(command1)
        if (_hx_local_1 == 10):
            if (command1 == "-updatedev"):
                Tools.updatedev()
            elif (command1 == "-updatelib"):
                Tools.updateLib()
        elif (_hx_local_1 == 11):
            if (command1 == "-miniengine"):
                mini_MiniEngineBuild.build((args[1] if 1 < len(args) else None))
            elif (command1 == "-updatehxml"):
                hxml_UpdateHxml.update((args[1] if 1 < len(args) else None))
        elif (_hx_local_1 == 9):
            if (command1 == "-inittask"):
                task_Tasks.initTask()
        elif (_hx_local_1 == 4):
            if (command1 == "-atf"):
                atf_AtfBuild.build((args[1] if 1 < len(args) else None),(args[2] if 2 < len(args) else None))
            elif (command1 == "-ogg"):
                haxe_Log.trace("Mp3 to Ogg...",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 100, 'className': "Tools", 'methodName': "main", 'customParams': [Sys.getCwd()]}))
                Sys.command("node",[(HxOverrides.stringOrNull(Sys.getCwd()) + "/tools/run/mp3toogg.js"), (args[1] if 1 < len(args) else None)])
            elif (command1 == "-pkg"):
                pkg_PkgTools.build()
            elif (command1 == "-xls"):
                xls_XlsBuild.build((HxOverrides.stringOrNull((args[3] if 3 < len(args) else None)) + HxOverrides.stringOrNull((args[1] if 1 < len(args) else None))),(HxOverrides.stringOrNull((args[3] if 3 < len(args) else None)) + HxOverrides.stringOrNull((args[2] if 2 < len(args) else None))))
        elif (_hx_local_1 == 5):
            if (command1 == "-libs"):
                Tools.showLibs()
        elif (_hx_local_1 == 7):
            if (command1 == "-upload"):
                Tools.uploadlib()
        elif (_hx_local_1 == 6):
            if (command1 == "-atlas"):
                atlasxml_AtlasTools.removeXmlItem((args[1] if 1 < len(args) else None))
            elif (command1 == "-build"):
                Build.run(args)
            elif (command1 == "-debug"):
                Build.run(args)
            elif (command1 == "-final"):
                Build.run(args)
        else:
            pass

    @staticmethod
    def showLibs():
        onlineVersion = sys_Http.requestUrl(((HxOverrides.stringOrNull(Tools.webPath) + "haxelib/version.json?") + Std.string(python_lib_Random.random())))
        haxe_Log.trace("\n版本库：",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 107, 'className': "Tools", 'methodName': "showLibs"}))
        arr = onlineVersion.split("\n")
        _g = 0
        while (_g < len(arr)):
            lib = (arr[_g] if _g >= 0 and _g < len(arr) else None)
            _g = (_g + 1)
            a = lib.split(":")
            if (len(a) == 2):
                projectName = (a[0] if 0 < len(a) else None)
                if sys_FileSystem.exists(((HxOverrides.stringOrNull(Tools.haxelib) + "/") + ("null" if projectName is None else projectName))):
                    if sys_FileSystem.exists((((HxOverrides.stringOrNull(Tools.haxelib) + "/") + ("null" if projectName is None else projectName)) + "/.current")):
                        haxe_Log.trace(((("null" if lib is None else lib) + "  now:") + HxOverrides.stringOrNull(sys_io_File.getContent((((HxOverrides.stringOrNull(Tools.haxelib) + "/") + ("null" if projectName is None else projectName)) + "/.current")))),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 115, 'className': "Tools", 'methodName': "showLibs"}))
                    elif sys_FileSystem.exists((((HxOverrides.stringOrNull(Tools.haxelib) + "/") + ("null" if projectName is None else projectName)) + "/.dev")):
                        haxe_Log.trace((("null" if lib is None else lib) + "  now:开发版本"),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 117, 'className': "Tools", 'methodName': "showLibs"}))
                    else:
                        haxe_Log.trace((("null" if lib is None else lib) + "  now:库已损坏"),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 119, 'className': "Tools", 'methodName': "showLibs"}))
                else:
                    haxe_Log.trace((("null" if lib is None else lib) + "  now:库不存在"),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 122, 'className': "Tools", 'methodName': "showLibs"}))

    @staticmethod
    def updateLib():
        x = (python_lib_Random.random() * 99999)
        random = None
        try:
            random = int(x)
        except BaseException as _g:
            None
            random = None
        downloadPath = Tools.webPath
        haxe_Log.trace(((("开始更新库:" + ("null" if downloadPath is None else downloadPath)) + "haxelib/version.json?version=") + Std.string(random)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 134, 'className': "Tools", 'methodName': "updateLib"}))
        versionData = sys_Http.requestUrl(((("null" if downloadPath is None else downloadPath) + "haxelib/version.json?version=") + Std.string(random)))
        versoins = versionData.split("\n")
        haxe_Log.trace(versoins,_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 137, 'className': "Tools", 'methodName': "updateLib"}))
        userName = python_GetPass.getuser()
        haxelibConfigPath = (("/Users/" + ("null" if userName is None else userName)) + "/.haxelib")
        haxe_Log.trace(("haxelibConfigPath=" + ("null" if haxelibConfigPath is None else haxelibConfigPath)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 142, 'className': "Tools", 'methodName': "updateLib"}))
        haxelibPath = Tools.haxelib
        if (Sys.systemName() == "Mac"):
            haxelibPath = sys_io_File.getContent(haxelibConfigPath)
        haxelibPath = StringTools.replace(haxelibPath," ","")
        haxe_Log.trace(("haxelibPath=" + ("null" if haxelibPath is None else haxelibPath)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 147, 'className': "Tools", 'methodName': "updateLib"}))
        _g = 0
        while (_g < len(versoins)):
            version = (versoins[_g] if _g >= 0 and _g < len(versoins) else None)
            _g = (_g + 1)
            isUpdate = False
            arr = [version.split(":")]
            cheakVersionPath = (((("null" if haxelibPath is None else haxelibPath) + "/") + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 0))) + "/.current")
            cheakDevPath = (((("null" if haxelibPath is None else haxelibPath) + "/") + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 0))) + "/.dev")
            haxe_Log.trace(("检查库：" + Std.string((arr[0] if 0 < len(arr) else None))),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 153, 'className': "Tools", 'methodName': "updateLib"}))
            if (len((arr[0] if 0 < len(arr) else None)) != 2):
                continue
            if sys_FileSystem.exists(cheakVersionPath):
                curVersion = sys_io_File.getContent(cheakVersionPath)
                haxe_Log.trace(("curVersion:" + ("null" if curVersion is None else curVersion)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 158, 'className': "Tools", 'methodName': "updateLib"}))
                haxe_Log.trace(("newVersion:" + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 1))),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 159, 'className': "Tools", 'methodName': "updateLib"}))
                tmp = None
                if (curVersion != python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 1)):
                    _this = curVersion.split(".")
                    tmp1 = Std.parseInt("".join([python_Boot.toString1(x1,'') for x1 in _this]))
                    _this1 = python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 1)
                    _this2 = _this1.split(".")
                    tmp = (tmp1 < Std.parseInt("".join([python_Boot.toString1(x1,'') for x1 in _this2])))
                else:
                    tmp = False
                if tmp:
                    haxe_Log.trace("版本有更新，开始下载",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 161, 'className': "Tools", 'methodName': "updateLib"}))
                    isUpdate = True
                else:
                    haxe_Log.trace("已是最新无需更新",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 164, 'className': "Tools", 'methodName': "updateLib"}))
            elif sys_FileSystem.exists(cheakDevPath):
                haxe_Log.trace(("newVersion:" + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 1))),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 167, 'className': "Tools", 'methodName': "updateLib"}))
                haxe_Log.trace("该库为开发库",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 168, 'className': "Tools", 'methodName': "updateLib"}))
            else:
                haxe_Log.trace("库不存在，开始下载",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 170, 'className': "Tools", 'methodName': "updateLib"}))
                isUpdate = True
            if isUpdate:
                haxe_Log.trace((((((((("null" if downloadPath is None else downloadPath) + "haxelib/") + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 0))) + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 1))) + ".zip") + " -> ") + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 0))) + ".zip"),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 176, 'className': "Tools", 'methodName': "updateLib"}))
                downloadZip = ((((("null" if downloadPath is None else downloadPath) + "haxelib/") + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 0))) + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 1))) + ".zip")
                saveZip = [(HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 0)) + ".zip")]
                http = sys_Http(downloadZip)
                def _hx_local_2(saveZip,arr):
                    def _hx_local_1(data):
                        sys_io_File.saveBytes((saveZip[0] if 0 < len(saveZip) else None),data)
                        Sys.command((("haxelib install " + HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 0))) + ".zip"))
                        sys_FileSystem.deleteFile((HxOverrides.stringOrNull(python_internal_ArrayImpl._get((arr[0] if 0 < len(arr) else None), 0)) + ".zip"))
                    return _hx_local_1
                http.onBytes = _hx_local_2(saveZip,arr)
                http.request()

    @staticmethod
    def updatedev():
        args = Sys.args()
        projectName = (args[1] if 1 < len(args) else None)
        haxe_Log.trace(("正在更新库：" + ("null" if projectName is None else projectName)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 198, 'className': "Tools", 'methodName': "updatedev"}))
        if sys_FileSystem.exists((((HxOverrides.stringOrNull(Tools.haxelib) + "/") + ("null" if projectName is None else projectName)) + "/.dev")):
            onlineVersion = sys_Http.requestUrl(((HxOverrides.stringOrNull(Tools.webPath) + "haxelib/version.json?") + Std.string(python_lib_Random.random())))
            libs = onlineVersion.split("\n")
            _g = 0
            _g1 = len(libs)
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                lib = (libs[i] if i >= 0 and i < len(libs) else None)
                startIndex = None
                if (((lib.find(projectName) if ((startIndex is None)) else HxString.indexOfImpl(lib,projectName,startIndex))) != -1):
                    downloadPath = ((((HxOverrides.stringOrNull(Tools.webPath) + "haxelib/") + HxOverrides.stringOrNull(StringTools.replace(lib,":",""))) + ".zip?") + Std.string(python_lib_Random.random()))
                    haxe_Log.trace(((("正在更新" + ("null" if lib is None else lib)) + ":") + ("null" if downloadPath is None else downloadPath)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 206, 'className': "Tools", 'methodName': "updatedev"}))
                    if sys_FileSystem.exists((HxOverrides.stringOrNull(Tools.haxelib) + "/cache.zip")):
                        sys_FileSystem.deleteFile((HxOverrides.stringOrNull(Tools.haxelib) + "/cache.zip"))
                    python_HttpDownload.urlretrieve(downloadPath,(HxOverrides.stringOrNull(Tools.haxelib) + "/cache.zip"))
                    haxe_Log.trace("同步版本",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 210, 'className': "Tools", 'methodName': "updatedev"}))
                    Sys.command((((("cd " + HxOverrides.stringOrNull(Tools.haxelib)) + "/") + ("null" if projectName is None else projectName)) + "\n                    unzip -o ../cache.zip"))
                    if sys_FileSystem.exists((((HxOverrides.stringOrNull(Tools.haxelib) + "/") + ("null" if projectName is None else projectName)) + "/__MACOSX")):
                        python_FileUtils.removeDic((((HxOverrides.stringOrNull(Tools.haxelib) + "/") + ("null" if projectName is None else projectName)) + "/__MACOSX"))
                    haxe_Log.trace("更新结束！",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 215, 'className': "Tools", 'methodName': "updatedev"}))
                    break
        else:
            haxe_Log.trace((("null" if projectName is None else projectName) + "不是你的开发库，无法更新"),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 220, 'className': "Tools", 'methodName': "updatedev"}))

    @staticmethod
    def uploadlib():
        args = Sys.args()
        projectName = (args[1] if 1 < len(args) else None)
        projectPath = ((HxOverrides.stringOrNull(Tools.haxelib) + "/") + ("null" if projectName is None else projectName))
        haxe_Log.trace(("正在处理项目库：" + ("null" if projectPath is None else projectPath)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 228, 'className': "Tools", 'methodName': "uploadlib"}))
        if sys_FileSystem.exists(projectPath):
            haxelibmsg = sys_io_File.getContent((("null" if projectPath is None else projectPath) + "/haxelib.json"))
            data = python_lib_Json.loads(haxelibmsg,**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'object_hook': python_Lib.dictToAnon})))
            version = Std.parseInt(StringTools.replace(Reflect.field(data,"version"),".",""))
            version = (version + 1)
            v = Std.string(version)
            if (len(v) < 3):
                while (len(v) < 3):
                    v = ("0" + ("null" if v is None else v))
            array = list(v)
            _this = array[0:(len(array) - 2)]
            v = ((((HxOverrides.stringOrNull("".join([python_Boot.toString1(x1,'') for x1 in _this])) + ".") + HxOverrides.stringOrNull(python_internal_ArrayImpl._get(array, (len(array) - 2)))) + ".") + HxOverrides.stringOrNull(python_internal_ArrayImpl._get(array, (len(array) - 1))))
            haxe_Log.trace(("升级版本至：" + ("null" if v is None else v)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 241, 'className': "Tools", 'methodName': "uploadlib"}))
            onlineVersion = sys_Http.requestUrl(((HxOverrides.stringOrNull(Tools.webPath) + "haxelib/version.json?") + Std.string(python_lib_Random.random())))
            startIndex = None
            if (((onlineVersion.find(projectName) if ((startIndex is None)) else HxString.indexOfImpl(onlineVersion,projectName,startIndex))) == -1):
                onlineVersion = (("null" if onlineVersion is None else onlineVersion) + HxOverrides.stringOrNull(((("\n" + ("null" if projectName is None else projectName)) + ":0.0.1"))))
            libs = onlineVersion.split("\n")
            _g = 0
            _g1 = len(libs)
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                lib = (libs[i] if i >= 0 and i < len(libs) else None)
                startIndex = None
                if (((lib.find(projectName) if ((startIndex is None)) else HxString.indexOfImpl(lib,projectName,startIndex))) != -1):
                    onlineV = HxOverrides.arrayGet(lib.split(":"), 1)
                    haxe_Log.trace((((("线上版本：" + ("null" if onlineV is None else onlineV)) + "->") + " 当前新版本：") + ("null" if v is None else v)),_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 253, 'className': "Tools", 'methodName': "uploadlib"}))
                    if (Std.parseInt(StringTools.replace(onlineV,".","")) >= Std.parseInt(StringTools.replace(v,".",""))):
                        haxe_Log.trace("你的本地版本需大于线上版本",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 256, 'className': "Tools", 'methodName': "uploadlib"}))
                        exit(1)
                    python_internal_ArrayImpl._set(libs, i, ((("null" if projectName is None else projectName) + ":") + ("null" if v is None else v)))
                    zipfiles = sys_FileSystem.readDirectory(projectPath)
                    def _hx_local_2(f):
                        startIndex = None
                        if (((f.find("Export") if ((startIndex is None)) else HxString.indexOfImpl(f,"Export",startIndex))) != -1):
                            return False
                        startIndex = None
                        if (((f.find(".dev") if ((startIndex is None)) else HxString.indexOfImpl(f,".dev",startIndex))) != -1):
                            return False
                        startIndex = None
                        if (((f.find("tps") if ((startIndex is None)) else HxString.indexOfImpl(f,"tps",startIndex))) != -1):
                            return False
                        startIndex = None
                        if (((f.find(".") if ((startIndex is None)) else HxString.indexOfImpl(f,".",startIndex))) == 0):
                            return False
                        return True
                    zipfiles = list(filter(_hx_local_2,zipfiles))
                    sys_io_File.saveContent((("null" if projectPath is None else projectPath) + "/../version.json"),"\n".join([python_Boot.toString1(x1,'') for x1 in libs]))
                    sys_io_File.saveContent((("null" if projectPath is None else projectPath) + "/haxelib.json"),StringTools.replace(haxelibmsg,Reflect.field(data,"version"),v))
                    projectName = (("null" if projectName is None else projectName) + ("null" if v is None else v))
                    Sys.command(((((("cd " + ("null" if projectPath is None else projectPath)) + "\n                    zip -r ../") + ("null" if projectName is None else projectName)) + ".zip ") + HxOverrides.stringOrNull(" ".join([python_Boot.toString1(x1,'') for x1 in zipfiles]))))
                    file = (((("null" if projectPath is None else projectPath) + "/../") + ("null" if projectName is None else projectName)) + ".zip")
                    haxe_Log.trace("开始上传",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 291, 'className': "Tools", 'methodName': "uploadlib"}))
                    Tools.uploadOSS(file,"kengsdk_tools_res:1001/haxelib")
                    Tools.uploadOSS((("null" if projectPath is None else projectPath) + "/../version.json"),"kengsdk_tools_res:1001/haxelib")
                    haxe_Log.trace("上传成功：",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 295, 'className': "Tools", 'methodName': "uploadlib", 'customParams': [projectName, v]}))
                    sys_FileSystem.deleteFile((((("null" if projectPath is None else projectPath) + "/../") + ("null" if projectName is None else projectName)) + ".zip"))
                    break
        else:
            haxe_Log.trace("库不存在！",_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 301, 'className': "Tools", 'methodName': "uploadlib"}))

    @staticmethod
    def uploadOSS(file,saveName):
        command = ((("haxelib run aliyun-oss-upload " + ("null" if file is None else file)) + " ") + ("null" if saveName is None else saveName))
        haxe_Log.trace(command,_hx_AnonObject({'fileName': "src/Tools.hx", 'lineNumber': 307, 'className': "Tools", 'methodName': "uploadOSS"}))
        Sys.command(command)
Tools._hx_class = Tools
_hx_classes["Tools"] = Tools

class ValueType(Enum):
    __slots__ = ()
    _hx_class_name = "ValueType"
    _hx_constructs = ["TNull", "TInt", "TFloat", "TBool", "TObject", "TFunction", "TClass", "TEnum", "TUnknown"]

    @staticmethod
    def TClass(c):
        return ValueType("TClass", 6, (c,))

    @staticmethod
    def TEnum(e):
        return ValueType("TEnum", 7, (e,))
ValueType.TNull = ValueType("TNull", 0, ())
ValueType.TInt = ValueType("TInt", 1, ())
ValueType.TFloat = ValueType("TFloat", 2, ())
ValueType.TBool = ValueType("TBool", 3, ())
ValueType.TObject = ValueType("TObject", 4, ())
ValueType.TFunction = ValueType("TFunction", 5, ())
ValueType.TUnknown = ValueType("TUnknown", 8, ())
ValueType._hx_class = ValueType
_hx_classes["ValueType"] = ValueType


class Type:
    _hx_class_name = "Type"
    __slots__ = ()
    _hx_statics = ["getClass", "getClassName", "resolveClass", "typeof"]

    @staticmethod
    def getClass(o):
        if (o is None):
            return None
        o1 = o
        if ((o1 is not None) and ((HxOverrides.eq(o1,str) or python_lib_Inspect.isclass(o1)))):
            return None
        if isinstance(o,_hx_AnonObject):
            return None
        if hasattr(o,"_hx_class"):
            return o._hx_class
        if hasattr(o,"__class__"):
            return o.__class__
        else:
            return None

    @staticmethod
    def getClassName(c):
        if hasattr(c,"_hx_class_name"):
            return c._hx_class_name
        else:
            if (c == list):
                return "Array"
            if (c == Math):
                return "Math"
            if (c == str):
                return "String"
            try:
                return c.__name__
            except BaseException as _g:
                return None

    @staticmethod
    def resolveClass(name):
        if (name == "Array"):
            return list
        if (name == "Math"):
            return Math
        if (name == "String"):
            return str
        cl = _hx_classes.get(name,None)
        tmp = None
        if (cl is not None):
            o = cl
            tmp = (not (((o is not None) and ((HxOverrides.eq(o,str) or python_lib_Inspect.isclass(o))))))
        else:
            tmp = True
        if tmp:
            return None
        return cl

    @staticmethod
    def typeof(v):
        if (v is None):
            return ValueType.TNull
        elif isinstance(v,bool):
            return ValueType.TBool
        elif isinstance(v,int):
            return ValueType.TInt
        elif isinstance(v,float):
            return ValueType.TFloat
        elif isinstance(v,str):
            return ValueType.TClass(str)
        elif isinstance(v,list):
            return ValueType.TClass(list)
        elif (isinstance(v,_hx_AnonObject) or python_lib_Inspect.isclass(v)):
            return ValueType.TObject
        elif isinstance(v,Enum):
            return ValueType.TEnum(v.__class__)
        elif (isinstance(v,type) or hasattr(v,"_hx_class")):
            return ValueType.TClass(v.__class__)
        elif callable(v):
            return ValueType.TFunction
        else:
            return ValueType.TUnknown
Type._hx_class = Type
_hx_classes["Type"] = Type


class _Xml_XmlType_Impl_:
    _hx_class_name = "_Xml.XmlType_Impl_"
    __slots__ = ()
    _hx_statics = ["toString"]

    @staticmethod
    def toString(this1):
        _g = this1
        if (_g == 0):
            return "Element"
        elif (_g == 1):
            return "PCData"
        elif (_g == 2):
            return "CData"
        elif (_g == 3):
            return "Comment"
        elif (_g == 4):
            return "DocType"
        elif (_g == 5):
            return "ProcessingInstruction"
        elif (_g == 6):
            return "Document"
        else:
            pass
_Xml_XmlType_Impl_._hx_class = _Xml_XmlType_Impl_
_hx_classes["_Xml.XmlType_Impl_"] = _Xml_XmlType_Impl_


class Xml:
    _hx_class_name = "Xml"
    __slots__ = ("nodeType", "nodeName", "nodeValue", "parent", "children", "attributeMap")
    _hx_fields = ["nodeType", "nodeName", "nodeValue", "parent", "children", "attributeMap"]
    _hx_methods = ["get", "set", "exists", "attributes", "elements", "firstElement", "addChild", "removeChild", "insertChild", "toString"]
    _hx_statics = ["Element", "PCData", "CData", "Comment", "DocType", "ProcessingInstruction", "Document", "parse", "createElement", "createPCData", "createCData", "createComment", "createDocType", "createProcessingInstruction", "createDocument"]

    def __init__(self,nodeType):
        self.parent = None
        self.nodeValue = None
        self.nodeName = None
        self.nodeType = nodeType
        self.children = []
        self.attributeMap = haxe_ds_StringMap()

    def get(self,att):
        if (self.nodeType != Xml.Element):
            raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((self.nodeType is None)) else _Xml_XmlType_Impl_.toString(self.nodeType))))))
        return self.attributeMap.h.get(att,None)

    def set(self,att,value):
        if (self.nodeType != Xml.Element):
            raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((self.nodeType is None)) else _Xml_XmlType_Impl_.toString(self.nodeType))))))
        self.attributeMap.h[att] = value

    def exists(self,att):
        if (self.nodeType != Xml.Element):
            raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((self.nodeType is None)) else _Xml_XmlType_Impl_.toString(self.nodeType))))))
        return (att in self.attributeMap.h)

    def attributes(self):
        if (self.nodeType != Xml.Element):
            raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((self.nodeType is None)) else _Xml_XmlType_Impl_.toString(self.nodeType))))))
        return self.attributeMap.keys()

    def elements(self):
        if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, expected Element or Document but found " + HxOverrides.stringOrNull((("null" if ((self.nodeType is None)) else _Xml_XmlType_Impl_.toString(self.nodeType))))))
        _g = []
        _g1 = 0
        _g2 = self.children
        while (_g1 < len(_g2)):
            child = (_g2[_g1] if _g1 >= 0 and _g1 < len(_g2) else None)
            _g1 = (_g1 + 1)
            if (child.nodeType == Xml.Element):
                _g.append(child)
        ret = _g
        return haxe_iterators_ArrayIterator(ret)

    def firstElement(self):
        if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, expected Element or Document but found " + HxOverrides.stringOrNull((("null" if ((self.nodeType is None)) else _Xml_XmlType_Impl_.toString(self.nodeType))))))
        _g = 0
        _g1 = self.children
        while (_g < len(_g1)):
            child = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            if (child.nodeType == Xml.Element):
                return child
        return None

    def addChild(self,x):
        if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, expected Element or Document but found " + HxOverrides.stringOrNull((("null" if ((self.nodeType is None)) else _Xml_XmlType_Impl_.toString(self.nodeType))))))
        if (x.parent is not None):
            x.parent.removeChild(x)
        _this = self.children
        _this.append(x)
        x.parent = self

    def removeChild(self,x):
        if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, expected Element or Document but found " + HxOverrides.stringOrNull((("null" if ((self.nodeType is None)) else _Xml_XmlType_Impl_.toString(self.nodeType))))))
        if python_internal_ArrayImpl.remove(self.children,x):
            x.parent = None
            return True
        return False

    def insertChild(self,x,pos):
        if ((self.nodeType != Xml.Document) and ((self.nodeType != Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, expected Element or Document but found " + HxOverrides.stringOrNull((("null" if ((self.nodeType is None)) else _Xml_XmlType_Impl_.toString(self.nodeType))))))
        if (x.parent is not None):
            python_internal_ArrayImpl.remove(x.parent.children,x)
        self.children.insert(pos, x)
        x.parent = self

    def toString(self):
        return haxe_xml_Printer.print(self)

    @staticmethod
    def parse(_hx_str):
        return haxe_xml_Parser.parse(_hx_str)

    @staticmethod
    def createElement(name):
        xml = Xml(Xml.Element)
        if (xml.nodeType != Xml.Element):
            raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((xml.nodeType is None)) else _Xml_XmlType_Impl_.toString(xml.nodeType))))))
        xml.nodeName = name
        return xml

    @staticmethod
    def createPCData(data):
        xml = Xml(Xml.PCData)
        if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((xml.nodeType is None)) else _Xml_XmlType_Impl_.toString(xml.nodeType))))))
        xml.nodeValue = data
        return xml

    @staticmethod
    def createCData(data):
        xml = Xml(Xml.CData)
        if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((xml.nodeType is None)) else _Xml_XmlType_Impl_.toString(xml.nodeType))))))
        xml.nodeValue = data
        return xml

    @staticmethod
    def createComment(data):
        xml = Xml(Xml.Comment)
        if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((xml.nodeType is None)) else _Xml_XmlType_Impl_.toString(xml.nodeType))))))
        xml.nodeValue = data
        return xml

    @staticmethod
    def createDocType(data):
        xml = Xml(Xml.DocType)
        if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((xml.nodeType is None)) else _Xml_XmlType_Impl_.toString(xml.nodeType))))))
        xml.nodeValue = data
        return xml

    @staticmethod
    def createProcessingInstruction(data):
        xml = Xml(Xml.ProcessingInstruction)
        if ((xml.nodeType == Xml.Document) or ((xml.nodeType == Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((xml.nodeType is None)) else _Xml_XmlType_Impl_.toString(xml.nodeType))))))
        xml.nodeValue = data
        return xml

    @staticmethod
    def createDocument():
        return Xml(Xml.Document)

Xml._hx_class = Xml
_hx_classes["Xml"] = Xml


class atf_AtfBuild:
    _hx_class_name = "atf.AtfBuild"
    __slots__ = ()
    _hx_statics = ["build"]

    @staticmethod
    def build(path,out):
        if (not sys_FileSystem.exists(out)):
            sys_FileSystem.createDirectory(out)
        dir = sys_FileSystem.readDirectory(path)
        _g = 0
        while (_g < len(dir)):
            _hx_str = (dir[_g] if _g >= 0 and _g < len(dir) else None)
            _g = (_g + 1)
            if sys_FileSystem.isDirectory(((("null" if path is None else path) + "/") + ("null" if _hx_str is None else _hx_str))):
                atf_AtfBuild.build(((("null" if path is None else path) + "/") + ("null" if _hx_str is None else _hx_str)),((("null" if out is None else out) + "/") + ("null" if _hx_str is None else _hx_str)))
            elif _hx_str.endswith("png"):
                if sys_FileSystem.exists(((("null" if path is None else path) + "/") + HxOverrides.stringOrNull(StringTools.replace(_hx_str,".png",".xml")))):
                    Sys.command((((((("echo `sips -g pixelHeight -g pixelWidth " + ("null" if path is None else path)) + "/") + ("null" if _hx_str is None else _hx_str)) + "` > ") + ("null" if out is None else out)) + "/cache.txt"))
                    _this = sys_io_File.getContent((("null" if out is None else out) + "/cache.txt"))
                    size = _this.split(" ")
                    filename = ((HxOverrides.stringOrNull((size[2] if 2 < len(size) else None)) + "x") + HxOverrides.stringOrNull((size[4] if 4 < len(size) else None)))
                    sys_FileSystem.deleteFile((("null" if out is None else out) + "/cache.txt"))
                    Sys.command(((((((("tools/atftools/png2atf -n 0,0 -c e -i " + ("null" if path is None else path)) + "/") + ("null" if _hx_str is None else _hx_str)) + " -o ") + ("null" if out is None else out)) + "/") + ("null" if filename is None else filename)))
                    Sys.command(((((((((("cd " + ("null" if out is None else out)) + "\n                        zip -q -r -m -o ") + ("null" if _hx_str is None else _hx_str)) + ".zip ") + ("null" if filename is None else filename)) + "\n                        mv ") + ("null" if _hx_str is None else _hx_str)) + ".zip ") + ("null" if _hx_str is None else _hx_str)))
                else:
                    python_FileUtils.copyFile(((("null" if path is None else path) + "/") + ("null" if _hx_str is None else _hx_str)),((("null" if out is None else out) + "/") + ("null" if _hx_str is None else _hx_str)))
            else:
                python_FileUtils.copyFile(((("null" if path is None else path) + "/") + ("null" if _hx_str is None else _hx_str)),((("null" if out is None else out) + "/") + ("null" if _hx_str is None else _hx_str)))
atf_AtfBuild._hx_class = atf_AtfBuild
_hx_classes["atf.AtfBuild"] = atf_AtfBuild


class atlasxml_AtlasTools:
    _hx_class_name = "atlasxml.AtlasTools"
    __slots__ = ()
    _hx_statics = ["removeXmlItem"]

    @staticmethod
    def removeXmlItem(xmlpath):
        xml = Xml.parse(sys_io_File.getContent(xmlpath))
        lastitem = None
        removeXmls = []
        item = xml.firstElement().elements()
        while item.hasNext():
            item1 = item.next()
            if (((lastitem is not None) and ((lastitem.get("x") == item1.get("x")))) and ((lastitem.get("y") == item1.get("y")))):
                removeXmls.append(item1)
            lastitem = item1
        _g = 0
        while (_g < len(removeXmls)):
            item = (removeXmls[_g] if _g >= 0 and _g < len(removeXmls) else None)
            _g = (_g + 1)
            xml.firstElement().removeChild(item)
        index = 10000
        item = xml.firstElement().elements()
        while item.hasNext():
            item1 = item.next()
            item1.set("name",("Frame" + Std.string(index)))
            index = (index + 1)
        sys_io_File.saveContent((("null" if xmlpath is None else xmlpath) + ".2"),haxe_xml_Printer.print(xml))
atlasxml_AtlasTools._hx_class = atlasxml_AtlasTools
_hx_classes["atlasxml.AtlasTools"] = atlasxml_AtlasTools


class haxe_Exception(Exception):
    _hx_class_name = "haxe.Exception"
    __slots__ = ("_hx___nativeStack", "_hx___skipStack", "_hx___nativeException", "_hx___previousException")
    _hx_fields = ["__nativeStack", "__skipStack", "__nativeException", "__previousException"]
    _hx_methods = ["unwrap", "toString", "get_message", "get_native"]
    _hx_statics = ["caught", "thrown"]
    _hx_interfaces = []
    _hx_super = Exception


    def __init__(self,message,previous = None,native = None):
        self._hx___previousException = None
        self._hx___nativeException = None
        self._hx___nativeStack = None
        self._hx___skipStack = 0
        super().__init__(message)
        self._hx___previousException = previous
        if ((native is not None) and Std.isOfType(native,BaseException)):
            self._hx___nativeException = native
            self._hx___nativeStack = haxe_NativeStackTrace.exceptionStack()
        else:
            self._hx___nativeException = self
            infos = python_lib_Traceback.extract_stack()
            if (len(infos) != 0):
                infos.pop()
            infos.reverse()
            self._hx___nativeStack = infos

    def unwrap(self):
        return self._hx___nativeException

    def toString(self):
        return self.get_message()

    def get_message(self):
        return str(self)

    def get_native(self):
        return self._hx___nativeException

    @staticmethod
    def caught(value):
        if Std.isOfType(value,haxe_Exception):
            return value
        elif Std.isOfType(value,BaseException):
            return haxe_Exception(str(value),None,value)
        else:
            return haxe_ValueException(value,None,value)

    @staticmethod
    def thrown(value):
        if Std.isOfType(value,haxe_Exception):
            return value.get_native()
        elif Std.isOfType(value,BaseException):
            return value
        else:
            e = haxe_ValueException(value)
            e._hx___skipStack = (e._hx___skipStack + 1)
            return e

haxe_Exception._hx_class = haxe_Exception
_hx_classes["haxe.Exception"] = haxe_Exception


class haxe_Log:
    _hx_class_name = "haxe.Log"
    __slots__ = ()
    _hx_statics = ["formatOutput", "trace"]

    @staticmethod
    def formatOutput(v,infos):
        _hx_str = Std.string(v)
        if (infos is None):
            return _hx_str
        pstr = ((HxOverrides.stringOrNull(infos.fileName) + ":") + Std.string(infos.lineNumber))
        if (Reflect.field(infos,"customParams") is not None):
            _g = 0
            _g1 = Reflect.field(infos,"customParams")
            while (_g < len(_g1)):
                v = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
                _g = (_g + 1)
                _hx_str = (("null" if _hx_str is None else _hx_str) + ((", " + Std.string(v))))
        return ((("null" if pstr is None else pstr) + ": ") + ("null" if _hx_str is None else _hx_str))

    @staticmethod
    def trace(v,infos = None):
        _hx_str = haxe_Log.formatOutput(v,infos)
        str1 = Std.string(_hx_str)
        python_Lib.printString((("" + ("null" if str1 is None else str1)) + HxOverrides.stringOrNull(python_Lib.lineEnd)))
haxe_Log._hx_class = haxe_Log
_hx_classes["haxe.Log"] = haxe_Log


class haxe_NativeStackTrace:
    _hx_class_name = "haxe.NativeStackTrace"
    __slots__ = ()
    _hx_statics = ["saveStack", "exceptionStack"]

    @staticmethod
    def saveStack(exception):
        pass

    @staticmethod
    def exceptionStack():
        exc = python_lib_Sys.exc_info()
        if (exc[2] is not None):
            infos = python_lib_Traceback.extract_tb(exc[2])
            infos.reverse()
            return infos
        else:
            return []
haxe_NativeStackTrace._hx_class = haxe_NativeStackTrace
_hx_classes["haxe.NativeStackTrace"] = haxe_NativeStackTrace


class haxe_ValueException(haxe_Exception):
    _hx_class_name = "haxe.ValueException"
    __slots__ = ("value",)
    _hx_fields = ["value"]
    _hx_methods = ["unwrap"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_Exception


    def __init__(self,value,previous = None,native = None):
        self.value = None
        super().__init__(Std.string(value),previous,native)
        self.value = value

    def unwrap(self):
        return self.value

haxe_ValueException._hx_class = haxe_ValueException
_hx_classes["haxe.ValueException"] = haxe_ValueException


class haxe_crypto_Md5:
    _hx_class_name = "haxe.crypto.Md5"
    __slots__ = ()
    _hx_methods = ["bitOR", "bitXOR", "bitAND", "addme", "hex", "rol", "cmn", "ff", "gg", "hh", "ii", "doEncode"]
    _hx_statics = ["encode", "str2blks"]

    def __init__(self):
        pass

    def bitOR(self,a,b):
        lsb = ((a & 1) | ((b & 1)))
        msb31 = (HxOverrides.rshift(a, 1) | (HxOverrides.rshift(b, 1)))
        return ((msb31 << 1) | lsb)

    def bitXOR(self,a,b):
        lsb = ((a & 1) ^ ((b & 1)))
        msb31 = (HxOverrides.rshift(a, 1) ^ (HxOverrides.rshift(b, 1)))
        return ((msb31 << 1) | lsb)

    def bitAND(self,a,b):
        lsb = ((a & 1) & ((b & 1)))
        msb31 = (HxOverrides.rshift(a, 1) & (HxOverrides.rshift(b, 1)))
        return ((msb31 << 1) | lsb)

    def addme(self,x,y):
        lsw = (((x & 65535)) + ((y & 65535)))
        msw = ((((x >> 16)) + ((y >> 16))) + ((lsw >> 16)))
        return ((msw << 16) | ((lsw & 65535)))

    def hex(self,a):
        _hx_str = ""
        hex_chr = "0123456789abcdef"
        _g = 0
        while (_g < len(a)):
            num = (a[_g] if _g >= 0 and _g < len(a) else None)
            _g = (_g + 1)
            index = ((num >> 4) & 15)
            index1 = (num & 15)
            _hx_str = (("null" if _hx_str is None else _hx_str) + HxOverrides.stringOrNull(((HxOverrides.stringOrNull((("" if (((index < 0) or ((index >= len(hex_chr))))) else hex_chr[index]))) + HxOverrides.stringOrNull((("" if (((index1 < 0) or ((index1 >= len(hex_chr))))) else hex_chr[index1])))))))
            index2 = ((num >> 12) & 15)
            index3 = ((num >> 8) & 15)
            _hx_str = (("null" if _hx_str is None else _hx_str) + HxOverrides.stringOrNull(((HxOverrides.stringOrNull((("" if (((index2 < 0) or ((index2 >= len(hex_chr))))) else hex_chr[index2]))) + HxOverrides.stringOrNull((("" if (((index3 < 0) or ((index3 >= len(hex_chr))))) else hex_chr[index3])))))))
            index4 = ((num >> 20) & 15)
            index5 = ((num >> 16) & 15)
            _hx_str = (("null" if _hx_str is None else _hx_str) + HxOverrides.stringOrNull(((HxOverrides.stringOrNull((("" if (((index4 < 0) or ((index4 >= len(hex_chr))))) else hex_chr[index4]))) + HxOverrides.stringOrNull((("" if (((index5 < 0) or ((index5 >= len(hex_chr))))) else hex_chr[index5])))))))
            index6 = ((num >> 28) & 15)
            index7 = ((num >> 24) & 15)
            _hx_str = (("null" if _hx_str is None else _hx_str) + HxOverrides.stringOrNull(((HxOverrides.stringOrNull((("" if (((index6 < 0) or ((index6 >= len(hex_chr))))) else hex_chr[index6]))) + HxOverrides.stringOrNull((("" if (((index7 < 0) or ((index7 >= len(hex_chr))))) else hex_chr[index7])))))))
        return _hx_str

    def rol(self,num,cnt):
        return ((num << cnt) | (HxOverrides.rshift(num, ((32 - cnt)))))

    def cmn(self,q,a,b,x,s,t):
        return self.addme(self.rol(self.addme(self.addme(a,q),self.addme(x,t)),s),b)

    def ff(self,a,b,c,d,x,s,t):
        return self.cmn(self.bitOR(self.bitAND(b,c),self.bitAND(~b,d)),a,b,x,s,t)

    def gg(self,a,b,c,d,x,s,t):
        return self.cmn(self.bitOR(self.bitAND(b,d),self.bitAND(c,~d)),a,b,x,s,t)

    def hh(self,a,b,c,d,x,s,t):
        return self.cmn(self.bitXOR(self.bitXOR(b,c),d),a,b,x,s,t)

    def ii(self,a,b,c,d,x,s,t):
        return self.cmn(self.bitXOR(c,self.bitOR(b,~d)),a,b,x,s,t)

    def doEncode(self,x):
        a = 1732584193
        b = -271733879
        c = -1732584194
        d = 271733878
        step = None
        i = 0
        while (i < len(x)):
            olda = a
            oldb = b
            oldc = c
            oldd = d
            step = 0
            a = self.ff(a,b,c,d,(x[i] if i >= 0 and i < len(x) else None),7,-680876936)
            d = self.ff(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 1)),12,-389564586)
            c = self.ff(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 2)),17,606105819)
            b = self.ff(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 3)),22,-1044525330)
            a = self.ff(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 4)),7,-176418897)
            d = self.ff(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 5)),12,1200080426)
            c = self.ff(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 6)),17,-1473231341)
            b = self.ff(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 7)),22,-45705983)
            a = self.ff(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 8)),7,1770035416)
            d = self.ff(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 9)),12,-1958414417)
            c = self.ff(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 10)),17,-42063)
            b = self.ff(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 11)),22,-1990404162)
            a = self.ff(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 12)),7,1804603682)
            d = self.ff(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 13)),12,-40341101)
            c = self.ff(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 14)),17,-1502002290)
            b = self.ff(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 15)),22,1236535329)
            a = self.gg(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 1)),5,-165796510)
            d = self.gg(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 6)),9,-1069501632)
            c = self.gg(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 11)),14,643717713)
            b = self.gg(b,c,d,a,(x[i] if i >= 0 and i < len(x) else None),20,-373897302)
            a = self.gg(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 5)),5,-701558691)
            d = self.gg(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 10)),9,38016083)
            c = self.gg(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 15)),14,-660478335)
            b = self.gg(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 4)),20,-405537848)
            a = self.gg(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 9)),5,568446438)
            d = self.gg(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 14)),9,-1019803690)
            c = self.gg(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 3)),14,-187363961)
            b = self.gg(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 8)),20,1163531501)
            a = self.gg(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 13)),5,-1444681467)
            d = self.gg(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 2)),9,-51403784)
            c = self.gg(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 7)),14,1735328473)
            b = self.gg(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 12)),20,-1926607734)
            a = self.hh(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 5)),4,-378558)
            d = self.hh(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 8)),11,-2022574463)
            c = self.hh(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 11)),16,1839030562)
            b = self.hh(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 14)),23,-35309556)
            a = self.hh(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 1)),4,-1530992060)
            d = self.hh(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 4)),11,1272893353)
            c = self.hh(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 7)),16,-155497632)
            b = self.hh(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 10)),23,-1094730640)
            a = self.hh(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 13)),4,681279174)
            d = self.hh(d,a,b,c,(x[i] if i >= 0 and i < len(x) else None),11,-358537222)
            c = self.hh(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 3)),16,-722521979)
            b = self.hh(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 6)),23,76029189)
            a = self.hh(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 9)),4,-640364487)
            d = self.hh(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 12)),11,-421815835)
            c = self.hh(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 15)),16,530742520)
            b = self.hh(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 2)),23,-995338651)
            a = self.ii(a,b,c,d,(x[i] if i >= 0 and i < len(x) else None),6,-198630844)
            d = self.ii(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 7)),10,1126891415)
            c = self.ii(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 14)),15,-1416354905)
            b = self.ii(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 5)),21,-57434055)
            a = self.ii(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 12)),6,1700485571)
            d = self.ii(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 3)),10,-1894986606)
            c = self.ii(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 10)),15,-1051523)
            b = self.ii(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 1)),21,-2054922799)
            a = self.ii(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 8)),6,1873313359)
            d = self.ii(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 15)),10,-30611744)
            c = self.ii(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 6)),15,-1560198380)
            b = self.ii(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 13)),21,1309151649)
            a = self.ii(a,b,c,d,python_internal_ArrayImpl._get(x, (i + 4)),6,-145523070)
            d = self.ii(d,a,b,c,python_internal_ArrayImpl._get(x, (i + 11)),10,-1120210379)
            c = self.ii(c,d,a,b,python_internal_ArrayImpl._get(x, (i + 2)),15,718787259)
            b = self.ii(b,c,d,a,python_internal_ArrayImpl._get(x, (i + 9)),21,-343485551)
            a = self.addme(a,olda)
            b = self.addme(b,oldb)
            c = self.addme(c,oldc)
            d = self.addme(d,oldd)
            i = (i + 16)
        return [a, b, c, d]

    @staticmethod
    def encode(s):
        m = haxe_crypto_Md5()
        h = m.doEncode(haxe_crypto_Md5.str2blks(s))
        return m.hex(h)

    @staticmethod
    def str2blks(_hx_str):
        str1 = haxe_io_Bytes.ofString(_hx_str)
        nblk = ((((str1.length + 8) >> 6)) + 1)
        blks = list()
        blksSize = (nblk * 16)
        _g = 0
        _g1 = blksSize
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            python_internal_ArrayImpl._set(blks, i, 0)
        i = 0
        _hx_max = str1.length
        l = (_hx_max * 8)
        while (i < _hx_max):
            _hx_local_0 = blks
            _hx_local_1 = (i >> 2)
            _hx_local_2 = (_hx_local_0[_hx_local_1] if _hx_local_1 >= 0 and _hx_local_1 < len(_hx_local_0) else None)
            python_internal_ArrayImpl._set(_hx_local_0, _hx_local_1, (_hx_local_2 | ((str1.b[i] << ((HxOverrides.mod(((l + i)), 4) * 8))))))
            (_hx_local_0[_hx_local_1] if _hx_local_1 >= 0 and _hx_local_1 < len(_hx_local_0) else None)
            i = (i + 1)
        _hx_local_4 = blks
        _hx_local_5 = (i >> 2)
        _hx_local_6 = (_hx_local_4[_hx_local_5] if _hx_local_5 >= 0 and _hx_local_5 < len(_hx_local_4) else None)
        python_internal_ArrayImpl._set(_hx_local_4, _hx_local_5, (_hx_local_6 | ((128 << ((HxOverrides.mod(((l + i)), 4) * 8))))))
        (_hx_local_4[_hx_local_5] if _hx_local_5 >= 0 and _hx_local_5 < len(_hx_local_4) else None)
        k = ((nblk * 16) - 2)
        python_internal_ArrayImpl._set(blks, k, (l & 255))
        python_internal_ArrayImpl._set(blks, k, ((blks[k] if k >= 0 and k < len(blks) else None) | ((((HxOverrides.rshift(l, 8) & 255)) << 8))))
        python_internal_ArrayImpl._set(blks, k, ((blks[k] if k >= 0 and k < len(blks) else None) | ((((HxOverrides.rshift(l, 16) & 255)) << 16))))
        python_internal_ArrayImpl._set(blks, k, ((blks[k] if k >= 0 and k < len(blks) else None) | ((((HxOverrides.rshift(l, 24) & 255)) << 24))))
        return blks

haxe_crypto_Md5._hx_class = haxe_crypto_Md5
_hx_classes["haxe.crypto.Md5"] = haxe_crypto_Md5


class haxe_exceptions_PosException(haxe_Exception):
    _hx_class_name = "haxe.exceptions.PosException"
    __slots__ = ("posInfos",)
    _hx_fields = ["posInfos"]
    _hx_methods = ["toString"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_Exception


    def __init__(self,message,previous = None,pos = None):
        self.posInfos = None
        super().__init__(message,previous)
        if (pos is None):
            self.posInfos = _hx_AnonObject({'fileName': "(unknown)", 'lineNumber': 0, 'className': "(unknown)", 'methodName': "(unknown)"})
        else:
            self.posInfos = pos

    def toString(self):
        return ((((((((("" + HxOverrides.stringOrNull(super().toString())) + " in ") + HxOverrides.stringOrNull(self.posInfos.className)) + ".") + HxOverrides.stringOrNull(self.posInfos.methodName)) + " at ") + HxOverrides.stringOrNull(self.posInfos.fileName)) + ":") + Std.string(self.posInfos.lineNumber))

haxe_exceptions_PosException._hx_class = haxe_exceptions_PosException
_hx_classes["haxe.exceptions.PosException"] = haxe_exceptions_PosException


class haxe_exceptions_NotImplementedException(haxe_exceptions_PosException):
    _hx_class_name = "haxe.exceptions.NotImplementedException"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_exceptions_PosException


    def __init__(self,message = None,previous = None,pos = None):
        if (message is None):
            message = "Not implemented"
        super().__init__(message,previous,pos)
haxe_exceptions_NotImplementedException._hx_class = haxe_exceptions_NotImplementedException
_hx_classes["haxe.exceptions.NotImplementedException"] = haxe_exceptions_NotImplementedException


class haxe_format_JsonPrinter:
    _hx_class_name = "haxe.format.JsonPrinter"
    __slots__ = ("buf", "replacer", "indent", "pretty", "nind")
    _hx_fields = ["buf", "replacer", "indent", "pretty", "nind"]
    _hx_methods = ["write", "classString", "fieldsString", "quote"]
    _hx_statics = ["print"]

    def __init__(self,replacer,space):
        self.replacer = replacer
        self.indent = space
        self.pretty = (space is not None)
        self.nind = 0
        self.buf = StringBuf()

    def write(self,k,v):
        if (self.replacer is not None):
            v = self.replacer(k,v)
        _g = Type.typeof(v)
        tmp = _g.index
        if (tmp == 0):
            self.buf.b.write("null")
        elif (tmp == 1):
            _this = self.buf
            s = Std.string(v)
            _this.b.write(s)
        elif (tmp == 2):
            f = v
            v1 = (Std.string(v) if ((((f != Math.POSITIVE_INFINITY) and ((f != Math.NEGATIVE_INFINITY))) and (not python_lib_Math.isnan(f)))) else "null")
            _this = self.buf
            s = Std.string(v1)
            _this.b.write(s)
        elif (tmp == 3):
            _this = self.buf
            s = Std.string(v)
            _this.b.write(s)
        elif (tmp == 4):
            self.fieldsString(v,python_Boot.fields(v))
        elif (tmp == 5):
            self.buf.b.write("\"<fun>\"")
        elif (tmp == 6):
            c = _g.params[0]
            if (c == str):
                self.quote(v)
            elif (c == list):
                v1 = v
                _this = self.buf
                s = "".join(map(chr,[91]))
                _this.b.write(s)
                _hx_len = len(v1)
                last = (_hx_len - 1)
                _g1 = 0
                _g2 = _hx_len
                while (_g1 < _g2):
                    i = _g1
                    _g1 = (_g1 + 1)
                    if (i > 0):
                        _this = self.buf
                        s = "".join(map(chr,[44]))
                        _this.b.write(s)
                    else:
                        _hx_local_0 = self
                        _hx_local_1 = _hx_local_0.nind
                        _hx_local_0.nind = (_hx_local_1 + 1)
                        _hx_local_1
                    if self.pretty:
                        _this1 = self.buf
                        s1 = "".join(map(chr,[10]))
                        _this1.b.write(s1)
                    if self.pretty:
                        v2 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
                        _this2 = self.buf
                        s2 = Std.string(v2)
                        _this2.b.write(s2)
                    self.write(i,(v1[i] if i >= 0 and i < len(v1) else None))
                    if (i == last):
                        _hx_local_2 = self
                        _hx_local_3 = _hx_local_2.nind
                        _hx_local_2.nind = (_hx_local_3 - 1)
                        _hx_local_3
                        if self.pretty:
                            _this3 = self.buf
                            s3 = "".join(map(chr,[10]))
                            _this3.b.write(s3)
                        if self.pretty:
                            v3 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
                            _this4 = self.buf
                            s4 = Std.string(v3)
                            _this4.b.write(s4)
                _this = self.buf
                s = "".join(map(chr,[93]))
                _this.b.write(s)
            elif (c == haxe_ds_StringMap):
                v1 = v
                o = _hx_AnonObject({})
                k = v1.keys()
                while k.hasNext():
                    k1 = k.next()
                    value = v1.h.get(k1,None)
                    setattr(o,(("_hx_" + k1) if ((k1 in python_Boot.keywords)) else (("_hx_" + k1) if (((((len(k1) > 2) and ((ord(k1[0]) == 95))) and ((ord(k1[1]) == 95))) and ((ord(k1[(len(k1) - 1)]) != 95)))) else k1)),value)
                v1 = o
                self.fieldsString(v1,python_Boot.fields(v1))
            elif (c == Date):
                v1 = v
                self.quote(v1.toString())
            else:
                self.classString(v)
        elif (tmp == 7):
            _g1 = _g.params[0]
            i = v.index
            _this = self.buf
            s = Std.string(i)
            _this.b.write(s)
        elif (tmp == 8):
            self.buf.b.write("\"???\"")
        else:
            pass

    def classString(self,v):
        self.fieldsString(v,python_Boot.getInstanceFields(Type.getClass(v)))

    def fieldsString(self,v,fields):
        _this = self.buf
        s = "".join(map(chr,[123]))
        _this.b.write(s)
        _hx_len = len(fields)
        last = (_hx_len - 1)
        first = True
        _g = 0
        _g1 = _hx_len
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            f = (fields[i] if i >= 0 and i < len(fields) else None)
            value = Reflect.field(v,f)
            if Reflect.isFunction(value):
                continue
            if first:
                _hx_local_0 = self
                _hx_local_1 = _hx_local_0.nind
                _hx_local_0.nind = (_hx_local_1 + 1)
                _hx_local_1
                first = False
            else:
                _this = self.buf
                s = "".join(map(chr,[44]))
                _this.b.write(s)
            if self.pretty:
                _this1 = self.buf
                s1 = "".join(map(chr,[10]))
                _this1.b.write(s1)
            if self.pretty:
                v1 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
                _this2 = self.buf
                s2 = Std.string(v1)
                _this2.b.write(s2)
            self.quote(f)
            _this3 = self.buf
            s3 = "".join(map(chr,[58]))
            _this3.b.write(s3)
            if self.pretty:
                _this4 = self.buf
                s4 = "".join(map(chr,[32]))
                _this4.b.write(s4)
            self.write(f,value)
            if (i == last):
                _hx_local_2 = self
                _hx_local_3 = _hx_local_2.nind
                _hx_local_2.nind = (_hx_local_3 - 1)
                _hx_local_3
                if self.pretty:
                    _this5 = self.buf
                    s5 = "".join(map(chr,[10]))
                    _this5.b.write(s5)
                if self.pretty:
                    v2 = StringTools.lpad("",self.indent,(self.nind * len(self.indent)))
                    _this6 = self.buf
                    s6 = Std.string(v2)
                    _this6.b.write(s6)
        _this = self.buf
        s = "".join(map(chr,[125]))
        _this.b.write(s)

    def quote(self,s):
        _this = self.buf
        s1 = "".join(map(chr,[34]))
        _this.b.write(s1)
        i = 0
        length = len(s)
        while (i < length):
            index = i
            i = (i + 1)
            c = ord(s[index])
            c1 = c
            if (c1 == 8):
                self.buf.b.write("\\b")
            elif (c1 == 9):
                self.buf.b.write("\\t")
            elif (c1 == 10):
                self.buf.b.write("\\n")
            elif (c1 == 12):
                self.buf.b.write("\\f")
            elif (c1 == 13):
                self.buf.b.write("\\r")
            elif (c1 == 34):
                self.buf.b.write("\\\"")
            elif (c1 == 92):
                self.buf.b.write("\\\\")
            else:
                _this = self.buf
                s1 = "".join(map(chr,[c]))
                _this.b.write(s1)
        _this = self.buf
        s = "".join(map(chr,[34]))
        _this.b.write(s)

    @staticmethod
    def print(o,replacer = None,space = None):
        printer = haxe_format_JsonPrinter(replacer,space)
        printer.write("",o)
        return printer.buf.b.getvalue()

haxe_format_JsonPrinter._hx_class = haxe_format_JsonPrinter
_hx_classes["haxe.format.JsonPrinter"] = haxe_format_JsonPrinter


class haxe_http_HttpBase:
    _hx_class_name = "haxe.http.HttpBase"
    _hx_fields = ["url", "responseBytes", "responseAsString", "postData", "postBytes", "headers", "params", "emptyOnData"]
    _hx_methods = ["onData", "onBytes", "onError", "onStatus", "hasOnData", "success", "get_responseData"]

    def __init__(self,url):
        self.emptyOnData = None
        self.postBytes = None
        self.postData = None
        self.responseAsString = None
        self.responseBytes = None
        self.url = url
        self.headers = []
        self.params = []
        self.emptyOnData = self.onData

    def onData(self,data):
        pass

    def onBytes(self,data):
        pass

    def onError(self,msg):
        pass

    def onStatus(self,status):
        pass

    def hasOnData(self):
        return (not Reflect.compareMethods(self.onData,self.emptyOnData))

    def success(self,data):
        self.responseBytes = data
        self.responseAsString = None
        if self.hasOnData():
            self.onData(self.get_responseData())
        self.onBytes(self.responseBytes)

    def get_responseData(self):
        if ((self.responseAsString is None) and ((self.responseBytes is not None))):
            self.responseAsString = self.responseBytes.getString(0,self.responseBytes.length,haxe_io_Encoding.UTF8)
        return self.responseAsString

haxe_http_HttpBase._hx_class = haxe_http_HttpBase
_hx_classes["haxe.http.HttpBase"] = haxe_http_HttpBase


class haxe_io_Bytes:
    _hx_class_name = "haxe.io.Bytes"
    __slots__ = ("length", "b")
    _hx_fields = ["length", "b"]
    _hx_methods = ["blit", "sub", "getString", "toString"]
    _hx_statics = ["alloc", "ofString", "ofData"]

    def __init__(self,length,b):
        self.length = length
        self.b = b

    def blit(self,pos,src,srcpos,_hx_len):
        if (((((pos < 0) or ((srcpos < 0))) or ((_hx_len < 0))) or (((pos + _hx_len) > self.length))) or (((srcpos + _hx_len) > src.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        self.b[pos:pos+_hx_len] = src.b[srcpos:srcpos+_hx_len]

    def sub(self,pos,_hx_len):
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > self.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        return haxe_io_Bytes(_hx_len,self.b[pos:(pos + _hx_len)])

    def getString(self,pos,_hx_len,encoding = None):
        tmp = (encoding is None)
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > self.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        return self.b[pos:pos+_hx_len].decode('UTF-8','replace')

    def toString(self):
        return self.getString(0,self.length)

    @staticmethod
    def alloc(length):
        return haxe_io_Bytes(length,bytearray(length))

    @staticmethod
    def ofString(s,encoding = None):
        b = bytearray(s,"UTF-8")
        return haxe_io_Bytes(len(b),b)

    @staticmethod
    def ofData(b):
        return haxe_io_Bytes(len(b),b)

haxe_io_Bytes._hx_class = haxe_io_Bytes
_hx_classes["haxe.io.Bytes"] = haxe_io_Bytes


class haxe_io_BytesBuffer:
    _hx_class_name = "haxe.io.BytesBuffer"
    __slots__ = ("b",)
    _hx_fields = ["b"]
    _hx_methods = ["getBytes"]

    def __init__(self):
        self.b = bytearray()

    def getBytes(self):
        _hx_bytes = haxe_io_Bytes(len(self.b),self.b)
        self.b = None
        return _hx_bytes

haxe_io_BytesBuffer._hx_class = haxe_io_BytesBuffer
_hx_classes["haxe.io.BytesBuffer"] = haxe_io_BytesBuffer


class haxe_io_Output:
    _hx_class_name = "haxe.io.Output"
    __slots__ = ("bigEndian",)
    _hx_fields = ["bigEndian"]
    _hx_methods = ["writeByte", "writeBytes", "close", "set_bigEndian", "writeFullBytes", "prepare", "writeString"]

    def writeByte(self,c):
        raise haxe_exceptions_NotImplementedException(None,None,_hx_AnonObject({'fileName': "haxe/io/Output.hx", 'lineNumber': 47, 'className': "haxe.io.Output", 'methodName': "writeByte"}))

    def writeBytes(self,s,pos,_hx_len):
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > s.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        b = s.b
        k = _hx_len
        while (k > 0):
            self.writeByte(b[pos])
            pos = (pos + 1)
            k = (k - 1)
        return _hx_len

    def close(self):
        pass

    def set_bigEndian(self,b):
        self.bigEndian = b
        return b

    def writeFullBytes(self,s,pos,_hx_len):
        while (_hx_len > 0):
            k = self.writeBytes(s,pos,_hx_len)
            pos = (pos + k)
            _hx_len = (_hx_len - k)

    def prepare(self,nbytes):
        pass

    def writeString(self,s,encoding = None):
        b = haxe_io_Bytes.ofString(s,encoding)
        self.writeFullBytes(b,0,b.length)

haxe_io_Output._hx_class = haxe_io_Output
_hx_classes["haxe.io.Output"] = haxe_io_Output


class haxe_io_BytesOutput(haxe_io_Output):
    _hx_class_name = "haxe.io.BytesOutput"
    __slots__ = ("b",)
    _hx_fields = ["b"]
    _hx_methods = ["writeByte", "writeBytes", "getBytes"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Output


    def __init__(self):
        self.b = haxe_io_BytesBuffer()
        self.set_bigEndian(False)

    def writeByte(self,c):
        self.b.b.append(c)

    def writeBytes(self,buf,pos,_hx_len):
        _this = self.b
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > buf.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        _this.b.extend(buf.b[pos:(pos + _hx_len)])
        return _hx_len

    def getBytes(self):
        return self.b.getBytes()

haxe_io_BytesOutput._hx_class = haxe_io_BytesOutput
_hx_classes["haxe.io.BytesOutput"] = haxe_io_BytesOutput

class haxe_io_Encoding(Enum):
    __slots__ = ()
    _hx_class_name = "haxe.io.Encoding"
    _hx_constructs = ["UTF8", "RawNative"]
haxe_io_Encoding.UTF8 = haxe_io_Encoding("UTF8", 0, ())
haxe_io_Encoding.RawNative = haxe_io_Encoding("RawNative", 1, ())
haxe_io_Encoding._hx_class = haxe_io_Encoding
_hx_classes["haxe.io.Encoding"] = haxe_io_Encoding


class haxe_io_Eof:
    _hx_class_name = "haxe.io.Eof"
    __slots__ = ()
    _hx_methods = ["toString"]

    def __init__(self):
        pass

    def toString(self):
        return "Eof"

haxe_io_Eof._hx_class = haxe_io_Eof
_hx_classes["haxe.io.Eof"] = haxe_io_Eof

class haxe_io_Error(Enum):
    __slots__ = ()
    _hx_class_name = "haxe.io.Error"
    _hx_constructs = ["Blocked", "Overflow", "OutsideBounds", "Custom"]

    @staticmethod
    def Custom(e):
        return haxe_io_Error("Custom", 3, (e,))
haxe_io_Error.Blocked = haxe_io_Error("Blocked", 0, ())
haxe_io_Error.Overflow = haxe_io_Error("Overflow", 1, ())
haxe_io_Error.OutsideBounds = haxe_io_Error("OutsideBounds", 2, ())
haxe_io_Error._hx_class = haxe_io_Error
_hx_classes["haxe.io.Error"] = haxe_io_Error


class haxe_io_Input:
    _hx_class_name = "haxe.io.Input"
    __slots__ = ("bigEndian",)
    _hx_fields = ["bigEndian"]
    _hx_methods = ["readByte", "readBytes", "set_bigEndian", "readAll"]

    def readByte(self):
        raise haxe_exceptions_NotImplementedException(None,None,_hx_AnonObject({'fileName': "haxe/io/Input.hx", 'lineNumber': 53, 'className': "haxe.io.Input", 'methodName': "readByte"}))

    def readBytes(self,s,pos,_hx_len):
        k = _hx_len
        b = s.b
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > s.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        try:
            while (k > 0):
                b[pos] = self.readByte()
                pos = (pos + 1)
                k = (k - 1)
        except BaseException as _g:
            if (not Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof)):
                raise _g
        return (_hx_len - k)

    def set_bigEndian(self,b):
        self.bigEndian = b
        return b

    def readAll(self,bufsize = None):
        if (bufsize is None):
            bufsize = 16384
        buf = haxe_io_Bytes.alloc(bufsize)
        total = haxe_io_BytesBuffer()
        try:
            while True:
                _hx_len = self.readBytes(buf,0,bufsize)
                if (_hx_len == 0):
                    raise haxe_Exception.thrown(haxe_io_Error.Blocked)
                if ((_hx_len < 0) or ((_hx_len > buf.length))):
                    raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
                total.b.extend(buf.b[0:_hx_len])
        except BaseException as _g:
            if (not Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof)):
                raise _g
        return total.getBytes()

haxe_io_Input._hx_class = haxe_io_Input
_hx_classes["haxe.io.Input"] = haxe_io_Input


class haxe_io_Path:
    _hx_class_name = "haxe.io.Path"
    __slots__ = ()
    _hx_statics = ["join", "normalize", "addTrailingSlash", "isAbsolute"]

    @staticmethod
    def join(paths):
        def _hx_local_0(s):
            if (s is not None):
                return (s != "")
            else:
                return False
        paths1 = list(filter(_hx_local_0,paths))
        if (len(paths1) == 0):
            return ""
        path = (paths1[0] if 0 < len(paths1) else None)
        _g = 1
        _g1 = len(paths1)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            path = haxe_io_Path.addTrailingSlash(path)
            path = (("null" if path is None else path) + HxOverrides.stringOrNull((paths1[i] if i >= 0 and i < len(paths1) else None)))
        return haxe_io_Path.normalize(path)

    @staticmethod
    def normalize(path):
        slash = "/"
        _this = path.split("\\")
        path = slash.join([python_Boot.toString1(x1,'') for x1 in _this])
        if (path == slash):
            return slash
        target = []
        _g = 0
        _g1 = (list(path) if ((slash == "")) else path.split(slash))
        while (_g < len(_g1)):
            token = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            if (((token == "..") and ((len(target) > 0))) and ((python_internal_ArrayImpl._get(target, (len(target) - 1)) != ".."))):
                if (len(target) != 0):
                    target.pop()
            elif (token == ""):
                if ((len(target) > 0) or ((HxString.charCodeAt(path,0) == 47))):
                    target.append(token)
            elif (token != "."):
                target.append(token)
        tmp = slash.join([python_Boot.toString1(x1,'') for x1 in target])
        acc_b = python_lib_io_StringIO()
        colon = False
        slashes = False
        _g = 0
        _g1 = len(tmp)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            _g2 = (-1 if ((i >= len(tmp))) else ord(tmp[i]))
            _g3 = _g2
            if (_g3 == 47):
                if (not colon):
                    slashes = True
                else:
                    i1 = _g2
                    colon = False
                    if slashes:
                        acc_b.write("/")
                        slashes = False
                    acc_b.write("".join(map(chr,[i1])))
            elif (_g3 == 58):
                acc_b.write(":")
                colon = True
            else:
                i2 = _g2
                colon = False
                if slashes:
                    acc_b.write("/")
                    slashes = False
                acc_b.write("".join(map(chr,[i2])))
        return acc_b.getvalue()

    @staticmethod
    def addTrailingSlash(path):
        if (len(path) == 0):
            return "/"
        startIndex = None
        c1 = None
        if (startIndex is None):
            c1 = path.rfind("/", 0, len(path))
        else:
            i = path.rfind("/", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("/"))) if ((i == -1)) else (i + 1))
            check = path.find("/", startLeft, len(path))
            c1 = (check if (((check > i) and ((check <= startIndex)))) else i)
        startIndex = None
        c2 = None
        if (startIndex is None):
            c2 = path.rfind("\\", 0, len(path))
        else:
            i = path.rfind("\\", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("\\"))) if ((i == -1)) else (i + 1))
            check = path.find("\\", startLeft, len(path))
            c2 = (check if (((check > i) and ((check <= startIndex)))) else i)
        if (c1 < c2):
            if (c2 != ((len(path) - 1))):
                return (("null" if path is None else path) + "\\")
            else:
                return path
        elif (c1 != ((len(path) - 1))):
            return (("null" if path is None else path) + "/")
        else:
            return path

    @staticmethod
    def isAbsolute(path):
        if path.startswith("/"):
            return True
        if ((("" if ((1 >= len(path))) else path[1])) == ":"):
            return True
        if path.startswith("\\\\"):
            return True
        return False
haxe_io_Path._hx_class = haxe_io_Path
_hx_classes["haxe.io.Path"] = haxe_io_Path


class haxe_iterators_ArrayIterator:
    _hx_class_name = "haxe.iterators.ArrayIterator"
    __slots__ = ("array", "current")
    _hx_fields = ["array", "current"]
    _hx_methods = ["hasNext", "next"]

    def __init__(self,array):
        self.current = 0
        self.array = array

    def hasNext(self):
        return (self.current < len(self.array))

    def next(self):
        def _hx_local_3():
            def _hx_local_2():
                _hx_local_0 = self
                _hx_local_1 = _hx_local_0.current
                _hx_local_0.current = (_hx_local_1 + 1)
                return _hx_local_1
            return python_internal_ArrayImpl._get(self.array, _hx_local_2())
        return _hx_local_3()

haxe_iterators_ArrayIterator._hx_class = haxe_iterators_ArrayIterator
_hx_classes["haxe.iterators.ArrayIterator"] = haxe_iterators_ArrayIterator


class haxe_iterators_ArrayKeyValueIterator:
    _hx_class_name = "haxe.iterators.ArrayKeyValueIterator"
    __slots__ = ("current", "array")
    _hx_fields = ["current", "array"]
    _hx_methods = ["hasNext", "next"]

    def __init__(self,array):
        self.current = 0
        self.array = array

    def hasNext(self):
        return (self.current < len(self.array))

    def next(self):
        def _hx_local_3():
            def _hx_local_2():
                _hx_local_0 = self
                _hx_local_1 = _hx_local_0.current
                _hx_local_0.current = (_hx_local_1 + 1)
                return _hx_local_1
            return _hx_AnonObject({'value': python_internal_ArrayImpl._get(self.array, self.current), 'key': _hx_local_2()})
        return _hx_local_3()

haxe_iterators_ArrayKeyValueIterator._hx_class = haxe_iterators_ArrayKeyValueIterator
_hx_classes["haxe.iterators.ArrayKeyValueIterator"] = haxe_iterators_ArrayKeyValueIterator


class haxe_xml_XmlParserException:
    _hx_class_name = "haxe.xml.XmlParserException"
    __slots__ = ("message", "lineNumber", "positionAtLine", "position", "xml")
    _hx_fields = ["message", "lineNumber", "positionAtLine", "position", "xml"]
    _hx_methods = ["toString"]

    def __init__(self,message,xml,position):
        self.xml = xml
        self.message = message
        self.position = position
        self.lineNumber = 1
        self.positionAtLine = 0
        _g = 0
        _g1 = position
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            c = (-1 if ((i >= len(xml))) else ord(xml[i]))
            if (c == 10):
                _hx_local_0 = self
                _hx_local_1 = _hx_local_0.lineNumber
                _hx_local_0.lineNumber = (_hx_local_1 + 1)
                _hx_local_1
                self.positionAtLine = 0
            elif (c != 13):
                _hx_local_2 = self
                _hx_local_3 = _hx_local_2.positionAtLine
                _hx_local_2.positionAtLine = (_hx_local_3 + 1)
                _hx_local_3

    def toString(self):
        return ((((((HxOverrides.stringOrNull(Type.getClassName(Type.getClass(self))) + ": ") + HxOverrides.stringOrNull(self.message)) + " at line ") + Std.string(self.lineNumber)) + " char ") + Std.string(self.positionAtLine))

haxe_xml_XmlParserException._hx_class = haxe_xml_XmlParserException
_hx_classes["haxe.xml.XmlParserException"] = haxe_xml_XmlParserException


class haxe_xml_Parser:
    _hx_class_name = "haxe.xml.Parser"
    __slots__ = ()
    _hx_statics = ["escapes", "parse", "doParse"]

    @staticmethod
    def parse(_hx_str,strict = None):
        if (strict is None):
            strict = False
        doc = Xml.createDocument()
        haxe_xml_Parser.doParse(_hx_str,strict,0,doc)
        return doc

    @staticmethod
    def doParse(_hx_str,strict,p = None,parent = None):
        if (p is None):
            p = 0
        xml = None
        state = 1
        next = 1
        aname = None
        start = 0
        nsubs = 0
        nbrackets = 0
        buf = StringBuf()
        escapeNext = 1
        attrValQuote = -1
        while (p < len(_hx_str)):
            c = ord(_hx_str[p])
            state1 = state
            if (state1 == 0):
                c1 = c
                if ((((c1 == 32) or ((c1 == 13))) or ((c1 == 10))) or ((c1 == 9))):
                    pass
                else:
                    state = next
                    continue
            elif (state1 == 1):
                if (c == 60):
                    state = 0
                    next = 2
                else:
                    start = p
                    state = 13
                    continue
            elif (state1 == 2):
                c2 = c
                if (c2 == 33):
                    index = (p + 1)
                    if (((-1 if ((index >= len(_hx_str))) else ord(_hx_str[index]))) == 91):
                        p = (p + 2)
                        if (HxString.substr(_hx_str,p,6).upper() != "CDATA["):
                            raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected <![CDATA[",_hx_str,p))
                        p = (p + 5)
                        state = 17
                        start = (p + 1)
                    else:
                        tmp = None
                        index1 = (p + 1)
                        if (((-1 if ((index1 >= len(_hx_str))) else ord(_hx_str[index1]))) != 68):
                            index2 = (p + 1)
                            tmp = (((-1 if ((index2 >= len(_hx_str))) else ord(_hx_str[index2]))) == 100)
                        else:
                            tmp = True
                        if tmp:
                            if (HxString.substr(_hx_str,(p + 2),6).upper() != "OCTYPE"):
                                raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected <!DOCTYPE",_hx_str,p))
                            p = (p + 8)
                            state = 16
                            start = (p + 1)
                        else:
                            tmp1 = None
                            index3 = (p + 1)
                            if (((-1 if ((index3 >= len(_hx_str))) else ord(_hx_str[index3]))) == 45):
                                index4 = (p + 2)
                                tmp1 = (((-1 if ((index4 >= len(_hx_str))) else ord(_hx_str[index4]))) != 45)
                            else:
                                tmp1 = True
                            if tmp1:
                                raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected <!--",_hx_str,p))
                            else:
                                p = (p + 2)
                                state = 15
                                start = (p + 1)
                elif (c2 == 47):
                    if (parent is None):
                        raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected node name",_hx_str,p))
                    start = (p + 1)
                    state = 0
                    next = 10
                elif (c2 == 63):
                    state = 14
                    start = p
                else:
                    state = 3
                    start = p
                    continue
            elif (state1 == 3):
                if (not (((((((((c >= 97) and ((c <= 122))) or (((c >= 65) and ((c <= 90))))) or (((c >= 48) and ((c <= 57))))) or ((c == 58))) or ((c == 46))) or ((c == 95))) or ((c == 45))))):
                    if (p == start):
                        raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected node name",_hx_str,p))
                    xml = Xml.createElement(HxString.substr(_hx_str,start,(p - start)))
                    parent.addChild(xml)
                    nsubs = (nsubs + 1)
                    state = 0
                    next = 4
                    continue
            elif (state1 == 4):
                c3 = c
                if (c3 == 47):
                    state = 11
                elif (c3 == 62):
                    state = 9
                else:
                    state = 5
                    start = p
                    continue
            elif (state1 == 5):
                if (not (((((((((c >= 97) and ((c <= 122))) or (((c >= 65) and ((c <= 90))))) or (((c >= 48) and ((c <= 57))))) or ((c == 58))) or ((c == 46))) or ((c == 95))) or ((c == 45))))):
                    if (start == p):
                        raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected attribute name",_hx_str,p))
                    tmp2 = HxString.substr(_hx_str,start,(p - start))
                    aname = tmp2
                    if xml.exists(aname):
                        raise haxe_Exception.thrown(haxe_xml_XmlParserException((("Duplicate attribute [" + ("null" if aname is None else aname)) + "]"),_hx_str,p))
                    state = 0
                    next = 6
                    continue
            elif (state1 == 6):
                if (c == 61):
                    state = 0
                    next = 7
                else:
                    raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected =",_hx_str,p))
            elif (state1 == 7):
                c4 = c
                if ((c4 == 39) or ((c4 == 34))):
                    buf = StringBuf()
                    state = 8
                    start = (p + 1)
                    attrValQuote = c
                else:
                    raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected \"",_hx_str,p))
            elif (state1 == 8):
                c5 = c
                if (c5 == 38):
                    _hx_len = (p - start)
                    s = (HxString.substr(_hx_str,start,None) if ((_hx_len is None)) else HxString.substr(_hx_str,start,_hx_len))
                    buf.b.write(s)
                    state = 18
                    escapeNext = 8
                    start = (p + 1)
                elif ((c5 == 62) or ((c5 == 60))):
                    if strict:
                        raise haxe_Exception.thrown(haxe_xml_XmlParserException((("Invalid unescaped " + HxOverrides.stringOrNull("".join(map(chr,[c])))) + " in attribute value"),_hx_str,p))
                    elif (c == attrValQuote):
                        len1 = (p - start)
                        s1 = (HxString.substr(_hx_str,start,None) if ((len1 is None)) else HxString.substr(_hx_str,start,len1))
                        buf.b.write(s1)
                        val = buf.b.getvalue()
                        buf = StringBuf()
                        xml.set(aname,val)
                        state = 0
                        next = 4
                elif (c == attrValQuote):
                    len2 = (p - start)
                    s2 = (HxString.substr(_hx_str,start,None) if ((len2 is None)) else HxString.substr(_hx_str,start,len2))
                    buf.b.write(s2)
                    val1 = buf.b.getvalue()
                    buf = StringBuf()
                    xml.set(aname,val1)
                    state = 0
                    next = 4
            elif (state1 == 9):
                p = haxe_xml_Parser.doParse(_hx_str,strict,p,xml)
                start = p
                state = 1
            elif (state1 == 10):
                if (not (((((((((c >= 97) and ((c <= 122))) or (((c >= 65) and ((c <= 90))))) or (((c >= 48) and ((c <= 57))))) or ((c == 58))) or ((c == 46))) or ((c == 95))) or ((c == 45))))):
                    if (start == p):
                        raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected node name",_hx_str,p))
                    v = HxString.substr(_hx_str,start,(p - start))
                    if ((parent is None) or ((parent.nodeType != 0))):
                        raise haxe_Exception.thrown(haxe_xml_XmlParserException((("Unexpected </" + ("null" if v is None else v)) + ">, tag is not open"),_hx_str,p))
                    if (parent.nodeType != Xml.Element):
                        raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((parent.nodeType is None)) else _Xml_XmlType_Impl_.toString(parent.nodeType))))))
                    if (v != parent.nodeName):
                        if (parent.nodeType != Xml.Element):
                            raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((parent.nodeType is None)) else _Xml_XmlType_Impl_.toString(parent.nodeType))))))
                        raise haxe_Exception.thrown(haxe_xml_XmlParserException((("Expected </" + HxOverrides.stringOrNull(parent.nodeName)) + ">"),_hx_str,p))
                    state = 0
                    next = 12
                    continue
            elif (state1 == 11):
                if (c == 62):
                    state = 1
                else:
                    raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected >",_hx_str,p))
            elif (state1 == 12):
                if (c == 62):
                    if (nsubs == 0):
                        parent.addChild(Xml.createPCData(""))
                    return p
                else:
                    raise haxe_Exception.thrown(haxe_xml_XmlParserException("Expected >",_hx_str,p))
            elif (state1 == 13):
                if (c == 60):
                    len3 = (p - start)
                    s3 = (HxString.substr(_hx_str,start,None) if ((len3 is None)) else HxString.substr(_hx_str,start,len3))
                    buf.b.write(s3)
                    child = Xml.createPCData(buf.b.getvalue())
                    buf = StringBuf()
                    parent.addChild(child)
                    nsubs = (nsubs + 1)
                    state = 0
                    next = 2
                elif (c == 38):
                    len4 = (p - start)
                    s4 = (HxString.substr(_hx_str,start,None) if ((len4 is None)) else HxString.substr(_hx_str,start,len4))
                    buf.b.write(s4)
                    state = 18
                    escapeNext = 13
                    start = (p + 1)
            elif (state1 == 14):
                tmp3 = None
                if (c == 63):
                    index5 = (p + 1)
                    tmp3 = (((-1 if ((index5 >= len(_hx_str))) else ord(_hx_str[index5]))) == 62)
                else:
                    tmp3 = False
                if tmp3:
                    p = (p + 1)
                    str1 = HxString.substr(_hx_str,(start + 1),((p - start) - 2))
                    parent.addChild(Xml.createProcessingInstruction(str1))
                    nsubs = (nsubs + 1)
                    state = 1
            elif (state1 == 15):
                tmp4 = None
                tmp5 = None
                if (c == 45):
                    index6 = (p + 1)
                    tmp5 = (((-1 if ((index6 >= len(_hx_str))) else ord(_hx_str[index6]))) == 45)
                else:
                    tmp5 = False
                if tmp5:
                    index7 = (p + 2)
                    tmp4 = (((-1 if ((index7 >= len(_hx_str))) else ord(_hx_str[index7]))) == 62)
                else:
                    tmp4 = False
                if tmp4:
                    parent.addChild(Xml.createComment(HxString.substr(_hx_str,start,(p - start))))
                    nsubs = (nsubs + 1)
                    p = (p + 2)
                    state = 1
            elif (state1 == 16):
                if (c == 91):
                    nbrackets = (nbrackets + 1)
                elif (c == 93):
                    nbrackets = (nbrackets - 1)
                elif ((c == 62) and ((nbrackets == 0))):
                    parent.addChild(Xml.createDocType(HxString.substr(_hx_str,start,(p - start))))
                    nsubs = (nsubs + 1)
                    state = 1
            elif (state1 == 17):
                tmp6 = None
                tmp7 = None
                if (c == 93):
                    index8 = (p + 1)
                    tmp7 = (((-1 if ((index8 >= len(_hx_str))) else ord(_hx_str[index8]))) == 93)
                else:
                    tmp7 = False
                if tmp7:
                    index9 = (p + 2)
                    tmp6 = (((-1 if ((index9 >= len(_hx_str))) else ord(_hx_str[index9]))) == 62)
                else:
                    tmp6 = False
                if tmp6:
                    child1 = Xml.createCData(HxString.substr(_hx_str,start,(p - start)))
                    parent.addChild(child1)
                    nsubs = (nsubs + 1)
                    p = (p + 2)
                    state = 1
            elif (state1 == 18):
                if (c == 59):
                    s5 = HxString.substr(_hx_str,start,(p - start))
                    if (((-1 if ((0 >= len(s5))) else ord(s5[0]))) == 35):
                        c6 = (Std.parseInt(("0" + HxOverrides.stringOrNull(HxString.substr(s5,1,(len(s5) - 1))))) if ((((-1 if ((1 >= len(s5))) else ord(s5[1]))) == 120)) else Std.parseInt(HxString.substr(s5,1,(len(s5) - 1))))
                        s6 = "".join(map(chr,[c6]))
                        buf.b.write(s6)
                    elif (not (s5 in haxe_xml_Parser.escapes.h)):
                        if strict:
                            raise haxe_Exception.thrown(haxe_xml_XmlParserException(("Undefined entity: " + ("null" if s5 is None else s5)),_hx_str,p))
                        s7 = Std.string((("&" + ("null" if s5 is None else s5)) + ";"))
                        buf.b.write(s7)
                    else:
                        s8 = Std.string(haxe_xml_Parser.escapes.h.get(s5,None))
                        buf.b.write(s8)
                    start = (p + 1)
                    state = escapeNext
                elif ((not (((((((((c >= 97) and ((c <= 122))) or (((c >= 65) and ((c <= 90))))) or (((c >= 48) and ((c <= 57))))) or ((c == 58))) or ((c == 46))) or ((c == 95))) or ((c == 45))))) and ((c != 35))):
                    if strict:
                        raise haxe_Exception.thrown(haxe_xml_XmlParserException(("Invalid character in entity: " + HxOverrides.stringOrNull("".join(map(chr,[c])))),_hx_str,p))
                    s9 = "".join(map(chr,[38]))
                    buf.b.write(s9)
                    len5 = (p - start)
                    s10 = (HxString.substr(_hx_str,start,None) if ((len5 is None)) else HxString.substr(_hx_str,start,len5))
                    buf.b.write(s10)
                    p = (p - 1)
                    start = (p + 1)
                    state = escapeNext
            else:
                pass
            p = (p + 1)
        if (state == 1):
            start = p
            state = 13
        if (state == 13):
            if (parent.nodeType == 0):
                if (parent.nodeType != Xml.Element):
                    raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((parent.nodeType is None)) else _Xml_XmlType_Impl_.toString(parent.nodeType))))))
                raise haxe_Exception.thrown(haxe_xml_XmlParserException((("Unclosed node <" + HxOverrides.stringOrNull(parent.nodeName)) + ">"),_hx_str,p))
            if ((p != start) or ((nsubs == 0))):
                _hx_len = (p - start)
                s = (HxString.substr(_hx_str,start,None) if ((_hx_len is None)) else HxString.substr(_hx_str,start,_hx_len))
                buf.b.write(s)
                parent.addChild(Xml.createPCData(buf.b.getvalue()))
                nsubs = (nsubs + 1)
            return p
        if (((not strict) and ((state == 18))) and ((escapeNext == 13))):
            s = "".join(map(chr,[38]))
            buf.b.write(s)
            _hx_len = (p - start)
            s = (HxString.substr(_hx_str,start,None) if ((_hx_len is None)) else HxString.substr(_hx_str,start,_hx_len))
            buf.b.write(s)
            parent.addChild(Xml.createPCData(buf.b.getvalue()))
            nsubs = (nsubs + 1)
            return p
        raise haxe_Exception.thrown(haxe_xml_XmlParserException("Unexpected end",_hx_str,p))
haxe_xml_Parser._hx_class = haxe_xml_Parser
_hx_classes["haxe.xml.Parser"] = haxe_xml_Parser


class haxe_xml_Printer:
    _hx_class_name = "haxe.xml.Printer"
    __slots__ = ("output", "pretty")
    _hx_fields = ["output", "pretty"]
    _hx_methods = ["writeNode", "hasChildren"]
    _hx_statics = ["print"]

    def __init__(self,pretty):
        self.output = StringBuf()
        self.pretty = pretty

    def writeNode(self,value,tabs):
        _g = value.nodeType
        if (_g == 0):
            _this = self.output
            s = Std.string((("null" if tabs is None else tabs) + "<"))
            _this.b.write(s)
            if (value.nodeType != Xml.Element):
                raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
            _this = self.output
            s = Std.string(value.nodeName)
            _this.b.write(s)
            attribute = value.attributes()
            while attribute.hasNext():
                attribute1 = attribute.next()
                _this = self.output
                s = Std.string(((" " + ("null" if attribute1 is None else attribute1)) + "=\""))
                _this.b.write(s)
                input = StringTools.htmlEscape(value.get(attribute1),True)
                _this1 = self.output
                s1 = Std.string(input)
                _this1.b.write(s1)
                self.output.b.write("\"")
            if self.hasChildren(value):
                self.output.b.write(">")
                if self.pretty:
                    self.output.b.write("\n")
                if ((value.nodeType != Xml.Document) and ((value.nodeType != Xml.Element))):
                    raise haxe_Exception.thrown(("Bad node type, expected Element or Document but found " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
                _g_current = 0
                _g_array = value.children
                while (_g_current < len(_g_array)):
                    child = _g_current
                    _g_current = (_g_current + 1)
                    child1 = (_g_array[child] if child >= 0 and child < len(_g_array) else None)
                    self.writeNode(child1,((("null" if tabs is None else tabs) + "\t") if (self.pretty) else tabs))
                _this = self.output
                s = Std.string((("null" if tabs is None else tabs) + "</"))
                _this.b.write(s)
                if (value.nodeType != Xml.Element):
                    raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
                _this = self.output
                s = Std.string(value.nodeName)
                _this.b.write(s)
                self.output.b.write(">")
                if self.pretty:
                    self.output.b.write("\n")
            else:
                self.output.b.write("/>")
                if self.pretty:
                    self.output.b.write("\n")
        elif (_g == 1):
            if ((value.nodeType == Xml.Document) or ((value.nodeType == Xml.Element))):
                raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
            nodeValue = value.nodeValue
            if (len(nodeValue) != 0):
                input = (("null" if tabs is None else tabs) + HxOverrides.stringOrNull(StringTools.htmlEscape(nodeValue)))
                _this = self.output
                s = Std.string(input)
                _this.b.write(s)
                if self.pretty:
                    self.output.b.write("\n")
        elif (_g == 2):
            _this = self.output
            s = Std.string((("null" if tabs is None else tabs) + "<![CDATA["))
            _this.b.write(s)
            if ((value.nodeType == Xml.Document) or ((value.nodeType == Xml.Element))):
                raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
            _this = self.output
            s = Std.string(value.nodeValue)
            _this.b.write(s)
            self.output.b.write("]]>")
            if self.pretty:
                self.output.b.write("\n")
        elif (_g == 3):
            if ((value.nodeType == Xml.Document) or ((value.nodeType == Xml.Element))):
                raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
            commentContent = value.nodeValue
            commentContent = EReg("[\n\r\t]+","g").replace(commentContent,"")
            commentContent = (("<!--" + ("null" if commentContent is None else commentContent)) + "-->")
            _this = self.output
            s = Std.string(tabs)
            _this.b.write(s)
            input = StringTools.trim(commentContent)
            _this = self.output
            s = Std.string(input)
            _this.b.write(s)
            if self.pretty:
                self.output.b.write("\n")
        elif (_g == 4):
            if ((value.nodeType == Xml.Document) or ((value.nodeType == Xml.Element))):
                raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
            _this = self.output
            s = Std.string((("<!DOCTYPE " + HxOverrides.stringOrNull(value.nodeValue)) + ">"))
            _this.b.write(s)
            if self.pretty:
                self.output.b.write("\n")
        elif (_g == 5):
            if ((value.nodeType == Xml.Document) or ((value.nodeType == Xml.Element))):
                raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
            _this = self.output
            s = Std.string((("<?" + HxOverrides.stringOrNull(value.nodeValue)) + "?>"))
            _this.b.write(s)
            if self.pretty:
                self.output.b.write("\n")
        elif (_g == 6):
            if ((value.nodeType != Xml.Document) and ((value.nodeType != Xml.Element))):
                raise haxe_Exception.thrown(("Bad node type, expected Element or Document but found " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
            _g_current = 0
            _g_array = value.children
            while (_g_current < len(_g_array)):
                child = _g_current
                _g_current = (_g_current + 1)
                child1 = (_g_array[child] if child >= 0 and child < len(_g_array) else None)
                self.writeNode(child1,tabs)
        else:
            pass

    def hasChildren(self,value):
        if ((value.nodeType != Xml.Document) and ((value.nodeType != Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, expected Element or Document but found " + HxOverrides.stringOrNull((("null" if ((value.nodeType is None)) else _Xml_XmlType_Impl_.toString(value.nodeType))))))
        _g_current = 0
        _g_array = value.children
        while (_g_current < len(_g_array)):
            child = _g_current
            _g_current = (_g_current + 1)
            child1 = (_g_array[child] if child >= 0 and child < len(_g_array) else None)
            _g = child1.nodeType
            if ((_g == 1) or ((_g == 0))):
                return True
            elif ((_g == 3) or ((_g == 2))):
                if ((child1.nodeType == Xml.Document) or ((child1.nodeType == Xml.Element))):
                    raise haxe_Exception.thrown(("Bad node type, unexpected " + HxOverrides.stringOrNull((("null" if ((child1.nodeType is None)) else _Xml_XmlType_Impl_.toString(child1.nodeType))))))
                if (len(StringTools.ltrim(child1.nodeValue)) != 0):
                    return True
            else:
                pass
        return False

    @staticmethod
    def print(xml,pretty = None):
        if (pretty is None):
            pretty = False
        printer = haxe_xml_Printer(pretty)
        printer.writeNode(xml,"")
        return printer.output.b.getvalue()

haxe_xml_Printer._hx_class = haxe_xml_Printer
_hx_classes["haxe.xml.Printer"] = haxe_xml_Printer


class hxml_UpdateHxml:
    _hx_class_name = "hxml.UpdateHxml"
    __slots__ = ()
    _hx_statics = ["haxelibPath", "update", "readHaxelibVersion", "readHaxelibVersionData"]

    @staticmethod
    def update(path):
        p = sys_io_Process("haxelib config")
        hxml_UpdateHxml.haxelibPath = p.stdout.readAll().toString()
        hxml_UpdateHxml.haxelibPath = StringTools.replace(hxml_UpdateHxml.haxelibPath,"\n","")
        hxml_UpdateHxml.haxelibPath = StringTools.replace(hxml_UpdateHxml.haxelibPath,"\r","")
        haxe_Log.trace(("Haxelib path = " + HxOverrides.stringOrNull(hxml_UpdateHxml.haxelibPath)),_hx_AnonObject({'fileName': "src/hxml/UpdateHxml.hx", 'lineNumber': 21, 'className': "hxml.UpdateHxml", 'methodName': "update"}))
        haxe_Log.trace(("read path = " + ("null" if path is None else path)),_hx_AnonObject({'fileName': "src/hxml/UpdateHxml.hx", 'lineNumber': 22, 'className': "hxml.UpdateHxml", 'methodName': "update"}))
        hxml = sys_io_File.getContent(path)
        lines = hxml.split("\n")
        hxmlContent = ""
        _g = 0
        while (_g < len(lines)):
            data = (lines[_g] if _g >= 0 and _g < len(lines) else None)
            _g = (_g + 1)
            startIndex = None
            if (((data.find("-D") if ((startIndex is None)) else HxString.indexOfImpl(data,"-D",startIndex))) != -1):
                data = HxString.substr(data,3,None)
                currentLib = data.split("=")
                value = hxml_UpdateHxml.readHaxelibVersion((currentLib[0] if 0 < len(currentLib) else None))
                if (value is not None):
                    haxe_Log.trace(((("update lib " + HxOverrides.stringOrNull((currentLib[0] if 0 < len(currentLib) else None))) + " = ") + ("null" if value is None else value)),_hx_AnonObject({'fileName': "src/hxml/UpdateHxml.hx", 'lineNumber': 33, 'className': "hxml.UpdateHxml", 'methodName': "update"}))
                    python_internal_ArrayImpl._set(currentLib, 1, value)
                hxmlContent = (("null" if hxmlContent is None else hxmlContent) + HxOverrides.stringOrNull(((("-D " + HxOverrides.stringOrNull("=".join([python_Boot.toString1(x1,'') for x1 in currentLib]))) + "\n"))))
            else:
                startIndex1 = None
                if (((data.find("-cp") if ((startIndex1 is None)) else HxString.indexOfImpl(data,"-cp",startIndex1))) != -1):
                    currentLib1 = data.split("/")
                    value1 = None
                    index = 0
                    _g1 = 1
                    while (_g1 < 4):
                        i = _g1
                        _g1 = (_g1 + 1)
                        value1 = hxml_UpdateHxml.readHaxelibVersion(python_internal_ArrayImpl._get(currentLib1, (len(currentLib1) - i)))
                        if (value1 is not None):
                            index = i
                            break
                    if (value1 is not None):
                        versoinData = python_internal_ArrayImpl._get(currentLib1, ((len(currentLib1) - index) + 1))
                        tmp = None
                        if (versoinData is None):
                            startIndex2 = None
                            tmp = (((versoinData.find(",") if ((startIndex2 is None)) else HxString.indexOfImpl(versoinData,",",startIndex2))) != -1)
                        else:
                            tmp = True
                        if tmp:
                            python_internal_ArrayImpl._set(currentLib1, ((len(currentLib1) - index) + 1), StringTools.replace(value1,".",","))
                    hxmlContent = (("null" if hxmlContent is None else hxmlContent) + HxOverrides.stringOrNull(((HxOverrides.stringOrNull("/".join([python_Boot.toString1(x1,'') for x1 in currentLib1])) + "\n"))))
                else:
                    hxmlContent = (("null" if hxmlContent is None else hxmlContent) + HxOverrides.stringOrNull(((("null" if data is None else data) + "\n"))))
        sys_io_File.saveContent(path,hxmlContent)

    @staticmethod
    def readHaxelibVersion(libname):
        if sys_FileSystem.exists((HxOverrides.stringOrNull(hxml_UpdateHxml.haxelibPath) + ("null" if libname is None else libname))):
            if sys_FileSystem.exists(((HxOverrides.stringOrNull(hxml_UpdateHxml.haxelibPath) + ("null" if libname is None else libname)) + "/haxelib.json")):
                return hxml_UpdateHxml.readHaxelibVersionData(((HxOverrides.stringOrNull(hxml_UpdateHxml.haxelibPath) + ("null" if libname is None else libname)) + "/haxelib.json"))
            elif sys_FileSystem.exists(((HxOverrides.stringOrNull(hxml_UpdateHxml.haxelibPath) + ("null" if libname is None else libname)) + "/.current")):
                currentVersion = sys_io_File.getContent(((HxOverrides.stringOrNull(hxml_UpdateHxml.haxelibPath) + ("null" if libname is None else libname)) + "/.current"))
                if sys_FileSystem.exists(((((HxOverrides.stringOrNull(hxml_UpdateHxml.haxelibPath) + ("null" if libname is None else libname)) + "/") + ("null" if currentVersion is None else currentVersion)) + "/haxelib.json")):
                    return hxml_UpdateHxml.readHaxelibVersionData(((((HxOverrides.stringOrNull(hxml_UpdateHxml.haxelibPath) + ("null" if libname is None else libname)) + "/") + ("null" if currentVersion is None else currentVersion)) + "/haxelib.json"))
        return None

    @staticmethod
    def readHaxelibVersionData(path):
        data = python_lib_Json.loads(sys_io_File.getContent(path),**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'object_hook': python_Lib.dictToAnon})))
        return data.version
hxml_UpdateHxml._hx_class = hxml_UpdateHxml
_hx_classes["hxml.UpdateHxml"] = hxml_UpdateHxml


class mini_MiniEngineBuild:
    _hx_class_name = "mini.MiniEngineBuild"
    __slots__ = ()
    _hx_statics = ["build"]

    @staticmethod
    def build(path):
        haxe_Log.trace(("build miniengine target = " + ("null" if path is None else path)),_hx_AnonObject({'fileName': "src/mini/MiniEngineBuild.hx", 'lineNumber': 11, 'className': "mini.MiniEngineBuild", 'methodName': "build"}))
        startIndex = None
        if (((path.find(".hx") if ((startIndex is None)) else HxString.indexOfImpl(path,".hx",startIndex))) == -1):
            Sys.setCwd(path)
        else:
            Sys.setCwd(python_internal_ArrayImpl._get(Sys.args(), (len(Sys.args()) - 1)))
        if sys_FileSystem.exists("build"):
            python_FileUtils.removeDic("build")
        if sys_FileSystem.exists("dist.zip"):
            sys_FileSystem.deleteFile("dist.zip")
        sys_FileSystem.createDirectory("build")
        python_FileUtils.copyDic("Source","build/")
        python_FileUtils.copyDic("Assets","build/")
        python_FileUtils.copyDic("Sound/mp3","build/")
        Sys.command("zip -q -r -m -o dist.zip build")
        if (python_internal_ArrayImpl._get(Sys.args(), 2) == "-o"):
            sys_io_File.copy("dist.zip",python_internal_ArrayImpl._get(Sys.args(), 3))
mini_MiniEngineBuild._hx_class = mini_MiniEngineBuild
_hx_classes["mini.MiniEngineBuild"] = mini_MiniEngineBuild


class pkg_PkgTools:
    _hx_class_name = "pkg.PkgTools"
    __slots__ = ()
    _hx_statics = ["build", "copyPkg", "copyTemplate", "copySource", "copyAssets"]

    @staticmethod
    def build():
        haxe_Log.trace("打包参数：",_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 12, 'className': "pkg.PkgTools", 'methodName': "build", 'customParams': [Sys.args()]}))
        projectDir = python_internal_ArrayImpl._get(Sys.args(), 1)
        path = (("null" if projectDir is None else projectDir) + "/zproject.xml")
        if (not sys_FileSystem.exists(path)):
            raise haxe_Exception.thrown("项目不存在zproject.xml")
        pkgDir = (("null" if projectDir is None else projectDir) + "/Export/pkg")
        python_FileUtils.removeDic(pkgDir)
        python_FileUtils.createDir(pkgDir)
        zproject = pkg_ZProjectData(path)
        sys_io_File.saveContent((("null" if pkgDir is None else pkgDir) + "/zproject.xml"),(("<project><haxedef name='pkgtools'/>" + HxOverrides.stringOrNull(zproject.getData())) + "</project>"))
        pkg_PkgTools.copyAssets(zproject)
        pkg_PkgTools.copyTemplate(zproject)
        pkg_PkgTools.copyPkg(zproject)
        pkg_PkgTools.copySource(zproject)
        if sys_FileSystem.exists((("null" if projectDir is None else projectDir) + "/pkgtools.json")):
            sys_io_File.copy((("null" if projectDir is None else projectDir) + "/pkgtools.json"),(("null" if pkgDir is None else pkgDir) + "/pkgtools.json"))
        haxe_Log.trace("############## 启动编译检查 ##############",_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 36, 'className': "pkg.PkgTools", 'methodName': "build"}))
        Sys.command((("cd " + ("null" if pkgDir is None else pkgDir)) + " && haxelib run zygameui -build html5"))
        haxe_Log.trace("############## 编译检查结束 ##############",_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 39, 'className': "pkg.PkgTools", 'methodName': "build"}))
        python_FileUtils.removeDic((("null" if pkgDir is None else pkgDir) + "/Export"))
        Sys.command((("cd " + ("null" if pkgDir is None else pkgDir)) + " && zip -q -r app.zip *"))

    @staticmethod
    def copyPkg(zproject):
        projectDir = python_internal_ArrayImpl._get(Sys.args(), 1)
        _g = 0
        _g1 = zproject.pkgBind
        while (_g < len(_g1)):
            obj = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            haxe_Log.trace(("Pkg:" + HxOverrides.stringOrNull(obj.path)),_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 53, 'className': "pkg.PkgTools", 'methodName': "copyPkg"}))
            if sys_FileSystem.isDirectory(obj.path):
                files = sys_FileSystem.readDirectory(obj.path)
                _g2 = 0
                while (_g2 < len(files)):
                    file = (files[_g2] if _g2 >= 0 and _g2 < len(files) else None)
                    _g2 = (_g2 + 1)
                    if sys_FileSystem.isDirectory(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file))):
                        python_FileUtils.copyDic(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file)),((("null" if projectDir is None else projectDir) + "/Export/pkg/") + HxOverrides.stringOrNull(obj.copyTo)))
                    else:
                        python_FileUtils.copyFile(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file)),((((("null" if projectDir is None else projectDir) + "/Export/pkg/") + HxOverrides.stringOrNull(obj.copyTo)) + "/") + ("null" if file is None else file)))
            else:
                python_FileUtils.copyFile(obj.path,((("null" if projectDir is None else projectDir) + "/Export/pkg/") + HxOverrides.stringOrNull(obj.copyTo)))
            haxe_Log.trace(((("null" if projectDir is None else projectDir) + "/") + HxOverrides.stringOrNull(obj.copyTo)),_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 65, 'className': "pkg.PkgTools", 'methodName': "copyPkg"}))
        _g = 0
        _g1 = zproject.includes
        while (_g < len(_g1)):
            i = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            pkg_PkgTools.copyPkg(i)

    @staticmethod
    def copyTemplate(zproject):
        projectDir = python_internal_ArrayImpl._get(Sys.args(), 1)
        _g = 0
        _g1 = zproject.templateBind
        while (_g < len(_g1)):
            obj = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            haxe_Log.trace(("Template:" + HxOverrides.stringOrNull(obj.path)),_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 79, 'className': "pkg.PkgTools", 'methodName': "copyTemplate"}))
            if sys_FileSystem.isDirectory(obj.path):
                files = sys_FileSystem.readDirectory(obj.path)
                _g2 = 0
                while (_g2 < len(files)):
                    file = (files[_g2] if _g2 >= 0 and _g2 < len(files) else None)
                    _g2 = (_g2 + 1)
                    if sys_FileSystem.isDirectory(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file))):
                        python_FileUtils.copyDic(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file)),((("null" if projectDir is None else projectDir) + "/Export/pkg/") + HxOverrides.stringOrNull(obj.copyTo)))
                    else:
                        python_FileUtils.copyFile(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file)),((((("null" if projectDir is None else projectDir) + "/Export/pkg/") + HxOverrides.stringOrNull(obj.copyTo)) + "/") + ("null" if file is None else file)))
            else:
                python_FileUtils.copyFile(obj.path,((("null" if projectDir is None else projectDir) + "/Export/pkg/") + HxOverrides.stringOrNull(obj.copyTo)))
            haxe_Log.trace(((("null" if projectDir is None else projectDir) + "/") + HxOverrides.stringOrNull(obj.copyTo)),_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 91, 'className': "pkg.PkgTools", 'methodName': "copyTemplate"}))
        _g = 0
        _g1 = zproject.includes
        while (_g < len(_g1)):
            i = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            pkg_PkgTools.copyTemplate(i)

    @staticmethod
    def copySource(zproject):
        projectDir = python_internal_ArrayImpl._get(Sys.args(), 1)
        _g = 0
        _g1 = zproject.sourceBind
        while (_g < len(_g1)):
            obj = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            haxe_Log.trace(("Source:" + HxOverrides.stringOrNull(obj.path)),_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 101, 'className': "pkg.PkgTools", 'methodName': "copySource"}))
            if sys_FileSystem.isDirectory(obj.path):
                files = sys_FileSystem.readDirectory(obj.path)
                _g2 = 0
                while (_g2 < len(files)):
                    file = (files[_g2] if _g2 >= 0 and _g2 < len(files) else None)
                    _g2 = (_g2 + 1)
                    if sys_FileSystem.isDirectory(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file))):
                        python_FileUtils.copyDic(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file)),(("null" if projectDir is None else projectDir) + "/Export/pkg/source"))
                    else:
                        python_FileUtils.copyFile(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file)),(((("null" if projectDir is None else projectDir) + "/Export/pkg/source") + "/") + ("null" if file is None else file)))
            else:
                python_FileUtils.copyFile(obj.path,(("null" if projectDir is None else projectDir) + "/Export/pkg/source"))
        _g = 0
        _g1 = zproject.includes
        while (_g < len(_g1)):
            i = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            pkg_PkgTools.copySource(i)

    @staticmethod
    def copyAssets(zproject):
        projectDir = python_internal_ArrayImpl._get(Sys.args(), 1)
        _g = 0
        _g1 = zproject.assetsBind
        while (_g < len(_g1)):
            obj = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            haxe_Log.trace(("Assets:" + HxOverrides.stringOrNull(obj.path)),_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 126, 'className': "pkg.PkgTools", 'methodName': "copyAssets"}))
            if sys_FileSystem.isDirectory(obj.path):
                files = sys_FileSystem.readDirectory(obj.path)
                _g2 = 0
                while (_g2 < len(files)):
                    file = (files[_g2] if _g2 >= 0 and _g2 < len(files) else None)
                    _g2 = (_g2 + 1)
                    if sys_FileSystem.isDirectory(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file))):
                        python_FileUtils.copyDic(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file)),((("null" if projectDir is None else projectDir) + "/Export/pkg/") + HxOverrides.stringOrNull(obj.copyTo)))
                    else:
                        python_FileUtils.copyFile(((HxOverrides.stringOrNull(obj.path) + "/") + ("null" if file is None else file)),((((("null" if projectDir is None else projectDir) + "/Export/pkg/") + HxOverrides.stringOrNull(obj.copyTo)) + "/") + ("null" if file is None else file)))
            else:
                python_FileUtils.copyFile(obj.path,((("null" if projectDir is None else projectDir) + "/Export/pkg/") + HxOverrides.stringOrNull(obj.copyTo)))
            haxe_Log.trace(((("null" if projectDir is None else projectDir) + "/") + HxOverrides.stringOrNull(obj.copyTo)),_hx_AnonObject({'fileName': "src/pkg/PkgTools.hx", 'lineNumber': 138, 'className': "pkg.PkgTools", 'methodName': "copyAssets"}))
        _g = 0
        _g1 = zproject.includes
        while (_g < len(_g1)):
            i = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            pkg_PkgTools.copyAssets(i)
pkg_PkgTools._hx_class = pkg_PkgTools
_hx_classes["pkg.PkgTools"] = pkg_PkgTools


class pkg_ZProjectData:
    _hx_class_name = "pkg.ZProjectData"
    __slots__ = ("_xml", "_changeXml", "includes", "assetsBind", "sourceBind", "templateBind", "pkgBind")
    _hx_fields = ["_xml", "_changeXml", "includes", "assetsBind", "sourceBind", "templateBind", "pkgBind"]
    _hx_methods = ["getData"]

    def __init__(self,path,xmlData = None):
        self.pkgBind = []
        self.templateBind = []
        self.sourceBind = []
        self.assetsBind = []
        self.includes = []
        self._changeXml = []
        startIndex = None
        _hx_len = None
        if (startIndex is None):
            _hx_len = path.rfind("/", 0, len(path))
        else:
            i = path.rfind("/", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("/"))) if ((i == -1)) else (i + 1))
            check = path.find("/", startLeft, len(path))
            _hx_len = (check if (((check > i) and ((check <= startIndex)))) else i)
        rootPath = HxString.substr(path,0,_hx_len)
        self._xml = Xml.parse((xmlData if ((xmlData is not None)) else sys_io_File.getContent(path)))
        _this = self._xml.firstElement()
        if ((_this.nodeType != Xml.Document) and ((_this.nodeType != Xml.Element))):
            raise haxe_Exception.thrown(("Bad node type, expected Element or Document but found " + HxOverrides.stringOrNull((("null" if ((_this.nodeType is None)) else _Xml_XmlType_Impl_.toString(_this.nodeType))))))
        item_current = 0
        item_array = _this.children
        while (item_current < len(item_array)):
            item = item_current
            item_current = (item_current + 1)
            item1 = (item_array[item] if item >= 0 and item < len(item_array) else None)
            if (item1.nodeType == 0):
                tmp = haxe_Log.trace
                tmp1 = ("null" if ((item1.nodeType is None)) else _Xml_XmlType_Impl_.toString(item1.nodeType))
                if (item1.nodeType != Xml.Element):
                    raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((item1.nodeType is None)) else _Xml_XmlType_Impl_.toString(item1.nodeType))))))
                tmp(tmp1,_hx_AnonObject({'fileName': "src/pkg/ZProjectData.hx", 'lineNumber': 39, 'className': "pkg.ZProjectData", 'methodName': "new", 'customParams': [item1.nodeName, item1]}))
                if (item1.nodeType != Xml.Element):
                    raise haxe_Exception.thrown(("Bad node type, expected Element but found " + HxOverrides.stringOrNull((("null" if ((item1.nodeType is None)) else _Xml_XmlType_Impl_.toString(item1.nodeType))))))
                _g = item1.nodeName
                _hx_local_0 = len(_g)
                if (_hx_local_0 == 7):
                    if (_g == "include"):
                        includeData = pkg_ZProjectData(((("null" if rootPath is None else rootPath) + "/") + HxOverrides.stringOrNull(item1.get("path"))))
                        attributes = []
                        itemkey = item1.attributes()
                        while itemkey.hasNext():
                            itemkey1 = itemkey.next()
                            if (itemkey1 == "path"):
                                continue
                            x1 = (((("null" if itemkey1 is None else itemkey1) + "=\"") + HxOverrides.stringOrNull(item1.get(itemkey1))) + "\"")
                            attributes.append(x1)
                        _this2 = self._changeXml
                        x2 = (((("<section " + HxOverrides.stringOrNull(" ".join([python_Boot.toString1(x1,'') for x1 in attributes]))) + ">") + HxOverrides.stringOrNull(includeData.getData())) + "</section>")
                        _this2.append(x2)
                        _this3 = self.includes
                        _this3.append(includeData)
                    elif (_g == "section"):
                        sectionData = pkg_ZProjectData(path,haxe_xml_Printer.print(item1))
                        attributes1 = []
                        itemkey2 = item1.attributes()
                        while itemkey2.hasNext():
                            itemkey3 = itemkey2.next()
                            x3 = (((("null" if itemkey3 is None else itemkey3) + "=\"") + HxOverrides.stringOrNull(item1.get(itemkey3))) + "\"")
                            attributes1.append(x3)
                        _this5 = self._changeXml
                        x4 = (((("<section " + HxOverrides.stringOrNull(" ".join([python_Boot.toString1(x1,'') for x1 in attributes1]))) + ">") + HxOverrides.stringOrNull(sectionData.getData())) + "</section>")
                        _this5.append(x4)
                    else:
                        _this9 = self._changeXml
                        x6 = haxe_xml_Printer.print(item1)
                        _this9.append(x6)
                elif (_hx_local_0 == 3):
                    if (_g == "pkg"):
                        to = (item1.get("rename") if (item1.exists("rename")) else item1.get("path"))
                        obj1 = _hx_AnonObject({'path': ((("null" if rootPath is None else rootPath) + "/") + HxOverrides.stringOrNull(item1.get("path"))), 'copyTo': to})
                        _this4 = self.pkgBind
                        _this4.append(obj1)
                    else:
                        _this9 = self._changeXml
                        x6 = haxe_xml_Printer.print(item1)
                        _this9.append(x6)
                elif (_hx_local_0 == 8):
                    if (_g == "template"):
                        obj3 = _hx_AnonObject({'path': ((("null" if rootPath is None else rootPath) + "/") + HxOverrides.stringOrNull(item1.get("path"))), 'copyTo': ("template/" + HxOverrides.stringOrNull(haxe_crypto_Md5.encode(((("null" if rootPath is None else rootPath) + "/") + HxOverrides.stringOrNull(item1.get("path"))))))})
                        _this7 = self.templateBind
                        _this7.append(obj3)
                        item1.set("path",obj3.copyTo)
                        _this8 = self._changeXml
                        x5 = haxe_xml_Printer.print(item1)
                        _this8.append(x5)
                    else:
                        _this9 = self._changeXml
                        x6 = haxe_xml_Printer.print(item1)
                        _this9.append(x6)
                elif (_hx_local_0 == 6):
                    if (_g == "assets"):
                        obj = _hx_AnonObject({'path': ((("null" if rootPath is None else rootPath) + "/") + HxOverrides.stringOrNull(item1.get("path"))), 'copyTo': ("assets/" + HxOverrides.stringOrNull(haxe_crypto_Md5.encode(((("null" if rootPath is None else rootPath) + "/") + HxOverrides.stringOrNull(item1.get("path"))))))})
                        _this = self.assetsBind
                        _this.append(obj)
                        if (not item1.exists("rename")):
                            item1.set("rename",item1.get("path"))
                        item1.set("path",obj.copyTo)
                        _this1 = self._changeXml
                        x = haxe_xml_Printer.print(item1)
                        _this1.append(x)
                    elif (_g == "source"):
                        obj2 = _hx_AnonObject({'path': ((("null" if rootPath is None else rootPath) + "/") + HxOverrides.stringOrNull(item1.get("path")))})
                        _this6 = self.sourceBind
                        _this6.append(obj2)
                    else:
                        _this9 = self._changeXml
                        x6 = haxe_xml_Printer.print(item1)
                        _this9.append(x6)
                else:
                    _this9 = self._changeXml
                    x6 = haxe_xml_Printer.print(item1)
                    _this9.append(x6)
        if (len(self.sourceBind) > 0):
            _this = self._changeXml
            _this.append("<source path=\"source\"/>")
        _this = self._changeXml
        haxe_Log.trace(("ChangeXml:\n\n" + HxOverrides.stringOrNull("\n".join([python_Boot.toString1(x1,'') for x1 in _this]))),_hx_AnonObject({'fileName': "src/pkg/ZProjectData.hx", 'lineNumber': 102, 'className': "pkg.ZProjectData", 'methodName': "new"}))

    def getData(self):
        _this = self._changeXml
        return "\n".join([python_Boot.toString1(x1,'') for x1 in _this])

pkg_ZProjectData._hx_class = pkg_ZProjectData
_hx_classes["pkg.ZProjectData"] = pkg_ZProjectData


class platforms_BuildSuper:
    _hx_class_name = "platforms.BuildSuper"
    __slots__ = ("dir", "args", "root")
    _hx_fields = ["dir", "args", "root"]
    _hx_methods = ["run", "buildAfter"]

    def __init__(self,args,dir):
        self.root = None
        self.dir = dir
        self.args = args

    def run(self,cName):
        pass

    def buildAfter(self):
        pass

platforms_BuildSuper._hx_class = platforms_BuildSuper
_hx_classes["platforms.BuildSuper"] = platforms_BuildSuper


class platforms_Facebook(platforms_BuildSuper):
    _hx_class_name = "platforms.Facebook"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_BuildSuper


    def __init__(self,args,dir):
        super().__init__(args,dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin"),dir)
platforms_Facebook._hx_class = platforms_Facebook
_hx_classes["platforms.Facebook"] = platforms_Facebook


class platforms_Hl(platforms_BuildSuper):
    _hx_class_name = "platforms.Hl"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["buildAfter"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_BuildSuper


    def __init__(self,args,dir):
        super().__init__(args,dir)

    def buildAfter(self):
        super().buildAfter()
        mainFile = ((((HxOverrides.stringOrNull((self.args[2] if 2 < len(self.args) else None)) + "Export/hl/bin/") + HxOverrides.stringOrNull(Build.mainFileName)) + ".app/Contents/MacOS/") + HxOverrides.stringOrNull(Build.mainFileName))
        sys_io_File.copy(mainFile,(("null" if mainFile is None else mainFile) + "_content"))
        sys_io_File.saveContent(mainFile,(("\n        work_path=$(dirname $0)\n        cd ${work_path}\n        ./" + HxOverrides.stringOrNull(Build.mainFileName)) + "_content\n        "))

platforms_Hl._hx_class = platforms_Hl
_hx_classes["platforms.Hl"] = platforms_Hl


class platforms_Huawei(platforms_BuildSuper):
    _hx_class_name = "platforms.Huawei"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["buildAfter"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_BuildSuper


    def __init__(self,args,dir):
        super().__init__(args,dir)
        self.root = "web"
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/release"),dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/signtool"),dir)
        if (not sys_FileSystem.exists((("null" if dir is None else dir) + "/web"))):
            sys_FileSystem.createDirectory((("null" if dir is None else dir) + "/web"))
        python_FileUtils.copyFile((((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/") + HxOverrides.stringOrNull(Build.mainFileName)) + ".js"),(("null" if dir is None else dir) + "/web"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/zygameui-dom.js"),(("null" if dir is None else dir) + "/web"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/manifest.json"),(("null" if dir is None else dir) + "/web"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/window.js"),(("null" if dir is None else dir) + "/web"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/game.js"),(("null" if dir is None else dir) + "/web"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/pkgicon.png"),(("null" if dir is None else dir) + "/web"))
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/lib"),(("null" if dir is None else dir) + "/web"))

    def buildAfter(self):
        super().buildAfter()
        oldDir = Sys.getCwd()
        Sys.setCwd(self.dir)
        Sys.command((("node ./signtool/package/index.js ./web ./dist " + HxOverrides.stringOrNull(Build.mainFileName)) + ".signed ./release/private.pem ./release/certificate.pem"))
        Sys.setCwd(oldDir)

platforms_Huawei._hx_class = platforms_Huawei
_hx_classes["platforms.Huawei"] = platforms_Huawei


class platforms_Meizu(platforms_BuildSuper):
    _hx_class_name = "platforms.Meizu"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_BuildSuper


    def __init__(self,args,dir):
        super().__init__(args,dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/index-meizu.html"),(("null" if dir is None else dir) + "/index.html"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/zygameui-dom.js"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/manifest.json"),dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/sign"),dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/image"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/pkgicon.png"),dir)
        oldDir = Sys.getCwd()
        Sys.setCwd(dir)
        npmInstall = sys_FileSystem.exists((HxOverrides.stringOrNull(self.dir) + "/../html5/bin/tools/meizu-build/node_modules"))
        command = ((((((((("cd \"" + HxOverrides.stringOrNull(self.dir)) + "/../html5/bin/tools/meizu-build") + "\" ") + HxOverrides.stringOrNull((("&& npm install" if ((not npmInstall)) else "")))) + " && node bundle.js release --sourcePath ") + HxOverrides.stringOrNull(self.dir)) + " --outputPath ") + HxOverrides.stringOrNull(self.dir)) + "/../ --sign release")
        haxe_Log.trace(command,_hx_AnonObject({'fileName': "src/platforms/Meizu.hx", 'lineNumber': 22, 'className': "platforms.Meizu", 'methodName': "new"}))
        Sys.command(command)
        Sys.setCwd(oldDir)
platforms_Meizu._hx_class = platforms_Meizu
_hx_classes["platforms.Meizu"] = platforms_Meizu


class platforms_Mmh5(platforms_BuildSuper):
    _hx_class_name = "platforms.Mmh5"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_BuildSuper


    def __init__(self,args,dir):
        super().__init__(args,dir)
        Sys.setCwd((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin"))
        Sys.command("zip -rp mmh5.zip .")
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/mmh5.zip"),dir)
platforms_Mmh5._hx_class = platforms_Mmh5
_hx_classes["platforms.Mmh5"] = platforms_Mmh5


class platforms_QuickGame(platforms_BuildSuper):
    _hx_class_name = "platforms.QuickGame"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["run"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_BuildSuper


    def __init__(self,args,dir):
        super().__init__(args,dir)
        python_FileUtils.createDir((("null" if dir is None else dir) + "/src"))
        python_FileUtils.createDir((("null" if dir is None else dir) + "/engine"))
        python_FileUtils.copyFile((((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/") + HxOverrides.stringOrNull(Build.mainFileName)) + ".js"),(("null" if dir is None else dir) + "/engine"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/game.js"),(("null" if dir is None else dir) + "/src"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/manifest.json"),(("null" if dir is None else dir) + "/src"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/package.json"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/zygameui-dom.js"),(("null" if dir is None else dir) + "/src"))
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/vivosrc"),(("null" if dir is None else dir) + "/src"))
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/config"),dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/sign"),dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/lib"),(("null" if dir is None else dir) + "/src"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/pkgicon.png"),(("null" if dir is None else dir) + "/src"))

    def run(self,cName):
        Sys.command((("cd Export/" + ("null" if cName is None else cName)) + "\n        npm install\n        npm run build\n        "))

platforms_QuickGame._hx_class = platforms_QuickGame
_hx_classes["platforms.QuickGame"] = platforms_QuickGame


class platforms_Vivo(platforms_QuickGame):
    _hx_class_name = "platforms.Vivo"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["buildAfter"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_QuickGame


    def __init__(self,args,dir):
        super().__init__(args,dir)
        self.root = "src"

    def buildAfter(self):
        super().buildAfter()
        self.run("vivo")

platforms_Vivo._hx_class = platforms_Vivo
_hx_classes["platforms.Vivo"] = platforms_Vivo


class platforms_Oppo(platforms_BuildSuper):
    _hx_class_name = "platforms.Oppo"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["buildAfter"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_BuildSuper


    def __init__(self,args,dir):
        super().__init__(args,dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/main.js"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/zygameui-dom.js"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/manifest.json"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/icon.png"),dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/res"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/lib/pako.min"),(("null" if dir is None else dir) + "/lib"))
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/release"),(("null" if dir is None else dir) + "/sign"))
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/pkgicon.png"),dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/sdk"),dir)

    def buildAfter(self):
        super().buildAfter()
        Sys.command("cd Export/oppo\n            source ~/.bash_profile\n            quickgame pack release")

platforms_Oppo._hx_class = platforms_Oppo
_hx_classes["platforms.Oppo"] = platforms_Oppo


class platforms_Wifi(platforms_Oppo):
    _hx_class_name = "platforms.Wifi"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["buildAfter"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_Oppo


    def __init__(self,args,dir):
        super().__init__(args,dir)

    def buildAfter(self):
        if sys_FileSystem.exists("Export/wifi/game.cpk"):
            sys_FileSystem.deleteFile("Export/wifi/game.cpk")
        Sys.command("cd Export/wifi\n        zip -r game.cpk ./*")

platforms_Wifi._hx_class = platforms_Wifi
_hx_classes["platforms.Wifi"] = platforms_Wifi


class platforms_Wechat(platforms_BuildSuper):
    _hx_class_name = "platforms.Wechat"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_BuildSuper


    def __init__(self,args,dir):
        super().__init__(args,dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/game.js"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/index.js"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/game.json"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/project.config.json"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/zygameui-dom.js"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/leuok.bi.wx.js"),dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/sdk"),dir)
platforms_Wechat._hx_class = platforms_Wechat
_hx_classes["platforms.Wechat"] = platforms_Wechat


class platforms_G4399(platforms_Wechat):
    _hx_class_name = "platforms.G4399"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_Wechat


    def __init__(self,args,dir):
        super().__init__(args,dir)
platforms_G4399._hx_class = platforms_G4399
_hx_classes["platforms.G4399"] = platforms_G4399


class platforms_Ks(platforms_Wechat):
    _hx_class_name = "platforms.Ks"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_Wechat


    def __init__(self,args,dir):
        super().__init__(args,dir)
platforms_Ks._hx_class = platforms_Ks
_hx_classes["platforms.Ks"] = platforms_Ks


class platforms_Bili(platforms_Wechat):
    _hx_class_name = "platforms.Bili"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_Wechat


    def __init__(self,args,dir):
        super().__init__(args,dir)
platforms_Bili._hx_class = platforms_Bili
_hx_classes["platforms.Bili"] = platforms_Bili


class platforms_Tt(platforms_Wechat):
    _hx_class_name = "platforms.Tt"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_Wechat


    def __init__(self,args,dir):
        super().__init__(args,dir)
platforms_Tt._hx_class = platforms_Tt
_hx_classes["platforms.Tt"] = platforms_Tt


class platforms_Qqquick(platforms_Wechat):
    _hx_class_name = "platforms.Qqquick"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_Wechat


    def __init__(self,args,dir):
        super().__init__(args,dir)
platforms_Qqquick._hx_class = platforms_Qqquick
_hx_classes["platforms.Qqquick"] = platforms_Qqquick


class platforms_Baidu(platforms_Wechat):
    _hx_class_name = "platforms.Baidu"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_Wechat


    def __init__(self,args,dir):
        super().__init__(args,dir)
platforms_Baidu._hx_class = platforms_Baidu
_hx_classes["platforms.Baidu"] = platforms_Baidu


class platforms_Mgc(platforms_Wechat):
    _hx_class_name = "platforms.Mgc"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["buildAfter"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_Wechat


    def __init__(self,args,dir):
        super().__init__(args,dir)

    def buildAfter(self):
        super().buildAfter()
        code = Sys.command("haxelib run lebox-build-tools")
        if (code == 0):
            haxe_Log.trace("梦工厂包编译成功",_hx_AnonObject({'fileName': "src/platforms/Wechat.hx", 'lineNumber': 65, 'className': "platforms.Mgc", 'methodName': "buildAfter"}))
        else:
            haxe_Log.trace("Warring:梦工厂包编译时，需要安装lebox-build-tools库",_hx_AnonObject({'fileName': "src/platforms/Wechat.hx", 'lineNumber': 68, 'className': "platforms.Mgc", 'methodName': "buildAfter"}))

platforms_Mgc._hx_class = platforms_Mgc
_hx_classes["platforms.Mgc"] = platforms_Mgc


class platforms_Qihoo(platforms_Wechat):
    _hx_class_name = "platforms.Qihoo"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["buildAfter"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_Wechat


    def __init__(self,args,dir):
        super().__init__(args,dir)

    def buildAfter(self):
        super().buildAfter()
        haxe_Log.trace("Build qihoo path:",_hx_AnonObject({'fileName': "src/platforms/Wechat.hx", 'lineNumber': 79, 'className': "platforms.Qihoo", 'methodName': "buildAfter", 'customParams': [self.dir]}))
        if sys_FileSystem.exists((HxOverrides.stringOrNull(self.dir) + "/game.zip")):
            sys_FileSystem.deleteFile((HxOverrides.stringOrNull(self.dir) + "/game.zip"))
        npmInstall = sys_FileSystem.exists((HxOverrides.stringOrNull(self.dir) + "/../html5/bin/tools/qihoosdk/node_modules"))
        command = ((((("\n\t\tcd " + HxOverrides.stringOrNull(self.dir)) + "/../html5/bin/tools/qihoosdk") + HxOverrides.stringOrNull((("" if npmInstall else "\n\t\tnpm install")))) + "\n\t\tnode ./index.js -i ") + HxOverrides.stringOrNull(self.dir))
        haxe_Log.trace(command,_hx_AnonObject({'fileName': "src/platforms/Wechat.hx", 'lineNumber': 92, 'className': "platforms.Qihoo", 'methodName': "buildAfter"}))
        Sys.command(command)
        python_FileUtils.copyFile((HxOverrides.stringOrNull(self.dir) + "/../html5/bin/tools/qihoosdk/dist/game.zip"),self.dir)

platforms_Qihoo._hx_class = platforms_Qihoo
_hx_classes["platforms.Qihoo"] = platforms_Qihoo


class platforms_Xiaomi(platforms_BuildSuper):
    _hx_class_name = "platforms.Xiaomi"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["buildAfter"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = platforms_BuildSuper


    def __init__(self,args,dir):
        super().__init__(args,dir)
        python_FileUtils.copyDic((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/sign"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/main.js"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/manifest.json"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/package.json"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/zygameui-dom.js"),dir)
        python_FileUtils.copyFile((HxOverrides.stringOrNull((args[2] if 2 < len(args) else None)) + "Export/html5/bin/pkgicon.png"),dir)

    def buildAfter(self):
        super().buildAfter()
        Sys.setCwd(self.dir)
        if (not sys_FileSystem.exists("node_moules")):
            Sys.command(" npm install;")
        Sys.command("npm run release;")

platforms_Xiaomi._hx_class = platforms_Xiaomi
_hx_classes["platforms.Xiaomi"] = platforms_Xiaomi


class python_Boot:
    _hx_class_name = "python.Boot"
    __slots__ = ()
    _hx_statics = ["keywords", "toString1", "fields", "simpleField", "hasField", "field", "getInstanceFields", "getSuperClass", "getClassFields", "prefixLength", "unhandleKeywords"]

    @staticmethod
    def toString1(o,s):
        if (o is None):
            return "null"
        if isinstance(o,str):
            return o
        if (s is None):
            s = ""
        if (len(s) >= 5):
            return "<...>"
        if isinstance(o,bool):
            if o:
                return "true"
            else:
                return "false"
        if (isinstance(o,int) and (not isinstance(o,bool))):
            return str(o)
        if isinstance(o,float):
            try:
                if (o == int(o)):
                    return str(Math.floor((o + 0.5)))
                else:
                    return str(o)
            except BaseException as _g:
                return str(o)
        if isinstance(o,list):
            o1 = o
            l = len(o1)
            st = "["
            s = (("null" if s is None else s) + "\t")
            _g = 0
            _g1 = l
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                prefix = ""
                if (i > 0):
                    prefix = ","
                st = (("null" if st is None else st) + HxOverrides.stringOrNull(((("null" if prefix is None else prefix) + HxOverrides.stringOrNull(python_Boot.toString1((o1[i] if i >= 0 and i < len(o1) else None),s))))))
            st = (("null" if st is None else st) + "]")
            return st
        try:
            if hasattr(o,"toString"):
                return o.toString()
        except BaseException as _g:
            pass
        if hasattr(o,"__class__"):
            if isinstance(o,_hx_AnonObject):
                toStr = None
                try:
                    fields = python_Boot.fields(o)
                    _g = []
                    _g1 = 0
                    while (_g1 < len(fields)):
                        f = (fields[_g1] if _g1 >= 0 and _g1 < len(fields) else None)
                        _g1 = (_g1 + 1)
                        x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
                        _g.append(x)
                    fieldsStr = _g
                    toStr = (("{ " + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " }")
                except BaseException as _g:
                    return "{ ... }"
                if (toStr is None):
                    return "{ ... }"
                else:
                    return toStr
            if isinstance(o,Enum):
                o1 = o
                l = len(o1.params)
                hasParams = (l > 0)
                if hasParams:
                    paramsStr = ""
                    _g = 0
                    _g1 = l
                    while (_g < _g1):
                        i = _g
                        _g = (_g + 1)
                        prefix = ""
                        if (i > 0):
                            prefix = ","
                        paramsStr = (("null" if paramsStr is None else paramsStr) + HxOverrides.stringOrNull(((("null" if prefix is None else prefix) + HxOverrides.stringOrNull(python_Boot.toString1(o1.params[i],s))))))
                    return (((HxOverrides.stringOrNull(o1.tag) + "(") + ("null" if paramsStr is None else paramsStr)) + ")")
                else:
                    return o1.tag
            if hasattr(o,"_hx_class_name"):
                if (o.__class__.__name__ != "type"):
                    fields = python_Boot.getInstanceFields(o)
                    _g = []
                    _g1 = 0
                    while (_g1 < len(fields)):
                        f = (fields[_g1] if _g1 >= 0 and _g1 < len(fields) else None)
                        _g1 = (_g1 + 1)
                        x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
                        _g.append(x)
                    fieldsStr = _g
                    toStr = (((HxOverrides.stringOrNull(o._hx_class_name) + "( ") + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " )")
                    return toStr
                else:
                    fields = python_Boot.getClassFields(o)
                    _g = []
                    _g1 = 0
                    while (_g1 < len(fields)):
                        f = (fields[_g1] if _g1 >= 0 and _g1 < len(fields) else None)
                        _g1 = (_g1 + 1)
                        x = ((("" + ("null" if f is None else f)) + " : ") + HxOverrides.stringOrNull(python_Boot.toString1(python_Boot.simpleField(o,f),(("null" if s is None else s) + "\t"))))
                        _g.append(x)
                    fieldsStr = _g
                    toStr = (((("#" + HxOverrides.stringOrNull(o._hx_class_name)) + "( ") + HxOverrides.stringOrNull(", ".join([x1 for x1 in fieldsStr]))) + " )")
                    return toStr
            if (o == str):
                return "#String"
            if (o == list):
                return "#Array"
            if callable(o):
                return "function"
            try:
                if hasattr(o,"__repr__"):
                    return o.__repr__()
            except BaseException as _g:
                pass
            if hasattr(o,"__str__"):
                return o.__str__([])
            if hasattr(o,"__name__"):
                return o.__name__
            return "???"
        else:
            return str(o)

    @staticmethod
    def fields(o):
        a = []
        if (o is not None):
            if hasattr(o,"_hx_fields"):
                fields = o._hx_fields
                if (fields is not None):
                    return list(fields)
            if isinstance(o,_hx_AnonObject):
                d = o.__dict__
                keys = d.keys()
                handler = python_Boot.unhandleKeywords
                for k in keys:
                    if (k != '_hx_disable_getattr'):
                        a.append(handler(k))
            elif hasattr(o,"__dict__"):
                d = o.__dict__
                keys1 = d.keys()
                for k in keys1:
                    a.append(k)
        return a

    @staticmethod
    def simpleField(o,field):
        if (field is None):
            return None
        field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
        if hasattr(o,field1):
            return getattr(o,field1)
        else:
            return None

    @staticmethod
    def hasField(o,field):
        if isinstance(o,_hx_AnonObject):
            return o._hx_hasattr(field)
        return hasattr(o,(("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field)))

    @staticmethod
    def field(o,field):
        if (field is None):
            return None
        if isinstance(o,str):
            field1 = field
            _hx_local_0 = len(field1)
            if (_hx_local_0 == 10):
                if (field1 == "charCodeAt"):
                    return python_internal_MethodClosure(o,HxString.charCodeAt)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 11):
                if (field1 == "lastIndexOf"):
                    return python_internal_MethodClosure(o,HxString.lastIndexOf)
                elif (field1 == "toLowerCase"):
                    return python_internal_MethodClosure(o,HxString.toLowerCase)
                elif (field1 == "toUpperCase"):
                    return python_internal_MethodClosure(o,HxString.toUpperCase)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 9):
                if (field1 == "substring"):
                    return python_internal_MethodClosure(o,HxString.substring)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 5):
                if (field1 == "split"):
                    return python_internal_MethodClosure(o,HxString.split)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 7):
                if (field1 == "indexOf"):
                    return python_internal_MethodClosure(o,HxString.indexOf)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 8):
                if (field1 == "toString"):
                    return python_internal_MethodClosure(o,HxString.toString)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_0 == 6):
                if (field1 == "charAt"):
                    return python_internal_MethodClosure(o,HxString.charAt)
                elif (field1 == "length"):
                    return len(o)
                elif (field1 == "substr"):
                    return python_internal_MethodClosure(o,HxString.substr)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            else:
                field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                if hasattr(o,field1):
                    return getattr(o,field1)
                else:
                    return None
        elif isinstance(o,list):
            field1 = field
            _hx_local_1 = len(field1)
            if (_hx_local_1 == 11):
                if (field1 == "lastIndexOf"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.lastIndexOf)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 4):
                if (field1 == "copy"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.copy)
                elif (field1 == "join"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.join)
                elif (field1 == "push"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.push)
                elif (field1 == "sort"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.sort)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 5):
                if (field1 == "shift"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.shift)
                elif (field1 == "slice"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.slice)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 7):
                if (field1 == "indexOf"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.indexOf)
                elif (field1 == "reverse"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.reverse)
                elif (field1 == "unshift"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.unshift)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 3):
                if (field1 == "map"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.map)
                elif (field1 == "pop"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.pop)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 8):
                if (field1 == "contains"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.contains)
                elif (field1 == "iterator"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.iterator)
                elif (field1 == "toString"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.toString)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 16):
                if (field1 == "keyValueIterator"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.keyValueIterator)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            elif (_hx_local_1 == 6):
                if (field1 == "concat"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.concat)
                elif (field1 == "filter"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.filter)
                elif (field1 == "insert"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.insert)
                elif (field1 == "length"):
                    return len(o)
                elif (field1 == "remove"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.remove)
                elif (field1 == "splice"):
                    return python_internal_MethodClosure(o,python_internal_ArrayImpl.splice)
                else:
                    field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                    if hasattr(o,field1):
                        return getattr(o,field1)
                    else:
                        return None
            else:
                field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
                if hasattr(o,field1):
                    return getattr(o,field1)
                else:
                    return None
        else:
            field1 = (("_hx_" + field) if ((field in python_Boot.keywords)) else (("_hx_" + field) if (((((len(field) > 2) and ((ord(field[0]) == 95))) and ((ord(field[1]) == 95))) and ((ord(field[(len(field) - 1)]) != 95)))) else field))
            if hasattr(o,field1):
                return getattr(o,field1)
            else:
                return None

    @staticmethod
    def getInstanceFields(c):
        f = (list(c._hx_fields) if (hasattr(c,"_hx_fields")) else [])
        if hasattr(c,"_hx_methods"):
            f = (f + c._hx_methods)
        sc = python_Boot.getSuperClass(c)
        if (sc is None):
            return f
        else:
            scArr = python_Boot.getInstanceFields(sc)
            scMap = set(scArr)
            _g = 0
            while (_g < len(f)):
                f1 = (f[_g] if _g >= 0 and _g < len(f) else None)
                _g = (_g + 1)
                if (not (f1 in scMap)):
                    scArr.append(f1)
            return scArr

    @staticmethod
    def getSuperClass(c):
        if (c is None):
            return None
        try:
            if hasattr(c,"_hx_super"):
                return c._hx_super
            return None
        except BaseException as _g:
            pass
        return None

    @staticmethod
    def getClassFields(c):
        if hasattr(c,"_hx_statics"):
            x = c._hx_statics
            return list(x)
        else:
            return []

    @staticmethod
    def unhandleKeywords(name):
        if (HxString.substr(name,0,python_Boot.prefixLength) == "_hx_"):
            real = HxString.substr(name,python_Boot.prefixLength,None)
            if (real in python_Boot.keywords):
                return real
        return name
python_Boot._hx_class = python_Boot
_hx_classes["python.Boot"] = python_Boot


class python_ChardetResult:
    _hx_class_name = "python.ChardetResult"
    __slots__ = ("encoding",)
    _hx_fields = ["encoding"]

python_ChardetResult._hx_class = python_ChardetResult
_hx_classes["python.ChardetResult"] = python_ChardetResult


class python_FileUtils:
    _hx_class_name = "python.FileUtils"
    __slots__ = ()
    _hx_statics = ["createDir", "copyFile", "copyDic", "getIsIgone", "removeDic", "removeNoneDic", "isBinary"]

    @staticmethod
    def createDir(dir):
        if (not sys_FileSystem.exists(dir)):
            sys_FileSystem.createDirectory(dir)

    @staticmethod
    def copyFile(file,copyTo):
        if (not sys_FileSystem.exists(file)):
            haxe_Log.trace(("copyDic 路径不存在：" + ("null" if file is None else file)),_hx_AnonObject({'fileName': "python/FileUtils.hx", 'lineNumber': 15, 'className': "python.FileUtils", 'methodName': "copyFile"}))
            return
        dir = None
        startIndex = None
        if (((copyTo.find("/") if ((startIndex is None)) else HxString.indexOfImpl(copyTo,"/",startIndex))) == -1):
            dir = copyTo
        else:
            startIndex = None
            _hx_len = None
            if (startIndex is None):
                _hx_len = copyTo.rfind("/", 0, len(copyTo))
            else:
                i = copyTo.rfind("/", 0, (startIndex + 1))
                startLeft = (max(0,((startIndex + 1) - len("/"))) if ((i == -1)) else (i + 1))
                check = copyTo.find("/", startLeft, len(copyTo))
                _hx_len = (check if (((check > i) and ((check <= startIndex)))) else i)
            dir = HxString.substr(copyTo,0,_hx_len)
        if (not sys_FileSystem.exists(dir)):
            sys_FileSystem.createDirectory(dir)
        if (sys_FileSystem.exists(copyTo) and (not sys_FileSystem.isDirectory(copyTo))):
            sys_FileSystem.deleteFile(copyTo)
        sys_io_File.copy(file,copyTo)

    @staticmethod
    def copyDic(dic,copyTo,igone = None):
        if (not sys_FileSystem.exists(dic)):
            haxe_Log.trace(("copyDic 路径不存在：" + ("null" if dic is None else dic)),_hx_AnonObject({'fileName': "python/FileUtils.hx", 'lineNumber': 35, 'className': "python.FileUtils", 'methodName': "copyDic"}))
            return
        dicName = None
        startIndex = None
        if (((dic.find("/") if ((startIndex is None)) else HxString.indexOfImpl(dic,"/",startIndex))) == -1):
            dicName = dic
        else:
            startIndex = None
            pos = None
            if (startIndex is None):
                pos = dic.rfind("/", 0, len(dic))
            else:
                i = dic.rfind("/", 0, (startIndex + 1))
                startLeft = (max(0,((startIndex + 1) - len("/"))) if ((i == -1)) else (i + 1))
                check = dic.find("/", startLeft, len(dic))
                pos = (check if (((check > i) and ((check <= startIndex)))) else i)
            dicName = HxString.substr(dic,(pos + 1),None)
        if (not sys_FileSystem.exists(((("null" if copyTo is None else copyTo) + "/") + ("null" if dicName is None else dicName)))):
            sys_FileSystem.createDirectory(((("null" if copyTo is None else copyTo) + "/") + ("null" if dicName is None else dicName)))
        _hx_list = sys_FileSystem.readDirectory(dic)
        _g = 0
        while (_g < len(_hx_list)):
            file = (_hx_list[_g] if _g >= 0 and _g < len(_hx_list) else None)
            _g = (_g + 1)
            file2 = ((("null" if dic is None else dic) + "/") + ("null" if file is None else file))
            if sys_FileSystem.isDirectory(file2):
                python_FileUtils.copyDic(file2,((("null" if copyTo is None else copyTo) + "/") + ("null" if dicName is None else dicName)),igone)
            elif ((igone is None) or (not python_FileUtils.getIsIgone(file,igone))):
                try:
                    sys_io_File.copy(file2,((("null" if copyTo is None else copyTo) + "/") + ("null" if dicName is None else dicName)))
                except BaseException as _g1:
                    e = haxe_Exception.caught(_g1).unwrap()
                    haxe_Log.trace(("Warring:" + ("null" if file2 is None else file2)),_hx_AnonObject({'fileName': "python/FileUtils.hx", 'lineNumber': 51, 'className': "python.FileUtils", 'methodName': "copyDic", 'customParams': [e]}))

    @staticmethod
    def getIsIgone(file,igone):
        _g = 0
        while (_g < len(igone)):
            i = (igone[_g] if _g >= 0 and _g < len(igone) else None)
            _g = (_g + 1)
            startIndex = None
            if (((file.find(i) if ((startIndex is None)) else HxString.indexOfImpl(file,i,startIndex))) != -1):
                return True
        return False

    @staticmethod
    def removeDic(dic):
        if (not sys_FileSystem.exists(dic)):
            return
        _hx_list = sys_FileSystem.readDirectory(dic)
        _g = 0
        while (_g < len(_hx_list)):
            file = (_hx_list[_g] if _g >= 0 and _g < len(_hx_list) else None)
            _g = (_g + 1)
            file = ((("null" if dic is None else dic) + "/") + ("null" if file is None else file))
            if sys_FileSystem.isDirectory(file):
                python_FileUtils.removeDic(file)
            else:
                sys_FileSystem.deleteFile(file)
        sys_FileSystem.deleteDirectory(dic)

    @staticmethod
    def removeNoneDic(dic):
        if (not sys_FileSystem.exists(dic)):
            return False
        isCanDelDic = True
        _hx_list = sys_FileSystem.readDirectory(dic)
        _g = 0
        while (_g < len(_hx_list)):
            file = (_hx_list[_g] if _g >= 0 and _g < len(_hx_list) else None)
            _g = (_g + 1)
            file = ((("null" if dic is None else dic) + "/") + ("null" if file is None else file))
            if sys_FileSystem.isDirectory(file):
                if (not python_FileUtils.removeNoneDic(file)):
                    isCanDelDic = False
            else:
                isCanDelDic = False
        if isCanDelDic:
            sys_FileSystem.deleteDirectory(dic)
        return isCanDelDic

    @staticmethod
    def isBinary(file):
        if sys_FileSystem.isDirectory(file):
            return False
        _hx_bytes = sys_io_File.getBytes(file)
        if ((((_hx_bytes.b[0] == 0) and ((_hx_bytes.b[1] == 0))) and ((_hx_bytes.b[2] == 0))) and ((_hx_bytes.b[3] == 0))):
            return True
        return False
python_FileUtils._hx_class = python_FileUtils
_hx_classes["python.FileUtils"] = python_FileUtils


class python_HaxeIterator:
    _hx_class_name = "python.HaxeIterator"
    __slots__ = ("it", "x", "has", "checked")
    _hx_fields = ["it", "x", "has", "checked"]
    _hx_methods = ["next", "hasNext"]

    def __init__(self,it):
        self.checked = False
        self.has = False
        self.x = None
        self.it = it

    def next(self):
        if (not self.checked):
            self.hasNext()
        self.checked = False
        return self.x

    def hasNext(self):
        if (not self.checked):
            try:
                self.x = self.it.__next__()
                self.has = True
            except BaseException as _g:
                if Std.isOfType(haxe_Exception.caught(_g).unwrap(),StopIteration):
                    self.has = False
                    self.x = None
                else:
                    raise _g
            self.checked = True
        return self.has

python_HaxeIterator._hx_class = python_HaxeIterator
_hx_classes["python.HaxeIterator"] = python_HaxeIterator


class python__KwArgs_KwArgs_Impl_:
    _hx_class_name = "python._KwArgs.KwArgs_Impl_"
    __slots__ = ()
    _hx_statics = ["fromT"]

    @staticmethod
    def fromT(d):
        this1 = python_Lib.anonAsDict(d)
        return this1
python__KwArgs_KwArgs_Impl_._hx_class = python__KwArgs_KwArgs_Impl_
_hx_classes["python._KwArgs.KwArgs_Impl_"] = python__KwArgs_KwArgs_Impl_


class HxString:
    _hx_class_name = "HxString"
    __slots__ = ()
    _hx_statics = ["split", "charCodeAt", "charAt", "lastIndexOf", "toUpperCase", "toLowerCase", "indexOf", "indexOfImpl", "toString", "substring", "substr"]

    @staticmethod
    def split(s,d):
        if (d == ""):
            return list(s)
        else:
            return s.split(d)

    @staticmethod
    def charCodeAt(s,index):
        if ((((s is None) or ((len(s) == 0))) or ((index < 0))) or ((index >= len(s)))):
            return None
        else:
            return ord(s[index])

    @staticmethod
    def charAt(s,index):
        if ((index < 0) or ((index >= len(s)))):
            return ""
        else:
            return s[index]

    @staticmethod
    def lastIndexOf(s,_hx_str,startIndex = None):
        if (startIndex is None):
            return s.rfind(_hx_str, 0, len(s))
        elif (_hx_str == ""):
            length = len(s)
            if (startIndex < 0):
                startIndex = (length + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            if (startIndex > length):
                return length
            else:
                return startIndex
        else:
            i = s.rfind(_hx_str, 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len(_hx_str))) if ((i == -1)) else (i + 1))
            check = s.find(_hx_str, startLeft, len(s))
            if ((check > i) and ((check <= startIndex))):
                return check
            else:
                return i

    @staticmethod
    def toUpperCase(s):
        return s.upper()

    @staticmethod
    def toLowerCase(s):
        return s.lower()

    @staticmethod
    def indexOf(s,_hx_str,startIndex = None):
        if (startIndex is None):
            return s.find(_hx_str)
        else:
            return HxString.indexOfImpl(s,_hx_str,startIndex)

    @staticmethod
    def indexOfImpl(s,_hx_str,startIndex):
        if (_hx_str == ""):
            length = len(s)
            if (startIndex < 0):
                startIndex = (length + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            if (startIndex > length):
                return length
            else:
                return startIndex
        return s.find(_hx_str, startIndex)

    @staticmethod
    def toString(s):
        return s

    @staticmethod
    def substring(s,startIndex,endIndex = None):
        if (startIndex < 0):
            startIndex = 0
        if (endIndex is None):
            return s[startIndex:]
        else:
            if (endIndex < 0):
                endIndex = 0
            if (endIndex < startIndex):
                return s[endIndex:startIndex]
            else:
                return s[startIndex:endIndex]

    @staticmethod
    def substr(s,startIndex,_hx_len = None):
        if (_hx_len is None):
            return s[startIndex:]
        else:
            if (_hx_len == 0):
                return ""
            if (startIndex < 0):
                startIndex = (len(s) + startIndex)
                if (startIndex < 0):
                    startIndex = 0
            return s[startIndex:(startIndex + _hx_len)]
HxString._hx_class = HxString
_hx_classes["HxString"] = HxString


class python_Lib:
    _hx_class_name = "python.Lib"
    __slots__ = ()
    _hx_statics = ["lineEnd", "printString", "dictToAnon", "anonToDict", "anonAsDict"]

    @staticmethod
    def printString(_hx_str):
        encoding = "utf-8"
        if (encoding is None):
            encoding = "utf-8"
        python_lib_Sys.stdout.buffer.write(_hx_str.encode(encoding, "strict"))
        python_lib_Sys.stdout.flush()

    @staticmethod
    def dictToAnon(v):
        return _hx_AnonObject(v.copy())

    @staticmethod
    def anonToDict(o):
        if isinstance(o,_hx_AnonObject):
            return o.__dict__.copy()
        else:
            return None

    @staticmethod
    def anonAsDict(o):
        if isinstance(o,_hx_AnonObject):
            return o.__dict__
        else:
            return None
python_Lib._hx_class = python_Lib
_hx_classes["python.Lib"] = python_Lib


class python_Xls:
    _hx_class_name = "python.Xls"
    __slots__ = ()
    _hx_methods = ["sheet_names", "sheet_by_name"]
python_Xls._hx_class = python_Xls
_hx_classes["python.Xls"] = python_Xls


class python_Sheet:
    _hx_class_name = "python.Sheet"
    __slots__ = ("nrows", "ncols")
    _hx_fields = ["nrows", "ncols"]
    _hx_methods = ["col_values", "row_values"]
python_Sheet._hx_class = python_Sheet
_hx_classes["python.Sheet"] = python_Sheet


class python_HTMLXlsData:
    _hx_class_name = "python.HTMLXlsData"
    __slots__ = ("xls",)
    _hx_fields = ["xls"]
    _hx_methods = ["sheet_names", "sheet_by_name"]
    _hx_interfaces = [python_Xls]

    def __init__(self,path):
        data = None
        codebytes = None
        f2 = open(path, 'rb') ;codebytes=f2.read();f2.close();
        char = python_Chardet.detect(codebytes)
        encoding = char['encoding']
        haxe_Log.trace("编码：",_hx_AnonObject({'fileName': "python/XlsData.hx", 'lineNumber': 167, 'className': "python.HTMLXlsData", 'methodName': "new", 'customParams': [encoding]}))
        f = open(path, 'r', encoding=encoding);data=f.read();f.close();
        obj = python_Pandas.read_html(data)
        startIndex = None
        _hx_len = None
        if (startIndex is None):
            _hx_len = path.rfind("/", 0, len(path))
        else:
            i = path.rfind("/", 0, (startIndex + 1))
            startLeft = (max(0,((startIndex + 1) - len("/"))) if ((i == -1)) else (i + 1))
            check = path.find("/", startLeft, len(path))
            _hx_len = (check if (((check > i) and ((check <= startIndex)))) else i)
        outpath = (HxOverrides.stringOrNull(HxString.substr(path,0,_hx_len)) + "/txtmp")
        if sys_FileSystem.exists(outpath):
            python_FileUtils.removeDic(outpath)
        sys_FileSystem.createDirectory(outpath)
        outpath = (("null" if outpath is None else outpath) + "/tmp.xls")
        xlsWrite = python_Pandas.ExcelWriter(outpath)
        HxOverrides.arrayGet(obj, 0).to_excel(xlsWrite)
        xlsWrite.close()
        haxe_Log.trace(("导出：" + ("null" if outpath is None else outpath)),_hx_AnonObject({'fileName': "python/XlsData.hx", 'lineNumber': 178, 'className': "python.HTMLXlsData", 'methodName': "new"}))
        self.xls = python_XlsData.open_workbook(outpath)

    def sheet_names(self):
        return self.xls.sheet_names()

    def sheet_by_name(self,name):
        return self.xls.sheet_by_name(name)

python_HTMLXlsData._hx_class = python_HTMLXlsData
_hx_classes["python.HTMLXlsData"] = python_HTMLXlsData


class python_CSVXlsData:
    _hx_class_name = "python.CSVXlsData"
    __slots__ = ("csv",)
    _hx_fields = ["csv"]
    _hx_methods = ["sheet_names", "sheet_by_name"]
    _hx_interfaces = [python_Xls]

    def __init__(self,path):
        data = None
        codebytes = None
        f2 = open(path, 'rb') ;codebytes=f2.read();f2.close();
        char = python_Chardet.detect(codebytes)
        encoding = char['encoding']
        haxe_Log.trace("编码：",_hx_AnonObject({'fileName': "python/XlsData.hx", 'lineNumber': 207, 'className': "python.CSVXlsData", 'methodName': "new", 'customParams': [encoding]}))
        if (encoding.upper() == "GB2312"):
            encoding = "gbk"
        f = open(path, 'r', encoding=encoding);data=f.read();f.close();
        data = StringTools.replace(data,"\"","")
        self.csv = python_CSVXlsSheet(data)

    def sheet_names(self):
        return ["default"]

    def sheet_by_name(self,name):
        return self.csv

python_CSVXlsData._hx_class = python_CSVXlsData
_hx_classes["python.CSVXlsData"] = python_CSVXlsData


class python_CSVXlsSheet:
    _hx_class_name = "python.CSVXlsSheet"
    __slots__ = ("rarray", "carray", "nrows", "ncols")
    _hx_fields = ["rarray", "carray", "nrows", "ncols"]
    _hx_methods = ["col_values", "row_values"]
    _hx_interfaces = [python_Sheet]

    def __init__(self,data):
        self.ncols = None
        self.carray = []
        self.rarray = []
        r = data.split("\n")
        self.nrows = len(r)
        _g = 0
        _g1 = len(r)
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            d = (r[i] if i >= 0 and i < len(r) else None)
            startIndex = None
            if (((d.find(",") if ((startIndex is None)) else HxString.indexOfImpl(d,",",startIndex))) == -1):
                python_internal_ArrayImpl._set(self.rarray, i, d.split("\t"))
            else:
                python_internal_ArrayImpl._set(self.rarray, i, d.split(","))
        self.ncols = len((self.rarray[0] if 0 < len(self.rarray) else None))
        haxe_Log.trace("CSV:",_hx_AnonObject({'fileName': "python/XlsData.hx", 'lineNumber': 248, 'className': "python.CSVXlsSheet", 'methodName': "new", 'customParams': [self.nrows, self.ncols]}))

    def col_values(self,index):
        return None

    def row_values(self,index):
        return (self.rarray[index] if index >= 0 and index < len(self.rarray) else None)

python_CSVXlsSheet._hx_class = python_CSVXlsSheet
_hx_classes["python.CSVXlsSheet"] = python_CSVXlsSheet


class python_internal_ArrayImpl:
    _hx_class_name = "python.internal.ArrayImpl"
    __slots__ = ()
    _hx_statics = ["concat", "copy", "iterator", "keyValueIterator", "indexOf", "lastIndexOf", "join", "toString", "pop", "push", "unshift", "remove", "contains", "shift", "slice", "sort", "splice", "map", "filter", "insert", "reverse", "_get", "_set"]

    @staticmethod
    def concat(a1,a2):
        return (a1 + a2)

    @staticmethod
    def copy(x):
        return list(x)

    @staticmethod
    def iterator(x):
        return python_HaxeIterator(x.__iter__())

    @staticmethod
    def keyValueIterator(x):
        return haxe_iterators_ArrayKeyValueIterator(x)

    @staticmethod
    def indexOf(a,x,fromIndex = None):
        _hx_len = len(a)
        l = (0 if ((fromIndex is None)) else ((_hx_len + fromIndex) if ((fromIndex < 0)) else fromIndex))
        if (l < 0):
            l = 0
        _g = l
        _g1 = _hx_len
        while (_g < _g1):
            i = _g
            _g = (_g + 1)
            if HxOverrides.eq(a[i],x):
                return i
        return -1

    @staticmethod
    def lastIndexOf(a,x,fromIndex = None):
        _hx_len = len(a)
        l = (_hx_len if ((fromIndex is None)) else (((_hx_len + fromIndex) + 1) if ((fromIndex < 0)) else (fromIndex + 1)))
        if (l > _hx_len):
            l = _hx_len
        while True:
            l = (l - 1)
            tmp = l
            if (not ((tmp > -1))):
                break
            if HxOverrides.eq(a[l],x):
                return l
        return -1

    @staticmethod
    def join(x,sep):
        return sep.join([python_Boot.toString1(x1,'') for x1 in x])

    @staticmethod
    def toString(x):
        return (("[" + HxOverrides.stringOrNull(",".join([python_Boot.toString1(x1,'') for x1 in x]))) + "]")

    @staticmethod
    def pop(x):
        if (len(x) == 0):
            return None
        else:
            return x.pop()

    @staticmethod
    def push(x,e):
        x.append(e)
        return len(x)

    @staticmethod
    def unshift(x,e):
        x.insert(0, e)

    @staticmethod
    def remove(x,e):
        try:
            x.remove(e)
            return True
        except BaseException as _g:
            return False

    @staticmethod
    def contains(x,e):
        return (e in x)

    @staticmethod
    def shift(x):
        if (len(x) == 0):
            return None
        return x.pop(0)

    @staticmethod
    def slice(x,pos,end = None):
        return x[pos:end]

    @staticmethod
    def sort(x,f):
        x.sort(key= python_lib_Functools.cmp_to_key(f))

    @staticmethod
    def splice(x,pos,_hx_len):
        if (pos < 0):
            pos = (len(x) + pos)
        if (pos < 0):
            pos = 0
        res = x[pos:(pos + _hx_len)]
        del x[pos:(pos + _hx_len)]
        return res

    @staticmethod
    def map(x,f):
        return list(map(f,x))

    @staticmethod
    def filter(x,f):
        return list(filter(f,x))

    @staticmethod
    def insert(a,pos,x):
        a.insert(pos, x)

    @staticmethod
    def reverse(a):
        a.reverse()

    @staticmethod
    def _get(x,idx):
        if ((idx > -1) and ((idx < len(x)))):
            return x[idx]
        else:
            return None

    @staticmethod
    def _set(x,idx,v):
        l = len(x)
        while (l < idx):
            x.append(None)
            l = (l + 1)
        if (l == idx):
            x.append(v)
        else:
            x[idx] = v
        return v
python_internal_ArrayImpl._hx_class = python_internal_ArrayImpl
_hx_classes["python.internal.ArrayImpl"] = python_internal_ArrayImpl


class HxOverrides:
    _hx_class_name = "HxOverrides"
    __slots__ = ()
    _hx_statics = ["iterator", "eq", "stringOrNull", "push", "rshift", "modf", "mod", "arrayGet", "mapKwArgs"]

    @staticmethod
    def iterator(x):
        if isinstance(x,list):
            return haxe_iterators_ArrayIterator(x)
        return x.iterator()

    @staticmethod
    def eq(a,b):
        if (isinstance(a,list) or isinstance(b,list)):
            return a is b
        return (a == b)

    @staticmethod
    def stringOrNull(s):
        if (s is None):
            return "null"
        else:
            return s

    @staticmethod
    def push(x,e):
        if isinstance(x,list):
            _this = x
            _this.append(e)
            return len(_this)
        return x.push(e)

    @staticmethod
    def rshift(val,n):
        return ((val % 0x100000000) >> n)

    @staticmethod
    def modf(a,b):
        if (b == 0.0):
            return float('nan')
        elif (a < 0):
            if (b < 0):
                return -(-a % (-b))
            else:
                return -(-a % b)
        elif (b < 0):
            return a % (-b)
        else:
            return a % b

    @staticmethod
    def mod(a,b):
        if (a < 0):
            if (b < 0):
                return -(-a % (-b))
            else:
                return -(-a % b)
        elif (b < 0):
            return a % (-b)
        else:
            return a % b

    @staticmethod
    def arrayGet(a,i):
        if isinstance(a,list):
            x = a
            if ((i > -1) and ((i < len(x)))):
                return x[i]
            else:
                return None
        else:
            return a[i]

    @staticmethod
    def mapKwArgs(a,v):
        a1 = _hx_AnonObject(python_Lib.anonToDict(a))
        k = python_HaxeIterator(iter(v.keys()))
        while k.hasNext():
            k1 = k.next()
            val = v.get(k1)
            if a1._hx_hasattr(k1):
                x = getattr(a1,k1)
                setattr(a1,val,x)
                delattr(a1,k1)
        return a1
HxOverrides._hx_class = HxOverrides
_hx_classes["HxOverrides"] = HxOverrides


class python_internal_MethodClosure:
    _hx_class_name = "python.internal.MethodClosure"
    __slots__ = ("obj", "func")
    _hx_fields = ["obj", "func"]
    _hx_methods = ["__call__"]

    def __init__(self,obj,func):
        self.obj = obj
        self.func = func

    def __call__(self,*args):
        return self.func(self.obj,*args)

python_internal_MethodClosure._hx_class = python_internal_MethodClosure
_hx_classes["python.internal.MethodClosure"] = python_internal_MethodClosure


class python_io_NativeInput(haxe_io_Input):
    _hx_class_name = "python.io.NativeInput"
    __slots__ = ("stream", "wasEof")
    _hx_fields = ["stream", "wasEof"]
    _hx_methods = ["throwEof", "readinto", "readBytes"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Input


    def __init__(self,s):
        self.wasEof = None
        self.stream = s
        self.set_bigEndian(False)
        self.wasEof = False
        if (not self.stream.readable()):
            raise haxe_Exception.thrown("Write-only stream")

    def throwEof(self):
        self.wasEof = True
        raise haxe_Exception.thrown(haxe_io_Eof())

    def readinto(self,b):
        raise haxe_Exception.thrown("abstract method, should be overridden")

    def readBytes(self,s,pos,_hx_len):
        if (((pos < 0) or ((_hx_len < 0))) or (((pos + _hx_len) > s.length))):
            raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
        ba = bytearray(_hx_len)
        ret = self.readinto(ba)
        if (ret == 0):
            self.throwEof()
        s.blit(pos,haxe_io_Bytes.ofData(ba),0,_hx_len)
        return ret

python_io_NativeInput._hx_class = python_io_NativeInput
_hx_classes["python.io.NativeInput"] = python_io_NativeInput


class python_io_IInput:
    _hx_class_name = "python.io.IInput"
    __slots__ = ("bigEndian",)
    _hx_fields = ["bigEndian"]
    _hx_methods = ["set_bigEndian", "readByte", "readBytes", "readAll"]
python_io_IInput._hx_class = python_io_IInput
_hx_classes["python.io.IInput"] = python_io_IInput


class python_io_IFileInput:
    _hx_class_name = "python.io.IFileInput"
    __slots__ = ()
    _hx_interfaces = [python_io_IInput]
python_io_IFileInput._hx_class = python_io_IFileInput
_hx_classes["python.io.IFileInput"] = python_io_IFileInput


class python_io_NativeOutput(haxe_io_Output):
    _hx_class_name = "python.io.NativeOutput"
    __slots__ = ("stream",)
    _hx_fields = ["stream"]
    _hx_methods = ["close", "prepare"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Output


    def __init__(self,stream):
        self.stream = None
        self.set_bigEndian(False)
        self.stream = stream
        if (not stream.writable()):
            raise haxe_Exception.thrown("Read only stream")

    def close(self):
        self.stream.close()

    def prepare(self,nbytes):
        self.stream.truncate(nbytes)

python_io_NativeOutput._hx_class = python_io_NativeOutput
_hx_classes["python.io.NativeOutput"] = python_io_NativeOutput


class python_io_IOutput:
    _hx_class_name = "python.io.IOutput"
    __slots__ = ("bigEndian",)
    _hx_fields = ["bigEndian"]
    _hx_methods = ["set_bigEndian", "writeByte", "writeBytes", "close", "writeFullBytes", "prepare", "writeString"]
python_io_IOutput._hx_class = python_io_IOutput
_hx_classes["python.io.IOutput"] = python_io_IOutput


class python_io_IFileOutput:
    _hx_class_name = "python.io.IFileOutput"
    __slots__ = ()
    _hx_interfaces = [python_io_IOutput]
python_io_IFileOutput._hx_class = python_io_IFileOutput
_hx_classes["python.io.IFileOutput"] = python_io_IFileOutput


class python_io_NativeTextInput(python_io_NativeInput):
    _hx_class_name = "python.io.NativeTextInput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["readByte", "readinto"]
    _hx_statics = []
    _hx_interfaces = [python_io_IInput]
    _hx_super = python_io_NativeInput


    def __init__(self,stream):
        super().__init__(stream)

    def readByte(self):
        ret = self.stream.buffer.read(1)
        if (len(ret) == 0):
            self.throwEof()
        return ret[0]

    def readinto(self,b):
        return self.stream.buffer.readinto(b)

python_io_NativeTextInput._hx_class = python_io_NativeTextInput
_hx_classes["python.io.NativeTextInput"] = python_io_NativeTextInput


class python_io_FileTextInput(python_io_NativeTextInput):
    _hx_class_name = "python.io.FileTextInput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = [python_io_IFileInput]
    _hx_super = python_io_NativeTextInput


    def __init__(self,stream):
        super().__init__(stream)
python_io_FileTextInput._hx_class = python_io_FileTextInput
_hx_classes["python.io.FileTextInput"] = python_io_FileTextInput


class python_io_NativeTextOutput(python_io_NativeOutput):
    _hx_class_name = "python.io.NativeTextOutput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = ["writeBytes", "writeByte"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = python_io_NativeOutput


    def __init__(self,stream):
        super().__init__(stream)
        if (not stream.writable()):
            raise haxe_Exception.thrown("Read only stream")

    def writeBytes(self,s,pos,_hx_len):
        return self.stream.buffer.write(s.b[pos:(pos + _hx_len)])

    def writeByte(self,c):
        self.stream.write("".join(map(chr,[c])))

python_io_NativeTextOutput._hx_class = python_io_NativeTextOutput
_hx_classes["python.io.NativeTextOutput"] = python_io_NativeTextOutput


class python_io_FileTextOutput(python_io_NativeTextOutput):
    _hx_class_name = "python.io.FileTextOutput"
    __slots__ = ()
    _hx_fields = []
    _hx_methods = []
    _hx_statics = []
    _hx_interfaces = [python_io_IFileOutput]
    _hx_super = python_io_NativeTextOutput


    def __init__(self,stream):
        super().__init__(stream)
python_io_FileTextOutput._hx_class = python_io_FileTextOutput
_hx_classes["python.io.FileTextOutput"] = python_io_FileTextOutput


class python_io_IoTools:
    _hx_class_name = "python.io.IoTools"
    __slots__ = ()
    _hx_statics = ["createFileInputFromText", "createFileOutputFromText"]

    @staticmethod
    def createFileInputFromText(t):
        return sys_io_FileInput(python_io_FileTextInput(t))

    @staticmethod
    def createFileOutputFromText(t):
        return sys_io_FileOutput(python_io_FileTextOutput(t))
python_io_IoTools._hx_class = python_io_IoTools
_hx_classes["python.io.IoTools"] = python_io_IoTools


class sys_net_Socket:
    _hx_class_name = "sys.net.Socket"
    __slots__ = ("_hx___s", "input", "output")
    _hx_fields = ["__s", "input", "output"]
    _hx_methods = ["__initSocket", "close", "connect", "shutdown", "setTimeout", "fileno"]

    def __init__(self):
        self.output = None
        self.input = None
        self._hx___s = None
        self._hx___initSocket()
        self.input = sys_net__Socket_SocketInput(self._hx___s)
        self.output = sys_net__Socket_SocketOutput(self._hx___s)

    def _hx___initSocket(self):
        self._hx___s = python_lib_socket_Socket()

    def close(self):
        self._hx___s.close()

    def connect(self,host,port):
        host_str = host.toString()
        self._hx___s.connect((host_str, port))

    def shutdown(self,read,write):
        self._hx___s.shutdown((python_lib_Socket.SHUT_RDWR if ((read and write)) else (python_lib_Socket.SHUT_RD if read else python_lib_Socket.SHUT_WR)))

    def setTimeout(self,timeout):
        self._hx___s.settimeout(timeout)

    def fileno(self):
        return self._hx___s.fileno()

sys_net_Socket._hx_class = sys_net_Socket
_hx_classes["sys.net.Socket"] = sys_net_Socket


class python_net_SslSocket(sys_net_Socket):
    _hx_class_name = "python.net.SslSocket"
    __slots__ = ("hostName",)
    _hx_fields = ["hostName"]
    _hx_methods = ["__initSocket", "connect"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = sys_net_Socket


    def __init__(self):
        self.hostName = None
        super().__init__()

    def _hx___initSocket(self):
        context = python_lib_ssl_SSLContext(python_lib_Ssl.PROTOCOL_SSLv23)
        context.verify_mode = python_lib_Ssl.CERT_REQUIRED
        context.set_default_verify_paths()
        context.options = (context.options | python_lib_Ssl.OP_NO_SSLv2)
        context.options = (context.options | python_lib_Ssl.OP_NO_SSLv3)
        context.options = (context.options | python_lib_Ssl.OP_NO_COMPRESSION)
        context.options = (context.options | python_lib_Ssl.OP_NO_TLSv1)
        self._hx___s = python_lib_socket_Socket()
        self._hx___s = context.wrap_socket(self._hx___s,False,True,True,self.hostName)

    def connect(self,host,port):
        self.hostName = host.host
        super().connect(host,port)

python_net_SslSocket._hx_class = python_net_SslSocket
_hx_classes["python.net.SslSocket"] = python_net_SslSocket


class sys_Http(haxe_http_HttpBase):
    _hx_class_name = "sys.Http"
    __slots__ = ("noShutdown", "cnxTimeout", "responseHeaders", "chunk_size", "chunk_buf", "file")
    _hx_fields = ["noShutdown", "cnxTimeout", "responseHeaders", "chunk_size", "chunk_buf", "file"]
    _hx_methods = ["request", "customRequest", "writeBody", "readHttpResponse", "readChunk"]
    _hx_statics = ["PROXY", "requestUrl"]
    _hx_interfaces = []
    _hx_super = haxe_http_HttpBase


    def __init__(self,url):
        self.file = None
        self.chunk_buf = None
        self.chunk_size = None
        self.responseHeaders = None
        self.noShutdown = None
        self.cnxTimeout = 10
        super().__init__(url)

    def request(self,post = None):
        _gthis = self
        output = haxe_io_BytesOutput()
        old = self.onError
        err = False
        def _hx_local_0(e):
            nonlocal err
            _gthis.responseBytes = output.getBytes()
            err = True
            _gthis.onError = old
            _gthis.onError(e)
        self.onError = _hx_local_0
        post = ((post or ((self.postBytes is not None))) or ((self.postData is not None)))
        self.customRequest(post,output)
        if (not err):
            self.success(output.getBytes())

    def customRequest(self,post,api,sock = None,method = None):
        self.responseAsString = None
        self.responseBytes = None
        url_regexp = EReg("^(https?://)?([a-zA-Z\\.0-9_-]+)(:[0-9]+)?(.*)$","")
        url_regexp.matchObj = python_lib_Re.search(url_regexp.pattern,self.url)
        if (url_regexp.matchObj is None):
            self.onError("Invalid URL")
            return
        secure = (url_regexp.matchObj.group(1) == "https://")
        if (sock is None):
            if secure:
                sock = python_net_SslSocket()
            else:
                sock = sys_net_Socket()
            sock.setTimeout(self.cnxTimeout)
        host = url_regexp.matchObj.group(2)
        portString = url_regexp.matchObj.group(3)
        request = url_regexp.matchObj.group(4)
        if ((("" if ((0 >= len(request))) else request[0])) != "/"):
            request = ("/" + ("null" if request is None else request))
        port = ((443 if secure else 80) if (((portString is None) or ((portString == "")))) else Std.parseInt(HxString.substr(portString,1,(len(portString) - 1))))
        multipart = (self.file is not None)
        boundary = None
        uri = None
        if multipart:
            post = True
            boundary = (((Std.string(int((python_lib_Random.random() * 1000))) + Std.string(int((python_lib_Random.random() * 1000)))) + Std.string(int((python_lib_Random.random() * 1000)))) + Std.string(int((python_lib_Random.random() * 1000))))
            while (len(boundary) < 38):
                boundary = ("-" + ("null" if boundary is None else boundary))
            b_b = python_lib_io_StringIO()
            _g = 0
            _g1 = self.params
            while (_g < len(_g1)):
                p = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
                _g = (_g + 1)
                b_b.write("--")
                b_b.write(Std.string(boundary))
                b_b.write("\r\n")
                b_b.write("Content-Disposition: form-data; name=\"")
                b_b.write(Std.string(p.name))
                b_b.write("\"")
                b_b.write("\r\n")
                b_b.write("\r\n")
                b_b.write(Std.string(p.value))
                b_b.write("\r\n")
            b_b.write("--")
            b_b.write(Std.string(boundary))
            b_b.write("\r\n")
            b_b.write("Content-Disposition: form-data; name=\"")
            b_b.write(Std.string(self.file.param))
            b_b.write("\"; filename=\"")
            b_b.write(Std.string(self.file.filename))
            b_b.write("\"")
            b_b.write("\r\n")
            b_b.write(Std.string(((("Content-Type: " + HxOverrides.stringOrNull(self.file.mimeType)) + "\r\n") + "\r\n")))
            uri = b_b.getvalue()
        else:
            _g = 0
            _g1 = self.params
            while (_g < len(_g1)):
                p = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
                _g = (_g + 1)
                if (uri is None):
                    uri = ""
                else:
                    uri = (("null" if uri is None else uri) + "&")
                uri = (("null" if uri is None else uri) + HxOverrides.stringOrNull((((HxOverrides.stringOrNull(python_lib_urllib_Parse.quote(p.name,"")) + "=") + HxOverrides.stringOrNull(python_lib_urllib_Parse.quote(("" + HxOverrides.stringOrNull(p.value)),""))))))
        b = haxe_io_BytesOutput()
        if (method is not None):
            b.writeString(method)
            b.writeString(" ")
        elif post:
            b.writeString("POST ")
        else:
            b.writeString("GET ")
        if (sys_Http.PROXY is not None):
            b.writeString("http://")
            b.writeString(host)
            if (port != 80):
                b.writeString(":")
                b.writeString(("" + Std.string(port)))
        b.writeString(request)
        if ((not post) and ((uri is not None))):
            if (HxString.indexOfImpl(request,"?",0) >= 0):
                b.writeString("&")
            else:
                b.writeString("?")
            b.writeString(uri)
        b.writeString(((" HTTP/1.1\r\nHost: " + ("null" if host is None else host)) + "\r\n"))
        if (self.postData is not None):
            self.postBytes = haxe_io_Bytes.ofString(self.postData)
            self.postData = None
        if (self.postBytes is not None):
            b.writeString((("Content-Length: " + Std.string(self.postBytes.length)) + "\r\n"))
        elif (post and ((uri is not None))):
            def _hx_local_4(h):
                return (h.name == "Content-Type")
            if (multipart or (not Lambda.exists(self.headers,_hx_local_4))):
                b.writeString("Content-Type: ")
                if multipart:
                    b.writeString("multipart/form-data")
                    b.writeString("; boundary=")
                    b.writeString(boundary)
                else:
                    b.writeString("application/x-www-form-urlencoded")
                b.writeString("\r\n")
            if multipart:
                b.writeString((("Content-Length: " + Std.string(((((len(uri) + self.file.size) + len(boundary)) + 6)))) + "\r\n"))
            else:
                b.writeString((("Content-Length: " + Std.string(len(uri))) + "\r\n"))
        b.writeString("Connection: close\r\n")
        _g = 0
        _g1 = self.headers
        while (_g < len(_g1)):
            h = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            b.writeString(h.name)
            b.writeString(": ")
            b.writeString(h.value)
            b.writeString("\r\n")
        b.writeString("\r\n")
        if (self.postBytes is not None):
            b.writeFullBytes(self.postBytes,0,self.postBytes.length)
        elif (post and ((uri is not None))):
            b.writeString(uri)
        try:
            if (sys_Http.PROXY is not None):
                sock.connect(sys_net_Host(sys_Http.PROXY.host),sys_Http.PROXY.port)
            else:
                sock.connect(sys_net_Host(host),port)
            if multipart:
                self.writeBody(b,self.file.io,self.file.size,boundary,sock)
            else:
                self.writeBody(b,None,0,None,sock)
            self.readHttpResponse(api,sock)
            sock.close()
        except BaseException as _g:
            e = haxe_Exception.caught(_g).unwrap()
            try:
                sock.close()
            except BaseException as _g:
                pass
            self.onError(Std.string(e))

    def writeBody(self,body,fileInput,fileSize,boundary,sock):
        if (body is not None):
            _hx_bytes = body.getBytes()
            sock.output.writeFullBytes(_hx_bytes,0,_hx_bytes.length)
        if (boundary is not None):
            bufsize = 4096
            buf = haxe_io_Bytes.alloc(bufsize)
            while (fileSize > 0):
                size = (bufsize if ((fileSize > bufsize)) else fileSize)
                _hx_len = 0
                try:
                    _hx_len = fileInput.readBytes(buf,0,size)
                except BaseException as _g:
                    if Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof):
                        break
                    else:
                        raise _g
                sock.output.writeFullBytes(buf,0,_hx_len)
                fileSize = (fileSize - _hx_len)
            sock.output.writeString("\r\n")
            sock.output.writeString("--")
            sock.output.writeString(boundary)
            sock.output.writeString("--")

    def readHttpResponse(self,api,sock):
        b = haxe_io_BytesBuffer()
        k = 4
        s = haxe_io_Bytes.alloc(4)
        sock.setTimeout(self.cnxTimeout)
        while True:
            p = sock.input.readBytes(s,0,k)
            while (p != k):
                p = (p + sock.input.readBytes(s,p,(k - p)))
            if ((k < 0) or ((k > s.length))):
                raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
            b.b.extend(s.b[0:k])
            k1 = k
            if (k1 == 1):
                c = s.b[0]
                if (c == 10):
                    break
                if (c == 13):
                    k = 3
                else:
                    k = 4
            elif (k1 == 2):
                c1 = s.b[1]
                if (c1 == 10):
                    if (s.b[0] == 13):
                        break
                    k = 4
                elif (c1 == 13):
                    k = 3
                else:
                    k = 4
            elif (k1 == 3):
                c2 = s.b[2]
                if (c2 == 10):
                    if (s.b[1] != 13):
                        k = 4
                    elif (s.b[0] != 10):
                        k = 2
                    else:
                        break
                elif (c2 == 13):
                    if ((s.b[1] != 10) or ((s.b[0] != 13))):
                        k = 1
                    else:
                        k = 3
                else:
                    k = 4
            elif (k1 == 4):
                c3 = s.b[3]
                if (c3 == 10):
                    if (s.b[2] != 13):
                        continue
                    elif ((s.b[1] != 10) or ((s.b[0] != 13))):
                        k = 2
                    else:
                        break
                elif (c3 == 13):
                    if ((s.b[2] != 10) or ((s.b[1] != 13))):
                        k = 3
                    else:
                        k = 1
            else:
                pass
        _this = b.getBytes().toString()
        headers = _this.split("\r\n")
        response = (None if ((len(headers) == 0)) else headers.pop(0))
        rp = response.split(" ")
        status = Std.parseInt((rp[1] if 1 < len(rp) else None))
        if ((status == 0) or ((status is None))):
            raise haxe_Exception.thrown("Response status error")
        if (len(headers) != 0):
            headers.pop()
        if (len(headers) != 0):
            headers.pop()
        self.responseHeaders = haxe_ds_StringMap()
        size = None
        chunked = False
        _g = 0
        while (_g < len(headers)):
            hline = (headers[_g] if _g >= 0 and _g < len(headers) else None)
            _g = (_g + 1)
            a = hline.split(": ")
            hname = (None if ((len(a) == 0)) else a.pop(0))
            hval = ((a[0] if 0 < len(a) else None) if ((len(a) == 1)) else ": ".join([python_Boot.toString1(x1,'') for x1 in a]))
            hval = StringTools.ltrim(StringTools.rtrim(hval))
            self.responseHeaders.h[hname] = hval
            _g1 = hname.lower()
            _hx_local_2 = len(_g1)
            if (_hx_local_2 == 17):
                if (_g1 == "transfer-encoding"):
                    chunked = (hval.lower() == "chunked")
            elif (_hx_local_2 == 14):
                if (_g1 == "content-length"):
                    size = Std.parseInt(hval)
            else:
                pass
        self.onStatus(status)
        chunk_re = EReg("^([0-9A-Fa-f]+)[ ]*\r\n","m")
        self.chunk_size = None
        self.chunk_buf = None
        bufsize = 1024
        buf = haxe_io_Bytes.alloc(bufsize)
        if chunked:
            try:
                while True:
                    _hx_len = sock.input.readBytes(buf,0,bufsize)
                    if (not self.readChunk(chunk_re,api,buf,_hx_len)):
                        break
            except BaseException as _g:
                if Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof):
                    raise haxe_Exception.thrown("Transfer aborted")
                else:
                    raise _g
        elif (size is None):
            if (not self.noShutdown):
                sock.shutdown(False,True)
            try:
                while True:
                    _hx_len = sock.input.readBytes(buf,0,bufsize)
                    if (_hx_len == 0):
                        break
                    api.writeBytes(buf,0,_hx_len)
            except BaseException as _g:
                if (not Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof)):
                    raise _g
        else:
            api.prepare(size)
            try:
                while (size > 0):
                    _hx_len = sock.input.readBytes(buf,0,(bufsize if ((size > bufsize)) else size))
                    api.writeBytes(buf,0,_hx_len)
                    size = (size - _hx_len)
            except BaseException as _g:
                if Std.isOfType(haxe_Exception.caught(_g).unwrap(),haxe_io_Eof):
                    raise haxe_Exception.thrown("Transfer aborted")
                else:
                    raise _g
        if (chunked and (((self.chunk_size is not None) or ((self.chunk_buf is not None))))):
            raise haxe_Exception.thrown("Invalid chunk")
        if ((status < 200) or ((status >= 400))):
            raise haxe_Exception.thrown(("Http Error #" + Std.string(status)))
        api.close()

    def readChunk(self,chunk_re,api,buf,_hx_len):
        if (self.chunk_size is None):
            if (self.chunk_buf is not None):
                b = haxe_io_BytesBuffer()
                b.b.extend(self.chunk_buf.b)
                if ((_hx_len < 0) or ((_hx_len > buf.length))):
                    raise haxe_Exception.thrown(haxe_io_Error.OutsideBounds)
                b.b.extend(buf.b[0:_hx_len])
                buf = b.getBytes()
                _hx_len = (_hx_len + self.chunk_buf.length)
                self.chunk_buf = None
            s = buf.toString()
            chunk_re.matchObj = python_lib_Re.search(chunk_re.pattern,s)
            if (chunk_re.matchObj is not None):
                p_pos = chunk_re.matchObj.start()
                p_len = (chunk_re.matchObj.end() - chunk_re.matchObj.start())
                if (p_len <= _hx_len):
                    cstr = chunk_re.matchObj.group(1)
                    self.chunk_size = Std.parseInt(("0x" + ("null" if cstr is None else cstr)))
                    if (self.chunk_size == 0):
                        self.chunk_size = None
                        self.chunk_buf = None
                        return False
                    _hx_len = (_hx_len - p_len)
                    return self.readChunk(chunk_re,api,buf.sub(p_len,_hx_len),_hx_len)
            if (_hx_len > 10):
                self.onError("Invalid chunk")
                return False
            self.chunk_buf = buf.sub(0,_hx_len)
            return True
        if (self.chunk_size > _hx_len):
            _hx_local_2 = self
            _hx_local_3 = _hx_local_2.chunk_size
            _hx_local_2.chunk_size = (_hx_local_3 - _hx_len)
            _hx_local_2.chunk_size
            api.writeBytes(buf,0,_hx_len)
            return True
        end = (self.chunk_size + 2)
        if (_hx_len >= end):
            if (self.chunk_size > 0):
                api.writeBytes(buf,0,self.chunk_size)
            _hx_len = (_hx_len - end)
            self.chunk_size = None
            if (_hx_len == 0):
                return True
            return self.readChunk(chunk_re,api,buf.sub(end,_hx_len),_hx_len)
        if (self.chunk_size > 0):
            api.writeBytes(buf,0,self.chunk_size)
        _hx_local_5 = self
        _hx_local_6 = _hx_local_5.chunk_size
        _hx_local_5.chunk_size = (_hx_local_6 - _hx_len)
        _hx_local_5.chunk_size
        return True

    @staticmethod
    def requestUrl(url):
        h = sys_Http(url)
        r = None
        def _hx_local_0(d):
            nonlocal r
            r = d
        h.onData = _hx_local_0
        def _hx_local_1(e):
            raise haxe_Exception.thrown(e)
        h.onError = _hx_local_1
        h.request(False)
        return r

sys_Http._hx_class = sys_Http
_hx_classes["sys.Http"] = sys_Http


class sys_io_File:
    _hx_class_name = "sys.io.File"
    __slots__ = ()
    _hx_statics = ["getContent", "saveContent", "getBytes", "saveBytes", "copy"]

    @staticmethod
    def getContent(path):
        f = python_lib_Builtins.open(path,"r",-1,"utf-8",None,"")
        content = f.read(-1)
        f.close()
        return content

    @staticmethod
    def saveContent(path,content):
        f = python_lib_Builtins.open(path,"w",-1,"utf-8",None,"")
        f.write(content)
        f.close()

    @staticmethod
    def getBytes(path):
        f = python_lib_Builtins.open(path,"rb",-1)
        size = f.read(-1)
        b = haxe_io_Bytes.ofData(size)
        f.close()
        return b

    @staticmethod
    def saveBytes(path,_hx_bytes):
        f = python_lib_Builtins.open(path,"wb",-1)
        f.write(_hx_bytes.b)
        f.close()

    @staticmethod
    def copy(srcPath,dstPath):
        python_lib_Shutil.copy(srcPath,dstPath)
sys_io_File._hx_class = sys_io_File
_hx_classes["sys.io.File"] = sys_io_File


class sys_io_FileInput(haxe_io_Input):
    _hx_class_name = "sys.io.FileInput"
    __slots__ = ("impl",)
    _hx_fields = ["impl"]
    _hx_methods = ["set_bigEndian", "readByte", "readBytes", "readAll"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Input


    def __init__(self,impl):
        self.impl = impl

    def set_bigEndian(self,b):
        return self.impl.set_bigEndian(b)

    def readByte(self):
        return self.impl.readByte()

    def readBytes(self,s,pos,_hx_len):
        return self.impl.readBytes(s,pos,_hx_len)

    def readAll(self,bufsize = None):
        return self.impl.readAll(bufsize)

sys_io_FileInput._hx_class = sys_io_FileInput
_hx_classes["sys.io.FileInput"] = sys_io_FileInput


class sys_io_FileOutput(haxe_io_Output):
    _hx_class_name = "sys.io.FileOutput"
    __slots__ = ("impl",)
    _hx_fields = ["impl"]
    _hx_methods = ["set_bigEndian", "writeByte", "writeBytes", "close", "writeFullBytes", "prepare", "writeString"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Output


    def __init__(self,impl):
        self.impl = impl

    def set_bigEndian(self,b):
        return self.impl.set_bigEndian(b)

    def writeByte(self,c):
        self.impl.writeByte(c)

    def writeBytes(self,s,pos,_hx_len):
        return self.impl.writeBytes(s,pos,_hx_len)

    def close(self):
        self.impl.close()

    def writeFullBytes(self,s,pos,_hx_len):
        self.impl.writeFullBytes(s,pos,_hx_len)

    def prepare(self,nbytes):
        self.impl.prepare(nbytes)

    def writeString(self,s,encoding = None):
        self.impl.writeString(s)

sys_io_FileOutput._hx_class = sys_io_FileOutput
_hx_classes["sys.io.FileOutput"] = sys_io_FileOutput


class sys_io_Process:
    _hx_class_name = "sys.io.Process"
    __slots__ = ("stdout", "stderr", "stdin", "p")
    _hx_fields = ["stdout", "stderr", "stdin", "p"]

    def __init__(self,cmd,args = None,detached = None):
        self.stdin = None
        self.stderr = None
        self.stdout = None
        if detached:
            raise haxe_Exception.thrown("Detached process is not supported on this platform")
        args1 = (cmd if ((args is None)) else ([cmd] + args))
        o = _hx_AnonObject({'shell': (args is None), 'stdin': python_lib_Subprocess.PIPE, 'stdout': python_lib_Subprocess.PIPE, 'stderr': python_lib_Subprocess.PIPE})
        Reflect.setField(o,"bufsize",(Reflect.field(o,"bufsize") if (python_Boot.hasField(o,"bufsize")) else 0))
        Reflect.setField(o,"executable",(Reflect.field(o,"executable") if (python_Boot.hasField(o,"executable")) else None))
        Reflect.setField(o,"stdin",(Reflect.field(o,"stdin") if (python_Boot.hasField(o,"stdin")) else None))
        Reflect.setField(o,"stdout",(Reflect.field(o,"stdout") if (python_Boot.hasField(o,"stdout")) else None))
        Reflect.setField(o,"stderr",(Reflect.field(o,"stderr") if (python_Boot.hasField(o,"stderr")) else None))
        Reflect.setField(o,"preexec_fn",(Reflect.field(o,"preexec_fn") if (python_Boot.hasField(o,"preexec_fn")) else None))
        Reflect.setField(o,"close_fds",(Reflect.field(o,"close_fds") if (python_Boot.hasField(o,"close_fds")) else None))
        Reflect.setField(o,"shell",(Reflect.field(o,"shell") if (python_Boot.hasField(o,"shell")) else None))
        Reflect.setField(o,"cwd",(Reflect.field(o,"cwd") if (python_Boot.hasField(o,"cwd")) else None))
        Reflect.setField(o,"env",(Reflect.field(o,"env") if (python_Boot.hasField(o,"env")) else None))
        Reflect.setField(o,"universal_newlines",(Reflect.field(o,"universal_newlines") if (python_Boot.hasField(o,"universal_newlines")) else None))
        Reflect.setField(o,"startupinfo",(Reflect.field(o,"startupinfo") if (python_Boot.hasField(o,"startupinfo")) else None))
        Reflect.setField(o,"creationflags",(Reflect.field(o,"creationflags") if (python_Boot.hasField(o,"creationflags")) else 0))
        self.p = (python_lib_subprocess_Popen(args1,Reflect.field(o,"bufsize"),Reflect.field(o,"executable"),Reflect.field(o,"stdin"),Reflect.field(o,"stdout"),Reflect.field(o,"stderr"),Reflect.field(o,"preexec_fn"),Reflect.field(o,"close_fds"),Reflect.field(o,"shell"),Reflect.field(o,"cwd"),Reflect.field(o,"env"),Reflect.field(o,"universal_newlines"),Reflect.field(o,"startupinfo"),Reflect.field(o,"creationflags")) if ((Sys.systemName() == "Windows")) else python_lib_subprocess_Popen(args1,Reflect.field(o,"bufsize"),Reflect.field(o,"executable"),Reflect.field(o,"stdin"),Reflect.field(o,"stdout"),Reflect.field(o,"stderr"),Reflect.field(o,"preexec_fn"),Reflect.field(o,"close_fds"),Reflect.field(o,"shell"),Reflect.field(o,"cwd"),Reflect.field(o,"env"),Reflect.field(o,"universal_newlines"),Reflect.field(o,"startupinfo")))
        self.stdout = python_io_IoTools.createFileInputFromText(python_lib_io_TextIOWrapper(python_lib_io_BufferedReader(self.p.stdout)))
        self.stderr = python_io_IoTools.createFileInputFromText(python_lib_io_TextIOWrapper(python_lib_io_BufferedReader(self.p.stderr)))
        self.stdin = python_io_IoTools.createFileOutputFromText(python_lib_io_TextIOWrapper(python_lib_io_BufferedWriter(self.p.stdin)))

sys_io_Process._hx_class = sys_io_Process
_hx_classes["sys.io.Process"] = sys_io_Process


class sys_net_Host:
    _hx_class_name = "sys.net.Host"
    __slots__ = ("host", "name")
    _hx_fields = ["host", "name"]
    _hx_methods = ["toString"]

    def __init__(self,name):
        self.host = name
        self.name = name

    def toString(self):
        return self.name

sys_net_Host._hx_class = sys_net_Host
_hx_classes["sys.net.Host"] = sys_net_Host


class sys_net__Socket_SocketInput(haxe_io_Input):
    _hx_class_name = "sys.net._Socket.SocketInput"
    __slots__ = ("_hx___s",)
    _hx_fields = ["__s"]
    _hx_methods = ["readByte", "readBytes"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Input


    def __init__(self,s):
        self._hx___s = s

    def readByte(self):
        r = None
        try:
            r = self._hx___s.recv(1,0)
        except BaseException as _g:
            if Std.isOfType(haxe_Exception.caught(_g).unwrap(),BlockingIOError):
                raise haxe_Exception.thrown(haxe_io_Error.Blocked)
            else:
                raise _g
        if (len(r) == 0):
            raise haxe_Exception.thrown(haxe_io_Eof())
        return r[0]

    def readBytes(self,buf,pos,_hx_len):
        r = None
        data = buf.b
        try:
            r = self._hx___s.recv(_hx_len,0)
            _g = pos
            _g1 = (pos + len(r))
            while (_g < _g1):
                i = _g
                _g = (_g + 1)
                data.__setitem__(i,r[(i - pos)])
        except BaseException as _g:
            if Std.isOfType(haxe_Exception.caught(_g).unwrap(),BlockingIOError):
                raise haxe_Exception.thrown(haxe_io_Error.Blocked)
            else:
                raise _g
        if (len(r) == 0):
            raise haxe_Exception.thrown(haxe_io_Eof())
        return len(r)

sys_net__Socket_SocketInput._hx_class = sys_net__Socket_SocketInput
_hx_classes["sys.net._Socket.SocketInput"] = sys_net__Socket_SocketInput


class sys_net__Socket_SocketOutput(haxe_io_Output):
    _hx_class_name = "sys.net._Socket.SocketOutput"
    __slots__ = ("_hx___s",)
    _hx_fields = ["__s"]
    _hx_methods = ["writeByte", "writeBytes", "close"]
    _hx_statics = []
    _hx_interfaces = []
    _hx_super = haxe_io_Output


    def __init__(self,s):
        self._hx___s = s

    def writeByte(self,c):
        try:
            self._hx___s.send(bytes([c]),0)
        except BaseException as _g:
            if Std.isOfType(haxe_Exception.caught(_g).unwrap(),BlockingIOError):
                raise haxe_Exception.thrown(haxe_io_Error.Blocked)
            else:
                raise _g

    def writeBytes(self,buf,pos,_hx_len):
        try:
            data = buf.b
            payload = data[pos:pos+_hx_len]
            r = self._hx___s.send(payload,0)
            return r
        except BaseException as _g:
            if Std.isOfType(haxe_Exception.caught(_g).unwrap(),BlockingIOError):
                raise haxe_Exception.thrown(haxe_io_Error.Blocked)
            else:
                raise _g

    def close(self):
        super().close()
        if (self._hx___s is not None):
            self._hx___s.close()

sys_net__Socket_SocketOutput._hx_class = sys_net__Socket_SocketOutput
_hx_classes["sys.net._Socket.SocketOutput"] = sys_net__Socket_SocketOutput


class task_TaskCommand:
    _hx_class_name = "task.TaskCommand"
    __slots__ = ("label", "command", "type", "problemMatcher", "group")
    _hx_fields = ["label", "command", "type", "problemMatcher", "group"]

    def __init__(self):
        self.command = None
        self.label = None
        self.group = _hx_AnonObject({'kind': "build"})
        self.problemMatcher = []
        self.type = "shell"

task_TaskCommand._hx_class = task_TaskCommand
_hx_classes["task.TaskCommand"] = task_TaskCommand


class task_Tasks:
    _hx_class_name = "task.Tasks"
    __slots__ = ()
    _hx_statics = ["initTask", "tasks"]

    @staticmethod
    def initTask():
        newdata = _hx_AnonObject({'version': "2.0.0", 'tasks': []})
        data = _hx_AnonObject({'version': "2.0.0", 'tasks': []})
        dir = python_internal_ArrayImpl._get(Sys.args(), (len(Sys.args()) - 1))
        if sys_FileSystem.exists((("null" if dir is None else dir) + "/.vscode/tasks.json")):
            haxe_Log.trace("tasks.json已存在，进行更新处理",_hx_AnonObject({'fileName': "src/task/Tasks.hx", 'lineNumber': 35, 'className': "task.Tasks", 'methodName': "initTask"}))
            tasks = sys_io_File.getContent((("null" if dir is None else dir) + "/.vscode/tasks.json"))
            datas = tasks.split("\n")
            _g_current = 0
            _g_array = datas
            while (_g_current < len(_g_array)):
                _g1_value = (_g_array[_g_current] if _g_current >= 0 and _g_current < len(_g_array) else None)
                _g1_key = _g_current
                _g_current = (_g_current + 1)
                index = _g1_key
                value = _g1_value
                startIndex = None
                if (((value.find("//") if ((startIndex is None)) else HxString.indexOfImpl(value,"//",startIndex))) != -1):
                    python_internal_ArrayImpl._set(datas, index, "")
            tasks = "\n".join([python_Boot.toString1(x1,'') for x1 in datas])
            data = python_lib_Json.loads(tasks,**python__KwArgs_KwArgs_Impl_.fromT(_hx_AnonObject({'object_hook': python_Lib.dictToAnon})))
        else:
            haxe_Log.trace("tasks.json不存在，创建新的任务列表",_hx_AnonObject({'fileName': "src/task/Tasks.hx", 'lineNumber': 46, 'className': "task.Tasks", 'methodName': "initTask"}))
        taskCommands = []
        _g = 0
        _g1 = task_Tasks.tasks.list
        while (_g < len(_g1)):
            tdata = (_g1[_g] if _g >= 0 and _g < len(_g1) else None)
            _g = (_g + 1)
            x = tdata.command
            taskCommands.append(x)
        _g2_current = 0
        _g2_array = data.tasks
        while (_g2_current < len(_g2_array)):
            _g3_value = (_g2_array[_g2_current] if _g2_current >= 0 and _g2_current < len(_g2_array) else None)
            _g3_key = _g2_current
            _g2_current = (_g2_current + 1)
            index = _g3_key
            value = _g3_value
            _hx_str = value.command
            tmp = None
            startIndex = None
            if (((_hx_str.find("haxelib run zygameui -updatelib") if ((startIndex is None)) else HxString.indexOfImpl(_hx_str,"haxelib run zygameui -updatelib",startIndex))) == -1):
                startIndex1 = None
                tmp = (((_hx_str.find("python3 tools/python/build.py") if ((startIndex1 is None)) else HxString.indexOfImpl(_hx_str,"python3 tools/python/build.py",startIndex1))) == -1)
            else:
                tmp = False
            if tmp:
                tmp1 = None
                tmp2 = None
                startIndex2 = None
                if (((_hx_str.find("haxelib run zygameui -debug") if ((startIndex2 is None)) else HxString.indexOfImpl(_hx_str,"haxelib run zygameui -debug",startIndex2))) == -1):
                    startIndex3 = None
                    tmp2 = (((_hx_str.find("haxelib run zygameui -build") if ((startIndex3 is None)) else HxString.indexOfImpl(_hx_str,"haxelib run zygameui -build",startIndex3))) != -1)
                else:
                    tmp2 = True
                if (not tmp2):
                    startIndex4 = None
                    tmp1 = (((_hx_str.find("haxelib run zygameui -final") if ((startIndex4 is None)) else HxString.indexOfImpl(_hx_str,"haxelib run zygameui -final",startIndex4))) != -1)
                else:
                    tmp1 = True
                if tmp1:
                    commandArray = _hx_str.split(" ")
                    command = python_internal_ArrayImpl._get(commandArray, (len(commandArray) - 1))
                    if (python_internal_ArrayImpl.indexOf(taskCommands,command,None) == -1):
                        _this = newdata.tasks
                        _this.append(value)
                else:
                    _this1 = newdata.tasks
                    _this1.append(value)
        arr = []
        _g2_current = 0
        _g2_array = task_Tasks.tasks.list
        while (_g2_current < len(_g2_array)):
            _g3_value = (_g2_array[_g2_current] if _g2_current >= 0 and _g2_current < len(_g2_array) else None)
            _g3_key = _g2_current
            _g2_current = (_g2_current + 1)
            index = _g3_key
            value = _g3_value
            _this = value.command
            startIndex = None
            if (((_this.find("haxelib") if ((startIndex is None)) else HxString.indexOfImpl(_this,"haxelib",startIndex))) == -1):
                x = value.name
                arr.append(x)
                c = task_TaskCommand()
                c.label = (HxOverrides.stringOrNull(value.name) + "(Build)")
                c.command = ("haxelib run zygameui -build " + HxOverrides.stringOrNull(value.command))
                _this1 = newdata.tasks
                _this1.append(c)
                c1 = task_TaskCommand()
                c1.label = (HxOverrides.stringOrNull(value.name) + "(Final)")
                c1.command = ("haxelib run zygameui -final " + HxOverrides.stringOrNull(value.command))
                _this2 = newdata.tasks
                _this2.append(c1)
                if ((value.command == "android") or ((value.command == "ios"))):
                    c2 = task_TaskCommand()
                    c2.label = (HxOverrides.stringOrNull(value.name) + "(Debug)")
                    c2.command = ("haxelib run zygameui -debug " + HxOverrides.stringOrNull(value.command))
                    _this3 = newdata.tasks
                    _this3.append(c2)
            else:
                c3 = task_TaskCommand()
                c3.label = value.name
                c3.command = value.command
                _this4 = newdata.tasks
                _this4.append(c3)
        sys_io_File.saveContent((("null" if dir is None else dir) + ".vscode/tasks.json"),haxe_format_JsonPrinter.print(newdata,None,None))
        haxe_Log.trace(("支持平台列表：\n" + HxOverrides.stringOrNull("\n".join([python_Boot.toString1(x1,'') for x1 in arr]))),_hx_AnonObject({'fileName': "src/task/Tasks.hx", 'lineNumber': 102, 'className': "task.Tasks", 'methodName': "initTask"}))
        haxe_Log.trace((("tasks.json同步" + Std.string(len(task_Tasks.tasks.list))) + "条编译命令"),_hx_AnonObject({'fileName': "src/task/Tasks.hx", 'lineNumber': 103, 'className': "task.Tasks", 'methodName': "initTask"}))
        haxe_Log.trace((("一共" + Std.string(len(newdata.tasks))) + "条编译命令"),_hx_AnonObject({'fileName': "src/task/Tasks.hx", 'lineNumber': 104, 'className': "task.Tasks", 'methodName': "initTask"}))
task_Tasks._hx_class = task_Tasks
_hx_classes["task.Tasks"] = task_Tasks


class xls_XlsBuild:
    _hx_class_name = "xls.XlsBuild"
    __slots__ = ()
    _hx_statics = ["build"]

    @staticmethod
    def build(path,saveDir):
        haxe_Log.trace("XLS:",_hx_AnonObject({'fileName': "src/xls/XlsBuild.hx", 'lineNumber': 10, 'className': "xls.XlsBuild", 'methodName': "build", 'customParams': [path, saveDir, sys_FileSystem.isDirectory(path)]}))
        if sys_FileSystem.isDirectory(path):
            array = sys_FileSystem.readDirectory(path)
            _g = 0
            while (_g < len(array)):
                _hx_str = (array[_g] if _g >= 0 and _g < len(array) else None)
                _g = (_g + 1)
                xls_XlsBuild.build(((("null" if path is None else path) + "/") + ("null" if _hx_str is None else _hx_str)),saveDir)
        elif (path.endswith("xlsx") or path.endswith("xls")):
            tmp = None
            startIndex = None
            if (((path.find(".") if ((startIndex is None)) else HxString.indexOfImpl(path,".",startIndex))) != 0):
                startIndex = None
                tmp = (((path.find("~") if ((startIndex is None)) else HxString.indexOfImpl(path,"~",startIndex))) == 0)
            else:
                tmp = True
            if tmp:
                return
            haxe_Log.trace(("parsing file:" + ("null" if path is None else path)),_hx_AnonObject({'fileName': "src/xls/XlsBuild.hx", 'lineNumber': 19, 'className': "xls.XlsBuild", 'methodName': "build"}))
            try:
                xlsData = python_XlsData.open_workbook(path)
                names = xlsData.sheet_names()
                _g = 0
                while (_g < len(names)):
                    name = (names[_g] if _g >= 0 and _g < len(names) else None)
                    _g = (_g + 1)
                    data = _hx_AnonObject({'data': []})
                    haxe_Log.trace((("do " + ("null" if name is None else name)) + " parsing..."),_hx_AnonObject({'fileName': "src/xls/XlsBuild.hx", 'lineNumber': 25, 'className': "xls.XlsBuild", 'methodName': "build"}))
                    sheet = xlsData.sheet_by_name(name)
                    keys = sheet.row_values(0)
                    newkeys = []
                    newDockey = []
                    docKeys = sheet.row_values(1)
                    _g1 = 0
                    _g2 = len(keys)
                    while (_g1 < _g2):
                        i = _g1
                        _g1 = (_g1 + 1)
                        s = (keys[i] if i >= 0 and i < len(keys) else None)
                        d = (docKeys[i] if i >= 0 and i < len(docKeys) else None)
                        if (((s != "") and ((s is not None))) and ((s != "null"))):
                            newkeys.append(s)
                            newDockey.append(_hx_AnonObject({'name': s, 'doc': d}))
                    keys = newkeys
                    if (len(newkeys) == 0):
                        continue
                    saveName = (newkeys[0] if 0 < len(newkeys) else None)
                    startIndex = None
                    if (((saveName.find(".") if ((startIndex is None)) else HxString.indexOfImpl(saveName,".",startIndex))) != -1):
                        startIndex1 = None
                        _hx_len = None
                        if (startIndex1 is None):
                            _hx_len = saveName.rfind(".", 0, len(saveName))
                        else:
                            i1 = saveName.rfind(".", 0, (startIndex1 + 1))
                            startLeft = (max(0,((startIndex1 + 1) - len("."))) if ((i1 == -1)) else (i1 + 1))
                            check = saveName.find(".", startLeft, len(saveName))
                            _hx_len = (check if (((check > i1) and ((check <= startIndex1)))) else i1)
                        saveName = HxString.substr(saveName,0,_hx_len)
                    else:
                        continue
                    haxe_Log.trace(("keys:" + Std.string(keys)),_hx_AnonObject({'fileName': "src/xls/XlsBuild.hx", 'lineNumber': 51, 'className': "xls.XlsBuild", 'methodName': "build"}))
                    _g3 = 2
                    _g4 = sheet.nrows
                    while (_g3 < _g4):
                        i2 = _g3
                        _g3 = (_g3 + 1)
                        values = sheet.row_values(i2)
                        obj = _hx_AnonObject({'id': (i2 - 1)})
                        _g5 = 1
                        _g6 = len(values)
                        while (_g5 < _g6):
                            i21 = _g5
                            _g5 = (_g5 + 1)
                            key = Std.string((keys[i21] if i21 >= 0 and i21 < len(keys) else None))
                            if (((key != "") and ((key is not None))) and ((key != "null"))):
                                Reflect.setProperty(obj,key,Std.string((values[i21] if i21 >= 0 and i21 < len(values) else None)))
                        Reflect.field(Reflect.field(data,"data"),"push")(obj)
                    Reflect.setField(data,"doc",_hx_AnonObject({}))
                    _g4_current = 0
                    _g4_array = newDockey
                    while (_g4_current < len(_g4_array)):
                        _g5_value = (_g4_array[_g4_current] if _g4_current >= 0 and _g4_current < len(_g4_array) else None)
                        _g5_key = _g4_current
                        _g4_current = (_g4_current + 1)
                        index = _g5_key
                        value = _g5_value
                        Reflect.setProperty(Reflect.field(data,"doc"),value.name,value.doc)
                    if (not sys_FileSystem.exists(saveDir)):
                        sys_FileSystem.createDirectory(saveDir)
                    sys_io_File.saveContent((((("null" if saveDir is None else saveDir) + "/") + ("null" if saveName is None else saveName)) + ".json"),haxe_format_JsonPrinter.print(data,None,None))
            except BaseException as _g:
                err = haxe_Exception.caught(_g)
                haxe_Log.trace((((("file " + ("null" if path is None else path)) + " is not xls, skip!") + "\n") + HxOverrides.stringOrNull(err.get_message())),_hx_AnonObject({'fileName': "src/xls/XlsBuild.hx", 'lineNumber': 75, 'className': "xls.XlsBuild", 'methodName': "build"}))
xls_XlsBuild._hx_class = xls_XlsBuild
_hx_classes["xls.XlsBuild"] = xls_XlsBuild

Math.NEGATIVE_INFINITY = float("-inf")
Math.POSITIVE_INFINITY = float("inf")
Math.NaN = float("nan")
Math.PI = python_lib_Math.pi

Build.platforms = ["android", "ios", "oppo", "vivo", "qqquick", "html5", "4399", "g4399", "xiaomi-zz", "xiaomi-h5", "xiaomi", "wechat", "tt", "baidu", "mgc", "wifi", "meizu", "mmh5", "facebook", "huawei", "qihoo", "bili", "hl", "electron", "ks", "lianxin"]
Build.mainFileName = None
Defines.defineMaps = haxe_ds_StringMap()
Tools.authorizationMaps = haxe_ds_StringMap()
Tools.haxelib = "/Users/grtf/haxelib"
Tools.version = "0.0.4"
Xml.Element = 0
Xml.PCData = 1
Xml.CData = 2
Xml.Comment = 3
Xml.DocType = 4
Xml.ProcessingInstruction = 5
Xml.Document = 6
def _hx_init_haxe_xml_Parser_escapes():
    def _hx_local_0():
        h = haxe_ds_StringMap()
        h.h["lt"] = "<"
        h.h["gt"] = ">"
        h.h["amp"] = "&"
        h.h["quot"] = "\""
        h.h["apos"] = "'"
        return h
    return _hx_local_0()
haxe_xml_Parser.escapes = _hx_init_haxe_xml_Parser_escapes()
hxml_UpdateHxml.haxelibPath = ""
python_Boot.keywords = set(["and", "del", "from", "not", "with", "as", "elif", "global", "or", "yield", "assert", "else", "if", "pass", "None", "break", "except", "import", "raise", "True", "class", "exec", "in", "return", "False", "continue", "finally", "is", "try", "def", "for", "lambda", "while"])
python_Boot.prefixLength = len("_hx_")
python_Lib.lineEnd = ("\r\n" if ((Sys.systemName() == "Windows")) else "\n")
sys_Http.PROXY = None
task_Tasks.tasks = _hx_AnonObject({'list': [_hx_AnonObject({'name': "HTML5", 'command': "html5"}), _hx_AnonObject({'name': "微信小游戏", 'command': "wechat"}), _hx_AnonObject({'name': "快手小游戏", 'command': "ks"}), _hx_AnonObject({'name': "4399游戏盒", 'command': "g4399"}), _hx_AnonObject({'name': "Bilibili快游戏", 'command': "bili"}), _hx_AnonObject({'name': "字节跳动快游戏", 'command': "tt"}), _hx_AnonObject({'name': "手Q小游戏", 'command': "qqquick"}), _hx_AnonObject({'name': "百度小游戏", 'command': "baidu"}), _hx_AnonObject({'name': "梦工厂小游戏", 'command': "mgc"}), _hx_AnonObject({'name': "奇虎小游戏", 'command': "qihoo"}), _hx_AnonObject({'name': "Facebook小游戏", 'command': "facebook"}), _hx_AnonObject({'name': "魅族快游戏", 'command': "meizu"}), _hx_AnonObject({'name': "华为快游戏", 'command': "huawei"}), _hx_AnonObject({'name': "小米快游戏", 'command': "xiaomi"}), _hx_AnonObject({'name': "移动MMH5小游戏", 'command': "mmh5"}), _hx_AnonObject({'name': "Vivo快游戏", 'command': "vivo"}), _hx_AnonObject({'name': "Oppo快游戏", 'command': "oppo"}), _hx_AnonObject({'name': "Wifi无极环境小游戏", 'command': "wifi"}), _hx_AnonObject({'name': "豹趣H5小游戏", 'command': "html5:baoqu"}), _hx_AnonObject({'name': "趣头条H5小游戏", 'command': "html5:quyouxi"}), _hx_AnonObject({'name': "360奇虎快游戏", 'command': "qihoo"}), _hx_AnonObject({'name': "九游UCH5小游戏", 'command': "html5:uc"}), _hx_AnonObject({'name': "安卓Android", 'command': "android"}), _hx_AnonObject({'name': "苹果IOS", 'command': "ios"}), _hx_AnonObject({'name': "4399H5全平台兼容小游戏", 'command': "4399"}), _hx_AnonObject({'name': "连信H5小游戏", 'command': "lianxin"}), _hx_AnonObject({'name': "小米赚赚H5小游戏", 'command': "xiaomi-zz"}), _hx_AnonObject({'name': "YY小游戏（H5）", 'command': "html5:yy"}), _hx_AnonObject({'name': "更新内部haxelib库", 'command': "haxelib run zygameui -updatelib"}), _hx_AnonObject({'name': "HashLink", 'command': "hl"}), _hx_AnonObject({'name': "Electron", 'command': "electron"}), _hx_AnonObject({'name': "生成Lime架构包", 'command': "haxelib run zygameui -pkg"})]})

Tools.main()

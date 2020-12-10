package zygame.utils;

/**
 * 大数值，用于支持数值超过一定常量的数值，不支持浮点数
 */
class BigInteger {

    private var _values:Array<Int> = [];

    private var _valStr:String;

    /**
     * 是否为正数
     */
    public var isPositive:Bool = true;

    /**
     * 用于支持大数值，value请传入字符串
     * @param val
     */
    public function new(val:String = "")
    {
        value = val;
    }

    public var value(get,set):String;
    private function set_value(val:String):String
    {
        _valStr = val;
        _values = MathUtils.value(val);
        return val;
    }
    private function get_value():String
    {
        if(_valStr == "")
            return "0";
        return (isPositive?"":"-")+_valStr;
    }

    /**
     * 次方运算
     * @param val 
     * @return BigInteger
     */
    public function pow(val:String):BigInteger
    {
        if(val == "0")
        {
            this._values = [1];
            this._valStr = "1";
            return this;
        }
        var curvalue:String = this.value;
        var value:Int = Std.parseInt(val) - 1;
        for(i in 0...value)
        {
            mul(curvalue);
        }
        return this;
    }

    /**
     * 删除结尾位数
     * @param len 
     * @return BigInteger
     */
    public function deleteEndNumber(len:Int):BigInteger
    {
        if(_values.length > len)
        {
            _values = _values.splice(0,_values.length - len);
            _valStr = _values.join("");
        }
        else
        {
            _values = [];
            _valStr = "0";
        }
        return this;
    }

    /**
     * 乘法计算
     * @param val
     * @return BigInteger
     */
    public function mul(val:String):BigInteger
    {
        if(value == "0" || val == "0")
        {
            //如果本身就是0，则无需计算
            value = "0";
            return this;
        }
        //检索是否为负数
        if(val.charAt(0) == "-")
        {
            val = val.substr(1);
            //值取反
            isPositive = !isPositive;
        }
        var big:BigInteger = new BigInteger(val);
        var value2:Array<Int> = big.getValues();
        var list:Array<Array<Int>> = [];
        for(i in 0...value2.length)
        {
            list.push(mul2(value2[i],value2.length - i - 1));
        }
        //开始相加
        var addValues:Array<Int> = [];
        //有多少位乘数，就补多少偏移位
        for(i2 in 0..._values.length + value2.length - 1)
        {
            var all:Int = 0;
            for(a in list)
            {
                if(i2 < a.length)
                    all += a[i2];
            }
            addValues.push(all);
        }
        //开始递增算法
        for(up in 0...addValues.length)
        {
            var value:Int = addValues[up];
            if(value > 0)
            {
                value = Std.int(value/10);
                addValues[up] -= value*10;
                if(up == addValues.length - 1)
                {
                    //最后一个
                    addValues.push(value);
                }
                else
                {
                    //递增
                    addValues[up + 1] += value;
                }
            }
        }
        addValues.reverse();
        _values = addValues;
        clearZero();
        _valStr = _values.join("");
        return this;
    }

    /**
     * 计算乘法
     * @param val 
     * @param py 偏移值，偏移多少就补多少个0
     * @return Array<Int>
     */
    private function mul2(val:Int,py:Int):Array<Int>
    {
        var arr:Array<Int> = _values.copy();
        for(i in 0...arr.length)
        {
            arr[i] *= val;
        }
        for(i2 in 0...py)
            arr.push(0);
        arr.reverse();
        return arr;
    }

    /**
     * 加法计算
     * @param val 
     * @return String
     */
    public function add(val:String):BigInteger
    {
        if(val.charAt(0) == "-")
        {
            val = val.substr(1);
            return sub(val);
        }
        if(!isPositive)
        {
            //如果为负数时，应让两者值相减
            isPositive = true;
            var big:BigInteger = sub(val);
            isPositive = !isPositive;
            return big;
        }
        //计算出相加值
        var _values2:Array<Int> = MathUtils.value(val);
        //将两个值倒序
        _values2.reverse();
        _values.reverse();
        //开始计算加法
        for(i in 0..._values2.length)
        {
            //如果长度比相加值短时，直接视为0+val[i]
            if(_values.length <= i)
            {
                //数值为空时，需要直接等于_value2值
                _values[i] = _values2[i];
            }
            else
            {
                //数值不为空时
                add2(i,_values2[i]);
            }
        }
        //恢复顺序
        _values.reverse();
        //更改现有值
        _valStr = _values.join("");
        //返回值
        return this;
    }

    /**
     * 从某个位置开始递增1
     * @param index 
     */
    private function add2(index:Int,value:Int):Void
    {
        if(_values.length == index)
        {
            _values[index] = value;
        }
        else
        {
            _values[index] += value;
            if(_values[index] >= 10)
            {
                _values[index] -= 10;
                add2(index+1,1);
            }
        }
    }

    /**
     * 计算递增减位
     * @param i 
     */
    public function sub(val:String):BigInteger
    {
        if(val.charAt(0) == "-")
        {
            val = val.substr(1);
            return add(val);
        }
        //计算出相加值
        var value2:BigInteger = new BigInteger(val);
        var _values2:Array<Int> = value2.getValues();
        //如果相减的数值
        if(isPositive && cheak("<",value2))
        {
            //如果值大于现有整数值，则取反相减
            var _values3:Array<Int> = _values;
            _values = _values2;
            _values2 = _values3;
            //更改为负数
            isPositive = false;
        }
        else if(!isPositive)
        {
            //如果本身就是负数的话，则相加
            isPositive = true;
            var big:BigInteger = add(val);
            isPositive = false;
            return big;
        }
        //将两个值倒序
        _values2.reverse();
        _values.reverse();
        //开始计算加减法
        for(i in 0..._values2.length)
        {
            //如果长度比相加值短时，直接视为0+val[i]
            if(_values.length <= i)
            {
                //数值为空时，需要直接等于_value2值，这时会变为负数
                _values[i] = _values2[i];
            }
            else
            {
                //数值不为空时
                sub2(_values,i,_values2[i]);
            }
        }
        //恢复顺序
        _values.reverse();
        //清空0
        clearZero();
        //更改现有值
        _valStr = _values.join("");
        //返回值
        return this;
    }

    /**
     * 递减
     * @param index 
     * @param value 
     */
    private function sub2(values:Array<Int>,index:Int,value:Int):Void
    {
        values[index] -= value;
        if(values[index] < 0)
        {
            values[index] += 10;
            sub2(values,index+1,1);
        }
    }

    /**
     * 清空多余的0
     */
    private function clearZero():Void
    {
        if(_values.length == 0)
            return;
        while(true)
        {
            if(_values[0] == 0)
            {
                _values.shift();
            }
            else
                break;
        }
    }

    public function getValues():Array<Int>
    {
        return _values;
    }

    /**
     * 检查数字的比较
     * @param type 支持>,<,<=,>=,==等比较方法
     * @param big 
     * @return Bool
     */
    public function cheak(type:String,big:BigInteger):Bool
    {
        switch(type)
        {
            case ">":
                //如果自身为正，比较为负时，为真
                if(this.isPositive && !big.isPositive)
                    return true;
                else if(!this.isPositive && big.isPositive)
                    return false;
                else if(this.isPositive && big.isPositive){
                    if(this.value.length > big.value.length)
                        return true;
                    else if(this.value.length == big.value.length)
                    {
                        for(i in 0...this._values.length)
                        {
                            if(this._values[i] > big.getValues()[i])
                            {
                                return true;
                            }
                            else if(this._values[i] < big.getValues()[i])
                            {
                                return false;
                            }
                        }
                        return false;
                    }
                }
                else if(!this.isPositive && !big.isPositive)
                {
                    if(this.value.length < big.value.length)
                        return true;
                    else if(this.value.length == big.value.length)
                    {
                        for(i in 0...this._values.length)
                        {
                            if(this._values[i] < big.getValues()[i])
                            {
                                return true;
                            }
                        }
                        return false;
                    }
                }
            case "<":
                return !cheak(">",big);
            case ">=":
                return cheak("==",big) || cheak(">",big);
            case "<=":
                return cheak("==",big) || !cheak(">=",big);
            case "==":
                //要么两个正的，要么两个负的，而且长度要一致
                if(this.value.length != big.value.length)
                    return false;
                else if((this.isPositive && big.isPositive) || (!this.isPositive && !big.isPositive)){
                    for(i in 0...this._values.length)
                    {
                        if(this._values[i] != big.getValues()[i])
                        {
                            return false;
                        }
                    }
                    return true;
                }
                else
                    return false;
        }
        return false;
    }

}

/**
 * BigInteger格式换算
 */
class UnitConversion {

    private var _unit:Array<String>;

    private var _digits:Int = 0;

    public function new(unit:Array<String>,digits:Int){
        _unit = unit;
        _digits = digits;
    }

    /**
     * 转换
     * @param big 
     * @return String
     */
    public function toNumber(big:BigInteger,retain:Int = 0,minMath:Int = 2):String
    {
        var values:Array<Int> = big.getValues().copy();
        if(values.length <= retain)
            return big.value;
        if(values.length < _digits)
            return big.value;
        var len:Int = Std.int(values.length / _digits);
        if(len == values.length / _digits)
            len --;
        var str:String = values.slice(0,values.length - _digits * len).join("");
        if(str.length + minMath <= values.length)
        {
            str += "." + values.slice(str.length ,str.length + minMath).join("");
        }
        return str + _unit[len - 1];
    }

}

@:keep
class MathUtils {

    public static function value(val:String):Array<Int>
    {
        var _values:Array<Int> = [];
        var len:Int = val.length;
        for(i in 0...len)
        {
            var v:String = val.charAt(i);
            _values.push(Std.parseInt(v));
        }
        return _values;
    }

}
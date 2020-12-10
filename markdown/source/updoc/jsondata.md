## JSON宏处理

可以将JSON数据进行类型化的宏操作，可在代码中正常通过变量访问。

#### JSON范例

```json
{
    "data":[
        {
            "id":1,
            "type":1,
            "data":"数据A"
        },
        {
            "id":2,
            "type":2,
            "data":"数据B"
        },
        {
            "id":3,
            "type":2,
            "data":"数据C"
        }
    ]
}
```

#### 使用

当需要使用json时，请确保属性名规范正确，不可用非法字符/中文，当创建完毕之后，json就是已经new出来的类对象，可通过json直接通过变量访问所有属性：

```haxe
var json = zygame.macro.JSONData.create("data.json");
//访问data
json.data[0].id; //1
json.data[1].data //数据B
```

#### 建立索引

很多情况下，是需要建立通过ID或者某个KEY来快速找到数据，可对第二个参数进行传递参数：

```haxe
var json = zygame.macro.JSONData.create("data.json",["id"]);
json.getDataById(1); // {id:1,type:1,data:数据A}
json.getDataById(3); // {id:3,type:2,data:数据B}
```

需要建立通过某个分类来筛选数组时，可对第三个参数进行传递参数：

```haxe
var json = zygame.macro.JSONData.create("data.json",null,["type"]);
json.getDataArrayByType(2); // [{id:2,type:2,data:数据B},{id:3,type:2,data:数据C}]
```




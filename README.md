# flutter study ing...

### 1.ListView.Builder(无限列表 )实现（可根据数据更新状态）。
* 1.下拉刷新。
* 2.上拉加载。

### 2.图片展示器（可根据需求参数计算适配每个item的大小）
* 1.动态权限申请（兼容Android/iOS）。
* 2.系统图片选择（裁剪可控）。
* 3.系统照相机拍照（裁剪可控）。
* 4.支持多图预览，渐现动画，占位符***更多功能在后续会继续扩展
* 5.支持点击预览，页面跳转间动画，图片可手势操作（放大，缩小）。
* 6.支持图片保存本地。

## 2.1 Example

### 1.GridPictureSelectWidget（图片选择添加，删除，替换，支持拍照并裁剪）
* 使用方法：参考view/SelectDemoWidget文件

```
Widget build(BuildContext context) {
     return Scaffold(
         appBar: AppBar(
           title: Text(name1),
         ),
         body: new ListView(
           physics: BouncingScrollPhysics(),
           children: <Widget>[
           //属性注释
           //GridPictureSelectWidget(数据集,每行显示个数，widget最大宽度，切角度数（0为不切），加号按钮回调，替换回调，删除按钮回调)
             GridPictureSelectWidget(localImageBeanList, 2,360,5, addClick, replaceClick, deleteClick),
             GridPictureSelectWidget(localImageBeanList, 3,360,5, addClick, replaceClick, deleteClick),
             GridPictureSelectWidget(localImageBeanList, 4,360,5, addClick, replaceClick, deleteClick),
             GridPictureSelectWidget(localImageBeanList, 5,360,5, addClick, replaceClick, deleteClick),
             GridPictureSelectWidget(localImageBeanList, 6,360,5, addClick, replaceClick, deleteClick),
             GridPictureSelectWidget(localImageBeanList, 7,360,5, addClick, replaceClick, deleteClick),
             GridPictureSelectWidget(localImageBeanList, 8,360,5, addClick, replaceClick, deleteClick),
           ],
         ));
}

Function addClick() {
      return null;
}

Function replaceClick( int id,List<String> imageUrls) {
      return null;
}

Function deleteClick(int id) {
      return null;
}
```
### 2.GridPictureDisplayWidget（图片渐现，加载进度条占位符，支持图片下载保存到本地，大图展示（支持多图展示））
* 使用方法：参考view/DisplayDemoWidget文件

```
Widget build(BuildContext context) {
     return Scaffold(
         appBar: AppBar(
           title: Text(name1),
         ),
         body: new ListView(
           physics: BouncingScrollPhysics(),
           children: <Widget>[
           //属性注释
           //GridPictureSelectWidget(数据集,每行显示个数，widget最大宽度，切角度数(0为不切))
             GridPictureDisplayWidget(imageBean, 2,360,5),
             GridPictureDisplayWidget(imageBean, 3,360,5),
             GridPictureDisplayWidget(imageBean, 4,360,5),
             GridPictureDisplayWidget(imageBean, 5,360,5),
             GridPictureDisplayWidget(imageBean, 6,360,5),
           ],
         ));
}

```

### 3.GridHeaderDisplayWidget（图片展示其，支持更多的样式自定义）
* 使用方法：参考view/HeaderDisplayDemoWidget文件

```
Widget build(BuildContext context) {
     return Scaffold(
       backgroundColor: Colors.blueGrey,
         appBar: AppBar(
           title: Text(name1),
         ),
         body: new ListView(
           physics: BouncingScrollPhysics(),
           children: <Widget>[
           //属性注释
           //GridPictureSelectWidget(数据集,每行显示个数，widget最大宽度)
             new Container(
               color:Colors.white,
               padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
               child: GridHeaderDisplayWidget(headerBean, 3,340),
             ),
             new Container(
               color:Colors.white,
               padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
               child: GridHeaderDisplayWidget(context,headerBean, 4,340),
             ),
             new Container(
               color:Colors.white,
               padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
               child: GridHeaderDisplayWidget(context,headerBean, 5,340),
             ),
             new Container(
               color:Colors.white,
               padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
               child: GridHeaderDisplayWidget(context,headerBean, 6,340),
             ),
             new Container(
               color:Colors.white,
               padding:EdgeInsets.fromLTRB(10, 10, 10, 10),
               child: GridHeaderDisplayWidget(context,headerBean, 7,340),
             ),
           ],
         ));
}

```

### 3.网络请求工具类（基于dio）ing
* 1.单例使用
* 2.BaseOptions编写
* 3.请求日志打印
* 4.请求取消(CancelToken)
* ...
## 3.1 API
### 1.Get(get请求)

```
Future requestGET() async {
     String url = 'https://www.zbg.com/exchange/config/controller/website/MarketController/getMarketAreaListByWebId';
     CancelToken cancelToken = new CancelToken();
     Response response = await dioHttpUtil().doGet(url,cancelToken: cancelToken);
     if(response != null){
       if(response.statusCode == 200){
         ToastUtil.toast("请求成功");
         setState(() {
           lineText = response.data.toString();
         });
       }else{
         ToastUtil.toast('request-error:$response.statusCode-$response.data');
       }
     }else{
       ToastUtil.toast('response == null');
     }

}
```

### 2.Post（post请求）

```
Future requestPOST() async {
     String url = 'https://www.zbg.com/exchange/config/controller/website/MarketController/getMarketAreaListByWebId';
     CancelToken cancelToken = new CancelToken();
     Response response = await dioHttpUtil().doPost(url,cancelToken: cancelToken);
     if(response != null){
       if(response.statusCode == 200){
         ToastUtil.toast("请求成功");
         setState(() {
           lineText = response.data.toString();
         });
       }else{
         ToastUtil.toast('request-error:$response.statusCode-$response.data');
       }
     }else{
       ToastUtil.toast('response == null');
     }
}
```

### 3.FormData(携带参数请求，支持单/多文件携带)

```
String url = 'https://www.zbg.com/exchange/config/controller/website/MarketController/getMarketAreaListByWebId';
     var jsonBody = '{\pageIndex\': 1, \'pageSize\': 10}';
     CancelToken cancelToken = new CancelToken();
     Response response = await dioHttpUtil().requestJsonBody(url, jsonBody: jsonBody,cancelToken: cancelToken);
     if(response != null){
       if(response.statusCode == 200){
         ToastUtil.toast("请求成功");
         setState(() {
           lineText = response.data.toString();
         });
       }else{
         ToastUtil.toast('request-error:$response.statusCode-$response.data');
       }
     }else{
       ToastUtil.toast('response == null');
}

```



### 4.jsonBody（携带jsonbody请求）

```
String url = 'https://www.zbg.com/exchange/config/controller/website/MarketController/getMarketAreaListByWebId';
     CancelToken cancelToken = new CancelToken();
     FormData formData = new FormData.from({
       "name": "wendux",
       "age": 25,
     });
     Response response = await dioHttpUtil().requestFormData(url, formData: formData,cancelToken: cancelToken);
     if(response != null){
       if(response.statusCode == 200){
         ToastUtil.toast("请求成功");
         setState(() {
           lineText = response.data.toString();
         });
       }else{
         ToastUtil.toast('request-error:$response.statusCode-$response.data');
       }
     }else{
       ToastUtil.toast('response == null');
}
```

### 5.downLoad(文件下载)

```
Future<void> downLoadFile() async {
     var sdcard = await getExternalStorageDirectory();
     String sdCardPath = sdcard.path;
     String directoryPath = sdCardPath+Constant.image_save_path;
     print("directoryPath:"+directoryPath);
     var directory = await new Directory(directoryPath).create(recursive: true);  ////如果有子文件夹，需要设置recursive: true
     //absolute返回path为绝对路径的Directory对象
     String path = directory.absolute.path;
     print("path:"+path);

     try {
       Response response;
       Dio dio = new Dio();
       String fileName = directory.absolute.path+'test_123.jpeg';
       response = await dio.download('https://b-ssl.duitang.com/uploads/item/201703/30/20170330175756_5KzW3.thumb.700_0.jpeg', fileName);
       if (response.statusCode == 200) {
         print("request-succes");
         ToastUtil.toast("保存成功：$fileName");
       } else {
         print("request-error");
       }
     } catch (e) {
       print(e);
     }
}
```



## 更新日志 new
* 1.GridView(可编辑，展示，"+")组件抽取完成
* 2.添加保存网络图片到本地
* 3.网络请求封装（dio）

## 会持续学习，不断完善
* 1.网络请求  ing
* 2.文件存取  ing
* 3.页面跳转并传参（路由）
* 4.native跳转并传参（native《=》flutter）
* 5.适配（字体大小，宽高），自定义字体，国际化
* 6.插件封装  ing






## 学习链接
* 1.[Flutter中文网](https://flutterchina.club/)

* 2.[Flutter实战](https://book.flutterchina.club/)

### 积少成多，全靠自觉

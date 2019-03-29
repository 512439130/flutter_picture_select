# flutter study ing...


### 图片展示器（可根据需求参数计算适配每个item的大小）
* 1.动态权限申请（兼容Android/iOS）。
* 2.系统图片选择（裁剪可控）。
* 3.系统照相机拍照（裁剪可控）。
* 4.支持多图预览，渐现动画，占位符***更多功能在后续会继续扩展
* 5.支持点击预览，页面跳转间动画，图片可手势操作（放大，缩小）。
* 6.支持图片保存本地。

## Example （参考../widget/demo/xxx.dart文件）

### 1.GridPictureSelectWidget（图片选择添加，删除，替换，支持拍照并裁剪）

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




#Other

## **原本是只是构造一个"图片展示器功能的Widget"，但flutter新知识不断学习，我喜欢记录一下，所以以下功能和原项目名称无关，如需要也可以查看学习。**

### 1.ListView.Builder(无限列表 )实现（可根据数据更新状态）。（参考../widget/demo/refresh.dart文件）
* 1.下拉刷新。
* 2.上拉加载。


### 2.网络请求工具类（基于dio）ing...（参考../widget/demo/dioHttpUtil.dart文件）
* 1.构建单例模式
* 2.BaseOptions编写
* 3.日志
* 4.Cookie管理
* 5.请求取消(CancelToken)
* ...

```
static dioHttpUtil instance;
  static dioHttpUtil getInstance() {
    print('getInstance');
    if (instance == null) {
      instance = new dioHttpUtil();
    }
    return instance;
}

dioHttpUtil() {
    print('配置dio实例');
    // 配置dio实例
    baseOptions = new BaseOptions(
      /// 请求路径，如果 `path` 以 "http(s)"开始, 则 `baseURL` 会被忽略； 否则,
      /// 将会和baseUrl拼接出完整的的url.
      baseUrl: "https://www.baidu.com/",
      connectTimeout: 8000,  //连接超时时间
      receiveTimeout: 10000, //回调超时时间
//      maxRedirects: 5,  //重定向最大次数。
      headers: {
        HttpHeaders.userAgentHeader: "dio",
        "api": "1.0.0",
      },
      contentType: ContentType.json,
      // Transform the response data to a String encoded with UTF8.
      // The default value is [ResponseType.JSON].
      responseType: ResponseType.plain,
    );

    dio = new Dio(baseOptions);
    dio.interceptors.add(LogInterceptor(responseBody: false)); //日志
//    dio.interceptors.add(CookieManager(CookieJar())); //Cookie管理
  }
```

## 2.1 API
### 2.1.1 Get(get请求)

```
Future requestGET() async {
     String url = 'api/test';
     CancelToken cancelToken = new CancelToken();
     Response response = await dioHttpUtil().doGet(url,cancelToken: cancelToken);
     if(response != null){
       if(response.statusCode == 200){
         ToastUtil.toast("请求成功");
         setState(() {
           lineText = response.data.toString();
         });
       }else{
         print('request-error-code:'+response.statusCode.toString());
         ToastUtil.toast('request-error-code:'+response.statusCode.toString());
       }
     }else{
       ToastUtil.toast('response == null');
     }
}
```

### 2.1.2 Post（post请求）

```
Future requestPOST() async {
     String url = 'api/test';
     CancelToken cancelToken = new CancelToken();
     Response response = await dioHttpUtil().doPost(url,cancelToken: cancelToken);
     if(response != null){
       if(response.statusCode == 200){
         ToastUtil.toast("请求成功");
         setState(() {
           lineText = response.data.toString();
         });
       }else{
         print('request-error-code:'+response.statusCode.toString());
         ToastUtil.toast('request-error-code:'+response.statusCode.toString());
       }
     }else{
       ToastUtil.toast('response == null');
     }
}
```

### 2.1.3 FormData(携带参数请求，支持单/多文件携带)

```
Future requestFormData() async {
    String url = 'api/test';
    CancelToken cancelToken = new CancelToken();
    FormData formData = new FormData.from({
      "name": "wendux",
      "age": 25,
    });
    Response response = await dioHttpUtil()
        .requestFormData(url, formData: formData, cancelToken: cancelToken);
    if (response != null) {
      if (response.statusCode == 200) {
        ToastUtil.toast("api/test");
        setState(() {
          lineText = response.data.toString();
        });
      } else {
        print('request-error-code:'+response.statusCode.toString());
        ToastUtil.toast('request-error-code:'+response.statusCode.toString());
      }
    } else {
      print('request-error');
    }
  }
```



### 2.1.4 jsonBody（携带jsonbody请求）

```
Future requestJsonBody() async {
    String url = 'api/test';
    var jsonBody = '{\pageIndex\': 1, \'pageSize\': 10}';
    CancelToken cancelToken = new CancelToken();
    Response response = await dioHttpUtil()
        .requestJsonBody(url, jsonBody: jsonBody, cancelToken: cancelToken);
    if (response != null) {
      if (response.statusCode == 200) {
        ToastUtil.toast("请求成功");
        setState(() {
          lineText = response.data.toString();
        });
      } else {
        ToastUtil.toast('request-error-code:'+response.statusCode.toString());
      }
    } else {
      print('request-error');
    }
  }
```

### 2.1.5 downLoad(文件下载)


```
//需要先获取读写权限 参考obtainPermission()
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
         print('request-error-code:'+response.statusCode.toString());
         ToastUtil.toast('request-error-code:'+response.statusCode.toString());
       }
     } catch (e) {
       print(e);
     }
}
```

### 2.1.6 obtainPermission(权限获取)

```
Future<void> obtainPermission() async {
    try {
      await Future.delayed(Duration(milliseconds: 500), () {
        setState(() {
          Future future1 = new Future(() => null);
          future1.then((_) {
            PermissionUtil.requestPermission(Permission.WriteExternalStorage)
                .then((result) {
              print("requestPermission-WriteExternalStorage$result");
              if (result == PermissionStatus.deniedNeverAsk) {
                //setting
                ToastUtil.toast('由于用户您选择不在提醒，并且拒绝了权限，请您去系统设置修改相关权限后再进行功能尝试');
                PermissionUtil.openPermissionSetting();
              } else if (result == PermissionStatus.authorized) {
                Future future2 = new Future(() => null);
                future2.then((_) {
                  PermissionUtil.requestPermission(
                          Permission.ReadExternalStorage)
                      .then((result2) {
                    print("ReadExternalStorage-Camera$result2");
                    if (result2 == PermissionStatus.deniedNeverAsk) {
                      //setting
                      ToastUtil.toast(
                          '由于用户您选择不在提醒，并且拒绝了权限，请您去系统设置修改相关权限后再进行功能尝试');
                      PermissionUtil.openPermissionSetting();
                    } else if (result2 == PermissionStatus.authorized) {
                      ToastUtil.toast('权限获取成功');
                    }
                  });
                });
              }
            });
          });
        });
      });
    } catch (e) {
      print("faild:$e.toString()");
    }
  }
```


## 会持续学习，不断完善
### 更新日志 new
* 1.下拉刷新，上拉加载 complete
* 2.权限申请 complete
* 3.图片Widget封装 complete
* 4.网络请求封装（dio）ing
* 5.文件存取  complete
* 6.页面跳转并传参（路由）styudy
* 7.native跳转并传参（native《=》flutter） styudy
* 8.适配（字体大小，宽高），自定义字体，国际化 styudy
* 9.插件封装(widget,util)  ing






## 学习链接
* 1.[Flutter中文网](https://flutterchina.club/)

* 2.[Flutter实战](https://book.flutterchina.club/)

### 积少成多，全靠自觉

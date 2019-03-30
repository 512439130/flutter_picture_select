# flutter study ing...


### 图片展示器（可根据需求参数计算适配每个item的大小）
* 一、GridView写法.（需要提供每行的固定个数，父布局宽度限制（父布局宽度限制:图片展示器需要的宽度），根据父布局最大宽度计算出最合适的宽高构造）
* 二、Flew写法.（需要提供精确的图片大小，不能整体居中，需要调试出固定每行图片数量时最合适的图片宽高，不需要提供父布局最大宽度，超过即换行）

## 包含功能
* 1.动态权限申请（兼容Android/iOS）。
* 2.系统图片选择（裁剪可控）。
* 3.系统照相机拍照（裁剪可控）。
* 4.支持多图预览，渐现动画，占位符***更多功能在后续会继续扩展
* 5.支持点击预览，页面跳转间动画，图片可手势操作（放大，缩小）。
* 6.支持图片保存本地。

## Example （参考../widget/demo/xxxDemo.dart文件）
## 一、GridView写法
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
@override
  Widget build(BuildContext context) {
    double boxPaddingLeft = 10;//盒子左边距
    double boxPaddingTop = 14;//盒子顶边距
    double boxPaddingRight = 10;//盒子右边距
    double boxPaddingBottom = 14;//盒子底边距
    double itemHorizontalSpacing = 12; //水平间距
    double itemVerticalSpacing = 12;  //垂直间距
    double itemRoundArc = 5; //图片圆角弧度
    double parentWidth = 300;  //父布局的最大宽度
    print("parentWidth:" + parentWidth.toString());
    return Scaffold(
        appBar: AppBar(
          title: Text(name1),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,
                //textDirection的正方向
                verticalDirection: VerticalDirection.down,
                //down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,
                //纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例1:4
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: GridPictureDisplayWidget(imageBean, 2,parentWidth,itemHorizontalSpacing,itemVerticalSpacing,itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            new Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,
                //textDirection的正方向
                verticalDirection: VerticalDirection.down,
                //down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,
                //纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例1:4
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: GridPictureDisplayWidget(imageBean, 3,parentWidth,itemHorizontalSpacing,itemVerticalSpacing,itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            new Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,
                //textDirection的正方向
                verticalDirection: VerticalDirection.down,
                //down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,
                //纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例1:4
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: GridPictureDisplayWidget(imageBean, 4,parentWidth,itemHorizontalSpacing,itemVerticalSpacing,itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            new Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,
                //textDirection的正方向
                verticalDirection: VerticalDirection.down,
                //down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,
                //纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例1:4
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: GridPictureDisplayWidget(imageBean, 5,parentWidth,itemHorizontalSpacing,itemVerticalSpacing,itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            new Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,
                //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,
                //textDirection的正方向
                verticalDirection: VerticalDirection.down,
                //down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,
                //纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,
                    //down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,
                    //参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例1:4
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: GridPictureDisplayWidget(imageBean,6,parentWidth,itemHorizontalSpacing,itemVerticalSpacing,itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

```

### 3.GridHeaderDisplayWidget（图片展示器，支持更多的样式自定义:头像+加号形式）

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

## 二、Flex写法
### 1.FlowPictureSelectWidget（图片选择添加，删除，替换，支持拍照并裁剪）

```
@override
  Widget build(BuildContext context) {
    double boxPaddingLeft = 5; //盒子左边距
    double boxPaddingTop = 12; //盒子顶边距
    double boxPaddingRight = 5; //盒子右边距
    double boxPaddingBottom = 12; //盒子底边距
    double itemWidth = 58; //图片宽度
    double itemHeight = 58 ; //图片高度
    double itemHorizontalSpacing = 17; //水平间距
    double itemVerticalSpacing = 17; //垂直间距
    double itemRoundArc = 5; //图片圆角弧度
    return Scaffold(
      appBar: AppBar(
        title: Text(name1),
      ),
      body: new Container(
          child: new ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              new Container(
                padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,boxPaddingRight, boxPaddingBottom),
                margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    itemWidth,
                    itemHeight,
                    itemHorizontalSpacing,
                    itemVerticalSpacing,
                    itemRoundArc,
                    addClick,
                    replaceClick,
                    deleteClick),
              ),
              new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,boxPaddingRight, boxPaddingBottom),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    82,
                    82,
                    itemHorizontalSpacing,
                    itemVerticalSpacing,
                    itemRoundArc,
                    addClick,
                    replaceClick,
                    deleteClick),
              ),
              new Container(
                color: Colors.white,
                margin: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop,boxPaddingRight, boxPaddingBottom),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: new FlowPictureSelectWidget(
                    localImageBeanList,
                    130,
                    130,
                    itemHorizontalSpacing,
                    itemVerticalSpacing,
                    itemRoundArc,
                    addClick,
                    replaceClick,
                    deleteClick),
              ),
            ],
          )),
    );
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
### 2.FlowPictureDisplayWidget（图片渐现，加载进度条占位符，支持图片下载保存到本地，大图展示（支持多图展示））

```
@override
  Widget build(BuildContext context) {
    double boxPaddingLeft = 10;//盒子左边距
    double boxPaddingTop = 14;//盒子顶边距
    double boxPaddingRight = 10;//盒子右边距
    double boxPaddingBottom = 14;//盒子底边距
    double itemWidth = 57;  //图片宽度
    double itemHeight = 57; //图片高度
    double itemHorizontalSpacing = 12; //水平间距
    double itemVerticalSpacing = 12;  //垂直间距
    double itemRoundArc = 5; //图片圆角弧度
    return Scaffold(
        appBar: AppBar(
          title: Text(name1),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,//从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,//textDirection的正方向
                verticalDirection: VerticalDirection.down,//down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,//纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,//down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,//参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例10:38
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: new FlowPictureDisplayWidget(
                              imageBean, 43, 43, itemHorizontalSpacing, itemVerticalSpacing, itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            new Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,//从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,//textDirection的正方向
                verticalDirection: VerticalDirection.down,//down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,//纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,//down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,//参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例10:38
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: new FlowPictureDisplayWidget(
                              imageBean, itemWidth, itemHeight, itemHorizontalSpacing, itemVerticalSpacing, itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            new Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,//从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,//textDirection的正方向
                verticalDirection: VerticalDirection.down,//down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,//纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,//down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,//参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例10:38
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.centerLeft, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          alignment: Alignment.topLeft,
                          child: new FlowPictureDisplayWidget(
                              imageBean, 80, 80, itemHorizontalSpacing, itemVerticalSpacing, itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            new Container(
              padding: EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: new Wrap(
                textDirection: TextDirection.ltr,//从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
                alignment: WrapAlignment.start,//textDirection的正方向
                verticalDirection: VerticalDirection.down,//down:表示从上到下 up:表示从下到上
                runAlignment: WrapAlignment.start,//纵轴方向的对齐方式:top,start,bottom,end
                children: <Widget>[
                  new Flex(  //弹性布局
                    direction: Axis.horizontal,
                    verticalDirection: VerticalDirection.down,//down:表示从上到下 up:表示从下到上
                    crossAxisAlignment: CrossAxisAlignment.start,//参考verticalDirection start表示正方向，end表示反方向
                    children: <Widget>[  //比例1:4
                      new Expanded(
                        flex: 1,
                        child: new Container(
                          alignment: Alignment.center, //内容位置
                          child: new Text(
                            "图         片",
                            style: new TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      new Expanded(
                        flex: 4,
                        child: new Container(
                          child: new FlowPictureDisplayWidget(imageBean, 125, 125, itemHorizontalSpacing, itemVerticalSpacing, itemRoundArc),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ));
  }

```

### 3.FlowHeaderDisplayWidget（图片展示器，支持更多的样式自定义:头像+间隔图像）
### 3.1FlowHeaderDisplayWidget（add类型）

```
@override
  Widget build(BuildContext context) {
    double boxPaddingLeft = ScreenUtil.getInstance().setHeight(5); //盒子左边距
    double boxPaddingTop = ScreenUtil.getInstance().setHeight(12); //盒子顶边距
    double boxPaddingRight = ScreenUtil.getInstance().setHeight(5); //盒子右边距
    double boxPaddingBottom = ScreenUtil.getInstance().setHeight(12); //盒子底边距
    double itemHorizontalSpacing = ScreenUtil.getInstance().setHeight(5); //水平间距
    double itemVerticalSpacing = ScreenUtil.getInstance().setHeight(5); //垂直间距
    return Scaffold(
      backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text(name1),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            //add
            //每行6个item
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(92), ScreenUtil.getInstance().setHeight(92), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_add,'images/icon_add.png'),
            ),

            //每行5个item
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(113), ScreenUtil.getInstance().setHeight(113), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_add,'images/icon_add.png'),
            ),

            //每行4个item
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(147), ScreenUtil.getInstance().setHeight(146), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_add,'images/icon_add.png'),
            ),
            //每行3个header
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(209), ScreenUtil.getInstance().setHeight(209), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_add,'images/icon_add.png'),
            ),

            //每行2个header
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(351), ScreenUtil.getInstance().setHeight(351), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_add,'images/icon_add.png'),
            ),
          ],
        ));

```

### 3.2FlowHeaderDisplayWidget（right类型）

```
@override
  Widget build(BuildContext context) {
    double boxPaddingLeft = ScreenUtil.getInstance().setHeight(5); //盒子左边距
    double boxPaddingTop = ScreenUtil.getInstance().setHeight(12); //盒子顶边距
    double boxPaddingRight = ScreenUtil.getInstance().setHeight(5); //盒子右边距
    double boxPaddingBottom = ScreenUtil.getInstance().setHeight(12); //盒子底边距
    double itemHorizontalSpacing = ScreenUtil.getInstance().setHeight(5); //水平间距
    double itemVerticalSpacing = ScreenUtil.getInstance().setHeight(5); //垂直间距
    return Scaffold(
      backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          title: Text(name1),
        ),
        body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            //right
            //每行6个item
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(83), ScreenUtil.getInstance().setHeight(83), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_right,'images/icon_right.png'),
            ),

            //每行5个item
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(101), ScreenUtil.getInstance().setHeight(101), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_right,'images/icon_right.png'),
            ),

            //每行4个item
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(128), ScreenUtil.getInstance().setHeight(128), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_right,'images/icon_right.png'),
            ),
            //每行3个header
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(173), ScreenUtil.getInstance().setHeight(173), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_right,'images/icon_right.png'),
            ),

            //每行2个header
            new Container(
              color:Colors.white,
              padding:EdgeInsets.fromLTRB(boxPaddingLeft, boxPaddingTop, boxPaddingRight, boxPaddingBottom),
              child: FlowHeaderDisplayWidget(headerBean,ScreenUtil.getInstance().setWidth(262), ScreenUtil.getInstance().setHeight(262), itemHorizontalSpacing, itemVerticalSpacing,Constant.header_type_right,'images/icon_right.png'),
            ),

          ],
        ));

```


# Other

## **原本是只是构造一个"图片展示器功能的Widget"，但flutter新知识不断学习，我喜欢记录一下，所以以下功能和原项目名称无关，如需要也可以查看学习。**

### 1.ListView.Builder(无限列表 )实现（可根据数据更新状态）（参考../widget/demo/RefreshDemo.dart文件）
* 1.下拉刷新。
* 2.上拉加载。


### 2.网络请求工具类（基于dio）ing...（参考../util/dioHttpUtil.dart文件）
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
      baseUrl: "https://www.baidu.com/",//baseUrl
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
* 2.权限申请 complete complete
* 3.图片Widget封装 complete
* 4.网络请求封装（dio）ing
* 5.文件存取  complete
* 6.页面跳转并传参（路由）styudy
* 7.native跳转并传参（native《=》flutter） styudy
* 8.适配（字体大小，宽高），自定义字体，国际化 styudy（屏幕适配：complete）
* 9.插件封装(widget,util)  ing


* insert
* 1.Flow（流式布局）的图片构造器 bug修复
* 2.header类型分离为两种情况
* 3.增加屏幕适配方案，适配Picture全部功能





## 学习链接
* 1.[Flutter中文网](https://flutterchina.club/)

* 2.[Flutter实战](https://book.flutterchina.club/)

### 积少成多，全靠自觉

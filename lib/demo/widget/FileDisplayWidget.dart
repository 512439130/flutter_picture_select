import 'package:flutter/material.dart';
import 'package:flutter_picture_select/demo/bean/FileBean.dart';
import 'package:flutter_picture_select/demo/bean/LocalFileBean.dart';
import 'package:flutter_picture_select/demo/const/Constant.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

//文件展示功能
class FileDisplayWidget extends StatefulWidget {
  final FileBean fileBean; //数据集合

  final List<LocalFileBean> localFileBeanList; //数据集合
  final String fileLeftUrl; //文件图访问Url
  final String type; //file_type_display:展示/file_type_edit:可操作
  final Function() onFileAddPress; //增加文件回调
  final Function(int id, String fileName, String url) onFilePress; //文件点击回调
  final Function(int id) onFileDeletePress; //删除回调

  FileDisplayWidget({
    this.fileBean,
    this.localFileBeanList,
    this.fileLeftUrl,
    this.type,
    this.onFileAddPress,
    this.onFilePress,
    this.onFileDeletePress,
  });

  @override
  _FileDisplayWidgetState createState() => _FileDisplayWidgetState();
}

class _FileDisplayWidgetState extends State<FileDisplayWidget> {
  List<Widget> listWidget;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void setList() {
    print('setList');
    listWidget = new List<Widget>();
    if(widget.type == Constant.file_type_edit){
      listWidget.add(createFileTileWidget());
      for (int i = 0; i < widget.localFileBeanList.length; i++) {
        listWidget.add(createFileWidget(i, widget.localFileBeanList[i].fileName, widget.localFileBeanList[i].fileName));
      }
    }else if(widget.type == Constant.file_type_display){
      for (int i = 0; i < widget.fileBean.datas.length; i++) {
        listWidget.add(createFileWidget(i, widget.fileBean.datas[i].fileName, widget.fileBean.datas[i].fileName));
      }
    }


  }

  Widget createFileTileWidget() {
    return new Offstage(
      offstage: false,
      child: new Container(
//              height: ScreenUtil.getInstance().setHeight(150),
        alignment: Alignment.center,
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(
            ScreenUtil.getInstance().setHeight(0),
            ScreenUtil.getInstance().setHeight(20),
            ScreenUtil.getInstance().setHeight(0),
            ScreenUtil.getInstance().setHeight(0)),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Text(
                '附件',
                softWrap: true,
                style: new TextStyle(
                  color: const Color(0xFF1A1A1A),
                  fontSize: ScreenUtil.getInstance().setSp(53),
                  fontWeight: FontWeight.w200,
                  fontStyle: FontStyle.normal,
                ),
              ),
            ),
            new Container(
              //右边区域
//              color: Colors.red,
              child: new GestureDetector(
                onTap: () {
                  widget.onFileAddPress();
                },
                child: Image.asset(
                  'images/icon_file_add.png',
                  width: ScreenUtil.getInstance().setWidth(70),
                  height: ScreenUtil.getInstance().setHeight(70),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createFileWidget(int id, String fileName, String fileLeftUrl) {
    return new Container(
      margin: EdgeInsets.only(
        top: ScreenUtil.getInstance().setHeight(30),
      ),
//      color: Colors.deepPurple,
      child: new Row(
        children: <Widget>[
          new Expanded(
            //左边区域
            child: new Container(
              alignment: Alignment.center,
              child: getFileWidget(id, true, fileName, fileLeftUrl),
            ),
          ),
          new Offstage(
            offstage: widget.type == Constant.file_type_edit ? false : true,
            child: new Container(
              //右边区域
              margin: EdgeInsets.fromLTRB(
                  ScreenUtil.getInstance().setHeight(25),
                  ScreenUtil.getInstance().setHeight(25),
                  ScreenUtil.getInstance().setHeight(0),
                  ScreenUtil.getInstance().setHeight(25)),
              child: new GestureDetector(
                onTap: () {
                  widget.onFileDeletePress(id);
                },
                child: Image.asset(
                  'images/icon_delete.png',
                  width: ScreenUtil.getInstance().setWidth(60),
                  height: ScreenUtil.getInstance().setHeight(60),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFileWidget(int id, bool isVisible, String fileName, String url) {
    double fontSize = ScreenUtil.getInstance().setSp(46);
    print("fontSize:" + fontSize.toString());

    return new GestureDetector(
        onTap: () {
          widget.onFilePress(id, fileName, url);
        },
        child: new Offstage(
          //使用Offstage 控制widget在tree中的显示和隐藏
          offstage: isVisible ? false : true,
          child: new Container(
            //左侧
            alignment: Alignment.centerLeft,
            color: const Color(0xFFF7F8FA),
            padding: EdgeInsets.fromLTRB(
                ScreenUtil.getInstance().setHeight(10),
                ScreenUtil.getInstance().setHeight(25),
                ScreenUtil.getInstance().setHeight(10),
                ScreenUtil.getInstance().setHeight(25)),
            child: new Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Container(
                  padding: EdgeInsets.only(
                      left: ScreenUtil.getInstance().setHeight(15),
                      right: ScreenUtil.getInstance().setHeight(15)),
                  width: ScreenUtil.getInstance().setHeight(111),
                  child: new Image.asset(
                    widget.fileLeftUrl,
                    fit: BoxFit.fitWidth,
                  ),
                ),
                new Expanded(
                  child: new Container(
                    padding: EdgeInsets.only(
                        left: ScreenUtil.getInstance().setHeight(10)),
                    child: new Text(
                      fileName,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        color: const Color(0xFF1A1A1A),
                        fontSize: fontSize,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    setList();
    return new ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          new Container(
//              color: Colors.deepOrange,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: new Wrap(
              //流式布局，垂直向下排列
              spacing: 0,
              // 主轴(水平)方向间距
              runSpacing: 0,
              // 纵轴（垂直）方向间距
              textDirection: TextDirection.ltr,
              //从(左/右)边开始  表示水平方向子widget的布局顺序(是从左往右还是从右往左)  textDirection是alignment的参考系
              alignment: WrapAlignment.start,
              //textDirection的正方向
              verticalDirection: VerticalDirection.down,
              //down:表示从上到下 up:表示从下到上
              runAlignment: WrapAlignment.start,
              //纵轴方向的对齐方式:top,start,bottom,end
              children: listWidget,
            ),
          ),
        ]);
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


const String name1 = 'RefreshWidget';

class RefreshWidget extends StatefulWidget {
  @override
  createState() {
    return new RefreshWidgetState();
  }
}
//生成ListView
class RefreshWidgetState extends State<RefreshWidget> {
  bool isFirstLoadData = true;
  final _font = const TextStyle(fontSize: 15.0);
  final _save = new Set<String>();

  List list = new List(); //列表要展示的数据
  ScrollController _scrollController = ScrollController(); //listView的滑动控制器
  int _page = 1; //加载的页数
  int _size = 10; //每页加载的数量
  bool isLoading = false; //是否正在加载数据
  bool isHasMore = true;  //是否存在更多数据

  @override
  void initState() {
    //插入到渲染树时调用，只执行一次。（类似Android Fragment的onCreateView函数）
    super.initState();
    print('initState');
    testPrint();
    init();
  }

  void testPrint() {
    int a = 2;
    a??=3;
    int b;
    b??=3;
    print("a=$a");
    print("b=$b");
  }

  //初始化
  void init() {
    getData();
    initListener();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2), () {
      //延迟2秒
      print('_onRefresh');
      //更新用户界面
      setState(() {
        print('更新用户界面');
        reset();
        list = List.generate(25, (int index) => '我是刷新的数据$index');
      });
    });
  }

  void reset() {
    list.clear();
    _save.clear();
    isHasMore = true;
    isLoading = false;
    _page = 1;
  }

  Future<void> _onLoad() async {
    //异步任务
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Future.delayed(Duration(seconds: 1), () {
        print('_onLoad');
        setState(() {
          if(isHasMore){
            list.addAll(List.generate(5, (int index) => '第$_page次上拉加载的数据'));
            _page++;
            isLoading = false;
          }
          isHasMore = false;
        });
      });
    } else {
      print('loading...');
    }
  }

  Future<void> getData() async {
    await Future.delayed(Duration(seconds: 1), () {
      print('getData');
      setState(() {
        list = List.generate(25, (int index) => '我是原始的数据${index+1}');
        isFirstLoadData = false;
      });
    });
  }

  void initListener() {
    print('initListener');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');

        _onLoad();
      }
    });
  }


  Widget _buildLoadMore(){
    print('_buildLoadMore');
    if(isHasMore){
      return _loadMoreWidget();
    }else{
      return _noLoadMoreWidget();
    }
  }

  Widget _loadMoreWidget() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 0.0,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SpinKitFadingCircle(
                color: Colors.grey,
                size: 30.0,
              ),
              new Padding(padding: EdgeInsets.only(left: 10)),
              new Text("正在加载更多...")
            ],
          ),
        ),
      ),);
  }

  Widget _noLoadMoreWidget() {
    return new Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      alignment: Alignment.center,
      child: new Text("没有更多数据了"),
    );
  }

  // 加载圆形进度条
  Widget getCircularProgress(){
    return new CircularProgressIndicator(
      strokeWidth: 3.5,  //圆形进度条宽度
      backgroundColor: Colors.red,
      valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
    );
  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    //1、在初始化initState后执行； 2、显示/关闭其它widget。 3、可执行多次；
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    //有点像Android的onStop函数， 在打开新的Widget或回到这个widget时会执行； 可执行多次；
    super.deactivate();
    print('deactivate');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //类似于Android的onDestroy， 在执行Navigator.pop后会调用该办法， 表示组件已销毁；
    super.dispose();
    print('dispose');
    _scrollController.dispose(); //清空监听
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    //点击热部署会执行，只用于调试时的hot reload。 release版本不会执行该函数。
    super.reassemble();
    print('reassemble');
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          //居中title
          title: new Center(child: Text(name1)),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.gavel), onPressed: _pushSavedTest)
          ],
        ),
        body: RefreshIndicator(
            onRefresh: _onRefresh,
            displacement: 40,
            //触发下拉刷新的距离
            color: Colors.blue,
            backgroundColor: Colors.white,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: list.length*2 + 1,  //
                //预加载的区域
                //cacheExtent: 30,
                padding: const EdgeInsets.all(5.0),
                //左右内间距
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,

                itemBuilder: (context, index) {
                  if(isFirstLoadData){
                    return loadProgress();
                  }else{
                    if (index < list.length*2) {

                      if (index.isOdd) {
                        return new Container(
                          //自定义高度的View
                          color: Colors.grey,
                          height: 0.5,
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        );
                      } else {
                        index = index ~/ 2; //保证输出正确

                      }
                      return _buildRow(list[index]);
                    }else{
                      return _buildLoadMore();
                    }
                  }
                })));

  }

  //加载进度条
  Widget loadProgress() {
    return new SizedBox(
      height: 300,
      child: new Center(
        widthFactor: 1,
        heightFactor: 1,
        child: getCircularProgress(),
      ),
    );
  }

  Future <void> testProgress() async{
    await Future.delayed(Duration(seconds: 1), () {
      loadProgress();
    });
  }

  void _pushSavedTest() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
          final tiles = _save.map(
                (value) {
              return new ListTile(
                title: new Text(
                  value,
                  style: _font,
                ),
                trailing: new Icon(Icons.border_right),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return new Scaffold(
            appBar: new AppBar(
              title: new Text('Saved Suggestions Test'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }


  Widget _buildRow(String value) {
    final alreadySaved = _save.contains(value);
    return new ListTile(
      title: new Text(
        // item 标题
        value.toString(),
        style: _font,
      ),
      leading: new Icon(Icons.menu),
      trailing: new Icon(
        //item 后置图标
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.blue : null,
      ),
      //点击Item事件
      onTap: () {
        // item onTap 点击事件
        setState(() {
          if (alreadySaved) {
            _save.remove(value);
          } else {
            _save.add(value);
          }
        });
      },
    );
  }




//生成列表内容，分割线
//  Widget _buildSuggestions() {
//    print('_buildSuggestions重复调用');
//    return new ListView.builder(
//        scrollDirection: Axis.vertical,
////        itemCount: 40,  //index/2影响
//        //item数量固定
////        itemExtent: 40,  //tem的高度固定   ps会让item加载更加高效
////        shrinkWrap: true,//内容适配（高度）
//        cacheExtent: 30,
//        //预加载的区域
//        padding: const EdgeInsets.all(5.0),
//        //左右内间距
//        physics: BouncingScrollPhysics(),
//        controller: ScrollController(
//          initialScrollOffset: 1,
//          keepScrollOffset: true,
//          debugLabel: "ListView.builder_test",
//        ),
//        //AlwaysScrollableScrollPhysics() 总是可以滑动（数据不满一屏时触发上啦加载） NeverScrollableScrollPhysics禁止滚动 BouncingScrollPhysics 内容超过一屏 上拉有回弹效果 ClampingScrollPhysics 包裹内容 不会有回弹
//        itemBuilder: (context, index) {
//          if (index.isOdd) {
////            return new Divider(  //固定为1height的高度
////              height: 16,   //padding height
////              indent: 20,  //padding left
////              color: Colors.grey,
////            );
//            return new Container(
//              //自定义高度的View
//              color: Colors.red,
//              height: 2,
//              width: 200,
//              margin: EdgeInsets.fromLTRB(5, 0, 10, 0),
//            );
//          } else {
//            index = index ~/ 2; //保证输出正确
//            print("index:$index");
//            _testString.add(index.toString());
//            //          print("test1:${index.toString()}");
////          print("test3:" + "${index.toString()}");
////          print("test4:第$index个X=" + "${index * index}");
//          }
//          return _buildRowTest(_testString[index]);
//        });
//  }

}





import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin  {

  int page = 1;
  List<Map> hotGoodsList = [];

  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  @override
  bool get wantKeepAlive => true;

  String homePageContent = '正在获取数据';

  @override
  Widget build(BuildContext context) {
    var formData = {'lon':'115.02932','lat':'35.76189'};
    return Scaffold(
        appBar: AppBar(
          title: Text('百姓生活+'),
        ),
        body: FutureBuilder(
          future: request('homePageContext','首页信息', params: formData),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = json.decode(snapshot.data.toString());
              // 轮播图数据
              List<Map> swiperDataList = (data['data']['slides'] as List).cast(); 
              // 导航按钮数据
              List<Map> navigatorList  = (data['data']['category'] as List).cast();
              // AdBanner数据
              String adPicture = data['data']['advertesPicture']['PICTURE_ADDRESS'];
              // 店长电话和图片
              String  leaderImage= data['data']['shopInfo']['leaderImage'];  
              String  leaderPhone = data['data']['shopInfo']['leaderPhone'];
              // 推荐商品
              List<Map> recommendList = (data['data']['recommend'] as List).cast();
              // 楼层1的标题图片
              String floor1Title =data['data']['floor1Pic']['PICTURE_ADDRESS'];
              // 楼层1的标题图片
              String floor2Title =data['data']['floor2Pic']['PICTURE_ADDRESS'];
              // 楼层1的标题图片
              String floor3Title =data['data']['floor3Pic']['PICTURE_ADDRESS'];
              // 楼层1商品和图片 
              List<Map> floor1 = (data['data']['floor1'] as List).cast();
              // 楼层1商品和图片 
              List<Map> floor2 = (data['data']['floor2'] as List).cast(); 
              // 楼层1商品和图片  
              List<Map> floor3 = (data['data']['floor3'] as List).cast(); 
              return EasyRefresh(
                refreshFooter: ClassicsFooter(
                key:_footerKey,
                bgColor:Colors.white,
                textColor: Colors.deepOrangeAccent,
                moreInfoColor: Colors.deepOrangeAccent,
                showMore: true,
                noMoreText: '',
                moreInfo: '拼命加载中',
                loadReadyText:'上拉加载....'

              ),
                child: ListView(
                  children: <Widget>[
                   // 轮播图
                    SwiperDiy(swiperDateList: swiperDataList,),
                    // 轮播图
                    TopNavigator(navigatorList: navigatorList),
                    // adBanner
                    AdBanner(adPicture: adPicture),
                    // 店长信息
                    LeaderPhone(leaderImage: leaderImage,leaderPhone: leaderPhone),
                    // 推荐商品
                    Recommend(recommendList: recommendList),
                    // 楼层标题
                    FloorTitle(picture_address: floor1Title),
                    // 楼层广告
                    FloorContent(floorGoodsList: floor1),
                    // 楼层标题
                    FloorTitle(picture_address: floor2Title),
                    // 楼层广告
                    FloorContent(floorGoodsList: floor2),
                    // 楼层标题
                    FloorTitle(picture_address: floor3Title),
                    // 楼层广告
                    FloorContent(floorGoodsList: floor3),
                    // 火爆专区
                    _hotGoods()
                  ],
                ),
                loadMore: () async {
                  var formPage = {'page': page};
                  request('homePageBelowConten', '获取火爆专区', params: formPage).then((val){
                    var data = jsonDecode(val.toString());
                    List<Map> newGoodsList = (data['data'] as List).cast();
                    setState(() {
                      hotGoodsList.addAll(newGoodsList);
                      page++;
                    });
                  });
                },
              );
            } else {
              return Center(
                child: Text('加载中......'),
              );
            }
          },
        ));
  }
  //火爆专区标题
  
   Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 0.5, color: Colors.black12)
      ),
    ),
    child: Text('火爆专区'),
  );

  // 火爆专区子项

  Widget _wrapList() {
    
    if (hotGoodsList.length != 0) {
      List<Widget> listWidget = hotGoodsList.map((val){
        return InkWell(
          onTap: (){
            Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(375)),
                Text(
                  val['name'],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: Colors.deepOrangeAccent, fontSize: ScreenUtil().setSp(26)), 
                ),
                Row(
                  children: <Widget>[
                    Text('￥${val['mallPrice']}'),
                    Text(
                      '￥${val['price']}',
                      style:TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough)
                    )
                  ],
                )
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text(' ');
    }
  }

  // 火爆专区组合

  Widget _hotGoods() {
    return Container(
      child: Column(
        children: <Widget>[
          hotTitle,
          _wrapList()
        ],
      )
    );
  }
}

//首页轮播    

class SwiperDiy extends StatelessWidget {
  final List swiperDateList;
  const SwiperDiy({Key key, this.swiperDateList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(333),
      width: ScreenUtil().setWidth(750),
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              Application.router.navigateTo(context, '/detail?id=${swiperDateList[index]['goodsId']}');
            },
            child: Image.network('${swiperDateList[index]['image']}'),
          ); 
        },
        itemCount: swiperDateList.length,
        pagination: SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//首页导航区
class TopNavigator  extends StatelessWidget {
  final List navigatorList;
  const TopNavigator ({Key key, this.navigatorList}) : super(key: key);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: (){print('点击了按钮');},
      child: Column(
        children: <Widget>[
          Image.network(item['image'], width: ScreenUtil().setWidth(95)),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (this.navigatorList.length > 10) {
      this.navigatorList.removeRange(10, this.navigatorList.length);
    }
    return Container(
      height: ScreenUtil().setHeight(320),
      child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//adBanner

class AdBanner extends StatelessWidget {
  final String adPicture;
  const AdBanner({Key key, this.adPicture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.network(adPicture),
    );
  }
}

// 打电话

class LeaderPhone  extends StatelessWidget {
  final String leaderImage;
  final String leaderPhone;
  const LeaderPhone ({Key key, this.leaderImage, this.leaderPhone}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  //打电话方法
  void _launchURL() async{
    String url = 'tel:' + leaderPhone;
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw 'url有问题';
    }
  }
}

// 推荐商品

class Recommend  extends StatelessWidget {
  final List recommendList;
  const Recommend ({Key key, this.recommendList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      height: ScreenUtil().setHeight(400),
     child: Column(
       children: <Widget>[
         _titleWidget(),
         _recommedList()
       ],
     ),
    );
  }

  //推荐商品标题

  Widget _titleWidget() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 5.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 0.5, color: Colors.black12),
        )
      ),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.deepOrangeAccent),
      ),
    );
  }

  // 商品列表容器

  Widget _recommedList() {
    return Container(
      height: ScreenUtil().setHeight(340),
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
        itemBuilder: (context, index){
          return _item(context, index);
        },
      ),
    );
  }

  // 每个商品

  Widget _item(context, index) {
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, '/detail?id=${recommendList[index]['goodsId']}');
      },
      child: Container(
        height: ScreenUtil().setHeight(330),
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
         color: Colors.white,
         border: Border(
           left: BorderSide(width: 0.5, color: Colors.black12)
         )
        ),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text('￥${recommendList[index]['mallPrice']}'),
            Text(
              '￥${recommendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
              ),
          ],
        ),
      ),
    );
  }
}

// 楼层标题

class FloorTitle  extends StatelessWidget {
  final String picture_address;
  const FloorTitle ({Key key, this.picture_address}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_address),
    );
  }
}

// 楼层商品列表 

class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  const FloorContent({Key key, this.floorGoodsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: Container(
        child: Column(
          children: <Widget>[
            _firstRow(context),
            _otherGoods(context)
          ],
        ),
      ),
    );
  }

  // 第一行
  
  Widget _firstRow(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[0]),
        Column(
          children: <Widget>[
            _goodsItem(context, floorGoodsList[1]),
            _goodsItem(context, floorGoodsList[2]),
          ],
        )
      ],
    );
  }

  // 第二行

  Widget _otherGoods(context) {
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[3]),
        _goodsItem(context, floorGoodsList[4])
      ],
    );
  }

  // 单个商品   
  Widget _goodsItem(context,Map goods){
    return InkWell(
      onTap: (){
        Application.router.navigateTo(context, 'detail?id=${goods['goodsId']}');
      },
        child: Container(
        width: ScreenUtil().setWidth(375),
        child: InkWell(
          child: Image.network(goods['image']),
        )
      ),
    );
    
  }
}

// 火爆专区

class HotGoods extends StatefulWidget {
  HotGoods({Key key}) : super(key: key);

  _HotGoodsState createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String rul = 'homePageBelowConten';
    int pages = 1;
    String funcName = '火爆专区';
    request(rul, funcName, params: pages).then((val){
      print(val);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       
    );
  }
}

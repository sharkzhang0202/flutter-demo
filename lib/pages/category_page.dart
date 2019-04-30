import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert'; 
import '../model/category.dart';
import '../model/categoryGoodsList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CategoryPage extends StatefulWidget {
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    // _getCategory();
    return Scaffold(
      appBar: AppBar(title: Text('商品分类')),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                 RightCategoryNav(),
                 CategoryGoodsList()
              ],
            )
          ],
        ),
      ),
    );
  }
}

// 左侧导航栏

class LeftCategoryNav extends StatefulWidget {
  LeftCategoryNav({Key key}) : super(key: key);

  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  List list = [];
  var listIndex = 0;

  @override
  void initState() { 
    super.initState();
    _getCategory();
    _getGoodList();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1, color: Colors.black12)
        ),
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index){
          return _leftInkWel(index);
        },
      ),
    );
    
  }

  // 请求数据方法

  void _getCategory()async{
    await request('getCategory', '商品分类信息').then((val){
      var data = json.decode(val.toString());
      CategoryModel category = CategoryModel.fromJson(data);

      setState(() {
        list = category.data;
      });
      Provide.value<ChildCategory>(context).getChildCategory(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  // 商品分类的商品列表

  void _getGoodList({String categoryId}) async {
    var data = {
      'categoryId': categoryId == null ? '4' : categoryId,
      'categorySubId': '',
      'page': 1
    };

    await request('getMallGoods', '商品分类的商品列表', params: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
    });
  }

  // 每一个小项

  Widget _leftInkWel(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;
    return InkWell(
      onTap: (){
        setState(() {
         listIndex = index; 
        });
        var childList = list[index].bxMallSubDto;
        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategory(childList, categoryId);
        _getGoodList(categoryId: categoryId);
      },
      child: Container(
        height: ScreenUtil().setHeight(100),
        padding: EdgeInsets.only(left: 10.0, top: 17.0),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 236, 236, 1.0) : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black12)
          )
        ),
        child: Text(list[index].mallCategoryName, style: TextStyle(fontSize: ScreenUtil().setSp(28)),),
      ),
    );
  }
}

// 右侧分类列表

class RightCategoryNav extends StatefulWidget {
  RightCategoryNav({Key key}) : super(key: key);

  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {
  // List list = ['啤酒', '白酒', '葡萄酒', '瓜子', '花生', '大碗面','啤酒', '白酒', '葡萄酒', '瓜子', '花生', '大碗面'];
  @override
  Widget build(BuildContext context) {
    return Provide<ChildCategory>(
      builder: (context, child, childCategory){
        return Container(
          height: ScreenUtil().setHeight(80),
          width: ScreenUtil().setWidth(570),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1, color: Colors.black12)
            )
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: childCategory.childCategoryList.length,
            itemBuilder: (context, index){
              return  _rightInkWell(index, childCategory.childCategoryList[index]);
            },
          ),
        );
      },
    );
  }

// 每个元素

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex) ? true : false;
    return InkWell(
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildIndex(index, item.mallSubId);
        _getGoodList(item.mallSubId);
        print(item.mallSubId);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5.0, 12.0, 5.0, 10.0),
        child: Text(
          item.mallSubName,
          style: TextStyle(
            fontSize: ScreenUtil().setSp(28),
            color: isClick ? Colors.deepOrangeAccent : Colors.black
          ),
        ),
      ),
    );
  }
  

  void _getGoodList(String categorySubId) async {
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': categorySubId,
      'page': 1
    };

    await request('getMallGoods', '商品分类的商品列表', params: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if(goodsList.data == null){
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }
    });
  }
}



//商品分类的商品列表

class CategoryGoodsList extends StatefulWidget {
  CategoryGoodsList({Key key}) : super(key: key);

  _CategoryGoodsListState createState() => _CategoryGoodsListState();
}

class _CategoryGoodsListState extends State<CategoryGoodsList> {
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();
  var scorrController = new ScrollController();
  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data){
        try{
          if(Provide.value<ChildCategory>(context).page == 1){
            scorrController.jumpTo(0.0);
          }
        }catch(e){
          print('第一次进入页面aaaaaaaaaaaaaaa$e');
        }
        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                key:_footerKey,
                bgColor:Colors.white,
                textColor: Colors.deepOrangeAccent,
                moreInfoColor: Colors.deepOrangeAccent,
                showMore: true,
                noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                moreInfo: '拼命加载中',
                loadReadyText:'上拉加载....'
              ),
              child: ListView.builder(
                controller: scorrController,
                itemCount: data.goodsList.length,
                itemBuilder: (context, index){
                  return _itemListWidget(data.goodsList, index);
                },
              ),
              loadMore: (){
                _getMoreList();
               
              },
              )
            ),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );
  }
  void _getMoreList() async {
    Provide.value<ChildCategory>(context).addPage();
    var data = {
      'categoryId': Provide.value<ChildCategory>(context).categoryId,
      'categorySubId': Provide.value<ChildCategory>(context).subId,
      'page': Provide.value<ChildCategory>(context).page
    };

    await request('getMallGoods', '获取更多商品分类', params: data).then((val){
      var data = json.decode(val.toString());
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data);
      if(goodsList.data == null){
        Provide.value<ChildCategory>(context).changeNoMore('没有更多了');
        Fluttertoast.showToast(
          msg: "已经到底了",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.black38,
          textColor: Colors.white,
          fontSize: 16.0
        );
      }else{
        Provide.value<CategoryGoodsListProvide>(context).getMoreList(goodsList.data);
      }
    });
  }
  
  
  // 商品图片

  Widget _goodsImage(List newList, index){

    return  Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );

  }

  // 商品名称

  Widget _goodsName(List newList, index){
    return Container( 
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
        ),
      );
  }

  // 商品价格

  Widget _goodsPrice(List newList, index){
    return  Container( 
      margin: EdgeInsets.only(top:20.0),
      width: ScreenUtil().setWidth(370),
      child:Row(
        children: <Widget>[
            Text(
              '价格:￥${newList[index].presentPrice}',
              style: TextStyle(color:Colors.pink,fontSize:ScreenUtil().setSp(30)),
              ),
            Text(
              '￥${newList[index].oriPrice}',
              style: TextStyle(
                color: Colors.black26,
                decoration: TextDecoration.lineThrough
              ),
            )
        ]
      )
    );
  }

  // 单个商品
  
  Widget _itemListWidget(List newList,int index){
    return InkWell(
      onTap: (){},
      child: Container(
        padding: EdgeInsets.only(top: 5.0,bottom: 5.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(width: 1.0,color: Colors.black12)
          )
        ),
        
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index)
           ,
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index)
              ],
            )
          ],
        ),
      )
    );  
  }
  
}
 
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cartInfo.dart';

class CartProvide with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoModel> cartList = [];
  // 总价钱
  double allPrice = 0;
  // 总数量
  int allGoodsCount = 0;
  //是否全选
  bool isAllCheck= true; 

  // 添加购物车
  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // 去除持久化的值
    cartString = prefs.getString('cartInfo');
    // 判断carString是否为空，为空说明第一次添加，或者key被清楚了。
    // 如果有之进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    //把获得值转变成List
    List<Map> tempList = (temp as List).cast();
    //声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false; //默认为没有
    var ival = 0; //用于进行循环的索引使用
    allPrice = 0;
    allGoodsCount = 0;
    tempList.forEach((item){
      if (item['goodsId'] == goodsId) {
        tempList[ival]['count'] = item['count'] + 1;
        cartList[ival].count++;
        isHave = true;
      }
      if  (item['isCheck']) {
        allPrice += (cartList[ival].price * cartList[ival].count);
        allGoodsCount += cartList[ival].count;
      }
      ival++;
    });
    // 没有的话，进行添加
     if(!isHave){
       Map<String, dynamic> newGoods = {
        'goodsId':goodsId,
        'goodsName':goodsName,
        'count':count,
        'price':price,
        'images':images,
        'isCheck':true
       };
      tempList.add(newGoods);
      cartList.add(new CartInfoModel.fromJson(newGoods));
    }
    //把字符串进行encode操作，
    cartString= json.encode(tempList).toString();
    // print(cartString);
    // print(cartList.toString());
    prefs.setString('cartInfo', cartString);//进行持久化
    notifyListeners();

  }

  remove() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //prefs.clear();//清空键值对
    prefs.remove('cartInfo');
    print('清空完成-----------------');
    notifyListeners();
  }

  // 得到购物车中的商品
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    // 初始化基础数据
    cartList = [];
    allPrice = 0;
    allGoodsCount = 0;
    isAllCheck = true;
    if(cartString == null) {
      cartList = [];
    }else{
      List<Map> tempList = (json.decode(cartString.toString()) as List ).cast();
      tempList.forEach((item){
        if (item['isCheck']) {
          allPrice += item['count'] * item['price'];
          allGoodsCount += item['count'];
        } else {
          isAllCheck = false;
        }
        cartList.add(CartInfoModel.fromJson(item));
      });
    }
    notifyListeners();
  }
  
  //删除单个购物车商品
  deleteOneGoods(String goodsId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    var tempIndex = 0;
    var delIndex = 0;

    tempList.forEach((item){
      if (item['goodsId'] == goodsId) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });

    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // 单选方法
  changeCheckState(CartInfoModel cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    var tempIndex = 0;
    var changeIndex = 0;
    tempList.forEach((item){
      if (item['goodsId'] == cartItem.goodsId) {
        changeIndex = tempIndex;
      }

      tempIndex++;
    });
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // 点击全选按钮操作

  changeAllCheckBtnState(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList = [];
    tempList.forEach((item){
      var newItem = item;
      item['isCheck'] = isCheck;
      newList.add(newItem);
    });
    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  // 商品数量加减
  addOrReduceAction(var cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    // 找出需要修改数量的索引值

    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item){
      if (cartItem.goodsId == item['goodsId']) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });

    // 判断是加法还是减法以及当前数量为零时减号按钮失效

    if (todo == 'add') {
      cartItem.count++;
    } else if (cartItem.count > 1) {
      cartItem.count--;
    }

    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }
}
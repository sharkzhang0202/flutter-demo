import 'package:flutter/material.dart';
import '../model/details.dart';
import '../service/service_method.dart';
import 'dart:convert';


class DetailsInfoProvide with ChangeNotifier {
  DetailsModle goodsInfo = null;
  
  // 从后台获取商品信息

  getGoodsInfo(String id) async {
    var params = {'goodId': id};
    await request('getGoodDetailById', '获取火爆专区商品详情页信息', params: params).then((val){
      var responseData = json.decode(val.toString());
      goodsInfo = DetailsModle.fromJson(responseData);
      notifyListeners();
    });
  }
}
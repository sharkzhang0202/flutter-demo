import 'package:flutter/material.dart';
import '../model/category.dart';

class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = []; // 小类列表

  int childIndex = 0;
  String categoryId = '4';
  String subId = '';
  String noMoreText = '';
  int page = 1;
  getChildCategory(List<BxMallSubDto> list, String id) {
    childIndex = 0;
    categoryId = id;
    noMoreText = '';
    page = 1;
    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = '';
    all.comments = 'null';
    all.mallSubName = '全部';
    childCategoryList = [all];
    childCategoryList.addAll(list);
    notifyListeners();
  }

  //改变子类索引
    changeChildIndex(index, String id) {
      childIndex = index;
      subId = id;
      page = 1;
      notifyListeners();
    }

    // 改变页数

    addPage() {
      page++;
    }

    //改变noMoreText数据

    changeNoMore(String text) {
      noMoreText = text;
    }
}
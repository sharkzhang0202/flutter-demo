import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../../provide/details_info.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailsTopArea extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
     builder: (context, child ,val){
      var goodsInfo = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo;

      if (goodsInfo != null) {
        return Container(
          child: Column(
            children: <Widget>[
              _goodsImage(goodsInfo.image1),
              _goodsName(goodsInfo.goodsName)
            ],
          ),
        );
      } else {
        return Text('正在加载中.......');
      }
     
     },
    );
  }

  // 商品图片

  Widget _goodsImage(url) {
    return Image.network(
      url,
      width: ScreenUtil().setWidth(750),
    );
  }

  // 商品名称

  Widget _goodsName(name) {
    return Container(
      padding: EdgeInsets.only(left: 15.0),
      width: ScreenUtil().setWidth(750.0),
      child: Text(
        name, 
        maxLines: 1,
        style: TextStyle(fontSize: ScreenUtil().setSp(30))
      ),
      );
  }

}
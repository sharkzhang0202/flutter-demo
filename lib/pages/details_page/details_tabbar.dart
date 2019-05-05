import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/details_info.dart';
import 'package:provide/provide.dart';

class DetailsTabBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provide<DetailsInfoProvide>(
      builder: (context, child, val) {
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        var isRight = Provide.value<DetailsInfoProvide>(context).isRight;
        return Container(
          margin: EdgeInsets.only(top: 15.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _myTabBarLeft(context, isLeft),
                _myTabBarRight(context, isRight)
                ],
              ),
            ],
          )
        );
      },
    );
  }

  Widget _myTabBarLeft(BuildContext context, bool isClickLeft) {
    return InkWell(
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('left');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isClickLeft ? Colors.deepOrangeAccent : Colors.black12 
            )
          )
        ),
        child: Text(
          '详情',
          style: TextStyle(
            color: isClickLeft ? Colors.deepOrangeAccent : Colors.black
          ),
        ),
      ),
    );
  }

  Widget _myTabBarRight(BuildContext context, bool isClickRight) {
    return InkWell(
      onTap: (){
        Provide.value<DetailsInfoProvide>(context).changeLeftAndRight('right');
      },
      child: Container(
        padding: EdgeInsets.all(10.0),
        alignment: Alignment.center,
        width: ScreenUtil().setWidth(375),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              width: 1.0,
              color: isClickRight ? Colors.deepOrangeAccent : Colors.black12 
            )
          )
        ),
        child: Text(
          '详情',
          style: TextStyle(
            color: isClickRight ? Colors.deepOrangeAccent : Colors.black
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/counter.dart';

class CartPage extends StatelessWidget {
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			body: Center(
				child: Center(
          child: Column(
            children: <Widget>[
              Number(),
              MyButton()
            ],
          ),
        ),
			),
		);
	}
}


class Number extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provide<Counter>(
        builder: (context, child, counter){
          return Text(
            '${counter.value}'
          );
        },),
    );
  }
}

class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: RaisedButton(
        onPressed: (){
          Provide.value<Counter>(context).adddd();
        },
        child: Text('递增'),
      ),
    );
  }
}


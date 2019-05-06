import 'package:flutter/material.dart';
// import 'package:flutter/foundation.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';


class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot){
          List cartList = Provide.value<CartProvide>(context).cartList;
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                Provide<CartProvide>(
                  builder: (context, child, val){
                    cartList = Provide.value<CartProvide>(context).cartList;
                    return Container(
                      padding: EdgeInsets.only(bottom: 50.0),
                      child: ListView.builder(
                        itemCount: cartList.length,
                        itemBuilder: (context,index){
                          final item = cartList[index].goodsId;
                          return Dismissible(
                            background: Container(
                              color: Colors.black54,
                              alignment: Alignment.centerRight,
                              child: Icon(Icons.delete_forever),
                            ),
                            
                            movementDuration: Duration(seconds: 2),
                            dismissThresholds: Map(),
                            key: Key(item),
                            direction: DismissDirection.endToStart,
                            
                            onDismissed: (direction) {
                              // Remove the item from our data source.
                              Provide.value<CartProvide>(context).deleteOneGoods(item);

                              // Then show a snackbar!
                              Scaffold.of(context)
                                  .showSnackBar(SnackBar(content: Text("$item dismissed")));
                            },
                            child:  CartItem(cartList[index]),
                          );
                         
                        },
                      ),
                    );
                  },
                ),
                Positioned(
                  bottom: -5,
                  left: 0,
                  child: CartBottom(),
                )
              ],
            );

            
          } else {
            return Text('正在加载。。。');
          }
        },
      ),
    );
  }

  Future<String> _getCartInfo(BuildContext context) async {
    await Provide.value<CartProvide>(context).getCartInfo();
    return 'end';
  }
}

// class CartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('购物车'),
//       ),
//       body: FutureBuilder(
//         future: _getCartInfo(context),
//         builder: (context, snapshot){
//           List cartList = Provide.value<CartProvide>(context).cartList;
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: cartList.length,
//               itemBuilder: (context, index){
//                 return ListTile(
//                   title: Text(cartList[index].goodsName),
//                 );
//               },
//             );
//           } else {
//             return Text('正在加载');
//           }
//         },
//       ),
//     );
//   }
//   Future<String> _getCartInfo(BuildContext context) async {
//     await Provide.value<CartProvide>(context).getCartInfo();
//     return 'end';
//   }
// }
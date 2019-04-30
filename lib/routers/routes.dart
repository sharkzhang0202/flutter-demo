import 'package:flutter/material.dart';
import './router_handler.dart';
import 'package:fluro/fluro.dart';

class Routers {
  static String root = '/';
  static String detailsPage = 'detail';
  static void configureRoutes(Router router) {
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print("对不起，你走错地方了+++++++++++++++++++++++++++++++++++");
      }
    );

    router.define(detailsPage, handler: detailsHanderl);
  }
}
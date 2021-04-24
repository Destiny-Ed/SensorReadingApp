import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PageRouter {
  BuildContext ctx;
  PageRouter({this.ctx}) : assert(ctx != null);

  void nexPage({Widget page}) {
    Navigator.push(ctx, MaterialPageRoute(builder: (context) => page));
  }
}

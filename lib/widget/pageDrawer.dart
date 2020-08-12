import 'package:flutter/material.dart';
import 'package:flutter_canvas/check_order.dart';
import 'package:flutter_canvas/check_repair.dart';

class PageDrawer extends StatefulWidget {
  @override
  _PageDrawerState createState() => _PageDrawerState();
}

class _PageDrawerState extends State<PageDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      children: <Widget>[
        DrawerHeader(
            decoration: BoxDecoration(color: Color(0xff9c6169)),
            child: Column(
              children: [
                Expanded(
                  child: Image.network(
                    'https://image.rocketpunch.com/company/79819/kaenbeoseukeompeoni_logo_1543836597.png?s=400x400&t=inside',
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            )),
        ListTile(
            title: FlatButton(
          child: Text('배송일 조회'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => CheckOrder()),
            );
          },
        )),
        ListTile(
            title: FlatButton(
          child: Text('수리 신청'),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (BuildContext context) => CheckRepair()),
            );
          },
        )),
      ],
    ));
  }
}

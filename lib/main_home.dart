import 'package:flutter/material.dart';

import './pages/check_shipping_date.dart';
import './pages/check_repair_request.dart';

class MainHome extends StatefulWidget {
  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  String currentPageTitle = '예상 발송일 조회';
  final String estimatedShippingDateTitle = '예상 발송일 조회';
  final String repairRequestTitle = '수리 신청';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            print('홈버튼');
          },
          icon: Image.network(
            'https://canvasrings.com//data/icon/favicon/favicon1538472366.ico',
            width: 24,
            height: 24,
          ),
        ),
        title: Text(
          currentPageTitle,
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState.openEndDrawer();
            },
            color: Colors.black,
          ),
        ],
      ),
      endDrawer: Drawer(
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
              ),
            ),
            drawerMenu(estimatedShippingDateTitle),
            drawerMenu(repairRequestTitle),
          ],
        ),
      ),
      body: currentPageTitle == estimatedShippingDateTitle
          ? EstimatedShippingDate()
          : currentPageTitle == repairRequestTitle
              ? RepairRequest(bracelet: [])
              : Container(),
    );
  }

  // Drawer Widget
  Widget drawerMenu(String menuTitle) {
    return ListTile(
      title: Text(menuTitle),
      hoverColor: Color(0xff9c6169).withOpacity(0.2),
      onTap: () {
        setState(() {
          currentPageTitle = menuTitle;
        });
        Navigator.of(context).pop();
      },
    );
  }
}

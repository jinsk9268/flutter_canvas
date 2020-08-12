import 'package:flutter/material.dart';

class PageAppBar extends StatefulWidget {
  final String title;

  PageAppBar({Key key, this.title}) : super(key: key);

  @override
  _PageAppBarState createState() => _PageAppBarState();
}

class _PageAppBarState extends State<PageAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
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
      title: Text(widget.title, style: TextStyle(color: Colors.black)),
      centerTitle: true,
      backgroundColor: Colors.white,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('메뉴리스트');
          },
          color: Colors.black,
        ),
      ],
    );
  }
}

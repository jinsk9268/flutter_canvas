import 'package:flutter/material.dart';

class CheckRepair extends StatefulWidget {
  @override
  _CheckRepairState createState() => _CheckRepairState();
}

class _CheckRepairState extends State<CheckRepair> {
  bool checkProgress = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe7e7e7),
      appBar: AppBar(
        leading: IconButton(
          icon: Image.network(
            'https://canvasrings.com//data/icon/favicon/favicon1538472366.ico',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            print('홈버튼');
          },
        ),
        title: Text('수리 신청', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            color: Colors.black,
            onPressed: () {
              print('메뉴 리스트');
            },
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: <Widget>[
                  progressText(
                      '신청서 작성', checkProgress ? 0xff323232 : 0xff7e7d7d),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Color(0xff7e7d7d),
                  ),
                  SizedBox(width: 6),
                  progressText(
                      '신청 완료', !checkProgress ? 0xff323232 : 0xff7e7d7d),
                ],
              ),
            ],
          )),
    );
  }

  Widget progressText(progressTitle, checkColor) {
    return Text(
      progressTitle,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(checkColor),
      ),
    );
  }
}

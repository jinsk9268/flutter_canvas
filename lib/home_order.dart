import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeOrder extends StatefulWidget {
  HomeOrder({Key key}) : super(key: key);

  @override
  _HomeOrderState createState() => _HomeOrderState();
}

class _HomeOrderState extends State<HomeOrder> {
  final _formKey = GlobalKey<FormState>();
  String orderNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('메뉴 리스트');
          },
        ),
        title: Text('예상 발송일 조회', style: TextStyle(color: Colors.black)),
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '주문번호 조회',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 15),
              TextFormField(
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  hintText: '주문번호 19자리를 입력해주세요',
                  isDense: true,
                  contentPadding: EdgeInsets.all(12),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  focusColor: Colors.black,
                ),
                // 숫자만 입력 가능, length가 19 초과 하면 입력 x
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                  LengthLimitingTextInputFormatter(19),
                ],
                // 유효성 검사
                validator: (orderNum) {
                  if (orderNum.length < 19) {
                    return '주문번호는 19자리 입니다. 다시 입력해주세요';
                  }
                  return null;
                },
                onSaved: (orderNum) {
                  orderNumber = orderNum;
                  print('저장되는 주문번호는 $orderNum');
                  print('orderNumber : $orderNumber');
                },
                onChanged: (orderNum) {
                  print('주문번호 : $orderNum');
                },
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Spacer(),
                  // checkBtn,
                  Container(
                    width: 120,
                    child: RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _formKey.currentState.save();
                          });
                        }
                      },
                      color: Colors.black,
                      child:
                          Text('조회하기', style: TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

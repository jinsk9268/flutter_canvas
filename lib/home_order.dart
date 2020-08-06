import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_format/date_format.dart';

class HomeOrder extends StatefulWidget {
  HomeOrder({Key key}) : super(key: key);

  @override
  _HomeOrderState createState() => _HomeOrderState();
}

class _HomeOrderState extends State<HomeOrder> {
  final _formKey = GlobalKey<FormState>();
  String orderNumber = '';
  bool changeWidget = false;

  getSendWeekday(var standardDate) {
    return standardDate.weekday == 1
        ? '월요일'
        : standardDate.weekday == 2
            ? '화요일'
            : standardDate.weekday == 3
                ? '수요일'
                : standardDate.weekday == 4
                    ? '목요일'
                    : standardDate.weekday == 5
                        ? '금요일'
                        : standardDate.weekday == 6 ? '토요일' : '일요일';
  }

  getSendDate(var returnDate) => formatDate(
      returnDate, [yyyy, '년 ', m, '월 ', d, '일 ', getSendWeekday(returnDate)]);

  productSendDate(String orderNum) {
    // 주문일 연,월,일
    int year = int.parse(orderNum.substring(0, 4));
    int month = int.parse(orderNum.substring(4, 6));
    int day = int.parse(orderNum.substring(6, 8));

    // 일단은 공휴일 고려대상 제외, 10시 전 주문건 당일 생산, 10시 이후 주문건 익일 생산
    // 주문 년,원,일
    var orderDate = new DateTime(year, month, day);

    // 주문일 요일, 시간
    int orderWeekday = orderDate.weekday;
    int hour = int.parse(orderNum.substring(8, 10));

    // 월요일 10시 이전 주문건 => 4일 소요
    var need4Days = orderDate.add(new Duration(days: 4));

    // 월요일 10시 이후, 화~금 10시 이전, 토요일 주문건 => 6일 소요
    var need6Days = orderDate.add(new Duration(days: 6));

    // 화~금 10시 이후 주문건 => 7일 소요
    var need7Days = orderDate.add(new Duration(days: 7));

    // 일요일 주문건 => 5일 소요
    var need5Days = orderDate.add(new Duration(days: 5));

    //  상품 발송일
    return orderWeekday == 1 && hour < 10
        ? getSendDate(need4Days)
        : orderWeekday != 1 &&
                orderWeekday != 6 &&
                orderWeekday != 7 &&
                hour < 10
            ? getSendDate(need6Days)
            : orderWeekday != 1 &&
                    orderWeekday != 6 &&
                    orderWeekday != 7 &&
                    hour >= 10
                ? getSendDate(need7Days)
                : orderWeekday == 6
                    ? getSendDate(need6Days)
                    : orderWeekday == 7
                        ? getSendDate(need5Days)
                        : '주문번호가 존재하지 않습니다.\n주문번호를 다시 확인해주세요!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            print('메뉴리스트');
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
            children: changeWidget
                ? <Widget>[
                    Text(
                      '고객님의 주문은 아래 날짜에 발송 예정입니다 :',
                      style: TextStyle(
                        height: 1.5,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      productSendDate(orderNumber),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          width: 120,
                          child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                changeWidget = !changeWidget;
                              });
                            },
                            color: Colors.black,
                            child: Text('뒤로가기',
                                style: TextStyle(color: Colors.white)),
                          ),
                        )
                      ],
                    )
                  ]
                : <Widget>[
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
                        // 입력값 삭제 controller로 구현 필요
                        // suffixIcon: IconButton(
                        //   icon: Icon(Icons.cancel),
                        //   onPressed: () {
                        //     // controller.clear();
                        //     print('입력');
                        //   },
                        //   disabledColor: Colors.grey,
                        //   color: Colors.grey,
                        // ),
                      ),
                      // 숫자만 입력 가능, length가 19자리를 초과 하면 입력 불가
                      keyboardType: TextInputType.number,
                      // controller로 length > 0 이상이면 보이게하기
                      // maxLength: 19,
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
                        Container(
                          width: 120,
                          child: RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _formKey.currentState.save();
                                  changeWidget = !changeWidget;
                                });
                              }
                            },
                            color: Colors.black,
                            child: Text('조회하기',
                                style: TextStyle(color: Colors.white)),
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

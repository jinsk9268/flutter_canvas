import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:date_format/date_format.dart';

class EstimatedShippingDate extends StatefulWidget {
  @override
  _EstimatedShippingDateState createState() => _EstimatedShippingDateState();
}

class _EstimatedShippingDateState extends State<EstimatedShippingDate> {
  final _formKey = GlobalKey<FormState>();

  final inputController = TextEditingController();
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  String orderNumber = '';
  bool checkOrderNumber = false;

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
        : orderWeekday == 1 && hour >= 10
            ? getSendDate(need7Days)
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: checkOrderNumber
                ? <Widget>[
                    shippingDateWidgetTitle('고객님의 주문은 아래 날짜에 발송 예정입니다 :'),
                    SizedBox(height: 15),
                    shippingDateText(),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          width: 120,
                          child: checkShippingDateBtn('뒤로가기'),
                        )
                      ],
                    )
                  ]
                : <Widget>[
                    shippingDateWidgetTitle('주문번호 조회'),
                    SizedBox(height: 15),
                    orderNumberInput(),
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Spacer(),
                        Container(
                          width: 120,
                          child: checkShippingDateBtn('조회하기'),
                        )
                      ],
                    )
                  ],
          ),
        ),
      ),
    );
  }

  Widget shippingDateWidgetTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        height: 1.5,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget shippingDateText() {
    return Text(
      productSendDate(orderNumber),
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget orderNumberInput() {
    return TextFormField(
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        hintText: '주문번호 19자리를 입력해주세요',
        isDense: true,
        contentPadding: EdgeInsets.all(12),
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(Icons.cancel),
          iconSize: 20,
          onPressed: () {
            inputController.clear();
          },
        ),
      ),
      controller: inputController,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
      ],
      maxLength: 19,
      validator: (orderNum) {
        return orderNum.length < 19 ? '주문번호는 19자리 입니다. 다시 입력해주세요' : null;
      },
      onSaved: (orderNum) {
        orderNumber = orderNum;
        print('저장되는 주문번호는 $orderNum');
        print('orderNumber : $orderNumber');
      },
      onChanged: (orderNum) {
        print('주문번호 : $orderNum');
      },
    );
  }

  Widget checkShippingDateBtn(String btnTitle) {
    return RaisedButton(
      onPressed: () {
        setState(() {
          switch (btnTitle) {
            case '조회하기':
              if (_formKey.currentState.validate()) {
                setState(() {
                  _formKey.currentState.save();
                  checkOrderNumber = !checkOrderNumber;
                });
              }
              break;
            case '뒤로가기':
              setState(() {
                checkOrderNumber = !checkOrderNumber;
              });
              break;
            default:
              break;
          }
        });
      },
      color: Color(0xff1D2433),
      child: Text(btnTitle, style: TextStyle(color: Colors.white)),
    );
  }
}

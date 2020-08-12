import 'package:flutter/material.dart';

import './widget/pageAppBar.dart';
import './widget/pageDrawer.dart';

class CheckRepair extends StatefulWidget {
  @override
  _CheckRepairState createState() => _CheckRepairState();
}

// provider 확인해보기
class _CheckRepairState extends State<CheckRepair> {
  // Drawer key
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  openDrawer(key) => key.currentState.openEndDrawer();

  // 수리 진행상황
  bool repairProgress = true;
  bool repairNotiActive = false;
  bool repairRequestActive = false;

  // 수리 신청 동의
  bool repairAgreement = false;

  // 수리 신청 내용
  bool repairStone = false;
  bool repairColor = false;
  bool repairScratch = false;
  bool repairBreakage = false;

  // 수리 신청 사용자 입력 controller
  final repairInputController = TextEditingController();
  String repairInputValue = '';

  @override
  void dispose() {
    repairInputController.dispose();
    super.dispose();
  }

  // 신청하기 현재 상황
  bool repairAccepted = false;

  // 신청 내역 데이터
  var repairCurrentData = Map();
  var repairFinalData = Map();

  // 수리 신청 조건 검사 함수
  repairRequestCheck(bool agreement, var repairContentMap) {
    var repairSendData = List();
    for (MapEntry e in repairContentMap.entries) {
      if (e.value) {
        repairSendData.add(e.key);
      }
    }

    return agreement == true && repairSendData.length > 0
        ? setState(() {
            repairAccepted = !repairAccepted;
            repairProgress = !repairProgress;
            repairFinalData['repair_agreement'] = repairAgreement;
            repairFinalData['repair_send_data'] = repairSendData;
            repairFinalData['repair_input_value'] = repairInputController.text;
          })
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('필수 사항이 누락되었습니다.'),
                content: boldText('유의 사항 동의 및 수리 내용 체크여부를 확인해주세요!'),
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xfff0f0f0),
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(56),
      //   child: PageAppBar(title: '수리 신청'),
      // ),
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
        title: Text('수리 신청', style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              print('메뉴리스트');
              openDrawer(_scaffoldKey);
            },
            color: Colors.black,
          ),
        ],
      ),
      endDrawer: PageDrawer(),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15),
        children: [
          SizedBox(height: 20),
          Row(
            children: <Widget>[
              progressText('신청서 작성', repairProgress),
              SizedBox(width: 6),
              Icon(
                Icons.arrow_forward_ios,
                size: 12,
                color: Color(0xff7e7d7d),
              ),
              SizedBox(width: 6),
              progressText('신청 완료', !repairProgress),
            ],
          ),
          repairAccepted
              ? Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    repairRequestCheckIcon(),
                    SizedBox(height: 10),
                    requestCompletionTitle('수리 신청이 완료되었습니다'),
                    SizedBox(height: 10),
                    requestCompletionSubTitle('제품을 포장하신 뒤 3영업일 내에'),
                    requestCompletionSubTitle('아래 주소로 배송 부탁드립니다.'),
                    SizedBox(height: 10),
                    requestCheckBtn(),
                    SizedBox(height: 20),
                    repairTitleNoIcon('배송 정보', ''),
                    repairBorder(),
                    repairDeliveryInfo(),
                    SizedBox(height: 20),
                  ],
                )
              : Column(
                  children: <Widget>[
                    SizedBox(height: 20),
                    repairTitleDropDown('유의 사항', repairNotiActive),
                    repairBorder(),
                    repairNotiActive ? Container() : repairNotiContent(),
                    SizedBox(height: 20),
                    repairTitleDropDown('수리 신청', repairRequestActive),
                    repairBorder(),
                    repairRequestActive ? Container() : repairRequestContent(),
                    SizedBox(height: 20),
                    repairTitleNoIcon('수리 내용', '(중복 선택 가능)'),
                    repairBorder(),
                    repairCheckContent(),
                    SizedBox(height: 20),
                  ],
                )
        ],
      ),
      bottomNavigationBar: repairAccepted
          ? null
          : BottomAppBar(
              child: Container(
                height: 56,
                child: RaisedButton(
                  onPressed: () {
                    repairRequestCheck(repairAgreement, repairCurrentData);
                    print('수리 신청 사용자 입력 데이터: $repairCurrentData');
                    print('수리 신청 최종 데이터: $repairFinalData');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '수리 신청하기',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.navigate_next,
                        color: Colors.white,
                      )
                    ],
                  ),
                  color: Color(0xff9c6169),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0.0),
                  ),
                ),
              ),
            ),
    );
  }

  // 신청 완료 Widget
  Widget repairRequestCheckIcon() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: Icon(
        Icons.check_circle_outline_sharp,
        color: Color(0xff9c6169),
        size: 65,
      ),
    );
  }

  Widget requestCompletionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 1.4,
      ),
    );
  }

  Widget requestCompletionSubTitle(String subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget requestCheckBtn() {
    return FlatButton(
      onPressed: () {
        print('수리 신청 내역 로드');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '수리 신청 내역 확인',
            style: TextStyle(
              color: Color(0xff9c6169),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.navigate_next,
            color: Color(0xff9c6169),
          ),
        ],
      ),
      hoverColor: Color(0xfff0f0f0),
      highlightColor: Color(0xfff0f0f0),
    );
  }

  Widget repairDeliveryInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          boldText('받는 사람'),
          regularText('주식회사 캔버스컴퍼니 제품 수리 담당자'),
          SizedBox(height: 15),
          boldText('연락처'),
          regularText('02-2231-1047'),
          SizedBox(height: 15),
          boldText('주소'),
          regularText('(04539)'),
          regularText('서울특별시 중구 을지로5길 19, 페럼타워 24층'),
          regularText('주식회사 캔버스컴퍼니'),
          SizedBox(height: 15),
          boldText('배송요금'),
          regularText('착불(결제 완료)'),
          Container(),
        ],
      ),
    );
  }

  // 신청서 작성 Widget
  Widget progressText(progressTitle, check) {
    return Text(
      progressTitle,
      style: TextStyle(
        fontSize: 13,
        fontWeight: check ? FontWeight.bold : FontWeight.w500,
        color: Color(check ? 0xff323232 : 0xff7e7d7d),
      ),
    );
  }

  Widget repairNotiContent() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              regularText('제품 수리에는 '),
              boldText('왕복 배송료와 수리비용'),
              regularText('이 발생합니다.'),
            ],
          ),
          SizedBox(height: 10),
          regularText('왕복 배송료를 신청과 함께 결제하셔야 하며, '
              '수리 비용은 제품 확인 후 별도 안내 드립니다.'),
          SizedBox(height: 10),
          regularText('수리를 원하시는 부분을 가능한 구체적으로 아래에 기입 부탁드립니다.'),
          SizedBox(height: 10),
          regularText('감사합니다.'),
          SizedBox(height: 10),
          repairBorder(),
          SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              checkBox(repairAgreement, '동의'),
              SizedBox(width: 7),
              regularText('(필수) 위의 유의 사항을 읽었으며, 이에 동의합니다.')
            ],
          )
        ],
      ),
    );
  }

  Widget repairRequestContent() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  'https://m.canvasrings.com/data/goods/1/2020/04/236_tmp_54594261ed288c7877c48d36d7fda27c7141large.jpg',
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText('R0093'),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: regularText('소재 :'),
                        ),
                        Expanded(
                          flex: 3,
                          child: regularText('화이크골드, 아쿠아 마린'),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: regularText('구매일 :'),
                        ),
                        Expanded(
                          flex: 3,
                          child: regularText('2017년 10월 1일'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Spacer(),
              repairRequestBtn('다른 제품 선택'),
            ],
          )
        ],
      ),
    );
  }

  Widget repairRequestBtn(String btnName) {
    return Container(
      height: 30,
      child: RaisedButton(
        onPressed: () {
          print('다른 제품 선택하기 모달');
        },
        color: Color(0xff1D2433),
        child: Text(btnName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            )),
      ),
    );
  }

  Widget repairCheckContent() {
    return Container(
      padding: EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        children: [
          repairCheck(repairStone, '스톤', '스톤이 떨어졌어요'),
          SizedBox(height: 8),
          repairCheck(repairColor, '변색', '제품이 변색 되었어요'),
          SizedBox(height: 8),
          repairCheck(repairScratch, '스크래치', '표면에 스크래치가 너무 많아요'),
          SizedBox(height: 8),
          repairCheck(repairBreakage, '파손', '제품에 심한 파손이 있어요'),
          SizedBox(height: 8),
          repairInputText(),
        ],
      ),
    );
  }

  Widget repairCheck(bool isChecked, String checkValue, String checkText) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Color(0xffd6d1d1),
          ),
        ),
        child: Row(
          children: [
            checkBox(isChecked, checkValue),
            SizedBox(width: 7),
            boldText(checkText),
          ],
        ));
  }

  Widget repairInputText() {
    return TextField(
      controller: repairInputController,
      onChanged: (repairText) {
        print('내용: $repairText');
      },
      maxLines: 6,
      textAlignVertical: TextAlignVertical.center,
      style: TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: '구제척인 내용을 적어주세요.',
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          borderSide: const BorderSide(width: 1, color: Color(0xffd6d1d1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          borderSide: const BorderSide(width: 1, color: Color(0xffd6d1d1)),
        ),
      ),
    );
  }

  // 공통 Widget
  Widget repairBorder() {
    return Container(
      padding: EdgeInsets.all(0.0),
      height: 1.3,
      color: Color(0xffd6d1d1),
    );
  }

  Widget regularText(String txt) {
    return Text(
      txt,
      style: TextStyle(fontSize: 14),
    );
  }

  Widget boldText(String txt) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget repairTitleDropDown(String title, bool active) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                switch (title) {
                  case '유의 사항':
                    repairNotiActive = !repairNotiActive;
                    break;
                  case '수리 신청':
                    repairRequestActive = !repairRequestActive;
                    break;
                }
              });
            },
            icon: Icon(active ? Icons.expand_more : Icons.expand_less),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget repairTitleNoIcon(String title, String subTitle) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Colors.white,
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 15.5, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 5),
          regularText(subTitle),
        ],
      ),
    );
  }

  Widget checkBox(bool isChecked, String checkValue) {
    return IconButton(
      onPressed: () {
        setState(() {
          switch (checkValue) {
            case '동의':
              repairAgreement = !repairAgreement;
              break;
            case '스톤':
              repairStone = !repairStone;
              repairCurrentData[checkValue] = repairStone;
              break;
            case '변색':
              repairColor = !repairColor;
              repairCurrentData[checkValue] = repairColor;
              break;
            case '스크래치':
              repairScratch = !repairScratch;
              repairCurrentData[checkValue] = repairScratch;
              break;
            case '파손':
              repairBreakage = !repairBreakage;
              repairCurrentData[checkValue] = repairBreakage;
              break;
            default:
              break;
          }
        });
      },
      icon: Icon(Icons.check_box),
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
      iconSize: 22,
      color: isChecked ? Colors.black : Color(0xffd6d1d1),
    );
  }
}

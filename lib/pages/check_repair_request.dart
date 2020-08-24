import 'package:flutter/material.dart';
import '../constant.dart';

import '../model/canvas_bracelet.dart';

class RepairRequest extends StatefulWidget {
  final List<Bracelet> bracelet;
  RepairRequest({Key key, @required this.bracelet}) : super(key: key);

  @override
  _RepairRequestState createState() => _RepairRequestState();
}

class _RepairRequestState extends State<RepairRequest> {
  // 수리 진행상황
  bool repairProgress = true;
  bool repairNotiActive = false;
  bool repairRequestActive = false;

  // 수리 신청 동의
  bool repairAgreement = false;

  // 다른 제품 선택하기
  String selectProductImage = bracelet[0].productImage;
  String selectProductId = bracelet[0].productId;
  String selectProductMaterial = bracelet[0].productMaterial;
  String selectProductPurchaseDate = bracelet[0].productPurchaseDate;

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
            repairFinalData['repair_product_id'] = selectProductId;
            repairFinalData['repair_product_material'] = selectProductMaterial;
            repairFinalData['repair_product_purchasce_date'] =
                selectProductPurchaseDate;
          })
        : showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('필수 사항이 누락되었습니다.'),
                content: boldText('유의 사항 동의 및 수리 내용 체크여부를 확인해주세요!'),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgGreyColor,
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
                color: divisionGreyColor,
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
                  color: canvasColor,
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
        Icons.check_circle_outline,
        color: canvasColor,
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
              color: canvasColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Icon(
            Icons.navigate_next,
            color: canvasColor,
          ),
        ],
      ),
      hoverColor: bgGreyColor,
      highlightColor: bgGreyColor,
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
        color: check ? brightBlackColor : divisionGreyColor,
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
                child: Image.network(selectProductImage),
              ),
              SizedBox(width: 15),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(selectProductId),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: regularText('소재 :'),
                        ),
                        Expanded(
                          flex: 4,
                          child: regularText(selectProductMaterial),
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
                          flex: 4,
                          child: regularText(selectProductPurchaseDate),
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
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('제품을 선택해주세요!'),
                content: productList(),
              );
            },
          );
        },
        color: brightBlackColor,
        child: Text(
          btnName,
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }

  Widget productList() {
    return Container(
      width: double.maxFinite,
      height: 400,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: bracelet.length,
        itemBuilder: (BuildContext context, int index) {
          var braceletInfo = bracelet[index];
          return Container(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: ListTile(
              onTap: () {
                setState(() {
                  selectProductImage = braceletInfo.productImage;
                  selectProductId = braceletInfo.productId;
                  selectProductMaterial = braceletInfo.productMaterial;
                  selectProductPurchaseDate = braceletInfo.productPurchaseDate;
                });
                Navigator.of(context).pop();
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              hoverColor: canvasColor.withOpacity(0.3),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(braceletInfo.productImage),
                backgroundColor: Colors.transparent,
              ),
              title: Text(braceletInfo.productId),
              subtitle: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text('구매일 :'),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(braceletInfo.productPurchaseDate),
                  ),
                ],
              ),
            ),
          );
        },
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
            color: brightGreyColor,
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
          borderSide: const BorderSide(width: 1, color: brightGreyColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(0)),
          borderSide: const BorderSide(width: 1, color: brightGreyColor),
        ),
      ),
    );
  }

  // 공통 Widget
  Widget repairBorder() {
    return Container(
      padding: EdgeInsets.all(0.0),
      height: 1.3,
      color: brightGreyColor,
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
      color: isChecked ? Colors.black : brightGreyColor,
    );
  }
}

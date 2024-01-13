import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/select_date_model.dart';
import 'package:mainproject_apill/models/select_posture_model.dart';
import 'package:mainproject_apill/models/select_week_model.dart';
import 'package:mainproject_apill/models/select_month_model.dart';
import 'package:mainproject_apill/models/week_month_posture_model.dart';

class StatisticCon extends GetxController with GetSingleTickerProviderStateMixin {

  // 달력 중 DB 데이터가 있는 날짜만 모아놓는 리스트
  RxList<DateTime> activeDates = <DateTime>[].obs;

  // 내가 선택한 날짜를 저장하는 변수 기본값은 오늘
  Rx<DateTime> selectedDate = DateTime.now().obs;

  // 내가 선택한 날짜가 속한 일요일을 저장하는 변수
  late Rx<DateTime> selectedDateSunday;

  // 하루데이터 저장용
  RxList<SelectDateData> selectedDateData = <SelectDateData>[].obs;

  // 하루데이터를 쪼개놓은 리스트
  RxList splitSelectedDateData = [].obs;

  // 일주일데이터 저장용
  RxList<SelectWeekSleepModel> selectedWeekSleepData = [
    SelectWeekSleepModel(date: DateTime.now().subtract(Duration(days: 3)),sleepNum: 1,totalSleepTime: 10),
    SelectWeekSleepModel(date: DateTime.now().subtract(Duration(days: 2)),sleepNum: 2,totalSleepTime: 20),
    SelectWeekSleepModel(date: DateTime.now().subtract(Duration(days: 1)),sleepNum: 3,totalSleepTime: 30),
    SelectWeekSleepModel(date: DateTime.now(),sleepNum: 3,totalSleepTime: 40),
    SelectWeekSleepModel(date: DateTime.now().add(Duration(days: 1)),sleepNum: 4,totalSleepTime: 30),
    SelectWeekSleepModel(date: DateTime.now().add(Duration(days: 2)),sleepNum: 5,totalSleepTime: 20),
    SelectWeekSleepModel(date: DateTime.now().add(Duration(days: 3)),sleepNum: 6,totalSleepTime: 10),
  ].obs;

  // 한달치데이터 저장용
  RxList<SelectMonthData> selectedMonthData = <SelectMonthData>[].obs;

  // 한달의 기간 확인
  RxList<DateTime> setMonthStartEndData = [
    DateTime.now().subtract(Duration(days: 30)),
    DateTime.now()
  ].obs;

  // 홈 화면 위에 나오는 멘트
  // 수면 문구
  RxString comment = ''.obs;


  // 파이 그래프 안쪽
  RxString totalSleepInPieChart = '데이터 없음'.obs;
  // 파이 그래프 안쪽 수면 시작 및 수면 종료
  RxString startEndTimeInPieChart = '데이터 없음'.obs;
  // 파이 그래프 내가 볼 수면 정보 인덱스
  RxInt pieIndex = 0.obs;
  // 파이 차트 내가 터치한 인덱스
  RxInt pieTouchIndex = (-1).obs;
  // 파이 그래프용 데이터
  RxList<dynamic> pieData = [].obs;

  // 라인 그래프용 데이터
  RxList lineData = [].obs;
  // 라인 그래프 하단 제목
  RxList lineBottomTitle = ["00:00","00:00"].obs;

  // 수평 누적 그래프 데이터
  RxList stackBarChartData = [
    SelectPostureModel(posture: 'DP',minutes: 1),
    SelectPostureModel(posture: 'CP',minutes: 1),
  ].obs;

  // 주간 통계용 데이터
  RxList<WeekMonthPostureModel> weekPostureTimeData = [
    WeekMonthPostureModel(totalSleepTime: 10,date: DateTime.now().subtract(Duration(days: 3)),postureType: 'DP'),
    WeekMonthPostureModel(totalSleepTime: 10,date: DateTime.now().subtract(Duration(days: 3)),postureType: 'CP'),
    WeekMonthPostureModel(totalSleepTime: 20,date: DateTime.now().subtract(Duration(days: 2)),postureType: 'CP'),
    WeekMonthPostureModel(totalSleepTime: 30,date: DateTime.now().subtract(Duration(days: 1)),postureType: 'DP'),
    WeekMonthPostureModel(totalSleepTime: 40,date: DateTime.now(),postureType: 'CP'),
    WeekMonthPostureModel(totalSleepTime: 30,date: DateTime.now().add(Duration(days: 1)),postureType: 'DP'),
    WeekMonthPostureModel(totalSleepTime: 20,date: DateTime.now().add(Duration(days: 2)),postureType: 'CP'),
    WeekMonthPostureModel(totalSleepTime: 10,date: DateTime.now().add(Duration(days: 3)),postureType: 'DP'),
  ].obs;

  //월간용 데이터 저장
  List monthChartData = [];

  // 애니메이션
  // 버튼 누르면 사라지게 하는 변수
  RxBool appbarCheck = true.obs;
  // 애니메이션 컨트롤러
  final Rxn<AnimationController> _animationController = Rxn<AnimationController>();
  AnimationController? get animationController => _animationController.value;
  // 애니메이션 높이
  final Rxn<Animation<double>> _heightAnimation = Rxn<Animation<double>>();
  Animation<double>? get heightAnimation => _heightAnimation.value;
  // 애니메이션 투명도
  final Rxn<Animation<double>> _opacityAnimation = Rxn<Animation<double>>();
  Animation<double>? get opacityAnimation => _opacityAnimation.value;


  @override
  void onInit() {
    super.onInit();

    // 애니메이션 재생시간
    const duration = Duration(seconds: 2,);
    _animationController.value = AnimationController(
      vsync: this, duration: duration,
    );
    // 버튼 눌렀을때 높이를 0으로 만들어주는 애니메이션
    // 텍스트를 감지하고 텍스트의 스타일과 몇 줄인지를 감지하고 높이를 계산함
    _heightAnimation.value = (Tween<double>(begin: 300.h, end: 0)
        .chain(CurveTween(curve: Curves.easeInOut))
        .animate(_animationController.value!));
    // 투명도 애니메이션
    _opacityAnimation.value = (Tween<double>(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController.value!));

    selectedDateSunday = findSunday(DateTime.now()).obs;
  }
  void startAnimation() async {
    await _animationController.value?.forward();
    appbarCheck.value = !appbarCheck.value;
  }

  @override
  void onClose() {
    _animationController.value?.dispose();
    super.onClose();
  }

  DateTime findSunday(DateTime date) {
    int daysUntilSunday = date.weekday - DateTime.sunday;
    return daysUntilSunday >= 0
        ? date.subtract(Duration(days: daysUntilSunday))
        : date.subtract(Duration(days: 7 + daysUntilSunday));
  }
}

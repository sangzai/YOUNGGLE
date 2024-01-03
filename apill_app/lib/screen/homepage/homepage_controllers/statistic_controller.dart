import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/selectDateModel.dart';
import 'package:mainproject_apill/models/selectWeekModel.dart';
import 'package:mainproject_apill/utils/getTextHeight.dart';
import 'package:mainproject_apill/widgets/mytheme.dart';

class StatisticCon extends GetxController with GetSingleTickerProviderStateMixin {

  // 달력 중 DB 데이터가 있는 날짜만 모아놓는 리스트
  RxList<DateTime> activeDates = <DateTime>[].obs;

  // 내가 선택한 날짜를 저장하는 변수 기본값은 오늘
  Rx<DateTime> selectedDate = DateTime.now().obs;

  // 내가 선택한 날짜가 속한 일요일을 저장하는 변수
  late Rx<DateTime> selectedDateSunday;

  // 하루데이터 저장용
  List<SelectDateData> selectedDateData = <SelectDateData>[].obs;

  // 일주일데이터 저장용
  List<SelectWeekData> selectedWeekData = <SelectWeekData>[].obs;

  // 한달치데이터 저장용
  List<SelectWeekData> selectedMonthData = <SelectWeekData>[].obs;

  // 홈 화면 위에 나오는 멘트
  // DB를 통해 랜덤으로 가져와야함
  RxString goodSleep = '오늘은 숙면을 위해 캐모마일티를 마셔보는건 어떠신가요?'.obs;

  // 파이 그래프 안쪽
  RxString totalSleepInPieChart = '00시 00분'.obs;

  // 파이 그래프 안쪽 수면 시작 및 수면 종료

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
    const duration = Duration(milliseconds: 3000);

    _animationController.value = AnimationController(
      vsync: this, duration: duration,
    );

    // 버튼 눌렀을때 높이를 0으로 만들어주는 애니메이션
    // 텍스트를 감지하고 텍스트의 스타일과 몇 줄인지를 감지하고 높이를 계산함
    _heightAnimation.value = (Tween<double>(
        begin: getTextHeight(
            goodSleep.value, myTheme.textTheme.headlineLarge!, 2),
        end: 1)
        .chain(CurveTween(curve: Curves.ease))
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
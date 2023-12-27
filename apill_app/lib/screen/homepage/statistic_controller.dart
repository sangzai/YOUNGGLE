import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/utils/getTextHeight.dart';
import 'package:mainproject_apill/widgets/mytheme.dart';

class StatisticCon extends GetxController with GetSingleTickerProviderStateMixin {

  Rx<DateTime> selectedDate = DateTime.now().obs;

  RxString goodSleep = 'ApilL님\n오늘은 숙면을 위해 캐모마일티를 마셔보는건 어떠신가요?'.obs;

  RxBool appbarCheck = true.obs;

  RxDouble appBarHeight = 0.0.obs;

  RxDouble heightBegin = 100.0.obs;

  final Rxn<AnimationController> _animationController = Rxn<AnimationController>();
  AnimationController? get animationController => _animationController.value;

  final Rxn<Animation<double>> _heightAnimation = Rxn<Animation<double>>();
  Animation<double>? get heightAnimation => _heightAnimation.value;

  final Rxn<Animation<double>> _opacityAnimation = Rxn<Animation<double>>();
  Animation<double>? get opacityAnimation => _opacityAnimation.value;


  @override
  void onInit() {

    super.onInit();

    const duration = Duration(milliseconds: 500);

    _animationController.value = AnimationController(
      vsync: this, duration: duration,
    );

    _heightAnimation.value = (Tween<double>(begin: getTextHeight(goodSleep.value, myTheme.textTheme.headlineLarge!, ScreenUtil().screenWidth), end: 0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController.value!));

    _opacityAnimation.value = (Tween<double>(begin: 1.0, end: 0.0)
        .chain(CurveTween(curve: Curves.ease))
        .animate(_animationController.value!));
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


}

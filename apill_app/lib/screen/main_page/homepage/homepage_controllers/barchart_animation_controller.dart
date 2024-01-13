
import 'package:flutter/animation.dart';
import 'package:get/get.dart';

class BarChartAnimationController
    extends GetxController
    with GetSingleTickerProviderStateMixin{


  // 스택바 애니메이션 컨트롤러
  late AnimationController animationController;
  var isAnimating = false.obs;
  @override
  void onInit(){
    super.onInit();

    animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 3));
  }

  @override
  void onReady(){
    super.onReady();
  }

  @override
  void onClose(){
    super.onClose();
   animationController.dispose();
  }

  startAnimation(){
    if(animationController.isAnimating){
      isAnimating.value = false;
      animationController.stop();
    } else {
      isAnimating.value = true;
      animationController.forward(from: 0.0);
      // animationController.repeat();
    }
  }
}
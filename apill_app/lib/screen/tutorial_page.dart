import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/screen/main_page/sleep_page/pillow_height_controller.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {

  final userCon = Get.find<UserController>();
  final mqttHandler = Get.find<MqttHandler>();
  final pillowHeightCon = Get.find<PillowHeightController>();

  RxBool frontCheck = false.obs;
  RxBool sideCheck = false.obs;

  final _introKey = GlobalKey<IntroductionScreenState>();
  RxInt countdownRx = 30.obs; // 타이머 시간 설정
  Timer? _countdownTimer; // Timer?로 변경

  @override
  void initState() {
    super.initState();
  }

  // 등누운자세 다이어로그 알림창으로 시간 세기
  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (countdownRx.value > 0) {
        countdownRx(countdownRx.value - 1); // Rx 변수 업데이트
      } else {
        _onCountdownComplete(); //
        _stopCountdownTimer(); // 타이머 종료
        countdownRx.value = 30;
      }
    });
  }

  // 옆누운자세 다이어로그 알림창으로 시간 세기
  void _startCountdownTimerTwo() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (countdownRx.value > 0) {
        countdownRx(countdownRx.value - 1); // Rx 변수 업데이트
      } else {
        _onCountdownCompleteTwo();
        _stopCountdownTimer(); // 변경된 부분: 타이머 종료
        countdownRx.value = 30;
      }
    });
  }

  void _stopCountdownTimer() {
    if (_countdownTimer != null) {
      _countdownTimer!.cancel();
      _countdownTimer = null;
    }
  }


  // 카운트다운 알림창을 열기 위한 함수(등누운자세)
  void _showCountdownDialog() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text('알림'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('측정을 시작하겠습니다.\n측정이 완료되면 자동으로 닫힙니다.',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 16),
            Obx(() => Text(
              '남은 시간: ${countdownRx.value}초',
              style: TextStyle(fontSize: 20, color: Colors.black),
            )),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              // _onCountdownComplete(); // 측정 완료 처리
              _countdownTimer?.cancel(); // 타이머 종료
              countdownRx.value = 30;
            },
            child: Text('종료'),
          ),
        ],
      ),
    );

  }

  // 카운트다운 알림창을 열기 위한 함수(옆누운자세)
  void _showCountdownDialogTwo() {
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text('알림'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('측정을 시작하겠습니다.\n측정이 완료되면 자동으로 닫힙니다.',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            SizedBox(height: 16),
            Obx(() => Text(
              '남은 시간: ${countdownRx.value}초',
              style: TextStyle(fontSize: 20, color: Colors.black),
            )),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              // _onCountdownCompleteTwo(); // 측정 완료 처리
              _countdownTimer?.cancel(); // 타이머 종료
              countdownRx.value = 30;
            },
            child: Text('종료'),
          ),
        ],
      ),
    );
  }


  // 카운트다운이 완료되면 호출되는 메소드(등누운자세)
  void _onCountdownComplete() {
    frontCheck.value = true;
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text('측정'),
        content: Text('측정이 완료되었습니다.', style: TextStyle(fontSize: 20, color: Colors.black)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              Get.back(); // 다이얼로그 닫기
              _showCountdownDialog();
              _startCountdownTimer();
            },
            child: Text('재측정'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              Get.back();
              _introKey.currentState?.next();
            },
            child: Text('완료'),
          ),

        ],
      ),
    );
  }

  // 카운트다운이 완료되면 호출되는 메소드(옆누운자세)
  void _onCountdownCompleteTwo(){
    sideCheck.value = true;
    Get.dialog(
      barrierDismissible: false,
      AlertDialog(
        title: Text('측정'),
        content: Text('측정이 완료되었습니다.', style: TextStyle(fontSize: 20, color: Colors.black)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              Get.back(); // 다이얼로그 닫기
              _showCountdownDialogTwo();
              _startCountdownTimerTwo();
            },
            child: Text('재측정'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              Get.back();
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text('설정이 완료되었습니다.'),
                  content: Text('ApiL에서 자동베개높이 측정을 통해 사용자의 수면 데이터를 분석하여 수면 그래프와 주무시는데 최적의 베개높이를 제공해드립니다.', style: TextStyle(fontSize: 20, color: Colors.black),),
                  actions: [
                    ElevatedButton(onPressed: () async {
                      Get.back(); // 다이얼로그 닫기
                      initalizeDataBeforeNavi();
                    }, child: Text('확인')
                    ),

                  ],
                );
              });
              _introKey.currentState?.next();
            },
            child: Text('완료'),
          ),

        ],
      ),
    );
  }

  // ElevatedButton(onPressed: (){
  // showDialog(context: context, builder: (context){
  // return AlertDialog(
  // title: Text(''),
  // content: Text('ApiL에서 자동베개높이 측정을 통해 사용자의 수면 데이터를 분석하여 수면 그래프와 주무시는데 최적의 베개높이를 제공해드립니다.', style: TextStyle(fontSize: 20, color: Colors.black),),
  // actions: [
  // ElevatedButton(onPressed: () async {
  // Get.back(); // 다이얼로그 닫기
  // initalizeDataBeforeNavi();
  // }, child: Text('확인')
  // ),
  //
  // ],
  // );
  // });
  // }, child: Text('확인')),

  // 베개 연결
  void _checkPillowPower() async {
    Get.dialog(
      barrierDismissible: false,

      AlertDialog(
        title: Text('전원'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('베개와 연결을 시작하겠습니다.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            SizedBox(height: 16),
            Obx(() =>
                Text(
                  '남은 시간: ${countdownRx.value}초',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                )
            ),

          ],
        ),
        actions: [
          TextButton(
            onPressed: (){
              Get.back();
              _stopCountdownTimer(); // 변경된 부분: 타이머 종료
              countdownRx.value = 30;
            },
            child: Text("취소"),
          )
        ],
      ),
    );

  }

  // 베개 연결 시간초 변경해주는 함수
  void _startPillowCheckCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) async {
      if (!pillowHeightCon.pillowCheck.value) {
        if (countdownRx.value > 0) {
          mqttHandler.pubCheckPillowPowerOn();
          countdownRx(countdownRx.value - 1); // Rx 변수 업데이트
        } else {
          Get.back();
          _showSimpleDialog("전원","베개와의 연결이 실패했습니다.");
          _stopCountdownTimer(); // _startPillowCheckCountdownTimer타이머 종료
          countdownRx.value = 30;

        }
      } else {
        Get.back();
        _stopCountdownTimer();
        countdownRx.value = 30;
        await Get.dialog(

          AlertDialog(

            title: Text('전원'),
            content: Text('베개와의 연결이 성공했습니다.',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
          ),
        );
        Future.delayed(const Duration(seconds: 0),
                () => _introKey.currentState?.next());
      }


    });
  }

  void _showSimpleDialog(String title, String content) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content,
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
      ),
    );
  }



  @override
  void dispose() {
    _stopCountdownTimer(); // 변경된 부분: dispose 시에도 타이머 종료
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BackGroundImageContainer(
      child: SafeArea(
        child: IntroductionScreen(
          // 2. Pass that key to the `IntroductionScreen` `key` param
          key: _introKey,
          globalHeader: Align(
           alignment: Alignment.topRight,
           child: TextButton(
             child: Text("종료"),
             onPressed: (){
               _showSkipDialog();
             },
           ),
          ),
          pages: [
            PageViewModel(
              title: '환영합니다.',
              bodyWidget: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        // setState(() => _status = 'Going to the next page...');
                        // 3. Use the `currentState` member to access functions defined in `IntroductionScreenState`
                        Future.delayed(const Duration(seconds: 0),
                                () => _introKey.currentState?.next());
                        // _introKey.currentState?.next();
                      },
                      child: Text('튜토리얼 시작하기')
                  )
                ],
              ),
              image: Center(
                child: Container(
                  // 튜토리얼 시작 그림
                  child: Image.asset('assets/image/MoonBG.png',), width: MediaQuery.of(context).size.width,) // 이미지가 반드시 있어야 작동
              ),
              // decoration: PageDecoration(
              //   contentMargin:EdgeInsets.all(20),
              //   pageMargin: EdgeInsets.all(40),),
            ),

            PageViewModel(
                // title: '베개의 전원을 켜주세요.',
                titleWidget: SizedBox(),
                bodyWidget: Column(
                  children: [
                    Text('베개의 전원을 켜주세요.', style: Theme.of(context).textTheme.titleMedium,),
                    Text('전원이 켜졌다면 버튼을 눌러주세요.', style: Theme.of(context).textTheme.titleMedium,),
                    SizedBox(height: 30,),
                    SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(onPressed: (){
                        _checkPillowPower();
                        _startPillowCheckCountdownTimer();
                      }, child: Text('연결하기', style: Theme.of(context).textTheme.titleLarge,)),
                    ),
                  ],
                ),
                image: Container(
                  // 베개 그림
                    child: Image.asset('assets/image/pillow_power.png', width: MediaQuery.of(context).size.width,)
                ),
            ),

            PageViewModel(
                title: '베개를 통해 높이를 측정하겠습니다.',
                bodyWidget: Column(
                  children: [
                    Text('베개에 등누운자세로 누워주세요.', style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(height: 30,),
                    Container(
                      child: ElevatedButton(onPressed: (){
                        // 카운트다운 알림창 열기
                        _showCountdownDialog();
                        _startCountdownTimer();

                      }, child: Text('On', style: Theme.of(context).textTheme.titleLarge,)
                      ),
                    )
                  ],
                ),
                image: Obx(
                  ()=> Container(
                    // 등누운자세 그림
                      child: Image.asset(
                          frontCheck.value ?
                          'assets/image/posture_front_check.png':
                          'assets/image/posture_front.png',
                          width: MediaQuery.of(context).size.width)
                  ),
                ),
                decoration: PageDecoration(
                    contentMargin:EdgeInsets.all(20),
                    pageMargin: EdgeInsets.all(30))
            ),
            PageViewModel(
                title: '베개를 통해 높이를 측정하겠습니다.',
                bodyWidget: Column(
                  children: [
                    Text('베개의 옆누운자세로 누워주세요.', style: Theme.of(context).textTheme.titleLarge,),
                    SizedBox(height: 30,),
                    Container(
                      child: ElevatedButton(onPressed: (){
                        _showCountdownDialogTwo();
                        _startCountdownTimerTwo();

                      }, child: Text('On', style: Theme.of(context).textTheme.titleLarge,)),
                    ),
                  ],
                ),
                image: Obx(
                  ()=> Container(
                    // 옆누운자세 그림
                      child: Image.asset(
                        sideCheck.value ?
                        'assets/image/posture_side_check.png':
                        'assets/image/posture_side.png',
                        width: MediaQuery.of(context).size.width,)
                  ),
                ),
                decoration: PageDecoration(
                    contentMargin:EdgeInsets.all(20),
                    pageMargin: EdgeInsets.all(30))
            ),
          ],



          skip: Text('종료'),
          onSkip: () {
            _showSkipDialog();
          },
          showSkipButton: false,
          skipSemantic: 'Skip introduction',

          done: Text('완료'),
          onDone: () async {
            // TODO : 튜토리얼에 true를 저장하면 튜토리얼 다시 안보게 됨
            initalizeDataBeforeNavi();
          },
          next: Container(),
          showNextButton: false,
          isProgress: false,
          isProgressTap: false,
          freeze: true,


        ),
      ),
    );
  }

  void _showSkipDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('알림'),
        content: Text('튜토리얼을 종료하시겠습니까?',
          style: TextStyle(fontSize: 18, color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              Get.offAllNamed('/navi');
            },
            child: Text('다음에하기'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
            },
            child: Text('계속하기'),
          ),
        ],
      ),
    );
  }


  Future<void> initalizeDataBeforeNavi() async{
    print("✨튜토리얼 페이지의 initalizeDataBeforeNavi 함수");
    await userCon.storage.write(
        key: '${userCon.userId.value} tutorial',
        value : 'true'
    );
    // await SetInitialDate().initializeData();
    Get.offAllNamed('/navi');
  }
}



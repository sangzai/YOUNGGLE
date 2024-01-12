import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mainproject_apill/screen/login_page/user_controller.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_utils/set_initial_date.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {

  static final storage = FlutterSecureStorage();

  final userCon = Get.find<UserController>();

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
      AlertDialog(
        title: Text('알림'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('측정을 시작하겠습니다. 측정이 완료되면 자동으로 닫힙니다.',
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
              _onCountdownComplete(); // 측정 완료 처리
              _countdownTimer?.cancel(); // 타이머 종료
              countdownRx.value = 30;
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  // 카운트다운 알림창을 열기 위한 함수(옆누운자세)
  void _showCountdownDialogTwo() {
    Get.dialog(
      AlertDialog(
        title: Text('알림'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('측정을 시작하겠습니다. 측정이 완료되면 자동으로 닫힙니다.',
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
              _onCountdownCompleteTwo(); // 측정 완료 처리
              _countdownTimer?.cancel(); // 타이머 종료
              countdownRx.value = 30;
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }


  // 카운트다운이 완료되면 호출되는 메소드(등누운자세)
  void _onCountdownComplete() {
    Get.dialog(
      AlertDialog(
        title: Text('측정'),
        content: Text('측정이 완료되었습니다.', style: TextStyle(fontSize: 20, color: Colors.black)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              Get.back();
              _introKey.currentState?.next(); // 온보딩의 다음 페이지로 이동
            },
            child: Text('확인'),
          ),
          ElevatedButton(
            onPressed: () {
              // 닫기 버튼을 눌렀을 때의 동작을 추가
              Navigator.of(context).pop(); // 다이얼로그 닫기
              // 여기에 닫기 버튼을 눌렀을 때의 추가 동작을 작성
            },
            child: Text('닫기'),
          ),

        ],
      ),
    );
  }

  // 카운트다운이 완료되면 호출되는 메소드(옆누운자세)
  void _onCountdownCompleteTwo(){
    Get.dialog(
      AlertDialog(
        title: Text('측정'),
        content: Text('측정이 완료되었습니다.', style: TextStyle(fontSize: 20, color: Colors.black),),
        actions: [
          Container(
            child: ElevatedButton(onPressed: (){
              showDialog(context: context, builder: (context){
                return AlertDialog(
                  title: Text(''),
                  content: Text('ApiL에서 자동베개높이 측정을 통해 사용자의 수면 데이터를 분석하여 수면 그래프와 주무시는데 최적의 베개높이를 제공해드립니다.', style: TextStyle(fontSize: 20, color: Colors.black),),
                  actions: [
                    ElevatedButton(onPressed: () async {
                      Get.back(); // 다이얼로그 닫기
                      initalizeDataBeforeNavi();
                    }, child: Text('확인')),

                  ],
                );
              });
            }, child: Text('확인')),
          )
        ],
      ),
    );
  }

  void _connectPower() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('전원'),
          content: Text('전원 연결 중...', style: TextStyle(fontSize: 20, color: Colors.black),),
        );
      },
    );

    bool isConnected = await _checkPowerConnection();

    // 5초 동안의 카운트다운 다이얼로그
    int countdown = 5;
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        // 다이얼로그 업데이트
        Navigator.of(context).pop(); // 현재 다이얼로그 닫기
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('전원'),
              content: Text('전원 연결 중...남은 시간: $countdown초', style: TextStyle(fontSize: 20, color: Colors.black),),
            );
          },
        );
        countdown--;
      } else {
        // 5초 후에 전원 연결 여부에 따라 다이얼로그 표시
        timer.cancel(); // 타이머 종료
        Navigator.of(context).pop(); // 다이얼로그 닫기

        if (isConnected) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('전원'),
                content: Text('전원이 연결되었습니다.', style: TextStyle(fontSize: 20, color: Colors.black),),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 전원 연결 완료 다이얼로그 닫기
                      _introKey.currentState?.next(); // 온보딩의 다음 페이지로 이동
                    },
                    child: Text('확인'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // 닫기 버튼을 눌렀을 때의 동작을 추가
                      Navigator.of(context).pop(); // 다이얼로그 닫기
                      // 여기에 닫기 버튼을 눌렀을 때의 추가 동작을 작성
                    },
                    child: Text('닫기'),
                  ),
                ],
              );
            },
          );
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('전원'),
                content: Text('전원 연결 실패. 다시 시도해주세요.'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // 전원 연결 실패 다이얼로그 닫기
                    },
                    child: Text('확인'),
                  ),
                ],
              );
            },
          );
        }
      }
    });
  }

  Future<bool> _checkPowerConnection() async {
    // 여기에 전원 연결 여부를 확인하는 비동기 작업을 추가
    // 예를 들어, 특정 API를 호출하거나 하드웨어 상태를 확인가능

    // 여기에서는 1초 동안 딜레이 후 연결된 것으로 간주하는 코드를 작성
    await Future.delayed(Duration(seconds: 1));

    // 실제로는 여러 요인을 고려하여 전원 연결 여부를 판단해야 함
    // 여기에서는 간단한 예시이므로 항상 true를 반환
    return true;
  }



  @override
  void dispose() {
    _stopCountdownTimer(); // 변경된 부분: dispose 시에도 타이머 종료
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BackGroundImageContainer(
      child: Center(
        child: IntroductionScreen(
          // 2. Pass that key to the `IntroductionScreen` `key` param
          key: _introKey,
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
              decoration: PageDecoration(
                contentMargin:EdgeInsets.all(20),
                pageMargin: EdgeInsets.all(40),),
            ),
      
            PageViewModel(
                title: '베개의 전원을 켜주세요.',
                bodyWidget: Column(
                  children: [
                    Text('전원을 켠 후 버튼을 눌러주세요.', style: Theme.of(context).textTheme.titleMedium,),
                    SizedBox(height: 30,),
                    SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(onPressed: (){
                        _connectPower();
                      }, child: Text('연동하기', style: Theme.of(context).textTheme.titleLarge,)),
                    ),
                  ],
                ),
                image: Container(
                  // 베개 그림
                    child: Image.asset('assets/image/pillow_power.png', width: MediaQuery.of(context).size.width,)
                ),
                decoration: PageDecoration(
                    contentMargin:EdgeInsets.all(20),
                    pageMargin: EdgeInsets.all(30))
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
          next: Text('다음'),
          showNextButton: true,
      
          back: Text('이전'),
          showBackButton: true,
      
          done: Text('완료'),
          onDone: () async {
            // TODO : 튜토리얼에 true를 저장하면 튜토리얼 다시 안보게 됨
            initalizeDataBeforeNavi();
          },
        ),
      ),
    );
  }

  Future<void> initalizeDataBeforeNavi() async{
    print("✨튜토리얼 페이지의 initalizeDataBeforeNavi 함수");
    await storage.write(
        key: '${userCon.userId.value} tutorial',
        value : 'true'
    );
    // await SetInitialDate().initializeData();
    Get.offAllNamed('/navi');
  }
}



import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:mainproject_apill/screen/main_page/bottom_navi_page.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {

  static final storage = FlutterSecureStorage();

  // bool isPillowConnected = false; // IoT 기기 연결상태
  // 1. Define a `GlobalKey` as part of the parent widget's state
  final _introKey = GlobalKey<IntroductionScreenState>();
  RxInt countdownRx = 30.obs; // 타이머 시간 설정
  Timer? _countdownTimer; // Timer?로 변경

  @override
  void initState() {
    super.initState();

  }

  void _startCountdownTimer() {
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (countdownRx.value > 0) {
        countdownRx(countdownRx.value - 1); // Rx 변수 업데이트
      } else {
        _onCountdownComplete();
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


  // 카운트다운 알림창을 열기 위한 함수
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
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }

  // 카운트다운 알림창을 열기 위한 함수2
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
            child: Text('닫기'),
          ),
        ],
      ),
    );
  }


  // 카운트다운이 완료되면 호출되는 메소드
  void _onCountdownComplete() {
    Get.dialog(
      AlertDialog(
        title: Text('측정'),
        content: Text('측정이 완료되었습니다.', style: TextStyle(fontSize: 20, color: Colors.black)),
        actions: [
          ElevatedButton(
            onPressed: () {
              Get.back(); // 다이얼로그 닫기
              // Navigator.of(context).pop(); // 주석 처리하면 다이얼로그창(알림)이 나중에 닫기를 눌러야 해서 두 번 닫아야함..
              // 주석처리 안하면 일정시간이 안지나고 알림창을 닫으면 오류가 뜸..
              _introKey.currentState?.next(); // 온보딩의 다음 페이지로 이동
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  // 카운트다운이 완료되면 호출되는 메소드2
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
                    ElevatedButton(onPressed: (){
                      Get.back(); // 다이얼로그 닫기
                      // Navigator.of(context).pushReplacement(
                      //     MaterialPageRoute(builder: (context)=>BottomNaviPage()));
                      // TODO : 라우팅 관리
                      Get.offAllNamed('/navi');


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
                    Container(
                      child: Text('전원을 켠 후 버튼을 눌러주세요.', style: Theme.of(context).textTheme.titleMedium,),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      child: ElevatedButton(onPressed: (){
                        showDialog(context: context, builder: (context){
                          return AlertDialog(
                            title: Text('전원'),
                            content: Text('전원이 연결되었습니다.', style: TextStyle(fontSize: 20, color: Colors.black),),
                            actions: [
                              Container(
                                child: ElevatedButton(onPressed: (){
                                  Navigator.of(context).pop();
                                  _introKey.currentState?.next();
                                }, child: Text('확인')),
                              )
                            ],
                          );
                        });
                      }, child: Text('On', style: Theme.of(context).textTheme.titleLarge,)),
                    ),
                  ],
                ),
                image: Container(
                    child: Image.asset('assets/image/pillow.png', width: MediaQuery.of(context).size.width,)
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
                image: Container(
                    child: Image.network('https://thumb.mt.co.kr/06/2020/04/2020040312451812893_3.jpg/dims/optimize/', width: MediaQuery.of(context).size.width,)
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
                image: Container(
                    child: Image.network('https://thumb.mt.co.kr/06/2020/04/2020040312451812893_1.jpg/dims/optimize/', width: MediaQuery.of(context).size.width,)
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
            // 상호작용 : IoT 기기와 통신하여 연결 상태 업데이트
            // 실제 코드에서는 적절한 IoT 통신 코드를 사용해야 함
            // setState(() {
            //   isPillowConnected = true;
            // });
      
            // Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(builder: (context)=>BottomNaviPage())
            // );
            // TODO : 튜토리얼에 true를 저장하면 튜토리얼 다시 안보게 됨
            await storage.write(
              key: 'tutorial',
              value : 'false'
            );
            Get.offAllNamed('/navi');
      
          },
        ),
      ),
    );
  }
}

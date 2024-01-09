import 'package:flutter/material.dart';
import 'package:mainproject_apill/widgets/backgroundcon.dart';

class information extends StatelessWidget {
  const information({super.key});

  @override
  Widget build(BuildContext context) {
    return BackGroundImageContainer(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('ApilL정보'),
        ),
        body: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('제품명 : ApilL', style: TextStyle(fontSize: 17, color: Colors.white),),
                SizedBox(height: 20,),
                Text('개발기관 : 스마트인재개발원', style: TextStyle(fontSize: 17, color: Colors.white),),
                SizedBox(height: 20,),
                Text('개발자 : 이상원, 이건중, 이다현, 오승헌, 조도원, 임유동', style: TextStyle(fontSize: 17, color: Colors.white),),
                SizedBox(height: 20,),
                Text('기능 : 본 제품은 음성명령을 통하여 베개의 높이를 자동으로 조절해줍니다. 압력, 기압센서를 활용하여 사용자의 체압을 분석하여 베개의 높이를 자동으로 조절해줍니다. 또한, STT와 TTS 기술을 활용하여 음성 인터페이스를 통한 베개높이조절 및 알람설정이 가능하고 YOUTUBE API를 통한 노래 재생, openweather API 및 기상청 API 통한 날씨 알림, Chat GPT API를 통한 대화 기능이 있다. 어플케이션과 연동이 되며 수면 모니터링, 수동 베개높이 조절, 알람 설정이 가능하다. 이러한 기능들로 사용자분들의 편안하고 안락한 수면환경을 만들어드리도록 개발하였습니다.', style: TextStyle(fontSize: 17, color: Colors.white),),
                SizedBox(height: 20,),
                Text('IDE : Android Studio, Visual Studio, Jupyter notebook, Arduibo IDE, Thonny IDE', style: TextStyle(fontSize: 17, color: Colors.white),),
                SizedBox(height: 20,),
                Text('DB : MySQL Workbench 8.0 CE', style: TextStyle(fontSize: 17, color: Colors.white),),
                SizedBox(height: 20,),
                Text('Server : MQTT Publish, Subscribe', style: TextStyle(fontSize: 17, color: Colors.white),),
                SizedBox(height: 20,),
                Text('Library : React.js 18.2.0, tailwind 4.0.0, fl_chart 0.65, get 4.6.6, introduction_screen: 3.1.12, joblib(1.2.0), pandas(1.5.3), numpy(1.24.3), sklearn(1.3.1) ', style: TextStyle(fontSize: 17, color: Colors.white),),
                SizedBox(height: 20,),
                Text('제작기간 : 2023.12.04 ~2024.01.16', style: TextStyle(fontSize: 17, color: Colors.white),),


              ],
            ),
          ),
        ),
    );
  }
}

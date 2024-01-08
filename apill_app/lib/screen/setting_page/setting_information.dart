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
            children: [
              Text('제품명 : ApilL', style: TextStyle(fontSize: 20, color: Colors.white),),
              SizedBox(height: 20,),
              Text('제품기간 : ')
            ],
          ),
        ),
      
      ),
    );
  }
}

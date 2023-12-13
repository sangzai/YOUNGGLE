import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
            child: Text('홈페이지',style: TextStyle(color: Colors.white54,fontSize: 48,fontWeight: FontWeight.bold)),
          ),
    );


  }
}

import 'package:flutter/material.dart';

class BackGroundImageContainer extends StatelessWidget {
  const BackGroundImageContainer({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/image/background.png',),
              fit: BoxFit.fill)
      ),
      child: child,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mainproject_apill/models/selectDateModel.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class TodaySummarys extends StatelessWidget {
  const TodaySummarys({
    super.key,
    required this.userName,
    required this.data,

  });

  final List<SelectDateData> data;
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.containerBackColor
        ),
        width: MediaQuery.of(context).size.width,
        // TODO 그래프 구현 2
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${userName}님의 번째 수면은',
                style: Theme.of(context).textTheme.headlineLarge,),
              Text('수면시간 : ',
                style: Theme.of(context).textTheme.headlineMedium,),
              Text('뒤척임 횟수 : ',
                style: Theme.of(context).textTheme.headlineMedium,),
              Text('옆누운자세 : ',style: Theme.of(context).textTheme.headlineMedium,),
              Text('등누운자세 : ',style: Theme.of(context).textTheme.headlineMedium,),
              Text('코골이 시간 : ',style: Theme.of(context).textTheme.headlineMedium,),
            ] // Column children
          ),
        ),

    );





  }
}

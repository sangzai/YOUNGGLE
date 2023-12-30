import 'package:flutter/material.dart';
import 'package:mainproject_apill/models/selectDateModel.dart';
import 'package:mainproject_apill/screen/homepage/homepage_widgets/statisitc_barchart.dart';
import 'package:mainproject_apill/screen/homepage/homepage_widgets/statistic_linechart.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class TodayCharts extends StatelessWidget {
  const TodayCharts({
    super.key,
    required this.data,
  });

  final List<SelectDateData> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColors.ContainerBackColor
      ),
      width: MediaQuery.of(context).size.width,
      height: 300,
      // TODO 그래프 구현 2
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3,child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
              child: Container(color: Colors.transparent,child: HomeLineChart()),
            )),
            Expanded(child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(58, 4, 24, 4),
                    child: HomeBarChart(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10,height: 10,color: Color(0xFF5D6DBE),),
                          SizedBox(width: 10,),
                          Text('등누운자세'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10,height: 10,color: Color(0xFF7DB249),),
                          SizedBox(width: 10,),
                          Text('옆누운자세'),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            )),
          ],
        ),
      ),

    );





  }
}

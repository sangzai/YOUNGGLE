import 'package:flutter/material.dart';
import 'package:mainproject_apill/models/select_date_model.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_widgets/statisitc_barchart.dart';
import 'package:mainproject_apill/screen/main_page/homepage/homepage_widgets/statistic_linechart.dart';
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
          color: AppColors.containerBackColor
      ),
      width: MediaQuery.of(context).size.width,
      height: 330,
      // TODO 그래프 구현 2
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3,child: Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
              // padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 4),
              child: HomeLineChart(),
            )),
            Expanded(child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(48, 4, 28, 4),
                    child: HomeBarChart(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10,height: 10,color: AppColors.appColorBlue70,),
                          SizedBox(width: 10,),
                          Text('등누운자세'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(width: 10,height: 10,color: AppColors.appColorGreen70,),
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

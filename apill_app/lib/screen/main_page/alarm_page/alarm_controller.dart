import 'package:get/get.dart';
import 'package:mainproject_apill/screen/main_page/alarm_page/alarm_page.dart';

class AlarmController extends GetxController {
  var alarms = <Alarm>[].obs;
  var lastAlarms = <Alarm>[].obs;
  var checkedId = [].obs;

  List<int> getSelectedAlarmIds() {
    return alarms
        .where((alarm) => alarm.isSelected)
        .map<int>((alarm) => alarm.id ?? 0)
        .toList();
  }
}
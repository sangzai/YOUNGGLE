import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mainproject_apill/models/alarm_model.dart';
import 'package:mainproject_apill/screen/main_page/alarm_page/alarm_controller.dart';
import 'package:mainproject_apill/utils/mqtt_handler.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  // 알람 추가시 현재 선택한 시간이 보이게끔

  bool checkAllbox = false;

  final mqttHandler = Get.find<MqttHandler>();

  final alarmCon = Get.find<AlarmController>();

  List<Alarm> get alarms => alarmCon.alarms;
  // List<Alarm> alarms = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  // @override
  // void dispose() {
  //   mqttHandler.client.unsubscribe('Apill/alarm/Appreturn');
  //   super.dispose();
  // }

  Future<void> _initializeData() async {
    // 비동기 작업 수행
    // await mqttHandler.client.subscribe('Apill/alarm/Appreturn', MqttQos.atMostOnce);
    var response = await mqttHandler.pubGetAlarmWaitResponse();
    print("✨알람 초기화 함수");

    List<AlarmModel> alarmList = alarmModelFromJson(response);
    alarms.clear();

    for (AlarmModel alarmModel in alarmList){
      int id = alarmModel.id;
      TimeOfDay time = TimeOfDay(
        hour: int.parse(alarmModel.time.split(":")[0]),
        minute: int.parse(alarmModel.time.split(":")[1]),
      );
      bool isOn = alarmModel.isOn == 1;
      bool isSelected = false;
      
      Alarm alarm = Alarm(time, id : id, isOn: isOn, isSelected: isSelected);
      alarms.add(alarm);
    }
    // print("✨알람 목록 확인 ${alarmCon.alarms}");


    // setState를 호출하여 UI를 업데이트
    // setState(() {
    //   // 여기에서 다른 initState에서 사용할 수 있는 데이터 처리
    //   // print("✨알람 페이지 : $response");
    // });
  }

  @override
  Widget build(BuildContext context) {

    return Stack(
        fit: StackFit.expand,
        children: [
          AppBar(
            title: Text(
              '알람',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            actions: [
              Visibility(
                visible: checkAllbox,
                child: IconButton(
                  icon: Icon(Icons.check_box_outline_blank),
                  color: AppColors.appColorWhite60,
                  onPressed: (){
                    setState(() {
                      // 현재 상태에 따라서 선택 또는 선택 해제를 수행
                      bool allSelected = alarms.every((alarm) => alarm.isSelected);

                      for (var alarm in alarms) {
                        alarm.isSelected = !allSelected;
                      }
                    });

                  },

                ),
              ),
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  _showAddAlarmDialog(context);
                },
                color: AppColors.appColorWhite60,
              ),

              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteSelectedAlarms();
                  checkAllbox = false;
                },
                color: AppColors.appColorWhite60,
              ),
            ],
          ),
          // 알람 목록
          Obx(
            ()=> Positioned(
              top: AppBar().preferredSize.height + 20.0,
              left: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: ListView.builder(
                itemCount: alarms.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AlarmTile(
                      alarm: alarms[index],
                      onAlarmSelected: (isSelected) {
                        setState(() {
                          alarms[index].isSelected = isSelected;
                          checkAllbox = alarms.any((alarm) => alarm.isSelected);

                        });
                      },
                      onDelete: () {
                        setState(() {
                          alarms.removeWhere((alarm) => alarm.isSelected);
                        });
                      },
                      onLongPress: () async {
                        // final editedAlarm = await _showEditAlarmDialog(context, alarms[index]);
                        // if (editedAlarm != null) {
                        //   setState(() {
                        //     alarms[alarms.indexOf(alarms[index])] = editedAlarm;
                        //   });
                        // }
                        final editedAlarm = await _showEditAlarmDialog(context, alarms[index]);

                        if (editedAlarm != null) {
                          setState(() {
                            alarms[alarms.indexOf(alarms[index])] = editedAlarm;
                          });
                          // updateAlarmAndPublish(alarms[alarms.indexOf(alarms[index])]);
                        }
                      },
                      onToggle: () async {
                        setState(() {
                          alarms[index].isOn = !alarms[index].isOn;
                        });
                        // await updateAlarmAndPublish(alarms[index]);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      );

  }

  // Future<void> updateAlarmAndPublish(Alarm editedAlarm) async {
  //   // int editedAlarmIndex = alarms.indexWhere((alarm) => alarm.id == editedAlarm.id);
  //
  //   // 확인된 인덱스가 유효하다면 해당 위치에 변경된 알람을 설정
  //   // if (editedAlarmIndex != -1) {
  //   //   alarms[editedAlarmIndex] = editedAlarm;
  //
  //     // 변경된 알람의 아이디와 시간 확인
  //   int editedAlarmId = editedAlarm.id ?? 0; // 예시: 0은 기본값
  //   TimeOfDay editedAlarmTime = editedAlarm.time;
  //   bool editedIsOn = editedAlarm.isOn;
  //   bool isSelected = false;
  //   print('✨알람 수정 확인 : $editedAlarmId $editedAlarmTime $editedIsOn $isSelected');
  //   await mqttHandler.pubUpdateAlarm(
  //     editedAlarmTime,
  //     editedIsOn,
  //     isSelected,
  //     editedAlarmId,
  //   );
  //   await mqttHandler.pubGetAlarmWaitResponse();
  // }

  // 선택된 알람 삭제
  void _deleteSelectedAlarms() async {

    print('✨리스트확인  ${alarmCon.getSelectedAlarmIds()}');
    List<int> selectedAlarmIds = alarmCon.getSelectedAlarmIds();

    // Now, the selectedIds list contains the ids of the deleted alarms (excluding null ids)
    print("✨삭제할 알람들의 id: $selectedAlarmIds");

    await mqttHandler.pubDeleteAlarm(selectedAlarmIds);

    setState(() {
      alarms.removeWhere((alarm) {
        if (alarm.isSelected) {
          return true; // Remove the alarm if it is selected
        }
        return false; // Keep the alarm if it is not selected
      });
    });

    mqttHandler.pubGetAlarmWaitResponse();
  }

  // 알람 추가 다이얼로그 표시
  void _showAddAlarmDialog(BuildContext context) async {
    final newAlarm = await showDialog<Alarm>(
      context: context,
      builder: (context) => AddAlarmDialog(),
    );

    if (newAlarm != null) {

      setState(() {
        alarms.add(newAlarm);
      });

      TimeOfDay addAlarmTime = newAlarm.time;
      bool addIsOn = newAlarm.isOn;
      bool isSelected = false;

      await mqttHandler.pubAddAlarm(
        addAlarmTime,
        addIsOn,
        isSelected
      );
      mqttHandler.pubGetAlarmWaitResponse();



    }
  }

  // 알람 수정 다이얼로그 표시
  Future<Alarm?> _showEditAlarmDialog(BuildContext context, Alarm alarm) async {

    return showDialog<Alarm>(
      context: context,
      builder: (context) => EditAlarmDialog(editingAlarm: alarm),
    );
  }
}

class AddAlarmDialog extends StatefulWidget {
  @override
  _AddAlarmDialogState createState() => _AddAlarmDialogState();
}

class _AddAlarmDialogState extends State<AddAlarmDialog> {
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = TimeOfDay(hour: 6,minute: 0);
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      backgroundColor: Colors.white.withOpacity(0.8),
      title: Text('알람 추가'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: AppColors.appColorWhite30)
              ),
              backgroundColor: AppColors.appColorBlue10
            ),
              onPressed: () => _showTimePicker(context),
              child: Text(
                '${_formatTime(selectedTime)}',
                style: TextStyle(
                  color: AppColors.appColorBlack.lighten(15),
                  fontWeight: FontWeight.w600,
                  fontSize: 90.sp,
                ),
              ),
          ),
          
        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('취소'),
            ),
            ElevatedButton(
              onPressed: () {

                _saveAlarm(context);
              },
              child: Text('저장'),
            ),
          ],
        ),
      ],
    );
  }

  void _showTimePicker(BuildContext context) async {
    final pickedTime = await showTimePicker(
      cancelText: "취소",
      confirmText: "확인",
      helpText: "",
      hourLabelText: "시간",
      minuteLabelText: "분",
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  void _saveAlarm(BuildContext context) {
    final newAlarm = Alarm(selectedTime);
    Navigator.of(context).pop(newAlarm);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = '${time.minute}'.padLeft(2, '0');
    final period = time.period == DayPeriod.am ? '오전' : '오후';

    return '$period $hour:$minute';
  }
}

class Alarm {
  int? id;
  final TimeOfDay time;
  bool isOn;
  bool isSelected;

  Alarm(this.time, {this.id, this.isOn = true, this.isSelected = false});
}

class AlarmTile extends StatefulWidget {
  final Alarm alarm;
  final ValueChanged<bool> onAlarmSelected;
  final VoidCallback onDelete;
  final VoidCallback onLongPress;
  final VoidCallback onToggle;

  AlarmTile({
    required this.alarm,
    required this.onAlarmSelected,
    required this.onDelete,
    required this.onLongPress,
    required this.onToggle,
  });

  @override
  _AlarmTileState createState() => _AlarmTileState();
}

class _AlarmTileState extends State<AlarmTile> {

  final alarmCon = Get.find<AlarmController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 0, 16),
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
      decoration: BoxDecoration(
        color: widget.alarm.isSelected
            ? Colors.grey.withOpacity(0.4)
            : Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                ' ${_formatTime(widget.alarm.time)}',
                style: TextStyle(color: Colors.grey[300], fontSize: 24),
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    widget.onToggle();
                  },
                  child: _buildToggleImage(widget.alarm.isOn),
                ),
                Checkbox(
                  value: widget.alarm.isSelected,
                  onChanged: (value) {
                    if (value ?? false) {
                      // 만약 선택한 알람이 true라면 리스트에 추가
                      if (!alarmCon.checkedId.contains(widget.onAlarmSelected)) {
                        alarmCon.checkedId.add(widget.onAlarmSelected);
                      }
                    } else {
                      // 만약 선택한 알람이 false라면 리스트에서 제거
                      alarmCon.checkedId.remove(widget.onAlarmSelected);
                    }
                    widget.onAlarmSelected(value ?? false);
                  },
                ),
              ],
            ),
          ],
        ),
        onLongPress: () {
          widget.onLongPress();
        },
      ),
    );
  }

  Widget _buildToggleImage(bool isOn) {

    final imageColor = isOn ? Colors.amber : Colors.white;

    return
        Image.asset(
          'assets/image/OnlyMoon.png',
          width: 40,
          height: 40,
          color : imageColor,
          errorBuilder: (context, error, stackTrace) {
            return Text('이미지 오류');
          },
        );

  }

  String _formatTime(TimeOfDay time) {
    final hour = '${time.hourOfPeriod}'.padLeft(2, '0');
    // final hour = time.hourOfPeriod;
    final minute = '${time.minute}'.padLeft(2, '0');
    final period = time.period == DayPeriod.am ? '오전' : '오후';

    return '$hour:$minute $period';
  }
}

class EditAlarmDialog extends StatefulWidget {
  final Alarm editingAlarm;

  EditAlarmDialog({required this.editingAlarm});

  @override
  _EditAlarmDialogState createState() => _EditAlarmDialogState();
}

class _EditAlarmDialogState extends State<EditAlarmDialog> {

  final mqttHandler = Get.find<MqttHandler>();

  late int id;

  late TimeOfDay selectedTime;

  late TimeOfDay editedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.editingAlarm.time;
    id = widget.editingAlarm.id!;
    editedTime = selectedTime;
  }
  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text('알람 수정'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(

                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(color: AppColors.appColorWhite30)
                ),
                backgroundColor: AppColors.appColorBlue10
            ),
            onPressed: () => _showTimePicker(context),
            child: Text(
              '${_formatTime(editedTime)}',
              style: TextStyle(
                color: AppColors.appColorBlack.lighten(15),
                fontWeight: FontWeight.w600,
                fontSize: 90.sp,
              ),
            ),
          ),

        ],
      ),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('취소'),
          ),
            ElevatedButton(
              onPressed: () {

                _saveAlarm(context);


              },
              child: Text('저장'),
            ),
          ],
        ),
      ],
    );
  }

  void _showTimePicker(BuildContext context) async {
    final pickedTime = await showTimePicker(
      cancelText: "취소",
      confirmText: "확인",
      helpText: "",
      hourLabelText: "시간",
      minuteLabelText: "분",
      context: context,
      initialTime: selectedTime,
    );

    if (pickedTime != null) {
      setState(() {
        editedTime = pickedTime;
      });
    }
  }

  Future<void> _saveAlarm(BuildContext context) async {

    final editedAlarm = Alarm(
        editedTime,
        id: id,
        isOn: widget.editingAlarm.isOn,
        isSelected: widget.editingAlarm.isSelected
    );

    Navigator.of(context).pop(editedAlarm);
  //   ✨

  await mqttHandler.pubUpdateAlarm(
    editedTime,
    widget.editingAlarm.isOn,
    widget.editingAlarm.isSelected,
    id,
  );
  await mqttHandler.pubGetAlarmWaitResponse();

  }

  String _formatTime(TimeOfDay time) {
    final hour = "${time.hourOfPeriod}".padLeft(2,'0');
    final minute = '${time.minute}'.padLeft(2, '0');
    final period = time.period == DayPeriod.am ? '오전' : '오후';

    return '$period $hour:$minute ';
  }
}
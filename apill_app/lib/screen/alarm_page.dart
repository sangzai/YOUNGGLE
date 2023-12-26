import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mainproject_apill/widgets/appcolors.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key});

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  // TODO : 알람을 DB와 핸드폰에 저장
  // 알람 추가시 현재 선택한 시간이 보이게끔

  List<Alarm> alarms = [];

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
                },
                color: AppColors.appColorWhite60,
              ),
            ],
          ),
          // 알람 목록
          Positioned(
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
                      });
                    },
                    onDelete: () {
                      setState(() {
                        alarms.removeWhere((alarm) => alarm.isSelected);
                      });
                    },
                    onLongPress: () async {
                      final editedAlarm = await _showEditAlarmDialog(context, alarms[index]);
                      if (editedAlarm != null) {
                        setState(() {
                          alarms[alarms.indexOf(alarms[index])] = editedAlarm;
                        });
                      }
                    },
                    onToggle: () {
                      setState(() {
                        alarms[index].isOn = !alarms[index].isOn;
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );

  }

  // 선택된 알람 삭제
  void _deleteSelectedAlarms() {
    setState(() {
      alarms.removeWhere((alarm) => alarm.isSelected);
    });
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
          // Text(
          //   '${_formatTime(selectedTime)}',
          //   style: TextStyle(
          //     color: AppColors.appColorBlack.lighten(15),
          //     fontWeight: FontWeight.w600,
          //     fontSize: 90.sp,
          //   ),
          // ),
          //
          // SizedBox(height: 10),
          //
          // ElevatedButton(
          //   onPressed: () => _showTimePicker(context),
          //   child: Text('알람 시간 선택'),
          // ),
          
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
  final TimeOfDay time;
  bool isOn;
  bool isSelected;

  Alarm(this.time, {this.isOn = true, this.isSelected = false});
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
    final hour = time.hourOfPeriod;
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
  late TimeOfDay selectedTime;

  @override
  void initState() {
    super.initState();
    selectedTime = widget.editingAlarm.time;
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
              '${_formatTime(selectedTime)}',
              style: TextStyle(
                color: AppColors.appColorBlack.lighten(15),
                fontWeight: FontWeight.w600,
                fontSize: 90.sp,
              ),
            ),
          ),
          // Text(
          //   '${_formatTime(selectedTime)}',
          //   style: TextStyle(
          //     color: AppColors.appColorBlack.lighten(15),
          //     fontWeight: FontWeight.w600,
          //     fontSize: 90.sp,
          //   ),
          // ),
          //
          // SizedBox(height: 10),
          //
          // ElevatedButton(
          //   onPressed: () => _showTimePicker(context),
          //   child: Text('알람 시간 선택'),
          // ),

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
        selectedTime = pickedTime;
      });
    }
  }

  void _saveAlarm(BuildContext context) {
    final editedAlarm = Alarm(
        selectedTime,
        isOn: widget.editingAlarm.isOn,
        isSelected: widget.editingAlarm.isSelected
    );
    Navigator.of(context).pop(editedAlarm);
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = '${time.minute}'.padLeft(2, '0');
    final period = time.period == DayPeriod.am ? '오전' : '오후';

    return '$period $hour:$minute ';
  }
}
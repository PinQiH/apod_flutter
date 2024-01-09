import 'dart:convert';

import 'package:apod/widget/astro_picture.dart';
import 'package:apod/widget/calendar_day_cell.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../api/constants.dart';
import '../keys/api_key.dart';
import '../model/ApodData.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime current = DateTime.now();
  bool _isLoading = false;

  final Map<String, ApodData> _dailyApodMap = {};

  @override
  void initState() {
    super.initState();
    String firstDayofMonth =
    formatDate(DateTime(current.year, current.month, 1));
    _fetchDailyApodData(firstDayofMonth, formatDate(current));
  }

  _fetchDailyApodData(String startDate, String endDate) async {
    if (_dailyApodMap[startDate] != null && _dailyApodMap[endDate] != null) {
      // 已經前後時間的資料，代表當月都抓過了，不必再call api抓一次
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Uri url = Uri.parse(
        '$apodEndpoint?api_key=$apiKey&thumbs=true&start_date=$startDate&end_date=$endDate');
    final response = await http.get(url, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });

    final parsedResponse = json.decode(response.body) as List<dynamic>;

    List<Map<String, dynamic>> dataList =
    parsedResponse.map((data) => data as Map<String, dynamic>).toList();

    for (var data in dataList) {
      _dailyApodMap[data['date']] = ApodData.fromJson(data);
    }

    setState(() {
      _isLoading = false;
    });
  }

  String formatDate(DateTime datetime) {
    return '${datetime.year}-${datetime.month < 10 ? '0${datetime.month}' : datetime.month}-${datetime.day < 10 ? '0${datetime.day}' : datetime.day}';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : TableCalendar(
            headerStyle: const HeaderStyle(formatButtonVisible: false),
            firstDay: DateTime.utc(current.year - 2, 01, 01),
            lastDay: DateTime.now(),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedDay = focusedDay;
              });

              if (focusedDay.month <= current.month) {
                String lastDayOfMonth = formatDate(
                    DateTime(focusedDay.year, focusedDay.month + 1, 0));
                _fetchDailyApodData(
                    formatDate(focusedDay),
                    DateTime(focusedDay.year, focusedDay.month + 1, 0)
                        .isAfter(current)
                        ? formatDate(current)
                        : lastDayOfMonth);
              }
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay; // 選取的日期
                _focusedDay = focusedDay; // 頁面停留的日期
              });
            },
            onDayLongPressed: ((selectedDay, focusedDay) {
              String date = formatDate(focusedDay);
              ApodData? apodDataForDate = _dailyApodMap[date];

              // 長按日期時導向該日的天文圖片頁面
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return Scaffold(
                    appBar: AppBar(title: Text(formatDate(selectedDay))),
                    body: apodDataForDate != null
                        ? AstroPicture(apodData: apodDataForDate)
                        : Center(child: Text('No data available for this date')));
              }));
            }),
            calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) => Center(
                    child: CalendarDayCell(
                      day: day,
                      hasDot: _dailyApodMap[formatDate(day)] != null,
                      dotColor: Colors.red,
                    )),
                selectedBuilder: (context, day, focusedDay) => Center(
                    child: CalendarDayCell(
                      day: day,
                      decoration: BoxDecoration(
                        color: Colors.blue[300],
                        shape: BoxShape.circle,
                      ),
                      hasDot: _dailyApodMap[formatDate(day)] != null,
                      dotColor: Colors.red,
                    )),
                todayBuilder: (context, day, focusedDay) => CalendarDayCell(
                  day: day,
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    shape: BoxShape.circle,
                  ),
                  hasDot: _dailyApodMap[formatDate(day)] != null,
                  dotColor: Colors.red,
                ))));
  }
}
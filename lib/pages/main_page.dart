// lib/pages/main_page.dart
import 'dart:convert';

import 'package:apod/model/ApodData.dart';
import 'package:apod/widget/astro_picture.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../keys/api_key.dart';

class MainPage extends StatefulWidget {
  MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}

enum NoteType { editable, text }

class _MainPageState extends State<MainPage> {
  final String apodUrl = 'https://api.nasa.gov/planetary/apod';

  @override
  void initState() {
    _fetchDailyApodData(); // 在頁面生成時取得APOD 資訊
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<ApodData?> _fetchDailyApodData() async {
    try {
      Uri url = Uri.parse('$apodUrl?api_key=$apiKey&thumbs=true');
      final response = await http.get(url, headers: {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final parsedResponse = json.decode(response.body) as Map<String, dynamic>;
        return ApodData.fromJson(parsedResponse);
      } else {
        // 處理錯誤情況
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // 處理任何拋出的錯誤
      print('An error occurred: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ApodData?>(
        future: _fetchDailyApodData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 加載中顯示加載指示器
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 發生錯誤時顯示錯誤信息
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            // 數據加載完成，使用數據構建界面
            ApodData apodData = snapshot.data!;
            return AstroPicture(
              title: apodData.title,
              url: apodData.url,
              desc: apodData.desc,
              note: 'Place your note here!', // 待日後將儲存的筆記放進來
              isFavorite: false, // 待日後將收藏狀態放進來
            );
          }  else {
            // 如果沒有數據顯示，則顯示預設信息
            return Center(child: Text('No data available'));
          }
        }
      )// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
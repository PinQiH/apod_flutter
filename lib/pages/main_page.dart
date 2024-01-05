// lib/pages/main_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/ApodData.dart';
import '../keys/api_key.dart';

class MainPage extends StatefulWidget {
  MainPage();

  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<MainPage> {
  bool _isFavorited = false; // 添加一個狀態變量來追蹤是否被點擊

  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited; // 在每次點擊時切換狀態
    });
  }

  final String apodUrl = 'https://api.nasa.gov/planetary/apod';

  @override
  void initState() {
    _fetchDailyApodData(); // 在頁面生成時取得APOD 資訊
    super.initState();
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
            return SingleChildScrollView (
                child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width, // 將容器的寬度設為螢幕寬度
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.width, // 將容器的最小高度設為螢幕寬度
                            ),
                            child: Image.network(
                                apodData.url,
                              fit: BoxFit.cover,
                              loadingBuilder:(
                                  BuildContext context,
                                  Widget child,
                                  ImageChunkEvent? loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              frameBuilder: (
                                  BuildContext context,
                                  Widget child,
                                  int? frame,
                                  bool wasSynchronouslyLoaded) {
                                if (wasSynchronouslyLoaded) {
                                  return child;
                                }
                                return AnimatedOpacity(
                                  opacity: frame == null ? 0 : 1,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.easeOut,
                                  child: child,
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 10.0, // 距離頂部的偏移量
                            left: 0.0, // 左邊對齊
                            right: 0.0, // 右邊對齊
                            child: Center( // Center 確保文字水平中心對齊
                              child: Text(
                                apodData.title, // 這裡放置您的標題文字
                                style: TextStyle(
                                  fontSize: 24.0, // 字體大小
                                  color: Colors.white, // 字體顏色
                                  shadows: <Shadow>[
                                    Shadow(
                                      offset: Offset(1.0, 1.0),
                                      blurRadius: 3.0,
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 10.0, // 相對上方距離10.0
                            right: 10.0, // 相對右方距離10.0
                            child: IconButton(
                              onPressed: _toggleFavorite,
                              icon: Icon(
                                Icons.favorite,
                                // 根據 _isFavorited 狀態來設置顏色
                                color: _isFavorited ? Theme.of(context).colorScheme.primary : Colors.white,
                              ),
                              iconSize: 30.0, // 設置圖標大小
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0), // 水平方向左右各添加16單位的內邊距
                        child: Text(
                          apodData.desc,
                          style: TextStyle(
                            fontSize: 12,
                            height: 2,
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                    ]
                )
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
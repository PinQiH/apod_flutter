import 'package:flutter/material.dart';

import 'pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1; // 預設選擇首頁(第二個項目)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget title;

    // 根據選擇的索引顯示相應的頁面
    switch (_selectedIndex) {
      case 0:
        title = Text('日曆');
        break;
      case 1:
        title = Text('今日照片');
        break;
      case 2:
        title = Text('設定');
        break;
      default:
        title = Text('未知');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: title,
      ),
      body: MainPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '日曆',
            tooltip: '前往日曆',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
            tooltip: '點擊這裡返回首頁',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
            tooltip: '前往設定',
          ),
        ],
        currentIndex: _selectedIndex, // 當前選中的索引
        onTap: _onItemTapped, // 更新選中的索引
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

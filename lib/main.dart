import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'model/daily_apod_state.dart';
import 'pages/main_page.dart';
import 'pages/favorite_page.dart';
import 'pages/calendar_page.dart';

import 'model/favorite_state.dart';

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

enum NoteType {
  text,
  editable,
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': '月曆',
      'widget': CalendarPage(),
    },
    {
      'title': '今日照片',
      'widget': MainPage(),
    },
    {
      'title': '我的收藏',
      'widget': FavoritePage()
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(_pages[_selectedIndex]['title']),
      ),
      body: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) =>
                FavoriteState(), // 在主要頁面的上層放了 FavoriteList 作為三個頁面都可共用的state
          ),
          ChangeNotifierProvider(create: (context) => DailyApodState())
        ],
        child: _pages[_selectedIndex]['widget'],
      ),
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
            icon: Icon(Icons.favorite),
            label: '最愛',
            tooltip: '前往我的最愛',
          ),
        ],
        currentIndex: _selectedIndex, // 當前選中的索引
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },// 更新選中的索引
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

import 'package:flutter/material.dart';

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
      home: const MyHomePage(title: '今日照片'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

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
    Widget content;

    // 根據選擇的索引顯示相應的頁面
    switch (_selectedIndex) {
      case 0:
        content = Text('日曆內容');
        break;
      case 1:
        content = Text('首頁內容');
        break;
      case 2:
        content = Text('設定內容');
        break;
      default:
        content = Text('未知的索引');
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(child: content),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: '日曆',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首頁',
            tooltip: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
            tooltip: '',
          ),
        ],
        currentIndex: _selectedIndex, // 當前選中的索引
        onTap: _onItemTapped, // 更新選中的索引
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

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
      body: SingleChildScrollView (
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 500,
                child: Image.network(
                  'https://i.pinimg.com/564x/a4/c7/13/a4c713ee683ff455464faa9132a69688.jpg',
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
              ElevatedButton.icon(
                  onPressed: () {
                    print('add to favorite');
                  },
                icon: Icon(Icons.favorite), // 在這裡添加愛心圖標
                label: Text('favorite'), // 按鈕的文字
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0), // 水平方向左右各添加16單位的內邊距
                child: Text(
                  "How much of planet Earth is made of water? Very little, actually. Although oceans of water cover about 70 percent of Earth's surface, these oceans are shallow compared to the Earth's radius. The featured illustration shows what would happen if all of the water on or near the surface of the Earth were bunched up into a ball. The radius of this ball would be only about 700 kilometers, less than half the radius of the Earth's Moon, but slightly larger than Saturn's moon Rhea which, like many moons in our outer Solar System, is mostly water ice. The next smallest ball depicts all of Earth's liquid fresh water, while the tiniest ball shows the volume of all of Earth's fresh-water lakes and rivers. How any of this water came to be on the Earth and whether any significant amount is trapped far beneath Earth's surface remain topics of research.",
                  style: TextStyle(fontSize: 12),
                ),
              ),
              SizedBox(height: 50),
            ]
          )
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

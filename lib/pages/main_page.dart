// lib/pages/main_page.dart
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView (
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
                        'https://apod.nasa.gov/apod/image/2209/WaterlessEarth2_woodshole_2520.jpg',
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
                    "How much of planet Earth is made of water? Very little, actually. Although oceans of water cover about 70 percent of Earth's surface, these oceans are shallow compared to the Earth's radius. The featured illustration shows what would happen if all of the water on or near the surface of the Earth were bunched up into a ball. The radius of this ball would be only about 700 kilometers, less than half the radius of the Earth's Moon, but slightly larger than Saturn's moon Rhea which, like many moons in our outer Solar System, is mostly water ice. The next smallest ball depicts all of Earth's liquid fresh water, while the tiniest ball shows the volume of all of Earth's fresh-water lakes and rivers. How any of this water came to be on the Earth and whether any significant amount is trapped far beneath Earth's surface remain topics of research.",
                    style: TextStyle(
                      fontSize: 12,
                      height: 2,
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ]
          )
      ),// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
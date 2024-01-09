import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/ApodData.dart';
import '../model/favorite_state.dart';

// 定義頁面筆記模式
enum NoteType {
  text,
  editable,
}

class AstroPicture extends StatefulWidget {
  final ApodData apodData;

  const AstroPicture({super.key, required this.apodData});

  @override
  State<AstroPicture> createState() => _AstroPictureState();
}

class _AstroPictureState extends State<AstroPicture> {
  // 用來控制文本欄的控制器
  final TextEditingController _controller = TextEditingController();
  NoteType _noteType = NoteType.editable;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.apodData.note;
    _isFavorite = widget.apodData.isFavorite;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildTextInputOrText(BuildContext context) {
    if (_noteType == NoteType.text) {
      // 如果是顯示文本模式
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal:16.0), // 在水平方向上增加間隔
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 16.0), // 右邊增加間隔
                padding: const EdgeInsets.all(16.0),
                child: Text(_controller.text),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5.0),
                  border: Border.all(color: Colors.grey), // 添加灰色實線邊框
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _noteType = NoteType.editable; // 切換回可編輯模式
                });
              },
              child: const Icon(Icons.edit),
            ),
          ],
        ),
      );
    } else {
      // 如果是可編輯模式
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // 在水平方向上增加間隔
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 16.0), // 右邊增加間隔
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: '請輸入留言...', // 提供提示文本
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey), // 設置灰色實線邊框
                    ),
                  ),
                  maxLines: 5,
                  minLines: 3,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                setState(() {
                  _noteType = NoteType.text; // 切換到文本模式
                });
              },
              child: const Icon(Icons.save),
            ),
          ],
        ),
      );
    }
  }

  void addToFavorite(context, ApodData apodData) {
    apodData.isFavorite = true;
    Provider.of<FavoriteState>(context, listen: false)
        .addToList(apodData); // 透過proivder.of直接調用FavoriteState的方法
    setState(() {
      _isFavorite = true;
    });
  }

  void removeFromFavorite(context, ApodData apodData) {
    apodData.isFavorite = false;
    Provider.of<FavoriteState>(context, listen: false).removeFromList(apodData);
    setState(() {
      _isFavorite = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      widget.apodData.url,
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
                        widget.apodData.title, // 這裡放置您的標題文字
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
                      onPressed: () {
                        _isFavorite == false
                            ? addToFavorite(context, widget.apodData)
                            : removeFromFavorite(context, widget.apodData);
                      },
                      icon: Icon(
                        Icons.favorite,
                        color: _isFavorite ? Theme.of(context).colorScheme.primary : Colors.white,
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
                  widget.apodData.desc,
                  style: TextStyle(
                    fontSize: 12,
                    height: 2,
                  ),
                ),
              ),
              SizedBox(height: 30),
              _buildTextInputOrText(context), // 調用上面定義的方法
              SizedBox(height: 50),
            ]
        )
    );
  }
}
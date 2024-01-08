import 'package:flutter/material.dart';

// 定義頁面筆記模式
enum NoteType {
  text,
  editable,
}

class AstroPicture extends StatefulWidget {
  final String title; // 標題
  final String url; // 圖片來源
  final String desc; // 圖片描述
  final String note; // 手札
  final bool isFavorite; // 是否收藏

  const AstroPicture(
    {
      super.key,
      required this.title,
      required this.url,
      required this.desc,
      required this.isFavorite,
      this.note = '', // 非必要，若沒有手札紀錄預設為空字串
    }
  ); // 非必要，預設為非收藏的圖片

  @override
  State<AstroPicture> createState() => _AstroPictureState();
}

class _AstroPictureState extends State<AstroPicture> {
  // 添加一個狀態變量來追蹤是否被點擊
  bool _isFavorited = false;
  void _toggleFavorite() {
    setState(() {
      _isFavorited = !_isFavorited; // 在每次點擊時切換狀態
    });
  }

  // 用來控制文本欄的控制器
  final TextEditingController _controller = TextEditingController();
  NoteType _noteType = NoteType.editable;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.note;
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
                      widget.url,
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
                        widget.title, // 這裡放置您的標題文字
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
                  widget.desc,
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
class ApodData {
  final String title; // 圖片標題
  final String url; // 圖片資源連結
  final String mediaType;  // 圖片類型
  final String desc;  // 圖片描述
  final String date;  // 日期

  ApodData(this.title, this.url, this.mediaType, this.desc, this.date);

  ApodData.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        url = json['hdurl'],
        mediaType = json['media_type'],
        desc = json['explanation'],
        date = json['date'];

  Map<String, dynamic> toJson() => {
    'title': title,
    'url': url,
    'media_type': mediaType,
    'explanation': desc,
    'date': date,
  };
}
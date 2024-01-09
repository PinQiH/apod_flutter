import 'package:apod/model/favorite_state.dart';
import 'package:apod/widget/astro_picture.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/ApodData.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<FavoriteState>(
        builder: (context, favoriteState, child) {
          List<ApodData> list = favoriteState.favoriteList;
          return list.isNotEmpty
              ? ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                elevation: 5.0,
                child: ListTile(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          title: Text(list[index].title),
                        ),
                        body: ChangeNotifierProvider.value(
                            value: favoriteState,
                            child: AstroPicture(apodData: list[index])
                        ),
                      );
                    }));
                  },
                  leading: Image.network(
                    list[index].url,
                    width: 80,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    list[index].title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  subtitle: Text(
                    list[index].date,
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400]
                    ),
                  ),
                ),
              );
            },
          )
              : Center(
            child: Text(
              '目前沒有收藏！',
              style: TextStyle(fontSize: 30, color: Colors.grey[400]),
            ),
          );
        },
      ),
    );
  }
}

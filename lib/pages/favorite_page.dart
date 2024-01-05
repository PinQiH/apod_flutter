// lib/pages/main_page.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/ApodData.dart';
import '../keys/api_key.dart';

class FavoritesPage extends StatefulWidget {
  FavoritesPage();

  @override
  _MainPageState createState() => _MainPageState();
}


class _MainPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return Container(
          height: 100,
          padding: const EdgeInsets.all(5.0),
          child: const Expanded(
            child: Card(
                elevation: 5.0,
                child: Center(
                  child: Text(
                    'I am Image Title',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                )),
          ),
        );
      },
      itemCount: 2,
    );
  }
}
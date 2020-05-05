import 'package:flutter/material.dart';
import './ui/klimatic.dart';
void main() {
  runApp(
    new MaterialApp(
      title: 'get_weather_forecast',
      debugShowCheckedModeBanner: false,
      home: new Klimatic(),
    )
  );
}
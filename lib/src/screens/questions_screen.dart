import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/material.dart';

import 'attend_screen.dart';
import 'participation_screen.dart';
import 'profile_screen.dart';

class Questions extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Swiper",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: new Swiper(
        itemBuilder: (BuildContext context,int index){
          return simpleText(index.toString());
        },
        itemCount: 3,
        pagination: new SwiperPagination(),
        control: new SwiperControl(),
      ),
    );
  }
  
}


Widget simpleText (String text) {
  return Scaffold(body: Text("${text}", style: TextStyle(color: Colors.red, fontSize: 100)));
}
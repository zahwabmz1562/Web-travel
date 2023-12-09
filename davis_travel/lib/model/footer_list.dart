import 'package:flutter/material.dart';

class FooterList {
  IconData? icon;
  String? content;
  String? img;

  FooterList({this.icon, this.content, this.img});

  FooterList.fromJson(Map<String, dynamic> json) {
    icon = json['icon'];
    content = json['content'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['icon'] = icon;
    data['content'] = content;
    data['img'] = img;
    return data;
  }
}

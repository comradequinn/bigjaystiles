import 'dart:io';

import 'package:flutter/material.dart';

class InputValidationException implements Exception {
  final String message;

  InputValidationException(this.message);
}

class Tile {
  final int id;
  String title;
  File image;
  File audio;
  int categoryID;

  Tile(this.id, this.title, this.image, this.audio, this.categoryID);

  Tile.fromJson(Map<String, dynamic> json,
      {String imagePathPrefix = "", String audioPathPrefix = ""})
      : id = json['id'],
        title = json['title'],
        image = File("$imagePathPrefix${json['image']}"),
        audio = File("$audioPathPrefix${json['audio']}"),
        categoryID = json['categoryID'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image.path,
        'audio': audio.path,
        'categoryID': categoryID
      };

  Tile clone() {
    return Tile(id, title, image, audio, categoryID);
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Tile && hashCode == other.hashCode;
}

class Category {
  static const unassigned = 0;

  final int id;
  String title;
  bool hidden;
  IconData icon;

  Category(this.id, this.title, this.icon, {this.hidden = false});

  Category.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        hidden = json['hidden'],
        icon = IconData(json['icon'], fontFamily: 'MaterialIcons');

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'hidden': hidden,
        'icon': icon.codePoint,
      };

  Category clone() {
    return Category(id, title, icon, hidden: hidden);
  }

  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) =>
      other is Category && hashCode == other.hashCode;
}

abstract class TileReader {
  ValueNotifier<bool> get changeNotifier;
  List<Category> categories({includeHidden = false});
  List<Tile> tiles(Category c);
}

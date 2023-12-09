import 'dart:typed_data';

class City {
  String? name;
  String? description;
  int? price;
  String? label;
  List<String>? benefit;
  List<Details>? details;
  String? image;
  Uint8List? imageByte;

  City(
      {this.name,
      this.description,
      this.price,
      this.label,
      this.benefit,
      this.details,
      this.image,
      this.imageByte});

  City.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    price = json['price'];
    label = json['label'];
    benefit = json['benefit'].cast<String>();
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
    image = json['image'];
    imageByte = json['image_byte'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['label'] = label;
    data['benefit'] = benefit;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    data['image'] = image;
    data['image_byte'] = imageByte;
    return data;
  }
}

class Details {
  int? id;
  String? name;
  String? detail;

  Details({this.id, this.name, this.detail});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    detail = json['detail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['detail'] = detail;
    return data;
  }
}

class PrivateTrip {
  String? id;
  String? image;
  String? name;
  String? type;

  PrivateTrip({this.id, this.image, this.name, this.type});

  PrivateTrip.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}

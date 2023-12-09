class Transportation {
  String? id;
  String? image;
  String? name;
  String? description;
  String? type;

  Transportation({this.id, this.image, this.name, this.description, this.type});

  Transportation.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    data['name'] = name;
    data['description'] = description;
    data['type'] = type;
    return data;
  }
}

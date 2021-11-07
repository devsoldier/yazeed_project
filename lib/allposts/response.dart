class response {
  String? id;
  String? description;
  String? image;
  String? data;
  String? author;

  response({this.id, this.description, this.image, this.data, this.author});

  // response.fromJson(Map<String, dynamic> json) {
  //   id = json['_id'];
  //   description = json['description'];
  //   image = json['image'];
  //   data = json['data'];
  //   author = json['author'];
  // }
}

import 'dart:typed_data';

class Blog {
  final int? id;
  final String authorName;
  final String title;
  final String desc;
  final Uint8List picture;

  Blog(
      {this.id,
      required this.authorName,
      required this.title,
      required this.desc, 
      required this.picture});

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
      id: json['id'],
      authorName: json['authorName'],
      title: json['title'],
      desc: json['desc'],
      picture: json['picture']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'authorName': authorName, 'title': title, 'desc': desc, 'picture': picture};
}

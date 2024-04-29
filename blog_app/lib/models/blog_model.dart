import 'dart:typed_data';

// creating blog model class
class Blog {
  final int? id;
  final String authorName;
  final String title;
  final String desc;
  final String dateCreated;
  final String lastUpdated;
  final Uint8List picture; //image is stored as blob in database

// declaring constructor
  Blog(
      {this.id,
      required this.authorName,
      required this.title,
      required this.desc,
      required this.dateCreated,
      required this.lastUpdated,
      required this.picture});

//parsing from JSON to model
  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
      id: json['id'],
      authorName: json['authorName'],
      title: json['title'],
      desc: json['desc'],
      dateCreated: json['dateCreated'] as String,
      lastUpdated: json['lastUpdated'] as String,
      picture: json['picture']);
      
//parsing from model to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'authorName': authorName,
        'title': title,
        'desc': desc,
        'dateCreated': dateCreated,
        'lastUpdated': lastUpdated,
        'picture': picture
      };
}

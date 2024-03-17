class Blog {
  final int? id;
  final String authorName;
  final String title;
  final String desc;

  Blog(
      {this.id,
      required this.authorName,
      required this.title,
      required this.desc});

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
      id: json['id'],
      authorName: json['authorName'],
      title: json['title'],
      desc: json['desc']);

  Map<String, dynamic> toJson() =>
      {'id': id, 'authorName': authorName, 'title': title, 'desc': desc};
}

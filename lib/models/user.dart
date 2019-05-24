class User {
  int id;
  String username;
  int createdAt;
  int updatedAt;

  User({this.id, this.username, this.createdAt, this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }
}
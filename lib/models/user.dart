class User {
  int id;
  String username;
  String token;
  String profileUrl;

  User({this.id, this.username, this.profileUrl, this.token});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    token = json['token'];
    profileUrl = json['url'];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "id": id,
      "username": username,
      "token": token,
      "url": profileUrl
    };
  }
}

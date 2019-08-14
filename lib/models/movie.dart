
class Movie {
  int id;
  String name;
  int year;
  String director;
  String mainStar;
  String description;
  String thumbnail;
  List<String> gentres;
  int createdAt;
  int updatedAt;
  bool isFavorite;
  Movie(
      {this.id,
      this.name,
      this.year,
      this.director,
      this.mainStar,
      this.description,
      this.thumbnail,
      this.gentres,
      this.createdAt,
      this.isFavorite,
      this.updatedAt});

  Movie.fromJson(Map<String, dynamic> json, bool isFavoriteMovie) {
    id = json['id'];
    name = json['name'];
    year = json['year'];
    director = json['director'];
    mainStar = json['main_star'];
    description = json['description'];
    thumbnail = json['thumbnail']['url'];
    gentres = json['genres'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isFavorite = isFavoriteMovie;
  }
}

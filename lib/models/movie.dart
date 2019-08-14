class Movie {
  int id;
  String name;
  String year;
  String director;
  String mainStar;
  String description;
  String thumbnail;
  List<String> gentres;
  List<String> favotiteUsernames;
  bool isFavorite;

  Movie({
    this.id,
    this.name,
    this.year,
    this.director,
    this.mainStar,
    this.description,
    this.thumbnail,
    this.gentres,
    this.favotiteUsernames,
    this.isFavorite,
  });

  Movie.fromJson(Map<String, dynamic> json, String userName) {
    id = json['id'];
    name = json['name'];
    year = json['year'];
    director = json['director'];
    mainStar = json['main_star'];
    description = json['description'];
    thumbnail =
        json.containsKey('thumbnail') ? "http://${json['thumbnail']}" : null;
    gentres = json['genres'].cast<String>();
    favotiteUsernames = json['favorite_usernames'].cast<String>();
    isFavorite = favotiteUsernames.contains(userName);
  }
}

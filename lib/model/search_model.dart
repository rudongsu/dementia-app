// search model
class SearchModel{
  final List<SearchItem> results;
  final String baseUri;
  final int number;

  SearchModel({this.results, this.baseUri, this.number});

  factory SearchModel.fromJson(Map<String, dynamic> json){
    var dataJson = json['results'] as List;
    List<SearchItem> results =
      dataJson.map((i) => SearchItem.fromJson(i)).toList();
    return SearchModel(
      results: results,
      baseUri: json['baseUri'],
      number: json['number'],
    );
  }
}

class SearchItem {
  final int id;
  final String title;
  final int readyInMinutes;
  final int servings;
  final String image;
  final List<String> imageUrls;

  SearchItem(
      {this.id,
        this.title,
        this.readyInMinutes,
        this.servings,
        this.image,
        this.imageUrls});

  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
      id : json['id'],
      title : json['title'],
      readyInMinutes : json['readyInMinutes'],
      servings : json['servings'],
      image : json['image'],
      imageUrls : json['imageUrls'].cast<String>(),
    );
  }
}


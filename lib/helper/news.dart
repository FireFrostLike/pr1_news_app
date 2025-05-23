import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pr1_news_app/models/article_model.dart';
import 'package:http/http.dart' as http;

import '../data/local_storage.dart';

class News {
  List<ArticleModel> news = [];

  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String language = GetIt.I<LocalStorage>().getLocale();

  Future<void> getNews(int page) async {
    Uri url = Uri(
        scheme: "https",
        host: "newsapi.org",
        path: "/v2/everything",
        queryParameters: {
          "q": "tesla",
          "language": language,
          "sortBy": "publishedAt",
          "pageSize": "5",
          "page": "$page",
          "apiKey": "8e1768b78d80489e917a26e4b1a46778",
        });

    var response = await http.get(url);

    var jsonData = jsonDecode(response.body);

    if (jsonData["status"] == "ok") {
      jsonData["articles"].forEach((element) {
        if (element["urlToImage"] != null && element["description"] != null) {
          ArticleModel articleModel = ArticleModel(
            author: element["author"],
            title: element["title"],
            description: element["description"],
            url: element["url"],
            urlToImage: element["urlToImage"],
            content: element["content"],
          );

          news.add(articleModel);
        }
      });
    }
  }
}

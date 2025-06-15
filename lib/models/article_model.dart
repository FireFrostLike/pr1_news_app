import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class ArticleModel extends Equatable {
  final int id;
  final String? author;
  final String title;
  final String description;
  final String url;
  final String urlToImage;
  final String content;

  const ArticleModel({
    this.id = 0,
    this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.urlToImage,
    required this.content,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    try {
      return ArticleModel(
        id: json["id"],
        author: json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        content: json["content"],
      );
    } catch (e) {
      debugPrint('Error during parsing my medicine model: $e');
      return ArticleModel(
        id: 0,
        author: "Error author",
        title: "Error title",
        description: "Error description",
        url: "Error url",
        urlToImage: "Error urlToImage",
        content: "Error content",
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'content': content,
    };
  }

  @override
  List<Object> get props => [
        id,
        author ?? "",
        title,
        description,
        url,
        urlToImage,
        content,
      ];
}

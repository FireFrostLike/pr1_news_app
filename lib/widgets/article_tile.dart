import 'package:flutter/material.dart';
import 'package:pr1_news_app/models/article_model.dart';

class ArticleTile extends StatelessWidget {
  final ArticleModel articleInfo;

  final Function? onLongPress;

  const ArticleTile({
    super.key,
    required this.articleInfo,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        "/article",
        arguments: {
          "articleInfo": articleInfo,
        },
      ),
      onLongPress: onLongPress != null ? () => onLongPress!() : null,
      child: Column(children: [
        Container(
          height: 200,
          width: double.maxFinite,
          color: theme.colorScheme.surfaceContainer,
          child: Image.network(
            articleInfo.urlToImage,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(),
              );
            },
            errorBuilder: (context, error, stackTrace) =>
                Icon(Icons.image_not_supported),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                articleInfo.title,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (articleInfo.description.isNotEmpty)
                Text(articleInfo.description, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ]),
    );
  }
}

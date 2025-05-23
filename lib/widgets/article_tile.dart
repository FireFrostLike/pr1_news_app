import 'package:flutter/material.dart';

class ArticleTile extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String description;
  final String url;

  const ArticleTile({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        "/article",
        arguments: {
          "imageUrl": imageUrl,
          "title": title,
          "description": description,
          "url": url,
        },
      ),
      child: Column(children: [
        Container(
          height: 200,
          width: double.maxFinite,
          color: theme.colorScheme.surfaceContainer,
          child: Image.network(
            imageUrl,
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
          padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (description.isNotEmpty)
                Text(description, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ]),
    );
  }
}

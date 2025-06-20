import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/l10n.dart';
import '../models/article_model.dart';

class ArticleScreen extends StatelessWidget {
  const ArticleScreen({super.key});

  _launchURL(String url) async {
    final Uri parsedUrl = Uri.parse(url);
    await launchUrl(parsedUrl);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map;

    final ArticleModel articleInfo = arguments["articleInfo"];

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).article,
          ),
          foregroundColor: theme.colorScheme.surface,
          backgroundColor: theme.colorScheme.primary,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _launchURL(articleInfo.url),
          label: Text(S.of(context).openInBrowser),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              width: double.maxFinite,
              color: theme.colorScheme.surfaceContainer,
              child: Image.network(
                articleInfo.urlToImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              child: Column(
                children: [
                  Text(
                    articleInfo.title,
                    style: theme.textTheme.headlineSmall,
                  ),
                  Text(
                    articleInfo.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

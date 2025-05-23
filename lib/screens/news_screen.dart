import 'package:flutter/material.dart';
import 'package:pr1_news_app/models/article_model.dart';
import 'package:pr1_news_app/widgets/article_tile.dart';

import '../generated/l10n.dart';
import '../helper/news.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<ArticleModel> articles = [];

  bool loading = true;

  int page = 1;

  getNews(int page) async {
    loading = true;

    News news = News();
    await news.getNews(page);
    articles = news.news;

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    getNews(page);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).news,
          ),
          foregroundColor: theme.colorScheme.surface,
          backgroundColor: theme.colorScheme.primary,
          actions: [
            IconButton(
              onPressed: () => getNews(page),
              icon: Icon(
                Icons.refresh,
              ),
            ),
            IconButton(
              onPressed: () => Navigator.pushNamed(context, "/settigns"),
              icon: Icon(
                Icons.settings,
              ),
            )
          ],
        ),
        bottomNavigationBar: ColoredBox(
          color: theme.colorScheme.surfaceContainer,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => setState(
                    () {
                      if (page > 1) {
                        page -= 1;
                        getNews(page);
                      }
                    },
                  ),
                  icon: Icon(Icons.arrow_back),
                ),
                Text(
                  "$page",
                  style: theme.textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => setState(() {
                    page += 1;
                    getNews(page);
                  }),
                  icon: Icon(Icons.arrow_forward),
                )
              ],
            ),
          ),
        ),
        body: loading
            ? Container(
                alignment: Alignment.center,
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: articles.length,
                itemBuilder: (context, index) {
                  return ArticleTile(
                    imageUrl: articles[index].urlToImage,
                    title: articles[index].title,
                    description: articles[index].description,
                    url: articles[index].url,
                  );
                },
              ),
      ),
    );
  }
}

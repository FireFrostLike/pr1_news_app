import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pr1_news_app/data/local_storage.dart';
import 'package:pr1_news_app/models/article_model.dart';
import 'package:pr1_news_app/widgets/article_tile.dart';

import '../generated/l10n.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<ArticleModel> articles = [];

  @override
  void initState() {
    articles = GetIt.I<LocalStorage>().getFavoritesList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            S.of(context).favorites,
          ),
          foregroundColor: theme.colorScheme.surface,
          backgroundColor: theme.colorScheme.primary,
        ),
        body: ListView.builder(
          itemCount: articles.length,
          itemBuilder: (context, index) {
            return ArticleTile(
                articleInfo: articles[index],
                onLongPress: () {
                  showModalBottomSheet(
                      context: context,
                      showDragHandle: true,
                      builder: (context) {
                        return Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            spacing: 8,
                            children: [
                              Text(
                                S
                                    .of(context)
                                    .doYouWantToDeleteANewsItemFromYour,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 32),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all(
                                  Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                )),
                                onPressed: () {
                                  setState(() {
                                    GetIt.I<LocalStorage>()
                                        .deleteFromFavoritesList(
                                            articles[index].id);

                                    Navigator.pop(context);

                                    articles = GetIt.I<LocalStorage>()
                                        .getFavoritesList();
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 32, vertical: 8),
                                  child: Text(S.of(context).delete,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge),
                                ),
                              ),
                              const SizedBox(height: 32),
                            ],
                          ),
                        );
                      });
                });
          },
        ),
      ),
    );
  }
}

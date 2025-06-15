import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pr1_news_app/models/article_model.dart';

abstract class SettingsStorage {
  Future<void> put(String key, dynamic value);
  dynamic get(String key);
  Future<void> delete(String key);
}

class HiveSettingsStorage implements SettingsStorage {
  final Box _box;

  HiveSettingsStorage(this._box);

  @override
  Future<void> put(String key, dynamic value) async {
    await _box.put(key, value);
  }

  @override
  dynamic get(String key) => _box.get(key);

  @override
  Future<void> delete(String key) async {
    await _box.delete(key);
  }
}

Future<void> settingsInit() async {
  late SettingsStorage settingsStorage;

  await Hive.initFlutter();
  final box = await Hive.openBox(
    'Settings',
  );
  settingsStorage = HiveSettingsStorage(box);

  GetIt.I.registerSingleton<SettingsStorage>(settingsStorage);

  await settingsStorage.put(
      'isLightTheme', settingsStorage.get('isLightTheme') ?? true);
  await settingsStorage.put('locale', settingsStorage.get('locale') ?? 'ru');
  await settingsStorage.put('favoritesList', settingsStorage.get('favoritesList') ?? '');
}

class LocalStorage extends ValueNotifier {
  late final SettingsStorage _storage;
  final ValueNotifier<bool> _themeNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<String> _languageNotifier = ValueNotifier<String>("en");

  LocalStorage(super._value) {
    _storage = GetIt.I<SettingsStorage>();

    //Language
    _languageNotifier.value = _storage.get("locale") ?? "ru";

    //Theme
    bool isLightTheme = _storage.get("isLightTheme") == "true";
    _themeNotifier.value = isLightTheme;
  }

  ValueListenable<String> languageListenable() {
    return _languageNotifier;
  }

  ValueListenable<bool> themeListenable() {
    return _themeNotifier;
  }

  void saveBoolTheme(bool value) {
    _themeNotifier.value = value;
    _storage.put("isLightTheme", value.toString());
  }

  bool getBoolTheme() {
    bool isLightTheme = _storage.get("isLightTheme") == "true";
    return isLightTheme;
  }

  Future<void> saveLocale(String locale) async {
    _languageNotifier.value = locale;
    await _storage.put("locale", locale);
  }

  String getLocale() {
    var locale = _storage.get("locale");
    if (locale == null || locale == "") {
      return "ru";
    } else {
      return locale;
    }
  }

  void addToFavoritesList(ArticleModel article) {
    var myMedicineList = getFavoritesList();

    ArticleModel newFavorite = ArticleModel(
      id: myMedicineList.isNotEmpty ? myMedicineList.last.id + 1 : 1,
      title: article.title,
      description: article.description,
      url: article.url,
      urlToImage: article.urlToImage,
      content: article.content,
    );

    myMedicineList.add(newFavorite);

    saveFavoritesList(myMedicineList);
  }

  void deleteFromFavoritesList(int id) {
    List<ArticleModel> favoritesList = getFavoritesList();

    ArticleModel? foundedElement =
        favoritesList.where((e) => e.id == id).firstOrNull;

    if (foundedElement != null) {
      favoritesList.remove(foundedElement);

      saveFavoritesList(favoritesList);
    }
  }

  void saveFavoritesList(List<ArticleModel> newValue) {
    String json = jsonEncode(newValue);

    _storage.put("favoritesList", json);
  }

  List<ArticleModel> getFavoritesList() {
    String json = _storage.get("favoritesList");

    List<ArticleModel> favoritesList = [];

    try {
      List<dynamic> favoritesListDynamic = jsonDecode(json);
      for (var element in favoritesListDynamic) {
        favoritesList.add(ArticleModel.fromJson(element));
      }
    } catch (e) {
      favoritesList = List<ArticleModel>.empty(growable: true);
    }

    return favoritesList;
  }
}

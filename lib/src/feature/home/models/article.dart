import 'package:faker_dart/faker_dart.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';

part 'article.g.dart';

enum AgeCategory {
  @JsonValue('from0to0.5')
  halfYear,
  @JsonValue('from0.5to1')
  year,
  @JsonValue('from1to2')
  twoYear,
  @JsonValue('from2to')
  older,
}

@JsonSerializable()
class ArticleModel extends _ArticleModel with _$ArticleModel {
  @JsonKey(name: 'id')
  final String? id;

  final String? title;

  @JsonKey(fromJson: _extractPhotoUrls)
  final List<String?>? images;

  static List<String?>? _extractPhotoUrls(List? images) {
    if (images == null) return null;

    return images.map((e) => e['photo_url'] as String?).toList();
  }

  final String? category;

  final String? file;

  @JsonKey(name: 'photo_url')
  final String? photo;

  final List<String>? tags;

  @JsonKey(name: 'account')
  final AccountModel? author;

  @JsonKey(name: 'body')
  final List<NativeArticle>? articles;

  @JsonKey(name: 'count_articles_author')
  final int? countArticlesAuthor;

  @JsonKey(name: 'age_category')
  List<AgeCategory?>? ageCategory;

  ArticleModel({
    this.id,
    this.title,
    this.category,
    this.file,
    this.photo,
    this.tags,
    this.images,
    this.author,
    this.articles,
    this.ageCategory,
    this.countArticlesAuthor,
    super.updatedAt,
    super.createdAt,
    super.isFavorite = false,
  });

  factory ArticleModel.mock(Faker faker) {
    return ArticleModel(
      id: faker.datatype.uuid(),
      title: faker.lorem.word(),
      category: faker.lorem.word(),
      photo: faker.image.image(),
      author: AccountModel.mock(faker),
      ageCategory: List.generate(
          faker.datatype.number(max: 5),
          (_) => AgeCategory.values[
              faker.datatype.number(max: AgeCategory.values.length - 1)]),
    );
  }

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}

abstract class _ArticleModel extends BaseModel with Store {
  _ArticleModel({
    super.updatedAt,
    super.createdAt,
    this.isFavorite = false,
  });

  @observable
  @JsonKey(name: 'is_favorite')
  bool? isFavorite;

  @action
  void setFavorite(bool v) => isFavorite = v;
}

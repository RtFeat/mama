import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

part 'favorite_article.g.dart';

@JsonSerializable()
class FavoriteArticle extends SkitBaseModel {
  final String? id;
  final String? title;
  final String? author;
  @JsonKey(name: 'author_profession')
  final String? profession;
  @JsonKey(name: 'author_avatar')
  final String? avatarUrl;

  final String? category;

  @JsonKey(name: 'age_category')
  List<AgeCategory?>? ageCategory;

  @JsonKey(name: 'article_photo')
  final String? articlePhotoUrl;

  FavoriteArticle({
    this.id,
    this.title,
    this.author,
    this.profession,
    this.avatarUrl,
    this.category,
    this.ageCategory,
    this.articlePhotoUrl,
  });

  factory FavoriteArticle.fromJson(Map<String, dynamic> json) =>
      _$FavoriteArticleFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$FavoriteArticleToJson(this);
}

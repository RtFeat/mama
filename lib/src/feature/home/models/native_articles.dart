import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'native_articles.g.dart';

@JsonSerializable()
class NativeArticles {
  @JsonKey(name: 'body')
  final List<NativeArticle>? articles;

  NativeArticles({this.articles});

  factory NativeArticles.fromJson(Map<String, dynamic> json) =>
      _$NativeArticlesFromJson(json);

  Map<String, dynamic> toJson() => _$NativeArticlesToJson(this);
}

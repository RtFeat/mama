import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:skit/skit.dart';

part 'articles.g.dart';

@JsonSerializable()
class ArticlesData extends SkitBaseModel {
  final List<ArticleModel>? articles;

  ArticlesData({this.articles});

  factory ArticlesData.fromJson(Map<String, dynamic> json) =>
      _$ArticlesDataFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$ArticlesDataToJson(this);
}

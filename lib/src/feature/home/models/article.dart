import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';

part 'article.g.dart';

@JsonSerializable()
class ArticleModel extends BaseModel {
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

  @JsonKey(name: 'photo_id')
  final String? photo;

  final List<String>? tags;

  ArticleModel({
    this.id,
    this.title,
    this.category,
    this.file,
    this.photo,
    this.tags,
    this.images,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ArticleModelToJson(this);
}

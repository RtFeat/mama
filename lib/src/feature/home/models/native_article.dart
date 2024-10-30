import 'package:json_annotation/json_annotation.dart';

part 'native_article.g.dart';

enum NativeArticleType {
  @JsonValue('image')
  image,
  @JsonValue('text')
  text,
}

@JsonSerializable()
class NativeArticle {
  @JsonKey(name: 'payload')
  final String? data;

  @JsonKey(name: 'type')
  final NativeArticleType type;

  NativeArticle({
    required this.data,
    required this.type,
  });

  factory NativeArticle.fromJson(Map<String, dynamic> json) =>
      _$NativeArticleFromJson(json);

  Map<String, dynamic> toJson() => _$NativeArticleToJson(this);
}

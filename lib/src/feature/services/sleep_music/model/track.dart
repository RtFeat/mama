import 'package:audioplayers/audioplayers.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'track.g.dart';

@JsonSerializable()
class TrackModel extends _TrackModel with _$TrackModel {
  @JsonKey(name: 'name')
  final String id;

  final String title;

  final String description;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? author;

  final double duration;

  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  Source? get source => UrlSource('${const Config().apiUrl}music/$id');

  TrackModel({
    required this.id,
    required this.title,
    required this.description,
    this.author,
    required this.duration,
    required this.createdAt,
  });

  factory TrackModel.fromJson(Map<String, dynamic> json) =>
      _$TrackModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrackModelToJson(this);
}

abstract class _TrackModel with Store {
  @observable
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isPlaying = false;

  @action
  void toggleIsPlaying() => isPlaying = !isPlaying;
}

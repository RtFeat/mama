import 'package:json_annotation/json_annotation.dart';

part 'message_file.g.dart';

@JsonSerializable()
class MessageFile {
  @JsonKey(name: 'file_path')
  final String? fileUrl;

  final String? filename;

  @JsonKey(name: 'type_file')
  final String? typeFile;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? filePath;

  MessageFile({
    this.fileUrl,
    this.filename,
    this.typeFile,
    this.filePath,
  });

  factory MessageFile.fromJson(Map<String, dynamic> json) =>
      _$MessageFileFromJson(json);

  Map<String, dynamic> toJson() => _$MessageFileToJson(this);
}

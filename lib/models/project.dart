import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Matches the existing ProjectSerializer rather than the PDF's sample schema.
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    this.id,
    required this.title,
    required this.projectType,
    required this.role,
    required this.description,
    required this.technologies,
    required this.liveUrl,
    this.thumbnailPath = '',
    this.sourceUrl = '',
    this.displayOrder = 0,
    this.starCount = 0,
    this.isStarred = false,
  });

  @JsonKey(includeToJson: false)
  final String? id;
  final String title;
  final String projectType;
  final String role;
  final String description;
  final String technologies;
  final String liveUrl;
  @JsonKey(defaultValue: '')
  final String thumbnailPath;
  @JsonKey(defaultValue: '')
  final String sourceUrl;
  final int displayOrder;
  @JsonKey(includeToJson: false, defaultValue: 0)
  final int starCount;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isStarred;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}

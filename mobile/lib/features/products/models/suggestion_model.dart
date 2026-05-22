import 'package:freezed_annotation/freezed_annotation.dart';

part 'suggestion_model.freezed.dart';
part 'suggestion_model.g.dart';

@freezed
class SuggestionModel with _$SuggestionModel {
  const factory SuggestionModel({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String category,
    String? description,
    @Default(0) double price,
    required String companyName,
    required String status,
    SuggestedByInfo? suggestedBy,
  }) = _SuggestionModel;

  factory SuggestionModel.fromJson(Map<String, dynamic> json) => _$SuggestionModelFromJson(json);
}

@freezed
class SuggestedByInfo with _$SuggestedByInfo {
  const factory SuggestedByInfo({
    @JsonKey(name: '_id') required String id,
    required String phone,
    required String role,
  }) = _SuggestedByInfo;

  factory SuggestedByInfo.fromJson(Map<String, dynamic> json) => _$SuggestedByInfoFromJson(json);
}

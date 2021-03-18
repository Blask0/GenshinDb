import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_element_file.freezed.dart';

@freezed
abstract class TranslationElementFile implements _$TranslationElementFile {
  factory TranslationElementFile({
    required String key,
    required String name,
    required String effect,
    String? description,
  }) = _TranslationElementFile;

  const TranslationElementFile._();

  factory TranslationElementFile.fromJson(Map<String, dynamic> json) => _$TranslationElementFileFromJson(json);
}

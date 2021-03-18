import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'character_file_model.dart';

part 'characters_file.freezed.dart';

@freezed
abstract class CharactersFile implements _$CharactersFile {
  factory CharactersFile({
    required List<CharacterFileModel> characters,
  }) = _CharactersFile;

  factory CharactersFile.fromJson(Map<String, dynamic> json) => _$CharactersFileFromJson(json);
}

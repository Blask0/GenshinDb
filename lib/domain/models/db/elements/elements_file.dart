import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models.dart';

part 'elements_file.freezed.dart';

@freezed
abstract class ElementsFile implements _$ElementsFile {
  factory ElementsFile({
    required List<ElementDebuffFileModel> debuffs,
    required List<ElementReactionFileModel> reactions,
    required List<ElementReactionFileModel> resonance,
  }) = _ElementsFile;

  ElementsFile._();

  factory ElementsFile.fromJson(Map<String, dynamic> json) => _$ElementsFileFromJson(json);
}

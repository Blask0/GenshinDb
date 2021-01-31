part of 'settings_bloc.dart';

@freezed
abstract class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.init() = _Init;
  const factory SettingsEvent.themeChanged({
    @required AppThemeType newValue,
  }) = _ThemeChanged;

  const factory SettingsEvent.accentColorChanged({
    @required AppAccentColorType newValue,
  }) = _AccentColorChanged;

  const factory SettingsEvent.languageChanged({
    @required AppLanguageType newValue,
  }) = _LanguageChanged;

  const factory SettingsEvent.showCharacterDetailsChanged({
    @required bool newValue,
  }) = _ShowCharacterDetailsChanged;

  const factory SettingsEvent.showWeaponDetailsChanged({
    @required bool newValue,
  }) = _ShowWeaponDetailsChanged;
}

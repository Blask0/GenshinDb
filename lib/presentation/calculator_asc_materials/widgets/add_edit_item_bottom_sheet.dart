import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:genshindb/application/bloc.dart';
import 'package:genshindb/domain/extensions/iterable_extensions.dart';
import 'package:genshindb/domain/models/models.dart';
import 'package:genshindb/generated/l10n.dart';
import 'package:genshindb/presentation/shared/common_bottom_sheet.dart';
import 'package:genshindb/presentation/shared/loading.dart';
import 'package:numberpicker/numberpicker.dart';

import 'ascension_level.dart';
import 'skill_item.dart';

class AddEditItemBottomSheet extends StatelessWidget {
  final int index;
  final String keyName;
  final bool isInEditMode;
  final bool isAWeapon;
  final bool isActive;

  const AddEditItemBottomSheet.toAddItem({
    Key key,
    @required this.keyName,
    @required this.isAWeapon,
  })  : index = null,
        isInEditMode = false,
        isActive = true,
        super(key: key);

  const AddEditItemBottomSheet.toEditItem({
    Key key,
    @required this.index,
    @required this.isAWeapon,
    @required this.isActive,
  })  : keyName = null,
        isInEditMode = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final theme = Theme.of(context);
    return BlocBuilder<CalculatorAscMaterialsItemBloc, CalculatorAscMaterialsItemState>(
      builder: (context, state) => state.map(
        loading: (_) => const Loading(),
        loaded: (state) => CommonBottomSheet(
          title: isAWeapon ? '${s.weapon}: ${state.name}' : '${s.character}: ${state.name}',
          titleIcon: !isInEditMode ? Icons.add : Icons.edit,
          iconSize: 40,
          showCancelButton: false,
          showOkButton: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                s.level,
                textAlign: TextAlign.center,
                style: theme.textTheme.subtitle2.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlineButton(
                    onPressed: () => _showLevelPickerDialog(context, state.currentLevel, true),
                    child: Text(s.currentX(state.currentLevel)),
                  ),
                  OutlineButton(
                    onPressed: () => _showLevelPickerDialog(context, state.desiredLevel, false),
                    child: Text(s.desiredX(state.desiredLevel)),
                  ),
                ],
              ),
              Text(s.currentAscension, textAlign: TextAlign.center, style: theme.textTheme.subtitle2),
              AscensionLevel(isCurrentLevel: true, level: state.currentAscensionLevel),
              Text(s.desiredAscension, textAlign: TextAlign.center, style: theme.textTheme.subtitle2),
              AscensionLevel(isCurrentLevel: false, level: state.desiredAscensionLevel),
              ...state.skills
                  .mapIndex((e, index) => SkillItem(
                        index: index,
                        name: e.name,
                        currentLevel: e.currentLevel,
                        desiredLevel: e.desiredLevel,
                        isCurrentDecEnabled: e.isCurrentDecEnabled,
                        isCurrentIncEnabled: e.isCurrentIncEnabled,
                        isDesiredDecEnabled: e.isDesiredDecEnabled,
                        isDesiredIncEnabled: e.isDesiredIncEnabled,
                      ))
                  .toList(),
              ButtonBar(
                buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                children: <Widget>[
                  OutlineButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(s.cancel, style: TextStyle(color: theme.primaryColor)),
                  ),
                  if (isInEditMode)
                    OutlineButton(
                      onPressed: () => isAWeapon
                          ? _applyChangesForWeapon(
                              state.currentLevel,
                              state.desiredLevel,
                              state.currentAscensionLevel,
                              state.desiredAscensionLevel,
                              context,
                              isActiveChanged: true,
                            )
                          : _applyChangesForCharacter(
                              state.currentLevel,
                              state.desiredLevel,
                              state.currentAscensionLevel,
                              state.desiredAscensionLevel,
                              state.skills,
                              context,
                              isActiveChanged: true,
                            ),
                      child: Text(isActive ? s.inactive : s.active, style: TextStyle(color: theme.primaryColor)),
                    ),
                  RaisedButton(
                    color: theme.primaryColor,
                    onPressed: () => isAWeapon
                        ? _applyChangesForWeapon(
                            state.currentLevel, state.desiredLevel, state.currentAscensionLevel, state.desiredAscensionLevel, context)
                        : _applyChangesForCharacter(
                            state.currentLevel,
                            state.desiredLevel,
                            state.currentAscensionLevel,
                            state.desiredAscensionLevel,
                            state.skills,
                            context,
                          ),
                    child: Text(s.ok),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showLevelPickerDialog(BuildContext context, int value, bool forCurrentLevel) async {
    final theme = Theme.of(context);
    final s = S.of(context);
    final newValue = await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return NumberPickerDialog.integer(
          minValue: CalculatorAscMaterialsItemBloc.minItemLevel,
          maxValue: CalculatorAscMaterialsItemBloc.maxItemLevel,
          title: Text(s.chooseALevel),
          initialIntegerValue: value,
          infiniteLoop: true,
          cancelWidget: Text(s.cancel),
          confirmWidget: Text(s.ok, style: TextStyle(color: theme.primaryColor)),
        );
      },
    );

    if (newValue == null) {
      return;
    }

    final event = forCurrentLevel
        ? CalculatorAscMaterialsItemEvent.currentLevelChanged(newValue: newValue)
        : CalculatorAscMaterialsItemEvent.desiredLevelChanged(newValue: newValue);
    context.read<CalculatorAscMaterialsItemBloc>().add(event);
  }

  void _applyChangesForWeapon(
    int currentLevel,
    int desiredLevel,
    int currentAscensionLevel,
    int desiredAscensionLevel,
    BuildContext context, {
    bool isActiveChanged = false,
  }) {
    final event = !isInEditMode
        ? CalculatorAscMaterialsEvent.addWeapon(
            key: keyName,
            currentLevel: currentLevel,
            desiredLevel: desiredLevel,
            currentAscensionLevel: currentAscensionLevel,
            desiredAscensionLevel: desiredAscensionLevel,
          )
        : CalculatorAscMaterialsEvent.updateWeapon(
            index: index,
            currentLevel: currentLevel,
            desiredLevel: desiredLevel,
            currentAscensionLevel: currentAscensionLevel,
            desiredAscensionLevel: desiredAscensionLevel,
            isActive: isActiveChanged ? !isActive : isActive,
          );
    context.read<CalculatorAscMaterialsBloc>().add(event);
    Navigator.of(context).pop();
  }

  void _applyChangesForCharacter(
    int currentLevel,
    int desiredLevel,
    int currentAscensionLevel,
    int desiredAscensionLevel,
    List<CharacterSkill> skills,
    BuildContext context, {
    bool isActiveChanged = false,
  }) {
    final event = !isInEditMode
        ? CalculatorAscMaterialsEvent.addCharacter(
            key: keyName,
            currentLevel: currentLevel,
            desiredLevel: desiredLevel,
            skills: skills,
            currentAscensionLevel: currentAscensionLevel,
            desiredAscensionLevel: desiredAscensionLevel,
          )
        : CalculatorAscMaterialsEvent.updateCharacter(
            index: index,
            currentLevel: currentLevel,
            desiredLevel: desiredLevel,
            skills: skills,
            currentAscensionLevel: currentAscensionLevel,
            desiredAscensionLevel: desiredAscensionLevel,
            isActive: isActiveChanged ? !isActive : isActive,
          );
    context.read<CalculatorAscMaterialsBloc>().add(event);
    Navigator.of(context).pop();
  }
}

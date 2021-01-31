import 'package:flutter/material.dart';
import 'package:genshindb/domain/models/models.dart';
import 'package:genshindb/generated/l10n.dart';
import 'package:genshindb/presentation/shared/item_description_detail.dart';
import 'package:genshindb/presentation/shared/styles.dart';

class WeaponDetailRefinementsCard extends StatelessWidget {
  final Color rarityColor;
  final List<WeaponFileRefinementModel> refinements;

  const WeaponDetailRefinementsCard({
    Key key,
    @required this.rarityColor,
    @required this.refinements,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final rows = refinements
        .map(
          (e) => TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: Styles.edgeInsetAll10,
                  child: Center(child: Text('${e.level}')),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Center(
                  child: Padding(
                    padding: Styles.edgeInsetVertical5,
                    child: Center(child: Text(e.description)),
                  ),
                ),
              ),
            ],
          ),
        )
        .toList();

    final body = Card(
      elevation: Styles.cardTenElevation,
      shape: Styles.cardShape,
      margin: Styles.edgeInsetAll5,
      child: Table(
        columnWidths: const {
          0: FractionColumnWidth(.2),
          1: FractionColumnWidth(.8),
        },
        children: [
          TableRow(
            children: [
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: Styles.edgeInsetAll10,
                  child: Center(child: Text(s.level)),
                ),
              ),
              TableCell(
                verticalAlignment: TableCellVerticalAlignment.middle,
                child: Padding(
                  padding: Styles.edgeInsetAll10,
                  child: Center(child: Text(s.description)),
                ),
              ),
            ],
          ),
          ...rows,
        ],
      ),
    );

    return ItemDescriptionDetail(title: s.refinements, body: body, textColor: rarityColor);
  }
}

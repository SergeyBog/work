import 'package:agent_app/models/domain/bonus_entity.dart';
import 'package:agent_app/providers/home_provider.dart';
import 'package:agent_app/services/navigation_service.dart';
import 'package:agent_app/ui/home_page/monthly_bonus/monthly_bonus_page.dart';
import 'package:agent_app/ui/home_page/widgets/diagram_widget.dart';
import 'package:agent_app/utils/l10n.dart';
import 'package:agent_app/utils/themes/style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BonusDiagram extends StatefulWidget {
  final List<BonusEntity> bonusList;

  const BonusDiagram({Key? key, required this.bonusList}) : super(key: key);

  @override
  State<BonusDiagram> createState() => _BonusDiagramState();
}

class _BonusDiagramState extends State<BonusDiagram> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 235,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).highlightColor),
        child: Column(
          children: [
            _title(context),
            const SizedBox(
              height: 24,
            ),
            DiagramWidget(bonusList: widget.bonusList)
          ],
        ),
      ),
    );
  }

  Widget _title(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          l10n(context).bonusHistory,
          style: TextStyle(
              fontSize: 18,
              height: 24 / 18,
              fontFamily: AppFont.tbc700,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).secondaryHeaderColor),
        ),
        if (context.watch<HomeProvider>().hasCurrentBonus)
          Flexible(
            child: GestureDetector(
              onTap: () =>
                  NavigationService().pushWithAnimation(const MonthlyBonus()),
              child: Text(
                l10n(context).viewFullHistory,
                textAlign: TextAlign.end,
                style: TextStyle(
                    fontSize: 12,
                    height: 16 / 12,
                    fontFamily: AppFont.tbc400,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).hoverColor),
              ),
            ),
          ),
      ],
    );
  }
}

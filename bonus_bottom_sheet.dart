import 'package:agent_app/providers/home_provider.dart';
import 'package:agent_app/ui/home_page/monthly_bonus/bonus_item.dart';
import 'package:agent_app/ui/widgets/custom_bottom_sheet.dart';
import 'package:agent_app/utils/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BonusBottomSheet extends StatelessWidget {
  const BonusBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      height: MediaQuery.of(context).size.height * 0.6,
      padding: const EdgeInsets.only(top: 24),
      titleForSheet: l10n(context).bonusHistory,
      child: _historyList(context),
    );
  }

  Widget _historyList(BuildContext context) {
    final provider = context.read<HomeProvider>();
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 4),
        itemBuilder: (context, index) => BonusItem(
          bonusList: provider.diagramData[index],
        ),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: provider.diagramData.length,
      ),
    );
  }
}

import 'package:agent_app/models/domain/monthly_summary.dart';
import 'package:agent_app/ui/widgets/custom_%20progress_bar.dart';
import 'package:flutter/material.dart';
import '../../../services/navigation_service.dart';
import '../../../utils/l10n.dart';
import '../../../utils/themes/style.dart';
import '../../widgets/custom_button.dart';

class SummaryBottomSheet extends StatelessWidget {
  final MonthlySummary? monthlySummary;

  const SummaryBottomSheet({Key? key, required this.monthlySummary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.47,
        padding: const EdgeInsets.only(top: 24, bottom: 48),
        child: Column(
          children: [
            header(context),
            Divider(color: Theme.of(context).selectedRowColor),
            completedBonus(context),
            CustomProgressBar(
                context: context,
                lineHeight: 8,
                percent: ((monthlySummary?.conversionRate ?? 1) / 100)),
            statisticRow(context),
            confirmButton(context)
          ],
        ),
      ),
    );
  }

  Widget header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 8),
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(left: 20),
        child: Text(
          l10n(context).monthlySummary,
          style: TextStyle(
              fontFamily: AppFont.tbc500,
              fontSize: 16,
              color: Theme.of(context).secondaryHeaderColor),
        ),
      ),
    );
  }

  Widget completedBonus(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(top: 16, left: 20, bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n(context).completedBonus,
              style: TextStyle(
                  fontFamily: AppFont.tbc400,
                  fontSize: 14,
                  color: Theme.of(context).hintColor)),
          Padding(
            padding: const EdgeInsets.only(top: 3),
            child: Text(
              '${monthlySummary?.completedBonus ?? ''} ₾',
              style: TextStyle(
                  fontFamily: AppFont.tbc500,
                  fontSize: 14,
                  color: Theme.of(context).secondaryHeaderColor),
            ),
          )
        ],
      ),
    );
  }

  Widget statisticRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          statistic(
              context: context,
              text: l10n(context).insuredPolices,
              amount: monthlySummary?.insuredPolicies.toString() ?? ''),
          statistic(
              context: context,
              text: l10n(context).leadQuantity,
              amount: monthlySummary?.leadQuantity.toString() ?? ''),
          statistic(
              context: context,
              text: l10n(context).conversionRate,
              amount: '${monthlySummary?.conversionRate.toString()} %'),
        ],
      ),
    );
  }

  Widget confirmButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: CustomButton(
        title: l10n(context).gotIt,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderColor: Theme.of(context).primaryColor.withOpacity(0.14),
        textColor: Theme.of(context).primaryColor,
        onPressed: () {
          NavigationService().pop(context);
        },
      ),
    );
  }

  Widget statistic(
      {required BuildContext context,
      required String text,
      required String amount}) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: AppFont.tbc400,
                fontSize: 12,
                color: Theme.of(context).secondaryHeaderColor),
          ),
        ),
        Text(
          amount,
          style: TextStyle(
              fontFamily: AppFont.tbc500,
              fontSize: 16,
              color: Theme.of(context).secondaryHeaderColor),
        ),
      ],
    );
  }
}

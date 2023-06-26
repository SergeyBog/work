import 'package:flutter/material.dart';
import 'package:multioil_mb/providers/notifications_provider.dart';
import 'package:multioil_mb/providers/profile_provider.dart';
import 'package:multioil_mb/services/navigation_service.dart';
import 'package:multioil_mb/ui/balance_page/widgets/action_circle.dart';
import 'package:multioil_mb/ui/balance_page/widgets/balance_card.dart';
import 'package:multioil_mb/ui/filling_card_page/filling_card_page.dart';
import 'package:multioil_mb/ui/filling_card_page/networks_page.dart';
import 'package:multioil_mb/ui/widgets/pop_up_manager.dart';
import 'package:multioil_mb/utils/l10n.dart';
import 'package:provider/provider.dart';
import '../../prices_page/prices_page.dart';

class CardBackground extends StatelessWidget {
  final String balanceSum;

  const CardBackground({Key? key, required this.balanceSum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var notificationProvider =
        Provider.of<NotificationProvider>(context, listen: true);
    return SingleChildScrollView(
      child: Column(
        children: [
          BalanceCard(
            messagesCount: notificationProvider.unreadNotifications,
            balance: balanceSum,
          ),
          _actionRow(context),
        ],
      ),
    );
  }

  Widget _actionRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionCircle(
            onTap: () =>
                PopUpManager().showPopUpBalanceDialog(context: context),
            path: 'assets/icons/pop_up_balance.svg',
            text: l10n(context).popUpBalance,
          ),
          ActionCircle(
            onTap: () => NavigationService().pushWithAnimation(
              //const FillingCardPage(),
              const NetworksPage(),
              speedAnimationDuration: const Duration(milliseconds: 500),
            ),
            path: 'assets/icons/fill_the_car.svg',
            text: l10n(context).fillTheCar,
          ),
          ActionCircle(
            onTap: () => NavigationService().pushWithAnimation(
              const PricePage(),
              speedAnimationDuration: const Duration(milliseconds: 500),
            ),
            path: 'assets/icons/prices.svg',
            text: l10n(context).fuelPrice,
          ),
        ],
      ),
    );
  }
}

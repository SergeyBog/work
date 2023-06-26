import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:multioil_mb/services/navigation_service.dart';
import 'package:multioil_mb/ui/widgets/custom_budge.dart';
import 'package:multioil_mb/utils/l10n.dart';
import 'package:multioil_mb/utils/themes/styles.dart';

import '../../../services/animation_rout_service.dart';
import '../../notification_page/notifications_page.dart';

class BalanceCard extends StatelessWidget {
  final int messagesCount;
  final String balance;

  const BalanceCard(
      {Key? key, required this.messagesCount, required this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18, left: 18, top: 50),
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.cardBackground,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(-3, 6), // changes position of shadow
            ),
          ],
        ),
        width: double.infinity,
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 17),
                  child: SvgPicture.asset('assets/icons/logo.svg'),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 27, top: 27),
                  child: GestureDetector(
                    onTap: () => NavigationService().pushWithAnimation(
                        const NotificationsPage(),
                        direction: AnimationDirection.horizontal,
                        speedAnimationDuration:
                            const Duration(milliseconds: 350)),
                    child: CustomBudge(
                      badgeContent: messagesCount,
                      child: SvgPicture.asset('assets/icons/messages.svg'),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n(context).balance}:',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontSize: 20, color: AppColor.lightGrey),
                  ),
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: balance,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontSize: 40, color: Colors.white),
                          children: [
                            const TextSpan(text: ' '),
                            TextSpan(
                              text: l10n(context).grn,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontSize: 20, color: Colors.white),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

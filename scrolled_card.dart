import 'package:flutter/material.dart';
import 'package:multioil_mb/utils/themes/styles.dart';
import '../../../../../utils/l10n.dart';

class ScrollCard extends StatelessWidget {
  final String balance;
  final bool paddingTop;

  const ScrollCard({Key? key, required this.balance, required this.paddingTop})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.cardBackground,
      child: Padding(
        padding:
            EdgeInsets.only(top: 20 + (paddingTop == true ? 56 : 20), left: 20),
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
    );
  }
}

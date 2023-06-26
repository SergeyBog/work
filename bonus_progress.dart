import 'package:agent_app/utils/l10n.dart';
import 'package:agent_app/utils/themes/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:percent_indicator/percent_indicator.dart';

class BonusProgress extends StatelessWidget {
  final void Function()? onAnimationEnd;
  final double percent;
  final List<int> possibleBonusesValue;
  final List<int> possiblePolicy;
  final int? indexAchievedBonus;
  final bool Function(int) checkAchievedBonus;
  final bool Function(int) showAchievedBonusIcon;
  final String polices;

  const BonusProgress({
    Key? key,
    this.onAnimationEnd,
    required this.percent,
    this.indexAchievedBonus,
    required this.checkAchievedBonus,
    required this.possibleBonusesValue,
    required this.showAchievedBonusIcon,
    required this.polices,
    required this.possiblePolicy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title(context),
        const SizedBox(
          height: 24,
        ),
        _indicator(context)
      ],
    );
  }

  Widget _title(BuildContext context) {
    return Text(
      l10n(context).bonusProgress,
      style: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
          fontSize: 18,
          fontFamily: AppFont.tbc700),
    );
  }

  Widget _indicator(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List<Widget>.generate(
              possibleBonusesValue.length,
              (index) => _completedIcons(context, index: index),
            ),
          ),
        ),
        const SizedBox(height: 12,),
        LinearPercentIndicator(
          padding: EdgeInsets.zero,
          lineHeight: 8,
          percent: percent,
          widgetIndicator: _widgetIndicator(context),
          progressColor: Theme.of(context).primaryColor,
          backgroundColor: Theme.of(context).cardColor,
          barRadius: const Radius.circular(20),
          animation: true,
          animationDuration: 400,
          onAnimationEnd: onAnimationEnd,
          center: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List<Widget>.generate(
              possibleBonusesValue.length,
                  (index) => _indicatorItems(context),
            ),
          ),
        ),
        const SizedBox(height: 16,),
        SizedBox(
          width: MediaQuery.of(context).size.width - 32,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List<Widget>.generate(
              possibleBonusesValue.length,
                  (index) => Flexible(
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _bonusValue(context, index: index),
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _widgetIndicator(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.11), blurRadius: 14)
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        polices,
        style: TextStyle(
            color: Theme.of(context).secondaryHeaderColor,
            fontSize: 12,
            fontFamily: AppFont.tbc500),
      ),
    );
  }

  Widget _indicatorItems(BuildContext context) {
    return Container(
      height: 4,
      width: 4,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 1),
      ),
    );
  }

  Widget _bonusValue(BuildContext context, {required int index}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${possibleBonusesValue[index]}${MediaQuery.of(context).size.width < 360 ? '' : '₾'}',
          textAlign: TextAlign.center,
          textWidthBasis: TextWidthBasis.longestLine,
          style: checkAchievedBonus(index)
              ? Theme.of(context).textTheme.bodyMedium
              : Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).hoverColor),
        ),
        const SizedBox(
          height: 4,
        ),
        Flexible(
          child: Text(
            '${possiblePolicy[index]}${MediaQuery.of(context).size.width < 400 ? '\n' : ' '}${l10n(context).polices}',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        )
      ],
    );
  }

  Widget _completedIcons(BuildContext context, {required int index}) {
    if (showAchievedBonusIcon(index)) {
      return SvgPicture.asset(
        'assets/icon/completed_icon.svg',
        color: checkAchievedBonus(index)
            ? Theme.of(context).toggleableActiveColor
            : Theme.of(context).hintColor,
      );
    }
    return SvgPicture.asset(
      'assets/icon/completed_icon.svg',
      color: Colors.transparent,
    );
  }
}

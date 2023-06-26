import 'package:agent_app/app.dart';
import 'package:agent_app/models/domain/bonus_entity.dart';
import 'package:agent_app/providers/home_provider.dart';
import 'package:agent_app/utils/input_formated.dart';
import 'package:agent_app/utils/themes/style.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DiagramWidget extends StatefulWidget {
  final List<BonusEntity> bonusList;

  const DiagramWidget({Key? key, required this.bonusList}) : super(key: key);

  @override
  State<DiagramWidget> createState() => _DiagramWidgetState();
}

class _DiagramWidgetState extends State<DiagramWidget> {
  final duration = const Duration(milliseconds: 500);
  final int showMonthUntilNow = 4;
  final double paddingUnderDiagram = 2;
  int touchBar = -1;
  bool nowTouchBar = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(
      duration,
      () => setState(() => touchBar = DateTime.now().month),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BarChart(
        BarChartData(
          barTouchData: _barTouchData(context),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(show: false),
          titlesData: _titleData(context),
          maxY: context.read<HomeProvider>().maxBonusMonth,
          minY: 0,
          alignment: BarChartAlignment.spaceEvenly,
          barGroups: _barGroups(context),
        ),
        swapAnimationDuration: duration, // Optional
        swapAnimationCurve: Curves.linear, // Optional
      ),
    );
  }

  FlTitlesData _titleData(BuildContext context) {
    return FlTitlesData(
      bottomTitles: AxisTitles(sideTitles: _bottomTitles),
      leftTitles: AxisTitles(sideTitles: _leftTitles),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
    );
  }

  List<BarChartGroupData> _barGroups(BuildContext context) {
    final startIndexMouth = DateTime.now().month - showMonthUntilNow > 0
        ? DateTime.now().month - showMonthUntilNow
        : 12 - (showMonthUntilNow - DateTime.now().month);
    return List<BarChartGroupData>.generate(showMonthUntilNow + 1, (index) {
      final x = startIndexMouth + index <= 12
          ? startIndexMouth + index
          : (startIndexMouth + index - 12);
      final y = widget.bonusList
          .firstWhere((element) => element.month == x,
              orElse: () => BonusEntity(bonusEarnedForAuto: 0))
          .allBonus
          .toDouble();
      final thisTouchBar = x == touchBar;
      return BarChartGroupData(
        x: x,
        showingTooltipIndicators: thisTouchBar ? [0] : [],
        barRods: [
          BarChartRodData(
            toY: y + paddingUnderDiagram,
            fromY: 1,
            width: 24,
            borderRadius: BorderRadius.circular(6),
            color: Theme.of(context)
                .primaryColor
                .withOpacity(thisTouchBar ? 1 : 0.15),
          )
        ],
      );
    });
  }

  SideTitles get _bottomTitles => SideTitles(
        showTitles: true,
        getTitlesWidget: (value, meta) {
          final month = nameMouth(value.toInt()).substring(0, 3);
          return GestureDetector(
            onTap: () {
              setState(() {
                final x = value.round();
                touchBar = x;
                context.read<HomeProvider>().setTouchBar(x);
              });
            },
            child: Text(
              month,
              style: TextStyle(
                color: Theme.of(App.globalContext).hoverColor,
                fontSize: 12,
                fontFamily: AppFont.tbc500,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        },
      );

  SideTitles get _leftTitles => SideTitles(
        showTitles: true,
        reservedSize: 40,
        getTitlesWidget: (value, meta) {
          if (value < 0) return const Text('');
          return Text(
            '${value.round()}₾',
            style: TextStyle(
              color: Theme.of(App.globalContext).hoverColor,
              fontSize: 12,
              fontFamily: AppFont.tbc500,
              fontWeight: FontWeight.w500,
            ),
          );
        },
      );

  BarTouchData _barTouchData(BuildContext context) {
    return BarTouchData(
      enabled: true,
      handleBuiltInTouches: false,
      allowTouchBarBackDraw: true,
      touchCallback: (event, response) {
        if (response != null &&
            response.spot != null &&
            event is FlTapUpEvent) {
          setState(() {
            final x = response.spot!.touchedBarGroup.x;
            touchBar = x;
            context.read<HomeProvider>().setTouchBar(x);
          });
        }
      },
      mouseCursorResolver: (event, response) {
        return response == null || response.spot == null
            ? MouseCursor.defer
            : SystemMouseCursors.click;
      },
      touchTooltipData: BarTouchTooltipData(
        tooltipBgColor: const Color.fromRGBO(8, 6, 23, 1),
        tooltipRoundedRadius: 10,
        tooltipPadding:
            const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 4),
        getTooltipItem: (barChartGroupData, index1, barChartRodData, index) {
          return BarTooltipItem(
            '${(barChartRodData.toY - paddingUnderDiagram).round()}₾',
            Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(color: Colors.white),
          );
        },
      ),
    );
  }
}

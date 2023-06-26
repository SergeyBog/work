import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multioil_mb/providers/balance_provider.dart';
import 'package:multioil_mb/ui/balance_page/widgets/azs_card.dart';
import 'package:multioil_mb/ui/balance_page/widgets/card_background.dart';
import 'package:multioil_mb/ui/balance_page/widgets/scrolled_card.dart';
import 'package:multioil_mb/ui/widgets/empty_page.dart';
import 'package:multioil_mb/utils/data_format.dart';
import 'package:multioil_mb/utils/l10n.dart';
import 'package:provider/provider.dart';
import '../../../../utils/themes/styles.dart';

class BalancePage extends StatefulWidget {
  const BalancePage({Key? key}) : super(key: key);

  @override
  State<BalancePage> createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> with WidgetsBindingObserver {
  final ScrollController sliverScrollController = ScrollController();
  final animationDuration = const Duration(milliseconds: 400);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var balanceProvider = context.read<BalanceProvider>();
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.resumed) {
      Future.microtask(() => Future.delayed(const Duration(seconds: 10))
          .then((value) => balanceProvider.getUserBalance()));
      Future.microtask(() => Future.delayed(const Duration(seconds: 20))
          .then((value) => balanceProvider.getUserBalance()));
      Future.microtask(() => Future.delayed(const Duration(seconds: 30))
          .then((value) => balanceProvider.getUserBalance()));
      Future.microtask(() => Future.delayed(const Duration(seconds: 40))
          .then((value) => balanceProvider.getUserBalance()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BalanceProvider>(
      builder: (_, BalanceProvider balanceProvider, __) {
        return Scaffold(
          body: _body(balanceProvider: balanceProvider),
        );
      },
    );
  }

  Widget _body({required BalanceProvider balanceProvider}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppGradient.green,
      ),
      child: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollUpdateNotification) {
            if (scrollNotification.metrics.pixels >= 135 &&
                balanceProvider.removeRoundCorners) {
              balanceProvider.setRoundCorners(false);
            } else if (scrollNotification.metrics.pixels < 135 &&
                balanceProvider.removeRoundCorners == false) {
              balanceProvider.setRoundCorners(true);
            }
          }
          return true;
        },
        child: RefreshIndicator(
          onRefresh: balanceProvider.getUserBalance,
          color: Theme.of(context).primaryColor,
          child: CustomScrollView(
            physics: const ClampingScrollPhysics(),
            controller: sliverScrollController,
            slivers: [
              _sliverAppBar(provider: balanceProvider),
              _sliverList(provider: balanceProvider),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _sliverAppBar({required BalanceProvider provider}) {
    return SliverAppBar(
      expandedHeight: 340,
      pinned: true,
      leading: const SizedBox(height: 0),
      backgroundColor: Colors.transparent,
      collapsedHeight: 94,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.white,
      ),
      flexibleSpace: LayoutBuilder(
        builder: (context, cons) {
          var top = cons.biggest.height;
          return FlexibleSpaceBar(
            expandedTitleScale: 1 + (60 / top * 0.5),
            titlePadding: EdgeInsets.zero,
            title: top >= 220
                ? AnimatedOpacity(
                    opacity: top >= 260 ? 1 : top / (top + 100),
                    duration: animationDuration,
                    child: CardBackground(
                      balanceSum: provider.userBalance.toCurrencyFormat(),
                    ),
                  )
                : AnimatedOpacity(
                    opacity: top <= 180 ? 1 : top / (top + 150),
                    duration: animationDuration,
                    child: ScrollCard(
                      paddingTop: false,
                      balance: provider.userBalance.toCurrencyFormat(),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _sliverList({required BalanceProvider provider}) {
    if (provider.azsInfo.isNotEmpty) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, int index) {
            final bool firstIndex = index == 0;
            final bool lastIndex = index == provider.azsInfo.length - 1;
            final EdgeInsets globalPaddingList = lastIndex
                ? const EdgeInsets.only(bottom: 130)
                : const EdgeInsets.only(bottom: 10);
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: firstIndex
                    ? provider.removeRoundCorners != false
                        ? const BorderRadius.vertical(top: Radius.circular(15))
                        : null
                    : null,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              padding: firstIndex
                  ? const EdgeInsets.only(top: 15, bottom: 10)
                  : globalPaddingList,
              child: AzsCard(
                azs: provider.azsInfo[index],
                displayAzsLogo: false,
              ),
            );
          },
          childCount: provider.azsInfo.length,
        ),
      );
    } else {
      return SliverToBoxAdapter(
        child: Container(
          height: MediaQuery.of(context).size.height - 340,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: EmptyPage(
              titlePage: l10n(context).errorMessage,
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          ),
        ),
      );
    }
  }
}

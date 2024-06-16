import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/screen/main/tab/tab_item.dart';
import 'package:fast_app_base/screen/main/tab/tab_navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../common/common.dart';
import 'fab/w_floating_daangn_button.dart';
import 'w_menu_drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabItem _currentTab = TabItem.home;
  final tabs = TabItem.values;
  late final List<GlobalKey<NavigatorState>> navigatorKeys =
      TabItem.values.map((e) => GlobalKey<NavigatorState>()).toList();

  // 아래에 있는 부분을 삭제하고 여기에 붙여넣었다.

  int get _currentIndex => tabs.indexOf(_currentTab);

  GlobalKey<NavigatorState> get _currentTabNavigationKey =>
      navigatorKeys[_currentIndex];

  bool get extendBody => true;

  static double get bottomNavigationBarBorderRadius => 30.0;
  static const bottomNavigationBarHeight = 60.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// riverpod으로 상태관리를 했다.
    return ProviderScope(
      child: PopScope(
        onPopInvoked: _handleBackPressed,
        child: Material(
          // Stack으로 감싸준다. Scaffold로 감쌀 때 Stack에 안 들어 있다면 Material로 감싸줘야 한다.
          child: Stack(
            children: [
              Scaffold(
                extendBody: extendBody, //bottomNavigationBar 아래 영역 까지 그림
                drawer: const MenuDrawer(),
                body: Container(
                  color: context.appColors.seedColor.getMaterialColorValues[200],
                  padding: EdgeInsets.only(
                      bottom:
                          extendBody ? 60 - bottomNavigationBarBorderRadius : 0),
                  child: SafeArea(
                    bottom: !extendBody,
                    child: pages,
                  ),
                ),
                bottomNavigationBar: _buildBottomNavigationBar(context),
              ),
              if(_currentTab!=TabItem.chat)
                // 자연스럽게 사라지게 하기 위해 animatedOpacity 사용.
                AnimatedOpacity(opacity: _currentTab != TabItem.chat ? 1: 0, duration: 300.ms,
                child: FloatingDaangnButton(),)

              // Scaffold가 아니라 stack 안에 Floating button을 넣은 것은
              // 전체 화면을 어둡게 만들기 위해서다.
              // 버튼 자체에 전체를 흐리게 하는 기능과 버튼의 효과를 넣었다.
            ],
          ),
        ),
      ),
    );
  }

  bool get isRootPage =>
      _currentTab == TabItem.home &&
      _currentTabNavigationKey.currentState?.canPop() == false;

  IndexedStack get pages => IndexedStack(
      index: _currentIndex,
      children: tabs
          .mapIndexed((tab, index) => Offstage(
                offstage: _currentTab != tab,
                child: TabNavigator(
                  navigatorKey: navigatorKeys[index],
                  tabItem: tab,
                ),
              ))
          .toList());

  void _handleBackPressed(bool didPop) {
    if (!didPop) {
      if (_currentTabNavigationKey.currentState?.canPop() == true) {
        Nav.pop(_currentTabNavigationKey.currentContext!);
        return;
      }

      if (_currentTab != TabItem.home) {
        _changeTab(tabs.indexOf(TabItem.home));
      }
    }
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black26, spreadRadius: 0, blurRadius: 10),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(bottomNavigationBarBorderRadius),
          topRight: Radius.circular(bottomNavigationBarBorderRadius),
        ),
        child: BottomNavigationBar(
          items: navigationBarItems(context),
          currentIndex: _currentIndex,
          selectedItemColor: context.appColors.text,
          unselectedItemColor: context.appColors.iconButtonInactivate,
          onTap: _handleOnTapNavigationBarItem,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        ),
      ),
    );
  }

  List<BottomNavigationBarItem> navigationBarItems(BuildContext context) {
    return tabs
        .mapIndexed(
          (tab, index) => tab.toNavigationBarItem(
            context,
            isActivated: _currentIndex == index,
          ),
        )
        .toList();
  }

  void _changeTab(int index) {
    setState(() {
      _currentTab = tabs[index];
    });
  }

  BottomNavigationBarItem bottomItem(bool activate, IconData iconData,
      IconData inActivateIconData, String label) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(label),
          activate ? iconData : inActivateIconData,
          color: activate
              ? context.appColors.iconButton
              : context.appColors.iconButtonInactivate,
        ),
        label: label);
  }

  void _handleOnTapNavigationBarItem(int index) {
    final oldTab = _currentTab;
    final targetTab = tabs[index];
    if (oldTab == targetTab) {
      final navigationKey = _currentTabNavigationKey;
      popAllHistory(navigationKey);
    }
    _changeTab(index);
  }

  void popAllHistory(GlobalKey<NavigatorState> navigationKey) {
    final bool canPop = navigationKey.currentState?.canPop() == true;
    if (canPop) {
      while (navigationKey.currentState?.canPop() == true) {
        navigationKey.currentState!.pop();
      }
    }
  }
}

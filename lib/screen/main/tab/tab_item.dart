import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/tab/home/f_home.dart';
import 'package:flutter/material.dart';

import 'chat/f_chat.dart';
import 'local_life/f_local_life.dart';
import 'my/f_my.dart';
import 'near_me/f_near_me.dart';

enum TabItem {
  home(Icons.home, '홈', HomeFragment()),
  localLife(Icons.holiday_village_outlined, '동네생활', LocalLifeFragment()),
  nearMe(Icons.pin_drop_outlined, '내 근처', NearMeFragment()),
  chat(Icons.chat_bubble_outline, '채팅', ChatFragment()),
  my(Icons.person_outline_rounded, '나의 당근', MyFragment()),
  ;

  final IconData activeIcon;
  final IconData inActiveIcon;
  final String tabName;
  final Widget firstPage;

  const TabItem(this.activeIcon, this.tabName, this.firstPage, {IconData? inActiveIcon})
      : inActiveIcon = inActiveIcon ?? activeIcon;

  BottomNavigationBarItem toNavigationBarItem(BuildContext context, {required bool isActivated}) {
    return BottomNavigationBarItem(
        icon: Icon(
          key: ValueKey(tabName),
          isActivated ? activeIcon : inActiveIcon,
          color:
              isActivated ? context.appColors.iconButton : context.appColors.iconButtonInactivate,
        ),
        label: tabName);
  }
}

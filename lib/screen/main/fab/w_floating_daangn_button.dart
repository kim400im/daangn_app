import 'package:fast_app_base/common/cli_common.dart';
import 'package:fast_app_base/common/common.dart';
import 'package:fast_app_base/screen/main/fab/w_floating_daangn_button.riverpod.dart';
import 'package:fast_app_base/screen/main/s_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common/widget/animated_width_collapse.dart';

class FloatingDaangnButton extends ConsumerWidget {
  FloatingDaangnButton({super.key});

  final duration = 300.ms;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final floatingButtonState = ref.watch(floatingButtonStateProvider);
    final isExpanded = floatingButtonState.isExpanded; // 누르면 커진다.
    final isSmall = floatingButtonState.isSmall;
    // 다른 탭에서도 변화를 주기 위해
    // 내부 state들을 riverpod을 통해 밖으로 끄집어 냈다.


    return Stack(
      children: [
        // 제스처를 무시할 수 있도록 감싼다
        IgnorePointer(
          // 확장이 아닐 때만 무시, 확장 한 상태면 스크롤이 안됨
          ignoring: !isExpanded,
          child: AnimatedContainer(
            duration: duration,
            color: isExpanded ? Colors.black.withOpacity(0.4) : Colors.transparent, //투명도를 준다
          ),
        ),
        Align(
            alignment: Alignment.bottomRight, //오른쪽 하단
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // opacity로 감싸고 isExpanded가 1인지 0인지를 판단한다.
                AnimatedOpacity(
                  opacity: isExpanded ? 1 : 0,
                  duration: duration,
                  child: Container(
                    width: 160,
                    padding: const EdgeInsets.all(15),
                    margin: const EdgeInsets.only(right: 15, bottom: 10),
                    decoration: BoxDecoration(
                        color: context.appColors.floatingActionLayer,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _floatItem('알바', '$basePath/fab/fab_01.png'),
                        _floatItem('과외/클래스', '$basePath/fab/fab_02.png'),
                        _floatItem('농수산물', '$basePath/fab/fab_03.png'),
                        _floatItem('부동산', '$basePath/fab/fab_04.png'),
                        _floatItem('중고차', '$basePath/fab/fab_05.png'),
                      ],
                    ),
                  ),
                ),
                Tap(
                  onTap: () {
                    ref.read(floatingButtonStateProvider.notifier).onTapButton();
                  },
                  child: AnimatedContainer(
                    duration: duration,
                    height: 60,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                        color: isExpanded
                            ? context.appColors.floatingActionLayer
                            : const Color(0xffff791f),
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // 크기를 작게 한다. 이거 없으면 가로로 길게 나옴
                      children: [
                        AnimatedRotation(
                            turns: isExpanded ? 0.125 : 0,
                            duration: duration,
                            child: const Icon(Icons.add)),
                        // 저자가 만든 함수다. 애니메이션이 자연스럽도록 함
                        AnimatedWidthCollapse(
                          visible: !isSmall,
                          duration: duration,
                          child: '글쓰기'.text.make(),
                        )
                      ],
                    ),
                  ).pOnly(
                      bottom: MainScreenState.bottomNavigationBarHeight +
                          context.viewPaddingBottom +
                          10,
                      right: 20),
                ),
              ],
            ))
      ],
    );
  }

  _floatItem(String title, String imagePath) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          imagePath,
          width: 30,
        ),
        const Width(8),
        title.text.make(),
      ],
    );
  }
}

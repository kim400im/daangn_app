import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'w_floating_daangn_button.state.dart';

final floatingButtonStateProvider =
    StateNotifierProvider<FloatingButtonStateNotifier, FloatingButtonState>(
  (ref) => FloatingButtonStateNotifier(
    const FloatingButtonState(false, false),
  ),
      // 초기화를 한다.
);


// Notifier를 사용하기 위해서 Provider를 만들었다.
class FloatingButtonStateNotifier extends StateNotifier<FloatingButtonState> {
  FloatingButtonStateNotifier(super.state);

  bool needToMakeButtonBigger = false;

  void onTapButton() {
    // 최초의 버튼을 눌렀을 때의 state를 저장한다. 이후에 바꾸더라도 최초의 의도를 알 수 있다.
    final isExpanded = state.isExpanded;
    final isSmall = state.isSmall;

    state = state.copyWith(
        isExpanded: !state.isExpanded, isSmall: needToMakeButtonBigger ? false : true);

    if (needToMakeButtonBigger) {
      needToMakeButtonBigger = false;
    }

    if (!isSmall && !isExpanded) {
      needToMakeButtonBigger = true;
    }
  }

  void changeButtonSize(bool isSmall) {
    if (state.isExpanded) {
      return;
    }

    state = state.copyWith(isSmall: isSmall);
  }
}

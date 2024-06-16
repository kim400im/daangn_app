import 'package:freezed_annotation/freezed_annotation.dart';

part 'w_floating_daangn_button.state.freezed.dart';

// stateProvider가 분리 된 것을 하나로 합쳐주자
@freezed
class FloatingButtonState with _$FloatingButtonState {
  const factory FloatingButtonState(
      final bool isExpanded,
      final bool isSmall
      ) = _FloatingButtonState;
}

// plugin에 feeze를 치고 깔아서 사용하자

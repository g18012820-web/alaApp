import 'package:flutter_bloc_template/base/utils/validation_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(
    "ValidationUtils.hasMinimumLength",
    () {
      test(
        "return true when input length is at least 8",
        () {
          String s1 = "abcdefgh";
          final isOk = ValidationUtils.hasMinimumLength(s1);
          expect(isOk, isTrue);
        },
      );
    },
  );
}

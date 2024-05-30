import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

typedef HighLightTextTap = Function(String text);
typedef HighLightTextDetector = bool Function(String text);

class HighLightTextBuilder {
  final TextSpan originalTextSpan;
  final TextStyle? highLightStyle;
  final TextStyle? textStyle;
  final HighLightTextTap? onTap;
  final HighLightTextDetector? highLightTextDetector;
  final RegExp pattern;

  HighLightTextBuilder(
      {required this.originalTextSpan,
      required this.highLightStyle,
      required this.textStyle,
      required this.highLightTextDetector,
      required this.pattern,
      this.onTap});

  TextSpan build() {
    final text = originalTextSpan.toPlainText();
    final List<TextSpan> textSpans = [];

    int previousEndIndex = 0;
    for (final match in pattern.allMatches(text)) {
      final int startIndex = match.start;
      final int endIndex = match.end;

      if (startIndex > previousEndIndex) {
        final String nonMentionText =
            text.substring(previousEndIndex, startIndex);
        textSpans.add(TextSpan(text: nonMentionText, style: textStyle));
      }

      final String mentionText = text.substring(startIndex, endIndex);
      if (highLightTextDetector == null
          ? true
          : highLightTextDetector!(mentionText)) {
        textSpans.add(TextSpan(
            text: mentionText,
            style: highLightStyle,
            recognizer: onTap != null
                ? (TapGestureRecognizer()
                  ..onTap = () {
                    onTap?.call(mentionText);
                  })
                : null));
      } else {
        textSpans.add(TextSpan(text: mentionText, style: textStyle));
      }

      previousEndIndex = endIndex;
    }

    if (previousEndIndex < text.length) {
      final String remainingText = text.substring(previousEndIndex);
      textSpans.add(TextSpan(text: remainingText, style: textStyle));
    }

    return TextSpan(children: textSpans);
  }

  factory HighLightTextBuilder.text(
          {String? text,
          required RegExp pattern,
          TextStyle? highLightStyle,
          TextStyle? textStyle,
          HighLightTextDetector? highLightTextDetector,
          HighLightTextTap? onTap}) =>
      HighLightTextBuilder(
          originalTextSpan: TextSpan(text: text),
          highLightStyle: highLightStyle,
          textStyle: textStyle,
          highLightTextDetector: highLightTextDetector,
          pattern: pattern);
}

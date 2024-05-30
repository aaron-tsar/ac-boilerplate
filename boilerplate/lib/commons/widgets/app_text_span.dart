import 'package:flutter/cupertino.dart';
import 'package:boilerplate/commons/mixin/app_mixin.dart';

class AppRichTextHyper {
  final TextStyle style;
  final Function? onClick;

  const AppRichTextHyper({required this.style, this.onClick});
}

class AppRichText extends StatelessWidget with AppMixin {
  final String text;
  final TextStyle textStyle;
  final Map<String, AppRichTextHyper>? hyperText;
  
  const AppRichText({
    super.key, required this.text, this.hyperText,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    
    List<String> texts = [];
    var tText = text;
    var tHyperText = hyperText ?? <String, AppRichTextHyper>{};
    
    for(final e in tHyperText.entries) {
      tText = tText.replaceAll(e.key, "|||${e.key}|||");
    }

    texts.addAll(tText.split("|||"));

    return RichText(
      text: TextSpan(
        children: texts.map((e) {
          final contain = tHyperText.containsKey(e);
          final res = tHyperText[e];
          if(contain && res?.onClick != null) {
            return WidgetSpan(
              child: GestureDetector(
                onTap: (){
                  res?.onClick?.call();
                },
                child: Text(
                  e,
                  style: contain ? res?.style : textStyle,
                ),
              ),
            );
          }
          return TextSpan(
            text: e,
            style: contain ? res?.style : textStyle,
          );
        }).toList(),
      ),
    );
  }
}

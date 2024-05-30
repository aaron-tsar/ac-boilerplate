import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';
import 'package:boilerplate/commons/styles/themes/default_theme.dart';
import 'package:boilerplate/commons/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef PickItemFormFieldByPopupStringBuilder<T> = String Function(T value);
typedef PickItemFormFieldByWrapBuilder<T> = Widget Function(BuildContext context, T value, bool picked);
typedef PickFromOutSideTypeDef<T> = Function(Function(T value));

class PickItemFormField<T> extends FormField<T> {

  final List<T> items;
  final ValueChanged<T>? onChanged;
  final String? title;

  PickItemFormField.byPopup({
    super.key,
    T? value,
    required this.items,
    required PickItemFormFieldByPopupStringBuilder<T> itemBuilder,
    super.onSaved,
    super.validator,
    this.onChanged,
    this.title,
    String? hint,
  }) : super(
    initialValue: value,
    builder: (field) {
      final _PickItemFormFieldState<T> state = field as _PickItemFormFieldState<T>;
      final styles = AppStyle.of(state.context);
      final bool hasError = field.errorText != null;
      final valuePicked = field.value != null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              title ?? "",
              style: styles.blackTextColor.textTheme.textTitleStyle.copyWith(
                fontSize: 12,
              ),
            ),
          ),
          OutlinedButton(
            style: styles.outlineButtonStyle.mergeOutlineColor(styles.defaultBorder.borderSide.color).mergeBackgroundColor(Colors.transparent),
            onPressed: () {
              if(state.value == null && items.isNotEmpty) {
                state.didChange(items.first);
                onChanged?.call(items.first);
              }
              state.pickValue(itemBuilder);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Expanded(
                    child: valuePicked ? Text(
                      itemBuilder.call(field.value as T),
                      style: styles.blackTextColor.textTheme.textStyle,
                    ) : Text(
                      hint ?? "",
                      style: styles.light.inputDecorationTheme.hintStyle,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 15,
                    color: styles.greysTextColor[2],
                  ),
                ],
              ),
            ),
          ),
          if (hasError)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(
                field.errorText!,
                style: AppColors.redPigment.textTheme.textStyle.copyWith(
                  fontSize: 13,
                ),
              ),
            ),
        ],
      );
    },
  );

  @override
  _PickItemFormFieldState<T> createState() => _PickItemFormFieldState<T>();
}

class _PickItemFormFieldState<T> extends FormFieldState<T> with AppMixin {

  @override
  PickItemFormField<T> get widget => super.widget as PickItemFormField<T>;

  void pickValue(PickItemFormFieldByPopupStringBuilder<T> stringBuilder) async {
    final res = await showModalBottomSheet(
      context: appContext,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.sizeOf(context).height/2.5,
          decoration: BoxDecoration(
            color: styles.greysTextColor.last,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8.0),
                      child: Text(
                        widget.title != null ? " ${widget.title}" : "",
                        style: styles.greysTextColor[2].textTheme.subTitleStyle.copyWith(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 16,
                      color: styles.greysTextColor[2],
                    ),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Expanded(
                child: StatefulBuilder(
                  builder: (context, subSetState) {
                    return CupertinoPicker.builder(
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        final picked = value == item;
                        return Center(
                          child: Text(
                            stringBuilder.call(item),
                            style: (picked ? styles.blackTextColor : styles.greysTextColor[2]).textTheme.subTitleStyle.copyWith(
                              fontSize: 20,
                            ),
                          ),
                        );
                      },
                      childCount: widget.items.length,
                      itemExtent: 60,
                      onSelectedItemChanged: (index) {
                        didChange(widget.items[index]);
                        subSetState(() {});
                        widget.onChanged?.call(widget.items[index]);
                      },
                      scrollController: value is T ? FixedExtentScrollController(
                        initialItem: widget.items.indexOf(value as T),
                      ) : null,
                      selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
                        background: styles.greysTextColor[2].withOpacity(0.1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    if(res is T) {
      widget.onChanged?.call(res);
      didChange(res);
    }
  }
}
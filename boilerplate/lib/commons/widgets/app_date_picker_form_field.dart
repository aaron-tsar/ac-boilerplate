import 'package:boilerplate/commons/styles/themes/default_theme.dart';
import 'package:boilerplate/commons/utils/app_colors.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';

class DatePickerFormField extends FormField<DateTime> {

  DatePickerFormField({
    super.key,
    DateTime? value,
    super.onSaved,
    super.validator,
    ValueChanged<DateTime>? onChanged,
    required String title,
    String? hint,
    required DateFormat dateFormat,
  }) : super(
    initialValue: value,
    builder: (field) {
      final _DatePickerFormFieldState state = field as _DatePickerFormFieldState;
      final styles = AppStyle.of(state.context);
      final bool hasError = field.errorText != null;
      final valuePicked = field.value != null;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              title,
              style: styles.blackTextColor.textTheme.textTitleStyle.copyWith(
                fontSize: 12,
              ),
            ),
          ),
          OutlinedButton(
            style: styles.outlineButtonStyle.mergeOutlineColor(styles.defaultBorder.borderSide.color).mergeBackgroundColor(Colors.transparent),
            onPressed: () {
              state.pickValue(hint, onChanged);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      valuePicked ? dateFormat.format(field.value!) : (hint ?? ""),
                      style: valuePicked ? styles.blackTextColor.textTheme.textStyle : styles.light.inputDecorationTheme.hintStyle,
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
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends FormFieldState<DateTime> with AppMixin {

  @override
  DatePickerFormField get widget => super.widget as DatePickerFormField;

  Future<DateTime?> pickValue(String? hint, ValueChanged<DateTime>? onChanged) async {
    // return showDatePicker(
    //   context: context,
    //   initialDate: DateTime.now(),
    //   firstDate: DateTime(2000, 01, 01),
    //   lastDate: DateTime.now(),
    //   currentDate: value,
    // );
    final res = await showModalBottomSheet(
      useRootNavigator: true,
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
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
                      hint ?? "",
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
                    context.pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: value ?? DateTime.now().subtract(const Duration(days: 1)),
                maximumDate: DateTime.now(),
                minimumDate: DateTime(1900, 01, 01),
                onDateTimeChanged: (val) {
                  didChange(val);
                  onChanged?.call(val);
                },
              ),
            ),
          ],
        ),
      ),
    );
    return res;
  }
}
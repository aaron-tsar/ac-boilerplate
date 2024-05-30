import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:boilerplate/commons/mixin/app_mixin.dart';
import 'package:boilerplate/commons/styles/styles.dart';

typedef AppTextFieldTitleBuilder = TextStyle Function(bool);

class CustomTextEditingController<T> extends TextEditingController {
  late final GlobalKey<FormState> formKey;
  late final GlobalKey globalKey;
  late final FocusNode focusNode;

  ///you can hold the meta value for the controller
  T? metaValue;

  ///you can hold the value to check if this controller's value is valid or not
  bool isValid = true;

  CustomTextEditingController({super.text, GlobalKey<FormState>? withFormKey})
      : formKey = withFormKey ?? GlobalKey<FormState>(),
        focusNode = FocusNode(),
        globalKey = GlobalKey();

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  void clear() {
    metaValue = null;
    super.clear();
  }

  bool? validate() => formKey.currentState?.validate();
}
class AppTextField extends StatefulWidget {

  final CustomTextEditingController controller;
  final String? title;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final bool obscure;
  final TextAlign textAlign;
  final AppTextFieldTitleBuilder? textTitleBuilder;
  final String? hint;
  final TextStyle? hintStyle;
  final InputBorder? focusedBorder, unfocusedBorder;
  final Widget? suffix;
  final TextInputType? textInputType;

  const AppTextField({
    super.key, required this.controller,
    this.title, this.maxLength,
    this.inputFormatters, this.validator,
    this.obscure = false,
    this.textAlign = TextAlign.start,
    this.textTitleBuilder, this.hint,
    this.hintStyle, this.focusedBorder, this.unfocusedBorder, this.suffix, this.textInputType,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> with AppMixin {

  CustomTextEditingController get controller => widget.controller;
  bool obscure = false;
  bool get isPasswordField => widget.obscure;
  bool get hasTitle => widget.title != null;

  BehaviorSubject<bool> focusNodeStream = BehaviorSubject();

  @override
  void initState() {
    if(isPasswordField) obscure = true;
    controller.focusNode.addListener(() {
      focusNodeStream.add(controller.focusNode.hasFocus);
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(hasTitle) Padding(
            padding: const EdgeInsets.only(bottom: 7.0),
            child: StreamBuilder<bool>(
              stream: focusNodeStream,
              builder: (context, snapshot) {
                return Text(
                  widget.title!,
                  style: widget.textTitleBuilder?.call(snapshot.data == true)
                      ?? styles.blackTextColor.textTheme.textTitleStyle.copyWith(
                    fontSize: 12,
                  ),
                );
              }
            ),
          ),
          TextFormField(
            keyboardType: widget.textInputType,
            controller: controller,
            focusNode: controller.focusNode,
            textAlign: widget.textAlign,
            decoration: InputDecoration(
              border: widget.focusedBorder,
              focusedBorder: widget.focusedBorder,
              enabledBorder: widget.unfocusedBorder,
              isCollapsed: false,
              isDense: true,
              counterText: "",
              errorStyle: const TextStyle(height: 0),
              suffixIcon: _buildSuffixIcon(),
              hintText: widget.hint,
              hintStyle: widget.hintStyle,
            ),
            maxLength: widget.maxLength,
            inputFormatters: widget.inputFormatters,
            validator: widget.validator,
            obscureText: obscure,
          ),
        ],
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if(isPasswordField) {
      return GestureDetector(
        onTap: (){
          setState(() {
            obscure = !obscure;
          });
        },
        child: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 18,
          color: styles.colorScheme.primary,
        ),
      );
    }
    return widget.suffix;
  }
}
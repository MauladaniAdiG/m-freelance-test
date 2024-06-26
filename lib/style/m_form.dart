import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum FormType { TEXT, DROPDOWN, TEXT_OUTLINE_BORDER }

class MForm extends StatefulWidget {
  final TextEditingController? controller;
  final InputBorder? inputBorder;
  final int? minLines;
  final int? maxLines;
  final Widget? label;
  final String? hintText;
  final bool obscureText;
  final bool isDense;
  final bool filled;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final FocusNode? focusNode;
  final String title;
  final FormType formType;
  final List<String> dropDownItems;
  final String? value;
  final EdgeInsetsGeometry? contentPadding;
  final Color? cursorColor;
  final Color? inputColor;
  final Color? hintColor;
  final Color? fillColor;
  final Color? borderColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final List<TextInputFormatter>? inputFormatters;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextAlign textAlign;
  final BorderRadius? borderRadius;
  const MForm({
    super.key,
    this.controller,
    this.inputBorder,
    this.minLines,
    this.maxLines,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.isDense = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.title = '',
    this.contentPadding,
    this.cursorColor,
    this.inputColor,
    this.hintColor,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.style,
    this.hintStyle,
    this.textAlign = TextAlign.start,
  })  : dropDownItems = const [],
        value = null,
        formType = FormType.TEXT,
        filled = false,
        fillColor = null,
        borderRadius = null;

  const MForm.withFillColor({
    super.key,
    this.controller,
    this.inputBorder,
    this.minLines,
    this.maxLines,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.isDense = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.title = '',
    this.contentPadding,
    this.cursorColor,
    this.inputColor,
    this.hintColor,
    this.fillColor,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.style,
    this.hintStyle,
    this.textAlign = TextAlign.start,
  })  : dropDownItems = const [],
        value = null,
        formType = FormType.TEXT,
        filled = true,
        borderRadius = null;

  const MForm.dropdown({
    super.key,
    required this.dropDownItems,
    this.inputBorder,
    this.label,
    this.hintText,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.title = '',
    this.value,
    this.contentPadding,
    this.isDense = false,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
    this.hintStyle,
    this.borderColor,
  })  : controller = null,
        obscureText = false,
        textInputAction = null,
        keyboardType = null,
        minLines = null,
        maxLines = null,
        cursorColor = null,
        inputColor = null,
        hintColor = null,
        formType = FormType.DROPDOWN,
        filled = false,
        fillColor = null,
        inputFormatters = null,
        textAlign = TextAlign.start,
        borderRadius = null;

  const MForm.dropdownWithColor({
    super.key,
    required this.dropDownItems,
    this.inputBorder,
    this.label,
    this.hintText,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.title = '',
    this.value,
    this.contentPadding,
    this.isDense = false,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.style,
    this.hintStyle,
    this.borderColor,
  })  : controller = null,
        obscureText = false,
        textInputAction = null,
        keyboardType = null,
        minLines = null,
        maxLines = null,
        cursorColor = null,
        inputColor = null,
        hintColor = null,
        formType = FormType.DROPDOWN,
        filled = true,
        inputFormatters = null,
        textAlign = TextAlign.start,
        borderRadius = null;

  const MForm.outlineWithFillColor({
    super.key,
    this.controller,
    this.inputBorder,
    this.minLines,
    this.maxLines,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.isDense = false,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onChanged,
    this.focusNode,
    this.title = '',
    this.contentPadding,
    this.cursorColor,
    this.inputColor,
    this.hintColor,
    this.fillColor,
    this.borderColor,
    this.prefixIcon,
    this.suffixIcon,
    this.inputFormatters,
    this.style,
    this.hintStyle,
    this.textAlign = TextAlign.start,
    this.borderRadius,
  })  : dropDownItems = const [],
        value = null,
        formType = FormType.TEXT_OUTLINE_BORDER,
        filled = true;

  @override
  State<MForm> createState() => _MFormState();
}

class _MFormState extends State<MForm> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: widget.title.isNotEmpty,
          child: Text(
            widget.title,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
          ),
        ),
        const SizedBox(height: 16.0),
        _chooseField(),
      ],
    );
  }

  Widget _chooseField() {
    if (widget.formType == FormType.DROPDOWN) {
      return DropdownButtonFormField<String>(
        decoration: _inputDecoration(),
        validator: widget.validator,
        value: widget.value,
        onChanged: widget.onChanged,
        style: widget.style ??
            const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400,
            ),
        items: widget.dropDownItems
            .map((e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
                ))
            .toList(),
      );
    }
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      minLines: widget.minLines,
      maxLines: widget.maxLines ?? 1,
      obscureText: widget.obscureText,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textAlign: widget.textAlign,
      style: widget.style ?? const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500).copyWith(color: widget.inputColor),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: widget.validator,
      onChanged: widget.onChanged,
      cursorColor: widget.cursorColor,
      inputFormatters: widget.inputFormatters,
      decoration: _inputDecoration(),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      label: widget.label,
      labelStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
      hintText: widget.hintText,
      hintStyle: widget.hintStyle ??
          const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500).copyWith(
            color: widget.hintColor == null ? Colors.grey : widget.hintColor!,
          ),
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      isDense: widget.isDense,
      fillColor: widget.fillColor,
      filled: widget.filled,
      contentPadding: widget.contentPadding,
      border: widget.inputBorder ?? _inputBorder(),
      errorBorder: widget.inputBorder?.copyWith(borderSide: const BorderSide(color: Colors.red)) ?? _inputBorder(borderColor: Colors.red),
      enabledBorder: widget.inputBorder ?? _inputBorder(),
      focusedBorder: widget.inputBorder ?? _inputBorder(),
      focusedErrorBorder: widget.inputBorder?.copyWith(borderSide: const BorderSide(color: Colors.red)) ?? _inputBorder(borderColor: Colors.red),
    );
  }

  InputBorder _inputBorder({
    Color borderColor = Colors.grey,
  }) {
    if (widget.formType == FormType.TEXT_OUTLINE_BORDER) {
      return OutlineInputBorder(
        borderSide: BorderSide(color: widget.borderColor ?? borderColor),
        borderRadius: widget.borderRadius ?? const BorderRadius.all(Radius.circular(4.0)),
      );
    }
    return UnderlineInputBorder(
      borderSide: BorderSide(color: widget.borderColor ?? borderColor),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

class TextFieldWidget extends FormBuilderTextField {
  final String id;
  final List<String? Function(String?)>? validators;
  final InputDecoration? decor;
  final String? hint;
  final String? label;
  final String? prefix;
  final String? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final double? borderRadius;
  final InputBorder? border;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  TextFieldWidget(
    this.id, {
    super.key,
    super.maxLines,
    super.keyboardType,
    super.autovalidateMode,
    super.textCapitalization,
    this.decor,
    super.textInputAction,
    super.obscureText,
    super.initialValue,
    this.validators,
    this.hint,
    this.label,
    this.borderRadius,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    super.maxLength,
    super.onSubmitted,
    super.inputFormatters,
    super.onChanged,
    super.onSaved,
    this.border,
    this.labelStyle,
    this.hintStyle,
    super.style,
  }) : super(
            name: id,
            decoration: decor?.copyWith(
                  labelText: label,
                  hintText: hint,
                  prefixText: prefix,
                  suffixText: suffix,
                  prefixIcon: prefixIcon,
                  suffixIcon: suffixIcon,
                  labelStyle: labelStyle,
                  hintStyle: hintStyle,
                ) ??
                InputDecoration(
                    labelText: label,
                    hintText: hint,
                    prefixText: prefix,
                    suffixText: suffix,
                    prefixIcon: prefixIcon,
                    suffixIcon: suffixIcon,
                    labelStyle: labelStyle,
                    hintStyle: hintStyle,
                    enabledBorder: border ??
                        OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(borderRadius ?? 8)),
                          borderSide: const BorderSide(width: 1),
                        ),
                    border: border ??
                        OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(borderRadius ?? 8)),
                          borderSide: const BorderSide(width: 1),
                        ),
                    focusedBorder: border ??
                        OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                              Radius.circular(borderRadius ?? 8)),
                          borderSide: const BorderSide(width: 1),
                        )),
            validator: FormBuilderValidators.compose(
                validators ?? <FormFieldValidator<String>>[]));
}
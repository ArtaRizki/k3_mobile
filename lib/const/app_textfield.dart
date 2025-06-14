import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield_validator.dart';

class AppTextField {
  static Widget basicTextField({
    required TextEditingController controller,
    required String label,
    VoidCallback? onTap,
    bool readOnly = false,
    bool required = false,
    bool? isDense,
    String hintText = '',
    Widget? prefix,
    Widget? prefixIcon,
    BoxConstraints? prefixIconConstraints,
    Widget? suffixIcon,
    BoxConstraints? suffixIconConstraints,
    Function(String)? onChanged,
    int? maxLines,
    double? radius,
    EdgeInsetsGeometry? contentPadding,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != '')
          Row(
            children: [
              Text(
                label,
                style: AppTextStyle.actionL.copyWith(
                  color: AppColor.neutralDarkDarkest,
                ),
              ),
              required
                  ? Text(
                    ' *',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.red,
                    ),
                  )
                  : SizedBox(),
            ],
          ),
        if (label != '') const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          inputFormatters: inputFormatters,
          style: AppTextStyle.bodyM.copyWith(color: AppColor.neutralDarkMedium),
          onChanged: onChanged,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            isDense: isDense,
            filled: true,
            fillColor:
                readOnly && onChanged == null
                    ? AppColor.neutralLightLight
                    : Colors.white,
            prefix:
                prefixIcon == null && prefix == null
                    ? SizedBox(width: 16)
                    : prefix ?? null,
            prefixIconConstraints: prefixIconConstraints,
            prefixIcon: prefixIcon,
            suffixIconConstraints: suffixIconConstraints,
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: AppTextStyle.bodyM.copyWith(
              color: AppColor.neutralLightDarkest,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 12),
              borderSide: BorderSide(color: AppColor.neutralLightDarkest),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 12),
              borderSide: BorderSide(color: AppColor.neutralLightDarkest),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 12),
              borderSide: BorderSide(
                color:
                    readOnly
                        ? AppColor.neutralLightDarkest
                        : AppColor.highlightDarkest,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 12),
              borderSide: BorderSide(color: AppColor.errorDark),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(radius ?? 12),
              borderSide: BorderSide(color: AppColor.errorDark),
            ),
            contentPadding:
                contentPadding ?? EdgeInsets.fromLTRB(0, 14, 16, 14),
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (v) {
            if (validator != null)
              validator;
            else {
              if (required) return AppTextFieldValidator.requiredValidator(v);
              return null;
            }
            return null;
          },
        ),
      ],
    );
  }

  static Widget loginTextField({
    required TextEditingController controller,
    VoidCallback? onTap,
    bool readOnly = false,
    bool required = false,
    bool isPassword = false,
    String hintText = '',
    Widget? suffixIcon,
    BoxConstraints? suffixIconConstraints,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      style: AppTextStyle.bodyM.copyWith(color: AppColor.neutralDarkMedium),
      obscureText: isPassword,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: readOnly ? AppColor.neutralLightLight : Colors.white,
        suffixIconConstraints: suffixIconConstraints,
        suffixIcon: suffixIcon,
        hintText: hintText,
        hintStyle: AppTextStyle.bodyM.copyWith(
          color: AppColor.neutralLightDarkest,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColor.neutralLightDarkest),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColor.neutralLightDarkest),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColor.highlightDarkest),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColor.errorDark),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: AppColor.errorDark),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) {
        if (validator != null)
          validator;
        else {
          if (required) return AppTextFieldValidator.requiredValidator(v);
          return null;
        }
        return null;
      },
    );
  }
}

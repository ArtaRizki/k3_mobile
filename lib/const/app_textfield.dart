import 'package:flutter/material.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';

class AppTextField {
  static Widget basicTextField({
    required TextEditingController controller,
    required String label,
    VoidCallback? onTap,
    bool readOnly = false,
    bool required = false,
    String hintText = '',
    Widget? prefixIcon,
    BoxConstraints? prefixIconConstraints,
    Widget? suffixIcon,
    BoxConstraints? suffixIconConstraints,
    Function(String)? onChanged,
    int? maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != '')
          Row(
            children: [
              Text(
                label,
                style: AppTextStyle.actionL
                    .copyWith(color: AppColor.neutralDarkDarkest),
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
          style: AppTextStyle.bodyM.copyWith(color: AppColor.neutralDarkMedium),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly && onChanged == null
                ? AppColor.neutralLightLight
                : Colors.white,
            prefixIconConstraints: prefixIconConstraints,
            prefixIcon: prefixIcon,
            suffixIconConstraints: suffixIconConstraints,
            suffixIcon: suffixIcon,
            hintText: hintText,
            hintStyle: AppTextStyle.bodyM
                .copyWith(color: AppColor.neutralLightDarkest),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.neutralLightDarkest),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.neutralLightDarkest),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: readOnly
                      ? AppColor.neutralLightDarkest
                      : AppColor.highlightDarkest),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.errorDark),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColor.errorDark),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          ),
        ),
      ],
    );
  }

  static Widget loginTextField({
    required TextEditingController controller,
    VoidCallback? onTap,
    bool readOnly = false,
    bool isPassword = false,
    String hintText = '',
    Widget? suffixIcon,
    BoxConstraints? suffixIconConstraints,
    Function(String)? onChanged,
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
        hintStyle:
            AppTextStyle.bodyM.copyWith(color: AppColor.neutralLightDarkest),
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
        contentPadding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      ),
    );
  }
}

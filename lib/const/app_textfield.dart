import 'package:flutter/material.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool filled;
  final String hintText;
  final Widget? prefix;

  const AppTextField({
    Key? key,
    required this.controller,
    required this.label,
    this.onTap,
    this.readOnly = false,
    this.filled = false,
    this.hintText = '',
    this.prefix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style:
              AppTextStyle.actionL.copyWith(color: AppColor.neutralDarkDarkest),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          decoration: InputDecoration(
            filled: filled,
            fillColor: filled ? Colors.white : AppColor.neutralLightLight,
            prefix: prefix,
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
              borderSide: BorderSide(color: AppColor.highlightDarkest),
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
                const EdgeInsets.symmetric(vertical: 30, horizontal: 12),
          ),
        ),
      ],
    );
  }
}

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:k3_mobile/component/dropdown_search.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_text_style.dart';

class AppDropdown {
  static Widget normalDropdown({
    required String label,
    VoidCallback? onTap,
    bool readOnly = false,
    String hintText = '',
    String? selectedItem,
    Function(String?)? onChanged,
    required List<DropdownMenuItem<String>> list,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != '')
          Text(
            label,
            style: AppTextStyle.actionL
                .copyWith(color: AppColor.neutralDarkDarkest),
          ),
        if (label != '') const SizedBox(height: 8),
        DropdownButtonFormField(
          items: readOnly ? null : list,
          onTap: onTap,
          style: AppTextStyle.bodyM.copyWith(color: AppColor.neutralDarkMedium),
          onChanged: onChanged,
          onSaved: (val) => FocusManager.instance.primaryFocus?.unfocus(),
          icon: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 0, 64),
            child: Icon(Icons.keyboard_arrow_down,
                color: AppColor.neutralLightDarkest, size: 24),
          ),
          // style: Constant.primaryTextStyle,
          isExpanded: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: readOnly ? AppColor.neutralLightLight : Colors.white,
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
              borderSide: BorderSide(color: AppColor.neutralLightDarkest),
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
          hint: Text(
            hintText,
            style: AppTextStyle.bodyM.copyWith(
              color: AppColor.neutralLightDarkest,
            ),
          ),
          value: selectedItem,
          // validator: (value) {
          //   if (required && value?.isNotEmpty != true) {
          //     return 'Harap isi $label';
          //   }
          // },
        ),
      ],
    );
  }

  static Widget filterDropdown({
    required String label,
    String? hintText,
    int line = 1,
    TextInputType type = TextInputType.text,
    bool readOnly = false,
    bool required = false,
    String? selectedItem,
    Function(String?)? onChanged,
    required List<DropdownMenuItem<String>> list,
    TextEditingController? controller,
    TextAlign? inputAlign,
    CrossAxisAlignment align = CrossAxisAlignment.start,
    EdgeInsetsGeometry? padding,
    double? labelFontSize,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (label != '')
            Text(
              label,
              style: AppTextStyle.actionL
                  .copyWith(color: AppColor.neutralDarkDarkest),
            ),
          if (label != '') const SizedBox(height: 8),
          CustomDropdownSearch().dropdownFilter(
            label: label,
            hint: hintText ?? "",
            list: list,
            onChanged: onChanged,
            required: required,
            selectedItem: selectedItem,
          ),
        ],
      ),
    );
  }

  static Widget searchDropdown({
    String? labelText,
    String? hintText,
    int line = 1,
    TextInputType type = TextInputType.text,
    bool readOnly = false,
    bool required = false,
    String? selectedItem,
    Function(String?)? onChanged,
    required List<String> list,
    TextEditingController? controller,
    TextAlign? inputAlign,
    CrossAxisAlignment align = CrossAxisAlignment.start,
    EdgeInsetsGeometry? padding,
    double? labelFontSize,
  }) {
    return Column(
      crossAxisAlignment: align,
      children: [
        if (labelText != null)
          Text(
            labelText,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        CustomDropdownSearch().dropdownSearch(
          label: labelText,
          hint: hintText ?? "",
          list: list,
          onChanged: onChanged,
          required: required,
        ),
      ],
    );
  }
}

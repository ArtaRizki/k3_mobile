import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:k3_mobile/const/app_color.dart';

class CustomDropdownSearch {
  Widget dropdownSearch(
      {String? label,
      required String hint,
      required List<String> list,
      bool required = false,
      String? selectedItem,
      InputDecoration? inputDecoration,
      Widget? icon,
      required Function(String?)? onChanged}) {
    return DropdownSearch<String>(
      popupProps:
          PopupProps.dialog(showSearchBox: true, showSelectedItems: true),
      items: (filter, loadProps) {
        return list;
      },
      selectedItem: selectedItem,
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(
          icon: Icon(Icons.clear, size: 17, color: Colors.black),
        ),
        dropdownButtonProps: DropdownButtonProps(
          iconOpened: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 0, 24),
            child: const Icon(Icons.keyboard_arrow_up, color: Colors.black87),
          ),
          iconClosed: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 0, 24),
            child: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
          ),
        ),
      ),
      validator: (value) {
        if (required && value?.isNotEmpty != true) {
          return 'Harap isi $label';
        }
        return null;
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: inputDecoration ??
            InputDecoration(
              contentPadding: EdgeInsets.zero,
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black26 /*, fontSize: 12*/),
              filled: true,
              fillColor: Colors.grey.shade200,
              suffixIconColor: AppColor.neutralLightDarkest,
              hoverColor: AppColor.neutralLightDarkest,
              focusColor: AppColor.highlightDarkest,
              prefix: SizedBox(width: 12),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1,
                  color: AppColor.highlightDarkest,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
      ),
      onChanged: onChanged,
    );
  }

  Widget dropdownNoSearch(
      {String? label,
      required String hint,
      String? selectedItem,
      required List<String> list,
      bool required = false,
      InputDecoration? inputDecoration,
      Widget? icon,
      required Function(String?)? onChanged}) {
    return DropdownSearch<String>(
      popupProps:
          PopupProps.menu(showSearchBox: false, showSelectedItems: true),
      items: (filter, loadProps) {
        return list;
      },
      selectedItem: selectedItem,
      suffixProps: DropdownSuffixProps(
        clearButtonProps: ClearButtonProps(
          icon: Icon(Icons.clear, size: 17, color: Colors.black),
        ),
        dropdownButtonProps: DropdownButtonProps(
          iconOpened: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 0, 24),
            child: const Icon(Icons.keyboard_arrow_up, color: Colors.black87),
          ),
          iconClosed: Padding(
            padding: const EdgeInsets.fromLTRB(6, 6, 0, 24),
            child: const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
          ),
        ),
      ),
      validator: (value) {
        if (required && value?.isNotEmpty != true) {
          return 'Harap isi $label';
        }
        return null;
      },
      decoratorProps: DropDownDecoratorProps(
        decoration: inputDecoration ??
            InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.black26),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: AppColor.highlightDarkest),
              ),
            ),
      ),
      onChanged: onChanged,
    );
  }

  Widget dropdown2(
      {String? label,
      required String hint,
      required List<DropdownMenuItem<String>> list,
      bool required = true,
      bool readOnly = false,
      bool enabled = true,
      Color? fillColor,
      String? selectedItem,
      required Function(String?)? onChanged}) {
    return DropdownButtonFormField(
      items: readOnly ? null : list,
      onChanged: readOnly ? null : onChanged,
      onSaved: (val) => FocusManager.instance.primaryFocus?.unfocus(),
      icon: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 12, 64),
        child: Icon(Icons.keyboard_arrow_down, color: Colors.black87, size: 24),
      ),
      // style: Constant.primaryTextStyle,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: hint,
        hintStyle: TextStyle(color: AppColor.neutralLightDarkest),
        filled: true,
        enabled: enabled ?? true,
        fillColor: fillColor ??
            ((enabled ?? false) ? Colors.white : AppColor.neutralLightDarkest),
        suffixIconColor: AppColor.neutralLightDarkest,
        hoverColor: AppColor.neutralLightDarkest,
        focusColor: AppColor.highlightDarkest,
        prefix: SizedBox(width: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.neutralLightDarkest),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.neutralLightDarkest),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColor.highlightDarkest),
        ),
      ),
      hint: Text(hint),
      value: selectedItem,
      // validator: (value) {
      //   if (required && value?.isNotEmpty != true) {
      //     return 'Harap isi $label';
      //   }
      // },
    );
  }

  Widget dropdownFilter(
      {String? label,
      required String hint,
      required List<DropdownMenuItem<String>> list,
      bool required = false,
      String? selectedItem,
      required Function(String?)? onChanged}) {
    return DropdownButtonFormField(
      padding: EdgeInsets.only(top: 8),
      items: list,
      onChanged: onChanged,
      elevation: 0,
      icon: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 12, 64),
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Colors.black,
        ),
      ),
      // style: Constant.primaryTextStyle,
      isExpanded: true,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        hintText: hint,
        hintStyle: TextStyle(color: Colors.black26, fontSize: 12),
        filled: true,
        fillColor: Colors.white,
        suffixIconColor: AppColor.neutralLightDarkest,
        hoverColor: AppColor.neutralLightDarkest,
        focusColor: AppColor.highlightDarkest,
        prefix: SizedBox(width: 12),
        border: OutlineInputBorder(
          borderSide: BorderSide(width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1),
          borderRadius: BorderRadius.circular(14),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.solid,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      hint: Text(hint),
      value: selectedItem,
      validator: (value) {
        if (required && value?.isNotEmpty != true) {
          return 'Harap isi $label';
        }
        return null;
      },
    );
  }
}

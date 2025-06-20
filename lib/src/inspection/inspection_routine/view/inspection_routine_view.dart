import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/empty_list.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/inspection/inspection_routine/controller/inspection_routine_controller.dart';
import 'package:k3_mobile/src/inspection/model/inspection_model.dart';

class InspectionRoutineView extends GetView<InspectionRoutineController> {
  InspectionRoutineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar.basicAppbar(title: 'Inspeksi Rutin'),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                _buildHeaderAction(),
                const SizedBox(height: 6),
                _buildInspectionList(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    final isQuerying = controller.searchC.value.text.isNotEmpty;
    return AppTextField.basicTextField(
      label: '',
      controller: controller.searchC.value,
      hintText: 'Search',
      suffixIconConstraints: BoxConstraints(maxHeight: isQuerying ? 23 : 18),
      onChanged: (_) {
        controller.update();
        controller.onSearchChanged();
      },
      suffixIcon: InkWell(
        onTap: isQuerying ? controller.clearField : null,
        child:
            isQuerying
                ? const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(Icons.close, color: AppColor.neutralDarkLight),
                )
                : Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: Image.asset(
                    Assets.iconsIcSearch,
                    color: AppColor.neutralLightDarkest,
                  ),
                ),
      ),
    );
  }

  Widget _buildHeaderAction() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            'Data Inspeksi Rutin',
            style: AppTextStyle.actionL.copyWith(
              color: AppColor.neutralDarkLight,
            ),
          ),
          const Spacer(),
          AppCard.basicCard(
            onTap: () => Get.toNamed(AppRoute.INSPECTION_ROUTINE_CREATE),
            color: AppColor.highlightDarkest,
            radius: 20,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
            child: Text(
              'Buat baru',
              style: AppTextStyle.actionL.copyWith(
                color: AppColor.neutralLightLightest,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInspectionList() {
    final data = controller.filteredInspections;
    if (data.isEmpty) {
      return EmptyList.textEmptyList(
        minHeight: Get.size.height * 0.71,
        onRefresh: _onRefresh,
      );
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.separated(
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, index) => _buildListItem(data[index]),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    await controller.getData();
    controller.update();
  }

  Widget _buildListItem(InspectionModelData? item) {
    return AppCard.listCard(
      onTap: () {
        FocusScope.of(Get.context!).unfocus();
        if (item?.id != null) {
          Get.toNamed(AppRoute.INSPECTION_ROUTINE_CREATE, arguments: item?.id);
        }
      },
      color: AppColor.neutralLightLightest,
      child: Row(
        children: [
          Image.asset(
            Assets.iconsIcListInspectionRoutine,
            width: 52,
            height: 52,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRowText(item?.code, item?.docDate, AppTextStyle.h4),
                const SizedBox(height: 3),
                _buildRowText(
                  item?.resiko,
                  item?.kategoriName,
                  AppTextStyle.bodyS,
                ),
                const SizedBox(height: 3),
                _buildRowText(
                  item?.lokasi,
                  Utils.getDocStatusName(item?.docStatus ?? ''),
                  AppTextStyle.bodyS,
                  rightColor: Utils.getDocStatusColor(item?.docStatus ?? ''),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRowText(
    String? left,
    String? right,
    TextStyle style, {
    Color? rightColor,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            left ?? '',
            style: style.copyWith(color: AppColor.neutralDarkDarkest),
          ),
        ),
        Text(
          right ?? '',
          style: style.copyWith(
            color: rightColor ?? AppColor.neutralDarkDarkest,
          ),
        ),
      ],
    );
  }
}

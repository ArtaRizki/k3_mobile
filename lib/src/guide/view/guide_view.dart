import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/empty_list.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/guide/controller/guide_controller.dart';
import 'package:k3_mobile/src/guide/model/guide_model.dart';

import 'package:k3_mobile/component/download.dart';

class GuideView extends GetView<GuideController> {
  GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar.basicAppbar(title: 'Pedoman K3', noBack: true),
      body: SafeArea(
        child: Obx(() {
          return Container(
            color: AppColor.neutralLightLightest,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchBar(),
                _buildGuideTitle(),
                _buildGuideList(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSearchBar() {
    final isSearching = controller.searchC.value.text.isNotEmpty;
    return AppTextField.basicTextField(
      label: '',
      controller: controller.searchC.value,
      hintText: 'Search',
      suffixIconConstraints: BoxConstraints(maxHeight: isSearching ? 23 : 18),
      onChanged: (v) {
        controller.update();
        controller.onSearchChanged();
      },
      textInputAction: TextInputAction.done,
      suffixIcon: InkWell(
        onTap: isSearching ? controller.clearField : null,
        child:
            isSearching
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
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

  Widget _buildGuideTitle() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Text(
        'Daftar pedoman K3',
        style: AppTextStyle.actionL.copyWith(color: AppColor.neutralDarkLight),
      ),
    );
  }

  Widget _buildGuideList() {
    final data = controller.filteredGuides;

    if (data.isEmpty) {
      return EmptyList.textEmptyList(
        minHeight: Get.size.height * .71,
        onRefresh: () async {
          await controller.getData();
          controller.update();
        },
      );
    }

    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.getData();
          controller.update();
        },
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => _buildGuideItem(data[i]),
        ),
      ),
    );
  }

  Widget _buildGuideItem(GuideModelData? item) {
    return AppCard.listCard(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        if (item?.file != null) {
          Get.toNamed(AppRoute.GUIDE_PREVIEW, arguments: item);
        }
      },
      color: AppColor.neutralLightLightest,
      child: Row(
        children: [
          Image.asset(Assets.iconsIcListGuide, width: 52, height: 52),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildGuideHeader(item),
                const SizedBox(height: 3),
                _buildGuideBody(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGuideHeader(GuideModelData? item) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item?.nomor ?? '',
            style: AppTextStyle.bodyS.copyWith(
              color: AppColor.neutralDarkDarkest,
            ),
          ),
        ),
        Text(
          item?.tanggal ?? '',
          style: AppTextStyle.bodyS.copyWith(
            color: AppColor.neutralDarkDarkest,
          ),
        ),
      ],
    );
  }

  Widget _buildGuideBody(GuideModelData? item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            item?.judul ?? '',
            style: AppTextStyle.h5.copyWith(
              color: AppColor.neutralDarkDarkest,
              fontSize: 12,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              item?.kategoriName ?? '',
              style: AppTextStyle.bodyS.copyWith(
                color: AppColor.neutralDarkDarkest,
              ),
            ),
            GestureDetector(
              onTap: () async {
                downloadFile(
                  Get.context!,
                  item?.file ?? '',
                  filename: (item?.file ?? '').split('/').last,
                  typeFile: 'pdf',
                  allowCustomSaveLocation: false,
                );
                // await OpenFile.open(localPdfPath);
              },
              child: Row(
                children: [
                  Image.asset(
                    Assets.iconsIcDownloadGuide,
                    width: 24,
                    height: 24,
                  ),
                  Text(
                    ' Unduh',
                    style: AppTextStyle.bodyS.copyWith(
                      color: AppColor.highlightDarkest,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

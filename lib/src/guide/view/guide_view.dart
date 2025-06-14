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

class GuideView extends GetView<GuideController> {
  GuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar.basicAppbar(title: 'Pedoman K3'),
      body: SafeArea(
        child: Obx(
          () => Container(
            color: AppColor.neutralLightLightest,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppTextField.loginTextField(
                  controller: controller.searchC.value,
                  hintText: 'Search',
                  suffixIconConstraints: BoxConstraints(maxHeight: 18),
                  onChanged: (v) {
                    controller.update();
                  },
                  suffixIcon: GestureDetector(
                    onTap: null,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: Image.asset(
                        Assets.iconsIcSearch,
                        color: AppColor.neutralLightDarkest,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 12),
                  child: Text(
                    'Daftar pedoman K3',
                    textAlign: TextAlign.left,
                    style: AppTextStyle.actionL.copyWith(
                      color: AppColor.neutralDarkLight,
                    ),
                  ),
                ),
                list(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget list() {
    final data = controller.filteredGuides;
    if (data.isEmpty)
      return EmptyList.textEmptyList(
        minHeight: Get.size.height * .71,
        onRefresh: () async {
          controller.update();
        },
      );
    return Expanded(
      child: ListView.separated(
        itemCount: data.length,
        shrinkWrap: true,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (c, i) {
          final item = data[i];
          return AppCard.listCard(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (item?.file != null)
                Get.toNamed(
                  AppRoute.GUIDE_PREVIEW,
                  arguments: item?.file ?? '',
                );
            },
            color: AppColor.neutralLightLightest,
            child: Row(
              children: [
                Image.asset(Assets.iconsIcListGuide, width: 52, height: 52),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
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
                      ),
                      SizedBox(height: 3),
                      Flexible(
                        child: Row(
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
                                Row(
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
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

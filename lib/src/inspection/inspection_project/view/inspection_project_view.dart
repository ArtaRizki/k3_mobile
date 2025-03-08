import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/inspection/inspection_project/controller/inspection_project_controller.dart';
import 'package:k3_mobile/src/main_home/controller/main_home_controller.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';

class InspectionProjectView extends GetView<InspectionProjectController> {
  InspectionProjectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.neutralLightLightest,
        leadingWidth: 72,
        leading: InkWell(
          onTap: () async {
            Get.back();
          },
          child: SizedBox(
            width: 24,
            height: 24,
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Transform.scale(
                scale: 0.5,
                child: Image.asset(
                  Assets.iconsIcArrowBack,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
          ),
        ),
        centerTitle: true,
        title: Text(
          'Inspeksi Proyek',
          style: AppTextStyle.h4.copyWith(
            color: AppColor.neutralDarkLight,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
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
                child: Row(
                  children: [
                    Text(
                      'Data Inspeksi Proyek',
                      textAlign: TextAlign.left,
                      style: AppTextStyle.actionL.copyWith(
                        color: AppColor.neutralDarkLight,
                      ),
                    ),
                    Spacer(),
                    AppCard.basicCard(
                      color: AppColor.highlightDarkest,
                      radius: 20,
                      padding: EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 24,
                      ),
                      child: Text(
                        'Buat baru',
                        style: AppTextStyle.actionL.copyWith(
                          color: AppColor.neutralLightLightest,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 6),
              list(),
            ],
          ),
        ),
      ),
    );
  }

  Widget list() {
    return Expanded(
      child: ListView.separated(
        itemCount: 10,
        shrinkWrap: true,
        separatorBuilder: (_, __) => SizedBox(height: 12),
        itemBuilder: (c, i) {
          return AppCard.listCard(
            onTap: () async {
              FocusManager.instance.primaryFocus?.unfocus();
              Get.toNamed(AppRoute.GUIDE_PREVIEW,
                  arguments:
                      'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf');
            },
            color: AppColor.neutralLightLightest,
            child: Row(
              children: [
                Image.asset(
                  Assets.iconsIcListInspectionProject,
                  width: 52,
                  height: 52,
                ),
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
                              'INS/2025/II/001',
                              style: AppTextStyle.h4.copyWith(
                                color: AppColor.neutralDarkDarkest,
                              ),
                            ),
                          ),
                          Text(
                            '12/02/2025',
                            style: AppTextStyle.bodyM.copyWith(
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
                                'Resiko tinggi',
                                style: AppTextStyle.bodyS.copyWith(
                                  color: AppColor.neutralDarkDarkest,
                                ),
                              ),
                            ),
                            Text(
                              'Unsafe Action',
                              style: AppTextStyle.bodyS.copyWith(
                                color: AppColor.neutralDarkDarkest,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Ruang Meeting Kantor pusat',
                        style: AppTextStyle.bodyS.copyWith(
                          color: AppColor.neutralDarkDarkest,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Jl A. Yani Surabaya',
                        style: AppTextStyle.bodyS.copyWith(
                          color: AppColor.neutralDarkDarkest,
                          fontSize: 12,
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

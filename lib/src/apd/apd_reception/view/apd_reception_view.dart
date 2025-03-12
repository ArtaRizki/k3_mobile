import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/apd/apd_reception/controller/apd_reception_controller.dart';

class ApdReceptionView extends GetView<ApdReceptionController> {
  ApdReceptionView({super.key});

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
          'Penerimaan APD',
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
                      'Data Penerimaan APD',
                      textAlign: TextAlign.left,
                      style: AppTextStyle.actionL.copyWith(
                        color: AppColor.neutralDarkLight,
                      ),
                    ),
                    Spacer(),
                    AppCard.basicCard(
                      onTap: () async {
                        Get.toNamed(AppRoute.APD_RECEPTION_CREATE);
                      },
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
              Get.toNamed(AppRoute.APD_RECEPTION_VIEW);
            },
            color: AppColor.neutralLightLightest,
            child: Row(
              children: [
                Image.asset(
                  Assets.iconsIcListApdReception,
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
                              'ARC/2025/II/021',
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
                                'Unit Kalimantan',
                                style: AppTextStyle.bodyS.copyWith(
                                  color: AppColor.neutralDarkDarkest,
                                ),
                              ),
                            ),
                            Text(
                              controller.statusTxt(i),
                              style: AppTextStyle.actionM.copyWith(
                                color: controller
                                    .statusColor(controller.statusTxt(i)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Deskripsi dokumen',
                        style: AppTextStyle.bodyS.copyWith(
                          color: AppColor.neutralDarkDarkest,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 3),
                      Flexible(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                'ARQ/2025/II/001',
                                textAlign: TextAlign.left,
                                style: AppTextStyle.bodyS.copyWith(
                                  color: AppColor.neutralDarkLightest,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 6,
                              child: Text(
                                '15/02/2025',
                                textAlign: TextAlign.left,
                                style: AppTextStyle.bodyS.copyWith(
                                  color: AppColor.neutralDarkLightest,
                                ),
                              ),
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/empty_list.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_appbar.dart';
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
      appBar: AppAppbar.basicAppbar(title: 'Penerimaan APD'),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: Obx(() {
            final query = controller.searchC.value.text.isNotEmpty;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppTextField.loginTextField(
                  controller: controller.searchC.value,
                  hintText: 'Search',
                  suffixIconConstraints: BoxConstraints(
                    maxHeight: query ? 23 : 18,
                  ),
                  onChanged: (v) {
                    controller.update();
                    controller.onSearchChanged();
                  },
                  suffixIcon: InkWell(
                    onTap: query ? controller.clearField : null,
                    child:
                        query
                            ? Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Icon(
                                Icons.close,
                                color: AppColor.neutralDarkLight,
                              ),
                            )
                            : Padding(
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
            );
          }),
        ),
      ),
    );
  }

  Widget list() {
    return Obx(() {
      final data = controller.filteredApdRec;
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
            itemCount: data.length,
            shrinkWrap: true,
            separatorBuilder: (_, __) => SizedBox(height: 12),
            itemBuilder: (c, i) {
              final item = data[i];
              return AppCard.listCard(
                onTap: () async {
                  FocusManager.instance.primaryFocus?.unfocus();
                  Get.toNamed(
                    AppRoute.APD_RECEPTION_VIEW,
                    arguments: item?.id ?? '',
                  );
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  item?.requestCode ?? '',
                                  style: AppTextStyle.h4.copyWith(
                                    color: AppColor.neutralDarkDarkest,
                                  ),
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                flex: 4,
                                child: Text(
                                  DateFormat('dd/MM/yyyy').format(
                                    DateFormat(
                                      'dd/MM/yyyy',
                                    ).parse(item?.docDate ?? ''),
                                  ),
                                  textAlign: TextAlign.right,
                                  style: AppTextStyle.bodyS.copyWith(
                                    color: AppColor.neutralDarkDarkest,
                                  ),
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
                                    item?.unit ?? '',
                                    style: AppTextStyle.bodyS.copyWith(
                                      color: AppColor.neutralDarkDarkest,
                                    ),
                                  ),
                                ),
                                Text(
                                  item?.status ?? '',
                                  style: AppTextStyle.actionM.copyWith(
                                    color: Utils.getDocStatusColorByName(
                                      item?.status ?? '',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            item?.keterangan ?? '',
                            style: AppTextStyle.bodyS.copyWith(
                              color: AppColor.neutralDarkDarkest,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            (item?.pengeluaranCode ?? '') +
                                '     ' +
                                (item?.docDate ?? ''),
                            textAlign: TextAlign.left,
                            style: AppTextStyle.bodyS.copyWith(
                              color: AppColor.neutralDarkLightest,
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
        ),
      );
    });
  }
}

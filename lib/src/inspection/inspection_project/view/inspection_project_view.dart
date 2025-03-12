import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/component/empty_list.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/const/app_textfield.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/inspection/inspection_project/controller/inspection_project_controller.dart';
import 'package:k3_mobile/src/inspection/inspection_project/model/inspection_project_create_param.dart';

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
          child: Obx(
            () {
              final query = controller.searchC.value.text.isNotEmpty;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  AppTextField.basicTextField(
                    label: '',
                    controller: controller.searchC.value,
                    hintText: 'Search',
                    suffixIconConstraints:
                        BoxConstraints(maxHeight: query ? 23 : 18),
                    onChanged: (v) {
                      controller.update();
                    },
                    suffixIcon: InkWell(
                      onTap: query ? controller.clearField : null,
                      child: query
                          ? Container(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(
                                  Icons.close,
                                  color: AppColor.neutralDarkLight,
                                ),
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
                          'Data Inspeksi Proyek',
                          textAlign: TextAlign.left,
                          style: AppTextStyle.actionL.copyWith(
                            color: AppColor.neutralDarkLight,
                          ),
                        ),
                        Spacer(),
                        AppCard.basicCard(
                          onTap: () async {
                            Get.toNamed(AppRoute.INSPECTION_PROJECT_CREATE);
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
            },
          ),
        ),
      ),
    );
  }

  Widget list() {
    final data = controller.filteredInspections;
    if (data.isEmpty)
      return EmptyList.textEmptyList(
        minHeight: Get.size.height * .71,
        onRefresh: () async {
          controller.update();
        },
      );
    return Expanded(
      child: RefreshIndicator(
        onRefresh: () async {
          controller.update();
        },
        child: ListView.separated(
          itemCount: data.length,
          shrinkWrap: true,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (c, i) {
            final item = data[i];
            return listItem(item);
          },
        ),
      ),
    );
  }

  Widget listItem(InspectionProjectCreateParam item) {
    return AppCard.listCard(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        Get.toNamed(
          AppRoute.INSPECTION_PROJECT_CREATE,
          arguments: item,
        );
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
                        item.projectName,
                        style: AppTextStyle.h4.copyWith(
                          color: AppColor.neutralDarkDarkest,
                        ),
                      ),
                    ),
                    Text(
                      item.date,
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
                          item.risk,
                          style: AppTextStyle.bodyS.copyWith(
                            color: AppColor.neutralDarkDarkest,
                          ),
                        ),
                      ),
                      Text(
                        item.category,
                        style: AppTextStyle.bodyS.copyWith(
                          color: AppColor.neutralDarkDarkest,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  item.location,
                  style: AppTextStyle.bodyS.copyWith(
                    color: AppColor.neutralDarkDarkest,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  item.location,
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
  }
}

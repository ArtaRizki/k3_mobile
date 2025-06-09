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
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_controller.dart';
import 'package:k3_mobile/src/apd/apd_request/model/apd_request_model.dart';

class ApdRequestView extends GetView<ApdRequestController> {
  ApdRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar.basicAppbar(title: 'Permintaan APD'),
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
                _buildSearchField(query),
                _buildHeader(),
                SizedBox(height: 6),
                _buildList(),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSearchField(bool query) {
    return AppTextField.loginTextField(
      controller: controller.searchC.value,
      hintText: 'Search',
      suffixIconConstraints: BoxConstraints(maxHeight: query ? 23 : 18),
      onChanged: (v) {
        controller.update();
      },
      suffixIcon: InkWell(
        onTap: query ? controller.clearField : null,
        child:
            query
                ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 12),
      child: Row(
        children: [
          Text(
            'Data Permintaan APD',
            textAlign: TextAlign.left,
            style: AppTextStyle.actionL.copyWith(
              color: AppColor.neutralDarkLight,
            ),
          ),
          Spacer(),
          AppCard.basicCard(
            onTap: () async {
              Get.toNamed(AppRoute.APD_REQUEST_CREATE);
            },
            color: AppColor.highlightDarkest,
            radius: 20,
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 24),
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

  Widget _buildList() {
    return Obx(() {
      final data = controller.filteredApdReq;
      if (data.isEmpty) {
        return EmptyList.textEmptyList(
          minHeight: Get.size.height * .71,
          onRefresh: () async {
            controller.update();
          },
        );
      }
      return Expanded(
        child: ListView.separated(
          itemCount: data.length,
          shrinkWrap: true,
          separatorBuilder: (_, __) => SizedBox(height: 12),
          itemBuilder: (c, i) {
            final item = data[i];
            return _buildListItem(item, i);
          },
        ),
      );
    });
  }

  Widget _buildListItem(ApdRequestModelData item, int index) {
    return AppCard.listCard(
      onTap: () async {
        FocusManager.instance.primaryFocus?.unfocus();
        Get.toNamed(AppRoute.APD_REQUEST_VIEW, arguments: [index, item]);
      },
      color: AppColor.neutralLightLightest,
      child: Row(
        children: [
          Image.asset(Assets.iconsIcListApdRequest, width: 52, height: 52),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildListItemHeader(item),
                SizedBox(height: 3),
                _buildListItemDetails(item),
                SizedBox(height: 3),
                Text(
                  item.description ?? '',
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

  Widget _buildListItemHeader(ApdRequestModelData item) {
    return Row(
      children: [
        Expanded(
          child: Text(
            item.id ?? '',
            style: AppTextStyle.h4.copyWith(color: AppColor.neutralDarkDarkest),
          ),
        ),
        Text(
          DateFormat(
            'dd/MM/yyyy',
          ).format(DateFormat('dd-MM-yyyy').parse(item.docDate ?? '')),
          style: AppTextStyle.bodyM.copyWith(
            color: AppColor.neutralDarkDarkest,
          ),
        ),
      ],
    );
  }

  Widget _buildListItemDetails(ApdRequestModelData item) {
    return Flexible(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              item.unitName ?? '',
              style: AppTextStyle.bodyS.copyWith(
                color: AppColor.neutralDarkDarkest,
              ),
            ),
          ),
          Text(
            Utils.getDocStatusName(item.docStatus ?? ''),
            style: AppTextStyle.actionM.copyWith(
              color: Utils.getDocStatusColor(item.docStatus ?? ''),
            ),
          ),
        ],
      ),
    );
  }
}

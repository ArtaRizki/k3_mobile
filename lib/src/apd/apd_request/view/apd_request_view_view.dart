import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:k3_mobile/component/utils.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_card.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_controller.dart';
import 'package:k3_mobile/src/apd/apd_request/controller/apd_request_view_controller.dart';

class ApdRequestViewView extends GetView<ApdRequestViewController> {
  ApdRequestViewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppAppbar.basicAppbar(
        title: 'ARQ/2025/II/001',
        centerTitle: false,
        titleSpacing: 0,
        titleStyle: AppTextStyle.h4.copyWith(
          color: AppColor.neutralDarkDarkest,
        ),
        action: _buildActionButtons(),
      ),
      body: SafeArea(
        child: Container(
          color: AppColor.neutralLightLightest,
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ..._buildHeader(),
                ..._buildRequestList(),
                _buildTimeline(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons() {
    final status = controller.viewData.value.data?.docStatus ?? '';
    return [
      if (status == 'Draft')
        _buildActionButton('Ajukan', AppColor.warningDark, () => Get.back()),
      if (status == 'Draft' || status == 'Ditolak')
        _buildActionButton('Edit', AppColor.highlightDarkest, () async {
          Get.toNamed(
            AppRoute.APD_REQUEST_CREATE,
            arguments: [controller.indexData.value, controller.viewData.value],
          );
        }),
      if (status == 'Draft')
        _buildActionButton('Hapus', AppColor.errorDark, () async {
          var c = Get.find<ApdRequestController>();
          await c.deleteApdRequestModel(controller.indexData.value);
          c.update();
          Get.back();
        }),
      SizedBox(width: 18),
    ];
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6),
        child: Text(label, style: AppTextStyle.bodyM.copyWith(color: color)),
      ),
    );
  }

  List<Widget> _buildHeader() {
    final data = controller.viewData.value.data;
    return [
      SizedBox(height: 12),
      _headerItem(
        'Tanggal',
        DateFormat(
          'dd/MM/yyyy',
        ).format(DateFormat('dd-MM-yyyy').parse(data?.docDate ?? '')),
      ),
      SizedBox(height: 9),
      _headerItem('Unit', data?.unitName ?? ''),
      SizedBox(height: 9),
      _headerItem('Keterangan', data?.description ?? ''),
      SizedBox(height: 9),
      _headerItem(
        'Status',
        Utils.getDocStatusName(data?.docStatus ?? ''),
        valueColor: Utils.getDocStatusColor(data?.docStatus ?? ''),
      ),
      SizedBox(height: 31),
    ];
  }

  Widget _headerItem(String title, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style: AppTextStyle.bodyM.copyWith(
              color: AppColor.neutralDarkLight,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value,
            style: AppTextStyle.actionL.copyWith(
              color: valueColor ?? AppColor.neutralDarkDarkest,
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildRequestList() {
    final data = controller.viewData.value.data?.daftarPermintaan ?? [];
    return [
      Text(
        'Daftar permintaan',
        style: AppTextStyle.bodyM.copyWith(color: AppColor.neutralDarkLight),
      ),
      SizedBox(height: 6),
      ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (c, i) {
          final item = data[i];
          return AppCard.listCard(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 6),
            color:
                i % 2 == 0
                    ? AppColor.highlightLightest
                    : AppColor.neutralLightLightest,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _titleSubtitle('Kode', item?.apdId ?? '', 3),
                SizedBox(width: 12),
                _titleSubtitle('Nama', item?.apdName ?? '', 5),
                SizedBox(width: 12),
                _titleSubtitle('Jumlah', '${item?.qty ?? 0}', 2),
              ],
            ),
          );
        },
      ),
    ];
  }

  Widget _titleSubtitle(String title, String subtitle, int flex) {
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.bodyS.copyWith(
              color: AppColor.neutralDarkLightest,
            ),
          ),
          SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyle.bodyM.copyWith(
              color: AppColor.neutralDarkDarkest,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 24),
      padding: EdgeInsets.symmetric(vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Linimasa',
            style: AppTextStyle.bodyM.copyWith(
              color: AppColor.neutralDarkLight,
            ),
          ),
          SizedBox(height: 6),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: List.generate(2, (i) {
                return _timelineItem(
                  '14/02/2025\n14:00',
                  'Permintaan APD diajukan',
                  'Siti',
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(String t1, String t2, String t3) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              t1,
              style: AppTextStyle.bodyS.copyWith(
                color: AppColor.neutralDarkLightest,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              t2,
              style: AppTextStyle.bodyS.copyWith(
                color: AppColor.neutralDarkLightest,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              'oleh: $t3',
              textAlign: TextAlign.center,
              style: AppTextStyle.bodyS.copyWith(
                color: AppColor.neutralDarkLightest,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

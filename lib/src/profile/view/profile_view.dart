import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:k3_mobile/const/app_appbar.dart';
import 'package:k3_mobile/const/app_button.dart';
import 'package:k3_mobile/const/app_color.dart';
import 'package:k3_mobile/const/app_page.dart';
import 'package:k3_mobile/const/app_text_style.dart';
import 'package:k3_mobile/generated/assets.dart';
import 'package:k3_mobile/src/profile/controller/profile_controller.dart';
import 'package:k3_mobile/src/session/controller/session_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.neutralLightLightest,
      appBar: AppAppbar.basicAppbar(title: 'Profil', noBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Obx(() {
            final user = controller.loginModel.value?.data;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAvatar(),
                  _buildProfileItem('Nama', user?.name ?? ''),
                  if (user?.tipeAkunName == 'MKP')
                    _buildProfileItem('Unit', user?.unitName ?? ''),
                  _buildProfileItem('Instansi', user?.instansiName ?? ''),
                  _buildProfileItem('Jabatan', user?.karyawan?.jabatan ?? ''),
                  _buildProfileItem('Tipe Pengguna', user?.tipeAkunName ?? ''),
                  _buildProfileItem('Role', user?.roleName ?? ''),
                ],
              ),
            );
          }),
        ),
      ),
      bottomNavigationBar: _buildLogoutButton(),
    );
  }

  Widget _buildAvatar() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Image.asset(Assets.iconsIcAvatar, width: 88, height: 88),
      ),
    );
  }

  Widget _buildProfileItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyle.bodyS.copyWith(
              color: AppColor.neutralDarkMedium,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: AppTextStyle.bodyS.copyWith(
              color: AppColor.neutralDarkDarkest,
              fontWeight: FontWeight.w900,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return InkWell(
      onTap: () async {
        await Get.find<SessionController>().logout();
        Get.offAllNamed(AppRoute.LOGIN);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 54, vertical: 16),
        child: AppButton.basicButton(
          enable: true,
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: AppColor.neutralLightLightest,
          radius: 30,
          border: Border.all(color: AppColor.errorDark, width: 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.iconsIcLogout, width: 24, height: 24),
              const SizedBox(width: 6),
              Text(
                'Keluar',
                style: AppTextStyle.actionL.copyWith(
                  color: AppColor.errorDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

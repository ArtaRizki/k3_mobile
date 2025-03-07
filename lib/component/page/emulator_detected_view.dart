import 'package:flutter/material.dart';
import 'package:k3_mobile/const/app_color.dart';

class EmulatorDetectedView extends StatelessWidget {
  const EmulatorDetectedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Emulator terdeteksi',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColor.highlightDarkest,
              ),
            ),
            Text('Anda harus menggunakan M-Speed dengan perangkat fisik!')
          ],
        ),
      ),
    );
  }
}

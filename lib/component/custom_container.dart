import 'package:flutter/material.dart';

// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CustomContainer {
  /// main card using container
  static Widget mainCard({
    required BuildContext context,
    required Widget child,
    bool isShadow = true,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    Color? color,
    double? width,
    double? height,
    double? radiusBorder,
    BorderRadius? customBorderRadius,
    DecorationImage? image,
  }) {
    return Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? EdgeInsets.all(12),
      width: width ?? null,
      height: height ?? null,
      decoration: BoxDecoration(
        color: color ??
            (MediaQuery.of(context).platformBrightness == Brightness.dark
                ? Colors.white
                : Colors.grey),
        image: image,
        borderRadius:
            customBorderRadius ?? BorderRadius.circular(radiusBorder ?? 12),
        boxShadow: [
          if (isShadow)
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 1,
              offset: Offset(0, 1), // changes position of shadow
            ),
        ],
      ),
      child: child,
    );
  }

  static Center mainNotFoundImage() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
              "assets/images/main-image-not-found.png",
            ),
            width: 275,
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Data tidak ditemukan!",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  static showModalBottomDraggable({
    required BuildContext context,
    required Widget child,
    double? initialChildSize,
    DraggableScrollableController? controller,
  }) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
            controller: controller ?? DraggableScrollableController(),
            initialChildSize: initialChildSize ?? 0.9,
            minChildSize: 0.1,
            maxChildSize: 0.96,
            expand: false,
            snap: true,
            builder: (context, scrollController) {
              return Container(
                padding: EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 55,
                      height: 3,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    SizedBox(height: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [child],
                    ),
                  ],
                ),
              );
            });
      },
    );
  }

  static showModalBottomScroll({
    required BuildContext context,
    required Widget child,
    double? initialChildSize,
    DraggableScrollableController? controller,
  }) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          controller: controller ?? DraggableScrollableController(),
          initialChildSize: initialChildSize ?? 0.9,
          minChildSize: 0.1,
          maxChildSize: 0.96,
          expand: false,
          snap: true,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(22),
                  topRight: Radius.circular(22),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 55,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                  SizedBox(height: 18),
                  Expanded(child: ListView(children: [child])),
                ],
              ),
            );
          },
        );
      },
    );
  }

  static showModalBottom(
      {required BuildContext context, required Widget child}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
            child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 55,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(22),
                  ),
                ),
                SizedBox(height: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [child],
                ),
              ],
            ),
          ),
        ));
      },
    );
  }

  static showModalBottomCloseButton(
      {required BuildContext context,
      String? title,
      required,
      required Widget child}) async {
    return await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
            child: Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  color: Color(0xff191d29),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          title ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffcb753d),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                            padding: EdgeInsets.all(6),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Color(0xffcb5b51),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [child],
                ),
                Container(
                  color: Color(0xff191d29),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Expanded(
                      //   child: CustomButton.mainButtonWithIcon(
                      //     Icon(Icons.close),
                      //     'Tidak Jadi',
                      //     () => Navigator.pop(context),
                      //   ),
                      // ),
                      // SizedBox(width: 10),
                      // Expanded(
                      //   child: CustomButton.mainButtonWithIcon(
                      //     Icon(
                      //       Icons.send_rounded,
                      //       color: Colors.white,
                      //     ),
                      //     'Cek',
                      //     () => Navigator.pop(context),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}

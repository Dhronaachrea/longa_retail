import 'package:longalottoretail/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:longalottoretail/utility/app_constant.dart';
import 'package:longalottoretail/utility/longa_lotto_pos_color.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class ScannerError extends StatefulWidget {
  BuildContext context;
  MobileScannerException error;

  ScannerError({Key? key, required this.context, required this.error})
      : super(key: key);

  @override
  State<ScannerError> createState() => _ScannerErrorState();
}

class _ScannerErrorState extends State<ScannerError> {
  static const Permission cameraPermission = Permission.camera;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: LongaLottoPosColor.game_color_black,
      child: widget.error.errorCode.name == "genericError" ||
              widget.error.errorCode.name == "permissionDenied"
          ? Center(
              child: InkWell(
                  onTap: () async {
                    showCustomDialog(context);
                  },
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "assets/icons/alert.png",
                          width: 30,
                          height: 30,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          context.l10n.reload,
                          style: const TextStyle(
                              color: LongaLottoPosColor.white, fontSize: 24),
                        ),
                      ],
                    ),
                  )),
            )
          : Text(widget.error.errorCode.name.toString()),
    );
  }

  Future<void> _requestPermission(context) async {
    var status = await cameraPermission.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  void showCustomDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            context.l10n.need_camera_permission,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: noirFont,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              child: Text(context.l10n.ok,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: noirFont,
                    fontWeight: FontWeight.w500,
                  )),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                _requestPermission(context);
              },
            )
          ],
        );
      },
    );
  }
}

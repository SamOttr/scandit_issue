import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scandit_issue/scandit/utils/scandit_type.dart';

class ScanTypeButtonWidget extends StatelessWidget {
  const ScanTypeButtonWidget(
      this.iconPath, {
        Key? key,
        required this.onPressed,
        required this.selectedScanType,
        required this.scanType,
      }) : super(key: key);

  final String iconPath;
  final VoidCallback onPressed;
  final ScanditType scanType;
  final ScanditType selectedScanType;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            selectedScanType == scanType
                ? const Color.fromRGBO(10, 178, 34, 1)
                : const Color.fromRGBO(51, 51, 51, 1),
          ),
        ),
        onPressed: selectedScanType == scanType ? null : onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
          child: SvgPicture.asset(
            iconPath,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
            width: 38,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:permission_handler/permission_handler.dart'
as permission_handler show openAppSettings;
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_issue/components/rounded_button_widget.dart';
import 'package:scandit_issue/components/scan_type_button_widget.dart';
import 'package:scandit_issue/scandit/services/scandit_service.dart';
import 'package:scandit_issue/scandit/utils/scandit_type.dart';

class ScanditPage extends StatefulWidget {
  const ScanditPage({
    Key? key,
    required ScanditService scanditService,
    RegExp? scanRegex,
  })  : _scanditService = scanditService,
        super(key: key);

  final ScanditService _scanditService;

  @override
  State<ScanditPage> createState() => _ScanditPageState();
}

class _ScanditPageState extends State<ScanditPage> with WidgetsBindingObserver {
  bool canDisplayScan = false;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    checkPermission();
  }

  @override
  void deactivate() {
    widget._scanditService.dispose();
    super.deactivate();
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _paused) {
      _paused = false;
      await checkPermission();
    } else if (state == AppLifecycleState.paused) {
      _paused = true;
      await widget._scanditService.disableScan();
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: canDisplayScan
            ? Stack(
          children: [
            widget._scanditService.captureView,
            Positioned(
              top: 16,
              right: 16,
              child: SafeArea(
                child: RoundedButtonWidget(
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: _torchWidget(),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 260,
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(
                      height: 24,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ScanTypeButtonWidget(
                          'assets/icons/auto_scan.svg',
                          onPressed: () async {
                            await widget._scanditService
                                .switchScanningMode(
                              ScanditType.scanditBasic,
                            );
                            setState(() {});
                          },
                          selectedScanType:
                          widget._scanditService.selectedScanType!,
                          scanType: ScanditType.scanditBasic,
                        ),
                        ScanTypeButtonWidget(
                          'assets/icons/manual_scan.svg',
                          onPressed: () async {
                            await widget._scanditService.switchScanningMode(
                              ScanditType.scanditSelection,
                            );
                            setState(() {});
                          },
                          selectedScanType:
                          widget._scanditService.selectedScanType!,
                          scanType: ScanditType.scanditSelection,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        )
            : const Center(
          child: CircularProgressIndicator(
            color: Colors.green,
          ),
        ),
      ),
    );
  }

  Future<void> checkPermission() async {
    var status = await Permission.camera.status;

    if (status.isDenied) {
      status = await Permission.camera.request();
    }

    switch (status) {
      case PermissionStatus.restricted:
      case PermissionStatus.limited:
      case PermissionStatus.granted:
      case PermissionStatus.provisional:
        await widget._scanditService.enableScan();
        break;
      case PermissionStatus.denied:
        await Future.microtask(() {
          showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Permissions denied'),
                content: const Text('You need to authorize camera permissions'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      checkPermission();
                    },
                    child: const Text('Ok'),
                  )
                ],
              );
            },
          );
        });
        break;
      case PermissionStatus.permanentlyDenied:
        await Future.microtask(() {
          showDialog<void>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Permissions permanently denied'),
                content: const Text(
                  'You need to authorize camera from app settings',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      permission_handler.openAppSettings();
                    },
                    child: const Text('Ok'),
                  )
                ],
              );
            },
          );
        });
        break;
    }

    setState(() {
      canDisplayScan = !status.isPermanentlyDenied && !status.isDenied;
    });
  }

  Widget _torchWidget() {
    return SafeArea(
      child: RawMaterialButton(
        onPressed: () async {
          widget._scanditService.torchState == TorchState.on
              ? await widget._scanditService.disableTorch()
              : await widget._scanditService.enableTorch();

          setState(() {});
        },
        fillColor: Colors.black.withOpacity(0.2),
        padding: const EdgeInsets.all(15),
        shape: const CircleBorder(),
        child: _getFlashIcon(),
      ),
    );
  }

  Widget _getFlashIcon() {
    switch (widget._scanditService.torchState) {
      case TorchState.on:
        return const Icon(
          Icons.flash_on,
          color: Colors.white,
        );
      case TorchState.off:
        return const Icon(
          Icons.flash_off,
          color: Colors.white,
        );
      case TorchState.auto:
        return const Icon(
          Icons.flash_auto,
          color: Colors.white,
        );
    }
  }
}

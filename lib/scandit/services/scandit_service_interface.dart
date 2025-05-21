import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

abstract class ScanditServiceInterface {
  DataCaptureView get captureView;

  void init();

  Future<void> enableScan();

  Future<void> disableScan();

  Future<void> dispose();

  Future<void> addOverlay();

  Future<void> removeOverlay();
}

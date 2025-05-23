import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';

abstract class ScanditServiceInterface {
  DataCaptureView get captureView;

  TorchState get torchState;

  Future<void> init();

  Future<void> enableScan();

  Future<void> disableScan();

  Future<void> zoom({required double zoomFactor});

  Future<void> dispose();

  Future<void> addOverlay();

  Future<void> removeOverlay();

  Future<void> enableTorch();

  Future<void> disableTorch();
}

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_capture.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_issue/scandit/services/scandit_service_interface.dart';

class ScanditBasicService extends ScanditServiceInterface
    implements BarcodeCaptureListener {
  ScanditBasicService(this._captureView);

  final DataCaptureView _captureView;

  late BarcodeCapture _barcodeCapture;
  late Camera? _camera;
  late final CameraSettings _basicCameraSettings;

  BarcodeCaptureOverlay? _overlay;
  TorchState _torchState = TorchState.off;

  @override
  TorchState get torchState {
    return _torchState;
  }

  final _settings = BarcodeCaptureSettings()
    ..enableSymbologies({
      Symbology.ean8,
      Symbology.ean13Upca,
      Symbology.code128,
      Symbology.code39,
      Symbology.upce,
    })
    ..codeDuplicateFilter = const Duration(seconds: 1);

  @override
  Future<void> init() async {
    _barcodeCapture =
    BarcodeCapture.forContext(DataCaptureContext.sharedInstance, _settings)
      ..isEnabled = false;

    _basicCameraSettings = BarcodeCapture.recommendedCameraSettings
      ..preferredResolution = VideoResolution.fullHd;
    _camera = Camera.defaultCamera;

    if (_camera != null) {
      await _camera!.applySettings(_basicCameraSettings);
      await DataCaptureContext.sharedInstance.setFrameSource(_camera!);
    }
  }

  @override
  Future<void> enableScan() async {
    _barcodeCapture
      ..addListener(this)
      ..isEnabled = true;
    await DataCaptureContext.sharedInstance.setMode(_barcodeCapture);
    await addOverlay();
    await _camera!.switchToDesiredState(FrameSourceState.on);
  }

  @override
  Future<void> disableScan() async {
    await DataCaptureContext.sharedInstance.removeCurrentMode();
    _barcodeCapture
      ..isEnabled = false
      ..removeListener(this);
    await disableTorch();
    await _camera?.switchToDesiredState(FrameSourceState.off);
    await removeOverlay();
  }

  @override
  Future<void> didScan(
      BarcodeCapture barcodeCapture,
      BarcodeCaptureSession session,
      Future<FrameData> Function() getFrameData,
      ) async {
    final code = session.newlyRecognizedBarcode;
    print("BASIC SERVICE - SCANNED ${code?.data}");
  }

  @override
  Future<void> didUpdateSession(
      BarcodeCapture barcodeCapture,
      BarcodeCaptureSession session,
      Future<FrameData> Function() getFrameData,
      ) async {}

  @override
  Future<void> dispose() async {
    if (await isEnable()) {
      await disableScan();
    }
  }

  Future<bool> isEnable() async {
    final currentState = await _camera?.currentState;
    return _barcodeCapture.isEnabled || currentState != FrameSourceState.off;
  }

  @override
  DataCaptureView get captureView => _captureView;

  @override
  Future<void> addOverlay() async {
    _overlay ??= BarcodeCaptureOverlay.withBarcodeCaptureForView(
      _barcodeCapture,
      captureView,
    )..viewfinder = RectangularViewfinder.withStyleAndLineStyle(
      RectangularViewfinderStyle.square,
      RectangularViewfinderLineStyle.light,
    );
    await _captureView.addOverlay(_overlay!);
  }

  @override
  Future<void> removeOverlay() async {
    await _captureView.removeOverlay(_overlay!);
  }

  @override
  Future<void> zoom({required double zoomFactor}) async {
    _basicCameraSettings.zoomFactor = zoomFactor;
    await _camera?.applySettings(_basicCameraSettings);
    await DataCaptureContext.sharedInstance.setFrameSource(_camera!);
  }

  @override
  Future<void> enableTorch() async {
    final isAvailable = await _camera!.isTorchAvailable;
    _torchState = TorchState.on;
    if (isAvailable) _camera!.desiredTorchState = _torchState;
  }

  @override
  Future<void> disableTorch() async {
    final isAvailable = await _camera!.isTorchAvailable;
    _torchState = TorchState.off;
    if (isAvailable) _camera!.desiredTorchState = _torchState;
  }
}

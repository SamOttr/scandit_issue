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
  late final CameraSettings _selectionCameraSettings;
  late final BarcodeCaptureOverlay _overlay;

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
  void init() {
    _barcodeCapture =
    BarcodeCapture.forContext(DataCaptureContext.sharedInstance, _settings)
      ..isEnabled = false;

    _basicCameraSettings = BarcodeCapture.recommendedCameraSettings
      ..preferredResolution = VideoResolution.fullHd;
    _selectionCameraSettings = BarcodeCapture.recommendedCameraSettings
      ..preferredResolution = VideoResolution.fullHd;
    _camera = Camera.defaultCamera;

    if (_camera != null) {
      _camera!.applySettings(_basicCameraSettings);
      DataCaptureContext.sharedInstance.setFrameSource(_camera!);

      _overlay = BarcodeCaptureOverlay.withBarcodeCaptureForView(
        _barcodeCapture,
        captureView,
      )..viewfinder = RectangularViewfinder.withStyleAndLineStyle(
        RectangularViewfinderStyle.square,
        RectangularViewfinderLineStyle.light,
      );
    }
  }

  @override
  Future<void> enableScan() async {
    await DataCaptureContext.sharedInstance.setMode(_barcodeCapture);
    await addOverlay();
    _barcodeCapture
      ..addListener(this)
      ..isEnabled = true;
    await _camera!.switchToDesiredState(FrameSourceState.on);
  }

  @override
  Future<void> disableScan() async {
    await DataCaptureContext.sharedInstance.removeCurrentMode();
    _barcodeCapture
      ..isEnabled = false
      ..removeListener(this);
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
    print("---------- [BASIC SERVICE] SCANNED BARCODE : ${code?.data} ---------");
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
      disableScan();
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
    await _captureView.addOverlay(_overlay);
  }

  @override
  Future<void> removeOverlay() async {
    await _captureView.removeOverlay(_overlay);
  }
}

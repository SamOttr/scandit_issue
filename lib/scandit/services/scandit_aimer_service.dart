import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode_selection.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_issue/scandit/services/scandit_service_interface.dart';

class ScanditAimerService extends ScanditServiceInterface
    implements BarcodeSelectionListener {
  ScanditAimerService(this._captureView);

  final DataCaptureView _captureView;

  late BarcodeSelection _barcodeSelection;
  late Camera? _camera;
  late BarcodeSelectionSettings _settings;
  late final CameraSettings _selectionCameraSettings;

  BarcodeSelectionBasicOverlay? _overlay;
  TorchState _torchState = TorchState.off;

  @override
  TorchState get torchState {
    return _torchState;
  }

  @override
  Future<void> init() async {
    final selection = BarcodeSelectionAimerSelection()
      ..selectionStrategy = BarcodeSelectionManualSelectionStrategy();
    _settings = BarcodeSelectionSettings()
      ..enableSymbologies({
        Symbology.ean8,
        Symbology.ean13Upca,
        Symbology.code128,
        Symbology.code39,
        Symbology.upce,
      })
      ..selectionType = selection
      ..codeDuplicateFilter = const Duration(seconds: 1);

    _barcodeSelection = BarcodeSelection.forContext(
      DataCaptureContext.sharedInstance,
      _settings,
    )..isEnabled = false;

    _selectionCameraSettings = BarcodeSelection.recommendedCameraSettings;
    _camera = Camera.defaultCamera;
    if (_camera != null) {
      await _camera!.applySettings(_selectionCameraSettings);
      await DataCaptureContext.sharedInstance.setFrameSource(_camera!);
    }
  }

  @override
  Future<void> enableScan() async {
    _barcodeSelection
      ..addListener(this)
      ..isEnabled = true;
    await DataCaptureContext.sharedInstance.setMode(_barcodeSelection);
    await addOverlay();
    await _camera!.switchToDesiredState(FrameSourceState.on);
  }

  @override
  Future<void> disableScan() async {
    await DataCaptureContext.sharedInstance.removeCurrentMode();
    _barcodeSelection
      ..isEnabled = false
      ..removeListener(this);
    await disableTorch();
    await _camera?.switchToDesiredState(FrameSourceState.off);
    await removeOverlay();
  }

  @override
  Future<void> didUpdateSelection(
      BarcodeSelection barcodeSelection,
      BarcodeSelectionSession session,
      Future<FrameData?> Function() getFrameData,
      ) async {
    final barcode = session.newlySelectedBarcodes;
    print("AIMER SERVICE - SCANNED $barcode");
  }

  @override
  Future<void> didUpdateSession(
      BarcodeSelection barcodeSelection,
      BarcodeSelectionSession session,
      Future<FrameData?> Function() gextFrameData,
      ) async {}

  @override
  Future<void> dispose() async {}

  @override
  DataCaptureView get captureView => _captureView;

  @override
  Future<void> addOverlay() async {
    _overlay ??= BarcodeSelectionBasicOverlay.withBarcodeSelectionForView(
      _barcodeSelection,
      _captureView,
    );
    await _captureView.addOverlay(_overlay!);
  }

  @override
  Future<void> removeOverlay() async {
    await _captureView.removeOverlay(_overlay!);
  }

  @override
  Future<void> zoom({required double zoomFactor}) async {
    _selectionCameraSettings.zoomFactor = zoomFactor;
    await _camera?.applySettings(_selectionCameraSettings);
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

import 'package:scandit_flutter_datacapture_barcode/scandit_flutter_datacapture_barcode.dart';
import 'package:scandit_flutter_datacapture_core/scandit_flutter_datacapture_core.dart';
import 'package:scandit_issue/scandit/services/scandit_aimer_service.dart';
import 'package:scandit_issue/scandit/services/scandit_basic_service.dart';
import 'package:scandit_issue/scandit/services/scandit_service_interface.dart';
import 'package:scandit_issue/scandit/utils/scandit_config.dart';
import 'package:scandit_issue/scandit/utils/scandit_type.dart';

class ScanditService {
  ScanditService._({required ScanditConfig scanditConfig})
      : _scanditConfig = scanditConfig;

  static ScanditService? _instance;

  static ScanditService? get instance {
    return _instance;
  }

  static Future<ScanditService> init(ScanditConfig scanditConfig) async {
    _instance = ScanditService._(scanditConfig: scanditConfig);
    await _instance?.initialize();

    return _instance!;
  }

  final ScanditConfig _scanditConfig;

  ScanditType? selectedScanType;

  late ScanditServiceInterface _service;
  late ScanditBasicService _basicService;
  late ScanditAimerService _aimerService;
  late DataCaptureView _captureView;

  DataCaptureView get captureView {
    return _captureView;
  }

  TorchState get torchState {
    return _service.torchState;
  }

  Future<void> initialize() async {
    await ScanditFlutterDataCaptureBarcode.initialize();
    await DataCaptureContext.initialize(_scanditConfig.scanditkey);

    _captureView = DataCaptureView.forContext(
      DataCaptureContext.sharedInstance,
    );

    _basicService = ScanditBasicService(_captureView);
    await _basicService.init();

    _aimerService = ScanditAimerService(_captureView);
    await _aimerService.init();

    selectedScanType = selectedScanType ?? ScanditType.scanditBasic;
    _service = selectedScanType == ScanditType.scanditBasic
        ? _basicService
        : _aimerService;
  }

  Future<void> dispose() async {
    zoom(zoomFactor: 1);
    await disableTorch();
    await _service.dispose();
  }

  Future<void> switchScanningMode(ScanditType type) async {
    await disableScan();

    selectedScanType = type;
    _service =
    (type == ScanditType.scanditBasic) ? _basicService : _aimerService;

    await enableScan();
  }

  Future<void> enableScan() async {
    await _service.enableScan();
  }

  Future<void> disableScan() async {
    await _service.disableScan();
  }

  void zoom({required double zoomFactor}) {
    _service.zoom(zoomFactor: zoomFactor);
  }

  Future<void> enableTorch() async {
    await _service.enableTorch();
  }

  Future<void> disableTorch() async {
    await _service.disableTorch();
  }
}

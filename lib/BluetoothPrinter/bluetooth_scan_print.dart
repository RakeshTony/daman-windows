import 'dart:io';
import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:daman/BluetoothPrinter/testprint.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import '../../DataBeans/ReprintResponseDataModel.dart';
import '../../Database/hive_boxes.dart';
import '../../Database/models/default_config.dart';
import '../../Theme/colors.dart';
import '../../Utils/Widgets/app_bar_common_widget.dart';
import '../../Utils/Widgets/custom_button.dart';
import '../../Utils/app_log.dart';
import '../DataBeans/BulkOrderResponseDataModel.dart';
import '../Routes/routes.dart';
import '../Utils/app_action.dart';
import '../main.dart';

class BluetoothScanPrintPage extends StatelessWidget {
  final List<VoucherDenomination> data;
  String dId;
  String opInst;

  BluetoothScanPrintPage(
      {required this.data, required this.dId, required this.opInst});

  @override
  Widget build(BuildContext context) {
    return BluetoothScanPrintBody(
      data: data,
      dId: dId,
      opInst: opInst,
    );
  }
}

class BluetoothScanPrintBody extends StatefulWidget {
  final List<VoucherDenomination> data;
  String dId = "";
  String opInst = "";

  BluetoothScanPrintBody(
      {required this.data, required this.dId, required this.opInst});

  @override
  _BluetoothScanPrintState createState() => new _BluetoothScanPrintState();
}

class _BluetoothScanPrintState extends State<BluetoothScanPrintBody> {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;
  List<BluetoothDevice> _mDeviceConnected =
      List<BluetoothDevice>.empty(growable: true);

  bool? isOn = false;

  late BluetoothDevice _device;
  bool _connected = false;
  late String pathImage;
  late GetPrint getPrint;
  var config = HiveBoxes.getDefaultConfig();

  DefaultConfig? getConfig() {
    return config.values.isNotEmpty ? config.values.first : null;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initSavetoPath();
    getPrint = GetPrint();
  }

  initSavetoPath() async {
    //read and write
    //image max 300px X 300px
    final filename = 'logo.png';
    var bytes = await rootBundle.load("assets/logo.png");
    String dir = (await getApplicationDocumentsDirectory()).path;
    writeToFile(bytes, '$dir/$filename');
    setState(() {
      pathImage = '$dir/$filename';
      AppLog.e("Image Path", pathImage);
    });
  }

  Future<void> initPlatformState() async {
    bluetooth.isOn.then((value) {
      isOn = value;
      setState(() {});
    });
    await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      // TODO - Error
    }
    if (!mounted) return;
    setState(() {
      _mDeviceConnected.clear();
      _mDeviceConnected.addAll(devices);
    });
    bluetooth.onStateChanged().listen((state) {
      switch (state) {
        case BlueThermalPrinter.CONNECTED:
          setState(() {
            _connected = true;
            print("bluetooth device state: connected");
          });
          break;
        case BlueThermalPrinter.DISCONNECTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnected");
          });
          break;
        case BlueThermalPrinter.DISCONNECT_REQUESTED:
          setState(() {
            _connected = false;
            print("bluetooth device state: disconnect requested");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning off");
          });
          break;
        case BlueThermalPrinter.STATE_OFF:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth off");
          });
          break;
        case BlueThermalPrinter.STATE_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth on");
          });
          break;
        case BlueThermalPrinter.STATE_TURNING_ON:
          setState(() {
            _connected = false;
            print("bluetooth device state: bluetooth turning on");
          });
          break;
        case BlueThermalPrinter.ERROR:
          setState(() {
            _connected = false;
            print("bluetooth device state: error");
          });
          break;
        default:
          print(state);
          break;
      }
    });
  }

  itemDeviceWidget(BluetoothDevice device) {
    AppLog.e("DEVICE", device);
    AppLog.e("PrintData", widget.dId + " : " + widget.opInst);
    return InkWell(
      onTap: () {
        _connect(device);
      },
      child: ListTile(
        title: Text(device.name ?? ""),
        subtitle: Text(device.address ?? ""),
        trailing: Icon(
            (mPreference.value.defaultBluetoothPrinter ==
                    (device.address ?? ""))
                ? Icons.radio_button_on
                : Icons.radio_button_off,
            size: 24,
            color: kMainColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var mConfig = getConfig();
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Bluetooth Printers"),
          backgroundColor: kMainColor,
        ),
        // appBar: AppBar(),
        backgroundColor: kScreenBackground,
        body: isOn ?? false
            ? Stack(
                children: [
                  Container(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _mDeviceConnected.length,
                      itemBuilder: (context, index) =>
                          itemDeviceWidget(_mDeviceConnected[index]),
                      separatorBuilder: (context, index) => Divider(
                        height: 1,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isProgressBar,
                    child: Align(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator()),
                  )
                ],
              )
            : Center(child: Text("Please Turn ON Bluetooth")),
        bottomNavigationBar: Visibility(
          visible: mPreference.value.defaultBluetoothPrinter.isNotEmpty,
          child: CustomButton(
            text: "Get Print",
            onPressed: () async {
              AppLog.e("PrintData", widget.dId + " : " + widget.opInst);
              await getPrint.doPrint(
                  pathImage, widget.data, mConfig, widget.dId, widget.opInst);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  var isProgressBar = false;

  void _connect(BluetoothDevice device) async {
    isProgressBar = true;
    setState(() {});
    if (await bluetooth.isConnected ?? false) await bluetooth.disconnect();
    bluetooth.connect(device).then((value) {
      mPreference.value.defaultBluetoothPrinter =
          (value ?? false) ? device.address : "";
      isProgressBar = false;
      setState(() {});
      AppAction.showGeneralErrorMessage(context, "Printer  connected");
    }).catchError((onError) {
      AppLog.e("PRINTER-ERROR", onError);
      mPreference.value.defaultBluetoothPrinter = "";
      isProgressBar = false;
      setState(() {});
      AppAction.showGeneralErrorMessage(context, "Printer not connected");
    });
  }

//write to app path
  Future<void> writeToFile(ByteData data, String path) {
    final buffer = data.buffer;
    return new File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }
}

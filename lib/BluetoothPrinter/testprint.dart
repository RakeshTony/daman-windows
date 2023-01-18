import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/services.dart';
import '../DataBeans/BulkOrderResponseDataModel.dart';
import '../Utils/app_encoder.dart';
import '../main.dart';
import 'package:http/http.dart' as http;

class GetPrint {
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  Future doPrint(String pathImage, List<VoucherDenomination> reprintData,
      var mConfig, String deviceId, String opInst) async {
    //SIZE
    // 0- normal size text
    // 1- only bold text
    // 2- bold with medium text
    // 3- bold with large text
    //ALIGN
    // 0- ESC_ALIGN_LEFT
    // 1- ESC_ALIGN_CENTER
    // 2- ESC_ALIGN_RIGHT

    /*var url = Uri.https('https://evd.miza.ly', '/img/Operators/Small/62642d303120923042022184536.png', {'q': '{http}'});
     var response = await http.get(url);
     Uint8List bytes = response.bodyBytes;*/
    await bluetooth.isConnected.then((isConnected) async {
      if (isConnected ?? false) {
        for (int index = 0; index < reprintData.length; index++) {
          var item = reprintData[index];
          await bluetooth.printImage(pathImage);
          //await bluetooth.printImageBytes(bytes);
          await bluetooth.printCustom("${mConfig?.website}", 1, 1);
          await bluetooth.printCustom("Customer Care:", 1, 1);
          await bluetooth.printCustom("Email: ${mConfig?.email}", 1, 1);
          await bluetooth.printCustom("Telephone: ${mConfig?.contactNo}", 1, 1);
          await bluetooth.printCustom("WhatsApp: ${mConfig?.whatsAppNo}", 1, 1);
          await bluetooth.printCustom("-------------------------------", 1, 1);
          await bluetooth.printCustom(item.denominationTitle, 2, 1);
          await bluetooth.printCustom(
              "Customer Receipt   " + item.batchNumber, 1, 1);
          await bluetooth.printCustom("-------------------------------", 1, 1);
          await bluetooth.printNewLine();
          await bluetooth.printLeftRight("Amount: ", item.decimalValue, 1);
          await bluetooth.printLeftRight(
              "PIN ", Encoder.decodeDefault(item.pinNumber), 2);
          await bluetooth.printCustom(opInst, 1, 1, charset: "utf-8");
          await bluetooth.printCustom("-------------------------------", 1, 1);
          await bluetooth.printLeftRight("Serial ", item.serialNumber, 1);
          await bluetooth.printLeftRight("TxnID ", item.orderNumber, 1);
          await bluetooth.printLeftRight("Expiry ", item.expiryDate, 1);
          await bluetooth.printCustom("-------------------------------", 1, 1);
          await bluetooth.printLeftRight(
              "Sold By ", "${mPreference.value.userData.name}", 1);
          await bluetooth.printCustom("Date        " + item.assignedDate, 1, 1);
          await bluetooth.printLeftRight("Terminal ", deviceId, 1);
        }
        await bluetooth.printNewLine();
        await bluetooth.printNewLine();
        await bluetooth.paperCut();
      }
    });
  }
}

import 'package:flutter/material.dart';
import 'package:daman/DataBeans/RemitaCustomFieldModel.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';

class DialogMultiplePicker extends StatefulWidget {
  List<RemitaCustomFieldOptionModel> data;
  List<RemitaCustomFieldOptionModel> selected;
  final bool isCancelable;

  DialogMultiplePicker(this.data,
      this.selected, {
        this.isCancelable = true,
      });

  @override
  State<DialogMultiplePicker> createState() => _DialogMultiplePickerState();
}

class _DialogMultiplePickerState extends State<DialogMultiplePicker> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => widget.isCancelable,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListView.separated(
                shrinkWrap: true,
                itemCount: widget.data.length,
                itemBuilder: (context, index) {
                  var item = widget.data[index];
                  return ListTile(
                    onTap: () {
                      if (widget.selected.contains(item)) {
                        widget.selected.remove(item);
                      } else {
                        widget.selected.add(item);
                      }
                      setState(() {});
                    },
                    leading: Icon(widget.selected.contains(item)
                        ? Icons.check_box
                        : Icons.check_box_outline_blank),
                    title: Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: kMainColor,
                        fontFamily: RFontFamily.SOFIA_PRO,
                        fontWeight: RFontWeight.MEDIUM,
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(onPressed: () {
                    Navigator.pop(context, widget.selected);
                  }, child: Text("OK"))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

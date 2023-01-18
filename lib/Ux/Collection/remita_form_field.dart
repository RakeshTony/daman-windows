import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_extensions.dart';
import 'package:daman/Utils/app_file_utils.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/Utils/pair.dart';
import 'package:daman/Ux/Dialog/dialog_multiple_picker.dart';

import '../../DataBeans/RemitaCustomFieldModel.dart';

class RemitaFormField extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RemitaFormField();
  }
}

class _RemitaFormField extends State<RemitaFormField> {
  List<Widget> fields = List<Widget>.empty(growable: true);

  getFormField() async {
    var items = await getRemitaCustomFields();
    AppLog.e("DATA", items);
    items.forEach((e) {
      switch (e.columnType) {
        case "D":
          fields.add(WidgetFormDateField(fieldModel: e));
          break;
        case "SL":
          fields.add(WidgetFormSpinnerMultiSelectField(fieldModel: e));
          break;
        case "DD":
          fields.add(WidgetFormSpinnerField(fieldModel: e));
          break;
        default:
          {
            fields.add(WidgetFormTextField(fieldModel: e));
          }
      }
    });
    setState(() {});
  }

  @override
  void initState() {
    getFormField();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kScreenBackground,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: fields,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                AppLog.i("HELLO");
                var error = "";
                var params = List<Pair<String, dynamic>>.empty(growable: true);
                for (var index = 0; index < fields.length; index++) {
                  Widget field = fields[index];
                  if (field is WidgetFormTextField) {
                    error = field.getErrorMessage();
                    params.add(field.getKeyValue());
                  } else if (field is WidgetFormDateField) {
                    error = field.getErrorMessage();
                    params.add(field.getKeyValue());
                  } else if (field is WidgetFormSpinnerMultiSelectField) {
                    error = field.getErrorMessage();
                    params.add(field.getKeyValue());
                  } else if (field is WidgetFormSpinnerField) {
                    error = field.getErrorMessage();
                    params.add(field.getKeyValue());
                  }
                  if (error.isNotEmpty) {
                    break;
                  }
                }
                if (error.isNotEmpty) {
                  AppAction.showGeneralErrorMessage(context, error);
                } else {}
              },
              child: Text("Continue"),
            )
          ],
        ),
      ),
    );
  }
}

class WidgetFormTextField extends StatefulWidget {
  final RemitaCustomFieldModel fieldModel;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  WidgetFormTextField({required this.fieldModel});

  String getErrorMessage() {
    AppLog.e("getErrorMessage", fieldModel.required);
    if (fieldModel.required) {
      AppLog.i("fieldModel.required");
      var txt = textEditingController.text.toString();
      if (txt.isEmpty) return "Please Enter ${fieldModel.columnName}";
      if (txt.length > fieldModel.columnLength)
        return "${fieldModel.columnName} max length allow (${fieldModel.columnLength})";
    }
    return "";
  }

  Pair<String, dynamic> getKeyValue() {
    return Pair(fieldModel.id, textEditingController.text);
  }

  @override
  State<WidgetFormTextField> createState() => _WidgetFormTextFieldState();
}

class _WidgetFormTextFieldState extends State<WidgetFormTextField> {
  TextInputType getKeyboardType(String type) {
    AppLog.e("FIELD TYPE", type);
    switch (type) {
      case "A": // Alphabets
        return TextInputType.text;
      case "AN": // Alphanumeric
        return TextInputType.text;
      case "N": // Numeric
        return TextInputType.number;

      case "D": // Date
        return TextInputType.text;

      case "DD": // Single select item list (no price/amount)
        return TextInputType.text;
      case "SL": // Multi select item list (no price/amount)
        return TextInputType.text;
      case "SP": // Multi select item list with price and amount
        return TextInputType.text;
      default: // ALL -  Any value
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: TextFormField(
        /*Enable true by rakesh*/
        enableInteractiveSelection: true,
        key: widget.key,
        maxLength: widget.fieldModel.columnLength <= 0
            ? 100
            : widget.fieldModel.columnLength,
        buildCounter: (BuildContext context,
                {int? currentLength, int? maxLength, bool? isFocused}) =>
            null,
        focusNode: widget.focusNode,
        keyboardType: getKeyboardType(widget.fieldModel.columnType),
        inputFormatters: [
          FilteringTextInputFormatter.singleLineFormatter,
          if (widget.fieldModel.columnType == "A")
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
          if (widget.fieldModel.columnType == "N")
            FilteringTextInputFormatter.digitsOnly,
          if (widget.fieldModel.columnType == "AN")
            FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
        ],
        controller: widget.textEditingController,
        style: AppStyleText.inputFiledPrimaryText,
        decoration: InputDecoration(
          hintText: widget.fieldModel.columnName +
              " ( ${widget.fieldModel.columnType} )",
          hintStyle: AppStyleText.inputFiledPrimaryHint,
          isDense: true,
          filled: true,
          contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          fillColor: Colors.transparent,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kTextInputInactive),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: kMainButtonColor),
          ),
        ),
      ),
    );
  }
}

class WidgetFormDateField extends StatefulWidget {
  final RemitaCustomFieldModel fieldModel;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();

  WidgetFormDateField({required this.fieldModel});

  String getErrorMessage() {
    AppLog.e("getErrorMessage", fieldModel.required);
    if (fieldModel.required) {
      AppLog.i("fieldModel.required");
      var txt = textEditingController.text.toString();
      if (txt.isEmpty) return "Please Pick ${fieldModel.columnName}";
      if (txt.length > fieldModel.columnLength)
        return "${fieldModel.columnName} max length allow (${fieldModel.columnLength})";
    }
    return "";
  }

  Pair<String, dynamic> getKeyValue() {
    return Pair(fieldModel.id, textEditingController.text);
  }

  @override
  State<WidgetFormDateField> createState() => _WidgetFormDateFieldState();
}

class _WidgetFormDateFieldState extends State<WidgetFormDateField> {
  DateTime? mSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var dateTime = await _pickDate(context);
        mSelected = dateTime;
        widget.textEditingController.text = mSelected?.getDate() ?? "";
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        child: AbsorbPointer(
          child: TextFormField(
            /*Enable true by rakesh*/
            enableInteractiveSelection: true,
            key: widget.key,
            maxLength: widget.fieldModel.columnLength <= 0
                ? 100
                : widget.fieldModel.columnLength,
            buildCounter: (BuildContext context,
                    {int? currentLength, int? maxLength, bool? isFocused}) =>
                null,
            focusNode: widget.focusNode,
            keyboardType: TextInputType.datetime,
            readOnly: true,
            inputFormatters: [
              FilteringTextInputFormatter.singleLineFormatter,
              FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s")),
              FilteringTextInputFormatter.allow(RegExp(r'[0-9-\\]')),
            ],
            controller: widget.textEditingController,
            style: AppStyleText.inputFiledPrimaryText,
            decoration: InputDecoration(
              hintText: widget.fieldModel.columnName +
                  " ( ${widget.fieldModel.columnType} )",
              hintStyle: AppStyleText.inputFiledPrimaryHint,
              isDense: true,
              filled: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
              fillColor: Colors.transparent,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kTextInputInactive),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: kMainButtonColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<DateTime?> _pickDate(BuildContext context) {
    return showDatePicker(
      context: context,
      initialDate: mSelected ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(),
          child: child ??
              Container(
                width: 0,
                height: 0,
              ),
        );
      },
    );
  }
}

class WidgetFormSpinnerMultiSelectField extends StatefulWidget {
  final RemitaCustomFieldModel fieldModel;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<RemitaCustomFieldOptionModel> selected =
      List<RemitaCustomFieldOptionModel>.empty(growable: true);

  WidgetFormSpinnerMultiSelectField({required this.fieldModel});

  String getErrorMessage() {
    AppLog.e("getErrorMessage", fieldModel.required);
    if (fieldModel.required) {
      AppLog.i("fieldModel.required");
      if (selected.isEmpty)
        return "Please Pick at least ${fieldModel.columnName}";
    }
    return "";
  }

  Pair<String, dynamic> getKeyValue() {
    return Pair(fieldModel.id, selected);
  }

  @override
  State<WidgetFormSpinnerMultiSelectField> createState() =>
      _WidgetFormSpinnerMultiSelectFieldState();
}

class _WidgetFormSpinnerMultiSelectFieldState
    extends State<WidgetFormSpinnerMultiSelectField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: () async {
            var dialog = DialogMultiplePicker(
                widget.fieldModel.customFieldDropDown, widget.selected);
            var result = await showDialog(
                context: context, builder: (context) => dialog);
            setState(() {});
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: AbsorbPointer(
              child: TextFormField(
                /*Enable true by rakesh*/
                enableInteractiveSelection: true,
                key: widget.key,
                maxLength: widget.fieldModel.columnLength <= 0
                    ? 100
                    : widget.fieldModel.columnLength,
                buildCounter: (BuildContext context,
                        {int? currentLength,
                        int? maxLength,
                        bool? isFocused}) =>
                    null,
                focusNode: widget.focusNode,
                keyboardType: TextInputType.none,
                readOnly: true,
                inputFormatters: [
                  FilteringTextInputFormatter.singleLineFormatter,
                  FilteringTextInputFormatter.deny(new RegExp(r"\s\b|\b\s")),
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9-\\]')),
                ],
                controller: widget.textEditingController,
                style: AppStyleText.inputFiledPrimaryText,
                decoration: InputDecoration(
                    hintText: widget.fieldModel.columnName +
                        " ( ${widget.fieldModel.columnType} )",
                    hintStyle: AppStyleText.inputFiledPrimaryHint,
                    isDense: true,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 0, vertical: 12),
                    fillColor: Colors.transparent,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kTextInputInactive),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: kMainButtonColor),
                    ),
                    suffixIcon: Icon(Icons.arrow_drop_down)),
              ),
            ),
          ),
        ),
        Container(
          width: double.maxFinite,
          padding: EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Wrap(
            direction: Axis.horizontal,
            alignment: WrapAlignment.start,
            spacing: 6,
            runSpacing: 0,
            children: List<Widget>.generate(widget.selected.length,
                (index) => _buildChip(widget.selected[index])),
          ),
        )
      ],
    );
  }

  Widget _buildChip(RemitaCustomFieldOptionModel item) {
    return Chip(
      label: Text(
        item.description,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      deleteIcon: Icon(Icons.cancel),
      deleteIconColor: Colors.red,
      onDeleted: () {
        if (widget.selected.contains(item)) {
          widget.selected.remove(item);
          setState(() {});
        }
      },
      backgroundColor: kMainColor,
      elevation: 2,
      padding: EdgeInsets.symmetric(horizontal: 8),
    );
  }
}

class WidgetFormSpinnerField extends StatefulWidget {
  final RemitaCustomFieldModel fieldModel;
  TextEditingController textEditingController = TextEditingController();
  FocusNode focusNode = FocusNode();
  RemitaCustomFieldOptionModel? selected;

  WidgetFormSpinnerField({required this.fieldModel});

  String getErrorMessage() {
    AppLog.e("getErrorMessage", fieldModel.required);
    if (fieldModel.required) {
      AppLog.i("fieldModel.required");
      if (selected == null) return "Please Select ${fieldModel.columnName}";
    }
    return "";
  }

  Pair<String, dynamic> getKeyValue() {
    return Pair(fieldModel.id, selected);
  }

  @override
  State<WidgetFormSpinnerField> createState() => _WidgetFormSpinnerFieldState();
}

class _WidgetFormSpinnerFieldState extends State<WidgetFormSpinnerField> {
  RemitaCustomFieldOptionModel? optionDefault;
  var items = List<RemitaCustomFieldOptionModel>.empty(growable: true);

  @override
  Widget build(BuildContext context) {
    if (optionDefault == null)
      optionDefault = RemitaCustomFieldOptionModel(
          description: "${widget.fieldModel.columnName}");
    if (widget.selected == null) {
      widget.selected = optionDefault;
    }
    if (items.isEmpty) {
      items.add(widget.selected!);
      items.addAll(widget.fieldModel.customFieldDropDown);
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12),
      margin: EdgeInsets.only(top: 12, left: 16, right: 16),
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: kTextInputInactive),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<RemitaCustomFieldOptionModel>(
          value: widget.selected,
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 24,
          elevation: 16,
          isDense: true,
          style: AppStyleText.inputFiledPrimaryText,
          onChanged: (data) {
            setState(() {
              widget.selected = data!;
              setState(() {});
            });
          },
          items: items.map<DropdownMenuItem<RemitaCustomFieldOptionModel>>(
              (RemitaCustomFieldOptionModel value) {
            return DropdownMenuItem<RemitaCustomFieldOptionModel>(
              value: value,
              child: Text(value.description),
            );
          }).toList(),
        ),
      ),
    );
  }
}

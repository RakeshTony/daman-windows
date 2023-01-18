import 'dart:typed_data';

import 'package:collection/src/iterable_extensions.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/preferences_handler.dart';
import 'package:daman/Ux/Profile/ViewModel/view_model_profile.dart';
import 'package:daman/main.dart';
import 'package:flutter/material.dart';
import 'package:image_cropping/image_cropping.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import '../../../Utils/app_decorations.dart';

class DialogProfile extends StatefulWidget {
  @override
  State<DialogProfile> createState() => _DialogProfileState();
}

class _DialogProfileState
    extends BasePageState<DialogProfile, ViewModelProfile> {
  FilePickerCross? filePickerCross;

  Uint8List? _mSelectedProfilePicture;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  FocusNode _usernameNode = FocusNode();
  FocusNode _nameNode = FocusNode();
  FocusNode _emailNode = FocusNode();
  FocusNode _mobileNode = FocusNode();
  FocusNode _addressNode = FocusNode();

  List<CountryData> countries = [];
  CountryData? _countrySelected;

  @override
  void initState() {
    super.initState();
    var user = mPreference.value.userData;
    _usernameController.text = user.username;
    _nameController.text = user.name;
    _emailController.text = user.email;
    _mobileController.text = user.mobile;
    _addressController.text = user.address;

    countries =
        HiveBoxes.getCountries().values.map((e) => e.toCountryData).toList();
    if (_countrySelected == null && countries.isNotEmpty) {
      var selected = countries.firstWhereOrNull(
          (element) => element.id.endsWith(AppSettings.COUNTRY_ID));
      if (selected == null)
        _countrySelected = countries.first;
      else
        _countrySelected = selected;
      setState(() {});
    }
    viewModel.validationErrorStream.listen((map) {
      if (mounted) {
        AppAction.showGeneralErrorMessage(context, map.toString());
      }
    }, cancelOnError: false);

    viewModel.responseStream.listen((map) {
      if (map.getStatus) {
        mPreference.value.userData = map.userData;
        if (mounted) {
          setState(() {});
          AppAction.showGeneralErrorMessage(context, map.getMessage);
        }
      }
    }, cancelOnError: false);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: 480,
            minWidth: 480,
          ),
          decoration: BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kTitleBackground, width: 2)),
          child: ValueListenableBuilder(
            valueListenable: mPreference,
            builder: (context, PreferencesHandler data, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 100,
                    child: Stack(
                      children: [
                        Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12)),
                            gradient: BUTTON_GRADIENT,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: InkWell(
                                  child: Icon(Icons.close,
                                      size: 16, color: kWhiteColor),
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: 80,
                            height: 80,
                            child: Stack(
                              children: [
                                AppImage(
                                  _mSelectedProfilePicture != null
                                      ? _mSelectedProfilePicture
                                      : data.userData.icon,
                                  80,
                                  defaultImage: DEFAULT_PERSON,
                                  isMemory: _mSelectedProfilePicture != null,
                                  borderWidth: 2,
                                ),
                                InkWell(
                                  onTap: () {
                                    _selectFile(context);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 5),
                                    child: Align(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: kWhiteColor,
                                          size: 16,
                                        ),
                                        decoration: BoxDecoration(
                                          color: kColor_2,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${data.userData.name}",
                    style: title().copyWith(fontSize: 16),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InputFieldWidget.text(
                    "Enter full name",
                    labelHint: "Full Name",
                    margin: EdgeInsets.only(top: 14, left: 18, right: 18),
                    textEditingController: _nameController,
                    focusNode: _nameNode,
                  ),
                  InputFieldWidget.number(
                    "Enter mobile number",
                    labelHint: "Mobile Number",
                    margin: EdgeInsets.only(top: 14, left: 18, right: 18),
                    textEditingController: _mobileController,
                    focusNode: _mobileNode,
                    maxLength: _countrySelected?.mobileNumberLength,
                  ),
                  InputFieldWidget.email(
                    "Enter email address",
                    labelHint: "Email Address",
                    margin: EdgeInsets.only(top: 14, left: 18, right: 18),
                    textEditingController: _emailController,
                    focusNode: _emailNode,
                  ),
                  InputFieldWidget.text(
                    "Enter address",
                    labelHint: "Address",
                    margin: EdgeInsets.only(top: 14, left: 18, right: 18),
                    textEditingController: _addressController,
                    focusNode: _addressNode,
                  ),
                  InkWell(
                    onTap: () {
                      viewModel.requestProfileUpdate(
                          _nameController,
                          _mobileController,
                          _emailController,
                          _addressController,
                          imageMemory: _mSelectedProfilePicture);
                    },
                    child: Container(
                      margin: EdgeInsets.all(48),
                      padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: BUTTON_GRADIENT,
                        borderRadius: BorderRadius.all(Radius.circular(34.0)),
                      ),
                      child: Text(
                        "Save",
                        style: Theme.of(context).textTheme.button!.copyWith(
                            fontWeight: RFontWeight.REGULAR, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _selectFile(context) {
    FilePickerCross.importFromStorage(type: FileTypeCross.image)
        .then((filePicker) {
      var imageBytes = filePicker.toUint8List();
      ImageCropping.cropImage(
        context: context,
        imageBytes: imageBytes,
        onImageDoneListener: (data) {
          setState(
            () {
              _mSelectedProfilePicture = data;
            },
          );
        },
        selectedImageRatio: CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
        visibleOtherAspectRatios: false,
        squareBorderWidth: 2,
        isConstrain: false,
        squareCircleColor: kMainColor,
        defaultTextColor: kWhiteColor,
        selectedTextColor: kWhiteColor,
        colorForWhiteSpace: kWhiteColor,
        makeDarkerOutside: true,
        outputImageFormat: OutputImageFormat.jpg,
        encodingQuality: 60,
      );
    });
  }

  BoxDecoration decoration = BoxDecoration(
    gradient: BUTTON_GRADIENT,
    borderRadius: BorderRadius.all(
      Radius.circular(12),
    ),
  );

  TextStyle title() {
    return TextStyle(
        color: kWhiteColor,
        fontSize: 13,
        fontWeight: RFontWeight.SEMI_BOLD,
        fontFamily: RFontFamily.POPPINS);
  }
}

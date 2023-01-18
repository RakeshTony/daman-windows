import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Ux/Dialog/dialog_image_picker.dart';
import 'package:daman/Ux/Profile/ViewModel/view_model_profile.dart';
import 'package:daman/main.dart';

class KYCPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return KYCBody();
  }
}

class KYCBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _KYCBodyState();
}

enum ImageType {
  ID_CARD_FRONT,
  ID_CARD_BACK,
  VOTER_ID_FRONT,
  VOTER_ID_BACK,
  PAN
}

class _KYCBodyState extends BasePageState<KYCBody, ViewModelProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _mSelectedPan;
  File? _mSelectedIdCardFront;
  File? _mSelectedIdCardBack;
  File? _mSelectedVoterIdFront;
  File? _mSelectedVoterIdBack;

  @override
  void initState() {
    super.initState();
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

  Future<Null> _doPickImage(ImageSource source, ImageType type) async {
    XFile? pickedImage =
        await _picker.pickImage(source: source, imageQuality: 50);
    if (pickedImage != null) {
      File? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          aspectRatioPresets: Platform.isAndroid
              ? [
                  CropAspectRatioPreset.square,
                ]
              : [
                  CropAspectRatioPreset.square,
                ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: kMainColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
            title: 'Cropper',
          ));
      if (croppedFile != null) {
        if (type == ImageType.PAN) {
          _mSelectedPan = croppedFile;
        } else if (type == ImageType.ID_CARD_FRONT) {
          _mSelectedIdCardFront = croppedFile;
        } else if (type == ImageType.ID_CARD_BACK) {
          _mSelectedIdCardBack = croppedFile;
        } else if (type == ImageType.VOTER_ID_FRONT) {
          _mSelectedVoterIdFront = croppedFile;
        } else if (type == ImageType.VOTER_ID_BACK) {
          _mSelectedVoterIdBack = croppedFile;
        }
        if (mounted) setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);
    var cardWidth = (mediaQuery.size.width - 48) / 2;
    return Scaffold(
      appBar: AppBarCommonWidget(),
      backgroundColor: kScreenBackground,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: theme.primaryColor,
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "KYC Verification",
                    style: TextStyle(
                        fontSize: 14,
                        color: kWhiteColor,
                        fontWeight: RFontWeight.LIGHT,
                        fontFamily: RFontFamily.POPPINS),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Identity Card",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kMainTextColor,
                                    fontWeight: RFontWeight.LIGHT,
                                    fontFamily: RFontFamily.POPPINS),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Approved",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kTextAmountCR,
                                    fontWeight: RFontWeight.LIGHT,
                                    fontFamily: RFontFamily.POPPINS),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: cardWidth,
                              decoration: _getBoxDecoration(),
                              child: AspectRatio(
                                aspectRatio: 16 / 10,
                                child: Stack(
                                  children: [
                                    _mSelectedIdCardFront != null
                                        ? _getViewImage(_mSelectedIdCardFront!)
                                        : _getViewUpload(
                                            ImageType.ID_CARD_FRONT),
                                    _getViewEdit(ImageType.ID_CARD_FRONT,
                                        visible: _mSelectedIdCardFront != null),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: cardWidth,
                              decoration: _getBoxDecoration(),
                              child: AspectRatio(
                                aspectRatio: 16 / 10,
                                child: Stack(
                                  children: [
                                    _mSelectedIdCardBack != null
                                        ? _getViewImage(_mSelectedIdCardBack!)
                                        : _getViewUpload(ImageType.ID_CARD_BACK,
                                            isBack: true),
                                    _getViewEdit(ImageType.ID_CARD_BACK,
                                        visible: _mSelectedIdCardBack != null),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Voter ID Card",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kMainTextColor,
                                    fontWeight: RFontWeight.LIGHT,
                                    fontFamily: RFontFamily.POPPINS),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pending",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kMainButtonColor,
                                    fontWeight: RFontWeight.LIGHT,
                                    fontFamily: RFontFamily.POPPINS),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: cardWidth,
                              decoration: _getBoxDecoration(),
                              child: AspectRatio(
                                aspectRatio: 16 / 10,
                                child: Stack(
                                  children: [
                                    _mSelectedVoterIdFront != null
                                        ? _getViewImage(_mSelectedVoterIdFront!)
                                        : _getViewUpload(
                                            ImageType.VOTER_ID_FRONT),
                                    _getViewEdit(ImageType.VOTER_ID_FRONT,
                                        visible:
                                            _mSelectedVoterIdFront != null),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            Container(
                              width: cardWidth,
                              decoration: _getBoxDecoration(),
                              child: AspectRatio(
                                aspectRatio: 16 / 10,
                                child: Stack(
                                  children: [
                                    _mSelectedVoterIdBack != null
                                        ? _getViewImage(_mSelectedVoterIdBack!)
                                        : _getViewUpload(
                                            ImageType.VOTER_ID_BACK,
                                            isBack: true),
                                    _getViewEdit(ImageType.VOTER_ID_BACK,
                                        visible: _mSelectedVoterIdBack != null),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                  ),
                  Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pan Card",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kMainTextColor,
                                    fontWeight: RFontWeight.LIGHT,
                                    fontFamily: RFontFamily.POPPINS),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Pending",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: kMainButtonColor,
                                    fontWeight: RFontWeight.LIGHT,
                                    fontFamily: RFontFamily.POPPINS),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Container(
                              width: cardWidth,
                              decoration: _getBoxDecoration(),
                              child: AspectRatio(
                                aspectRatio: 16 / 10,
                                child: Stack(
                                  children: [
                                    _mSelectedPan != null
                                        ? _getViewImage(_mSelectedPan!)
                                        : _getViewUpload(ImageType.PAN),
                                    _getViewEdit(ImageType.PAN,
                                        visible: _mSelectedPan != null)
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(16),
                  ),
                  CustomButton(
                    text: "Update",
                    margin: EdgeInsets.only(
                        top: 16, left: 18, right: 18, bottom: 24),
                    radius: BorderRadius.all(Radius.circular(34.0)),
                    onPressed: () {
                      /* viewModel.requestProfileUpdate(
                          _nameController,
                          _mobileController,
                          _emailController,
                          _addressController,
                          _mSelectedProfilePicture);*/
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Coming Soon..."),
                      ));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getViewImage(File file) {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(6)),
        child: Image.file(file, fit: BoxFit.fill),
      ),
    );
  }

  _getViewUpload(ImageType type, {bool isBack = false}) {
    return InkWell(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 36,
              color: kMainTextColor,
            ),
            Text(
              isBack ? "Upload Back Image" : "Upload Front Image",
              style: TextStyle(color: kMainTextColor, fontSize: 10),
            )
          ],
        ),
      ),
      onTap: () {
        imagePicker(type);
      },
    );
  }

  _getViewEdit(ImageType type, {bool visible = false}) {
    return Visibility(
      visible: visible,
      child: InkWell(
        onTap: () {
          imagePicker(type);
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              padding: EdgeInsets.all(6),
              child: Icon(
                Icons.edit_outlined,
                color: kWhiteColor,
                size: 14,
              ),
              decoration: BoxDecoration(
                color: kMainButtonColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _getBoxDecoration() {
    return BoxDecoration(
        color: kWhiteColor, borderRadius: BorderRadius.all(Radius.circular(6)));
  }

  void imagePicker(ImageType type) {
    var dialogImagePicker = DialogImagePicker(
      (source) {
        _doPickImage(source, type);
      },
    );
    showDialog(
      context: context,
      builder: (context) => dialogImagePicker,
    );
  }
}

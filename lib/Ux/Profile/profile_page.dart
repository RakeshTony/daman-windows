import 'dart:io';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Locale/locales.dart';
import 'package:daman/Routes/routes.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_family.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/Widgets/AppImage.dart';
import 'package:daman/Utils/Widgets/app_bar_common_widget.dart';
import 'package:daman/Utils/Widgets/custom_button.dart';
import 'package:daman/Utils/Widgets/input_field_widget.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_icons.dart';
import 'package:daman/Utils/app_settings.dart';
import 'package:daman/Utils/app_style_text.dart';
import 'package:daman/Ux/Dialog/dialog_country_picker.dart';
import 'package:daman/Ux/Dialog/dialog_error.dart';
import 'package:daman/Ux/Dialog/dialog_image_picker.dart';
import 'package:daman/Ux/Profile/ViewModel/view_model_profile.dart';
import 'package:daman/main.dart';

import '../../Utils/app_decorations.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ProfileBody();
  }
}

class ProfileBody extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends BasePageState<ProfileBody, ViewModelProfile> {
  final ImagePicker _picker = ImagePicker();
  File? _mSelectedProfilePicture;
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

  Future<Null> _doPickImage(ImageSource source) async {
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
        _mSelectedProfilePicture = croppedFile;
        if (mounted) setState(() {});
      }
    }
  }

  bool imageConstraint(File image) {
    if (!['png', 'jpg', 'jpeg']
        .contains(image.path.split('.').last.toString())) {
      var dialog = DialogError(
          title: "Image format should be jpg/jpeg/png.",
          actionText: "Continue",
          onActionTap: () {});
      showDialog(context: context, builder: (context) => dialog);
      return false;
    }
    if (image.lengthSync() > 100000) {
      var dialog = DialogError(
          title: "Error Uploading!",
          actionText: "Continue",
          onActionTap: () {});
      showDialog(context: context, builder: (context) => dialog);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var theme = Theme.of(context);
    var mediaQuery = MediaQuery.of(context);

    return Container(
      decoration: decorationBackground,
      child: Scaffold(
        appBar: AppBarCommonWidget(),
        backgroundColor: kTransparentColor,
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 48,
                color: kTitleBackground,
                padding: EdgeInsets.only(left: 16, right: 0, top: 8, bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        child: Text(
                          AppLocalizations.of(context)!.profile!,
                          style: TextStyle(
                              fontSize: 14,
                              color: kWhiteColor,
                              fontWeight: RFontWeight.LIGHT,
                              fontFamily: RFontFamily.POPPINS),
                        )),
                    Visibility(
                      visible: mPreference.value.userData.isKycVerified == "1"
                          ? true
                          : false,
                      child: Container(
                        width: 120,
                        height: 36,
                        child: CustomButton(
                          text: "KYC",
                          radius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          padding: 0,
                          style: TextStyle(
                              fontFamily: RFontFamily.POPPINS,
                              fontWeight: RFontWeight.LIGHT,
                              fontSize: 14,
                              color: kWhiteColor),
                          onPressed: () {
                            /*ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("Coming Soon..."),
                        ));*/
                            Navigator.pushNamed(context, PageRoutes.kyc);
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: Stack(
                                children: [
                                  AppImage(
                                    _mSelectedProfilePicture != null
                                        ? _mSelectedProfilePicture!.path
                                        : mPreference.value.userData.icon,
                                    80,
                                    defaultImage: DEFAULT_PERSON,
                                    isFile: _mSelectedProfilePicture != null,
                                    borderWidth: 2,
                                    borderColor: kWhiteColor,
                                  ),
                                  Padding(
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
                                          color: kMainColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onTap: () {
                              var dialogImagePicker = DialogImagePicker(
                                (source) {
                                  _doPickImage(source);
                                },
                              );
                              showDialog(
                                  context: context,
                                  builder: (context) => dialogImagePicker);
                            },
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${mPreference.value.userData.name}",
                                  style: TextStyle(
                                      color: kWhiteColor,
                                      fontSize: 16,
                                      fontWeight: RFontWeight.REGULAR),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${mPreference.value.userData.mobile}",
                                  style: TextStyle(
                                      color: kTextColor3,
                                      fontSize: 12,
                                      fontWeight: RFontWeight.REGULAR),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "${mPreference.value.userData.email}",
                                  style: TextStyle(
                                      color: kTextColor3,
                                      fontSize: 12,
                                      fontWeight: RFontWeight.LIGHT),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    InputFieldWidget.text(
                      "Username",
                      margin: EdgeInsets.only(top: 14, left: 18, right: 18),
                      textEditingController: _usernameController,
                      focusNode: _usernameNode,
                      readOnly: true,
                    ),
                    InputFieldWidget.text(
                      "Full Name",
                      margin: EdgeInsets.only(top: 14, left: 18, right: 18),
                      textEditingController: _nameController,
                      focusNode: _nameNode,
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 14, left: 18, right: 18),
                      child: Stack(
                        children: [
                          InputFieldWidget.number(
                            locale.mobileNumber ?? "",
                            padding: EdgeInsets.only(
                                top: 16, right: 0, left: 0, bottom: 16),
                            textEditingController: _mobileController,
                            focusNode: _mobileNode,
                            maxLength: _countrySelected?.mobileNumberLength,
                          ),
                          Visibility(
                            visible: false,
                            child: InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 16),
                                child: Text(
                                  "+${_countrySelected?.phoneCode}",
                                  style: AppStyleText.inputFiledPrimaryText,
                                ),
                              ),
                              onTap: () {
                                var dialogCountryPicker = DialogCountryPicker(
                                  data: countries,
                                  onTap: (country) {
                                    _countrySelected = country;
                                    setState(() {});
                                  },
                                );
                                showDialog(
                                    context: context,
                                    builder: (context) => dialogCountryPicker);
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                    InputFieldWidget.email(
                      "Email Address",
                      margin: EdgeInsets.only(top: 14, left: 18, right: 18),
                      textEditingController: _emailController,
                      focusNode: _emailNode,
                    ),
                    InputFieldWidget.text(
                      "Address",
                      margin: EdgeInsets.only(top: 14, left: 18, right: 18),
                      textEditingController: _addressController,
                      focusNode: _addressNode,
                    ),
                    CustomButton(
                      text: AppLocalizations.of(context)!.submit!,
                      margin: EdgeInsets.only(
                          top: 16, left: 18, right: 18, bottom: 24),
                      radius: BorderRadius.all(Radius.circular(34.0)),
                      onPressed: () {
                        viewModel.requestProfileUpdate(
                            _nameController,
                            _mobileController,
                            _emailController,
                            _addressController,
                            image: _mSelectedProfilePicture);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

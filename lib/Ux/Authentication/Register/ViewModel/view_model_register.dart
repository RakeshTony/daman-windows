import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/DataBeans/CountryDataModel.dart';
import 'package:daman/DataBeans/DefaultDataModel.dart';
import 'package:daman/DataBeans/DistrictDataModel.dart';
import 'package:daman/DataBeans/StateDataModel.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/countries.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_encoder.dart';

class ViewModelRegister extends BaseViewModel {
  final StreamController<String> _validationErrorStreamController =
      StreamController();

  Stream<String> get validationErrorStream =>
      _validationErrorStreamController.stream;

  final StreamController<DefaultDataModel> _responseStreamController =
      StreamController();

  Stream<DefaultDataModel> get responseStream =>
      _responseStreamController.stream;

  final StreamController<List<CountryData>> _countriesStreamController =
      StreamController();

  Stream<List<CountryData>> get countriesStream =>
      _countriesStreamController.stream;

  final StreamController<List<StateData>> _stateStreamController =
  StreamController();

  Stream<List<StateData>> get stateStream => _stateStreamController.stream;
  final StreamController<List<DistrictData>> _districtStreamController =
  StreamController();

  Stream<List<DistrictData>> get districtStream =>
      _districtStreamController.stream;


  @override
  void disposeStream() {
    _validationErrorStreamController.close();
    _responseStreamController.close();
    _countriesStreamController.close();
    _stateStreamController.close();
    _districtStreamController.close();
    super.disposeStream();
  }

  void requestCountries() {
    final box = HiveBoxes.getCountries();
    if (box.values.isEmpty) {
      request(
        networkRequest.getCountries(),
        (map) {
          CountryDataModel dataModel = CountryDataModel();
          dataModel.parseData(map);
          var countries = dataModel.countries.map((element) {
            return element.toCountry;
          }).toList();
          box.addAll(countries);
          _countriesStreamController.sink.add(dataModel.countries);
        },
        errorType: ErrorType.BANNER,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      var countries = box.values.map((e) => e.toCountryData).toList();
      _countriesStreamController.sink.add(countries);
    }
  }

  void requestRegister(
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController mobileController,
      TextEditingController passwordController,
      TextEditingController passwordConfirmController,
      String countryId,
      String stateId,
      String districtId) async {
    String _name = nameController.text.trim();
    String _email = emailController.text.trim();
    String _mobile = mobileController.text.trim();
    String _password = passwordController.text.trim();
    String _passwordConfirm = passwordConfirmController.text.trim();
    String _error = _validateUserDetails( stateId, districtId,
        _name, _email, _mobile, _password, _passwordConfirm, countryId);

    if (_error.isEmpty) {
      HashMap<String, dynamic> requestMap = HashMap();
      requestMap["name"] = Encoder.encode(_name);
      requestMap["password"] = Encoder.encode(_password);
      requestMap["email"] = Encoder.encode(_email);
      requestMap["mobile"] = Encoder.encode(_mobile);
      requestMap["country_id"] = Encoder.encode(countryId);
      requestMap["state_id"] = Encoder.encode(stateId);
      requestMap["city_id"] = Encoder.encode(districtId);
      request(
        networkRequest.registerUser(requestMap),
        (map) {
          DefaultDataModel dataModel = DefaultDataModel();
          dataModel.parseData(map);
          _responseStreamController.sink.add(dataModel);
        },
        errorType: ErrorType.POPUP,
        requestType: RequestType.NON_INTERACTIVE,
      );
    } else {
      _validationErrorStreamController.sink.add(_error);
    }
  }

  String _validateUserDetails(String stateId,
      String districtId,String name, String email, String mobile,
      String password, String confirm, String phoneCode) {
    if (stateId.isEmpty)
    return "Please Choose State";
    else if (districtId.isEmpty)
    return "Please Choose Local Governance";
    else  if (name.isEmpty)
      return "Please Enter Name";
    else if (email.isEmpty)
      return "Please Enter Email";
    else if (phoneCode.isEmpty)
      return "Please Choose Country";
    else if (mobile.isEmpty)
      return "Please Enter Mobile Number";
    else if (password.isEmpty)
      return "Please Enter Password";
    else if (confirm.isEmpty)
      return "Please Enter Confirm Password";
    else if (!confirm.endsWith(password))
      return "Password Not Match";
    else
      return "";
  }
  void requestStateList(String countryId) {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["country_id"] = Encoder.encode(countryId);
    request(
      networkRequest.getStateList(requestMap),
          (map) {
        StateDataModel dataModel = StateDataModel();
        dataModel.parseData(map);
        _stateStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.BANNER,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

  void requestDistrictList(String stateId) {
    HashMap<String, dynamic> requestMap = HashMap();
    requestMap["state_id"] = Encoder.encode(stateId);
    request(
      networkRequest.getCitiesList(requestMap),
          (map) {
        DistrictDataModel dataModel = DistrictDataModel();
        dataModel.parseData(map);
        _districtStreamController.sink.add(dataModel.data);
      },
      errorType: ErrorType.BANNER,
      requestType: RequestType.NON_INTERACTIVE,
    );
  }

}

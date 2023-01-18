import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:daman/BaseClasses/base_view_model.dart';
import 'package:daman/BaseClasses/view_model_provider.dart';
import 'package:daman/Database/hive_boxes.dart';
import 'package:daman/Database/models/push_notification.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_error_type.dart';
import 'package:daman/Utils/Enum/enum_request_type.dart';
import 'package:daman/Utils/app_action.dart';
import 'package:daman/Utils/app_log.dart';
import 'package:daman/Utils/app_request_code.dart';
import 'package:daman/Utils/app_request_key.dart';
import 'package:daman/Utils/app_string.dart';
import 'package:daman/Ux/Dialog/dialog_error.dart';
import 'package:daman/Ux/Dialog/dialog_progress.dart';
import 'package:daman/main.dart';

abstract class BasePageState<T extends StatefulWidget, V extends BaseViewModel>
    extends State<T> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @protected
  Color setStatusBarColor = kMainColor;

  @protected
  String progressBarTitle = AppString.loading;

  @protected
  String? errorMessage;

  @protected
  bool showProgressBar = false;

  @protected
  late V viewModel;

  DialogProgress? _dialogProgress;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: setStatusBarColor));
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    viewModel = ViewModelProvider.instance().getViewModel();

    viewModel.errorStream.listen((map) {
      AppLog.e("ERROR ${AppRequestKey.RESPONSE_CODE}",
          map[AppRequestKey.RESPONSE_CODE]);
      AppLog.e(
          "ERROR ${AppRequestKey.ERROR_TYPE}", map[AppRequestKey.ERROR_TYPE]);
      AppLog.e("ERROR ${AppRequestKey.RESPONSE_MSG}",
          map[AppRequestKey.RESPONSE_MSG]);
      if (mounted) {
        errorMessage = null;
        if (_dialogProgress != null) {
          _dialogProgress?.dismiss();
          _dialogProgress = null;
        }

        switch (map[AppRequestKey.RESPONSE_CODE]) {
          case AppRequestCode.SERVICE_UNAVAILABLE:
            break;
          case AppRequestCode.FORCE_UPDATE:
            break;
          case AppRequestCode.FORCE_LOGOUT:
            break;
          case AppRequestCode.UNAUTHORIZED:
            showDialog(
              context: context,
              builder: (context) => DialogError(
                title: map[AppRequestKey.RESPONSE_MSG],
                actionText: AppString.login_now,
                onActionTap: () {
                  mPreference.value.clear();
                  Phoenix.rebirth(context);
                },
              ),
            );
            break;
          default:
            switch (map[AppRequestKey.ERROR_TYPE]) {
              case ErrorType.POPUP:
                showDialog(
                  context: context,
                  builder: (context) => DialogError(
                    title: map[AppRequestKey.RESPONSE_MSG],
                    actionText: AppString.ok,
                  ),
                );
                break;
              case ErrorType.BANNER:
                AppAction.showGeneralErrorMessage(
                    context, map[AppRequestKey.RESPONSE_MSG]);
                break;
              case ErrorType.NONE:
                errorMessage = map[AppRequestKey.RESPONSE_MSG];
                break;
            }
        }
      }
    }, cancelOnError: false);

    viewModel.requestTypeStream.listen((map) {
      if (mounted) {
        errorMessage = null;
        if ((map[AppRequestKey.SHOW_PROGRESS] as bool) == true) {
          switch (map[AppRequestKey.PROGRESS_TYPE]) {
            case RequestType.INTERACTIVE:
              setState(() => showProgressBar = true);
              break;
            case RequestType.NON_INTERACTIVE:
              {
                if (_dialogProgress == null) {
                  _dialogProgress = DialogProgress(context, progressBarTitle);
                  showDialog(
                      context: context, builder: (context) => _dialogProgress!);
                }
                AppLog.i("$_dialogProgress");
              }
              break;
          }
        } else {
          switch (map[AppRequestKey.PROGRESS_TYPE]) {
            case RequestType.INTERACTIVE:
              setState(() => showProgressBar = false);
              break;
            case RequestType.NON_INTERACTIVE:
              {
                if (_dialogProgress != null) {
                  _dialogProgress?.dismiss();
                  _dialogProgress = null;
                }
              }
              break;
          }
        }
      }
    }, cancelOnError: false);
  }

  @override
  void dispose() {
    viewModel.disposeStream();
    super.dispose();
  }
}

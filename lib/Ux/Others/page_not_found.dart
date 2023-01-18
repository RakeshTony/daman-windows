
import 'package:flutter/material.dart';
import 'package:daman/BaseClasses/base_state.dart';
import 'package:daman/BaseClasses/view_model_common.dart';

class PageNotFound extends StatefulWidget {
  @override
  _PageNotFoundState createState() => _PageNotFoundState();
}

class _PageNotFoundState extends BasePageState<PageNotFound, ViewModelCommon> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "404",
                style: TextStyle(fontSize: 80),
              ),
              Text(
                "Page Not Found",
                style: TextStyle(fontSize: 24),
              )
            ],
          ),
        ),
      ),
    );
  }
}

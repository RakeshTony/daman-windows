import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';

class DialogImagePicker extends StatelessWidget {
  final Function(ImageSource) onTap;
  DialogImagePicker(this.onTap);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: kWhiteColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: kMainColor,borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton.icon(onPressed: (){
                  Navigator.pop(context);
                  onTap(ImageSource.camera);
                },
                  icon: Icon(Icons.camera_alt_outlined,color: kWhiteColor,),
                  label: Text(
                    "Camera",
                    style: TextStyle(
                      color: kWhiteColor,
                      fontWeight: RFontWeight.MEDIUM,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16,),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: kMainColor,borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton.icon(onPressed: (){
                  Navigator.pop(context);
                  onTap(ImageSource.gallery);
                },
                  icon: Icon(Icons.image_outlined,color: kWhiteColor,),
                  label: Text(
                    "Gallery",
                    style: TextStyle(
                      color: kWhiteColor,
                      fontWeight: RFontWeight.MEDIUM,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

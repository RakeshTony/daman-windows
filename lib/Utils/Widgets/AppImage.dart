import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:daman/Theme/colors.dart';
import 'package:daman/Utils/Enum/enum_r_font_weight.dart';
import 'package:daman/Utils/app_icons.dart';

class AppImage extends StatelessWidget {
  dynamic path;
  double size;
  String defaultImage;
  Color borderColor;
  Color backgroundColor;
  Color textColor;
  double borderWidth;
  BoxShape shape;
  bool isUrl;
  bool isFile;
  bool isMemory;

  AppImage(
    this.path,
    this.size, {
    this.defaultImage = DEFAULT_OPERATOR,
    this.borderColor = kTransparentColor,
    this.backgroundColor = kTransparentColor,
    this.textColor = kWhiteColor,
    this.borderWidth = 1,
    this.shape = BoxShape.circle,
    this.isUrl = true,
    this.isFile = false,
    this.isMemory = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: shape,
        color: backgroundColor,
        border: Border.all(
          width: borderWidth,
          color: borderColor,
          style: BorderStyle.solid,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size / 2),
        child: isMemory
            ? Image.memory(
                path,
                height: size,
                width: size,
              )
            : isFile
                ? Image.file(
                    File(path.toString()),
                    height: size,
                    width: size,
                  )
                : isUrl
                    ? CachedNetworkImage(
                        imageUrl: path.toString(),
                        placeholder: (context, url) => AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.asset(defaultImage),
                        ),
                        errorWidget: (context, url, error) => AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Image.asset(defaultImage),
                        ),
                      )
                    : Center(
                        child: Text(
                          path.toUpperCase(),
                          style: TextStyle(
                            color: textColor,
                            fontWeight: RFontWeight.BOLD,
                          ),
                        ),
                      ),
      ),
    );
  }
}

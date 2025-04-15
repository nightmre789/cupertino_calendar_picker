// Copyright (c) 2024 Philip Softworks. All rights reserved.
// Use of this source code is governed by a MIT-style license that can be
// found in the LICENSE file.

import 'package:flutter/cupertino.dart';

const CupertinoDynamicColor pickerButtonTextColor = CupertinoColors.label;
const TextStyle pickerButtonTextStyle = TextStyle(
  color: pickerButtonTextColor,
  fontSize: 17.0,
);

const CupertinoDynamicColor pickerButtonBackgroundColor =
    CupertinoColors.tertiarySystemFill;

const Border pickerButtonBorder = Border.fromBorderSide(BorderSide.none);

/// A decoration class for the cupertino picker button.
class PickerButtonDecoration {
  /// Creates a cupertino picker button decoration class with default values
  /// for non-provided parameters.
  factory PickerButtonDecoration({
    TextStyle? textStyle,
    Color? backgroundColor,
    Border? border,
    EdgeInsets? padding,
  }) {
    return PickerButtonDecoration._(
      textStyle: textStyle ?? pickerButtonTextStyle,
      backgroundColor: backgroundColor ?? pickerButtonBackgroundColor,
      border: border ?? pickerButtonBorder,
      padding: padding,
    );
  }

  const PickerButtonDecoration._({
    this.textStyle,
    this.backgroundColor,
    this.border,
    this.padding,
  });

  /// Creates a cupertino picker button decoration class with default values
  /// for non-provided parameters.
  ///
  /// Applies the [CupertinoDynamicColor.resolve] method for colors.
  factory PickerButtonDecoration.withDynamicColor(
    BuildContext context, {
    TextStyle? textStyle,
    CupertinoDynamicColor? backgroundColor,
    Border? border,
    EdgeInsets? padding,
  }) {
    final TextStyle style = textStyle ?? pickerButtonTextStyle;
    return PickerButtonDecoration(
      textStyle: style.copyWith(
        color: CupertinoDynamicColor.resolve(
          style.color ?? pickerButtonTextColor,
          context,
        ),
      ),
      backgroundColor: CupertinoDynamicColor.resolve(
        backgroundColor ?? pickerButtonBackgroundColor,
        context,
      ),
      border: border,
      padding: padding,
    );
  }

  /// The [TextStyle] of the picker button.
  final TextStyle? textStyle;

  /// The background [Color] of the picker button.
  final Color? backgroundColor;

  /// The [Border] of the picker button.
  final Border? border;

  /// The [Padding] of the picker button.
  final EdgeInsets? padding;

  /// Creates a copy of the class with the provided parameters.
  PickerButtonDecoration copyWith({
    TextStyle? textStyle,
    Color? backgroundColor,
    Border? border,
    EdgeInsets? padding,
  }) {
    return PickerButtonDecoration(
      textStyle: textStyle ?? this.textStyle,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      border: border ?? this.border,
      padding: padding ?? this.padding,
    );
  }
}

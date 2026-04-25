import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle get display => GoogleFonts.manrope(
        fontSize: 48,
        height: 56 / 48,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.96,
        color: AppColors.primaryAccent,
      );

  static TextStyle get heading => GoogleFonts.manrope(
        fontSize: 24,
        height: 32 / 24,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      );

  static TextStyle get subheading => GoogleFonts.manrope(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  static TextStyle get body => GoogleFonts.manrope(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get bodySmall => GoogleFonts.manrope(
        fontSize: 14,
        height: 20 / 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  static TextStyle get label => GoogleFonts.manrope(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textSecondary,
      );

  static TextStyle get caption => GoogleFonts.manrope(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  static TextStyle get buttonPrimary => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w700,
        color: AppColors.surface,
      );

  static TextStyle get buttonSecondary => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryAccent,
      );

  static TextStyle get buttonOutline => GoogleFonts.inter(
        fontSize: 16,
        height: 24 / 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get inputText => GoogleFonts.manrope(
        fontSize: 16,
        height: 22 / 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      );

  static TextStyle get inputHint => GoogleFonts.manrope(
        fontSize: 16,
        height: 22 / 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
      );

  static TextStyle get helperError => GoogleFonts.manrope(
        fontSize: 10,
        height: 12 / 10,
        fontWeight: FontWeight.w500,
        color: AppColors.error,
      );

  static TextStyle get chipSelected => GoogleFonts.manrope(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w700,
        color: AppColors.surface,
      );

  static TextStyle get chipUnselected => GoogleFonts.manrope(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      );

  static TextStyle get badge => GoogleFonts.manrope(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryAccent,
      );

  static TextStyle get macroLabel => GoogleFonts.manrope(
        fontSize: 12,
        height: 16 / 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      );

  static TextStyle get macroValue => GoogleFonts.manrope(
        fontSize: 28,
        height: 28 / 28,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      );

  static TextStyle get macroUnit => GoogleFonts.manrope(
        fontSize: 16,
        height: 20 / 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textMuted,
      );
}

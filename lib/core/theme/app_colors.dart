import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── BRAND PALETTE (RGB) ──────────────────────────────────────────────────
  /// Verde escuro da marca — backgrounds dark, superfícies escuras
  static const Color brandDarkGreen = Color(0xFF0E312A);

  /// Verde brilhante — destaques, badges, acentos vibrantes
  static const Color brandBrightGreen = Color(0xFF7CFF66);

  /// Verde principal — botões CTA, ações primárias
  static const Color brandGreen = Color(0xFF64E04B);

  /// Verde intermediário — estados hover/pressed, variantes
  static const Color brandMidGreen = Color(0xFF5DBF4D);

  // ── BRAND PALETTE (CMYK) ─────────────────────────────────────────────────
  /// Verde escuro CMYK — background alternativo dark
  static const Color brandCmykDark = Color(0xFF103129);

  /// Verde claro CMYK — texto de destaque, ícones ativos
  static const Color brandCmykLight = Color(0xFF7BC558);

  /// Verde médio CMYK — botões secundários
  static const Color brandCmykMid = Color(0xFF63B941);

  /// Verde suave CMYK — badges, tags
  static const Color brandCmykSoft = Color(0xFF5CB64A);

  // SHARED SEMANTIC COLORS
  static const Color brand = Color(0xFF245A73);
  static const Color highlight = Color(0xFFE3A93B);
  static const Color navigationBackground = Color(0xFF1A1D21);
  static const Color elevatedSurface = Color(0xFF23282D);
  static const Color inputSurfaceDark = Color(0xFF181818);
  static const Color dividerSubtleDark = Color(0x1FFFFFFF);
  static const Color outlineSubtleDark = Color(0x3DFFFFFF);
  static const Color textMutedDark = Color(0x8AFFFFFF);
  static const Color textFaintDark = Color(0x61FFFFFF);
  static const Color textDisabledDark = Color(0x4DFFFFFF);
  static const Color chartFuel = Color(0xFF14A351);
  static const Color chartDepreciation = Color(0xFFE5B84B);
  static const Color chartInsurance = Color(0xFF3B82F6);
  static const Color chartMaintenance = Color(0xFFEF4444);
  static const Color chartIpva = Color(0xFF8B5CF6);
  static const Color chartLicensing = Color(0xFFF97316);
  static const Color chartTire = Color(0xFF06B6D4);
  static const Color chartWash = Color(0xFFEC4899);
  static const Color chartLubricant = Color(0xFF9CA3AF);
  static const Color chartFinancing = Color(0xFF64748B);
  static const Color danger = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color overlayDark = Color(0x33000000);

  // LIGHT MODE
  static const Color lightBackground = Color(0xFFFCFCFC);
  static const Color lightForeground = Color(0xFF171717);
  static const Color lightCard = Color(0xFFF7F7F7);
  static const Color lightCardForeground = Color(0xFF171717);
  static const Color lightPopover = Color(0xFFF7F7F7);
  static const Color lightPopoverForeground = Color(0xFF171717);
  static const Color lightPrimary = Color(0xFF245A73);
  static const Color lightPrimaryForeground = Color(0xFFFCFCFC);
  static const Color lightSecondary = Color(0xFFF0F0F0);
  static const Color lightSecondaryForeground = Color(0xFF171717);
  static const Color lightMuted = Color(0xFFF0F0F0);
  static const Color lightMutedForeground = Color(0xFF6B6B6B);
  static const Color lightAccent = Color(0xFFE3A93B);
  static const Color lightAccentForeground = Color(0xFF171717);
  static const Color lightDestructive = Color(0xFFD33A48);
  static const Color lightDestructiveForeground = Color(0xFFFCFCFC);
  static const Color lightBorder = Color(0x1A000000);
  static const Color lightInput = Color(0x1A000000);
  static const Color lightRing = Color(0xFF245A73);
  static const Color lightPrimaryTint = Color(0xFFE2EEF2);
  static const Color lightPrimaryTintStrong = Color(0xFFC8DEE6);
  static const Color lightAccentTint = Color(0xFFF3EAD7);
  static const Color lightAccentTintStrong = Color(0xFFE7D4AF);
  static const Color lightDestructiveTint = Color(0xFFF9E5E5);
  static const Color lightDestructiveTintStrong = Color(0xFFF1CFCF);

  // LIGHT MODE - Status
  static const Color lightStatusProfitBg = Color(0xFFD7F9DE);
  static const Color lightStatusProfitFg = Color(0xFF004E04);
  static const Color lightStatusProfitBorder = Color(0xFF4DBF74);
  static const Color lightStatusProfitDot = Color(0xFF007D37);
  static const Color lightStatusLossBg = Color(0xFFFFE3DD);
  static const Color lightStatusLossFg = Color(0xFF760003);
  static const Color lightStatusLossBorder = Color(0xFFF47C70);
  static const Color lightStatusLossDot = Color(0xFFCD0011);
  static const Color lightStatusBreakevenBg = Color(0xFFF6EDE0);
  static const Color lightStatusBreakevenFg = Color(0xFF5E4205);
  static const Color lightStatusBreakevenBorder = Color(0xFFBF9F6A);
  static const Color lightStatusBreakevenDot = Color(0xFF997B46);

  // DARK MODE
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkForeground = Color(0xFFFAFAFA);
  static const Color darkCard = Color(0xFF171717);
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  static const Color darkPopover = Color(0xFF171717);
  static const Color darkPopoverForeground = Color(0xFFFAFAFA);
  static const Color darkPrimary = Color(0xFF009B49);
  static const Color darkPrimaryForeground = Color(0xFF0A0A0A);
  static const Color darkSecondary = Color(0xFF262626);
  static const Color darkSecondaryForeground = Color(0xFFFAFAFA);
  static const Color darkMuted = Color(0xFF262626);
  static const Color darkMutedForeground = Color(0xFFA1A1A1);
  static const Color darkAccent = Color(0xFFE6AC3D);
  static const Color darkAccentForeground = Color(0xFFFAFAFA);
  static const Color darkDestructive = Color(0xFFFF6467);
  static const Color darkDestructiveForeground = Color(0xFFFAFAFA);
  static const Color darkBorder = Color(0x1AFFFFFF);
  static const Color darkInput = Color(0x1AFFFFFF);
  static const Color darkRing = Color(0xFF009B49);
  static const Color darkPrimaryTint = Color(0xFF0F2516);
  static const Color darkPrimaryTintStrong = Color(0xFF0D3119);

  // DARK MODE - Status
  static const Color darkStatusProfitBg = Color(0xFF05210E);
  static const Color darkStatusProfitFg = Color(0xFF58C97D);
  static const Color darkStatusProfitBorder = Color(0xFF005C16);
  static const Color darkStatusProfitDot = Color(0xFF32A85F);
  static const Color darkStatusLossBg = Color(0xFF2E100D);
  static const Color darkStatusLossFg = Color(0xFFFF8579);
  static const Color darkStatusLossBorder = Color(0xFF861213);
  static const Color darkStatusLossDot = Color(0xFFE62C2C);
  static const Color darkStatusBreakevenBg = Color(0xFF201A10);
  static const Color darkStatusBreakevenFg = Color(0xFFB99964);
  static const Color darkStatusBreakevenBorder = Color(0xFF5E4205);
  static const Color darkStatusBreakevenDot = Color(0xFF997B46);
}

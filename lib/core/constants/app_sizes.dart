import 'package:flutter/material.dart';

// Constant sizes for app spacing, paddings, gaps, border radius etc.
class AppSizes {
  // Sizes
  static const s1 = 1.0;
  static const s1Half = 1.5;
  static const s2 = 2.0;
  static const s2Half = 2.5;
  static const s3 = 3.0;
  static const s4 = 4.0;
  static const s4Half = 4.5;
  static const s5 = 5.0;
  static const s6 = 6.0;
  static const s8 = 8.0;
  static const s10 = 10.0;
  static const s12 = 12.0;
  static const s14 = 14.0;
  static const s16 = 16.0;
  static const s20 = 20.0;
  static const s24 = 24.0;
  static const s32 = 32.0;
  static const s40 = 40.0;
  static const s48 = 48.0;
  static const s56 = 56.0;
  static const s64 = 64.0;
  static const s80 = 80.0;
  static const s96 = 96.0;
  static const s100 = 100.0;

  // Paddings
  static const p4 = 4.0;
  static const p8 = 8.0;
  static const p10 = 10.0;
  static const p12 = 12.0;
  static const p14 = 14.0;
  static const p16 = 16.0;
  static const p20 = 20.0;
  static const p24 = 24.0;

  // Border Radius
  static const r4 = 4.0;
  static const r8 = 8.0;
  static const r10 = 10.0;
  static const r12 = 12.0;
  static const r14 = 14.0;
  static const r16 = 16.0;
  static const r20 = 20.0;
  static const r24 = 24.0;
  static const rFull = 9999.0;

  // Border Radius Widgets
  static const r4Radius = BorderRadius.all(Radius.circular(r4));
  static const r8Radius = BorderRadius.all(Radius.circular(r8));
  static const r10Radius = BorderRadius.all(Radius.circular(r10));
  static const r12Radius = BorderRadius.all(Radius.circular(r12));
  static const r14Radius = BorderRadius.all(Radius.circular(r14));
  static const r16Radius = BorderRadius.all(Radius.circular(r16));
  static const r20Radius = BorderRadius.all(Radius.circular(r20));
  static const r24Radius = BorderRadius.all(Radius.circular(r24));
  static const rFullRadius = BorderRadius.all(Radius.circular(rFull));
  // Gaps
  static const g4 = 4.0;
  static const g8 = 8.0;
  static const g10 = 10.0;
  static const g12 = 12.0;
  static const g14 = 14.0;
  static const g16 = 16.0;
  static const g20 = 20.0;
  static const g24 = 24.0;

  // Gap Widgets
  static const gapW4 = SizedBox(width: g4);
  static const gapW8 = SizedBox(width: g8);
  static const gapW12 = SizedBox(width: g12);
  static const gapW16 = SizedBox(width: g16);
  static const gapW20 = SizedBox(width: g20);
  static const gapW24 = SizedBox(width: g24);
  static const gapH4 = SizedBox(height: g4);
  static const gapH8 = SizedBox(height: g8);
  static const gapH12 = SizedBox(height: g12);
  static const gapH16 = SizedBox(height: g16);
  static const gapH20 = SizedBox(height: g20);
  static const gapH24 = SizedBox(height: g24);

  // Margins
  static const m4 = 4.0;
  static const m8 = 8.0;
  static const m12 = 12.0;
  static const m16 = 16.0;
  static const m20 = 20.0;
  static const m24 = 24.0;

  // Margin & Padding Widgets
  static const marginV4 = EdgeInsets.symmetric(vertical: m4);
  static const paddingV4 = marginV4;
  static const marginV8 = EdgeInsets.symmetric(vertical: m8);
  static const paddingV8 = marginV8;
  static const marginV12 = EdgeInsets.symmetric(vertical: m12);
  static const paddingV12 = marginV12;
  static const marginV16 = EdgeInsets.symmetric(vertical: m16);
  static const paddingV16 = marginV16;
  static const marginV20 = EdgeInsets.symmetric(vertical: m20);
  static const paddingV20 = marginV20;
  static const marginV24 = EdgeInsets.symmetric(vertical: m24);
  static const paddingV24 = marginV24;
  static const marginH4 = EdgeInsets.symmetric(horizontal: m4);
  static const paddingH4 = marginH4;
  static const marginH8 = EdgeInsets.symmetric(horizontal: m8);
  static const paddingH8 = marginH8;
  static const marginH12 = EdgeInsets.symmetric(horizontal: m12);
  static const paddingH12 = marginH12;
  static const marginH16 = EdgeInsets.symmetric(horizontal: m16);
  static const paddingH16 = marginH16;
  static const marginH20 = EdgeInsets.symmetric(horizontal: m20);
  static const paddingH20 = marginH20;
  static const marginH24 = EdgeInsets.symmetric(horizontal: m24);
  static const paddingH24 = marginH24;
  static const marginAll4 = EdgeInsets.all(m4);
  static const paddingAll4 = marginAll4;
  static const marginAll8 = EdgeInsets.all(m8);
  static const paddingAll8 = marginAll8;
  static const marginAll12 = EdgeInsets.all(m12);
  static const paddingAll12 = marginAll12;
  static const marginAll16 = EdgeInsets.all(m16);
  static const paddingAll16 = marginAll16;
  static const marginAll20 = EdgeInsets.all(m20);
  static const paddingAll20 = marginAll20;
  static const marginAll24 = EdgeInsets.all(m24);
  static const paddingAll24 = marginAll24;
  static const gutter = EdgeInsets.symmetric(horizontal: m16);

  // Icon Sizes
  static const iconSize16 = 16.0;
  static const iconSize20 = 20.0;
  static const iconSize24 = 24.0;
  static const iconSize32 = 32.0;
  static const iconSize48 = 48.0;
  static const iconSize64 = 64.0;

  // Font Sizes
  static const fontSize10 = 10.0;
  static const fontSize11 = 11.0;
  static const fontSize12 = 12.0;
  static const fontSize13 = 13.0;
  static const fontSize14 = 14.0;
  static const fontSize15 = 15.0;
  static const fontSize16 = 16.0;
  static const fontSize17 = 17.0;
  static const fontSize18 = 18.0;
  static const fontSize19 = 19.0;
  static const fontSize20 = 20.0;
  static const fontSize24 = 24.0;
  static const fontSize32 = 32.0;
  static const fontSize36 = 36.0;
  static const fontSize48 = 48.0;
  static const fontSize64 = 64.0;
}

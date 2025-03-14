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
  static const s36 = 36.0;
  static const s40 = 40.0;
  static const s48 = 48.0;
  static const s50 = 50.0;
  static const s56 = 56.0;
  static const s64 = 64.0;
  static const s80 = 80.0;
  static const s96 = 96.0;
  static const s100 = 100.0;
  static const s120 = 120.0;
  static const s140 = 140.0;
  static const s160 = 160.0;
  static const s180 = 180.0;
  static const s200 = 200.0;
  static const s220 = 220.0;
  static const s240 = 240.0;
  static const s260 = 260.0;
  static const s280 = 280.0;
  static const s300 = 300.0;
  static const s320 = 320.0;

  // Border Radius Widgets
  static const r4 = BorderRadius.all(Radius.circular(s4));
  static const r6 = BorderRadius.all(Radius.circular(s6));
  static const r8 = BorderRadius.all(Radius.circular(s8));
  static const r10 = BorderRadius.all(Radius.circular(s10));
  static const r12 = BorderRadius.all(Radius.circular(s12));
  static const r14 = BorderRadius.all(Radius.circular(s14));
  static const r16 = BorderRadius.all(Radius.circular(s16));
  static const r20 = BorderRadius.all(Radius.circular(s20));
  static const r24 = BorderRadius.all(Radius.circular(s24));
  static const r32 = BorderRadius.all(Radius.circular(s32));
  static const rFull = BorderRadius.all(Radius.circular(s320));

  // Gap Widgets
  static const gapW4 = SizedBox(width: s4);
  static const gapW6 = SizedBox(width: s6);
  static const gapW8 = SizedBox(width: s8);
  static const gapW12 = SizedBox(width: s12);
  static const gapW16 = SizedBox(width: s16);
  static const gapW20 = SizedBox(width: s20);
  static const gapW24 = SizedBox(width: s24);
  static const gapH4 = SizedBox(height: s4);
  static const gapH8 = SizedBox(height: s8);
  static const gapH12 = SizedBox(height: s12);
  static const gapH16 = SizedBox(height: s16);
  static const gapH20 = SizedBox(height: s20);
  static const gapH24 = SizedBox(height: s24);
  static const gapH32 = SizedBox(height: s32);

  // Margin & Padding Widgets
  static const m4 = EdgeInsets.all(s4),
      mv4 = EdgeInsets.symmetric(vertical: s4),
      mh4 = EdgeInsets.symmetric(horizontal: s4),
      mt4 = EdgeInsets.only(top: s4),
      mr4 = EdgeInsets.only(right: s4),
      mb4 = EdgeInsets.only(bottom: s4),
      ml4 = EdgeInsets.only(left: s4);

  static const p4 = m4,
      pv4 = mv4,
      ph4 = mh4,
      pt4 = mt4,
      pr4 = mr4,
      pb4 = mb4,
      pl4 = ml4;

  static const m8 = EdgeInsets.all(s8),
      mv8 = EdgeInsets.symmetric(vertical: s8),
      mh8 = EdgeInsets.symmetric(horizontal: s8),
      mt8 = EdgeInsets.only(top: s8),
      mr8 = EdgeInsets.only(right: s8),
      mb8 = EdgeInsets.only(bottom: s8),
      ml8 = EdgeInsets.only(left: s8);

  static const p8 = m8,
      pv8 = mv8,
      ph8 = mh8,
      pt8 = mt8,
      pr8 = mr8,
      pb8 = mb8,
      pl8 = ml8;

  static const m12 = EdgeInsets.all(s12),
      mv12 = EdgeInsets.symmetric(vertical: s12),
      mh12 = EdgeInsets.symmetric(horizontal: s12),
      mt12 = EdgeInsets.only(top: s12),
      mr12 = EdgeInsets.only(right: s12),
      mb12 = EdgeInsets.only(bottom: s12),
      ml12 = EdgeInsets.only(left: s12);

  static const p12 = m12,
      pv12 = mv12,
      ph12 = mh12,
      pt12 = mt12,
      pr12 = mr12,
      pb12 = mb12,
      pl12 = ml12;

  static const m16 = EdgeInsets.all(s16),
      mv16 = EdgeInsets.symmetric(vertical: s16),
      mh16 = EdgeInsets.symmetric(horizontal: s16),
      mt16 = EdgeInsets.only(top: s16),
      mr16 = EdgeInsets.only(right: s16),
      mb16 = EdgeInsets.only(bottom: s16),
      ml16 = EdgeInsets.only(left: s16);

  static const p16 = m16,
      pv16 = mv16,
      ph16 = mh16,
      pt16 = mt16,
      pr16 = mr16,
      pb16 = mb16,
      pl16 = ml16;

  static const m20 = EdgeInsets.all(s20),
      mv20 = EdgeInsets.symmetric(vertical: s20),
      mh20 = EdgeInsets.symmetric(horizontal: s20),
      mt20 = EdgeInsets.only(top: s20),
      mr20 = EdgeInsets.only(right: s20),
      mb20 = EdgeInsets.only(bottom: s20),
      ml20 = EdgeInsets.only(left: s20);

  static const p20 = m20,
      pv20 = mv20,
      ph20 = mh20,
      pt20 = mt20,
      pr20 = mr20,
      pb20 = mb20,
      pl20 = ml20;

  static const m24 = EdgeInsets.all(s24),
      mv24 = EdgeInsets.symmetric(vertical: s24),
      mh24 = EdgeInsets.symmetric(horizontal: s24),
      mt24 = EdgeInsets.only(top: s24),
      mr24 = EdgeInsets.only(right: s24),
      mb24 = EdgeInsets.only(bottom: s24),
      ml24 = EdgeInsets.only(left: s24);

  static const p24 = m24,
      pv24 = mv24,
      ph24 = mh24,
      pt24 = mt24,
      pr24 = mr24,
      pb24 = mb24,
      pl24 = ml24;

  static const m32 = EdgeInsets.all(s32),
      mv32 = EdgeInsets.symmetric(vertical: s32),
      mh32 = EdgeInsets.symmetric(horizontal: s32),
      mt32 = EdgeInsets.only(top: s32),
      mr32 = EdgeInsets.only(right: s32),
      mb32 = EdgeInsets.only(bottom: s32),
      ml32 = EdgeInsets.only(left: s32);

  static const p32 = m32,
      pv32 = mv32,
      ph32 = mh32,
      pt32 = mt32,
      pr32 = mr32,
      pb32 = mb32,
      pl32 = ml32;

  static const m40 = EdgeInsets.all(s40),
      mv40 = EdgeInsets.symmetric(vertical: s40),
      mh40 = EdgeInsets.symmetric(horizontal: s40),
      mt40 = EdgeInsets.only(top: s40),
      mr40 = EdgeInsets.only(right: s40),
      mb40 = EdgeInsets.only(bottom: s40),
      ml40 = EdgeInsets.only(left: s40);

  static const p40 = m40,
      pv40 = mv40,
      ph40 = mh40,
      pt40 = mt40,
      pr40 = mr40,
      pb40 = mb40,
      pl40 = ml40;

  static const m48 = EdgeInsets.all(s48),
      mv48 = EdgeInsets.symmetric(vertical: s48),
      mh48 = EdgeInsets.symmetric(horizontal: s48),
      mt48 = EdgeInsets.only(top: s48),
      mr48 = EdgeInsets.only(right: s48),
      mb48 = EdgeInsets.only(bottom: s48),
      ml48 = EdgeInsets.only(left: s48);

  static const p48 = m48,
      pv48 = mv48,
      ph48 = mh48,
      pt48 = mt48,
      pr48 = mr48,
      pb48 = mb48,
      pl48 = ml48;

  static const m56 = EdgeInsets.all(s56),
      mv56 = EdgeInsets.symmetric(vertical: s56),
      mh56 = EdgeInsets.symmetric(horizontal: s56),
      mt56 = EdgeInsets.only(top: s56),
      mr56 = EdgeInsets.only(right: s56),
      mb56 = EdgeInsets.only(bottom: s56),
      ml56 = EdgeInsets.only(left: s56);

  static const p56 = m56,
      pv56 = mv56,
      ph56 = mh56,
      pt56 = mt56,
      pr56 = mr56,
      pb56 = mb56,
      pl56 = ml56;

  static const m64 = EdgeInsets.all(s64),
      mv64 = EdgeInsets.symmetric(vertical: s64),
      mh64 = EdgeInsets.symmetric(horizontal: s64),
      mt64 = EdgeInsets.only(top: s64),
      mr64 = EdgeInsets.only(right: s64),
      mb64 = EdgeInsets.only(bottom: s64),
      ml64 = EdgeInsets.only(left: s64);

  static const p64 = m64,
      pv64 = mv64,
      ph64 = mh64,
      pt64 = mt64,
      pr64 = mr64,
      pb64 = mb64,
      pl64 = ml64;

  static const m80 = EdgeInsets.all(s80),
      mv80 = EdgeInsets.symmetric(vertical: s80),
      mh80 = EdgeInsets.symmetric(horizontal: s80),
      mt80 = EdgeInsets.only(top: s80),
      mr80 = EdgeInsets.only(right: s80),
      mb80 = EdgeInsets.only(bottom: s80),
      ml80 = EdgeInsets.only(left: s80);

  static const p80 = m80,
      pv80 = mv80,
      ph80 = mh80,
      pt80 = mt80,
      pr80 = mr80,
      pb80 = mb80,
      pl80 = ml80;

  static const m96 = EdgeInsets.all(s96),
      mv96 = EdgeInsets.symmetric(vertical: s96),
      mh96 = EdgeInsets.symmetric(horizontal: s96),
      mt96 = EdgeInsets.only(top: s96),
      mr96 = EdgeInsets.only(right: s96),
      mb96 = EdgeInsets.only(bottom: s96),
      ml96 = EdgeInsets.only(left: s96);

  static const p96 = m96,
      pv96 = mv96,
      ph96 = mh96,
      pt96 = mt96,
      pr96 = mr96,
      pb96 = mb96,
      pl96 = ml96;

  static const m100 = EdgeInsets.all(s100),
      mv100 = EdgeInsets.symmetric(vertical: s100),
      mh100 = EdgeInsets.symmetric(horizontal: s100),
      mt100 = EdgeInsets.only(top: s100),
      mr100 = EdgeInsets.only(right: s100),
      mb100 = EdgeInsets.only(bottom: s100),
      ml100 = EdgeInsets.only(left: s100);

  static const p100 = m100,
      pv100 = mv100,
      ph100 = mh100,
      pt100 = mt100,
      pr100 = mr100,
      pb100 = mb100,
      pl100 = ml100;

  static const m120 = EdgeInsets.all(s120),
      mv120 = EdgeInsets.symmetric(vertical: s120),
      mh120 = EdgeInsets.symmetric(horizontal: s120),
      mt120 = EdgeInsets.only(top: s120),
      mr120 = EdgeInsets.only(right: s120),
      mb120 = EdgeInsets.only(bottom: s120),
      ml120 = EdgeInsets.only(left: s120);

  static const p120 = m120,
      pv120 = mv120,
      ph120 = mh120,
      pt120 = mt120,
      pr120 = mr120,
      pb120 = mb120,
      pl120 = ml120;

  static const gutter = EdgeInsets.symmetric(horizontal: s16),
      gutterValue = s16;
}

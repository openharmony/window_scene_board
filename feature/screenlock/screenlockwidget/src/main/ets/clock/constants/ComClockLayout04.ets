/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { ClockComFamily, ClockLayout, ClockTextAlign, ClockWidgetId } from '../../common/WidgetParam';
import { SignFormKey } from '../common/SignFormKey';
import { DynamicRegion } from '../common/DynamicRegion';
import Constants from '../../common/Constants';
import { DynamicNumber } from '../common/DynamicNumber';
import { DynamicLength } from '../common/DynamicLength';
import { HAlignKey, VAlignKey } from '../common/HorizontalVerticalAlign';
import { DynamicAlignDy } from '../common/DynamicAlignDy';
import { FontSizeKey } from '../common/ClockFontSize';
import { ClockStyleConfig } from '../model/data/ClockStyleConfig';
import { AodClockStyleConfig } from '../model/data/AodClockStyleConfig';

const OUTER_SCREEN_DATE_FONT_SIZE: number = 16.7;

/**
 * 数字时钟样式04
 * 单个元素的布局属性
 * time 42/date 42/week 19/sign 17
 */
export const comClock04: ClockStyleConfig = ClockStyleConfig.wrap(ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL)
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 8, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 32) // 垂直居中
      .buildProperty(VAlignKey.V_END, 48), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 40) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 19))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 24) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 3))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 171) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 37, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 32) // 垂直居中
      .buildProperty(VAlignKey.V_END, 48), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 40) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 19))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 24) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 3))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 200) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 66, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 32) // 垂直居中
      .buildProperty(VAlignKey.V_END, 48), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 40) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 19))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 24) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 3))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 229) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 81, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 32) // 垂直居中
      .buildProperty(VAlignKey.V_END, 48), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 40) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 19))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 24) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 3))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 244) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 110, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 50, // 高度42fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 32) // 垂直居中
      .buildProperty(VAlignKey.V_END, 48), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 40) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 19))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 24) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 3))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 273) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: 8, y: 66 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 50)
      .buildProperty(FontSizeKey.POCKETKNIVES, 50.8),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 82) // 垂直居中
      .buildProperty(VAlignKey.V_END, 98), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 40) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 19))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 24) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 3))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '97.5%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: 157, y: 67 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, OUTER_SCREEN_DATE_FONT_SIZE),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 85) // 垂直居中
      .buildProperty(VAlignKey.V_END, 101), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 40) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 19))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 24) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 3))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '49.7%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: 157, y: 88 },
    anchor: { x: 0, y: 0 },
    fontSize: 16, // 高度19fp
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, OUTER_SCREEN_DATE_FONT_SIZE),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 106) // 垂直居中
      .buildProperty(VAlignKey.V_END, 122), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 40) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 19))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 24) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 3))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '49.7%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: 10, y: 112 },
    anchor: { x: 0, y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    maxWidth: 211, // 跑马灯最大宽度
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 128) // 垂直居中
      .buildProperty(VAlignKey.V_END, 144), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 40) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 19))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 24) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 3))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '96.8%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%'), // 居右对齐
    dynamicTextAlignMap: DynamicNumber.wrapper().buildProperty(HAlignKey.H_END, ClockTextAlign.RIGHT) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: '50%', y: 132 },
    anchor: { x: 0, y: 0 },
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_CENTER,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 15)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
      .buildProperty(VAlignKey.V_START,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 15)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
      .buildProperty(VAlignKey.V_END,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 15)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 8, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 171) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 37, y: 8},
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 200) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 66, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 229) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 81, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 244) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 110, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 50, // 高度42fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 273) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: 8, y: 58 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 50)
      .buildProperty(FontSizeKey.POCKETKNIVES, 50.8),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '97.5%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: 157, y: 61 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, OUTER_SCREEN_DATE_FONT_SIZE),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '49.7%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: 157, y: 82 },
    anchor: { x: 0, y: 0 },
    fontSize: 16, // 高度19fp
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, OUTER_SCREEN_DATE_FONT_SIZE),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '49.7%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: 10, y: 104 },
    anchor: { x: 0, y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    maxWidth: 211, // 跑马灯最大宽度
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '96.8%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%'), // 居右对齐
    dynamicTextAlignMap: DynamicNumber.wrapper().buildProperty(HAlignKey.H_END, ClockTextAlign.RIGHT) // 居右对齐
  })
  .bindExpandGrid({
    maxWidthSize: 312,
    maxHeightSize: 312,
    gridWidthSize: 312,
    gridHeightSize: 156,
    gridWidthAmount: 4,
    gridHeightAmount: 2,
    timeTextWidth: 32,
    timeTextHeight: 44,
    dateTextHeight: 21,
    gridVerticalMargin: 16,
    gridHorizontalMargin: 6,
    specialSeparator: false,
    singleLineDate: false,
    dateSeperate: true,
    largeDate: true,
    dynamicLunar: false,
  })
  .bindCollapseGrid({
    maxWidthSize: 312,
    maxHeightSize: 312,
    gridWidthSize: 312,
    gridHeightSize: 156,
    gridWidthAmount: 4,
    gridHeightAmount: 2,
    timeTextWidth: 32,
    timeTextHeight: 44,
    dateTextHeight: 21,
    gridVerticalMargin: 16,
    gridHorizontalMargin: 6,
    specialSeparator: false,
    singleLineDate: false,
    dateSeperate: true,
    largeDate: true,
    dynamicLunar: false,
    dynamicRegion: DynamicRegion.wrapper()
      .bindRegion(SignFormKey.VISIBLE_NONE, {y: Constants.SCREENLOCK_CLOCK_TOP, height: 101})
      .bindRegion(SignFormKey.VISIBLE_SIGN, {y: Constants.SCREENLOCK_CLOCK_TOP, height: 121})
  })
  .bindOneShotCollapseGrid({
    singleLineDate: false,
    dateSeperate: true,
    dynamicLunar: false
  })
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_06) as ClockStyleConfig;

export const aodClock04: AodClockStyleConfig = AodClockStyleConfig.wrap(ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL)
// 局部AOD样式元素配置
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 77, y: 31.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 97.5, y: 31.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 117.5, y: 31.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 128.5, y: 31.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 148, y: 31.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_DATE,
    offset: { x: 77, y: 64.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: 182, y: 60 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: 182, y: 78.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: 81, y: 97.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 14,
    fontSizeScale: 0.875,
    isShow: true,
    maxWidth: 189,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: '50%', y: 101.5 },
    anchor: { x: '50%', y: 0 },
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_CENTER,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 15)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
      .buildProperty(VAlignKey.V_START,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 15)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
      .buildProperty(VAlignKey.V_END,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 15)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
  })
  .bindAodClockMargin({
    top: 157,
    left: 24,
  })
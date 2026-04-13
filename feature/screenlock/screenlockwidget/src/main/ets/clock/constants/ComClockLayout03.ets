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
import { DateWeekLunarStyle } from '../common/ClockConstants';

/**
 * 数字时钟样式03
 * 单个元素的布局属性
 * time 51/date 19/sign 17
 */
export const comClock03: ClockStyleConfig = ClockStyleConfig.wrap(ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT)
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 6, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 28) // 垂直居中
      .buildProperty(VAlignKey.V_END, 40), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 32) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 34))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 146) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 40, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 28) // 垂直居中
      .buildProperty(VAlignKey.V_END, 40), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 32) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 34))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 180) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 76, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 28) // 垂直居中
      .buildProperty(VAlignKey.V_END, 40), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 32) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 34))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 214) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 96, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 28) // 垂直居中
      .buildProperty(VAlignKey.V_END, 40), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 32) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 34))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 234) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 130, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 60, // 高度51fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 28) // 垂直居中
      .buildProperty(VAlignKey.V_END, 40), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 32) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 34))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 268) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: 14, y: 74 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 86) // 垂直居中
      .buildProperty(VAlignKey.V_END, 98), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 32) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 34))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '95.5%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: 14, y: 74 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 86) // 垂直居中
      .buildProperty(VAlignKey.V_END, 98), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 32) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 34))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '95.5%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: 14, y: 97 },
    anchor: { x: 0, y: 0 },
    fontSize: 16, // 高度19fp
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 109) // 垂直居中
      .buildProperty(VAlignKey.V_END, 121), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 32) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 34))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '95.5%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: 14, y: 97 },
    anchor: { x: 0, y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    maxWidth: 188, // 跑马灯最大宽度
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 109) // 垂直居中
      .buildProperty(VAlignKey.V_END, 121), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 32) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 34))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '95.5%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%'), // 居右对齐
    dynamicTextAlignMap: DynamicNumber.wrapper().buildProperty(HAlignKey.H_END, ClockTextAlign.RIGHT) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: 14, y: 125 },
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
    offset: { x: 6, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 146) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 40, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 180) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 76, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 214) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 96, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 234) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 130, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 60, // 高度51fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, 268) // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: 14, y: 66 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '95.5%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: 14, y: 66 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '95.5%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: 14, y: 89 },
    anchor: { x: 0, y: 0 },
    fontSize: 16, // 高度19fp
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '95.5%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: 14, y: 89 },
    anchor: { x: 0, y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    maxWidth: 188, // 跑马灯最大宽度
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4),
    dynamicOffsetXMap: DynamicLength.wrapper().buildProperty(HAlignKey.H_END, '95.5%'), // 居右对齐
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
    timeTextWidth: 36,
    timeTextHeight: 50,
    dateTextHeight: 21,
    gridVerticalMargin: 0,
    gridHorizontalMargin: 0,
    specialSeparator: false,
    singleLineDate: false,
    dateSeperate: false,
    largeDate: false,
    dynamicLunar: true,
  })
  .bindCollapseGrid({
    maxWidthSize: 312,
    maxHeightSize: 312,
    gridWidthSize: 312,
    gridHeightSize: 156,
    gridWidthAmount: 4,
    gridHeightAmount: 2,
    timeTextWidth: 36,
    timeTextHeight: 50,
    dateTextHeight: 21,
    gridVerticalMargin: 0,
    gridHorizontalMargin: 0,
    specialSeparator: false,
    singleLineDate: false,
    dateSeperate: false,
    largeDate: false,
    dynamicLunar: true,
    dynamicRegion: DynamicRegion.wrapper()
      .bindRegion(SignFormKey.VISIBLE_NONE, {y: Constants.SCREENLOCK_CLOCK_TOP, height: 108})
      .bindRegion(SignFormKey.VISIBLE_SIGN, {y: Constants.SCREENLOCK_CLOCK_TOP, height: 106})
  })
  .bindOneShotCollapseGrid({
    singleLineDate: false,
    dateSeperate: false,
    dynamicLunar: true
  })
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_05) as ClockStyleConfig;

export const aodClock03: AodClockStyleConfig = AodClockStyleConfig.wrap(ClockLayout.NORMAL_CLOCK_LAYOUT_LEFT)
// 局部AOD样式元素配置
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 92, y: 22 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    fontSizeScale: 0.8,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 120, y: 22 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    fontSizeScale: 0.8,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 149, y: 22 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    fontSizeScale: 0.8,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 163, y: 22 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    fontSizeScale: 0.8,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 192, y: 22 },
    anchor: { x: 0, y: 0 },
    fontSize: 60,
    fontSizeScale: 0.8,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_DATE,
    offset: { x: 98, y: 70.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: 154, y: 70.5 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: 98, y: 91 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: 98, y: 111 },
    anchor: { x: 0, y: 0 },
    fontSize: 14,
    fontSizeScale: 0.875,
    isShow: true,
    maxWidth: 123,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: 98, y: 117 },
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
  .bindMergeWeekLunar(DateWeekLunarStyle.STYLE_MULTILINE)
  .bindAodClockMargin({
    top: 158,
    left: 24,
  })
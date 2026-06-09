/*
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
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

/**
 * 数字时钟样式08
 * 单个元素的布局属性
 * time 98/date 19/sign 17
 */
export const comClock08: ClockStyleConfig = ClockStyleConfig.wrap(ClockLayout.DEFAULT_CLOCK_SPECIAL)
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 167, y: 16 },
    anchor: { x: 78, y: 0 },
    fontSize: 116,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 23) // 垂直居中
      .buildProperty(VAlignKey.V_END, 30), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 15) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 8)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 162) // 居左对齐
      .buildProperty(HAlignKey.H_END, 172) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 233, y: 16 },
    anchor: { x: 78, y: 0 },
    fontSize: 116,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 23) // 垂直居中
      .buildProperty(VAlignKey.V_END, 30), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 15) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 8)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 228) // 居左对齐
      .buildProperty(HAlignKey.H_END, 238) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 204, y: 64 },
    anchor: { x: 78, y: 0 },
    fontSize: 116,
    isShow: false,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 71) // 垂直居中
      .buildProperty(VAlignKey.V_END, 78), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 15) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 8)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 199) // 居左对齐
      .buildProperty(HAlignKey.H_END, 209) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 167, y: 184 },
    anchor: { x: 78, y: 0 },
    fontSize: 116,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 191) // 垂直居中
      .buildProperty(VAlignKey.V_END, 198), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 15) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 8)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 162) // 居左对齐
      .buildProperty(HAlignKey.H_END, 172) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 233, y: 184 },
    anchor: { x: 78, y: 0 },
    fontSize: 116, // 高度98fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 191) // 垂直居中
      .buildProperty(VAlignKey.V_END, 198), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 22))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 15) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 15))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 8)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 228) // 居左对齐
      .buildProperty(HAlignKey.H_END, 238) // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: '50%', y: 130 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 137) // 垂直居中
      .buildProperty(VAlignKey.V_END, 144), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 23))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 15) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 16))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 9)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 173) // 居左对齐
      .buildProperty(HAlignKey.H_END, '64.86%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 0) // 居左对齐
      .buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: '50%', y: 130 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 137) // 垂直居中
      .buildProperty(VAlignKey.V_END, 144), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 23))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 15) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 16))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 9)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 173) // 居左对齐
      .buildProperty(HAlignKey.H_END, '64.86%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 0) // 居左对齐
      .buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: '50%', y: 150 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16, // 高度19fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 157) // 垂直居中
      .buildProperty(VAlignKey.V_END, 164), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 23))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 15) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 16))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 9)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 173) // 居左对齐
      .buildProperty(HAlignKey.H_END, '64.86%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 0) // 居左对齐
      .buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: '50%', y: 150 },
    anchor: { x: '50%', y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    maxWidth: 188, // 跑马灯最大宽度
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4),
    dynamicTextAlignMap: DynamicNumber.wrapper()
      .buildProperty(HAlignKey.H_START, ClockTextAlign.LEFT) // 居左对齐
      .buildProperty(HAlignKey.H_END, ClockTextAlign.RIGHT), // 居右对齐
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 157) // 垂直居中
      .buildProperty(VAlignKey.V_END, 164), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 23))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 15) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 16))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，固定最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 9)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 173) // 居左对齐
      .buildProperty(HAlignKey.H_END, '64.86%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 0) // 居左对齐
      .buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: '50%', y: 292 },
    anchor: { x: '50%', y: 0 },
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 128, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 174, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 222, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 246, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 292, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 80, // 高度68fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: '50%', y: 88 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7)
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: '50%', y: 88 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7)
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: '50%', y: 88 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16, // 高度19fp
    isShow: false,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7)
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: '50%', y: 111 },
    anchor: { x: '50%', y: 0 },
    fontSize: 14, // 高度17fp
    isShow: false,
    maxWidth: 208, // 跑马灯最大宽度
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4)
  })
  .bindExpandGrid({
    maxWidthSize: 468,
    maxHeightSize: 312,
    gridWidthSize: 156,
    gridHeightSize: 312,
    gridWidthAmount: 2,
    gridHeightAmount: 4,
    timeTextWidth: 68,
    timeTextHeight: 96,
    dateTextHeight: 21,
    gridVerticalMargin: 0,
    gridHorizontalMargin: 0,
    specialSeparator: false,
    singleLineDate: false,
    dateSeperate: false,
    largeDate: false,
    dynamicLunar: true,
    isTimeSeparate: true,
  })
  .bindCollapseGrid({
    maxWidthSize: 468,
    maxHeightSize: 312,
    gridWidthSize: 312,
    gridHeightSize: 156,
    gridWidthAmount: 4,
    gridHeightAmount: 2,
    timeTextWidth: 48,
    timeTextHeight: 68,
    dateTextHeight: 21,
    gridVerticalMargin: 0,
    gridHorizontalMargin: 0,
    specialSeparator: false,
    singleLineDate: true,
    dateSeperate: false,
    largeDate: false,
    dynamicLunar: false,
    isTimeSeparate: true,
    dynamicRegion: DynamicRegion.wrapper()
      .bindRegion(SignFormKey.VISIBLE_NONE, {y: Constants.SCREENLOCK_CLOCK_TOP, height: 107})
      .bindRegion(SignFormKey.VISIBLE_SIGN, {y: Constants.SCREENLOCK_CLOCK_TOP, height: 128})
  })
  .bindOneShotCollapseGrid({
    singleLineDate: false,
    dateSeperate: false,
    dynamicLunar: true
  })
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_03) as ClockStyleConfig;

export const aodClock08: AodClockStyleConfig = AodClockStyleConfig.wrap(ClockLayout.DEFAULT_CLOCK_SPECIAL)
// 局部AOD样式元素配置
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 197, y: 65 },
    anchor: { x: 78, y: 0 },
    fontSize: 116,
    fontSizeScale: 0.55,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 234.5, y: 65 },
    anchor: { x: 78, y: 0 },
    fontSize: 116,
    fontSizeScale: 0.55,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 204, y: 33 },
    anchor: { x: 78, y: 0 },
    fontSize: 116,
    fontSizeScale: 0.55,
    isShow: false,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 197, y: 173 },
    anchor: { x: 78, y: 0 },
    fontSize: 116,
    fontSizeScale: 0.55,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 234.5, y: 173 },
    anchor: { x: 78, y: 0 },
    fontSize: 116,
    fontSizeScale: 0.55,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_DATE,
    offset: { x: '50%', y: 130 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: '50%', y: 130 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: '50%', y: 149 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: '50%', y: 149 },
    anchor: { x: '50%', y: 0 },
    fontSize: 14,
    fontSizeScale: 0.875,
    maxWidth: 176,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: '50.8%', y: 236 },
    anchor: { x: '50%', y: 0 },
  })
  .bindAodClockMargin({
    top: 119,
    left: 108.92307692307692,
  })
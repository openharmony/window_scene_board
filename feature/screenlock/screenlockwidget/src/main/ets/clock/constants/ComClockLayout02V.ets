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
import { VAlignKey } from '../common/HorizontalVerticalAlign';
import { DynamicAlignDy } from '../common/DynamicAlignDy';
import { FontSizeKey } from '../common/ClockFontSize';
import { ClockStyleConfig } from '../model/data/ClockStyleConfig';
import { AodClockStyleConfig } from '../model/data/AodClockStyleConfig';
import { aodClock02 } from './ComClockLayout02';

/**
 * 数字时钟样式2 翻转
 * 单个元素的布局属性
 * time 68/date 19/sign 17
 */
export const comClock02V: ClockStyleConfig = ClockStyleConfig.wrap(ClockLayout.NORMAL_CLOCK_REVERSE_LAYOUT)
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 50, y: 47 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 59.5) // 垂直居中
      .buildProperty(VAlignKey.V_END, 72), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 33) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 12))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20.5) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -0.5))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 96, y: 47 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 59.5) // 垂直居中
      .buildProperty(VAlignKey.V_END, 72), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 33) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 12))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20.5) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -0.5))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 144, y: 47 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 59.5) // 垂直居中
      .buildProperty(VAlignKey.V_END, 72), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 33) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 12))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20.5) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -0.5))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 168, y: 47 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 59.5) // 垂直居中
      .buildProperty(VAlignKey.V_END, 72), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 33) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 12))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20.5) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -0.5))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 214, y: 47 },
    anchor: { x: 0, y: 0 },
    fontSize: 80, // 高度68fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 59.5) // 垂直居中
      .buildProperty(VAlignKey.V_END, 72), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 33) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 12))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20.5) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -0.5))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: '50%', y: 16 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 28.5) // 垂直居中
      .buildProperty(VAlignKey.V_END, 41), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 33) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 12))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20.5) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -0.5))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: '50%', y: 16 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 28.5) // 垂直居中
      .buildProperty(VAlignKey.V_END, 41), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 33) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 12))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20.5) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -0.5))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: '50%', y: 16 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16, // 高度19fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 28.5) // 垂直居中
      .buildProperty(VAlignKey.V_END, 41), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 33) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 12))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20.5) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -0.5))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: '50%', y: 39 },
    anchor: { x: '50%', y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    maxWidth: 208, // 跑马灯最大宽度
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 51.5) // 垂直居中
      .buildProperty(VAlignKey.V_END, 64), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 33) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 12))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -10.5) // 显示签名时，保持垂直居中
        .buildProperty(SignFormKey.VISIBLE_FORM, 20.5) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -0.5))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -21) // 显示签名时，保持底部对齐
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -13))
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 50, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 96, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 144, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 168, y: 8 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 214, y: 8 },
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
    isShow: true,
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
    isShow: true,
    maxWidth: 208, // 跑马灯最大宽度
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4)
  })
  .bindExpandGrid({
    maxWidthSize: 312,
    maxHeightSize: 312,
    gridWidthSize: 312,
    gridHeightSize: 156,
    gridWidthAmount: 4,
    gridHeightAmount: 2,
    timeTextWidth: 48,
    timeTextHeight: 68,
    dateTextHeight: 21,
    gridVerticalMargin: 16,
    gridHorizontalMargin: 6,
    specialSeparator: false,
    singleLineDate: true,
    dateSeperate: false,
    largeDate: false,
    dynamicLunar: false,
  })
  .bindCollapseGrid({
    maxWidthSize: 312,
    maxHeightSize: 312,
    gridWidthSize: 312,
    gridHeightSize: 156,
    gridWidthAmount: 4,
    gridHeightAmount: 2,
    timeTextWidth: 48,
    timeTextHeight: 68,
    dateTextHeight: 21,
    gridVerticalMargin: 8,
    gridHorizontalMargin: 6,
    specialSeparator: false,
    singleLineDate: true,
    dateSeperate: false,
    largeDate: false,
    dynamicLunar: false,
    dynamicRegion: DynamicRegion.wrapper()
      .bindRegion(SignFormKey.VISIBLE_NONE, {y: Constants.SCREENLOCK_CLOCK_TOP, height: 107})
      .bindRegion(SignFormKey.VISIBLE_SIGN, {y: Constants.SCREENLOCK_CLOCK_TOP, height: 128})
  })
  .bindOneShotCollapseGrid({
    singleLineDate: true,
    dateSeperate: false,
    dynamicLunar: false
  })
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_01) as ClockStyleConfig;

export const aodComClock02V: AodClockStyleConfig = aodClock02.copy(ClockLayout.NORMAL_CLOCK_REVERSE_LAYOUT);

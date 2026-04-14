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
import { DynamicAlignDy } from '../common/DynamicAlignDy';
import { VAlignKey } from '../common/HorizontalVerticalAlign';
import { DynamicNumber } from '../common/DynamicNumber';
import { FontSizeKey } from '../common/ClockFontSize';
import { ClockStyleConfig } from '../model/data/ClockStyleConfig';
import { aodClock06 } from './ComClockLayout06';
import { AodClockStyleConfig } from '../model/data/AodClockStyleConfig';

/**
 * 数字时钟样式06 翻转
 * 单个元素的布局属性
 * time 85/date 19/sign 17
 */
export const comClock06V: ClockStyleConfig = ClockStyleConfig.wrap(ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT)
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 42, y: 51 },
    anchor: { x: 0, y: 0 },
    fontSize: 100,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicAlignDyMap: DynamicAlignDy.wrapper() // 始终保持垂直居中
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 98, y: 31 },
    anchor: { x: 0, y: 0 },
    fontSize: 100,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicAlignDyMap: DynamicAlignDy.wrapper() // 始终保持垂直居中
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 155, y: 50 },
    anchor: { x: 0, y: 0 },
    fontSize: 80,
    isShow: false,
    textAlign: ClockTextAlign.CENTER,
    dynamicAlignDyMap: DynamicAlignDy.wrapper() // 始终保持垂直居中
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 154, y: 60 },
    anchor: { x: 0, y: 0 },
    fontSize: 100, // 高度85fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicAlignDyMap: DynamicAlignDy.wrapper() // 始终保持垂直居中
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 210, y: 40 },
    anchor: { x: 0, y: 0 },
    fontSize: 100,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicAlignDyMap: DynamicAlignDy.wrapper() // 始终保持垂直居中
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: '50%', y: 11 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicAlignDyMap: DynamicAlignDy.wrapper() // 始终保持垂直居中
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: '50%', y: 11 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicAlignDyMap: DynamicAlignDy.wrapper() // 始终保持垂直居中
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: '50%', y: 11 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16, // 高度19fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicAlignDyMap: DynamicAlignDy.wrapper() // 始终保持垂直居中
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: '50%', y: 31 },
    anchor: { x: '50%', y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    maxWidth: 226, // 跑马灯最大宽度
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4),
    dynamicAlignDyMap: DynamicAlignDy.wrapper() // 始终保持垂直居中
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, -9)
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, -9))
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
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
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
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
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
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
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
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4),
  })
  .bindExpandGrid({
    maxWidthSize: 312,
    maxHeightSize: 312,
    gridWidthSize: 312,
    gridHeightSize: 156,
    gridWidthAmount: 4,
    gridHeightAmount: 2,
    timeTextWidth: 60,
    timeTextHeight: 80,
    dateTextHeight: 21,
    gridVerticalMargin: 0,
    gridHorizontalMargin: 0,
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
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_07) as ClockStyleConfig;

export const aodComClock06V: AodClockStyleConfig = aodClock06.copy(ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT);

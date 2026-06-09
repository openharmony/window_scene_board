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
import { FontSizeKey } from '../common/ClockFontSize';
import { ClockStyleConfig } from '../model/data/ClockStyleConfig';
import { AodClockStyleConfig } from '../model/data/AodClockStyleConfig';

const OUTER_SCREEN_DATE_FONT_SIZE: number = 16.5;

/**
 * 数字时钟样式07
 * 单个元素的布局属性
 */
export const comClock07: ClockStyleConfig = ClockStyleConfig.wrap(ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SPECIAL)
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 13, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 84, y: 16 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 154, y: 113 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    isShow: false,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 155, y: 113 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 226, y: 113 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: '52.5%', y: 60 },
    anchor: { x: 0, y: 0 },
    fontSize: 24, // 高度29
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 24)
      .buildProperty(FontSizeKey.POCKETKNIVES, 24.2)
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: '52.5%', y: 90 },
    anchor: { x: 0, y: 0 },
    fontSize: 16, // 高度19
    isShow: true,
    textAlign: ClockTextAlign.RIGHT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, OUTER_SCREEN_DATE_FONT_SIZE)
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: '47%', y: 125 },
    anchor: { x: '100%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.RIGHT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, OUTER_SCREEN_DATE_FONT_SIZE)
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: '47%', y: 148 },
    anchor: { x: '100%', y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    maxWidth: 130, // 跑马灯最大宽度
    textAlign: ClockTextAlign.RIGHT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4)
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: '50%', y: 228 },
    anchor: { x: '50%', y: 0 },
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
      .buildProperty(FontSizeKey.POCKETKNIVES, OUTER_SCREEN_DATE_FONT_SIZE)
  })
  .bindCollapseElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: '50%', y: 88 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, OUTER_SCREEN_DATE_FONT_SIZE)
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
      .buildProperty(FontSizeKey.POCKETKNIVES, OUTER_SCREEN_DATE_FONT_SIZE)
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
    gridHeightSize: 234,
    gridWidthAmount: 4,
    gridHeightAmount: 3,
    timeTextWidth: 72,
    timeTextHeight: 96,
    dateTextHeight: 21,
    gridVerticalMargin: 0,
    gridHorizontalMargin: 0,
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
    singleLineDate: false,
    dateSeperate: true,
    dynamicLunar: true
  })
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_05) as ClockStyleConfig;

export const aodClock07: AodClockStyleConfig = AodClockStyleConfig.wrap(ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SPECIAL)
// 局部AOD样式元素配置
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 83, y: 52 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    fontSizeScale: 0.5,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 120, y: 52 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    fontSizeScale: 0.5,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 154, y: 90 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    fontSizeScale: 0.5,
    isShow: false,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 157, y: 101 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    fontSizeScale: 0.5,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 194, y: 101 },
    anchor: { x: 0, y: 0 },
    fontSize: 124,
    fontSizeScale: 0.5,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_DATE,
    offset: { x: '52.15%', y: 62 },
    anchor: { x: 0, y: 0 },
    fontSize: 24,
    fontSizeScale: 0.83,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: '52.15%', y: 82 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.RIGHT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: '48%', y: 109 },
    anchor: { x: '100%', y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.RIGHT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: '48%', y: 127 },
    anchor: { x: '100%', y: 0 },
    fontSize: 14,
    fontSizeScale: 0.875,
    isShow: true,
    maxWidth: 60,
    textAlign: ClockTextAlign.RIGHT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: '50%', y: 166 },
    anchor: { x: '50%', y: 0 },
  })
  .bindAodClockMargin({
    top: 126,
    left: 24,
  })
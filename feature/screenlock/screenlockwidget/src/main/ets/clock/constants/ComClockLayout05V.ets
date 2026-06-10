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
import { DynamicLength } from '../common/DynamicLength';
import { PocketVAlignKey } from '../common/HorizontalVerticalAlign';
import { ClockStyleConfig } from '../model/data/ClockStyleConfig';
import { AodClockStyleConfig } from '../model/data/AodClockStyleConfig';
import { aodClock05 } from './ComClockLayout05';

/**
 * 数字时钟样式05 翻转
 * 单个元素的布局属性
 */
export const comClock05V: ClockStyleConfig = ClockStyleConfig.wrap(ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT_SEPERATOR)
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 13, y: 52 },
    anchor: { x: 0, y: 0 },
    fontSize: 112,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 76, y: 52 },
    anchor: { x: 0, y: 0 },
    fontSize: 112,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 139, y: 52 },
    anchor: { x: 0, y: 0 },
    fontSize: 112,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 170, y: 52 },
    anchor: { x: 0, y: 0 },
    fontSize: 112, // 高度95fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 233, y: 52 },
    anchor: { x: 0, y: 0 },
    fontSize: 112,
    isShow: true,
    textAlign: ClockTextAlign.CENTER
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: 21, y: 6 },
    anchor: { x: 0, y: 0 },
    fontSize: 40,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 40)
      .buildProperty(FontSizeKey.POCKETKNIVES, 40.36)
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: '93%', y: 4 },
    anchor: { x: '100%', y: 0 },
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.RIGHT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(PocketVAlignKey.PV_START, 109.4) // 小折叠产品折叠态 顶部对齐
      .buildProperty(PocketVAlignKey.PV_CENTER, 109.4) // 小折叠产品折叠态 垂直居中
      .buildProperty(PocketVAlignKey.PV_END, 109.4), // 小折叠产品折叠态 底部对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: '93%', y: 25 },
    anchor: { x: '100%', y: 0 },
    fontSize: 16, // 高度19fp
    isShow: true,
    textAlign: ClockTextAlign.RIGHT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(PocketVAlignKey.PV_START, 134.4) // 小折叠产品折叠态 顶部对齐
      .buildProperty(PocketVAlignKey.PV_CENTER, 134.4) // 小折叠产品折叠态 垂直居中
      .buildProperty(PocketVAlignKey.PV_END, 134.4), // 小折叠产品折叠态 底部对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: '93%', y: 25 },
    anchor: { x: '100%', y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    maxWidth: 148, // 跑马灯最大宽度
    textAlign: ClockTextAlign.RIGHT,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4)
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
    timeTextWidth: 60,
    timeTextHeight: 84,
    dateTextHeight: 21,
    gridVerticalMargin: 16,
    gridHorizontalMargin: 6,
    specialSeparator: false,
    singleLineDate: false,
    dateSeperate: true,
    largeDate: true,
    dynamicLunar: true,
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

export const aodComClock05V: AodClockStyleConfig = aodClock05.copy(ClockLayout.MOUNTAIN_CLOCK_REVERSE_LAYOUT_SEPERATOR);

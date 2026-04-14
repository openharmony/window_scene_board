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
import { HAlignKey, VAlignKey, PocketVAlignKey } from '../common/HorizontalVerticalAlign';
import { DynamicAlignDy } from '../common/DynamicAlignDy';
import { FontSizeKey } from '../common/ClockFontSize';
import { ClockStyleConfig } from '../model/data/ClockStyleConfig';
import { AodClockStyleConfig } from '../model/data/AodClockStyleConfig';
import { aodClock01 } from './ComClockLayout01';

/**
 * 数字时钟样式01 翻转
 * 单个元素的布局属性
 * time 102/date 19/sign 17
 */
export const comClock01V: ClockStyleConfig = ClockStyleConfig.wrap(ClockLayout.DEFAULT_CLOCK_REVERSE_LAYOUT)
  // 展开样式元素配置
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 164, y: 66 },
    anchor: { x: 78, y: 0 },
    fontSize: 120,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(PocketVAlignKey.PV_CENTER, 28.4) // 小折叠产品折叠态 垂直居中
      .buildProperty(VAlignKey.V_CENTER, 80) // 垂直居中
      .buildProperty(VAlignKey.V_END, 94), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 36) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 38))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 24))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 233, y: 66 },
    anchor: { x: 78, y: 0 },
    fontSize: 120,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(PocketVAlignKey.PV_CENTER, 28.4) // 小折叠产品折叠态 垂直居中
      .buildProperty(VAlignKey.V_CENTER, 80) // 垂直居中
      .buildProperty(VAlignKey.V_END, 94), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 36) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 38))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 24))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 199, y: 64 },
    anchor: { x: 78, y: 0 },
    fontSize: 120,
    isShow: false,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 78) // 垂直居中
      .buildProperty(VAlignKey.V_END, 92), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 36) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 38))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 24))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 164, y: 172 },
    anchor: { x: 78, y: 0 },
    fontSize: 120,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(PocketVAlignKey.PV_CENTER, 11.4) // 小折叠产品折叠态 垂直居中
      .buildProperty(VAlignKey.V_CENTER, 180) // 垂直居中
      .buildProperty(VAlignKey.V_END, 194), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 30) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 32))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 24))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 233, y: 172 },
    anchor: { x: 78, y: 0 },
    fontSize: 120, // 高度102fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(PocketVAlignKey.PV_CENTER, 131.4) // 小折叠产品折叠态 垂直居中
      .buildProperty(VAlignKey.V_CENTER, 180) // 垂直居中
      .buildProperty(VAlignKey.V_END, 194), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 30) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 32))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 24))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10))
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_DATE,
    offset: { x: '50%', y: 16 },
    anchor: { x: '50%', y: 0 }, // 用锚点和偏移配合保持居中
    fontSize: 16,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(PocketVAlignKey.PV_CENTER, 240.4) // 小折叠产品折叠态 垂直居中
      .buildProperty(VAlignKey.V_CENTER, 24) // 垂直居中
      .buildProperty(VAlignKey.V_END, 38), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 30) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 32))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 24))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 251) // 居左对齐
      .buildProperty(HAlignKey.H_END, '63.7%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 78) // 居左对齐
      .buildProperty(HAlignKey.H_END, '100%') // 居右对齐
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
      .buildProperty(PocketVAlignKey.PV_CENTER, 240.4) // 小折叠产品折叠态 垂直居中
      .buildProperty(VAlignKey.V_CENTER, 24) // 垂直居中
      .buildProperty(VAlignKey.V_END, 38), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 30) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 32))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 24))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 251) // 居左对齐
      .buildProperty(HAlignKey.H_END, '63.7%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 78) // 居左对齐
      .buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: '50%', y: 39 },
    anchor: { x: '50%', y: 0 },
    fontSize: 16, // 高度19fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 16)
      .buildProperty(FontSizeKey.POCKETKNIVES, 19.7),
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 47) // 垂直居中
      .buildProperty(VAlignKey.V_END, 61) // 底部对齐
      .buildProperty(PocketVAlignKey.PV_CENTER, 265.4), // 小折叠产品折叠态 垂直居中
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 30) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 32))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 24))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 251) // 居左对齐
      .buildProperty(HAlignKey.H_END, '63.7%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 78) // 居左对齐
      .buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  .bindExpandElement({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: '50%', y: 39 },
    anchor: { x: '50%', y: 0 },
    fontSize: 14, // 高度17fp
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    maxWidth: 189, // 跑马灯最大宽度
    dynamicFontSizeMap: DynamicNumber.wrapper()
      .buildProperty(FontSizeKey.DEFAULT, 14)
      .buildProperty(FontSizeKey.POCKETKNIVES, 16.4),
    dynamicTextAlignMap: DynamicNumber.wrapper()
      .buildProperty(HAlignKey.H_START, ClockTextAlign.LEFT) // 居左对齐
      .buildProperty(HAlignKey.H_END, ClockTextAlign.RIGHT), // 居右对齐
    dynamicOffsetYMap: DynamicLength.wrapper()
      .buildProperty(VAlignKey.V_CENTER, 47) // 垂直居中
      .buildProperty(VAlignKey.V_END, 61), // 底部对齐
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_START, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_FORM, 30) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 32))
      .buildProperty(VAlignKey.V_CENTER, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 1) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 22) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 24))
      .buildProperty(VAlignKey.V_END, DynamicNumber.wrapper()
        .buildProperty(SignFormKey.VISIBLE_SIGN, 2) // 显示签名时，向下偏移
        .buildProperty(SignFormKey.VISIBLE_FORM, 8) // 显示服务卡片时，保持最底部
        .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 10)),
    dynamicOffsetXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 251) // 居左对齐
      .buildProperty(HAlignKey.H_END, '63.7%'), // 居右对齐
    dynamicAnchorXMap: DynamicLength.wrapper()
      .buildProperty(HAlignKey.H_START, 78) // 居左对齐
      .buildProperty(HAlignKey.H_END, '100%') // 居右对齐
  })
  // 收起样式元素配置
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
    anchor: { x: '50%', y: 0 }, // 用锚点和偏移配合保持居中
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
    textAlign: ClockTextAlign.CENTER,
    maxWidth: 208, // 跑马灯最大宽度
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
    timeTextWidth: 72,
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
    dynamicLunar: true,
  })
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_01) as ClockStyleConfig;

export const aodComClock01V: AodClockStyleConfig = aodClock01.copy(ClockLayout.DEFAULT_CLOCK_REVERSE_LAYOUT);
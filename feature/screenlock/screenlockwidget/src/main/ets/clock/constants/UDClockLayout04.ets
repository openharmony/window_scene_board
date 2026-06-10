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
import { ClockComFamily, ClockLayout, ClockWidgetId, ClockTextAlign } from '../../common/WidgetParam';
import { ClockStyleConfig } from '../model/data/ClockStyleConfig';
import { UDFontAdapterUtil } from '../common/UDFontAdapterUtil';
import { comClock04 } from './ComClockLayout04';
import { AodClockStyleConfig } from '../model/data/AodClockStyleConfig';
import { DynamicAlignDy } from '../common/DynamicAlignDy';
import { DateWeekLunarStyle } from '../common/ClockConstants';
import { VAlignKey } from '../common/HorizontalVerticalAlign';
import { SignFormKey } from '../common/SignFormKey';
import { DynamicNumber } from '../common/DynamicNumber';
import { SizeBpSplice } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/utils/ScreenBreakPoint';

/**
 * UD数字时钟04
 * 单个元素的布局属性
 */
export const udClock04: ClockStyleConfig = comClock04.copy(
  UDFontAdapterUtil.getLayout4UD(ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL))
  .bindExpandElement({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: '50%', y: 119 },
    anchor: { x: 0, y: 0 },
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_CENTER,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 17)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 17))
      .buildProperty(VAlignKey.V_START,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 17)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 17))
      .buildProperty(VAlignKey.V_END,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 17)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 17))
  })
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_ULT_2_4) as ClockStyleConfig;

export const aodUdClock04: AodClockStyleConfig = AodClockStyleConfig.wrap(
  UDFontAdapterUtil.getLayout4UD(ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL))
// 局部AOD样式元素配置
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR0,
    offset: { x: 68, y: 23 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_HOUR1,
    offset: { x: 90, y: 23 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_SEPARATOR,
    offset: { x: 111, y: 23 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE0,
    offset: { x: 122, y: 23 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_MINUTE1,
    offset: { x: 143, y: 23 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_DATE,
    offset: { x: 68, y: 52 },
    anchor: { x: 0, y: 0 },
    fontSize: 50,
    fontSizeScale: 0.7,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_WEEK,
    offset: { x: 170, y: 50 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_LUNA,
    offset: { x: 170, y: 65 },
    anchor: { x: 0, y: 0 },
    fontSize: 16,
    fontSizeScale: 0.875,
    isShow: true,
    textAlign: ClockTextAlign.LEFT,
  })
  .bindAodClockLayout({
    id: ClockWidgetId.ID_COM_SIGN,
    offset: { x: 68, y: 84 },
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
    offset: { x: '50%', y: 91 },
    anchor: { x: 0, y: 0 },
    dynamicAlignDyMap: DynamicAlignDy.wrapper()
      .buildProperty(VAlignKey.V_CENTER,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 17)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 17))
      .buildProperty(VAlignKey.V_START,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 17)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 17))
      .buildProperty(VAlignKey.V_END,
        DynamicNumber.wrapper().buildProperty(SignFormKey.VISIBLE_SIGN, 17)
          .buildProperty(SignFormKey.VISIBLE_SIGN_FORM, 17))
  })
  .bindAodClockMargin({
    top: 157,
    left: 24,
  })

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
import { ClockStyleConfig } from '../model/data/ClockStyleConfig';
import { UDFontAdapterUtil } from '../common/UDFontAdapterUtil';
import { aodClock02, comClock02 } from './ComClockLayout02';
import { AodClockStyleConfig } from '../model/data/AodClockStyleConfig';
import { DynamicAlignDy } from '../common/DynamicAlignDy';
import { SignFormKey } from '../common/SignFormKey';
import { VAlignKey } from '../common/HorizontalVerticalAlign';
import { DynamicNumber } from '../common/DynamicNumber';

/**
 * UD数字时钟02
 * 单个元素的布局属性
 */
export const udClock02: ClockStyleConfig = comClock02.copy(
  UDFontAdapterUtil.getLayout4UD(ClockLayout.NORMAL_CLOCK_LAYOUT))
  .bindExpandElement({
    id: ClockWidgetId.ID_BATTERY,
    fontSize: 0,
    isShow: true,
    textAlign: ClockTextAlign.CENTER,
    offset: { x: '50%', y: 127 },
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
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_ULT_2_4) as ClockStyleConfig;

export const aodUdClock02: AodClockStyleConfig = aodClock02.copy(
  UDFontAdapterUtil.getLayout4UD(ClockLayout.NORMAL_CLOCK_LAYOUT))
  .bindFontFamily(ClockComFamily.HARMONY_CLOCK_ULT_2_4) as AodClockStyleConfig;
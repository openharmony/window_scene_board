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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level, expect } from '@ohos/hypium';
import { BaseState, WBaseProperty } from '@ohos/screenlockcommon';
import { ImmersiveAnimParam } from '../../../../../../main/ets/common/anim/ImmersiveAnimParam';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

export function ImmersiveAnimParamTest() {
  describe('ImmersiveAnimParamTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('ImmersiveAnimParam_create', Level.LEVEL1, (): void => {
      let param = new ImmersiveAnimParam()
        .animPros([WBaseProperty.ALPHA])
        .animStartValue([1])
        .animEndValue([1])
        .animDuration(10)
        .animCurve(Curve.Linear)
        .animDelay(12)
        .animFinish(() => {});
      param.setStateToStart(BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'test'));
      param.setStateToEnd(BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'test'));
      param.clearStatePro(BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'test'));
      expect(param).not().assertNull();
    });
  });
}
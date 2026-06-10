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
import { ImmersiveAnimUnit, ImmersiveAnimNode } from '../../../../../../main/ets/common/anim/ImmersiveAnimUnit';
import { WBaseProperty, BaseState } from '@ohos/screenlockcommon';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

export function ImmersiveAnimUnitTest() {
  describe('ImmersiveAnimUnitTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('ImmersiveAnimUnit_create', Level.LEVEL1, (): void => {
      let unit = new ImmersiveAnimUnit()
        .addAnimNode(
          new ImmersiveAnimNode(BaseState.wrap<WidgetAnimState>(WidgetAnimState,'test'))
            .addPropValue({ type: WBaseProperty.ALPHA, start: 1, end: 1 })
            .setPropValue({ type: WBaseProperty.ALPHA, start: 1, end: 1 })
            .enableClip(true)
        )
        .animDuration(10)
        .animCurve(Curve.Linear)
        .animDelay(1)
        .animFinish(() => {});
      unit.setStateToStart();
      unit.setStateToEnd();
      unit.clearState();
      expect(unit).not().assertNull();
    });

    it('ImmersiveAnimNode_create', Level.LEVEL1, (): void => {
      let animnode = new ImmersiveAnimNode(BaseState.wrap<WidgetAnimState>(WidgetAnimState,'test'))
        .addPropValue({ type: WBaseProperty.ALPHA, start: 1, end: 1 })
        .setPropValue({ type: WBaseProperty.ALPHA, start: 1, end: 1 })
        .enableClip(true);
      animnode.clearState();
      (animnode as object)['state'] = undefined;
      animnode.setStateToStart();
      animnode.setStateToEnd();
      animnode.clearState();
      expect(animnode).not().assertNull();
    });
  });
}
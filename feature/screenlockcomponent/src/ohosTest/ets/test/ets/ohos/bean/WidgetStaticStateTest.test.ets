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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import {
  SlMainStateType,
  SlSubStateType,
  WidgetBindStateType,
  WidgetStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState, SlObject, WidgetArea, WidgetPivot } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';

export default function WidgetStaticStateTest() {
  let mainType: SlMainStateType;
  describe('WidgetStaticStateTest', (): void => {
    let mWidgetStaticState: WidgetStaticState<SlSubStateType> = new WidgetStaticState(mainType);
    let subType: WidgetStaticStateType;
    let area: WidgetArea = {
      globalX: 1,
      globalY: 1,
      width: 1,
      height: 1
    };
    let pivot: WidgetPivot = {
      centerX: 2,
      centerY: 2,
      centerZ: 2
    }
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getSlStateType_return', 0, (): void => {
      let result = mWidgetStaticState.getSlStateType();
      expect(result).not().assertNull();
    })

    it('test_setSlState_return', 0, (): void => {
      let value: SlObject = 1;
      let result = mWidgetStaticState.setSlState(subType, value);
      expect(result).not().assertNull();
    })

    it('test_getSlState_return', 0, (): void => {
      let scene: SlObject = 0;
      mWidgetStaticState.setWidgetArea();
      let result = mWidgetStaticState.getSlState(subType, scene);
      expect(result).not().assertNull();
    })

    it('test_setWidgetArea_return', 0, (): void => {
      mWidgetStaticState.setWidgetArea(area);
      expect(mWidgetStaticState.getSlStateType()).assertEqual(undefined);
    })

    it('test_getWidgetArea_return', 0, (): void => {
      let result = mWidgetStaticState.getWidgetArea();
      mWidgetStaticState.setWidgetScreenPivot();
      expect(result).not().assertNull();
    })

    it('test_setWidgetScreenPivot_return', 0, (): void => {
      mWidgetStaticState.setWidgetScreenPivot(pivot);
      expect(mWidgetStaticState.getSlStateType()).assertEqual(undefined);
    })

    it('test_getWidgetScreenPivot_return', 0, (): void => {
      let result = mWidgetStaticState.getWidgetScreenPivot();
      expect(result).not().assertNull();
    })

  })
}
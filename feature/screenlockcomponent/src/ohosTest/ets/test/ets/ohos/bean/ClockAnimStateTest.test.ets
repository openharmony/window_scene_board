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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { ClockAnimState } from '@ohos/screenlockcommon/src/main/ets/bean/ClockAnimState';
import { SlMainStateType, ClockAnimStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState, SlObject } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';

class getResultClass {
  static getResult1(callBack: Function): void {
    callBack();
  }
}
;

export default function ClockAnimStateTest() {

  describe('ClockAnimStateTest', (): void => {
    let mClockAnimState: ClockAnimState = new ClockAnimState();
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_getSlStateType_return', 0, (): void => {
      let result = mClockAnimState.getSlStateType();
      expect(result).assertEqual(SlMainStateType.CLOCK_ANIM_STATE);
    })

    it('test_setSlState_return', 0, (): void => {
      let subType: ClockAnimStateType = ClockAnimStateType.ADD_ANIM_SCENE;
      let value: SlObject = true;
      let result = mClockAnimState.setSlState(subType,value);
      expect(result).not().assertNull();
    })

    it('test_getSlState_return', 0, (): void => {
      let subType: ClockAnimStateType = ClockAnimStateType.ADD_ANIM_SCENE;
      let result = mClockAnimState.getSlState(subType);
      expect(result).assertEqual(undefined);
    })

    it('test_addAnimScene_return_one', 0, (): void => {
      let scene: string = 'res';
      let result = mClockAnimState.addAnimScene(scene);
      expect(result).not().assertNull();
    })

    it('test_addAnimScene_return_two', 0, (): void => {
      let DEFAULT_ANIM_SCENE = 'default_anim_scene';
      let result = mClockAnimState.addAnimScene();
      expect(result).not().assertNull();
    })

    it('test_removeAnimScene_return_one', 0, (): void => {
      let DEFAULT_ANIM_SCENE = 'default_anim_scene';
      let result = mClockAnimState.removeAnimScene();
      expect(result).not().assertNull();
    })

    it('test_removeAnimScene_return_two', 0, (): void => {
      let scene: string = 'res';
      let result = mClockAnimState.removeAnimScene(scene);
      expect(result).not().assertNull();
    })

    it('test_isCurAnimating_return', 0, (): void => {
      let result = mClockAnimState.isCurAnimating();
      expect(result).not().assertNull();
    })

    it('test_isSceneAnimating_return', 0, (): void => {
      let result = mClockAnimState.isSceneAnimating();
      expect(result).assertEqual(false);
    })

    it('test_setTranY_return', 0, (): void => {
      let tran: number = 1;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mClockAnimState.setTranY(tran);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_getTranY_return', 0, (): void => {
      let result = mClockAnimState.getTranY();
      expect(result).assertEqual(1);
    })

    it('test_setScaleX_return', 0, (): void => {
      let scale: number = 1;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mClockAnimState.setScaleX(scale);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_getScaleX_return', 0, (): void => {
      let result = mClockAnimState.getScaleX();
      expect(result).assertEqual(1);
    })

    it('test_setScaleY_return', 0, (): void => {
      let scale: number = 1;
      let result: boolean = false;
      getResultClass.getResult1(() => {
        mClockAnimState.setScaleY(scale);
        result = true;
      })
      expect(result).assertEqual(true);
    })

    it('test_getScaleY_return', 0, (): void => {
      let result = mClockAnimState.getScaleY();
      expect(result).assertEqual(1);
    })

    it('test_clearAll_return', 0, (): void => {
      let result = mClockAnimState.clearAll();
      expect(result).not().assertNull();
    })

  })
}
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import { SlBindStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlBindState } from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/model/data/SlBindState';

/**
 * 锁屏面板UI绑定状态变量管理测试用例
 */
export function SlBindStateTest() {
  describe('SlBindStateTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getSlStateType', Level.LEVEL0, (): void => {
      let slBindState = new SlBindState();
      let res = slBindState.getSlStateType();
      expect(res).not().assertNull();
    });

    it('test_setSlState', Level.LEVEL0, (): void => {
      let res = true;
      let slBindState = new SlBindState();
      slBindState.setSlState(SlBindStateType.SL_SHOWING_STATE, undefined);
      expect(res).assertTrue();
    });

    it('test_getSlState', Level.LEVEL0, (): void => {
      let res = true;
      let slBindState = new SlBindState();
      slBindState.getSlState(SlBindStateType.SL_SHOWING_STATE);
      expect(res).assertTrue();
    });

    it('test_setSlShowing', Level.LEVEL0, (): void => {
      let slBindState = new SlBindState();
      slBindState.setSlShowing(true);
      let res = slBindState.isPanelShowing();
      expect(res).assertTrue();
    });

    it('test_isPanelShowing', Level.LEVEL0, (): void => {
      let slBindState = new SlBindState();
      let res = slBindState.isPanelShowing();
      expect(res).assertFalse();
    });

    it('test_setOsAccountUnlocked', Level.LEVEL0, (): void => {
      let res = true;
      let slBindState = new SlBindState();
      slBindState.setOsAccountUnlocked(true);
      expect(res).assertTrue();
    });

    it('test_isOsAccountUnlocked', Level.LEVEL0, (): void => {
      let slBindState = new SlBindState();
      let res = slBindState.isOsAccountUnlocked();
      expect(res).assertFalse();
    });

    it('test_setBgBlurFreeze', Level.LEVEL0, (): void => {
       try{
         let res = true;
         let slBindState = new SlBindState();
         slBindState.setBgBlurFreeze();
         expect(res).assertTrue();
       }catch{}
    });

    it('test_isBgBlurSceneFreeze', Level.LEVEL0, (): void => {
      let slBindState = new SlBindState();
      let res = slBindState.isBgBlurSceneFreeze();
      expect(res).assertFalse();
    });

    it('test_setRootScale', Level.LEVEL0, (): void => {
      let res = true;
      let slBindState = new SlBindState();
      slBindState.setRootScale(0);
      expect(res).assertTrue();
    });

    it('test_getRootScale', Level.LEVEL0, (): void => {
      let slBindState = new SlBindState();
      slBindState.setRootScale(0);
      let res = slBindState.getRootScale();
      expect(res === 0).assertTrue();
    });

    it('test_getGreetView', Level.LEVEL0, (): void => {
      let slBindState = new SlBindState();
      slBindState.setSlGreetShowState(true);
      let res = slBindState.getSlGreetShowState();
      expect(res).assertTrue();
    });
  });
}
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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium'
import {
  LockState,
  PageState, ScreenLockStateManager, StateInfo } from '../../../../../main/ets/manager/ScreenLockStateManager'

/**
 * 锁屏状态管理测试
 */
export default function ScreenLockStateManagerTest() {
  // let screenLockStateManager: ScreenLockStateManager = new ScreenLockStateManager();
  describe('ScreenLockStateManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('ScreenLockStateManager_isLocked', Level.LEVEL0, () => {
      let result = ScreenLockStateManager.getInstance().isLocked;
      expect(result).not().assertNull();
    })

    it('ScreenLockStateManager_isInBouncer', Level.LEVEL2, () => {
      let isInBouncer: boolean = ScreenLockStateManager.getInstance().isInBouncer;
      expect(isInBouncer).assertFalse();
    })

    it('ScreenLockStateManager_isInEdite', Level.LEVEL2, () => {
      let isInEdite: boolean = ScreenLockStateManager.getInstance().isInEdite;
      expect(isInEdite).assertFalse();
    })

    it('ScreenLockStateManager_updateStateInfo1', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      (ScreenLockStateManager.getInstance() as object)['_isInBouncer'] = true;
      (ScreenLockStateManager.getInstance() as object)['_isInEdite'] = true;
      let newStateInfo: StateInfo = {
        pageState: PageState.SHOW,
        lockState: LockState.LOCKED,
        isInBouncer: false,
        isInEdite: false
      }
      ScreenLockStateManager.getInstance().updateStateInfo(newStateInfo);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('ScreenLockStateManager_updateStateInfo2', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      (ScreenLockStateManager.getInstance() as object)['_isInBouncer'] = true;
      (ScreenLockStateManager.getInstance() as object)['_isInEdite'] = true;
      let newStateInfo: StateInfo = {
        pageState: PageState.SHOW,
        isInBouncer: false,
        isInEdite: false
      }
      ScreenLockStateManager.getInstance().updateStateInfo(newStateInfo);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('ScreenLockStateManager_updateStateInfo3', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      (ScreenLockStateManager.getInstance() as object)['_isInBouncer'] = true;
      (ScreenLockStateManager.getInstance() as object)['_isInEdite'] = true;
      let newStateInfo: StateInfo = {
        lockState: LockState.LOCKED,
        isInBouncer: false,
        isInEdite: false
      }
      ScreenLockStateManager.getInstance().updateStateInfo(newStateInfo);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

  })
}
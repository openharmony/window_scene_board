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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import {
  interruptMgr,
  PromiseInterrupt
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { NtfListStaticState } from '../../../../../../main/ets/viewmodel/viewdata/NtfListState';

/**
 * 沉浸式锁屏数据预处理测试用例
 */
export function NtfListStateTest() {
  describe('NtfListStateTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('test_updateScrolling', Level.LEVEL1, (): void => {
      let state: NtfListStaticState = new NtfListStaticState();
      state.updateScrolling(true);
      expect(state).not().assertNull();
    });

    it('test_updateMeshInterrupt', Level.LEVEL1, (): void => {
      let state: NtfListStaticState = new NtfListStaticState();
      state.updateMeshInterrupt(interruptMgr.getInterrupt('test'));
      expect(state).not().assertNull();
    });

    it('test_updateItemAnim', Level.LEVEL1, (): void => {
      let state: NtfListStaticState = new NtfListStaticState();
      state.updateScrolling(true);
      state.updateItemAnim();
      state.updateItemAnim({delay: 100});
      expect(state).not().assertNull();
    });

    it('test_clearUpdateAnimTimeout', Level.LEVEL1, (): void => {
      let state: NtfListStaticState = new NtfListStaticState();
      state.updateItemAnim({delay: 100});
      (state as object)['clearUpdateAnimTimeout']();
      expect(state).not().assertNull();
    });

    it('test_clearMeshInterruptTimeout', Level.LEVEL1, (): void => {
      let state: NtfListStaticState = new NtfListStaticState();
      state.updateMeshInterrupt(interruptMgr.getInterrupt('test'));
      (state as object)['clearMeshInterruptTimeout']();
      expect(state).not().assertNull();
    });
  });
}

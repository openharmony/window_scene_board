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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { ImmersiveState, ImmersiveType } from '@ohos/systemuicommon';
import {
  immersiveStateMgr,
  IImmersiveState,
} from '../../../../../../main/ets/common/manager/ImmersiveStateManager';

/**
 * 沉浸式锁屏状态管理测试用例
 */
export function ImmersiveStateManagerTest() {
  describe('ImmersiveStateManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      expect(res !== undefined).assertTrue();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      expect(immersiveStateMgr).not().assertNull();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state?: IImmersiveState) => {
        return 0;
      });
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener((state?: IImmersiveState) => {
        return 0;
      });
      expect(immersiveStateMgr).not().assertNull();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });
  });
}
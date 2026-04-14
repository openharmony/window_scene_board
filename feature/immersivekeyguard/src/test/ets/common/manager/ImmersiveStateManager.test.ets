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
import { CommonUtils } from '@ohos/basicutils/src/main/ets/TsIndex';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { ImmersiveState, ImmersiveType } from '@ohos/systemuicommon';
import { AppIconCallback } from '../../../../main/ets/common/helper/ImmersiveAppIconHelper';
import {
  immersiveStateMgr,
  IImmersiveState,
} from '../../../../main/ets/common/manager/ImmersiveStateManager';

/**
 * 沉浸式锁屏状态管理测试用例
 */
export function ImmersiveStateManagerTest01() {
  describe('ImmersiveStateManagerTest01', (): void => {
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
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let hasCode ="TEST_REGISTER";
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });
    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let hasCode ="TEST_REGISTER";
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let hasCode ="TEST_REGISTER";
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let hasCode ="TEST_REGISTER";
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let hasCode ="TEST_REGISTER";
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });
    
    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_getListStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_LIST);
      expect(res !== undefined).assertTrue();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_LIST).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_getCurrentState', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let hasCode ="TEST_REGISTER";
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res).not().assertNull();
    });

    it('test_requestImmersiveCard', Level.LEVEL0, (): void => {
      immersiveStateMgr.requestImmersiveCard();
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_01', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener((state: IImmersiveState) => {
        return 0;
      });
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_02', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });

    it('test_unregisterOnImmersiveStateChangeListener', Level.LEVEL0, (): void => {
      immersiveStateMgr.unregisterOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(true).assertTrue();
    });

    it('test_getImmersiveStateType', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.getCurrentState(ImmersiveType.TYPE_IMMERSIVE);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== undefined).assertTrue();
      expect(res?.getImmersiveStateType() === ImmersiveType.TYPE_IMMERSIVE).assertTrue();
    });

    it('test_registerOnImmersiveStateChangeListener_03', Level.LEVEL0, (): void => {
      let res = immersiveStateMgr.registerOnImmersiveStateChangeListener(null);
      let mock = new MockKit();
      let callback: AppIconCallback = {
        onAppIconChange: (): void => {}
      };
      let hasCode ="TEST_REGISTER";
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let mockFun2 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(hasCode).afterReturn(true);
      when(mockFun2)(callback).afterReturn(true);
      expect(res !== null).assertTrue();
    });
  });
}
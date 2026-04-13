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

import { MemoryManager } from '@ohos/frameworkcommon';
import {
  ControlBrightnessManager
} from '@ohos/brightnesscomponent/src/main/ets/default/ControlBrightnessManager';
import { afterAll, afterEach, beforeEach, it, describe, expect, MockKit, beforeAll, when } from '@ohos/hypium';


export function ControlBrightnessManagerTest() {

  describe('ControlBrightnessManagerTest', (): void => {
    let mocker: MockKit;
    beforeAll((): void => {
      mocker = new MockKit();
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {
      mocker.clearAll();
    })

    let mBrightnessManager = ControlBrightnessManager.getInstance();
    it('ControlBrightnessManagerTest_001', 0, (): void => {
      mBrightnessManager.init(5);
      mBrightnessManager.getMin();
      mBrightnessManager.getMax();
      mBrightnessManager.getDefault();
      mBrightnessManager.setBrightnessUiValue(undefined);
      mBrightnessManager.setBrightnessUiValue(10);
      (mBrightnessManager as object)['resetTaskFlags']();
      mBrightnessManager.setControlCenterVisible(false);
      mBrightnessManager.setControlCenterVisible(true);
      mBrightnessManager.registerBrightness();
      mBrightnessManager.unRegisterBrightness();
      expect(mBrightnessManager.isControlCenterVisible).assertTrue();
    })

    it('ControlBrightnessManagerTest_executeTaskDelay', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mBrightnessManager, (mBrightnessManager as object)['needExecuteTask']);
      when(mockFunc)().afterReturn(false);
      (mBrightnessManager as object)['executeTaskDelay']();
      when(mockFunc)().afterReturn(true);
      (mBrightnessManager as object)['executeTaskDelay']();
      (mBrightnessManager as object)['needExecuteTaskOnceMore'] = true;
      (mBrightnessManager as object)['resetTaskFlags']();
      expect((mBrightnessManager as object)['needExecuteTaskOnceMore']).assertFalse();
      mocker.clear(mBrightnessManager);
    })

    it('ControlBrightnessManagerTest_needExecuteTask_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(MemoryManager.getInstance(), MemoryManager.getInstance().checkIsStaticMemoryScene);
      when(mockFunc)().afterReturn(true);
      expect((mBrightnessManager as object)['needExecuteTask']()).assertFalse();
      mocker.clear(MemoryManager.getInstance());
    })

    it('ControlBrightnessManagerTest_needExecuteTask_2', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(MemoryManager.getInstance(), MemoryManager.getInstance().checkIsStaticMemoryScene);
      when(mockFunc)().afterReturn(false);
      (mBrightnessManager as object)['taskTimerId'] = undefined;
      expect((mBrightnessManager as object)['needExecuteTask']()).assertTrue();
      mocker.clear(MemoryManager.getInstance());
    })

    it('ControlBrightnessManagerTest_needExecuteTask_3', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(MemoryManager.getInstance(), MemoryManager.getInstance().checkIsStaticMemoryScene);
      when(mockFunc)().afterReturn(false);
      (mBrightnessManager as object)['taskTimerId'] = 1;
      mBrightnessManager.isControlCenterVisible = false;
      expect((mBrightnessManager as object)['needExecuteTask']()).assertTrue();
      mocker.clear(MemoryManager.getInstance());
    })

    it('ControlBrightnessManagerTest_needExecuteTask_4', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc(MemoryManager.getInstance(), MemoryManager.getInstance().checkIsStaticMemoryScene);
      when(mockFunc)().afterReturn(false);
      (mBrightnessManager as object)['taskTimerId'] = 1;
      mBrightnessManager.isControlCenterVisible = true;
      expect((mBrightnessManager as object)['needExecuteTask']()).assertFalse();
      mBrightnessManager.unRegisterBrightness();
      mocker.clear(MemoryManager.getInstance());
    })
  })
}

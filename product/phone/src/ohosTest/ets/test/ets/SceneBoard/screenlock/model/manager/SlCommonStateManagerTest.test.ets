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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import {
  slComStateMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/screenlock/model/manager/SlCommonStateManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';

/**
 * 锁屏状态工具测试用例
 */
export function SlCommonStateManagerTest() {
  let mocker: MockKit;
  describe('SlCommonStateManagerTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
      mocker.clearAll();
    });
    afterEach((): void => {
    });

    it('test_init', Level.LEVEL0, (): void => {
      slComStateMgr.init();
      expect(slComStateMgr).not().assertUndefined();
    });

    it('test_destroy', Level.LEVEL0, (): void => {
      slComStateMgr.destroy();
      expect(slComStateMgr).not().assertUndefined();
    });

    it('test_destroy', Level.LEVEL0, (): void => {
      slComStateMgr.setWidgetArea(SlMainStateType.SL_STATIC_STATE);
      expect(slComStateMgr).not().assertUndefined();
    });

    it('test_initDeviceType1', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockfunc_1)().afterReturn(true);
      (slComStateMgr as object)['initDeviceType']();
      expect(slComStateMgr).not().assertUndefined();
      mocker.clear(DeviceHelper);
    });

    it('test_initDeviceType2', Level.LEVEL0, (): void => {
      let mockfunc_1 = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockfunc_2 = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockfunc_1)().afterReturn(false);
      when(mockfunc_2)().afterReturn(true);
      (slComStateMgr as object)['initDeviceType']();
      expect(slComStateMgr).not().assertUndefined();
      mocker.clear(DeviceHelper);
    });
  });
}
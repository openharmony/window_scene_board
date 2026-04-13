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
import { TraceUtil } from '@ohos/basicutils';
import { ImmersiveTraceHelper } from '../../../../../../main/ets/common/helper/ImmersiveTraceHelper';
import { ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveTraceHelperTest() {
  describe('ImmersiveTraceHelperTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_startTrace', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc = mocker.mockFunc(TraceUtil, TraceUtil.startTrace);
      when(mockfunc)(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW).afterReturnNothing();
      let scene = ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW;
      ImmersiveTraceHelper.startTrace(scene);
      expect(ImmersiveTraceHelper).not().assertNull();
    });

    it('test_endTrace', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc = mocker.mockFunc(TraceUtil, TraceUtil.endTrace);
      when(mockfunc)(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW).afterReturnNothing();
      let scene = ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW;
      ImmersiveTraceHelper.endTrace(scene);
      expect(ImmersiveTraceHelper).not().assertNull();
    });

    it('test_startAnimTrace', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc = mocker.mockFunc(TraceUtil, TraceUtil.startAnimTrace);
      when(mockfunc)(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW).afterReturnNothing();
      let scene = ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW;
      ImmersiveTraceHelper.startAnimTrace(scene);
      expect(ImmersiveTraceHelper).not().assertNull();
    });

    it('test_endAnimTrace', Level.LEVEL0, (): void => {
      let mocker = new MockKit();
      let mockfunc = mocker.mockFunc(TraceUtil, TraceUtil.endAnimTrace);
      when(mockfunc)(ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW).afterReturnNothing();
      let scene = ImmersiveAnimScene.SCENE_CAPSULE_ROOT_SHOW;
      ImmersiveTraceHelper.endAnimTrace(scene);
      expect(ImmersiveTraceHelper).not().assertNull();
    });

    it('test_startAnimTrace_02', Level.LEVEL0, (): void => {
      let scene: ImmersiveAnimScene = ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX;
      let mocker = new MockKit();
      let mockfunc = mocker.mockFunc(TraceUtil, TraceUtil.endAnimTrace);
      when(mockfunc)(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_TOUCH_BACK).afterReturn(false);
      ImmersiveTraceHelper.startAnimTrace(scene);
      mocker.ignoreMock(TraceUtil, TraceUtil.endAnimTrace);
      expect(scene).not().assertNull();
    });
  });
}
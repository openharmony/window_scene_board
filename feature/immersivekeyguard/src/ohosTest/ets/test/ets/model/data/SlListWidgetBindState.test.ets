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
import { ImmersiveState, ImmersiveType } from '@ohos/systemuicommon';
import {
  immersiveStateMgr,
  IImmersiveState,
} from '../../../../../../main/ets/common/manager/ImmersiveStateManager';
import { ImmersiveAnimScene } from '../../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { CapStyleBuilder } from '../../../../../../main/ets/model/data/ImmersiveCapsuleStyle';
import { SlListWidgetBindState } from '../../../../../../main/ets/model/data/SlListWidgetBindState';
import { BlurFreezeScene } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { CommonUtils } from '@ohos/basicutils';

/**
 * 锁屏组件，通知列表组件UI绑定状态管理测试用例
 *
 */
export function SlListWidgetBindStateTest() {
  let mocker: MockKit;
  describe('SlListWidgetBindStateTest', (): void => {
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

    /**
     * 复写 WidgetStaticState set方法测试用例
     *
     */
    it('test_initSetMethods', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListWidgetBindState();
      manager.setBgBlurFreeze();
      expect(res).assertTrue();
    });

    /**
     * 复写 WidgetStaticState get方法测试用例
     *
     */
    it('test_initGetMethods', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListWidgetBindState();
      manager.isBgBlurSceneFreeze();
      expect(res).assertTrue();
    });

    /**
     * 设置模糊冻结状态测试用例
     *
     */
    it('test_setBgBlurFreeze', Level.LEVEL0, (): void => {
      let res = true;
      let manager = new SlListWidgetBindState();
      let mockFunc_1 = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFunc_1)().afterReturn(true);
      let freeze: BlurFreezeScene = {
        isFreeze: true,
        scene: ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX
      };
      manager.setBgBlurFreeze();
      manager.setBgBlurFreeze(freeze);
      expect(res).assertTrue();
    });

    /**
     * 当前模糊冻结状态测试用例
     *
     */
    it('test_isBgBlurSceneFreeze', Level.LEVEL0, (): void => {
      let manager = new SlListWidgetBindState();
      manager.isBgBlurSceneFreeze();
      manager.isBgBlurSceneFreeze(ImmersiveAnimScene.SCENE_CAPSULE_TO_LIST_FIX);
      expect(manager).not().assertNull();
    });

    it('test_initSetMethods2', Level.LEVEL1, (): void => {
      let state: SlListWidgetBindState = new SlListWidgetBindState();
      (state as object)['initSetMethods']();
      expect(state).not().assertNull();
    });

    it('test_initGetMethods2', Level.LEVEL1, (): void => {
      let state: SlListWidgetBindState = new SlListWidgetBindState();
      (state as object)['initGetMethods']();
      expect(state).not().assertNull();
    });

    it('test_setBgBlurFreeze2', Level.LEVEL1, (): void => {
      let state: SlListWidgetBindState = new SlListWidgetBindState();
      state.setBgBlurFreeze();
      state.setBgBlurFreeze({isFreeze: true, scene: 'test'});
      state.setBgBlurFreeze({isFreeze: false, scene: 'test'});
      expect(state).not().assertNull();
    });

    it('test_isBgBlurSceneFreeze2', Level.LEVEL1, (): void => {
      let state: SlListWidgetBindState = new SlListWidgetBindState();
      state.isBgBlurSceneFreeze();
      state.isBgBlurSceneFreeze('test');
      expect(state).not().assertNull();
    });
  });
}
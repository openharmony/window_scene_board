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

import {
  OneMirrorStaticStateType,
  SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { immersiveStateHelper } from '../../../../../../main/ets/common/helper/ImmersiveStateHelper';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveStateHelperTest() {
  describe('ImmersiveStateHelperTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getImmerseCardStaticState', Level.LEVEL0, (): void => {
      (immersiveStateHelper as object)['slImmerseCardStaticState'] = undefined;
      immersiveStateHelper.getImmerseCardStaticState();
      expect(immersiveStateHelper.getImmerseCardStaticState()).not().assertNull();
    });

    it('test_getImmerseCardAnimState', Level.LEVEL0, (): void => {
      (immersiveStateHelper as object)['slImmerseCardStaticState'] = undefined;
      (immersiveStateHelper as object)['slImmerseCardAnimState'] = undefined;
      immersiveStateHelper.getImmerseCardAnimState();
      expect(immersiveStateHelper.getImmerseCardAnimState()).not().assertNull();
    });

    it('test_getSlCapsuleWidgetBindState', Level.LEVEL0, (): void => {
      (immersiveStateHelper as object)['slCapsuleWidgetBindState'] = undefined;
      immersiveStateHelper.getSlCapsuleWidgetBindState();
      expect(immersiveStateHelper.getSlCapsuleWidgetBindState()).not().assertNull();
    });

    it('test_getSlCapsuleStaticState', Level.LEVEL0, (): void => {
      (immersiveStateHelper as object)['slImmerseCapStaticState'] = undefined;
      immersiveStateHelper.getSlCapsuleStaticState();
      expect(immersiveStateHelper.getSlCapsuleStaticState()).not().assertNull();
    });

    it('test_getImmerseCapsuleAnimState', Level.LEVEL0, (): void => {
      (immersiveStateHelper as object)['slImmerseCapStaticState'] = undefined;
      (immersiveStateHelper as object)['slCapsuleAnimState'] = undefined;
      immersiveStateHelper.getImmerseCapsuleAnimState();
      expect(immersiveStateHelper.getImmerseCapsuleAnimState()).not().assertNull();
    });

    it('test_getSlBindState', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slBindState'] = undefined;
      immersiveStateHelper.getSlBindState();
      (immersiveStateHelper as object)['slBindState'] = state;
      immersiveStateHelper.getSlBindState();
      expect(immersiveStateHelper.getSlBindState()).not().assertNull();
    });

    it('test_getSlStaticState', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slBindState'] = undefined;
      immersiveStateHelper.getSlStaticState();
      (immersiveStateHelper as object)['slBindState'] = state;
      immersiveStateHelper.getSlStaticState();
      expect(immersiveStateHelper.getSlStaticState()).not().assertNull();
    });

    it('test_getSlListBindState', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slListBindState'] = undefined;
      immersiveStateHelper.getSlListBindState();
      (immersiveStateHelper as object)['slListBindState'] = state;
      immersiveStateHelper.getSlListBindState();
      expect(immersiveStateHelper.getSlListBindState()).not().assertNull();
    });

    it('test_getSlListStaticState', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slListStaticState'] = undefined;
      immersiveStateHelper.getSlListStaticState();
      (immersiveStateHelper as object)['slListStaticState'] = state;
      immersiveStateHelper.getSlListStaticState();
      expect(immersiveStateHelper.getSlListStaticState()).assertEqual(state);
    });

    it('test_getSlListAnimState', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slListStaticState'] = undefined;
      immersiveStateHelper.getSlListAnimState();
      (immersiveStateHelper as object)['slListStaticState'] = state;
      (immersiveStateHelper as object)['slListAnimState'] = state;
      immersiveStateHelper.getSlListAnimState();
      expect(immersiveStateHelper.getSlListAnimState()).assertEqual(state);
    });

    it('test_getSlListAnimState_02', Level.LEVEL0, (): void => {
      (immersiveStateHelper as object)['slListStaticState'] = undefined;
      immersiveStateHelper.getSlListAnimState();
      expect(immersiveStateHelper.getSlListAnimState()).not().assertNull();
    });

    it('test_getSlClockBindState', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slClockStaticCtrl'] = undefined;
      immersiveStateHelper.getSlClockBindState();
      (immersiveStateHelper as object)['slClockStaticCtrl'] = state;
      immersiveStateHelper.getSlClockBindState();
      expect(immersiveStateHelper.getSlClockBindState()).assertEqual(state);
    });

    it('test_getImmerseCardBindState', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slImmerseCardBindState'] = undefined;
      immersiveStateHelper.getImmerseCardBindState();
      (immersiveStateHelper as object)['slImmerseCardBindState'] = state;
      immersiveStateHelper.getImmerseCardBindState();
      expect(immersiveStateHelper.getImmerseCardBindState()).assertEqual(state);
    });

    it('test_getImmerseCardBindState_02', Level.LEVEL0, (): void => {
      (immersiveStateHelper as object)['slImmerseCardBindState'] = undefined;
      immersiveStateHelper.getImmerseCardBindState();
      (immersiveStateHelper as object)['slImmerseCardBindState'] = undefined;
      immersiveStateHelper.getImmerseCardBindState();
      expect(immersiveStateHelper.getImmerseCardBindState()).not().assertNull();
    });

    it('test_getImmerseCardStaticState_02', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slImmerseCardStaticState'] = undefined;
      immersiveStateHelper.getImmerseCardStaticState();
      (immersiveStateHelper as object)['slImmerseCardStaticState'] = state;
      immersiveStateHelper.getImmerseCardStaticState();
      expect(immersiveStateHelper.getImmerseCardStaticState()).assertEqual(state);
    });

    it('test_getSlCapsuleWidgetBindState_02', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slCapsuleWidgetBindState'] = undefined;
      immersiveStateHelper.getSlCapsuleWidgetBindState();
      (immersiveStateHelper as object)['slCapsuleWidgetBindState'] = state;
      immersiveStateHelper.getSlCapsuleWidgetBindState();
      expect(immersiveStateHelper.getSlCapsuleWidgetBindState()).assertEqual(state);
    });

    it('test_getSlCapsuleStaticState_02', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slImmerseCapStaticState'] = undefined;
      immersiveStateHelper.getSlCapsuleStaticState();
      (immersiveStateHelper as object)['slImmerseCapStaticState'] = true;
      immersiveStateHelper.getSlCapsuleStaticState();
      expect(immersiveStateHelper.getSlCapsuleStaticState()).assertTrue();
    });

    it('test_getImmerseCapsuleAnimState_02', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slImmerseCapStaticState'] = undefined;
      immersiveStateHelper.getImmerseCapsuleAnimState();

      (immersiveStateHelper as object)['slImmerseCapStaticState'] = state;
      (immersiveStateHelper as object)['slListAnimState'] = state;
      immersiveStateHelper.getImmerseCapsuleAnimState();

      (immersiveStateHelper as object)['slImmerseCapStaticState'] = state;
      (immersiveStateHelper as object)['slListAnimState'] = false;
      immersiveStateHelper.getImmerseCapsuleAnimState();

      (immersiveStateHelper as object)['slImmerseCapStaticState'] = false;
      (immersiveStateHelper as object)['slListAnimState'] = false;
      immersiveStateHelper.getImmerseCapsuleAnimState();
      expect(immersiveStateHelper.getImmerseCapsuleAnimState()).not().assertNull();
    });

    it('test_getOneMirrorStaticState', Level.LEVEL0, (): void => {
      let state:ISlState;
      slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE)
      ?.setSlState(OneMirrorStaticStateType.IS_HAS_BROAD_CASTING_CENTER, true);
      state = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE) as ISlState;
      (immersiveStateHelper as object)['slOneMirrorStaticState'] = undefined;
      immersiveStateHelper.getOneMirrorStaticState();
      (immersiveStateHelper as object)['slOneMirrorStaticState'] = state;
      immersiveStateHelper.getOneMirrorStaticState();
      expect(immersiveStateHelper.getImmerseCapsuleAnimState()).not().assertNull();
    });
  });
}
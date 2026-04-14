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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it
} from '@ohos/hypium';
import { BouncerStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/BouncerFsm';
import { MpStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/MainPageFsm';
import { CoreEvent, CoreEventType, CoreStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { SoStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenOffFsm';
import TestConst from '../../constants/TestConst';

export default function CounterCommandTestOne() {
  const persistentId: number = 1;

  describe('CounterCommandTestOne', (): void => {
    let screenLockFsmProxy: ScreenLockFsmProxy;
    let checkSubFsmState = (mpState: MpStateType, bouncerState: BouncerStateType, soState?: SoStateType): void => {
      expect(screenLockFsmProxy.mainPageFsm.currentStateType).assertEqual(mpState);
      expect(screenLockFsmProxy.bouncerFsm.currentStateType).assertEqual(bouncerState);
      if (soState !== undefined) {
        expect(screenLockFsmProxy.screenOffFsm.currentStateType).assertEqual(soState);
      }
    };

    // 状态预设函数
    const initState = (stateType: CoreStateType): CoreStateType => {
      switch (stateType) {
        case CoreStateType.INIT_STATE:
          break;
        case CoreStateType.MAIN_PAGE_LOCK_STATE:
        case CoreStateType.MAIN_PAGE_UNLOCK_STATE:
        case CoreStateType.BOUNCER_SIM_CHECK_STATE:
        case CoreStateType.UNLOCK_STATE:
          screenLockFsmProxy.matchCoreFsmChange(CoreStateType.INIT_STATE, stateType);
          break;
        case CoreStateType.MAIN_PAGE_EDIT_STATE:
          screenLockFsmProxy.matchCoreFsmChange(CoreStateType.INIT_STATE, CoreStateType.MAIN_PAGE_UNLOCK_STATE);
          screenLockFsmProxy.matchCoreFsmChange(CoreStateType.MAIN_PAGE_UNLOCK_STATE, stateType);
          break;
        case CoreStateType.MAIN_PAGE_FAKE_AOD_STATE:
        case CoreStateType.BOUNCER_TO_UNLOCK_STATE:
        case CoreStateType.BOUNCER_TO_EDIT_STATE:
        case CoreStateType.SCREEN_OFF_MP_LOCK_STATE:
          screenLockFsmProxy.matchCoreFsmChange(CoreStateType.INIT_STATE, CoreStateType.MAIN_PAGE_LOCK_STATE);
          screenLockFsmProxy.matchCoreFsmChange(CoreStateType.MAIN_PAGE_LOCK_STATE, stateType);
          break;
        case CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE:
        case CoreStateType.SCREEN_OFF_PWD_CHECK_STATE:
        case CoreStateType.SCREEN_OFF_SIM_CHECK_STATE:
        case CoreStateType.SCREEN_OFF_UNLOCK_STATE:
          screenLockFsmProxy.matchCoreFsmChange(CoreStateType.INIT_STATE, CoreStateType.MAIN_PAGE_LOCK_STATE);
          screenLockFsmProxy.matchCoreFsmChange(CoreStateType.MAIN_PAGE_LOCK_STATE,
            CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
          screenLockFsmProxy.matchCoreFsmChange(CoreStateType.SCREEN_OFF_MP_LOCK_STATE, stateType);
          break;
      }
      return stateType;
    };

    beforeAll((): void => {
    })
    beforeEach((): void => {
      screenLockFsmProxy = ScreenLockFsmProxy.getInstance(persistentId);
    })
    afterEach((): void => {
    })
    afterAll((): void => {
    })

    it('test_matchCoreFsmChange_when_init_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.INIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_LOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_LOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_init_to_mpu_return_mpu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.INIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_UNLOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_init_to_unlock_return_unlock', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.INIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.UNLOCK_STATE);

      checkSubFsmState(MpStateType.UNLOCK_STATE, BouncerStateType.UNLOCK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_init_to_simLock_return_simLock', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.INIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.SIM_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpl_to_mpu_return_mpu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_UNLOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpl_to_fa_return_fa', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      checkSubFsmState(MpStateType.NORMAL_FAKE_AOD_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpl_to_btu_return_btu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.PWD_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpl_to_bte_return_bte', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_TO_EDIT_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.PWD_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpl_to_bsc_return_bsc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.SIM_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpl_to_unlock_return_unlock', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.UNLOCK_STATE);

      checkSubFsmState(MpStateType.UNLOCK_STATE, BouncerStateType.UNLOCK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpl_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpu_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_LOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_LOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpu_to_mpe_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_EDIT_STATE);

      checkSubFsmState(MpStateType.EDIT_NORMAL_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpu_to_fa_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      checkSubFsmState(MpStateType.NORMAL_FAKE_AOD_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpu_to_bsc_return_bsc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.SIM_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpu_to_unlock_return_unlock', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.UNLOCK_STATE);

      checkSubFsmState(MpStateType.UNLOCK_STATE, BouncerStateType.UNLOCK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpu_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpe_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_LOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_LOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpe_to_mpu_return_mpu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_UNLOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpe_to_fa_return_fa', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      checkSubFsmState(MpStateType.NORMAL_FAKE_AOD_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpe_to_bsc_return_bsc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.SIM_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpe_to_unlock_return_unlock', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.UNLOCK_STATE);

      checkSubFsmState(MpStateType.UNLOCK_STATE, BouncerStateType.UNLOCK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_mpe_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_fa_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_LOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_LOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_fa_to_mpu_return_mpu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_UNLOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_fa_to_btu_return_btu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.PWD_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_fa_to_unlock_return_unlock', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.UNLOCK_STATE);

      checkSubFsmState(MpStateType.UNLOCK_STATE, BouncerStateType.UNLOCK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_fa_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_fa_to_sosc_return_sosc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_btu_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_LOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_LOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_btu_to_mpl_user_deactivate_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_LOCK_STATE,
        new CoreEvent(CoreEventType.USER_DEACTIVATE));

      checkSubFsmState(MpStateType.INACTIVE_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_btu_to_fa_return_fa', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      checkSubFsmState(MpStateType.NORMAL_FAKE_AOD_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_btu_to_bsc_return_bsc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.SIM_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_btu_to_unlock_return_unlock', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.UNLOCK_STATE);

      checkSubFsmState(MpStateType.UNLOCK_STATE, BouncerStateType.UNLOCK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_btu_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bte_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_LOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_LOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bte_to_mpe_return_mpe', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_EDIT_STATE);

      checkSubFsmState(MpStateType.EDIT_NORMAL_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bte_to_fa_return_fa', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      checkSubFsmState(MpStateType.NORMAL_FAKE_AOD_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bte_to_bsc_return_bsc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.SIM_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bte_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bsc_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_LOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_LOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bsc_to_mpu_return_mpu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_UNLOCK_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bsc_to_fa_return_fa', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      checkSubFsmState(MpStateType.NORMAL_FAKE_AOD_STATE, BouncerStateType.MAIN_PAGE_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bsc_to_btu_return_btu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.PWD_CHECK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_bsc_to_unlock_return_unlock', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.UNLOCK_STATE);

      checkSubFsmState(MpStateType.UNLOCK_STATE, BouncerStateType.UNLOCK_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sompl_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.MAIN_PAGE_LOCK_STATE);

      checkSubFsmState(MpStateType.NORMAL_LOCK_STATE, BouncerStateType.MAIN_PAGE_STATE, SoStateType.SCREEN_ON_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sompl_to_sompu_return_sompu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sompl_to_sopc_return_sopc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sompl_to_sosc_return_sosc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sompl_to_sou_return_sou', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_UNLOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sompu_to_mpu_return_mpu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sompu_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sompu_to_sosc_return_sosc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sopc_to_btu_return_btu', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.PWD_CHECK_STATE,
        SoStateType.SCREEN_ON_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sopc_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sopc_to_sosc_return_sosc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sosc_to_bsc_return_bsc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.BOUNCER_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.BOUNCER_STATE, BouncerStateType.SIM_CHECK_STATE, SoStateType.SCREEN_ON_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sosc_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sou_to_unlock_return_unlock', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.UNLOCK_STATE);

      checkSubFsmState(MpStateType.UNLOCK_STATE, BouncerStateType.UNLOCK_STATE, SoStateType.SCREEN_ON_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sou_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })

    it('test_matchCoreFsmChange_when_sou_to_sosc_return_sosc', TestConst.TEST_LEVEL, (): void => {
      let oldState = initState(CoreStateType.SCREEN_OFF_UNLOCK_STATE);

      screenLockFsmProxy.matchCoreFsmChange(oldState, CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);

      checkSubFsmState(MpStateType.SCREEN_OFF_STATE, BouncerStateType.SCREEN_OFF_STATE,
        SoStateType.NORMAL_SCREEN_OFF_STATE);
      expect(oldState).not().assertNull();
    })
  })
}
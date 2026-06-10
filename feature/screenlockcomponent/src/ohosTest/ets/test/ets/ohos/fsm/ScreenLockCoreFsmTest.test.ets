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

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { sSCBOobeManager } from '@ohos/windowscene';
import {
  ScreenLockStateManager,
  SimCardStateManager, SlServerHelper,
  VerifyDataManager
} from '@ohos/screenlockcommon';
import { AuthType } from '@ohos/screenlockcommon/src/main/ets/utils/AccountHelper';
import { CoreEventType, CoreStateType, ScreenLockCoreFsm } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockCoreFsm';
import TestConst from '../constants/TestConst';
import { MockVerifyInfo } from '../model/MockVerifyInfo';

interface MockParams {
  isScreenLockDisabled?: boolean,
  isOobeEnable?: boolean,
  hasPwd?: boolean,
  isSimLock?: boolean,
}

export default function ScreenLockCoreFsmTest() {
  const persistentId: number = 1;

  describe('ScreenLockCoreFsmTest', (): void => {
    let mocker: MockKit = new MockKit();
    let screenLockCoreFsm: ScreenLockCoreFsm;

    const mockState = (param?: MockParams): void => {
      // 模拟锁屏是否去使能
      let mockIsScreenLockDisabled: Function = mocker.mockFunc(SlServerHelper.getInstance(),
        SlServerHelper.getInstance().isScreenLockDisabled);
      when(mockIsScreenLockDisabled)(ArgumentMatchers.any).afterReturn(param?.isScreenLockDisabled ?? false);

      // 模式是否处于OOBE阶段
      let mockIsEnable: Function = mocker.mockFunc(sSCBOobeManager, sSCBOobeManager.isEnable);
      when(mockIsEnable)(ArgumentMatchers.any).afterReturn(param?.isOobeEnable ?? false);

      // 模拟是否有密码
      let pwdVerifyInfo: MockVerifyInfo = new MockVerifyInfo(AuthType.PIN);
      pwdVerifyInfo.hasCredential = (param?.hasPwd ?? true);
      pwdVerifyInfo.isSwitchOpen = (param?.hasPwd ?? true);
      let mockGetVerifyInfo: Function = mocker.mockFunc(VerifyDataManager.getInstance(),
        VerifyDataManager.getInstance().getVerifyInfo);
      when(mockGetVerifyInfo)(AuthType.PIN).afterReturn(pwdVerifyInfo);

      // 模拟SIM是否锁定
      let mockIsSimLocked: Function = mocker.mockFunc(SimCardStateManager.getInstance(),
        SimCardStateManager.getInstance().isSimLocked);
      when(mockIsSimLocked)(ArgumentMatchers.any).afterReturn(param?.isSimLock ?? false);
    };

    const clearMock = (): void => {
      mocker.clear(SlServerHelper.getInstance());
      mocker.clear(sSCBOobeManager);
      mocker.clear(VerifyDataManager.getInstance());
      mocker.clear(SimCardStateManager.getInstance());
    };

    // 状态预设函数
    const initCoreFsm = (stateType: CoreStateType): void => {
      switch (stateType) {
        case CoreStateType.INIT_STATE:
          break;
        case CoreStateType.MAIN_PAGE_LOCK_STATE:
          screenLockCoreFsm.init();
          break;
        case CoreStateType.MAIN_PAGE_FAKE_AOD_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);
          break;
        case CoreStateType.MAIN_PAGE_UNLOCK_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_SILENCE);
          break;
        case CoreStateType.MAIN_PAGE_EDIT_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_SILENCE);
          screenLockCoreFsm.submitEvent(CoreEventType.ENTER_EDIT);
          break;
        case CoreStateType.BOUNCER_TO_UNLOCK_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_UNLOCK);
          break;
        case CoreStateType.BOUNCER_TO_EDIT_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.ENTER_EDIT);
          break;
        case CoreStateType.BOUNCER_SIM_CHECK_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);
          break;
        case CoreStateType.UNLOCK_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);
          break;
        case CoreStateType.SCREEN_OFF_MP_LOCK_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);
          break;
        case CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);
          screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_SILENCE);
          break;
        case CoreStateType.SCREEN_OFF_PWD_CHECK_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);
          screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_UNLOCK);
          break;
        case CoreStateType.SCREEN_OFF_SIM_CHECK_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);
          screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);
          break;
        case CoreStateType.SCREEN_OFF_UNLOCK_STATE:
          screenLockCoreFsm.init();
          screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);
          screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);
          break;
      }
      expect(screenLockCoreFsm.currentStateType).assertEqual(stateType);
    };

    // 状态校验函数
    const checkResult = (isPageShow: boolean, isLocked: boolean): void => {
      expect(ScreenLockStateManager.getInstance().isPageShow).assertEqual(isPageShow);
      expect(ScreenLockStateManager.getInstance().isLocked).assertEqual(isLocked);
    };

    beforeAll((): void => {
      ScreenLockStateManager.getInstance().init();
    })
    beforeEach((): void => {
      screenLockCoreFsm = new ScreenLockCoreFsm(persistentId);
    })
    afterEach((): void => {
      clearMock();
    })
    afterAll((): void => {
      ScreenLockStateManager.getInstance().release();
      mocker.clearAll()
    })

    it('test_init_when_oobe_nopwd_should_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState({isOobeEnable: true, hasPwd: false});

      screenLockCoreFsm.init();

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_init_when_not_oobe_nopwd_should_return_mpu', TestConst.TEST_LEVEL, (): void => {
      mockState({hasPwd: false});

      screenLockCoreFsm.init();

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_UNLOCK_STATE);
      checkResult(true, false);
    })

    it('test_init_when_has_pwd_should_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();

      screenLockCoreFsm.init();

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ru_to_mpl_return_btu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_UNLOCK);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_TO_UNLOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_sfb_to_mpl_return_btu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SLIDE_FROM_BOTTOM);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_TO_UNLOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_mpl_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_us_to_mpl_return_mpu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_SILENCE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_UNLOCK_STATE);
      checkResult(true, false);
    })

    it('test_submitEvent_when_send_et_to_mpl_return_bte', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ENTER_EDIT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_TO_EDIT_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_pso_to_mpl_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_DEACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ua_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_ACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_mpl_return_bsc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_pso_to_mpl_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_fso_to_mpl_return_soml', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_DEACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ua_to_mpl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_ACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_mpl_return_bsc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_son_to_mpfa_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SCREEN_ON);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_soff_to_mpfa_return_sompl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_simLock_send_soff_to_mpfa_return_soscs', TestConst.TEST_LEVEL, (): void => {
      mockState({isSimLock: true});
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_mpfa_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_sfb_to_mpfa_return_btu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SLIDE_FROM_BOTTOM);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_TO_UNLOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_nopwd_send_sfb_to_mpfa_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState({hasPwd: false});
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SLIDE_FROM_BOTTOM);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_ru_to_mpfa_return_btu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_UNLOCK);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_TO_UNLOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_nopwd_send_ru_to_mpfa_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState({hasPwd: false});
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_UNLOCK);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_ud_to_mpfa_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_btmp_to_mpfa_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.BACK_TO_MAIN_PAGE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_btmp_to_mpfa_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.BACK_TO_MAIN_PAGE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_simLock_send_btmp_to_mpfa_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      mockState({isSimLock: true});

      screenLockCoreFsm.submitEvent(CoreEventType.BACK_TO_MAIN_PAGE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_pso_to_mpfa_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_fso_to_mpfa_return_soml', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_mpfa_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_mpfa_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_DEACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ua_to_mpfa_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_ACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_mpfa_return_bsc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_sfb_to_mpu_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SLIDE_FROM_BOTTOM);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_qu_to_mpu_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_UNLOCK);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_simLock_send_ud_to_mpu_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState({isSimLock: true});
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_ee_to_mpu_return_mpe', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ENTER_EDIT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_EDIT_STATE);
      checkResult(true, false);
    })

    it('test_submitEvent_when_nopwd_send_ql_to_mpu_return_mpl', TestConst.TEST_LEVEL, (): void => {
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_LOCK);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_pso_to_mpu_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_fso_to_mpu_return_soml', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_mpu_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_mpu_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_DEACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ua_to_mpu_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_ACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_mpu_return_bsc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_sfb_to_mpe_return_mpu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SLIDE_FROM_BOTTOM);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_UNLOCK_STATE);
      checkResult(true, false);
    })

    it('test_submitEvent_when_send_btmp_to_mpe_return_mpu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.BACK_TO_MAIN_PAGE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_UNLOCK_STATE);
      checkResult(true, false);
    })

    it('test_submitEvent_when_send_ee_to_mpe_return_mpu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.EXIT_EDIT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_UNLOCK_STATE);
      checkResult(true, false);
    })

    it('test_submitEvent_when_send_ru_to_mpe_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_UNLOCK);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_rl_to_mpe_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_LOCK);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_pso_to_mpe_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_fso_to_mpe_return_soml', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_mpe_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_mpe_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_DEACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ua_to_mpe_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_ACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_mpe_return_bsc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.MAIN_PAGE_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_btmp_to_btu_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.BACK_TO_MAIN_PAGE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_btu_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_us_to_btu_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_SILENCE);

      expect(screenLockCoreFsm.currentStateType).not().assertNull();
    })

    it('test_submitEvent_when_send_pso_to_btu_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_fso_to_btu_return_soml', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_btu_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_btu_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_DEACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ua_to_btu_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_ACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_btu_return_bsc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_btmp_to_bte_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.BACK_TO_MAIN_PAGE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_bte_return_edit', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_EDIT_STATE);
      checkResult(true, false);
    })

    it('test_submitEvent_when_send_us_to_bte_return_edit', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_SILENCE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_EDIT_STATE);
      checkResult(true, false);
    })

    it('test_submitEvent_when_send_pso_to_bte_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_fso_to_bte_return_soml', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_bte_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_bte_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_DEACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ua_to_bte_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_ACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_bte_return_bsc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_TO_EDIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_btmp_to_bsc_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.BACK_TO_MAIN_PAGE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_bsc_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_pso_to_bsc_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_fso_to_bsc_return_sosc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_bsc_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_css_to_bte_return_btu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.BOUNCER_SIM_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.CHECK_SIM_SUCCESS);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_TO_UNLOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ql_to_unlock_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_LOCK);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ua_to_unlock_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_ACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_pso_to_unlock_return_mpfa', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.PRE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_FAKE_AOD_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_fso_to_unlock_return_soml', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.FORCE_SCREEN_OFF);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_unlock_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_unlock_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.USER_DEACTIVATE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_unlock_return_bsc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_btmp_to_init_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.INIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.BACK_TO_MAIN_PAGE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_init_return_sosc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.INIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_init_return_unlock', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.INIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_us_to_init_return_mpu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.INIT_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_SILENCE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_UNLOCK_STATE);
      checkResult(true, false);
    })

    it('test_submitEvent_when_send_so_to_sompl_return_mpl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SCREEN_ON);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_vf_to_sompl_return_sopc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.VERIFY_FAIL);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_sfb_to_sompl_return_sopc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SLIDE_FROM_BOTTOM);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ru_to_sompl_return_sopc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REQUEST_UNLOCK);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_ud_to_sompl_return_sou', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_DIRECT);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_UNLOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_us_to_sompl_return_sompu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.UNLOCK_SILENCE);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_sompl_return_sosc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_sompl_return_sompl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_so_to_sompu_return_mpu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SCREEN_ON);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.MAIN_PAGE_UNLOCK_STATE);
      checkResult(true, false);
    })

    it('test_submitEvent_when_send_asc_to_sompu_return_sosc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_sompu_return_sompl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_MP_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_so_to_sopc_return_btu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SCREEN_ON);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_TO_UNLOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_asc_to_sopc_return_sosc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_sopc_return_sompl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_PWD_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_so_to_sosc_return_sompl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_so_to_sosc_return_bsc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SCREEN_ON);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.BOUNCER_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_so_to_sou_return_mpu', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.SCREEN_ON);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.UNLOCK_STATE);
      checkResult(false, false);
    })

    it('test_submitEvent_when_send_asc_to_sou_return_sosc', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.ADD_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_SIM_CHECK_STATE);
      checkResult(true, true);
    })

    it('test_submitEvent_when_send_rsc_to_sou_return_sompl', TestConst.TEST_LEVEL, (): void => {
      mockState();
      initCoreFsm(CoreStateType.SCREEN_OFF_UNLOCK_STATE);

      screenLockCoreFsm.submitEvent(CoreEventType.REMOVE_SIM_CARD);

      expect(screenLockCoreFsm.currentStateType).assertEqual(CoreStateType.SCREEN_OFF_MP_LOCK_STATE);
      checkResult(true, true);
    })
  })
}
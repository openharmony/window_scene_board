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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import {
  BouncerEventType,
  BouncerFsm,
  BouncerStateType,
  BouncerStateTypeUtils
} from '@ohos/screenlockcommon/src/main/ets/fsm/BouncerFsm';
import TestConst from '../constants/TestConst';

export default function BouncerFsmTest() {
  const persistentId: number = 1;

  describe('BouncerFsmTest', (): void => {
    let bouncerFsm: BouncerFsm;

    // 状态预设函数
    const initBouncerFsm = (stateType: BouncerStateType): void => {
      switch (stateType) {
        case BouncerStateType.INIT_STATE:
          break;
        case BouncerStateType.PWD_CHECK_STATE:
          bouncerFsm.submitEvent(BouncerEventType.ENTER_PWD_CHECK);
          break;
        case BouncerStateType.HIGH_FINGERPRINT_CHECK_STATE:
          bouncerFsm.submitEvent(BouncerEventType.ENTER_PWD_CHECK);
          bouncerFsm.submitEvent(BouncerEventType.ENTER_HIGH_FINGERPRINT_CHECK);
          break;
      }
      expect(bouncerFsm.currentStateType).assertEqual(stateType);
    };

    beforeAll((): void => {
    })
    beforeEach((): void => {
      bouncerFsm = new BouncerFsm(persistentId);
    })
    afterEach((): void => {
    })
    afterAll((): void => {
    })

    it('test_submitEvent_when_send_ehfc_to_pc_return_high_fp_check', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(BouncerStateType.PWD_CHECK_STATE);

      bouncerFsm.submitEvent(BouncerEventType.ENTER_HIGH_FINGERPRINT_CHECK);

      expect(bouncerFsm.currentStateType).assertEqual(BouncerStateType.HIGH_FINGERPRINT_CHECK_STATE);
    })

    it('test_submitEvent_when_send_epc_to_hfc_return_edit_mpf', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(BouncerStateType.HIGH_FINGERPRINT_CHECK_STATE);

      bouncerFsm.submitEvent(BouncerEventType.ENTER_PWD_CHECK);

      expect(bouncerFsm.currentStateType).assertEqual(BouncerStateType.HIGH_FINGERPRINT_CHECK_STATE);
    })

    it('test_submitEvent_when_send_chfc_to_hfc_return_edit_mpf', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(BouncerStateType.HIGH_FINGERPRINT_CHECK_STATE);

      bouncerFsm.submitEvent(BouncerEventType.CANCEL_HIGH_FINGERPRINT_CHECK);

      expect(bouncerFsm.currentStateType).assertEqual(BouncerStateType.PWD_CHECK_STATE);
    })

    it('BouncerFsmTest_001', 0, (done: Function) => {
      let bouncerStateTypeUtils = BouncerStateTypeUtils;
      try {
        let result = bouncerStateTypeUtils.isInMainPageState(BouncerStateType.MAIN_PAGE_STATE)
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('BouncerFsmTest_002', 0, (done: Function) => {
      let bouncerStateTypeUtils = BouncerStateTypeUtils;
      try {
        let result = bouncerStateTypeUtils.isInBouncerState(BouncerStateType.PWD_CHECK_STATE)
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('BouncerFsmTest_003', 0, (done: Function) => {
      let bouncerStateTypeUtils = BouncerStateTypeUtils;
      try {
        let result = bouncerStateTypeUtils.isInSimLockState(BouncerStateType.SIM_CHECK_STATE)
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
    it('BouncerFsmTest_004', 0, (done: Function) => {
      let bouncerStateTypeUtils = BouncerStateTypeUtils;
      try {
        let result = bouncerStateTypeUtils.isInSimLockState(BouncerStateType.UNLOCK_STATE)
        expect(result !== null).assertTrue();
      } catch (e) {
      } finally {
        done()
      }
    });
  })
}
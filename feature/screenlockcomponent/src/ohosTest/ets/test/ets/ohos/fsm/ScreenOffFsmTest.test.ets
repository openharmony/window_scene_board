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
import { ScreenOffFsm, SoEventType, SoStateType } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenOffFsm';
import TestConst from '../constants/TestConst';

export default function ScreenOffFsmTest() {
  const persistentId: number = 1;

  describe('ScreenOffFsmTest', (): void => {
    let screenOffFsm: ScreenOffFsm;

    // 状态预设函数
    const initBouncerFsm = (stateType: SoStateType): void => {
      switch (stateType) {
        case SoStateType.INIT_STATE:
          break;
        case SoStateType.NORMAL_SCREEN_OFF_STATE:
          screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_OFF_STATE);
          break;
        case SoStateType.PRE_BRIGHT_STATE:
          screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_OFF_STATE);
          screenOffFsm.submitEvent(SoEventType.PRE_BRIGHT);
          break;
        case SoStateType.PRE_BRIGHT_FACE_AUTH_STATE:
          screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_OFF_STATE);
          screenOffFsm.submitEvent(SoEventType.PRE_BRIGHT);
          screenOffFsm.submitEvent(SoEventType.TRIGGER_FACE_RECOGNITION);
          break;
        case SoStateType.SCREEN_ON_STATE:
          screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_ON_STATE);
          break;
      }
      expect(screenOffFsm.currentStateType).assertEqual(stateType);
    };

    beforeAll((): void => {
    })
    beforeEach((): void => {
      screenOffFsm = new ScreenOffFsm(persistentId);
    })
    afterEach((): void => {
    })
    afterAll((): void => {
    })

    it('test_submitEvent_when_send_eson_to_init_return_screen_on', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.INIT_STATE);

      screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_ON_STATE);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.SCREEN_ON_STATE);
    })

    it('test_submitEvent_when_send_esoff_to_init_return_screen_off', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.INIT_STATE);

      screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_OFF_STATE);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.NORMAL_SCREEN_OFF_STATE);
    })

    it('test_submitEvent_when_send_eson_to_soff_return_screen_on', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.NORMAL_SCREEN_OFF_STATE);

      screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_ON_STATE);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.SCREEN_ON_STATE);
    })

    it('test_submitEvent_when_send_pb_to_soff_return_screen_off', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.NORMAL_SCREEN_OFF_STATE);

      screenOffFsm.submitEvent(SoEventType.PRE_BRIGHT);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.PRE_BRIGHT_STATE);
    })

    it('test_submitEvent_when_send_eson_to_pb_return_screen_on', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.PRE_BRIGHT_STATE);

      screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_ON_STATE);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.SCREEN_ON_STATE);
    })

    it('test_submitEvent_when_send_tfr_to_pb_return_screen_off', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.PRE_BRIGHT_STATE);

      screenOffFsm.submitEvent(SoEventType.TRIGGER_FACE_RECOGNITION);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.PRE_BRIGHT_FACE_AUTH_STATE);
    })

    it('test_submitEvent_when_send_eson_to_pbfa_return_screen_on', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.PRE_BRIGHT_FACE_AUTH_STATE);

      screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_ON_STATE);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.SCREEN_ON_STATE);
    })

    it('test_submitEvent_when_send_fvf_to_pbfa_return_screen_off', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.PRE_BRIGHT_FACE_AUTH_STATE);

      screenOffFsm.submitEvent(SoEventType.FACE_VERIFY_FAIL);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.PRE_BRIGHT_STATE);
    })

    it('test_submitEvent_when_send_eson_to_son_return_screen_on', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.SCREEN_ON_STATE);

      screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_ON_STATE);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.SCREEN_ON_STATE);
    })

    it('test_submitEvent_when_send_esoff_to_son_return_screen_off', TestConst.TEST_LEVEL, (): void => {
      initBouncerFsm(SoStateType.SCREEN_ON_STATE);

      screenOffFsm.submitEvent(SoEventType.ENTER_SCREEN_OFF_STATE);

      expect(screenOffFsm.currentStateType).assertEqual(SoStateType.NORMAL_SCREEN_OFF_STATE);
    })
  })
}
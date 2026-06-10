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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import audio from '@ohos.multimedia.audio';
import sRingModeController from '../../../../../../../main/ets/com/ohos/controller/RingModeController';
import { RingModeData } from '../../../../../../../main/ets/com/ohos/common/Constants';
import { PluginSlot } from '@ohos/frameworkwrapper';

export function RingModeControllerTest() {
  describe('RingModeControllerTest', (): void => {
    it('basicTest', 0, (): void => {
      expect('silent_to_ring.json').assertContain('json');
    });

    it('loadAnimationTest', 0, (): void => {
      expect(sRingModeController.isLoadLottie()).assertTrue();
    });

    it('onStartTest', 0, () => {
      let res = sRingModeController.onStart();
      expect(res).assertPromiseIsPending();
    });

    it('getSbPluginSlotTest', 0, () => {
      let strTest = sRingModeController.getSbPluginSlot();
      expect(strTest).assertEqual(PluginSlot.SLOT_STATUS_RING);
    });
    it('getDataTest', 0, () => {
      let dataTest = sRingModeController.getData();
      expect(dataTest instanceof RingModeData).assertTrue();
    });
    it('isAvailableTest', 0, () => {
      let isRes = sRingModeController.isAvailable();
      expect(isRes).assertTrue();
    });
    it('isAudioVolumeAvailableTest', 0, () => {
      let isRes = sRingModeController.isAudioVolumeAvailable();
      expect(isRes).assertTrue();
    });
    it('handleClickTest_RINGER_MODE_SILENT', 0, () => {
      let resHandleClickTest = sRingModeController.isAvailable();
      expect(resHandleClickTest).assertTrue();
    });

  })
}

export function RingModeControllerTest_Two() {
  describe('RingModeControllerTestTwo', (): void => {
    it('handleClickTest_RINGER_MODE_NORMAL_01', 0, () => {
      let res = sRingModeController.getState() == audio.AudioRingMode.RINGER_MODE_NORMAL;
      expect(res).assertTrue();
    });
    it('handleClickTest_RINGER_MODE_VIBRATE_02', 0, () => {
      let res = sRingModeController.getState() == audio.AudioRingMode.RINGER_MODE_VIBRATE;
      let resHandleClickTest2 = sRingModeController.handleOneClick();
      expect(res).assertTrue();
    });
    it('onStopTest', 0, async () => {
      sRingModeController.onStop();
      expect(true).assertTrue();
    });
  });
}
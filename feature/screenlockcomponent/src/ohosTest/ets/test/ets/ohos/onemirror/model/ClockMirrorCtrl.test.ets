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
import { ClockMirrorCtrl } from '../../../../../../../main/ets/onemirror/model/ClockMirrorCtrl';
import { MirrorAnimState, MirrorsScene } from '../../../../../../../main/ets/onemirror/constants/MirrorToEndConst';

/**
 * 沉浸式锁屏测试用例
 */
export default function ClockMirrorCtrlTest() {
  describe('ClockMirrorCtrlTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    let clockMirrorCtrl: ClockMirrorCtrl = new ClockMirrorCtrl();

    it('test_setUiBindState', Level.LEVEL0, (): void => {
      clockMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      clockMirrorCtrl.setUiBindState(MirrorsScene.SCREEN_OFF_TO_SL);
      clockMirrorCtrl.setUiBindState(MirrorsScene.SL_TO_AOD);
      clockMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_DESKTOP);
      clockMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_SL);
      clockMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_DEFAULT);
      clockMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD);
    });

    it('test_setPartUiBindState', Level.LEVEL0, (): void => {
      clockMirrorCtrl.setPartUiBindState(MirrorsScene.DESKTOP_TO_AOD);
      clockMirrorCtrl.setPartUiBindState(MirrorsScene.SL_TO_AOD);
      clockMirrorCtrl.setPartUiBindState(MirrorsScene.SCREEN_OFF_TO_SL);
      clockMirrorCtrl.setPartUiBindState(MirrorsScene.AOD_TO_SL);
      clockMirrorCtrl.setPartUiBindState(MirrorsScene.AOD_TO_DESKTOP);
    });

    it('test_setAnimState', Level.LEVEL0, (): void => {
      clockMirrorCtrl.setAnimState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      clockMirrorCtrl.setAnimState(MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START);
      clockMirrorCtrl.setAnimState(MirrorsScene.SCREEN_OFF_TO_SL);
      clockMirrorCtrl.setAnimState(MirrorsScene.DESKTOP_TO_AOD);
      clockMirrorCtrl.setAnimState(MirrorsScene.SL_TO_AOD);
      clockMirrorCtrl.setAnimState(MirrorsScene.SL_TO_SLEEP);
    });

    it('test_isScreenOffToSLWithoutClockOneShot', Level.LEVEL0, (): void => {
      (clockMirrorCtrl as object)['isScreenOffToSLWithoutClockOneShot'](MirrorsScene.SCREEN_OFF_TO_SL);
      (clockMirrorCtrl as object)['isScreenOffToSLWithoutClockOneShot'](MirrorsScene.DESKTOP_TO_AOD);
      (clockMirrorCtrl as object)['isScreenOffToSLWithoutClockOneShot'](MirrorsScene.AOD_TO_DESKTOP);
    });
  });
}
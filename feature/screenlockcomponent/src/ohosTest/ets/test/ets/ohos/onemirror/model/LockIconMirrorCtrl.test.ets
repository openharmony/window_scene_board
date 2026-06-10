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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { LockIconMirrorCtrl } from '../../../../../../../main/ets/onemirror/model/LockIconMirrorCtrl';
import { MirrorAnimState, MirrorsScene } from '../../../../../../../main/ets/onemirror/constants/MirrorToEndConst';

/**
 * 沉浸式锁屏测试用例
 */
export default function LockIconMirrorCtrlTest() {
  describe('LockIconMirrorCtrlTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    let lockIconMirrorCtrl: LockIconMirrorCtrl = new LockIconMirrorCtrl();

    it('test_setUiBindState', Level.LEVEL0, (): void => {
      lockIconMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      lockIconMirrorCtrl.setUiBindState(MirrorsScene.SCREEN_OFF_TO_SL);
      lockIconMirrorCtrl.setUiBindState(MirrorsScene.SL_TO_AOD);
      lockIconMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_DESKTOP);
      lockIconMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_SL);
      lockIconMirrorCtrl.setUiBindState(MirrorsScene.SCREEN_OFF_TO_SL_END);
      lockIconMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD);
    });

    it('test_setAnimState', Level.LEVEL0, (): void => {
      lockIconMirrorCtrl.setAnimState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      lockIconMirrorCtrl.setAnimState(MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START);
      lockIconMirrorCtrl.setAnimState(MirrorsScene.SCREEN_OFF_TO_SL);
      lockIconMirrorCtrl.setAnimState(MirrorsScene.DESKTOP_TO_AOD);
      lockIconMirrorCtrl.setAnimState(MirrorsScene.SL_TO_AOD);
      lockIconMirrorCtrl.setAnimState(MirrorsScene.SL_TO_SLEEP);
    });

    it('test_setAnimEmoji', Level.LEVEL0, (): void => {
      lockIconMirrorCtrl.setAnimEmoji(MirrorsScene.DESKTOP_TO_AOD);
      lockIconMirrorCtrl.setAnimEmoji(MirrorsScene.SL_TO_AOD);
      lockIconMirrorCtrl.setAnimEmoji(MirrorsScene.SCREEN_OFF_TO_SL);
      lockIconMirrorCtrl.setAnimEmoji(MirrorsScene.SCREEN_OFF_TO_SL_END);
    });

    it('test_setPartUiBindState', Level.LEVEL0, (): void => {
      lockIconMirrorCtrl.setPartUiBindState(MirrorsScene.DESKTOP_TO_AOD);
      lockIconMirrorCtrl.setPartUiBindState(MirrorsScene.SL_TO_AOD);
      lockIconMirrorCtrl.setPartUiBindState(MirrorsScene.SCREEN_OFF_TO_SL);
      lockIconMirrorCtrl.setPartUiBindState(MirrorsScene.SL_TO_SLEEP);
    });
  });
}
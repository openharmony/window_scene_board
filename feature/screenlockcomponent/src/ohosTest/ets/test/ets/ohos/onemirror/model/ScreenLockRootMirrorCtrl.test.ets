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
import { ScreenLockRootMirrorCtrl } from '../../../../../../../main/ets/onemirror/model/ScreenLockRootMirrorCtrl';
import { MirrorAnimState, MirrorsScene } from '../../../../../../../main/ets/onemirror/constants/MirrorToEndConst';

/**
 * 沉浸式锁屏测试用例
 */
export default function ScreenLockRootMirrorCtrlTest() {
  describe('ScreenLockRootMirrorCtrlTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    let slRootMirrorCtrl: ScreenLockRootMirrorCtrl = new ScreenLockRootMirrorCtrl();

    it('ScreenLockRoot_test_setUiBindState', Level.LEVEL0, (): void => {
      slRootMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      slRootMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD);
      slRootMirrorCtrl.setUiBindState(MirrorsScene.SCREEN_OFF_TO_SL);
      slRootMirrorCtrl.setUiBindState(MirrorsScene.SL_TO_AOD);
      slRootMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_DESKTOP);
      slRootMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_SL);
      slRootMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_DEFAULT);
    });

    it('ScreenLockRoot_test_setPartUiBindState', Level.LEVEL0, (): void => {
      slRootMirrorCtrl.setPartUiBindState(MirrorsScene.DESKTOP_TO_AOD);
      slRootMirrorCtrl.setPartUiBindState(MirrorsScene.SCREEN_OFF_TO_SL);
      slRootMirrorCtrl.setPartUiBindState(MirrorsScene.SL_TO_AOD);
      slRootMirrorCtrl.setPartUiBindState(MirrorsScene.AOD_TO_DESKTOP);
      slRootMirrorCtrl.setPartUiBindState(MirrorsScene.AOD_TO_SL);
      slRootMirrorCtrl.setPartUiBindState(MirrorsScene.AOD_TO_DEFAULT);
    });

    it('ScreenLockRoot_test_setAnimState', Level.LEVEL0, (): void => {
      slRootMirrorCtrl.setAnimState(MirrorsScene.DESKTOP_TO_AOD);
      slRootMirrorCtrl.setAnimState(MirrorsScene.SCREEN_OFF_TO_SL);
      slRootMirrorCtrl.setAnimState(MirrorsScene.SL_TO_AOD);
      slRootMirrorCtrl.setAnimState(MirrorsScene.AOD_TO_DESKTOP);
      slRootMirrorCtrl.setAnimState(MirrorsScene.AOD_TO_SL);
      slRootMirrorCtrl.setAnimState(MirrorsScene.AOD_TO_DEFAULT);
    });

    it('ScreenLockRoot_test_setAnimEmoji', Level.LEVEL0, (): void => {
      slRootMirrorCtrl.setAnimEmoji(MirrorsScene.DESKTOP_TO_AOD);
      slRootMirrorCtrl.setAnimEmoji(MirrorsScene.AOD_TO_DESKTOP);
    });

    it('ScreenLockRoot_test_startAnim', Level.LEVEL0, (): void => {
      slRootMirrorCtrl.startAnim(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START, true);
      slRootMirrorCtrl.startAnim(MirrorsScene.DESKTOP_TO_AOD, MirrorAnimState.START, false);
    });

    it('ScreenLockRoot_test_clearAnimating', Level.LEVEL0, (): void => {
      slRootMirrorCtrl.clearAnimating();
    });

    it('ScreenLockRoot_test_isSceneAnimating', Level.LEVEL0, (): void => {
      slRootMirrorCtrl.isSceneAnimating(MirrorsScene.DESKTOP_TO_AOD);
      slRootMirrorCtrl.isSceneAnimating(MirrorsScene.AOD_TO_DESKTOP);
      slRootMirrorCtrl.isSceneAnimating('');
    });

  });
}
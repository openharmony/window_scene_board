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
import { ImmersiveMirrorCtrl } from '../../../../../../../main/ets/onemirror/model/ImmersiveMirrorCtrl';
import { MirrorAnimState, MirrorsScene } from '../../../../../../../main/ets/onemirror/constants/MirrorToEndConst';
import { ImmersiveListMirrorCtrl } from '../../../../../../../main/ets/onemirror/model/ImmersiveListMirrorCtrl';

/**
 * 沉浸式锁屏测试用例
 */
export default function ImmersiveMirrorCtrlTest() {
  describe('ImmersiveMirrorCtrlTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    let immersiveMirrorCtrl: ImmersiveMirrorCtrl = new ImmersiveListMirrorCtrl();

    it('test_setUiBindState', Level.LEVEL0, (): void => {
      immersiveMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      immersiveMirrorCtrl.setUiBindState(MirrorsScene.SCREEN_OFF_TO_SL);
      immersiveMirrorCtrl.setUiBindState(MirrorsScene.SL_TO_AOD);
      immersiveMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_DESKTOP);
      immersiveMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_SL);
      immersiveMirrorCtrl.setUiBindState(MirrorsScene.SCREEN_OFF_TO_SL_END);
      immersiveMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD);
    });

    it('test_setAnimState', Level.LEVEL0, (): void => {
      immersiveMirrorCtrl.setAnimState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      immersiveMirrorCtrl.setAnimState(MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START);
      immersiveMirrorCtrl.setAnimState(MirrorsScene.SCREEN_OFF_TO_SL);
      immersiveMirrorCtrl.setAnimState(MirrorsScene.DESKTOP_TO_AOD);
      immersiveMirrorCtrl.setAnimState(MirrorsScene.SL_TO_AOD);
      immersiveMirrorCtrl.setAnimState(MirrorsScene.SL_TO_SLEEP);
    });

    it('test_setAnimEmoji', Level.LEVEL0, (): void => {
      immersiveMirrorCtrl.setAnimEmoji(MirrorsScene.DESKTOP_TO_AOD);
      immersiveMirrorCtrl.setAnimEmoji(MirrorsScene.AOD_TO_DESKTOP);
      immersiveMirrorCtrl.setAnimEmoji(MirrorsScene.SL_TO_AOD);
      immersiveMirrorCtrl.setAnimEmoji(MirrorsScene.AOD_TO_SL);
      immersiveMirrorCtrl.setAnimEmoji(MirrorsScene.SCREEN_OFF_TO_SL);
      immersiveMirrorCtrl.setAnimEmoji(MirrorsScene.SCREEN_OFF_TO_SL_END);
    });

    it('test_setPartUiBindState', Level.LEVEL0, (): void => {
      immersiveMirrorCtrl.setPartUiBindState(MirrorsScene.DESKTOP_TO_AOD);
      immersiveMirrorCtrl.setPartUiBindState(MirrorsScene.AOD_TO_DESKTOP);
      immersiveMirrorCtrl.setPartUiBindState(MirrorsScene.SL_TO_AOD);
      immersiveMirrorCtrl.setPartUiBindState(MirrorsScene.AOD_TO_SL);
      immersiveMirrorCtrl.setPartUiBindState(MirrorsScene.SCREEN_OFF_TO_SL);
      immersiveMirrorCtrl.setPartUiBindState(MirrorsScene.SCREEN_OFF_TO_SL_END);
      immersiveMirrorCtrl.setPartUiBindState(MirrorsScene.SL_TO_SLEEP);
    });
  });
}
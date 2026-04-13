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
import { DofWallpaperMirrorCtrl } from '../../../../../../../main/ets/onemirror/model/DofWallpaperMirrorCtrl';
import { MirrorAnimState, MirrorsScene } from '../../../../../../../main/ets/onemirror/constants/MirrorToEndConst';

/**
 * 沉浸式锁屏测试用例
 */
export default function DofWallpaperMirrorCtrlTest() {
  describe('DofWallpaperMirrorCtrlTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    let dofWallpaperMirrorCtrl: DofWallpaperMirrorCtrl = new DofWallpaperMirrorCtrl();

    it('test_setUiBindState', Level.LEVEL0, (): void => {
      dofWallpaperMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      dofWallpaperMirrorCtrl.setUiBindState(MirrorsScene.SCREEN_OFF_TO_SL);
      dofWallpaperMirrorCtrl.setUiBindState(MirrorsScene.SL_TO_AOD);
      dofWallpaperMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_DESKTOP);
      dofWallpaperMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_SL);
      dofWallpaperMirrorCtrl.setUiBindState(MirrorsScene.AOD_TO_DEFAULT);
      dofWallpaperMirrorCtrl.setUiBindState(MirrorsScene.DESKTOP_TO_AOD);
    });

    it('test_setAnimState', Level.LEVEL0, (): void => {
      dofWallpaperMirrorCtrl.setAnimState(MirrorsScene.DESKTOP_TO_AOD + MirrorAnimState.START);
      dofWallpaperMirrorCtrl.setAnimState(MirrorsScene.AOD_TO_DESKTOP + MirrorAnimState.START);
      dofWallpaperMirrorCtrl.setAnimState(MirrorsScene.SCREEN_OFF_TO_SL);
      dofWallpaperMirrorCtrl.setAnimState(MirrorsScene.DESKTOP_TO_AOD);
      dofWallpaperMirrorCtrl.setAnimState(MirrorsScene.SL_TO_AOD);
      dofWallpaperMirrorCtrl.setAnimState(MirrorsScene.SL_TO_SLEEP);
    });

    it('test_isSceneAnimating', Level.LEVEL0, (): void => {
      (dofWallpaperMirrorCtrl as object)['isSceneAnimating'](MirrorsScene.SCREEN_OFF_TO_SL);
      (dofWallpaperMirrorCtrl as object)['isSceneAnimating'](MirrorsScene.DESKTOP_TO_AOD);
      (dofWallpaperMirrorCtrl as object)['isSceneAnimating'](MirrorsScene.AOD_TO_DESKTOP);
    });
  });
}
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
import ScreenLockFingerPrintAni from '../../../../../../../main/ets/onemirror/model/ScreenLockFingerPrintAni';
import MirrorAniConfig from '../../../../../../../main/ets/onemirror/model/MirrorAnimationConf';

export default function ScreenLockFingerPrintAniTest() {
  let aniConf: MirrorAniConfig = new MirrorAniConfig();
  describe('ScreenLockFingerPrintAniTest', (): void => {
    let mScreenLockFingerPrintAni: ScreenLockFingerPrintAni = new ScreenLockFingerPrintAni(aniConf);

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_playNtfAudio_return', 0, (): void => {
      let blur:number = 300;
      mScreenLockFingerPrintAni.doWhenBeginSleep();
      mScreenLockFingerPrintAni.aniConf.setBlur(blur);
      expect(aniConf.blur).assertEqual(300);
    })

    it('test_doWhenEndScreenOn_return', 0, (): void => {
      let blur:number = 0;
      mScreenLockFingerPrintAni.doWhenEndScreenOn();
      mScreenLockFingerPrintAni.aniConf.setBlur(blur);
      expect(aniConf.blur).assertEqual(0);
    })

    it('test_doWhenOffScreen_return', 0, (): void => {
      let blur:number = 0;
      mScreenLockFingerPrintAni.doWhenOffScreen();
      mScreenLockFingerPrintAni.aniConf.setBlur(blur);
      expect(aniConf.blur).assertEqual(0);
    })

    it('test_doWhenOnScreen_return', 0, (): void => {
      let blur:number = 300;
      mScreenLockFingerPrintAni.doWhenOnScreen();
      mScreenLockFingerPrintAni.aniConf.setBlur(blur);
      expect(aniConf.blur).assertEqual(300);
    })

    it('test_doWhenDesktopToAOD_return', 0, (): void => {
      let blur:number = 300;
      mScreenLockFingerPrintAni.doWhenDesktopToAOD();
      mScreenLockFingerPrintAni.aniConf.setBlur(blur);
      expect(aniConf.blur).assertEqual(300);
    })

    it('test_doWhenScreenLockToAOD_return', 0, (): void => {
      let blur:number = 0;
      mScreenLockFingerPrintAni.doWhenScreenLockToAOD();
      mScreenLockFingerPrintAni.aniConf.setBlur(blur);
      expect(aniConf.blur).assertEqual(0);
    })

    it('test_doWhenAODToDesktop_return', 0, (): void => {
      let blur:number = 300;
      mScreenLockFingerPrintAni.doWhenAODToDesktop();
      mScreenLockFingerPrintAni.doWhenAODToScreenLock();
      mScreenLockFingerPrintAni.doWhenAODSCL2AOD();
      mScreenLockFingerPrintAni.doWhenOffScreen2ScreenLockBegin();
      mScreenLockFingerPrintAni.aniConf.setBlur(blur);
      expect(aniConf.blur).assertEqual(300);
    })

    it('test_doWhenOffScreen2ScreenLockEnd_return', 0, (): void => {
      let blur:number = 0;
      mScreenLockFingerPrintAni.doWhenOffScreen2ScreenLockEnd();
      mScreenLockFingerPrintAni.aniConf.setBlur(blur);
      expect(aniConf.blur).assertEqual(0);
    })
  })
}
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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import AodScreenLockAni
  from '../../../../../../../main/ets/onemirror/model/AodScreenLockAni';
import MirrorAniConfig, {
  MirrorElemType
} from '../../../../../../../main/ets/onemirror/model/MirrorAnimationConf';

export default function AodScreenLockAniTest() {
  let aniConf: MirrorAniConfig = new MirrorAniConfig();
  let elemType: number;
  describe('AodScreenLockAniTest', (): void => {

    let mAodScreenLockAni: AodScreenLockAni = new AodScreenLockAni(aniConf, elemType);
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_doWhenBeginSleep_return', 0, (): void => {
      mAodScreenLockAni.doWhenBeginSleep();
      expect(aniConf.alpha).assertEqual(1);
    })

    it('test_doWhenEndScreenOn_return', 0, (): void => {
      mAodScreenLockAni.doWhenEndScreenOn();
      mAodScreenLockAni.doWhenOffScreen();
      expect(aniConf.alpha).assertEqual(1);
    })

    it('test_doWhenOnScreen_return', 0, (): void => {
      mAodScreenLockAni.doWhenOnScreen();
      expect(aniConf.alpha).assertEqual(1);
    })

    it('test_doWhenDesktopToAOD_return', 0, (): void => {
      mAodScreenLockAni.doWhenDesktopToAOD();
      expect(aniConf.alpha).assertEqual(0);
    })

    it('test_doWhenScreenLockToAOD_return', 0, (): void => {
      mAodScreenLockAni.doWhenScreenLockToAOD();
      expect(aniConf.alpha).assertEqual(1);
    })

    it('test_doWhenAODToDesktop_return', 0, (): void => {
      mAodScreenLockAni.doWhenAODToDesktop();
      mAodScreenLockAni.doWhenAODToScreenLock();
      mAodScreenLockAni.doWhenAODSCL2AOD();
      expect(aniConf.alpha).assertEqual(0);
    })

    it('test_doWhenOffScreen2ScreenLockBegin_return', 0, (): void => {
      mAodScreenLockAni.doWhenOffScreen2ScreenLockBegin();
      expect(aniConf.scaleX).assertEqual(0.7);
    })

    it('test_doWhenOffScreen2ScreenLockEnd_return', 0, (): void => {
      mAodScreenLockAni.doWhenOffScreen2ScreenLockEnd();
      expect(aniConf.alpha).assertEqual(1);
    })

  })
}
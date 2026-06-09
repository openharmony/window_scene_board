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
import TestConst from '../constants/TestConst';
import MirrorAniConfig, { MirrorElemType } from '../../../../../../main/ets/onemirror/model/MirrorAnimationConf';
import IMirrorToEnd from '../../../../../../main/ets/onemirror/model/IMirrorToEnd';
import ScreenLockAni from '../../../../../../main/ets/onemirror/model/ScreenLockAni';
import ScreenLockElementAni from '../../../../../../main/ets/onemirror/model/ScreenLockElementAni';

export default function MirrorAniConfigTest() {
  const screenLockConf: MirrorAniConfig = new MirrorAniConfig();
  const lockIconConf: MirrorAniConfig = new MirrorAniConfig();

  describe('MirrorAniConfigTest', (): void => {
    const screenLockAni: IMirrorToEnd = new ScreenLockAni(screenLockConf);
    const screenLockElementAni: IMirrorToEnd = new ScreenLockElementAni(lockIconConf, MirrorElemType.Mirror_LOCK_ICON);

    beforeAll((): void => {

    })
    beforeEach((): void => {
    })
    afterEach((): void => {

    })
    afterAll((): void => {
    })

    it('test_getScaleX_should_return_1', TestConst.TEST_LEVEL, (): void => {
      expect(screenLockConf.getScaleX()).assertEqual(1);
    })

    it('test_getScaleY_should_return_1', TestConst.TEST_LEVEL, (): void => {
      expect(screenLockConf.getScaleY()).assertEqual(1);
    })

    it('test_getBlur_should_return_0', TestConst.TEST_LEVEL, (): void => {
      expect(screenLockConf.getBlur()).assertEqual(0);
    })

    it('test_getAlpha_should_return_0', TestConst.TEST_LEVEL, (): void => {
      expect(screenLockConf.getAlpha()).assertEqual(1);
    })

    it('test_ScreenLockAni_doWhenDesktopToAOD', TestConst.TEST_LEVEL, (): void => {
      screenLockAni.doWhenDesktopToAOD();
      expect(screenLockConf.getScaleX()).assertEqual(1);
    })

    it('test_ScreenLockAni_doWhenScreenLockToAOD', TestConst.TEST_LEVEL, (): void => {
      screenLockAni.doWhenScreenLockToAOD();
      expect(screenLockConf.getScaleX()).assertEqual(1);
    })

    it('test_ScreenLockAni_doWhenOffScreen', TestConst.TEST_LEVEL, (): void => {
      screenLockAni.doWhenOffScreen();
      expect(screenLockConf.getScaleX()).assertEqual(0.95);
    })

    it('test_ScreenLockAni_doWhenOnScreen', TestConst.TEST_LEVEL, (): void => {
      screenLockAni.doWhenOnScreen();
      expect(screenLockConf.getScaleX()).assertEqual(1);
    })

    it('test_ScreenLockAni_doWhenBeginSleep', TestConst.TEST_LEVEL, (): void => {
      screenLockAni.doWhenBeginSleep();
      expect(screenLockConf.getScaleX()).assertEqual(1);
    })

    it('test_screenLockElementAni_doWhenDesktopToAOD', TestConst.TEST_LEVEL, (): void => {
      screenLockElementAni.doWhenDesktopToAOD();
      expect(lockIconConf.getScaleX()).assertEqual(0.7);
      expect(lockIconConf.getScaleY()).assertEqual(0.7);
      expect(lockIconConf.getBlur()).assertEqual(0);
    })

    it('test_screenLockElementAni_doWhenScreenLockToAOD', TestConst.TEST_LEVEL, (): void => {
      screenLockElementAni.doWhenScreenLockToAOD();
      expect(lockIconConf.getScaleX()).assertEqual(1);
      expect(lockIconConf.getScaleY()).assertEqual(1);
      expect(lockIconConf.getBlur()).assertEqual(0);
    })

    it('test_screenLockElementAni_doWhenOffScreen', TestConst.TEST_LEVEL, (): void => {
      screenLockElementAni.doWhenOffScreen();
      expect(lockIconConf.getScaleX()).assertEqual(0.7);
      expect(lockIconConf.getScaleY()).assertEqual(0.7);
      expect(lockIconConf.getBlur()).assertEqual(0);
    })

    it('test_screenLockElementAni_doWhenOnScreen', TestConst.TEST_LEVEL, (): void => {
      screenLockElementAni.doWhenOnScreen();
      expect(lockIconConf.getScaleX()).assertEqual(0.7);
      expect(lockIconConf.getScaleY()).assertEqual(0.7);
      expect(lockIconConf.getBlur()).assertEqual(0);
    })

    it('test_screenLockElementAni_doWhenBeginSleep', TestConst.TEST_LEVEL, (): void => {
      screenLockElementAni.doWhenBeginSleep();
      expect(lockIconConf.getScaleX()).assertEqual(0.7);
      expect(lockIconConf.getScaleY()).assertEqual(0.7);
      expect(lockIconConf.getBlur()).assertEqual(0);
    })

  })

}
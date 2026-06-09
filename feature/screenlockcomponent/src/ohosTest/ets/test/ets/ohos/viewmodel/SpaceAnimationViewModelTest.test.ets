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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium';
import TestConst from '../constants/TestConst';
import ScreenLockSpaceAnimationViewModel
  from '../../../../../../main/ets/password/viewmodel/ScreenLockSpaceAnimationViewModel';
import { SCBScreenProperty } from '@ohos/windowscene';

export default function SpaceAnimationViewModelTest() {

  const mSpaceAniViewModel: ScreenLockSpaceAnimationViewModel = new ScreenLockSpaceAnimationViewModel();

  describe('SpaceAnimationViewModelTest', (): void => {

    beforeAll((): void => {
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {
    })

    it('test_doItemNoPwdUnlockAnimation', TestConst.TEST_LEVEL, (): void => {
      mSpaceAniViewModel.doItemNoPwdUnlockAnimation(false, true);
      mSpaceAniViewModel.doItemNoPwdUnlockAnimation(true, true);
      expect(true).assertTrue();
    })

    it('test_setUnlockAnimation', TestConst.TEST_LEVEL, (): void => {
      mSpaceAniViewModel.setUnlockAnimation(0, 0);
      expect(true).assertTrue();
    })

    it('test_setSlideAnimation', TestConst.TEST_LEVEL, (): void => {
      mSpaceAniViewModel.setSlideAnimation(0, 0);
      expect(true).assertTrue();
    })

    it('test_getDelay', TestConst.TEST_LEVEL, (): void => {
      mSpaceAniViewModel.getDelay("sl_clock");
      expect(true).assertTrue();
    })

    it('test_getClockScale', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions = mSpaceAniViewModel.getClockScale(0.9, {
        centerX: 1, centerY: 1
      });
      mSpaceAniViewModel.getClockScale(0.9, {
        centerX: 0, centerY: 0
      });
      expect(ret.x).assertEqual(0.9);
    })

    it('test_getQuickToolsIconScale_01', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions = mSpaceAniViewModel.getQuickToolsIconScale(true, 1.1, 0.9, {
        centerX: 1, centerY: 1
      });
      expect(ret.x).assertEqual(1.1);
    })

    it('test_getQuickToolsIconScale_02', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions = mSpaceAniViewModel.getQuickToolsIconScale(false, 1.1, 0.9, {
        centerX: 1, centerY: 1
      });
      expect(ret.x).assertEqual(0.9);
    })

    it('test_getCameraIconScale_01', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions = mSpaceAniViewModel.getCameraIconScale(true, 1.1, 0.9, {
        centerX: 1, centerY: 1
      });
      expect(ret.x).assertEqual(1.1);
    })

    it('test_getCameraIconScale_02', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions = mSpaceAniViewModel.getCameraIconScale(false, 1.1, 0.9, {
        centerX: 1, centerY: 1
      });
      expect(ret.x).assertEqual(0.9);
    })

    it('test_getLockIconScale_01', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions | undefined = mSpaceAniViewModel.getLockIconScale(true, 1.1, false, 0.9, {
        centerX: 1, centerY: 1
      });
      expect(ret?.x).assertEqual(1.1);
    })

    it('test_getLockIconScale_02', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions | undefined = mSpaceAniViewModel.getLockIconScale(false, 1.1, true, 0.9, {
        centerX: 1, centerY: 1
      });
      expect(ret?.x).assertEqual(0.9);
    })

    it('test_getLockIconScale_03', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions | undefined = mSpaceAniViewModel.getLockIconScale(false, 1.1, false, 0.9, {
        centerX: 1, centerY: 1
      });
      expect(ret).assertUndefined();
    })

    it('test_getClockAnimScale', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions = mSpaceAniViewModel.getClockAnimScale(true, {
        x: 1, y: 1
      }, {
        x: 0.9, y: 0.9
      });
      expect(ret.x).assertEqual(1);
    })

    it('test_getClockSlideAnimScale', TestConst.TEST_LEVEL, (): void => {
      let ret: ScaleOptions = mSpaceAniViewModel.getClockSlideAnimScale(1);
      expect(ret.x).assertEqual(1);
    })

    it('test_viewModelInit', TestConst.TEST_LEVEL, (): void => {
      let screenProp = new SCBScreenProperty();
      mSpaceAniViewModel.viewModelInit(screenProp);
      expect(true).assertTrue();
    })

    it('test_getOpacityDuration', TestConst.TEST_LEVEL, (): void => {
      let result = mSpaceAniViewModel.getOpacityDuration(1, 1);
      expect(result).assertEqual(0);
    })
  })

}
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
import ScreenLockSpaceAnimationViewModel
  from '../../../../../../../main/ets/password/viewmodel/ScreenLockSpaceAnimationViewModel';
import { WidgetPivot } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { SlWidgetId } from '@ohos/screenlockcommon/src/main/ets/constants/SlWidgetConst';

export default function MulchingCoverageTest() {

  describe('MulchingCoverageTest', (): void => {
    let screenLockSpaceAnimation: ScreenLockSpaceAnimationViewModel = new ScreenLockSpaceAnimationViewModel();
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_doLockIconAnimation', 0, (): void => {
      let resA: Object = (screenLockSpaceAnimation as object)['doLockIconAnimation'](true, true);
      expect(resA === null).assertFalse();
      let resB: Object = (screenLockSpaceAnimation as object)['doLockIconAnimation'](false, false);
      expect(resB === null).assertFalse();
    })

    it('test_doClockAnimation', 0, (): void => {
      let resA: Object = (screenLockSpaceAnimation as object)['doClockAnimation'](true, true);
      expect(resA === null).assertFalse();
      let resB: Object = (screenLockSpaceAnimation as object)['doClockAnimation'](false, false);
      expect(resB === null).assertFalse();
    })

    it('test_doFormIconAnimation', 0, (): void => {
      let resA: Object = (screenLockSpaceAnimation as object)['doFormIconAnimation'](true, true);
      expect(resA === null).assertFalse();
      let resB: Object = (screenLockSpaceAnimation as object)['doFormIconAnimation'](false, false);
      expect(resB === null).assertFalse();
    })

    it('test_doQuickToolsAnimation', 0, (): void => {
      let resA: Object = (screenLockSpaceAnimation as object)['doQuickToolsAnimation'](true, true);
      expect(resA === null).assertFalse();
      let resB: Object = (screenLockSpaceAnimation as object)['doQuickToolsAnimation'](false, false);
      expect(resB === null).assertFalse();
    })

    it('test_doImmersiveCapAnimation', 0, (): void => {
      let resA: Object = (screenLockSpaceAnimation as object)['doImmersiveCapAnimation'](true, true);
      expect(resA === null).assertFalse();
      let resB: Object = (screenLockSpaceAnimation as object)['doImmersiveCapAnimation'](false, false);
      expect(resB === null).assertFalse();
    })

    it('test_doImmersiveListAnimation', 0, (): void => {
      let resA: Object = (screenLockSpaceAnimation as object)['doImmersiveListAnimation'](true, true);
      expect(resA === null).assertFalse();
      let resB: Object = (screenLockSpaceAnimation as object)['doImmersiveListAnimation'](false, false);
      expect(resB === null).assertFalse();
    })

    it('test_doImmersiveCardAnimation', 0, (): void => {
      let resA: Object = (screenLockSpaceAnimation as object)['doImmersiveCardAnimation'](true, true);
      expect(resA === null).assertFalse();
      let resB: Object = (screenLockSpaceAnimation as object)['doImmersiveCardAnimation'](false, false);
      expect(resB === null).assertFalse();
    })

    it('test_doCameraAnimation', 0, (): void => {
      let resA: Object = (screenLockSpaceAnimation as object)['doCameraAnimation'](true, true);
      expect(resA === null).assertFalse();
      let resB: Object = (screenLockSpaceAnimation as object)['doCameraAnimation'](false, false);
      expect(resB === null).assertFalse();
    })

    it('test_getImmersiveKeyguardListScale', 0, (): void => {
      let resA = screenLockSpaceAnimation.getImmersiveKeyguardListScale(true);
      expect(resA !== undefined).assertTrue();
      let resB = screenLockSpaceAnimation.getImmersiveKeyguardListScale(false);
      expect(resB === undefined).assertTrue();
    })

    it('test_getImmersiveKeyguardListOpacity', 0, (): void => {
      let resA = screenLockSpaceAnimation.getImmersiveKeyguardListOpacity(true);
      expect(typeof resA === 'number').assertTrue();
      let resB = screenLockSpaceAnimation.getImmersiveKeyguardListOpacity(false);
      expect(resB === undefined).assertTrue();
    })

    it('test_getImmersiveKeyguardCardScale', 0, (): void => {
      let resA = screenLockSpaceAnimation.getImmersiveKeyguardCardScale(true);
      expect(resA !== undefined).assertTrue();
      let resB = screenLockSpaceAnimation.getImmersiveKeyguardCardScale(false);
      expect(resB === undefined).assertTrue();
    })

    it('test_getImmersiveKeyguardCardOpacity', 0, (): void => {
      let resA = screenLockSpaceAnimation.getImmersiveKeyguardCardOpacity(true);
      expect(typeof resA === 'number').assertTrue();
      let resB = screenLockSpaceAnimation.getImmersiveKeyguardCardOpacity(false);
      expect(resB === undefined).assertTrue();
    })

    it('test_getQuickToolsIconScale', 0, (): void => {
      let point: WidgetPivot = {
        centerX: 0,
        centerY: 0,
        centerZ: 0
      }
      let resA = screenLockSpaceAnimation.getQuickToolsIconScale(true, 1, 2, point);
      expect(resA === null).assertFalse();
      let resB = screenLockSpaceAnimation.getQuickToolsIconScale(false, 1, 2, point);
      expect(resB === null).assertFalse();
    })

    it('test_getCameraIconScale', 0, (): void => {
      let point: WidgetPivot = {
        centerX: 0,
        centerY: 0,
        centerZ: 0
      }
      let resA = screenLockSpaceAnimation.getCameraIconScale(true, 1, 2, point);
      expect(resA === null).assertFalse();
      let resB = screenLockSpaceAnimation.getCameraIconScale(false, 1, 2, point);
      expect(resB === null).assertFalse();
    })

    it('test_getLockIconScale', 0, (): void => {
      let point: WidgetPivot = {
        centerX: 0,
        centerY: 0,
        centerZ: 0
      }
      let resA = screenLockSpaceAnimation.getLockIconScale(true, 1, true, 2, point);
      expect(resA === null).assertFalse();
      let resB = screenLockSpaceAnimation.getLockIconScale(false, 1, true, 2, point);
      expect(resB === null).assertFalse();
      let resC = screenLockSpaceAnimation.getLockIconScale(false, 1, false, 2, point);
      expect(resC === undefined).assertTrue();
    })

    it('test_getClockAnimScale', 0, (): void => {
      let curAnimateScale: ScaleOptions = {
        x: 1,
        y: 1,
        z: 1,
        centerX: 1,
        centerY: 1
      }
      let sceneAnimateScale: ScaleOptions = {
        x: 2,
        y: 2,
        z: 2,
        centerX: 2,
        centerY: 2
      }
      let resA = screenLockSpaceAnimation.getClockAnimScale(true, curAnimateScale, sceneAnimateScale);
      expect(resA === null).assertFalse();
      let resB = screenLockSpaceAnimation.getClockAnimScale(false, curAnimateScale, sceneAnimateScale);
      expect(resB === null).assertFalse();
    })

    it('test_isComponentSpaceUnlockAnimation', 0, (): void => {
      let resA: Object = (ScreenLockSpaceAnimationViewModel as object)['isComponentSpaceUnlockAnimation']();
      expect(resA === null).assertFalse();
    })

    it('test_isClockSpaceUnlockAnimation', 0, (): void => {
      let resA: Object = (ScreenLockSpaceAnimationViewModel as object)['isClockSpaceUnlockAnimation']();
      expect(resA === null).assertFalse();
    })

    it('test_isSpaceUnlockAnimation', 0, (): void => {
      let resA = ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation();
      expect(resA === null).assertFalse();
      let componentId: SlWidgetId = SlWidgetId.CLOCK;
      let resB = ScreenLockSpaceAnimationViewModel.isSpaceUnlockAnimation(componentId);
      expect(resB === null).assertFalse();
    })
  })
}

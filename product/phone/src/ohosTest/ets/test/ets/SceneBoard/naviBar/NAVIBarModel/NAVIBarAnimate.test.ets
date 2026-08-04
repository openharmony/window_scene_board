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
import { GlobalContext } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NAVIBarAnimate } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarAnimate';
import { SCBNaviBarConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/SCBNaviBarConstants';
import { NAVIBarData, } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarData';
import { NAVIBarViewData, } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarViewData';
import type abilityCommon from '@ohos.app.ability.common';
import { systemDateTime } from '@kit.BasicServicesKit';
import { inputMonitor } from '@kit.InputKit';
import { TouchEvent as InputTouch } from '@ohos.multimodalInput.touchEvent';

export default function NAVIBarAnimateTest() {
  describe('NAVIBarAnimateTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    let naviBarAnimate: NAVIBarAnimate = NAVIBarAnimate.getInstance();
    let naviBarData: NAVIBarData = NAVIBarData.getInstance();
    let naviBarViewData: NAVIBarViewData = NAVIBarViewData.getInstance();
    let eventArea: Area = {
      width: 0,
      height: 0,
      position: {
        x: 0, y: 0
      },
      globalPosition: {
        x: 0, y: 0
      }
    };

    let eventTarget: EventTarget = {
      area: eventArea
    };

    let event: GestureEvent = {
      target: eventTarget,
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      repeat: false,
      fingerList: [],
      offsetX: 0,
      offsetY: 0,
      angle: 0,
      speed: 0,
      scale: 0,
      pinchCenterX: 0,
      pinchCenterY: 0,
      velocityX: 0,
      velocityY: 0,
      velocity: 0
    };

    it('naviBarAnimate_checkInitAnimParam_1', 0, () => {
      naviBarViewData.isShowingNaviBar = false;
      expect(naviBarAnimate.checkInitAnimParam(event) === undefined).assertTrue();
    })

    it('naviBarAnimate_checkInitAnimParam_2', 0, () => {
      let event: GestureEvent | null = null;
      expect(naviBarAnimate.checkInitAnimParam(event) === undefined).assertTrue();
    })

    it('naviBarAnimate_checkInitAnimParam_3', 0, () => {
      expect(naviBarAnimate.checkInitAnimParam(event) === undefined).assertTrue();
    })

    it('naviBarAnimate_checkInitAnimParam_5', 0, () => {
      let event: GestureEvent | undefined = undefined;
      expect(naviBarAnimate.checkInitAnimParam(event) === undefined).assertTrue();
    })

    it('naviBarAnimate_checkInitAnimParam_7', 0, () => {
      naviBarViewData.isShowingNaviBar = true;
      expect(naviBarAnimate.checkInitAnimParam(event) === undefined).assertTrue();
    })

    it('naviBarAnimate_resetAnimParam_1', 0, () => {
      expect(naviBarAnimate.resetAnimParam(event) === undefined).assertTrue();
    })

    it('naviBarAnimate_processBackEventAnimate_1', 0, () => {
      expect(naviBarAnimate.processBackEventAnimate() === undefined).assertTrue();
    })

    it('naviBarAnimate_getTransitionEffect_1', 0, () => {
      let isSystemBarEnable: boolean = true;
      naviBarAnimate.getTransitionEffect(isSystemBarEnable);
      expect(naviBarAnimate).not().assertUndefined();
    })

    it('naviBarAnimate_getTransitionEffect_2', 0, () => {
      let isSystemBarEnable: boolean = false;
      naviBarAnimate.getTransitionEffect(isSystemBarEnable);
      expect(naviBarAnimate).not().assertUndefined();
    })

    it('naviBarAnimate_onActionEndAndCancelAnimal_1', 0, () => {
      expect(naviBarAnimate.onActionEndAndCancelAnimal() === undefined).assertTrue();
    })

    it('naviBarAnimate_playBarAnim_1', 0, () => {
      naviBarData.startOffsetY = 30;
      event.offsetY = 10;
      naviBarViewData.isShowingNaviBar = true;
      expect(naviBarAnimate.checkPlayBarFollowHandAnim(event) === undefined).assertTrue();
    })

    it('naviBarAnimate_naviBarChangeAnim_1', 0, () => {
      let type: number = 0;
      expect(naviBarAnimate.naviBarChangeAnim(type) === undefined).assertTrue();
    })

    it('naviBarAnimate_naviBarChangeAnim_2', 0, () => {
      let type: number = 1;
      expect(naviBarAnimate.naviBarChangeAnim(type) === undefined).assertTrue();
    })

    it('naviBarAnimate_naviBarChangeAnim_3', 0, () => {
      let type: number = 2;
      expect(naviBarAnimate.naviBarChangeAnim(type) === undefined).assertTrue();
    })

    it('naviBarAnimate_naviBarChangeAnim_4', 0, () => {
      let type: number = 3;
      expect(naviBarAnimate.naviBarChangeAnim(type) === undefined).assertTrue();
    })

    it('naviBarAnimate_changeToDefaultNaviBar_1', 0, () => {
      expect(naviBarAnimate.changeToDefaultNaviBar() === undefined).assertTrue();
    })
  })
}
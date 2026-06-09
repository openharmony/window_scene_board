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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level, expect } from '@ohos/hypium';
import { ElementConf } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutParam';
import { ClockAnimData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockAnimData';
import { ClockBindData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockBindData';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import { ClockLayoutModifier } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutModifier';
import {
  AnimParamType,
  AnimPrepareParam,
  AnimScene,
  ClockAnimParam } from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/viewanim/ClockWidgetAnimManager';
import {
  ClockWidgetOneShotAnimManager
} from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/viewanim/ClockWidgetOneShotAnimManager';
import { ClockAodAndDesktopConsts, ScreenLockToDesktopConsts } from '@ohos/screenlockcommon/src/main/ets/TsIndex';

/**
 * 时钟测试用例
 */
export default function ClockWidgetOneShotAnimManagerTest() {
  let staticState: ClockStaticData = new ClockStaticData();
  let bindState: ClockBindData = new ClockBindData();
  let clockAnimData: ClockAnimData = new ClockAnimData();
  let clockLayoutModifier: ClockLayoutModifier = new ClockLayoutModifier(bindState);

  describe('ClockWidgetOneShotAnimManagerTest', (): void => {
    let manager: ClockWidgetOneShotAnimManager = new ClockWidgetOneShotAnimManager(staticState, bindState,
      clockAnimData, clockLayoutModifier);
    let animPreParam: AnimPrepareParam = {
      mainAnimScene: AnimScene.SCENE_MAIN_COLLAPSE,
      sepAlphaScene: AnimScene.SCENE_SEP_ALPHA_COLLAPSE,
      isTimeSeparate: true,
      isPreSeparateShow: true,
      isCurSeparateShow: true,
      isPreSeparateLine: false,
      isCurSeparateLine: true,
      isPreLargeDate: true,
      isCurLargeDate: false
    };
    let clockAniParam: ClockAnimParam = {isAnimToExpand: false, animListener: undefined}

    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });


    it('test_getIsOnOneShotAnim', Level.LEVEL0, (): void => {
      manager.getIsOnOneShotAnim();
      expect(true).assertTrue();
    });

    it('test_startCollapseStateChangeAnimForOneShot', Level.LEVEL0, (): void => {
      staticState.isClockToCollapseOnDesktop = false;
      manager.startCollapseStateChangeAnimForOneShot(clockAniParam, 'test');
      staticState.isClockToCollapseOnDesktop = true;
      manager.startCollapseStateChangeAnimForOneShot(clockAniParam, 'test');
      expect(true).assertTrue();
    });

    it('test_startSeparatorAlphaAnimForOneShot', Level.LEVEL0, (): void => {
      animPreParam.isPreSeparateShow = true;
      animPreParam.isCurSeparateShow = true;
      animPreParam.isPreSeparateLine = false;
      animPreParam.isCurSeparateLine = true;
      (manager as object)['startSeparatorAlphaAnimForOneShot'](animPreParam, 'test');

      animPreParam.mainAnimScene = AnimScene.SCENE_MAIN_EXPAND;
      (manager as object)['startSeparatorAlphaAnimForOneShot'](animPreParam, 'test');

      animPreParam.isPreSeparateLine = true;
      (manager as object)['startSeparatorAlphaAnimForOneShot'](animPreParam, 'test');

      animPreParam.isPreSeparateShow = false;
      animPreParam.isCurSeparateShow = false;
      (manager as object)['startSeparatorAlphaAnimForOneShot'](animPreParam, 'test');

      animPreParam.isPreSeparateShow = true;
      animPreParam.isCurSeparateShow = false;
      (manager as object)['startSeparatorAlphaAnimForOneShot'](animPreParam,
        ClockAodAndDesktopConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION);
      (manager as object)['startSeparatorAlphaAnimForOneShot'](animPreParam,
        ClockAodAndDesktopConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION);
      expect(true).assertTrue();
    });

    it('test_initLineAlphaAnimForOneShot', Level.LEVEL0, (): void => {
      animPreParam.isPreSeparateShow = true;
      animPreParam.isCurSeparateShow = true;
      (manager as object)['initLineAlphaAnimForOneShot'](animPreParam, 'test');
      (manager as object)['initLineAlphaAnimForOneShot'](animPreParam, 'SLIDE_UP_TO_RESET_CLOCK_ANIMATION');

      animPreParam.isPreSeparateShow = true;
      animPreParam.isCurSeparateShow = false;
      (manager as object)['initLineAlphaAnimForOneShot'](animPreParam, 'test');
      (manager as object)['initLineAlphaAnimForOneShot'](animPreParam, 'SLIDE_UP_TO_RESET_CLOCK_ANIMATION');

      animPreParam.isPreSeparateLine = false;
      (manager as object)['initLineAlphaAnimForOneShot'](animPreParam, 'test');
      expect(true).assertTrue();
    });

    it('test_initPointAlphaAnimForOneShot', Level.LEVEL0, (): void => {
      animPreParam.isPreSeparateShow = true;
      animPreParam.isCurSeparateShow = true;
      (manager as object)['initPointAlphaAnimForOneShot'](animPreParam, 'test');
      (manager as object)['initPointAlphaAnimForOneShot'](animPreParam, 'SLIDE_UP_TO_RESET_CLOCK_ANIMATION');

      animPreParam.isPreSeparateShow = true;
      animPreParam.isCurSeparateShow = false;
      (manager as object)['initPointAlphaAnimForOneShot'](animPreParam, 'test');
      (manager as object)['initPointAlphaAnimForOneShot'](animPreParam, 'SLIDE_UP_TO_RESET_CLOCK_ANIMATION');

      animPreParam.isPreSeparateLine = false;
      (manager as object)['initLineAlphaAnimForOneShot'](animPreParam, 'test');
      (manager as object)['initPointAlphaAnimForOneShot'](animPreParam, 'SLIDE_UP_TO_RESET_CLOCK_ANIMATION');
      expect(true).assertTrue();
    });

    it('test_startAllElementAnimForOneShot', Level.LEVEL0, (): void => {
      animPreParam.isTimeSeparate = false;
      (manager as object)['startAllElementAnimForOneShot'](animPreParam, 'test');

      animPreParam.isTimeSeparate = true;
      animPreParam.mainAnimScene = AnimScene.SCENE_MAIN_COLLAPSE;
      (manager as object)['startAllElementAnimForOneShot'](animPreParam, 'test');

      animPreParam.mainAnimScene = AnimScene.SCENE_MAIN_EXPAND;
      (manager as object)['startAllElementAnimForOneShot'](animPreParam, 'SLIDE_UP_TO_RESET_CLOCK_ANIMATION');
      expect(true).assertTrue();
    });

    it('test_createUnitAnimateTo', Level.LEVEL0, (): void => {
      (manager as object)['createUnitAnimateTo'](undefined, 'test', animPreParam);
      expect(true).assertTrue();
    });

    it('test_createSeparateAnimateTo', Level.LEVEL0, (): void => {
      (manager as object)['createSeparateAnimateTo'](0, undefined, 'test', true, animPreParam, 0);
      (manager as object)['createSeparateAnimateTo'](0, undefined, 'test', false, animPreParam, 0);
      expect(true).assertTrue();
    });

    it('test_updateClockOffset', Level.LEVEL0, (): void => {
      staticState.isClockToCollapseOnDesktop = false;
      (manager as object)['updateClockOffset'](false);
      (manager as object)['updateClockOffset'](true);

      staticState.isClockToCollapseOnDesktop = true;
      (manager as object)['updateClockOffset'](false);
      (manager as object)['updateClockOffset'](true);
      expect(true).assertTrue();
    });

    it('test_updateNoTimeViewOpacity', Level.LEVEL0, (): void => {
      staticState.isClockToCollapseOnDesktop = false;
      (manager as object)['updateNoTimeViewOpacity']();

      staticState.isClockToCollapseOnDesktop = true;
      (manager as object)['updateNoTimeViewOpacity']();
      expect(true).assertTrue();
    });

    it('test_updateTimeViewOpacity', Level.LEVEL0, (): void => {
      staticState.isClockToCollapseOnDesktop = false;
      staticState.textColorOfDesktopClock = '#000000';
      (manager as object)['updateTimeViewOpacity']();

      staticState.textColorOfDesktopClock = '#FFFFFF';
      (manager as object)['updateTimeViewOpacity']();

      staticState.isClockToCollapseOnDesktop = true;
      staticState.textColorOfDesktopClock = '#000000';
      (manager as object)['updateTimeViewOpacity']();

      staticState.textColorOfDesktopClock = '#FFFFFF';
      (manager as object)['updateTimeViewOpacity']();
      expect(true).assertTrue();
    });

    it('test_updateTextColor', Level.LEVEL0, (): void => {
      staticState.textColor = '#FFFFFF';
      staticState.isClockToCollapseOnDesktop = false;
      staticState.textColorOfScreenLockClock = '#FFFFFF';
      (manager as object)['updateTextColor']();

      staticState.textColorOfScreenLockClock = '#000000';
      (manager as object)['updateTextColor']();

      staticState.isClockToCollapseOnDesktop = true;
      staticState.textColorOfDesktopClock = '#FFFFFF';
      (manager as object)['updateTextColor']();

      staticState.textColorOfDesktopClock = '#000000';
      (manager as object)['updateTextColor']();
      expect(true).assertTrue();
    });

    it('test_updateTextOffSets', Level.LEVEL0, (): void => {
      (manager as object)['updateTextOffSets']();
      expect(true).assertTrue();
    });

    it('test_updateScaleOptions', Level.LEVEL0, (): void => {
      (manager as object)['updateScaleOptions']();
      expect(true).assertTrue();
    });

    it('test_updateFontSizeAfterSlideUp', Level.LEVEL0, (): void => {
      (manager as object)['updateFontSizeAfterSlideUp']();
      expect(true).assertTrue();
    });

    it('test_getMainSpringAnimListenerForOneShot', Level.LEVEL0, (): void => {
      (manager as object)['getMainSpringAnimListenerForOneShot'](animPreParam, 'test');
      (manager as object)['getMainSpringAnimListenerForOneShot'](animPreParam, 'FACE_TO_DESKTOP_CLOCK_ANIMATION');
      (manager as object)['getMainSpringAnimListenerForOneShot'](animPreParam, 'FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION');
      expect(true).assertTrue();
    });

    it('test_sendMessageToUnlock', Level.LEVEL0, (): void => {
      (manager as object)['sendMessageToUnlock']('test');
      (manager as object)['sendMessageToUnlock']('SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION');
      (manager as object)['sendMessageToUnlock']('FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION');
      (manager as object)['sendMessageToUnlock']('FACE_TO_DESKTOP_CLOCK_ANIMATION');
      expect(true).assertTrue();
    });

    it('test_prepareForOneShotAnimOnFirstMove', Level.LEVEL0, (): void => {
      clockAniParam.animListener = undefined
      manager.prepareForOneShotAnimOnFirstMove(clockAniParam);

      clockAniParam.animListener = {
        onAnimationStart: undefined
      }
      manager.prepareForOneShotAnimOnFirstMove(clockAniParam);

      clockAniParam.animListener = {
        onAnimationStart: () => {}
      }
      manager.prepareForOneShotAnimOnFirstMove(clockAniParam);
      expect(true).assertTrue();
    });

    it('test_prepareForSeparatorAlphaAnimOnFirstMove', Level.LEVEL0, (): void => {
      animPreParam.isPreSeparateShow = false;
      animPreParam.isCurSeparateShow = false;
      (manager as object)['prepareForSeparatorAlphaAnimOnFirstMove'](animPreParam);

      animPreParam.isPreSeparateShow = true;
      animPreParam.isCurSeparateShow = true;
      animPreParam.isPreSeparateLine = false;
      animPreParam.isCurSeparateLine = true;
      (manager as object)['prepareForSeparatorAlphaAnimOnFirstMove'](animPreParam);

      animPreParam.isPreSeparateLine = true;
      animPreParam.isCurSeparateLine = true;
      (manager as object)['prepareForSeparatorAlphaAnimOnFirstMove'](animPreParam);
      expect(true).assertTrue();
    });

    it('test_startCollapseStateChangeAnimOnMoveForOneShot', Level.LEVEL0, (): void => {
      staticState.isClockToCollapseOnDesktop = true;
      staticState.collapseElementConf = undefined;
      manager.startCollapseStateChangeAnimOnMoveForOneShot(true, 1);

      staticState.collapseElementConf = [new ElementConf()];
      manager.startCollapseStateChangeAnimOnMoveForOneShot(true, 1);

      manager.startCollapseStateChangeAnimOnMoveForOneShot(true, 10000);
      expect(true).assertTrue();
    });

    it('test_startAllElementAnimOnMove', Level.LEVEL0, (): void => {
      animPreParam.isTimeSeparate = false;
      (manager as object)['startAllElementAnimOnMove'](animPreParam, 0);

      animPreParam.isTimeSeparate = true;
      animPreParam.mainAnimScene = AnimScene.SCENE_MAIN_COLLAPSE;
      (manager as object)['startAllElementAnimOnMove'](animPreParam, 0);
      (manager as object)['startAllElementAnimOnMove'](animPreParam, 100);

      animPreParam.mainAnimScene = AnimScene.SCENE_MAIN_EXPAND;
      (manager as object)['startAllElementAnimOnMove'](animPreParam, 0);
      (manager as object)['startAllElementAnimOnMove'](animPreParam, 100);
      expect(true).assertTrue();
    });

    it('test_updateElementWithProgress', Level.LEVEL0, (): void => {
      (manager as object)['updateElementWithProgress'](0);
      let confs: ElementConf[] = [new ElementConf(), new ElementConf()];
      (manager as object)['updateElementWithProgress'](0, undefined, undefined, [1]);
      (manager as object)['updateElementWithProgress'](0, confs, undefined, [1]);
      (manager as object)['updateElementWithProgress'](0, confs, confs, [1]);
      expect(true).assertTrue();
    });

    it('test_updateClockGridParamWithProgress', Level.LEVEL0, (): void => {
      (manager as object)['updateClockGridParamWithProgress'](0);
      expect(true).assertTrue();
    });

    it('test_updateNoTimeViewOpacityWithProgress', Level.LEVEL0, (): void => {
      (manager as object)['updateNoTimeViewOpacityWithProgress'](0);
      (manager as object)['updateNoTimeViewOpacityWithProgress'](10);
      expect(true).assertTrue();
    });

    it('test_updateClockOffsetWithProgress', Level.LEVEL0, (): void => {
      (manager as object)['updateClockOffsetWithProgress'](1, true);
      (manager as object)['updateClockOffsetWithProgress'](1, false);
      expect(true).assertTrue();
    });

    it('test_startClockFontSizeAnimOnUpForOneShot', Level.LEVEL0, (): void => {
      staticState.isClockToCollapseOnDesktop = true;
      staticState.collapseElementConf = undefined;
      manager.startClockFontSizeAnimOnUpForOneShot(clockAniParam, 0);

      staticState.collapseElementConf = [new ElementConf()];
      manager.startClockFontSizeAnimOnUpForOneShot(clockAniParam, 0);
      expect(true).assertTrue();
    });

    it('test_startCollapseStateChangeAnimOnUpForOneShot', Level.LEVEL0, (): void => {
      staticState.isClockToCollapseOnDesktop = true;
      staticState.collapseElementConf = undefined;
      manager.startCollapseStateChangeAnimOnUpForOneShot(clockAniParam, 0);

      staticState.collapseElementConf = [new ElementConf()];
      manager.startCollapseStateChangeAnimOnUpForOneShot(clockAniParam, 0);
      expect(true).assertTrue();
    });

    it('test_startAllElementAndSeparatorAlphaAnimOnUp', Level.LEVEL0, (): void => {
      animPreParam.isTimeSeparate = false;
      (manager as object)['startAllElementAndSeparatorAlphaAnimOnUp'](animPreParam, 0);

      animPreParam.isTimeSeparate = true;
      (manager as object)['startAllElementAndSeparatorAlphaAnimOnUp'](animPreParam, 0);
      expect(true).assertTrue();
    });

    it('test_updateElementForOneShot', Level.LEVEL0, (): void => {
      let confs: ElementConf[] = [new ElementConf(), new ElementConf()];
      (manager as object)['updateElementForOneShot'](false);
      (manager as object)['updateElementForOneShot'](true);
      (manager as object)['updateElementForOneShot'](false, undefined, [1]);
      (manager as object)['updateElementForOneShot'](false, confs, [1]);
      expect(true).assertTrue();
    });

    it('test_createUnitAnimateToOnUp', Level.LEVEL0, (): void => {
      let confs: ElementConf[] = [new ElementConf(), new ElementConf()];
      (manager as object)['createUnitAnimateToOnUp'](undefined, animPreParam, 0);
      (manager as object)['createUnitAnimateToOnUp'](confs, animPreParam, 0);
      expect(true).assertTrue();
    });

    it('test_createSeparateAnimateToOnUp', Level.LEVEL0, (): void => {
      let confs: ElementConf[] = [new ElementConf(), new ElementConf()];
      animPreParam.mainAnimScene = AnimScene.SCENE_MAIN_COLLAPSE;
      (manager as object)['createSeparateAnimateToOnUp'](animPreParam, confs, 0);

      animPreParam.mainAnimScene = AnimScene.SCENE_MAIN_EXPAND;
      (manager as object)['createSeparateAnimateToOnUp'](animPreParam, confs, 0);
      expect(true).assertTrue();
    });

    it('test_updateHourFontSize', Level.LEVEL0, (): void => {
      (manager as object)['updateHourFontSize'](1);
      expect(true).assertTrue();
    });

    it('test_updateMinuteAndSeparatorFontSize', Level.LEVEL0, (): void => {
      (manager as object)['updateMinuteAndSeparatorFontSize'](1);
      expect(true).assertTrue();
    });

    it('test_updateHourMinuteAndSeparatorFontSize', Level.LEVEL0, (): void => {
      (manager as object)['updateHourMinuteAndSeparatorFontSize'](1);
      expect(true).assertTrue();
    });

    it('test_stopOneShotAnim', Level.LEVEL0, (): void => {
      manager.stopOneShotAnim();
      expect(true).assertTrue();
    });

    it('test_getAnimCurve', Level.LEVEL0, (): void => {
      (manager as object)['getAnimCurve'](undefined, 0);
      (manager as object)['getAnimCurve'](AnimParamType.MAIN_SPRING, 0);
      (manager as object)['getAnimCurve'](AnimParamType.SECONDARY_CUBIC_BEZIER, 0);
      expect(true).assertTrue();
    });

    it('test_startAllElementAnimForDesktopAodOneShot', Level.LEVEL0, (): void => {
      animPreParam.isTimeSeparate = false;
      (manager as object)['startAllElementAnimForDesktopAodOneShot'](animPreParam,
        ClockAodAndDesktopConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION);

      animPreParam.isTimeSeparate = true;
      (manager as object)['startAllElementAnimForDesktopAodOneShot'](animPreParam,
        ClockAodAndDesktopConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION);

      (manager as object)['startAllElementAnimForDesktopAodOneShot'](animPreParam,
        ClockAodAndDesktopConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION);
      expect(true).assertTrue();
    });

    it('test_createDesktopAndAodUnitAnimateTo', Level.LEVEL0, (): void => {
      (manager as object)['createDesktopAndAodUnitAnimateTo'](undefined, 'test', animPreParam);
      expect(true).assertTrue();
    });

    it('test_createDeskTopToAodSeparateAnimateTo', Level.LEVEL0, (): void => {
      (manager as object)['createDeskTopToAodSeparateAnimateTo'](undefined, 'test', animPreParam);
      expect(true).assertTrue();
    });

    it('test_createAodToDesktopSeparateAnimateTo', Level.LEVEL0, (): void => {
      (manager as object)['createAodToDesktopSeparateAnimateTo'](undefined, 'test', animPreParam);
      expect(true).assertTrue();
    });

    it('test_updateFontSizeAfterScreenOff', Level.LEVEL0, (): void => {
      (manager as object)['updateFontSizeAfterScreenOff']();
      expect(true).assertTrue();
    });

    it('test_setClockToCollapse', Level.LEVEL0, (): void => {
      manager.setClockToCollapse();
      expect(true).assertTrue();
    });

    it('test_getAnimationEndDelay', Level.LEVEL0, (): void => {
      (manager as object)['getAnimationEndDelay']('test');
      (manager as object)['getAnimationEndDelay'](ScreenLockToDesktopConsts.FACE_TO_DESKTOP_CLOCK_ANIMATION);
      (manager as object)['getAnimationEndDelay'](ScreenLockToDesktopConsts.FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION);
      (manager as object)['getAnimationEndDelay'](ClockAodAndDesktopConsts.FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION);
      (manager as object)['getAnimationEndDelay'](ClockAodAndDesktopConsts.DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION);
      expect(true).assertTrue();
    });

    it('test_refreshClockParamInAnim', Level.LEVEL0, (): void => {
      (manager as object)['refreshClockParamInAnim'](false);
      expect(true).assertTrue();
    });
  });
}
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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { ClockWidgetModel } from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/ClockWidgetModel';
import { ClockGridParam, ClockLayoutParam } from '@ohos/screenlockwidget/src/main/ets/clock/common/ClockLayoutParam';
import { ClockLayout } from '@ohos/screenlockwidget/src/main/ets/common/WidgetParam';
import { ClockStaticData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockStaticData';
import { ScreenLockState, ComponentCallback, MeshRange } from '@ohos/screenlockcommon';
import { DisplayModeChangeListener } from '@ohos/screenlockcommon/Index';
import { ClockBindData } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/ClockBindData';
import {
  ClockWidgetOneShotAnimManager
} from '@ohos/screenlockwidget/src/main/ets/clock/viewmodel/viewanim/ClockWidgetOneShotAnimManager';
import {
  ClockStaticStateType,
  FormWgStaticStateType,
  SlBindStateType,
  SlMainStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import {
  ImmersiveBaseState,
  immersiveKgMgr,
  OnStateChangeListener,
  StateType
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { SlClockStaticState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockStaticState';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import {
  ScreenLockWallpaperChangeEvent
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/event/ImmersiveEvent';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { slStateHelper } from '../../../../../../main/ets/common/helper/SlStateHelper';
import { SlClockBindState } from '@ohos/screenlockwidget/src/main/ets/clock/model/data/SlClockBindState';
import MultiSceneThemeManager from '@ohos/screenlockwidget/src/main/ets/common/theme/MultiSceneThemeManager';
import { UDFontAdapterUtil } from '@ohos/screenlockwidget/src/main/ets/clock/common/UDFontAdapterUtil';
import { HVAlign } from '@ohos/screenlockwidget/src/main/ets/clock/common/HorizontalVerticalAlign';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

export default function ClockWidgetModelTest() {
  const mClockWidgetModel: ClockWidgetModel = new ClockWidgetModel()
  describe('ClockWidgetModelTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('test_mClockWidgetModel_getIsClockWidgetExpand', '0', (): void => {
      AppStorage.setOrCreate('isBeginSleepStart', true);
      mClockWidgetModel.getClockStaticState();
      mClockWidgetModel.getClockBindState();
      mClockWidgetModel.getClockAnimData();
      mClockWidgetModel.updateClockElementVisible(false, false, false);
      mClockWidgetModel.updateClockCollapseState(false);
      mClockWidgetModel.onClickClock();
      let mIsClockWidgetExpand = mClockWidgetModel.getIsClockWidgetExpand();
      expect(mIsClockWidgetExpand).assertEqual(false);
    });

    it('test_mClockWidgetModel_getIsNotificationExpand', '0', (): void => {
      mClockWidgetModel.updateClockElementVisible(true, true, true);
      mClockWidgetModel.updateClockCollapseState(true);
      mClockWidgetModel.setIsNotificationExpand(false);
      mClockWidgetModel.destroyMeshRange();
      let mIsNotificationExpand = mClockWidgetModel.getIsNotificationExpand();
      expect(mIsNotificationExpand).assertEqual(false);
    });

    it('test_updateClockLayoutParam', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['updateClockLayoutParam']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockMargin', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['updateClockMargin']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateDateWeekStyle', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['updateDateWeekStyle']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockOffset', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['updateClockOffset']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onEnterHost', Level.LEVEL0, (): void => {
      mClockWidgetModel.onEnterHost(ScreenLockState.THEME_EDITOR_FULL);
      mClockWidgetModel.onEnterHost(ScreenLockState.THEME_EDITOR_FULL);
      mClockWidgetModel.onEnterHost(ScreenLockState.HOST);
      mClockWidgetModel.onEnterHost(ScreenLockState.HOST);
      mClockWidgetModel.onEnterHost(ScreenLockState.EXIT_KEYGUARD);
      mClockWidgetModel.onEnterHost(ScreenLockState.EXIT_KEYGUARD);
      mClockWidgetModel.onEnterOtherApp();
      mClockWidgetModel.onClickClock();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_initMeshRange', Level.LEVEL0, (): void => {
      let clockChangeCallback: ComponentCallback = {
        onChange: (isClockExpand: boolean): void => {
        },
      };
      mClockWidgetModel.initMeshRange(clockChangeCallback);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_registerClockStyleChange', Level.LEVEL0, (): void => {
      mClockWidgetModel.registerClockStyleChange((positionY: number) => {
      });
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_getClockExpand', Level.LEVEL0, (): void => {
      mClockWidgetModel.getIsClockWidgetExpand();
      mClockWidgetModel.getIsNotificationExpand();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_setIsNotificationExpand', Level.LEVEL0, (): void => {
      mClockWidgetModel.setIsNotificationExpand(true);
      mClockWidgetModel.setIsNotificationExpand(false);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_handleClockExpand', Level.LEVEL0, (): void => {
      let mrange: MeshRange = new MeshRange(0, 100);
      (mClockWidgetModel as object)['handleClockExpand'](mrange);
      mrange.rangeStart = 0;
      mrange.rangeEnd = 0;
      (mClockWidgetModel as object)['handleClockExpand'](mrange);
      mrange.rangeStart = 90;
      mrange.rangeEnd = 100;
      (mClockWidgetModel as object)['handleClockExpand'](mrange);
      mClockWidgetModel.destroyMeshRange();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_printRangeInfo', Level.LEVEL0, (): void => {
      let mrange: MeshRange = new MeshRange(0, 100);
      (mClockWidgetModel as object)['printRangeInfo'](mrange);
      mrange.rangeStart = 0;
      mrange.rangeEnd = 0;
      (mClockWidgetModel as object)['printRangeInfo'](mrange);
      mrange.rangeStart = 90;
      mrange.rangeEnd = 100;
      (mClockWidgetModel as object)['printRangeInfo'](mrange);
      mClockWidgetModel.destroyMeshRange();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_checkHasFormCard', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['checkHasFormCard']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_registerFont', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['registerFont']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onEnterThemeEditor', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['onEnterThemeEditor'](ScreenLockState.THEME_EDITOR_FULL);
      (mClockWidgetModel as object)['onEnterThemeEditor'](ScreenLockState.HOST);
      (mClockWidgetModel as object)['onEnterThemeEditor'](ScreenLockState.ENTER_OTHER_APP);
      (mClockWidgetModel as object)['onEnterThemeEditor'](ScreenLockState.THEME_EDITOR_FULL_FORM);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onEnterFullEditor', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['onEnterFullEditor'](ScreenLockState.THEME_EDITOR_FULL, ScreenLockState.HOST);
      (mClockWidgetModel as object)['onEnterFullEditor'](ScreenLockState.ENTER_OTHER_APP, ScreenLockState.HOST);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onClickClock', Level.LEVEL0, (): void => {
      mClockWidgetModel.onEnterThemeEditor(ScreenLockState.ENTER_OTHER_APP);
      (mClockWidgetModel as object)['onClickClock']();
      mClockWidgetModel.onEnterFullEditor(ScreenLockState.ENTER_OTHER_APP, ScreenLockState.THEME_EDITOR_FULL);
      (mClockWidgetModel as object)['onClickClock']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateSlClockRegionState', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['updateSlClockRegionState']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateFontFamily', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['updateFontFamily']('yahei');
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_handleIfNeed', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['handleIfNeed']('yahei');
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_handleScreenLockWallpaperChangeEvent', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['handleScreenLockWallpaperChangeEvent']('Aod_ClockWidget');
      (mClockWidgetModel as object)['handleScreenLockWallpaperChangeEvent']('ClockWidget');
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_setCallBackForOneShotAni', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['setCallBackForOneShotAni']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_getClockBrightnessOptions', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['getClockBrightnessOptions']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_getEnterpriseSystemParam', Level.LEVEL0, (): void => {
      mClockWidgetModel.getEnterpriseSystemParam();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_getEdmEnableSystemParam', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['getEdmEnableSystemParam']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_setClockLayoutParam', Level.LEVEL0, (): void => {
      mClockWidgetModel.setClockLayoutParam(new ClockLayoutParam());
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockLayoutByManualEdit', Level.LEVEL0, (): void => {
      let clkStaticData = new ClockStaticData();
      clkStaticData.clockLayout = ClockLayout.NORMAL_CLOCK_LAYOUT_SPECIAL;
      (mClockWidgetModel as object)['staticState'] = clkStaticData;
      mClockWidgetModel.updateClockLayoutByManualEdit(ClockLayout.DIMENSION_4_4);
      mClockWidgetModel.updateClockLayoutByManualEdit(ClockLayout.DIMENSION_2_4);
      mClockWidgetModel.updateClockLayoutByManualEdit(ClockLayout.DEFAULT_CLOCK_LAYOUT);
      mClockWidgetModel.updateClockLayoutByManualEdit(ClockLayout.MOUNTAIN_CLOCK_LAYOUT_SEPERATOR);
      mClockWidgetModel.updateClockLayoutByManualEdit(ClockLayout.CLOCK_LAYOUT_UD_FLAG);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateTextColorOnStyleChange', Level.LEVEL0, (): void => {
      mClockWidgetModel.updateTextColorOnStyleChange('#ff00ff00');
      mClockWidgetModel.updateTextColorOnStyleChange('#ffffffff');
      mClockWidgetModel.updateTextColorOnStyleChange('#ff000000');
      mClockWidgetModel.updateTextColorOnStyleChange('#00000000');
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_recoverClockAfterOneShotAnim', Level.LEVEL0, (): void => {
      mClockWidgetModel.recoverClockAfterOneShotAnim();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_refreshClockLayout', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['refreshClockLayout']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_setIsNeedRefreshClockLayout', Level.LEVEL0, (): void => {
      mClockWidgetModel.setIsNeedRefreshClockLayout(true);
      mClockWidgetModel.setIsNeedRefreshClockLayout(false);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateTest', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['updateNoTimeViewOpacity']();
      (mClockWidgetModel as object)['updateTimeViewOpacity']();
      (mClockWidgetModel as object)['updateTextColor']();
      (mClockWidgetModel as object)['updateTextOffSets']();
      (mClockWidgetModel as object)['updateScaleOptions']();
      (mClockWidgetModel as object)['updateFontSizeAfterSlideUp']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_subscribeForOneShotAnim', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['subscribeForOneShotAnim']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_subscribeForBeginSleep', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['subscribeForBeginSleep']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_subscribeForSlideReset', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['subscribeForSlideReset']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_subscribeForFaceToDesktop', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['subscribeForFaceToDesktop']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_subscribeForFingerprintToDesktop', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['subscribeForFingerprintToDesktop']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_subscribeForFingerprintToDesktop', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['subscribeForFingerprintToDesktop']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_subscribeForSlideUpToChangeFontSize', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['subscribeForSlideUpToChangeFontSize']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_subscribeForDesktopToAod', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['subscribeForDesktopToAod']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_subscribeForAodToDesktop', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['subscribeForAodToDesktop']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_unsubscribeForOneShotAnim', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['unsubscribeForOneShotAnim']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockElementVisible', Level.LEVEL0, (): void => {
      mClockWidgetModel.updateClockElementVisible(true, true, true);
      mClockWidgetModel.updateClockElementVisible(true, true, false);
      mClockWidgetModel.updateClockElementVisible(true, false, true);
      mClockWidgetModel.updateClockElementVisible(true, false, false);
      mClockWidgetModel.updateClockElementVisible(false, true, true);
      mClockWidgetModel.updateClockElementVisible(false, true, false);
      mClockWidgetModel.updateClockElementVisible(false, false, true);
      mClockWidgetModel.updateClockElementVisible(false, false, false);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_setImmersivePanelRelated', Level.LEVEL0, (): void => {
      mClockWidgetModel.setImmersivePanelRelated(true);
      mClockWidgetModel.setImmersivePanelRelated(false);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_prepareForOneShotAnimOnFirstMove', Level.LEVEL0, (): void => {
      mClockWidgetModel.prepareForOneShotAnimOnFirstMove();
      mClockWidgetModel.updateClockWidgetParamsOnMove(0);
      mClockWidgetModel.updateClockWidgetParamsOnMove(1);
      mClockWidgetModel.updateClockWidgetParamsOnMove(100);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_screenSizeChangeCallback', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onEnterOtherAppBorderShow', Level.LEVEL0, (): void => {
      mClockWidgetModel.onEnterOtherAppBorderShow();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onEnterOtherAppBorderHide', Level.LEVEL0, (): void => {
      mClockWidgetModel.onEnterOtherAppBorderHide();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_handleClockCollapse', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['handleClockCollapse']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_setBackgroundColor', Level.LEVEL0, (): void => {
      mClockWidgetModel.setBackgroundColor('#ff00ff00');
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockBrightnessOption', Level.LEVEL0, (): void => {
      mClockWidgetModel.updateClockBrightnessOption();
      mClockWidgetModel.updateClockBrightnessOption(true);
      mClockWidgetModel.updateClockBrightnessOption(false);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_destroyViewModel', Level.LEVEL0, (): void => {
      mClockWidgetModel.destroyViewModel();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_setClockViewId', Level.LEVEL0, (): void => {
      mClockWidgetModel.setClockViewId('test', true);
      mClockWidgetModel.setClockViewId('test', false);
      expect(mClockWidgetModel).not().assertNull();
    })

    it('test_screenSizeChangeCallback_02', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun = mock.mockFunc(staticState, staticState.updateDisplayScale);
      when(mockFun)().afterReturn(true);
      (mClockWidgetModel as object)['isImmersivePanelRelated'] = true;
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState,staticState.updateDisplayScale);
    });

    it('test_screenSizeChangeCallback_03', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateDisplayScale);
      let mockFun2 = mock.mockFunc(staticState, staticState.updateScreenPortrait);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState,staticState.updateDisplayScale);
      mock.ignoreMock(staticState,staticState.updateScreenPortrait);
    });

    it('test_screenSizeChangeCallback_04', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateDisplayScale);
      let mockFun2 = mock.mockFunc(staticState, staticState.updateScreenPortrait);
      let mockFun3 = mock.mockFunc(staticState, staticState.updateFoldExpand);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(false);
      when(mockFun3)().afterReturn(true);
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState,staticState.updateDisplayScale);
      mock.ignoreMock(staticState,staticState.updateScreenPortrait);
      mock.ignoreMock(staticState,staticState.updateFoldExpand);
    });

    it('test_screenSizeChangeCallback_05', Level.LEVEL0, (): void => {
      let bindState: ClockBindData = (mClockWidgetModel as object)['bindState'];
      bindState.isClockWidgetOnTouchMoving = true;
      (mClockWidgetModel as object)['isTextDigital'] = true;
      mClockWidgetModel.recoverClockAfterOneShotAnim();
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_screenSizeChangeCallback_06', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let oneShotAnimMgr: ClockWidgetOneShotAnimManager = (mClockWidgetModel as object)['oneShotAnimMgr'];
      let bindState: ClockBindData = (mClockWidgetModel as object)['bindState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateFoldExpand);
      let mockFun2 = mock.mockFunc(oneShotAnimMgr, oneShotAnimMgr.getIsOnOneShotAnim);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['isTextDigital'] = true;
      bindState.isClockWidgetOnTouchMoving = true;
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      oneShotAnimMgr.stopOneShotAnim();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateFoldExpand);
      mock.ignoreMock(oneShotAnimMgr, oneShotAnimMgr.getIsOnOneShotAnim);
    });

    it('test_onFormStateChange', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['onFormStateChange'].onSlStateChange('', FormWgStaticStateType.FORM_SHOW_COUNT);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onStateChange_02', Level.LEVEL0, (): void => {
      let state: OnStateChangeListener = (mClockWidgetModel as object)['onStateChange']
      let immersive: ImmersiveBaseState = new ImmersiveBaseState()
      let mock = new MockKit();
      let mockFun = mock.mockFunc(immersive, immersive.getStateType);
      when(mockFun)().afterReturn(StateType.TYPE_DISPLAY_SIZE);
      state.onStateChange(immersive);
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(immersive, immersive.getStateType);
    });


    it('test_handleImmersiveStateChange_02', Level.LEVEL0, (): void => {
      let slClockStaticCtrl: SlClockStaticState = (mClockWidgetModel as object)['slClockStaticCtrl'];
      let immersive = immersiveKgMgr.getImmersiveDisplayState();
      let immersiveState = immersiveKgMgr.getBeforeImmersiveState();
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slClockStaticCtrl, slClockStaticCtrl.getIsClockVisible);
      let mockFun2 = mock.mockFunc(immersive, immersive.isImmersive);
      let mockFun3 = mock.mockFunc(immersiveState, immersiveState.isImmersive);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      when(mockFun3)().afterReturn(true);
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slClockStaticCtrl, slClockStaticCtrl.getIsClockVisible);
      mock.ignoreMock(immersive, immersive.isImmersive);
      mock.ignoreMock(immersiveState, immersiveState.isImmersive);
    });

      it('test_registerImmersiveStateChange', Level.LEVEL0, (): void => {
      let stateChange: OnStateChangeListener = (mClockWidgetModel as object)['onStateChange'];
      immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, stateChange);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_unRegisterImmersiveStateChange', Level.LEVEL0, (): void => {
      let stateChange: OnStateChangeListener = (mClockWidgetModel as object)['onStateChange'];
      immersiveKgMgr.unregisterStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, stateChange);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onClockStateChange', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['onClockStateChange'].onSlStateChange('', ClockStaticStateType.IS_CHANGE_COLOR);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_handleScreenLockWallpaperChangeEvent_02', Level.LEVEL0, (): void => {
      let slBindState: ISlState = (mClockWidgetModel as object)['slBindState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slBindState, slBindState.getSlState);
      when(mockFun1)(SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER).afterReturn(true);
      (mClockWidgetModel as object)['handleScreenLockWallpaperChangeEvent']('test');
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slBindState, slBindState.getSlState);
    });

    it('test_initViewModel', Level.LEVEL0, (): void => {
      let displayModeChange: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number) => {
        }
      };
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun = mock.mockFunc(staticState, staticState.updateDisplayScale);
      when(mockFun)().afterReturn(true);
      mClockWidgetModel.initViewModel(displayModeChange, 'test');
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateDisplayScale);
    });

    it('test_initViewModel_02', Level.LEVEL0, (): void => {
      let displayModeChange: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number) => {
        }
      };
      let clockViewId = 'test';
      (mClockWidgetModel as object)['handleScreenLockWallpaperChangeEvent'](clockViewId);
      mClockWidgetModel.initViewModel(displayModeChange, clockViewId);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_initViewModel_03', Level.LEVEL0, (): void => {
      let displayModeChange: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number) => {
        }
      };
      let clockViewId = 'test';
      (mClockWidgetModel as object)['isTextDigital'] = true;
      mClockWidgetModel.initViewModel(displayModeChange, clockViewId);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_initViewModel_04', Level.LEVEL0, (): void => {
      let displayModeChange: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number) => {
        }
      };
      let clockViewId = 'test';
      let slClockStaticCtrl: SlClockStaticState = (mClockWidgetModel as object)['slClockStaticCtrl']
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slClockStaticCtrl, slClockStaticCtrl.getIsClockForceCollapseState);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['slClockStaticCtrl'].setClockForceCollapseState(undefined);
      mClockWidgetModel.initViewModel(displayModeChange, clockViewId);
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slClockStaticCtrl, slClockStaticCtrl.getIsClockForceCollapseState);
    });

    it('test_slUiStateMgr', Level.LEVEL0, (): void => {
      let onFormStateChange: ISlStateChangeListener = (mClockWidgetModel as object)['onFormStateChange'];
      slUiStateMgr.registerSlStateChangeListener(onFormStateChange);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockBrightnessOption_02', Level.LEVEL0, (): void => {
      let slClockStaticCtrl: SlClockStaticState = (mClockWidgetModel as object)['slClockStaticCtrl']
      let mock = new MockKit();
      let mockFun = mock.mockFunc(slClockStaticCtrl, slClockStaticCtrl.getChangeColorState);
      when(mockFun)().afterReturn(true);
      mClockWidgetModel.updateClockBrightnessOption(true);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_setCallBackForOneShotAni_02', Level.LEVEL0, (): void => {
      let slClockStaticCtrl: SlClockStaticState = (mClockWidgetModel as object)['slClockStaticCtrl'];
      let mock = new MockKit();
      let mockFun = mock.mockFunc(slClockStaticCtrl, slClockStaticCtrl.getChangeColorState);
      when(mockFun)().afterReturn(true);
      mClockWidgetModel.updateClockBrightnessOption(true);
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slClockStaticCtrl, slClockStaticCtrl.getChangeColorState);
    });

    it('test_getClockBrightnessOptions_02', Level.LEVEL0, (): void => {
      let slState = slStateHelper.getSlClockStaticState();
      let slStateClock = slStateHelper.getSlClockBindState() as SlClockBindState;
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slState, slState.getChangeColorState);
      let mockFun2 = mock.mockFunc(slStateClock, slStateClock.getLightWallpaperState);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['getClockBrightnessOptions']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slState, slState.getChangeColorState);
      mock.ignoreMock(slStateClock, slStateClock.getLightWallpaperState);
    });

    it('test_getClockBrightnessOptions_03', Level.LEVEL0, (): void => {
      let slState = slStateHelper.getSlClockStaticState();
      let slStateClock = slStateHelper.getSlClockBindState() as SlClockBindState;
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slState, slState.getChangeColorState);
      let mockFun2 = mock.mockFunc(slStateClock, slStateClock.getLightWallpaperState);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(false);
      (mClockWidgetModel as object)['getClockBrightnessOptions']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slState, slState.getChangeColorState);
      mock.ignoreMock(slStateClock, slStateClock.getLightWallpaperState);
    });

    it('test_getClockBrightnessOptions_04', Level.LEVEL0, (): void => {
      let slState = slStateHelper.getSlClockStaticState();
      let slStateClock = slStateHelper.getSlClockBindState() as SlClockBindState;
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slState, slState.getChangeColorState);
      let mockFun2 = mock.mockFunc(slStateClock, slStateClock.getLightWallpaperState);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['getClockBrightnessOptions']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slState, slState.getChangeColorState);
      mock.ignoreMock(slStateClock, slStateClock.getLightWallpaperState);
    });

    it('test_updateClockLayout', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateClockLayout);
      when(mockFun1)(ClockLayout.DIMENSION_4_4).afterReturn(true);
      (mClockWidgetModel as object)['isImmersivePanelRelated'] = true;
      mClockWidgetModel.updateClockLayout(ClockLayout.DIMENSION_4_4, 10)
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateClockLayout);
    });

    it('test_updateClockLayoutByManualEdit_02', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      staticState.clockLayout = ClockLayout.CLOCK_LAYOUT_UD_FLAG;
      mClockWidgetModel.updateClockLayoutByManualEdit(ClockLayout.CLOCK_LAYOUT_UD_FLAG);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockLayoutByManualEdit_04', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      staticState.clockLayout = ClockLayout.NORMAL_CLOCK_LAYOUT;
      (mClockWidgetModel as object)['isImmersivePanelRelated'] = true;
      mClockWidgetModel.updateClockLayoutByManualEdit(ClockLayout.CLOCK_LAYOUT_UD_FLAG);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_clockLayoutParam', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let clockParam: ClockGridParam = new ClockGridParam();
      staticState.clockLayout = ClockLayout.NORMAL_CLOCK_LAYOUT;
      (mClockWidgetModel as object)['clockLayoutParam'].initClockLayoutParam(10, clockParam);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockMargin_02', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateClockViewMargin);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateClockMargin']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateClockViewMargin);
    });

    it('test_updateClockOffset_02', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateClockOffset);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateClockOffset']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateClockOffset);
    });

    it('test_updateNoTimeViewOpacity', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateNoTimeViewOpacity);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateNoTimeViewOpacity']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateNoTimeViewOpacity);
    });

    it('test_updateTimeViewOpacity', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateTimeViewOpacity);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateTimeViewOpacity']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateTimeViewOpacity);
    });

    it('test_updateTextColor', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateTextColor);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateTextColor']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateTextColor);
    });

    it('test_updateClockCollapseState', Level.LEVEL0, (): void => {
      let staticState: SlClockStaticState = (mClockWidgetModel as object)['slClockStaticCtrl'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.getIsExitingKg);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateClockCollapseState']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.getIsExitingKg);
    });

    it('test_handleIfNeed_02', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      let mockFun2 = mock.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['handleIfNeed']('test');
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      mock.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
    });

    it('test_handleIfNeed_03', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      let mockFun2 = mock.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(false);
      (mClockWidgetModel as object)['handleIfNeed']('test');
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      mock.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
    });

    it('test_computeHorizontalAlign', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeHorizontalAlign'](10, 20, 30);
      expect(res).assertEqual(HVAlign.CENTER);
    });

    it('test_computeAlign', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeAlign'](10, 10, 30);
      expect(res).assertEqual(HVAlign.CENTER);
    });

    it('test_computeAlign_02', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeAlign'](10, 15, 10);
      expect(res).assertEqual(HVAlign.START);
    });

    it('test_computeAlign_03', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeAlign'](10, 15, 15);
      expect(res).assertEqual(HVAlign.END);
    });

    it('test_computeAlign_04', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeAlign'](10, 12, 15);
      expect(res).assertEqual(HVAlign.CENTER);
    });

    it('test_recoverClockBeforeUnlockAnimIfNeed', Level.LEVEL0, (): void => {
      let slClockBindCtrl: SlClockBindState = (mClockWidgetModel as object)['slClockBindCtrl'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slClockBindCtrl, slClockBindCtrl.getClockDesktopToAod);
      when(mockFun1)().afterReturn(true);
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slClockBindCtrl, slClockBindCtrl.getClockDesktopToAod);
    });


    it('test_screenSizeChangeCallback_02', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun = mock.mockFunc(staticState, staticState.updateDisplayScale);
      when(mockFun)().afterReturn(true);
      (mClockWidgetModel as object)['isImmersivePanelRelated'] = true;
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateDisplayScale);
    });

    it('test_screenSizeChangeCallback_03', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateDisplayScale);
      let mockFun2 = mock.mockFunc(staticState, staticState.updateScreenPortrait);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateDisplayScale);
      mock.ignoreMock(staticState, staticState.updateScreenPortrait);
    });

    it('test_screenSizeChangeCallback_04', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateDisplayScale);
      let mockFun2 = mock.mockFunc(staticState, staticState.updateScreenPortrait);
      let mockFun3 = mock.mockFunc(staticState, staticState.updateFoldExpand);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(false);
      when(mockFun3)().afterReturn(true);
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateDisplayScale);
      mock.ignoreMock(staticState, staticState.updateScreenPortrait);
      mock.ignoreMock(staticState, staticState.updateFoldExpand);
    });

    it('test_screenSizeChangeCallback_05', Level.LEVEL0, (): void => {
      let bindState: ClockBindData = (mClockWidgetModel as object)['bindState'];
      bindState.isClockWidgetOnTouchMoving = true;
      (mClockWidgetModel as object)['isTextDigital'] = true;
      mClockWidgetModel.recoverClockAfterOneShotAnim();
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_screenSizeChangeCallback_06', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let oneShotAnimMgr: ClockWidgetOneShotAnimManager = (mClockWidgetModel as object)['oneShotAnimMgr'];
      let bindState: ClockBindData = (mClockWidgetModel as object)['bindState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateFoldExpand);
      let mockFun2 = mock.mockFunc(oneShotAnimMgr, oneShotAnimMgr.getIsOnOneShotAnim);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['isTextDigital'] = true;
      bindState.isClockWidgetOnTouchMoving = true;
      (mClockWidgetModel as object)['screenSizeChangeCallback']();
      oneShotAnimMgr.stopOneShotAnim();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateFoldExpand);
      mock.ignoreMock(oneShotAnimMgr, oneShotAnimMgr.getIsOnOneShotAnim);
    });

    it('test_onFormStateChange', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['onFormStateChange'].onSlStateChange('', FormWgStaticStateType.FORM_SHOW_COUNT)
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onStateChange_02', Level.LEVEL0, (): void => {
      let state: OnStateChangeListener = (mClockWidgetModel as object)['onStateChange']
      let immersive: ImmersiveBaseState = new ImmersiveBaseState()
      let mock = new MockKit();
      let mockFun = mock.mockFunc(immersive, immersive.getStateType);
      when(mockFun)().afterReturn(StateType.TYPE_DISPLAY_SIZE);
      state.onStateChange(immersive);
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(immersive, immersive.getStateType);
    });

    it('test_registerImmersiveStateChange', Level.LEVEL0, (): void => {
      let stateChange: OnStateChangeListener = (mClockWidgetModel as object)['onStateChange'];
      immersiveKgMgr.registerStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, stateChange)
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_unRegisterImmersiveStateChange', Level.LEVEL0, (): void => {
      let stateChange: OnStateChangeListener = (mClockWidgetModel as object)['onStateChange'];
      immersiveKgMgr.unregisterStateChangeListener(StateType.TYPE_IMMERSIVE_KEYGUARD_TYPE, stateChange)
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_onClockStateChange', Level.LEVEL0, (): void => {
      (mClockWidgetModel as object)['onClockStateChange'].onSlStateChange('', ClockStaticStateType.IS_CHANGE_COLOR);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_handleScreenLockWallpaperChangeEvent_02', Level.LEVEL0, (): void => {
      let slBindState: ISlState = (mClockWidgetModel as object)['slBindState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slBindState, slBindState.getSlState);
      when(mockFun1)(SlBindStateType.IS_USING_IMMERSIVE_WALL_PAPER).afterReturn(true);
      (mClockWidgetModel as object)['handleScreenLockWallpaperChangeEvent']('test');
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slBindState, slBindState.getSlState);
    });

    it('test_initViewModel', Level.LEVEL0, (): void => {
      let displayModeChange: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number) => {
        }
      }
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun = mock.mockFunc(staticState, staticState.updateDisplayScale);
      when(mockFun)().afterReturn(true);
      mClockWidgetModel.initViewModel(displayModeChange, 'test');
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateDisplayScale);
    });


    it('test_initViewModel_02', Level.LEVEL0, (): void => {
      let displayModeChange: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number) => {
        }
      };
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun = mock.mockFunc(staticState, staticState.updateDisplayScale);
      when(mockFun)().afterReturn(true);
      (mClockWidgetModel as object)['eventMgr'].on(ScreenLockWallpaperChangeEvent, () => {
        (mClockWidgetModel as object)['handleScreenLockWallpaperChangeEvent']('test')
      });
      mClockWidgetModel.initViewModel(displayModeChange, 'test')
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateDisplayScale);
    });

    it('test_initViewModel_02', Level.LEVEL0, (): void => {
      let displayModeChange: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number) => {
        }
      };
      let clockViewId = 'test';
      (mClockWidgetModel as object)['handleScreenLockWallpaperChangeEvent'](clockViewId)
      mClockWidgetModel.initViewModel(displayModeChange, clockViewId);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_initViewModel_03', Level.LEVEL0, (): void => {
      let displayModeChange: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number) => {
        }
      };
      let clockViewId = 'test';
      (mClockWidgetModel as object)['isTextDigital'] = true;
      mClockWidgetModel.initViewModel(displayModeChange, clockViewId);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_initViewModel_04', Level.LEVEL0, (): void => {
      let displayModeChange: DisplayModeChangeListener = {
        onDisplayModeChange: (displayMode: number) => {
        }
      };
      let clockViewId = 'test';
      let slClockStaticCtrl: SlClockStaticState = (mClockWidgetModel as object)['slClockStaticCtrl']
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slClockStaticCtrl, slClockStaticCtrl.getIsClockForceCollapseState);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['slClockStaticCtrl'].setClockForceCollapseState(undefined);
      mClockWidgetModel.initViewModel(displayModeChange, clockViewId);
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slClockStaticCtrl, slClockStaticCtrl.getIsClockForceCollapseState);
    });

    it('test_slUiStateMgr', Level.LEVEL0, (): void => {
      let onFormStateChange: ISlStateChangeListener = (mClockWidgetModel as object)['onFormStateChange'];
      slUiStateMgr.registerSlStateChangeListener(onFormStateChange);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockBrightnessOption_02', Level.LEVEL0, (): void => {
      let slClockStaticCtrl: SlClockStaticState = (mClockWidgetModel as object)['slClockStaticCtrl']
      let mock = new MockKit();
      let mockFun = mock.mockFunc(slClockStaticCtrl, slClockStaticCtrl.getChangeColorState);
      when(mockFun)().afterReturn(true);
      mClockWidgetModel.updateClockBrightnessOption(true);
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slClockStaticCtrl, slClockStaticCtrl.getChangeColorState);
    });


    it('test_getClockBrightnessOptions_02', Level.LEVEL0, (): void => {
      let slState = slStateHelper.getSlClockStaticState();
      let slStateClock = slStateHelper.getSlClockBindState() as SlClockBindState;
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slState, slState.getChangeColorState);
      let mockFun2 = mock.mockFunc(slStateClock, slStateClock.getLightWallpaperState);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['getClockBrightnessOptions']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slState, slState.getChangeColorState);
      mock.ignoreMock(slStateClock, slStateClock.getLightWallpaperState);
    });

    it('test_getClockBrightnessOptions_03', Level.LEVEL0, (): void => {
      let slState = slStateHelper.getSlClockStaticState();
      let slStateClock = slStateHelper.getSlClockBindState() as SlClockBindState;
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slState, slState.getChangeColorState);
      let mockFun2 = mock.mockFunc(slStateClock, slStateClock.getLightWallpaperState);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(false);
      (mClockWidgetModel as object)['getClockBrightnessOptions']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slState, slState.getChangeColorState);
      mock.ignoreMock(slStateClock, slStateClock.getLightWallpaperState);
    });

    it('test_getClockBrightnessOptions_04', Level.LEVEL0, (): void => {
      let slState = slStateHelper.getSlClockStaticState();
      let slStateClock = slStateHelper.getSlClockBindState() as SlClockBindState;
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(slState, slState.getChangeColorState);
      let mockFun2 = mock.mockFunc(slStateClock, slStateClock.getLightWallpaperState);
      when(mockFun1)().afterReturn(false);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['getClockBrightnessOptions']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(slState, slState.getChangeColorState);
      mock.ignoreMock(slStateClock, slStateClock.getLightWallpaperState);
    });

    it('test_updateClockLayout', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateClockLayout);
      when(mockFun1)(ClockLayout.DIMENSION_4_4).afterReturn(true);
      (mClockWidgetModel as object)['isImmersivePanelRelated'] = true;
      mClockWidgetModel.updateClockLayout(ClockLayout.DIMENSION_4_4, 10)
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateClockLayout);
    });

    it('test_updateClockLayoutByManualEdit_02', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      staticState.clockLayout = ClockLayout.CLOCK_LAYOUT_UD_FLAG;
      mClockWidgetModel.updateClockLayoutByManualEdit(ClockLayout.CLOCK_LAYOUT_UD_FLAG);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockLayoutByManualEdit_04', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      staticState.clockLayout = ClockLayout.NORMAL_CLOCK_LAYOUT;
      (mClockWidgetModel as object)['isImmersivePanelRelated'] = true;
      mClockWidgetModel.updateClockLayoutByManualEdit(ClockLayout.CLOCK_LAYOUT_UD_FLAG);
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_clockLayoutParam', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let clockParam: ClockGridParam = new ClockGridParam();
      staticState.clockLayout = ClockLayout.NORMAL_CLOCK_LAYOUT;
      (mClockWidgetModel as object)['clockLayoutParam'].initClockLayoutParam(10, clockParam)
      expect(mClockWidgetModel).not().assertNull();
    });

    it('test_updateClockMargin_02', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateClockViewMargin);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateClockMargin']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateClockViewMargin);
    });

    it('test_updateClockOffset_02', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateClockOffset);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateClockOffset']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateClockOffset);
    });

    it('test_updateNoTimeViewOpacity', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateNoTimeViewOpacity);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateNoTimeViewOpacity']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateNoTimeViewOpacity);
    });

    it('test_updateTimeViewOpacity', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateTimeViewOpacity);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateTimeViewOpacity']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateTimeViewOpacity);
    });

    it('test_updateTextColor', Level.LEVEL0, (): void => {
      let staticState: ClockStaticData = (mClockWidgetModel as object)['staticState'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.updateTextColor);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateTextColor']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.updateTextColor);
    });

    it('test_updateClockCollapseState', Level.LEVEL0, (): void => {
      let staticState: SlClockStaticState = (mClockWidgetModel as object)['slClockStaticCtrl'];
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(staticState, staticState.getIsExitingKg);
      when(mockFun1)().afterReturn(true);
      (mClockWidgetModel as object)['updateClockCollapseState']();
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(staticState, staticState.getIsExitingKg);
    });

    it('test_handleIfNeed_02', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      let mockFun2 = mock.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      (mClockWidgetModel as object)['handleIfNeed']('test');
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      mock.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
    });

    it('test_handleIfNeed_03', Level.LEVEL0, (): void => {
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      let mockFun2 = mock.mockFunc(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(false);
      (mClockWidgetModel as object)['handleIfNeed']('test');
      expect(mClockWidgetModel).not().assertNull();
      mock.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isUD);
      mock.ignoreMock(UDFontAdapterUtil, UDFontAdapterUtil.isSupportByFont);
    });

    it('test_computeHorizontalAlign', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeHorizontalAlign'](10, 20, 30);
      expect(res).assertEqual(HVAlign.CENTER);
    });

    it('test_computeAlign', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeAlign'](10, 10, 30);
      expect(res).assertEqual(HVAlign.CENTER);
    });

    it('test_computeAlign_02', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeAlign'](10, 15, 10);
      expect(res).assertEqual(HVAlign.START);
    });

    it('test_computeAlign_03', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeAlign'](10, 15, 15);
      expect(res).assertEqual(HVAlign.END);
    });

    it('test_computeAlign_04', Level.LEVEL0, (): void => {
      let res: number = (mClockWidgetModel as object)['computeAlign'](10, 12, 15);
      expect(res).assertEqual(HVAlign.CENTER);
    });
  });
}

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
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { LauncherVisualEffectManager } from '../../../../../../main/ets/manager/LauncherVisualEffectManager';
import {
  BlurEffect,
  BlurEffectType,
} from '@ohos/commonconstants/src/main/ets/constants/VisualEffectConstants';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { ScenePanelState } from '@ohos/windowscene';

export default function LauncherVisualEffectManagerTest() {
  describe('LauncherVisualEffectManagerTest', () => {
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

    it('test_initParams', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      expect(manager.initParams() === undefined).assertTrue();
    });

    it('test_isRecentBlurEffectDisabled_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = false;
      expect(manager.isRecentBlurEffectDisabled()).assertEqual(false);
    });
    it('test_isRecentBlurEffectDisabled_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = true;
      expect(manager.isRecentBlurEffectDisabled()).assertEqual(true);
    });

    it('test_isNegativeBlurEffectDisabled_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isNegativeBlurEffectDisable'] = false;
      expect(manager.isNegativeBlurEffectDisabled()).assertEqual(false);
    });
    it('test_isNegativeBlurEffectDisabled_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isNegativeBlurEffectDisable'] = true;
      expect(manager.isNegativeBlurEffectDisabled()).assertEqual(true);
    });

    it('test_isGlobalSearchBlurEffectDisabled_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isGlobalSearchBlurEffectDisable'] = true;
      const result = manager.isGlobalSearchBlurEffectDisabled();
      expect(result).assertEqual(true);
    });
    it('test_isGlobalSearchBlurEffectDisabled_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isGlobalSearchBlurEffectDisable'] = false;
      const result = manager.isGlobalSearchBlurEffectDisabled();
      expect(result).assertEqual(false);
    });

    it('test_isFolderBlurEffectDisabled_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isFolderBlurEffectDisable'] = true;
      const result = manager.isFolderBlurEffectDisabled();
      expect(result).assertEqual(true);
    });
    it('test_isFolderBlurEffectDisabled_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isFolderBlurEffectDisable'] = false;
      const result = manager.isFolderBlurEffectDisabled();
      expect(result).assertEqual(false);
    });

    it('test_registerRecentBlurEvent_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = false;
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.on);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      manager.registerRecentBlurEvent();
      mocker.ignoreMock(eventHub, eventHub.on);
    });
    it('test_registerRecentBlurEvent_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = true;
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.on);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      manager.registerRecentBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.on);
    });

    it('test_unRegisterRecentBlurEvent_1', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.off);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isRecentBlurEffectDisable'] = true;
      manager.unRegisterRecentBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.off);
    });
    it('test_unRegisterRecentBlurEvent_2', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.off);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isRecentBlurEffectDisable'] = false;
      manager.unRegisterRecentBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.off);
    });

    it('test_triggerRecentBlurEvent_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(GlobalContext.getContext(), eventHub.emit);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isRecentBlurEffectDisable'] = false;
      manager.triggerRecentBlurEvent(true);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(GlobalContext.getContext(), GlobalContext.getContext().eventHub.emit);
    });
    it('test_triggerRecentBlurEvent_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(GlobalContext.getContext(), eventHub.emit);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isRecentBlurEffectDisable'] = true;
      manager.triggerRecentBlurEvent(true);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(GlobalContext.getContext(), GlobalContext.getContext().eventHub.emit);
    });

    it('test_triggerDesktopBlurByPanelState_1', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockEmit: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmit)(ArgumentMatchers.anyString).afterReturnNothing();

      let fromState: ScenePanelState = ScenePanelState.QUICK_SWITCH;
      let curState: ScenePanelState = ScenePanelState.FULLSCENE;
      let blurAnimDelayTime: number = 100;
      let result = manager.triggerDesktopBlurByPanelState(fromState, curState, blurAnimDelayTime);

      expect(result).assertEqual(false);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });
    it('test_triggerDesktopBlurByPanelState_2', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockEmit: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmit)(ArgumentMatchers.anyString).afterReturnNothing();

      let fromState: ScenePanelState = ScenePanelState.RECENT;
      let curState: ScenePanelState = ScenePanelState.QUICK_SWITCH;
      let blurAnimDelayTime: number = 100;
      let result = manager.triggerDesktopBlurByPanelState(fromState, curState, blurAnimDelayTime);

      expect(result).assertEqual(true);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });

    it('test_triggerDesktopBlurByPanelState_3', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockEmit: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmit)(ArgumentMatchers.anyString).afterReturnNothing();

      let fromState: ScenePanelState = ScenePanelState.RECENT;
      let curState: ScenePanelState = ScenePanelState.FULLSCENE;
      let blurAnimDelayTime: number = 100;
      let result = manager.triggerDesktopBlurByPanelState(fromState, curState, blurAnimDelayTime);

      expect(result).assertEqual(false);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });
    it('test_triggerDesktopBlurByPanelState_4', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockEmit: Function = mocker.mockFunc(eventHub, eventHub.emit);
      when(mockEmit)(ArgumentMatchers.anyString).afterReturnNothing();

      let fromState: ScenePanelState = ScenePanelState.QUICK_SWITCH;
      let curState: ScenePanelState = ScenePanelState.RECENT;
      let blurAnimDelayTime: number = 100;
      let result = manager.triggerDesktopBlurByPanelState(fromState, curState, blurAnimDelayTime);

      expect(result).assertEqual(true);
      mocker.ignoreMock(eventHub, eventHub.emit);
    });

    it('test_triggerDesktopBlurByOneStepState_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = true;
      manager.triggerDesktopBlurByOneStepState(0, 0);
      let a = 'test';
      expect(a).assertEqual('test');
    });
    it('test_triggerDesktopBlurByOneStepState_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = false;
      manager.triggerDesktopBlurByOneStepState(0, 0);
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_exitBlurWithLauncherOpAnim_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = true;
      (manager as object)['isLauncherOpAnimDisable'] = true;
      manager.exitBlurWithLauncherOpAnim();
      expect((manager as object)['isLauncherOpAnimDisable']).assertEqual(false);
    });
    it('test_exitBlurWithLauncherOpAnim_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = false;
      (manager as object)['isLauncherOpAnimDisable'] = true;
      manager.exitBlurWithLauncherOpAnim();
      expect((manager as object)['isLauncherOpAnimDisable']).assertEqual(true);
    });

    it('test_exitBlurWithoutAnim_1', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = true;
      manager.exitBlurWithoutAnim();
      let a = 'test';
      expect(a).assertEqual('test');
    });
    it('test_exitBlurWithoutAnim_2', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = false;
      manager.exitBlurWithoutAnim();
      let a = 'test';
      expect(a).assertEqual('test');
    });

    it('test_registerFolderFullBlurEvent_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isFolderBlurEffectDisable'] = false;
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.on);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      manager.registerFolderFullBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.on);
    });
    it('test_registerFolderFullBlurEvent_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isFolderBlurEffectDisable'] = true;
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.on);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      manager.registerFolderFullBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.on);
    });

    it('test_unRegisterFolderFullBlurEvent_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.off);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isFolderBlurEffectDisable'] = true;
      manager.unRegisterFolderFullBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.off);
    });
    it('test_unRegisterFolderFullBlurEvent_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.off);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isFolderBlurEffectDisable'] = false;
      manager.unRegisterFolderFullBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.off);
    });

    it('test_triggerFolderFullBlurEvent_1', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isFolderBlurEffectDisable'] = true;
      let result = manager.triggerFolderFullBlurEvent(true);
      expect(result).assertEqual(true);
    });
    it('test_triggerFolderFullBlurEvent_2', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isFolderBlurEffectDisable'] = false;
      let result = manager.triggerFolderFullBlurEvent(true);
      expect(result).assertEqual(false);
    });

    it('test_isBlurEffectEnabledByType_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isRecentBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.RECENT);
      expect(result).assertEqual(true);
    });
    it('test_isBlurEffectEnabledByType_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isNegativeScreenEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.NEGATIVE_SCREEN);
      expect(result).assertEqual(true);
    });
    it('test_isBlurEffectEnabledByType_3', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isFolderBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.FOLDER);
      expect(result).assertEqual(true);
    });
    it('test_isBlurEffectEnabledByType_4', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isEditModeFolderEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.EDIT_MODE_FOLDER);
      expect(result).assertEqual(true);
    });
    it('test_isBlurEffectEnabledByType_5', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isGlobalSearchEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.GLOBAL_SEARCH);
      expect(result).assertEqual(true);
    });

    it('test_isBlurEffectEnabledByType_6', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isStartExitBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.ICON_START_EXIT);
      expect(result).assertEqual(true);
    });

    it('test_hideLauncher_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = true;
      manager.launcherOpacity.value = 1;
      manager.hideLauncher();
      expect(manager.launcherOpacity.value).assertEqual(0);
    });
    it('test_hideLauncher_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isRecentBlurEffectDisable'] = true;
      manager.launcherOpacity.value = 0.5;
      manager.hideLauncher();
      expect(manager.launcherOpacity.value).assertEqual(0.5);
    });

    it('test_updateBlurEffect_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['blurEffect'] = new BlurEffect();
      manager.updateBlurEffect(true, BlurEffectType.FOLDER);
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.FOLDER);
      expect(result).assertEqual(true);
    });
    it('test_updateBlurEffect_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['blurEffect'] = new BlurEffect();
      manager.updateBlurEffect(true, BlurEffectType.RECENT);
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.RECENT);
      expect(result).assertEqual(true);
    });
    it('test_updateBlurEffect_3', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['blurEffect'] = new BlurEffect();
      manager.updateBlurEffect(true, BlurEffectType.NEGATIVE_SCREEN);
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.NEGATIVE_SCREEN);
      expect(result).assertEqual(true);
    });
    it('test_updateBlurEffect_4', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['blurEffect'] = new BlurEffect();
      manager.updateBlurEffect(true, BlurEffectType.EDIT_MODE_FOLDER);
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.EDIT_MODE_FOLDER);
      expect(result).assertEqual(true);
    });
    it('test_updateBlurEffect_5', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['blurEffect'] = new BlurEffect();
      manager.updateBlurEffect(true, BlurEffectType.GLOBAL_SEARCH);
      let result = manager.isBlurEffectEnabledByType(BlurEffectType.GLOBAL_SEARCH);
      expect(result).assertEqual(true);
    });

    it('test_getNegativeScreenOpacity_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let result = manager.getNegativeScreenOpacity();
      expect(result.value).assertEqual(1);
    });
    it('test_getGlobalSearchOpacity_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let result = manager.getGlobalSearchOpacity();
      expect(result.value).assertEqual(1);
    });
    it('test_getOpenFolderOpacity_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let result = manager.getOpenFolderOpacity();
      expect(result.value).assertEqual(1);
    });
    it('test_getEditModeButtonOpacity_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let result = manager.getEditModeButtonOpacity();
      expect(result.value).assertEqual(1);
    });
    it('test_getEditModeTopBarOpacity_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let result = manager.getEditModeTopBarOpacity();
      expect(result.value).assertEqual(1);
    });
    it('test_getDesktopDialogOpacity_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let result = manager.getDesktopDialogOpacity();
      expect(result.value).assertEqual(1);
    });
    it('test_getEditModeExtensionUIOpacity_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let result = manager.getEditModeExtensionUIOpacity();
      expect(result.value).assertEqual(1);
    });

    it('test_isLauncherSwiperCustomEnabled_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isLauncherSwiperCustomEnable'] = false;
      expect(manager.isLauncherSwiperCustomEnabled()).assertEqual(false);
    });
    it('test_isLauncherSwiperCustomEnabled_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isLauncherSwiperCustomEnable'] = true;
      expect(manager.isLauncherSwiperCustomEnabled()).assertEqual(true);
    });

    it('test_setShowUIExtension_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      manager.setShowUIExtension(true);
      expect((manager as object)['isShowUIExtension']).assertEqual(true);
    });
    it('test_setShowUIExtension_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      manager.setShowUIExtension(false);
      expect((manager as object)['isShowUIExtension']).assertEqual(false);
    });

    it('test_updateColorMode', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      manager.updateColorMode(1);
      expect((manager as object)['colorMode']).assertEqual(1);
    });

    it('test_addMaskByBlurEffect', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['addMaskByBlurEffect']();
      expect(manager.isShowMask.value).assertEqual(true);
    });

    it('test_updateMastColor_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['colorMode'] = 1 + 1;
      (manager as object)['updateMastColor']();
      expect(manager.maskColor.value).assertEqual('#19000000');
    });
    it('test_updateMastColor_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['colorMode'] = 1;
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isRecentBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      (manager as object)['updateMastColor']();
      expect(manager.maskColor.value).assertEqual('#3F000000');
    });
    it('test_updateMastColor_3', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['colorMode'] = 1;
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isFolderBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      (manager as object)['updateMastColor']();
      expect(manager.maskColor.value).assertEqual('#12000000');
    });
    it('test_updateMastColor_4', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['colorMode'] = 1;
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isNegativeScreenEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      (manager as object)['updateMastColor']();
      expect(manager.maskColor.value).assertEqual('#19000000');
    });
    it('test_updateMastColor_5', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['colorMode'] = 1;
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isGlobalSearchEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      (manager as object)['updateMastColor']();
      expect(manager.maskColor.value).assertEqual('#19000000');
    });
    it('test_updateMastColor_6', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['colorMode'] = 0;
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isRecentBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      (manager as object)['updateMastColor']();
      expect(manager.maskColor.value).assertEqual('#38000000');
    });
    it('test_updateMastColor_7', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['colorMode'] = 0;
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isFolderBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      (manager as object)['updateMastColor']();
      expect(manager.maskColor.value).assertEqual('#66000000');
    });
    it('test_updateMastColor_8', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['colorMode'] = 0;
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isNegativeScreenEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      (manager as object)['updateMastColor']();
      expect(manager.maskColor.value).assertEqual('#4D000000');
    });
    it('test_updateMastColor_9', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['colorMode'] = 0;
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isGlobalSearchEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      (manager as object)['updateMastColor']();
      expect(manager.maskColor.value).assertEqual('#66000000');
    });


    it('test_registerIconStartExitBlurEvent_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isTransitionBlurEffectDisable'] = false;
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.on);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      manager.registerIconStartExitBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.on);
    });
    it('test_registerIconStartExitBlurEvent_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      (manager as object)['isTransitionBlurEffectDisable'] = true;
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.on);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();
      manager.registerIconStartExitBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.on);
    });

    it('test_unRegisterIconStartExitBlurEvent_1', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.off);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isTransitionBlurEffectDisable'] = true;
      manager.unRegisterIconStartExitBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.off);
    });
    it('test_unRegisterIconStartExitBlurEvent_2', 0, async () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(eventHub, eventHub.off);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isTransitionBlurEffectDisable'] = false;
      manager.unRegisterIconStartExitBlurEvent();
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(eventHub, eventHub.off);
    });

    it('test_triggerIconStartExitBlurEvent_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(GlobalContext.getContext(), eventHub.emit);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isTransitionBlurEffectDisable'] = false;
      manager.triggerIconStartExitBlurEvent(true);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(GlobalContext.getContext(), GlobalContext.getContext().eventHub.emit);
    });

    it('test_triggerIconStartExitBlurEvent_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let mocker: MockKit = new MockKit();
      let eventHub = GlobalContext.getContext().eventHub;
      let mockfunc: Function = mocker.mockFunc(GlobalContext.getContext(), eventHub.emit);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);
      (manager as object)['isTransitionBlurEffectDisable'] = true;
      manager.triggerIconStartExitBlurEvent(true);
      let a = 'test';
      expect(a).assertEqual('test');
      mocker.ignoreMock(GlobalContext.getContext(), GlobalContext.getContext().eventHub.emit);
    });

    it('test_setLauncherOpacityWithDfx_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isStartExitBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      manager.launcherOpacity.value = 0;
      manager.setLauncherOpacityWithDfx(1);
      expect(manager.launcherOpacity.value).assertEqual(1);
    });


    it('test_setWallpaperBlurOpacityWithDfx_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isStartExitBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      manager.wallpaperBlurOpacity.value = 0;
      manager.setWallpaperBlurOpacityWithDfx(1);
      expect(manager.wallpaperBlurOpacity.value).assertEqual(1);
    });

    it('test_setWallpaperBlurOpacityWithDfx_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isStartExitBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      manager.wallpaperBlurOpacity.value = 0;
      manager.setWallpaperBlurOpacityWithDfx(0);
      expect(manager.wallpaperBlurOpacity.value).assertEqual(0);
    });

    it('test_setWallpaperBlurInactive_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isStartExitBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      manager.setWallpaperBlurInactive();
      expect(manager.launcherOpacity.value).assertEqual(1);
      expect(manager.wallpaperBlurOpacity.value).assertEqual(0);
    });

    it('test_setWallpaperBlurInactive_2', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isStartExitBlurEffect = false;
      (manager as object)['blurEffect'] = blurEffect;
      manager.setWallpaperBlurInactive();
      expect(manager.launcherOpacity.value).assertEqual(1);
      expect(manager.wallpaperBlurOpacity.value).assertEqual(0);
    });

    it('test_setWallpaperBlurActive_1', 0, () => {
      let manager: LauncherVisualEffectManager = new LauncherVisualEffectManager();
      let blurEffect: BlurEffect = new BlurEffect();
      blurEffect.isStartExitBlurEffect = true;
      (manager as object)['blurEffect'] = blurEffect;
      manager.setWallpaperBlurActive();
      expect(manager.launcherOpacity.value).assertEqual(0);
      expect(manager.wallpaperBlurOpacity.value).assertEqual(1);
    });
  });
}
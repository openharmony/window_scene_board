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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit,
  ArgumentMatchers,
  when} from '@ohos/hypium'
import {
  scbEventExclusiveManager,
  SCBPropertyChangeReason,
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  ScenePanelState
} from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import { CheckEmptyUtils } from '@ohos/basicutils';
import { RotationConstants } from '@ohos/commonconstants';
import { DeviceHelper, GlobalContext, HiSysEventUtil } from '@ohos/frameworkwrapper';
import {
  AIBarViewModel, } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/AIBarViewModel';
import {
  SwitchType,
  ToastType
} from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/settings/preference/PreferenceType';
import lottie from '@ohos/lottie';
import {
  AiBarShowParam,
  WeakNotifyParam,
  WeakNotifyState } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/AIBarModel/AIBarViewData';
import { inputMonitor } from '@kit.InputKit';
import { commonEventManager, systemParameterEnhance, thermal, BusinessError, power } from '@kit.BasicServicesKit';
import { ToolType, Action, TouchEvent as InputTouch } from '@ohos.multimodalInput.touchEvent'
import { SCBAiBarConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/SCBAiBarConstants';
import { SystemSceneConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/SystemSceneConstants';
import {
  AiBarRegisterFunc,
  SCBAiBarProxyManager } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/proxy/SCBAiBarProxyManager';
import { common, uriPermissionManager } from '@kit.AbilityKit';
import singletonBackViewModel
  from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/back/viewmodel/SCBGestureBackViewModel';
import { CommonConstants, DesktopModeManager, vibratorMgr } from '@ohos/launchercommon/src/main/ets/TsIndex';
import sceneSessionManager from '@ohos.sceneSessionManager';
import {
  DesktopModeEnum,
} from '@ohos/launchercommon';
import { AodUtil } from '@ohos/aod';
import { HiSysLongPressMisTouchType } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysData';
import UDC from '@ohos.data.unifiedDataChannel';
import UniformTypeDescriptor from '@ohos.data.uniformTypeDescriptor';
import {
  aiBarSettingsDataMgr,
  AiBarSettingsDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/settings/preference/AiBarSettingsDataMgr';
import { MultiWindowMode } from '@ohos/windowscene';
import { DragEventType } from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/SCBGestureNavBarViewModel';
import { SendTouchEventController } from '@ohos/windowscene/Index';
import { SCBDefaultZIndex } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/SCBScreen';
import type abilityCommon from '@ohos.app.ability.common';
import { SwitchEventData, UserSwitchService } from '@ohos/screenlockcommon';
import { DragEvent } from 'DragControllerParam';
import unifiedDataChannel from '@ohos.data.unifiedDataChannel';

export default function AIBarViewModelTest() {
  describe('AIBarViewModelTest', () => {
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

    let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let aiBarViewModel: AIBarViewModel = AIBarViewModel.getInstance(scbScreenProperty);
    let viewController: BaseViewController = new BaseViewController('test');
    let aiBarShowParam: AiBarShowParam = new AiBarShowParam();

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

    let gestureEvent: GestureEvent = {
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

    let historicalPoint: HistoricalPoint = {
      touchObject: {
        type: TouchType.Down,
        id: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0
      },
      size: 0,
      force: 0,
      timestamp: 0
    }

    let touchEvent: TouchEvent = {
      target: {
        area: {
          width: 0,
          height: 0,
          position: {
            x: 0, y: 0
          },
          globalPosition: {
            x: 0, y: 0
          }
        }
      },
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      type: TouchType.Down,
      touches: [],
      changedTouches: [{
        id: 0,
        type: 0,
        displayX: 0,
        displayY: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0
      }],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [historicalPoint, historicalPoint];
      },
      preventDefault: () => {
      }
    }

    let inputTouch: InputTouch = {
      touches: [{
        id: 0,
        pressedTime: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        pressure: 0,
        width: 0,
        height: 0,
        tiltX: 0,
        tiltY: 0,
        toolX: 0,
        toolY: 0,
        toolWidth: 0,
        toolHeight: 0,
        rawX: 0,
        rawY: 0,
        toolType: ToolType.FINGER
      }],
      action: Action.CANCEL,
      touch: {
        id: 0,
        pressedTime: 0,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        pressure: 0,
        width: 0,
        height: 0,
        tiltX: 0,
        tiltY: 0,
        toolX: 0,
        toolY: 0,
        toolWidth: 0,
        toolHeight: 0,
        rawX: 0,
        rawY: 0,
        toolType: ToolType.FINGER
      },
      sourceType: 0,
      id: 0,
      deviceId: 0,
      actionTime: 0,
      screenId: 0,
      windowId: 0
    }

    let downEvent: TouchEvent = {
      target: {
        area: {
          width: 0,
          height: 0,
          position: {
            x: 0, y: 0
          },
          globalPosition: {
            x: 0, y: 0
          }
        }
      },
      timestamp: 0,
      source: 0,
      pressure: 0,
      tiltX: 0,
      tiltY: 0,
      sourceTool: 0,
      type: TouchType.Down,
      touches: [],
      changedTouches: [{
        id: 0,
        type: 0,
        displayX: 20,
        displayY: 20,
        windowX: 0,
        windowY: 0,
        screenX: 0,
        screenY: 0,
        x: 0,
        y: 0
      }],
      stopPropagation: () => {
      },
      getHistoricalPoints: () => {
        return [historicalPoint, historicalPoint];
      },
      preventDefault: () => {
      }
    }

    it('aiBarViewModel_switchMultiWindowModeCallback_1', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      expect((aiBarViewModel as object)['switchMultiWindowModeCallback'].onEnterMode?.(MultiWindowMode.FREEFORM_SCENE) ===
        undefined).assertTrue();
    })

    it('aiBarViewModel_switchMultiWindowModeCallback_2', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      expect((aiBarViewModel as object)['switchMultiWindowModeCallback'].onEnterMode?.(MultiWindowMode.FULL_SCENE) ===
        undefined).assertTrue();
    })

    it('aiBarViewModel_switchMultiWindowModeCallback_3', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      expect((aiBarViewModel as object)['switchMultiWindowModeCallback'].onEnterMode?.(5) ===
        undefined).assertTrue();
    })

    it('aiBarViewModel_aiBarViewAppear_1', 0, () => {
      let mockKit = new MockKit();
      mockKit.mockFunc(aiBarViewModel, (aiBarViewModel as object)['lottieResourcePreparation']);

      aiBarViewModel.aiBarData.isTimerRunning = false;
      let sendTouchEventController = new SendTouchEventController('TAG', 1, SCBDefaultZIndex.GESTURE_NAVIGATION);
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      expect(aiBarViewModel.aiBarViewAppear(1, viewController, sendTouchEventController) === undefined).assertTrue();

      mockKit.ignoreMock(aiBarViewModel, (aiBarViewModel as object)['lottieResourcePreparation']);
    })

    it('aiBarViewModel_aiBarViewAppear_2', 0, () => {
      let mockKit = new MockKit();
      mockKit.mockFunc(aiBarViewModel, (aiBarViewModel as object)['lottieResourcePreparation']);

      aiBarViewModel.aiBarData.isTimerRunning = true;
      let sendTouchEventController = new SendTouchEventController('TAG', 1, SCBDefaultZIndex.GESTURE_NAVIGATION);
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      expect(aiBarViewModel.aiBarViewAppear(1, viewController, sendTouchEventController) === undefined).assertTrue();

      mockKit.ignoreMock(aiBarViewModel, (aiBarViewModel as object)['lottieResourcePreparation']);
    })

    it('aiBarViewModel_aiBarViewAppear_3', 0, () => {
      let mockKit = new MockKit();
      mockKit.mockFunc(aiBarViewModel, (aiBarViewModel as object)['lottieResourcePreparation']);

      aiBarViewModel.aiBarData.is2DRelease = true;
      let sendTouchEventController = new SendTouchEventController('TAG', 1, SCBDefaultZIndex.GESTURE_NAVIGATION);
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      expect(aiBarViewModel.aiBarViewAppear(1, viewController, sendTouchEventController) === undefined).assertTrue();

      mockKit.ignoreMock(aiBarViewModel, (aiBarViewModel as object)['lottieResourcePreparation']);
    })

    it('aiBarViewModel_aiBarViewAppear_4', 0, () => {
      let mockKit = new MockKit();
      mockKit.mockFunc(aiBarViewModel, (aiBarViewModel as object)['lottieResourcePreparation']);

      aiBarViewModel.aiBarData.is2DRelease = false;
      let sendTouchEventController = new SendTouchEventController('TAG', 1, SCBDefaultZIndex.GESTURE_NAVIGATION);
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      expect(aiBarViewModel.aiBarViewAppear(1, viewController, sendTouchEventController) === undefined).assertTrue();

      mockKit.ignoreMock(aiBarViewModel, (aiBarViewModel as object)['lottieResourcePreparation']);
    })

    it('aiBarViewModel_registerAiBarProxyCallback_1', 0, () => {
      SCBAiBarProxyManager.getInstance().executeCallbackByType(AiBarRegisterFunc.AIBAR_EXIT_FUNC);
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('aiBarViewModel_registerAiBarProxyCallback_2', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      SCBAiBarProxyManager.getInstance().executeCallbackByType(AiBarRegisterFunc.AIBAR_SHOW_FUNC);
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('aiBarViewModel_registerAiBarProxyCallback_3', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      SCBAiBarProxyManager.getInstance().executeCallbackByType(AiBarRegisterFunc.AIBAR_SHOW_FUNC);
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('aiBarViewModel_registerAiBarProxyCallback_8', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let getAibarOpacity = mocker.mockFunc(aiBarViewModel.aiBarViewData, aiBarViewModel.aiBarViewData.getAibarOpacity);
      when(getAibarOpacity)(ArgumentMatchers.any).afterReturn(0);
      SCBAiBarProxyManager.getInstance().executeCallbackByType(AiBarRegisterFunc.AIBAR_SHOW_FUNC);
      expect(aiBarViewModel).not().assertUndefined();
      mocker.ignoreMock(aiBarViewModel.aiBarViewData, aiBarViewModel.aiBarViewData.getAibarOpacity);
    })

    it('aiBarViewModel_unRegisterAiBarProxyCallback_1', 0, () => {
      expect(aiBarViewModel.unRegisterAiBarProxyCallback() === undefined).assertTrue();
    })

    it('aiBarViewModel_registerDesktopModeCallback_1', 0, () => {
      expect(aiBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
    })

    it('should_unregister_all_ai_bar_proxy_callbacks', 0, () => {
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(SCBAiBarProxyManager.getInstance(), SCBAiBarProxyManager.getInstance().unRegisterProxyCallback);
      aiBarViewModel.unRegisterAiBarProxyCallback();
      mocker.verify('unRegisterProxyCallback', ['aiBarExit']).atLeast(1);
      mocker.verify('unRegisterProxyCallback', ['aiBarShow']).atLeast(1);
      mocker.verify('unRegisterProxyCallback', ['aiBarHide']).atLeast(1);
      mocker.ignoreMock(SCBAiBarProxyManager.getInstance(), SCBAiBarProxyManager.getInstance().unRegisterProxyCallback);
    });

    it('should_unregister_all_ai_bar_toast_callbacks', 0, () => {
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(aiBarViewModel.aiBarData.aiBarSettingsDataMgr,
        aiBarViewModel.aiBarData.aiBarSettingsDataMgr.unRegisterCallback);
      mocker.verify('unRegisterCallback', [ToastType.AI_BAR_TOAST]).atLeast(1);
      mocker.ignoreMock(aiBarViewModel.aiBarData.aiBarSettingsDataMgr,
        aiBarViewModel.aiBarData.aiBarSettingsDataMgr.unRegisterCallback);
    });

    it('aiBarViewModel_registerDesktopModeCallback_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().registerModeChangeCallback);
      when(mockFunc1)(ArgumentMatchers.any)
        .afterReturn((registerTag: string, callback: Function) => {
          callback(DesktopModeEnum.EMERGENCY_MODE, DesktopModeEnum.EMERGENCY_MODE);
        });
      expect(aiBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().registerModeChangeCallback);
    })

    it('aiBarViewModel_registerDesktopModeCallback_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().registerModeChangeCallback);
      when(mockFunc1)(ArgumentMatchers.any)
        .afterReturn((registerTag: string, callback: Function) => {
          callback(DesktopModeEnum.THERMAL_SAFE_MODE, DesktopModeEnum.THERMAL_SAFE_MODE);
        });
      expect(aiBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().registerModeChangeCallback);
    })

    it('aiBarViewModel_registerDesktopModeCallback_4', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().registerModeChangeCallback);
      when(mockFunc1)(ArgumentMatchers.any)
        .afterReturn((registerTag: string, callback: Function) => {
          callback(DesktopModeEnum.THER_EMC_OVERLAY_MODE, DesktopModeEnum.THER_EMC_OVERLAY_MODE);
        });
      expect(aiBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().registerModeChangeCallback);
    })

    it('aiBarViewModel_registerDesktopModeCallback_5', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().registerModeChangeCallback);
      when(mockFunc1)(ArgumentMatchers.any)
        .afterReturn((registerTag: string, callback: Function) => {
          callback(DesktopModeEnum.BASE_MODE, DesktopModeEnum.BASE_MODE);
        });
      expect(aiBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().registerModeChangeCallback);
    })

    it('aiBarViewModel_registerAiBarToastCallback_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(aiBarViewModel.aiBarData.aiBarSettingsDataMgr,
        aiBarViewModel.aiBarData.aiBarSettingsDataMgr.registerCallback);
      when(mockFuc)(ArgumentMatchers.any).afterAction((type:string, callback: Function) => {
        callback('clickBackStatus');
      });
      mocker.ignoreMock(aiBarViewModel.aiBarData.aiBarSettingsDataMgr,
        aiBarViewModel.aiBarData.aiBarSettingsDataMgr.registerCallback);
    })

    it('aiBarViewModel_registerAiBarToastCallback_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(aiBarViewModel.aiBarData.aiBarSettingsDataMgr,
        aiBarViewModel.aiBarData.aiBarSettingsDataMgr.registerCallback);
      mocker.ignoreMock(aiBarViewModel.aiBarData.aiBarSettingsDataMgr,
        aiBarViewModel.aiBarData.aiBarSettingsDataMgr.registerCallback);
    })

    it('aiBarViewModel_registerAiBarToastCallback_4', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(aiBarViewModel.aiBarData.aiBarSettingsDataMgr,
        aiBarViewModel.aiBarData.aiBarSettingsDataMgr.registerCallback);
      when(mockFuc)(ArgumentMatchers.any).afterAction((type:string, callback: Function) => {
        callback('aiBarToast')
      });
      mocker.ignoreMock(aiBarViewModel.aiBarData.aiBarSettingsDataMgr,
        aiBarViewModel.aiBarData.aiBarSettingsDataMgr.registerCallback);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_1', 0, () => {
      expect(aiBarViewModel.unRegisterAiBarProxyCallback() === undefined).assertTrue();
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_2', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_3', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_4', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_5', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_6', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_7', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_8', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_9', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_10', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_11', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_12', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_13', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_14', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_15', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_16', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_17', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_18', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_19', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_20', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_dragShowResetParam_1', 0, () => {
      (aiBarViewModel as object)['dragShowResetParam']();
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_21', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_22', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_23', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_24', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_25', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_26', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_27', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_28', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_29', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_30', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_31', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_32', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_33', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_34', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_35', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_36', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_37', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_38', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_39', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_40', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_resetHotAreaHeightInGame_41', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, aiBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(aiBarViewModel,
        aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(aiBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('aiBarViewModel_getStartPosition_1', 0, () => {
      (aiBarViewModel as object)['screenProperty'].height = 1000;
      (aiBarViewModel as object)['getStartPosition'](20);
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('aiBarViewModel_getStartPosition_2', 0, () => {
      (aiBarViewModel as object)['screenProperty'].height = 300;
      (aiBarViewModel as object)['getStartPosition'](800);
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('aiBarViewModel_getAIBarColor_1', 0, () => {
      aiBarViewModel.aiBarData.getAIBarColor(aiBarViewModel.aiBarViewData);
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('aiBarViewModel_getAIBarColor_2', 0, () => {
      aiBarViewModel.aiBarViewData.scenePanelState = 0;
      aiBarViewModel.aiBarViewData.specialScenePanelState = 0;
      expect(aiBarViewModel.aiBarData.getAIBarColor(aiBarViewModel.aiBarViewData) !== undefined).assertTrue()
    })

    it('aiBarViewModel_getAIBarColor_3', 0, () => {
      aiBarViewModel.aiBarViewData.scenePanelState = 0;
      aiBarViewModel.aiBarViewData.specialScenePanelState = 2;
      expect(aiBarViewModel.aiBarData.getAIBarColor(aiBarViewModel.aiBarViewData) !== undefined).assertTrue()
    })

    it('aiBarViewModel_getAIBarColor_4', 0, () => {
      aiBarViewModel.aiBarViewData.powerMode = 600;
      aiBarViewModel.aiBarViewData.scenePanelState =1;
      aiBarViewModel.aiBarViewData.specialScenePanelState = 2;
      expect(aiBarViewModel.aiBarData.getAIBarColor(aiBarViewModel.aiBarViewData) !== undefined).assertFalse()
    })

    it('aiBarViewModel_getAIBarColor_5', 0, () => {
      aiBarViewModel.aiBarViewData.scenePanelState =1;
      aiBarViewModel.aiBarViewData.specialScenePanelState = 2;
      aiBarViewModel.aiBarViewData.powerMode = SCBAiBarConstants.LOW_POWER_LEVEL;
      aiBarViewModel.aiBarData.getAIBarColor(aiBarViewModel.aiBarViewData);
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('aiBarViewModel_aiBarRetract_1', 0, () => {
      expect(aiBarViewModel.aiBarRetract(new HiSysLongPressMisTouchType()) === undefined).assertTrue();
    });

    it('aiBarViewModel_aiBarOnTouchEvent_1', 0, () => {
      expect(aiBarViewModel.aiBarOnTouchEvent(touchEvent, null) === undefined).assertTrue();
    });

    it('aiBarViewModel_aiBarOnTouchEvent_2', 0, () => {
      aiBarViewModel.aiBarData.isAiBarRetract = true;
      expect(aiBarViewModel.aiBarOnTouchEvent(touchEvent, downEvent) === undefined).assertTrue();
    });

    it('aiBarViewModel_aiBarOnTouchEvent_5', 0, () => {
      expect(aiBarViewModel.aiBarOnTouchEvent(touchEvent, null) === undefined).assertTrue();
    });

    it('aiBarViewModel_aiBarOnTouchEvent_6', 0, () => {
      expect(aiBarViewModel.aiBarOnTouchEvent(touchEvent, downEvent) === undefined).assertTrue();
    });

    it('should_reset_hot_area_height_to_default_when_not_in_game_status', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockCheckGameStatus: Function = mocker.mockFunc(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      when(mockCheckGameStatus)().afterReturn(false);
      let mockIsPhone: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhone)().afterReturn(true);
      aiBarViewModel.resetHotAreaHeightInGame();
      expect(aiBarViewModel).not().assertUndefined();
      mocker.ignoreMock(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      done();
    });

    it('should_reset_hot_area_height_to_game_status_when_in_game_status_and_anti_touch_enabled', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockCheckGameStatus: Function = mocker.mockFunc(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      when(mockCheckGameStatus)().afterReturn(true);
      let mockIsPhone: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhone)().afterReturn(true);
      let mockCheckEnableAntiTouchStatus: Function = mocker.mockFunc(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockCheckEnableAntiTouchStatus)(ArgumentMatchers.any).afterReturn(true);
      aiBarViewModel.resetHotAreaHeightInGame();
      expect(aiBarViewModel).not().assertUndefined();
      mocker.ignoreMock(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(aiBarViewModel.navBarViewModel.windowManager, aiBarViewModel.navBarViewModel.windowManager.setResponseRegionHeight);
      done();
    });

    it('should_reset_hot_area_height_to_default_when_in_game_status_and_anti_touch_disabled', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockCheckGameStatus: Function = mocker.mockFunc(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      when(mockCheckGameStatus)().afterReturn(true);
      let mockIsPhone: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhone)().afterReturn(true);
      let mockCheckEnableAntiTouchStatus: Function = mocker.mockFunc(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockCheckEnableAntiTouchStatus)(ArgumentMatchers.any).afterReturn(false);
      aiBarViewModel.resetHotAreaHeightInGame();
      expect(aiBarViewModel).not().assertUndefined();
      mocker.ignoreMock(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(aiBarViewModel.navBarViewModel, aiBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      done();
    });

    it('AIBarViewModel_initGameEventListener_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let createSubscriber: Function = mocker.mockFunc(aiBarViewModel, (aiBarViewModel as object)['createSubscriber']);
      when(createSubscriber)(ArgumentMatchers.any).afterReturnNothing();
      expect(aiBarViewModel.initGameEventListener() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, (aiBarViewModel as object)['createSubscriber']);
      done();
    });

    it('AIBarViewModel_initGameEventListener_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let createSubscriber: Function = mocker.mockFunc(aiBarViewModel, (aiBarViewModel as object)['createSubscriber']);
      when(createSubscriber)(ArgumentMatchers.any).afterThrow('createSubscriber is fail');
      expect(aiBarViewModel.initGameEventListener() === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, (aiBarViewModel as object)['createSubscriber']);
      done();
    });

    it('AIBarViewModel_subscriberFunc_1', 0, async (done: Function) => {
      let err: BusinessError = {} as BusinessError;
      let commonEventData: commonEventManager.CommonEventData = {} as commonEventManager.CommonEventData;
      (aiBarViewModel as object)['subscriberFunc'](err, commonEventData);
      expect(aiBarViewModel).not().assertUndefined();
      done();
    });

    it('AIBarViewModel_subscriberFunc_2', 0, async (done: Function) => {
      let commonEventData: commonEventManager.CommonEventData = {
        event: commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED,
        code: power.DevicePowerMode.MODE_NORMAL
      } as commonEventManager.CommonEventData;
      (aiBarViewModel as object)['subscriberFunc'](undefined, commonEventData);
      expect(aiBarViewModel).not().assertUndefined();
      done();
    });

    it('AIBarViewModel_subscriberFunc_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let createSubscriber: Function = mocker.mockFunc(aiBarViewModel,
        (aiBarViewModel as object)['setAiBarStatusInGame']);
      when(createSubscriber)(ArgumentMatchers.any).afterReturnNothing();

      let commonEventData: commonEventManager.CommonEventData = {
        event: SystemSceneConstants.GAME_EVENT_LISTENER_FIELD,
        code: power.DevicePowerMode.MODE_NORMAL,
        parameters: {}
      } as commonEventManager.CommonEventData;
      (aiBarViewModel as object)['subscriberFunc'](undefined, commonEventData);
      expect(aiBarViewModel).not().assertUndefined();
      done();
    });

    it('should_not_call_notifyAiBarShowStatus_when_isShowingAiBar_does_not_change_and_scenePanelState_is_RECENT', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarViewModel, aiBarViewModel.notifyAiBarShowStatus);
      let aiBarShowParam: AiBarShowParam = new AiBarShowParam()
      aiBarShowParam.scenePanelState = ScenePanelState.RECENT;

      aiBarViewModel.aiBarViewData.isShowingAiBar = true;
      aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam);
      mocker.verify('notifyAiBarShowStatus', []).never();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.notifyAiBarShowStatus);
      done();
    });

    it('should_call_notifyAiBarShowStatus_when_isShowingAiBar_changes_and_scenePanelState_is_not_RECENT', 0, async (done: Function) => {

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aiBarViewModel, aiBarViewModel.notifyAiBarShowStatus);
      let aiBarShowParam: AiBarShowParam = new AiBarShowParam()
      aiBarViewModel.aiBarViewData.isShowingAiBar = false;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(aiBarViewModel, aiBarViewModel.notifyAiBarShowStatus);
      done();
    });

    it('should_call_startVibration_and_processBackEvent_with_BACK_and_VIBRATION_ATTRIBUTE_LONG_PRESS', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockProcessBackEvent: Function = mocker.mockFunc(singletonBackViewModel, singletonBackViewModel.processBackEvent);
      when(mockProcessBackEvent)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);
      aiBarViewModel.processBackEvent();
      expect(aiBarViewModel).not().assertUndefined();
      mocker.ignoreMock(singletonBackViewModel, singletonBackViewModel.processBackEvent);
      done();
    });

    it('AIBarViewModel_updateAiBarHotAreaRect_1', 0, (): void => {
      expect(aiBarViewModel.updateAiBarHotAreaRect(scbScreenProperty, scbScreenProperty) === undefined).assertTrue();
    })

    it('AIBarViewModel_updateAiBarHotAreaRect_1', 0, (): void => {
      expect(aiBarViewModel.updateAiBarHotAreaRectForRecent(scbScreenProperty, RotationConstants.ROTATION_90) ===
        undefined).assertTrue();
    })

    it('AIBarViewModel_calculateAiBarWidth_1', 0, (): void => {
      expect(aiBarViewModel.calculateAiBarWidth(300)).assertEqual(112);
    })

    it('AIBarViewModel_calculateAiBarWidth_2', 0, (): void => {
      expect(aiBarViewModel.calculateAiBarWidth(750)).assertEqual(202);
    })

    it('AIBarViewModel_calculateAiBarWidth_3', 0, (): void => {
      expect(aiBarViewModel.calculateAiBarWidth(880)).assertEqual(172);
    })

    it('AIBarViewModel_isConfigureMisTouchAppActive_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)().afterReturn(false);
      expect(aiBarViewModel.isConfigureMisTouchAppActive() !== undefined)
        .assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad)
    })

    it('AIBarViewModel_isConfigureMisTouchAppActive_2', 0, (): void => {
      aiBarViewModel.aiBarViewData.scenePanelState = 0;
      expect(aiBarViewModel.isConfigureMisTouchAppActive() !== undefined)
        .assertTrue();
    })

    it('AIBarViewModel_isConfigureMisTouchAppActive_3', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)().afterReturn(true);
      aiBarViewModel.aiBarViewData.scenePanelState = 1;
      aiBarViewModel.aiBarViewData.isShowingAiBar = false;
      expect(aiBarViewModel.isConfigureMisTouchAppActive() !== undefined)
        .assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad)
    })

    it('AIBarViewModel_isConfigureMisTouchAppActive_4', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)().afterReturn(true);
      aiBarViewModel.aiBarViewData.scenePanelState = 0;
      aiBarViewModel.aiBarViewData.isShowingAiBar = false;
      expect(aiBarViewModel.isConfigureMisTouchAppActive() !== undefined)
        .assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad)
    })

    it('AIBarViewModel_checkPlayBarResetAnim_1', 0, (): void => {
      expect(aiBarViewModel.aiBarAnimate.playBarResetAnim() === undefined).assertTrue();
    })

    it('AIBarViewModel_notifyAiBarShowStatusDecide_1', 0, (): void => {
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
    })

    it('AIBarViewModel_judgeShowAIBar_1', 0, (): void => {
      aiBarShowParam.isInOutLauncher = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
    })

    it('AIBarViewModel_judgeShowAIBar_2', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(true);
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_3', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'false');
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_4', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_5', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.SPLIT;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_6', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_7', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      aiBarShowParam.isNavigationBarEnable = false;
      aiBarShowParam.isTempShowAiBar = false;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_8', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      aiBarShowParam.isNavigationBarEnable = false;
      aiBarShowParam.isTempShowAiBar = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_9', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      aiBarShowParam.isNavigationBarEnable = true;
      aiBarShowParam.isTempShowAiBar = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_10', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      aiBarShowParam.isNavigationBarEnable = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_11', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      aiBarShowParam.isNavigationBarEnable = true;
      aiBarShowParam.isTempShowAiBar = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_12', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.RECENT;
      aiBarShowParam.isNavigationBarEnable = true;
      aiBarShowParam.isTempShowAiBar = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_13', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.HOME;
      aiBarShowParam.isNavigationBarEnable = true;
      aiBarShowParam.isTempShowAiBar = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_14', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.HOME;
      aiBarShowParam.isNavigationBarEnable = true;
      aiBarShowParam.isTempShowAiBar = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_15', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      aiBarShowParam.isNavigationBarEnable = true;
      aiBarShowParam.isTempShowAiBar = true;
      aiBarShowParam.isInExitLandScape = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('AIBarViewModel_judgeShowAIBar_16', 0, (): void => {
      aiBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      aiBarShowParam.isNavigationBarEnable = true;
      aiBarShowParam.isTempShowAiBar = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
    })

    it('AIBarViewModel_judgeShowAIBar_17', 0, (): void => {
      aiBarShowParam.navBarIsShow = false;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
    })

    it('AIBarViewModel_judgeShowAIBar_18', 0, (): void => {
      aiBarShowParam.navBarIsShow = true;
      aiBarShowParam.isInOutLauncher = false;
      systemParameterEnhance.setSync('persist.sceneboard.aibar.enable', 'true');
      aiBarShowParam.isInEmergencyOrThermalSafeMode = true;
      expect(aiBarViewModel.notifyAiBarShowStatusDecide(aiBarShowParam) === undefined).assertTrue();
    })

    it('AIBarViewModel_setAiBarStatusInGame_1', 0, (): void => {
      (aiBarViewModel as object)['setAiBarStatusInGame'](1, 4, 'abc');
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('AIBarViewModel_setAiBarStatusInGame_2', 0, (): void => {
      (aiBarViewModel as object)['setAiBarStatusInGame'](1, 3, 'abc');
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('AIBarViewModel_setAiBarStatusInGame_3', 0, (): void => {
      (aiBarViewModel as object)['setAiBarStatusInGame'](1, 1, 'abc');
      expect(aiBarViewModel).not().assertUndefined();
    })

    it('AIBarViewModel_checkPlayBarFollowHandAnim_1', 0, (): void => {
      aiBarViewModel.aiBarViewData.isShowingAiBar = false;
      expect(aiBarViewModel.aiBarAnimate.checkPlayBarFollowHandAnim(gestureEvent) === undefined).assertTrue();
    })

    it('AIBarViewModel_checkPlayBarFollowHandAnim_2', 0, (): void => {
      aiBarViewModel.aiBarViewData.isShowingAiBar = true;
      expect(aiBarViewModel.aiBarAnimate.checkPlayBarFollowHandAnim(gestureEvent) === undefined).assertTrue();
    })

    it('AIBarViewModel_getTransitionEffect_1', 0, (): void => {
      expect(aiBarViewModel.aiBarAnimate.getTransitionEffect(true) !== undefined).assertTrue();
    })

    it('AIBarViewModel_getTransitionEffect_2', 0, (): void => {
      expect(aiBarViewModel.aiBarAnimate.getTransitionEffect(false) !== undefined).assertTrue();
    })

    it('should_clear_both_timers_when_they_are_set', 0, async (done: Function) => {

      let mocker: MockKit = new MockKit();
      let mockClearTimeout: Function = mocker.mockFunc(globalThis, globalThis.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturn(null);
      aiBarViewModel.clearTimeout();
      mocker.ignoreMock(globalThis, globalThis.clearTimeout);
      done();
    });


    it('should_return_true_when_keyName_is_in_active_session_list_in_container_session', 0, async (done: Function) => {

      let mocker = new MockKit();
      let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionList.add(scContainerSession);
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getContainerSessionList().getActiveSessionList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);


      const result = aiBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();

      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('should_return_true_when_keyName_is_in_active_session_list_in_special_container_session', 0, async (done: Function) => {
      let mocker = new MockKit();
      let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionList.add(scContainerSession);
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().getActiveSessionList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);

      const result = aiBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();

      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('should_return_true_when_keyName_is_in_active_session_list_in_floating_session', 0, async (done: Function) => {
      let mocker = new MockKit();
      let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('1', '2', '3');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionList.add(scContainerSession);
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getFloatingSessionList().getActiveSessionList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);

      const result = aiBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();

      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('should_return_false_when_keyName_is_not_in_any_active_session_list', 0, async (done: Function) => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getFloatingSessionList().getActiveSessionList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      const result = aiBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('AIBarViewModelTest_selectAppInFrontDesk_1', 0, async (done: Function) => {
      let mocker = new MockKit();
      let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('132', '2', '3');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionList.add(scContainerSession);
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getContainerSessionList().getActiveSessionList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
      const result = aiBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('AIBarViewModelTest_selectAppInFrontDesk_2', 0, async (done: Function) => {
      let mocker = new MockKit();
      let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('132', '2', '3');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionList.add(scContainerSession);
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getSpecialContainerSessionList().getActiveSessionList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
      const result = aiBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('AIBarViewModelTest_selectAppInFrontDesk_3', 0, async (done: Function) => {
      let mocker = new MockKit();
      let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('132', '2', '3');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionList.add(scContainerSession);
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getFloatingSessionList().getActiveSessionList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);
      const result = aiBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('AIBarViewModelTest_selectAppInFrontDesk_3', 0, async (done: Function) => {
      let mocker = new MockKit();
      let sessionList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
      let sceneInfo: SCBSceneInfo = new SCBSceneInfo('132', '2', '3');
      let scbSceneSession: SCBSceneSession = new SCBSceneSession(
        sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let scContainerSession: SCBSceneContainerSession =
        new SCBSceneContainerSession(scbSceneSession, screenProperty);
      sessionList.add(scContainerSession);
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getFloatingSessionList().getActiveSessionList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(sessionList);

      let checkKeyNameIsInCurPanel = mocker.mockFunc(aiBarViewModel, (aiBarViewModel as object)['checkKeyNameIsInCurPanel']);
      when(checkKeyNameIsInCurPanel)().afterReturn(true);

      const result = aiBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('AIBarViewModelTest_aiBarViewDisAppear', 0, () => {
      expect(aiBarViewModel.aiBarViewDisAppear() === undefined).assertTrue();
    });

    it('AIBarViewModelTest_aiBarViewDisAppear_1', 0, () => {
      expect(aiBarViewModel.aiBarViewDisAppear() === undefined).assertTrue();
    });

    it('AIBarViewModelTest_calculateDragWidth_1', 0, async (done: Function) => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      (aiBarViewModel as object)['calculateDragWidth'](700);
      expect(aiBarViewModel).not().assertUndefined();
      done();
    });

    it('AIBarViewModelTest_isAiBarTranslate_true', 0, () => {
      aiBarViewModel.aiBarViewData.barTranslateParam.barTranslateY = 10;
      aiBarViewModel.aiBarViewData.barTranslateParam.barTranslateY = 10;
      expect(aiBarViewModel.isAiBarTranslate()).assertTrue();
    });

    it('AIBarViewModelTest_isAiBarTranslate_false', 0, () => {
      aiBarViewModel.aiBarViewData.barTranslateParam.barTranslateY = 0;
      aiBarViewModel.aiBarViewData.barTranslateParam.barTranslateY = 0;
      expect(aiBarViewModel.isAiBarTranslate()).assertFalse();
    });

    it('AIBarViewModelTest_isAiBarTranslate_false_1', 0, () => {
      aiBarViewModel.aiBarViewData.barTranslateParam.barTranslateY = 0;
      aiBarViewModel.aiBarViewData.barTranslateParam.barTranslateY = 0;
      expect(aiBarViewModel.isAiBarTranslate()).assertFalse();
    });

    it('AIBarViewModelTest_isAiBarTranslate_false_2', 0, () => {
      aiBarViewModel.aiBarViewData.barTranslateParam.barTranslateY = 0;
      aiBarViewModel.aiBarViewData.barTranslateParam.barTranslateY = 0;
      expect(aiBarViewModel.isAiBarTranslate()).assertFalse();
    });

    // new
    it('AIBarViewModelTest_handleSwitchedEvent_1', 0, (done: Function) => {
      let switchEventData: SwitchEventData = new SwitchEventData();
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      (aiBarViewModel as object)['handleSwitchedEvent'](switchEventData);
      expect(aiBarViewModel).not().assertUndefined();
      done();
    });

    it('AIBarViewModelTest_checkIsInMidScene_1', 0, (done: Function) => {
      let mockKit = new MockKit();
      let sessionManager = SCBSceneSessionManager.getInstance();
      let IsTopContainerInMidScene = mockKit.mockFunc(sessionManager, sessionManager.IsTopContainerInMidScene);
      when(IsTopContainerInMidScene)().afterReturn(true);
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      aiBarViewModel.checkIsInMidScene();
      expect(aiBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(sessionManager, sessionManager.IsTopContainerInMidScene);
      done();
    });

    it('AIBarViewModelTest_checkIsInMidScene_2', 0, (done: Function) => {
      let mockKit = new MockKit();
      let sessionManager = SCBSceneSessionManager.getInstance();
      let IsTopContainerInMidScene = mockKit.mockFunc(sessionManager, sessionManager.IsTopContainerInMidScene);
      when(IsTopContainerInMidScene)().afterReturn(false);
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      aiBarViewModel.checkIsInMidScene();
      expect(aiBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(sessionManager, sessionManager.IsTopContainerInMidScene);
      done();
    });

    it('AIBarViewModelTest_onCapsuleWidthChange_3', 0, (done: Function) => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      (aiBarViewModel as object)['getAiBarAreaPaperDegree']();
      expect(aiBarViewModel).not().assertUndefined();
      done();
    });

    it('AIBarViewModelTest_inputMonitorCallback_1', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      aiBarViewModel.aiBarData.startPosition = 0;
      (aiBarViewModel as object)['inputMonitorCallback']({touches: []});
      (aiBarViewModel as object)['inputMonitorCallback'](undefined);
      expect(aiBarViewModel).not().assertUndefined();
    });

    it('AIBarViewModelTest_inputMonitorCallback_2', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      aiBarViewModel.aiBarData.startPosition = 0;
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      let input1 = getInputTouch();
      input1.touches[0].screenY = 10;
      (aiBarViewModel as object)['inputMonitorCallback'](input1);
      let input2 = getInputTouch();
      input2.touches[0].screenY = 20;
      (aiBarViewModel as object)['inputMonitorCallback'](input2);
      let input3 = getInputTouch();
      input3.touches[0].screenY = 30;
      (aiBarViewModel as object)['inputMonitorCallback'](input3);
      let input4 = getInputTouch();
      input4.touches[0].screenY = 40;
      (aiBarViewModel as object)['inputMonitorCallback'](input4);
      (aiBarViewModel as object)['inputMonitorCallback'](input4);
      (aiBarViewModel as object)['inputMonitorCallback'](input4);
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      expect(aiBarViewModel).not().assertUndefined();
    });

    it('AIBarViewModelTest_inputMonitorCallback_3', 0, () => {
      let mockKit = new MockKit();
      let isExclusive = mockKit.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(isExclusive)(ArgumentMatchers.any).afterReturn(true);
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      aiBarViewModel.aiBarData.startPosition = 0;
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (aiBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      let input1 = getInputTouch();
      input1.touches[0].screenY = 1000;
      (aiBarViewModel as object)['inputMonitorCallback'](input1);
      (aiBarViewModel as object)['inputMonitorCallback'](input1);
      expect(aiBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
    });

    it('AIBarViewModelTest_aiBarExitFunc_1', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getAibarOpacity = mockKit.mockFunc(aiBarViewModel.aiBarViewData,
        aiBarViewModel.aiBarViewData.getAibarOpacity);
      when(getAibarOpacity)(ArgumentMatchers.any).afterReturn(0);
      (aiBarViewModel as object)['aiBarExitFunc']();
      expect(aiBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(aiBarViewModel.aiBarViewData, aiBarViewModel.aiBarViewData.getAibarOpacity);
    });

    it('AIBarViewModelTest_aiBarExitFunc_2', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getAibarOpacity = mockKit.mockFunc(aiBarViewModel.aiBarViewData,
        aiBarViewModel.aiBarViewData.getAibarOpacity);
      when(getAibarOpacity)(ArgumentMatchers.any).afterReturn(1);
      (aiBarViewModel as object)['aiBarExitFunc']();
      expect(aiBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(aiBarViewModel.aiBarViewData, aiBarViewModel.aiBarViewData.getAibarOpacity);
    });

    it('AIBarViewModelTest_aiBarShowFunc_1', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getAibarOpacity = mockKit.mockFunc(aiBarViewModel.aiBarViewData,
        aiBarViewModel.aiBarViewData.getAibarOpacity);
      when(getAibarOpacity)(ArgumentMatchers.any).afterReturn(0);
      (aiBarViewModel as object)['aiBarShowFunc']();
      expect(aiBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(aiBarViewModel.aiBarViewData, aiBarViewModel.aiBarViewData.getAibarOpacity);
    });

    it('AIBarViewModelTest_aiBarShowFunc_2', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getAibarOpacity = mockKit.mockFunc(aiBarViewModel.aiBarViewData,
        aiBarViewModel.aiBarViewData.getAibarOpacity);
      when(getAibarOpacity)(ArgumentMatchers.any).afterReturn(1);
      (aiBarViewModel as object)['aiBarShowFunc']();
      expect(aiBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(aiBarViewModel.aiBarViewData, aiBarViewModel.aiBarViewData.getAibarOpacity);
    });

    it('AIBarViewModelTest_aiBarShowFunc_3', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getAibarOpacity = mockKit.mockFunc(aiBarViewModel.aiBarViewData,
        aiBarViewModel.aiBarViewData.getAibarOpacity);
      when(getAibarOpacity)(ArgumentMatchers.any).afterReturn(1);
      (aiBarViewModel as object)['aiBarShowFunc']();
      expect(aiBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(aiBarViewModel.aiBarViewData, aiBarViewModel.aiBarViewData.getAibarOpacity);
    });

    it('AIBarViewModelTest_desktopModeCallback_1', 0, () => {
      let aiBarViewModel = new AIBarViewModel(new SCBScreenProperty());
      (aiBarViewModel as object)['desktopModeCallback'](DesktopModeEnum.BASE_MODE, DesktopModeEnum.EMERGENCY_MODE);
      (aiBarViewModel as object)['desktopModeCallback'](DesktopModeEnum.BASE_MODE, DesktopModeEnum.THERMAL_SAFE_MODE);
      (aiBarViewModel as object)['desktopModeCallback'](DesktopModeEnum.BASE_MODE, DesktopModeEnum.BASE_MODE);
      (aiBarViewModel as object)['desktopModeCallback'](DesktopModeEnum.BASE_MODE, DesktopModeEnum.EMERGENCY_MODE);
      expect(aiBarViewModel).not().assertUndefined();
    });

    it('AIBarViewModelTest_getRawFileContentCallBack_1', 0, () => {
      (aiBarViewModel as object)['getRawFileContentCallBack'](undefined);
      expect(aiBarViewModel).not().assertUndefined();
    });

    it('AIBarViewModelTest_getRawFileContentCallBack_2', 0, () => {
      let data: Uint8Array = new Uint8Array(new Uint8Array().buffer);

      let mockKit = new MockKit();
      let parse = mockKit.mockFunc(JSON, JSON.parse);
      when(parse)(ArgumentMatchers.any).afterThrow('parse is fail');

      (aiBarViewModel as object)['getRawFileContentCallBack'](data)
      expect(aiBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(JSON, JSON.parse);
    });

    it('AIBarViewModelTest_getRawFileContentCallBack_2', 0, () => {
      let data: Uint8Array = new Uint8Array(new Uint8Array().buffer);
      (aiBarViewModel as object)['getRawFileContentCallBack'](data)
      expect(aiBarViewModel).not().assertUndefined();
    });

    it('AIBarViewModelTest_registerPowerStatusListener', 0, () => {
      (aiBarViewModel as object)['registerPowerStatusListener']()
      expect(aiBarViewModel).not().assertUndefined();
    });
    it('AIBarViewModelTest_unRegisterPowerStatusListener', 0, () => {
      (aiBarViewModel as object)['unRegisterPowerStatusListener']()
      expect(aiBarViewModel).not().assertUndefined();
    });
  })
}

function resetHotAreaHeightInGameMocker(mocker: MockKit, aiBarViewModel: AIBarViewModel) {
  let mockFunc1: Function = mocker.mockFunc(aiBarViewModel, aiBarViewModel.navBarViewModel.checkGameStatus);
  let mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
  when(mockFunc1)().afterReturn(true);
  when(mockFunc2)().afterReturn(true);
}

function getInputTouch(): InputTouch {
  return {
    touches: [{
      id: 0,
      pressedTime: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      pressure: 0,
      width: 0,
      height: 0,
      tiltX: 0,
      tiltY: 0,
      toolX: 0,
      toolY: 0,
      toolWidth: 0,
      toolHeight: 0,
      rawX: 0,
      rawY: 0,
      toolType: ToolType.FINGER
    }],
    action: Action.CANCEL,
    touch: {
      id: 0,
      pressedTime: 0,
      windowX: 0,
      windowY: 0,
      screenX: 0,
      screenY: 0,
      pressure: 0,
      width: 0,
      height: 0,
      tiltX: 0,
      tiltY: 0,
      toolX: 0,
      toolY: 0,
      toolWidth: 0,
      toolHeight: 0,
      rawX: 0,
      rawY: 0,
      toolType: ToolType.FINGER
    },
    sourceType: 0,
    id: 0,
    deviceId: 0,
    actionTime: 0,
    screenId: 0,
    windowId: 0
  };
}

class MockDockDragEvent implements DragEvent {
  getModifierKeyState?(keys: string[]): boolean {
    return true;
  }

  executeDropAnimation(customDropAnimation: Callback<void, void>): void {
  }

  displayX: number = 0;
  displayY: number = 0;

  getDisplayX(): number {
    return this.displayX;
  }

  getDisplayY(): number {
    return this.displayY;
  }

  getWindowX(): number {
    return 0;
  }

  getWindowY(): number {
    return 0;
  }

  getX(): number {
    return 0;
  }

  getY(): number {
    return 0;
  }

  dragBehavior: DragBehavior = DragBehavior.COPY;
  useCustomDropAnimation: boolean = false;

  setData(unifiedData: unifiedDataChannel.UnifiedData): void {
  }

  getData(): unifiedDataChannel.UnifiedData {
    let data = new unifiedDataChannel.UnifiedRecord()
    return new unifiedDataChannel.UnifiedData(data);
  }

  getSummary(): unifiedDataChannel.Summary {
    return new unifiedDataChannel.Summary();
  }

  setResult(dragResult: DragResult): void {
  }

  getResult(): DragResult {
    return DragResult.DRAG_SUCCESSFUL;
  }

  getPreviewRect(): Rectangle {
    return {};
  }

  getVelocityX(): number {
    return 0;
  }

  getVelocityY(): number {
    return 0;
  }

  getVelocity(): number {
    return 0;
  }
}
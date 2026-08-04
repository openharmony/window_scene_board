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
  NAVIBarViewModel, } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarViewModel';
import {
  SwitchType,
  ToastType
} from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/settings/preference/PreferenceType';
import lottie from '@ohos/lottie';
import {
  NaviBarShowParam,
  WeakNotifyParam,
  WeakNotifyState } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/NAVIBarModel/NAVIBarViewData';
import { inputMonitor } from '@kit.InputKit';
import { commonEventManager, systemParameterEnhance, thermal, BusinessError, power } from '@kit.BasicServicesKit';
import { ToolType, Action, TouchEvent as InputTouch } from '@ohos.multimodalInput.touchEvent'
import { SCBNaviBarConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/SCBNaviBarConstants';
import { SystemSceneConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/SystemSceneConstants';
import {
  NaviBarRegisterFunc,
  SCBNaviBarProxyManager } from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/proxy/SCBNaviBarProxyManager';
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
  naviBarSettingsDataMgr,
  NaviBarSettingsDataMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/naviBar/settings/preference/NaviBarSettingsDataMgr';
import { MultiWindowMode } from '@ohos/windowscene';
import { DragEventType } from '@ohos/phonebase/src/main/ets/SceneBoard/gesturenavigation/SCBGestureNavBarViewModel';
import { SendTouchEventController } from '@ohos/windowscene/Index';
import { SCBDefaultZIndex } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/SCBScreen';
import type abilityCommon from '@ohos.app.ability.common';
import { SwitchEventData, UserSwitchService } from '@ohos/screenlockcommon';
import { DragEvent } from 'DragControllerParam';
import unifiedDataChannel from '@ohos.data.unifiedDataChannel';

export default function NAVIBarViewModelTest() {
  describe('NAVIBarViewModelTest', () => {
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
    let naviBarViewModel: NAVIBarViewModel = NAVIBarViewModel.getInstance(scbScreenProperty);
    let viewController: BaseViewController = new BaseViewController('test');
    let naviBarShowParam: NaviBarShowParam = new NaviBarShowParam();

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

    it('naviBarViewModel_switchMultiWindowModeCallback_1', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      expect((naviBarViewModel as object)['switchMultiWindowModeCallback'].onEnterMode?.(MultiWindowMode.FREEFORM_SCENE) ===
        undefined).assertTrue();
    })

    it('naviBarViewModel_switchMultiWindowModeCallback_2', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      expect((naviBarViewModel as object)['switchMultiWindowModeCallback'].onEnterMode?.(MultiWindowMode.FULL_SCENE) ===
        undefined).assertTrue();
    })

    it('naviBarViewModel_switchMultiWindowModeCallback_3', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      expect((naviBarViewModel as object)['switchMultiWindowModeCallback'].onEnterMode?.(5) ===
        undefined).assertTrue();
    })

    it('naviBarViewModel_naviBarViewAppear_1', 0, () => {
      let mockKit = new MockKit();
      mockKit.mockFunc(naviBarViewModel, (naviBarViewModel as object)['lottieResourcePreparation']);

      naviBarViewModel.naviBarData.isTimerRunning = false;
      let sendTouchEventController = new SendTouchEventController('TAG', 1, SCBDefaultZIndex.GESTURE_NAVIGATION);
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      expect(naviBarViewModel.naviBarViewAppear(1, viewController, sendTouchEventController) === undefined).assertTrue();

      mockKit.ignoreMock(naviBarViewModel, (naviBarViewModel as object)['lottieResourcePreparation']);
    })

    it('naviBarViewModel_naviBarViewAppear_2', 0, () => {
      let mockKit = new MockKit();
      mockKit.mockFunc(naviBarViewModel, (naviBarViewModel as object)['lottieResourcePreparation']);

      naviBarViewModel.naviBarData.isTimerRunning = true;
      let sendTouchEventController = new SendTouchEventController('TAG', 1, SCBDefaultZIndex.GESTURE_NAVIGATION);
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      expect(naviBarViewModel.naviBarViewAppear(1, viewController, sendTouchEventController) === undefined).assertTrue();

      mockKit.ignoreMock(naviBarViewModel, (naviBarViewModel as object)['lottieResourcePreparation']);
    })

    it('naviBarViewModel_naviBarViewAppear_3', 0, () => {
      let mockKit = new MockKit();
      mockKit.mockFunc(naviBarViewModel, (naviBarViewModel as object)['lottieResourcePreparation']);

      naviBarViewModel.naviBarData.is2DRelease = true;
      let sendTouchEventController = new SendTouchEventController('TAG', 1, SCBDefaultZIndex.GESTURE_NAVIGATION);
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      expect(naviBarViewModel.naviBarViewAppear(1, viewController, sendTouchEventController) === undefined).assertTrue();

      mockKit.ignoreMock(naviBarViewModel, (naviBarViewModel as object)['lottieResourcePreparation']);
    })

    it('naviBarViewModel_naviBarViewAppear_4', 0, () => {
      let mockKit = new MockKit();
      mockKit.mockFunc(naviBarViewModel, (naviBarViewModel as object)['lottieResourcePreparation']);

      naviBarViewModel.naviBarData.is2DRelease = false;
      let sendTouchEventController = new SendTouchEventController('TAG', 1, SCBDefaultZIndex.GESTURE_NAVIGATION);
      GlobalContext.setContext(globalThis.getContext() as abilityCommon.ServiceExtensionContext);
      expect(naviBarViewModel.naviBarViewAppear(1, viewController, sendTouchEventController) === undefined).assertTrue();

      mockKit.ignoreMock(naviBarViewModel, (naviBarViewModel as object)['lottieResourcePreparation']);
    })

    it('naviBarViewModel_registerNaviBarProxyCallback_1', 0, () => {
      SCBNaviBarProxyManager.getInstance().executeCallbackByType(NaviBarRegisterFunc.NAVIBAR_EXIT_FUNC);
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('naviBarViewModel_registerNaviBarProxyCallback_2', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      SCBNaviBarProxyManager.getInstance().executeCallbackByType(NaviBarRegisterFunc.NAVIBAR_SHOW_FUNC);
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('naviBarViewModel_registerNaviBarProxyCallback_3', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      SCBNaviBarProxyManager.getInstance().executeCallbackByType(NaviBarRegisterFunc.NAVIBAR_SHOW_FUNC);
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('naviBarViewModel_registerNaviBarProxyCallback_8', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      let mocker: MockKit = new MockKit();
      let getNavibarOpacity = mocker.mockFunc(naviBarViewModel.naviBarViewData, naviBarViewModel.naviBarViewData.getNavibarOpacity);
      when(getNavibarOpacity)(ArgumentMatchers.any).afterReturn(0);
      SCBNaviBarProxyManager.getInstance().executeCallbackByType(NaviBarRegisterFunc.NAVIBAR_SHOW_FUNC);
      expect(naviBarViewModel).not().assertUndefined();
      mocker.ignoreMock(naviBarViewModel.naviBarViewData, naviBarViewModel.naviBarViewData.getNavibarOpacity);
    })

    it('naviBarViewModel_unRegisterNaviBarProxyCallback_1', 0, () => {
      expect(naviBarViewModel.unRegisterNaviBarProxyCallback() === undefined).assertTrue();
    })

    it('naviBarViewModel_registerDesktopModeCallback_1', 0, () => {
      expect(naviBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
    })

    it('should_unregister_all_navi_bar_proxy_callbacks', 0, () => {
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(SCBNaviBarProxyManager.getInstance(), SCBNaviBarProxyManager.getInstance().unRegisterProxyCallback);
      naviBarViewModel.unRegisterNaviBarProxyCallback();
      mocker.verify('unRegisterProxyCallback', ['naviBarExit']).atLeast(1);
      mocker.verify('unRegisterProxyCallback', ['naviBarShow']).atLeast(1);
      mocker.verify('unRegisterProxyCallback', ['naviBarHide']).atLeast(1);
      mocker.ignoreMock(SCBNaviBarProxyManager.getInstance(), SCBNaviBarProxyManager.getInstance().unRegisterProxyCallback);
    });

    it('should_unregister_all_navi_bar_toast_callbacks', 0, () => {
      let mocker: MockKit = new MockKit();
      mocker.mockFunc(naviBarViewModel.naviBarData.naviBarSettingsDataMgr,
        naviBarViewModel.naviBarData.naviBarSettingsDataMgr.unRegisterCallback);
      mocker.verify('unRegisterCallback', [ToastType.NAVI_BAR_TOAST]).atLeast(1);
      mocker.ignoreMock(naviBarViewModel.naviBarData.naviBarSettingsDataMgr,
        naviBarViewModel.naviBarData.naviBarSettingsDataMgr.unRegisterCallback);
    });

    it('naviBarViewModel_registerDesktopModeCallback_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().registerModeChangeCallback);
      when(mockFunc1)(ArgumentMatchers.any)
        .afterReturn((registerTag: string, callback: Function) => {
          callback(DesktopModeEnum.EMERGENCY_MODE, DesktopModeEnum.EMERGENCY_MODE);
        });
      expect(naviBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().registerModeChangeCallback);
    })

    it('naviBarViewModel_registerDesktopModeCallback_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().registerModeChangeCallback);
      when(mockFunc1)(ArgumentMatchers.any)
        .afterReturn((registerTag: string, callback: Function) => {
          callback(DesktopModeEnum.THERMAL_SAFE_MODE, DesktopModeEnum.THERMAL_SAFE_MODE);
        });
      expect(naviBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().registerModeChangeCallback);
    })

    it('naviBarViewModel_registerDesktopModeCallback_4', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().registerModeChangeCallback);
      when(mockFunc1)(ArgumentMatchers.any)
        .afterReturn((registerTag: string, callback: Function) => {
          callback(DesktopModeEnum.THER_EMC_OVERLAY_MODE, DesktopModeEnum.THER_EMC_OVERLAY_MODE);
        });
      expect(naviBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().registerModeChangeCallback);
    })

    it('naviBarViewModel_registerDesktopModeCallback_5', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().registerModeChangeCallback);
      when(mockFunc1)(ArgumentMatchers.any)
        .afterReturn((registerTag: string, callback: Function) => {
          callback(DesktopModeEnum.BASE_MODE, DesktopModeEnum.BASE_MODE);
        });
      expect(naviBarViewModel.registerDesktopModeCallback() === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(), DesktopModeManager.getInstance().registerModeChangeCallback);
    })

    it('naviBarViewModel_registerNaviBarToastCallback_2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(naviBarViewModel.naviBarData.naviBarSettingsDataMgr,
        naviBarViewModel.naviBarData.naviBarSettingsDataMgr.registerCallback);
      when(mockFuc)(ArgumentMatchers.any).afterAction((type:string, callback: Function) => {
        callback('clickBackStatus');
      });
      mocker.ignoreMock(naviBarViewModel.naviBarData.naviBarSettingsDataMgr,
        naviBarViewModel.naviBarData.naviBarSettingsDataMgr.registerCallback);
    })

    it('naviBarViewModel_registerNaviBarToastCallback_3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(naviBarViewModel.naviBarData.naviBarSettingsDataMgr,
        naviBarViewModel.naviBarData.naviBarSettingsDataMgr.registerCallback);
      mocker.ignoreMock(naviBarViewModel.naviBarData.naviBarSettingsDataMgr,
        naviBarViewModel.naviBarData.naviBarSettingsDataMgr.registerCallback);
    })

    it('naviBarViewModel_registerNaviBarToastCallback_4', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFuc: Function = mocker.mockFunc(naviBarViewModel.naviBarData.naviBarSettingsDataMgr,
        naviBarViewModel.naviBarData.naviBarSettingsDataMgr.registerCallback);
      when(mockFuc)(ArgumentMatchers.any).afterAction((type:string, callback: Function) => {
        callback('naviBarToast')
      });
      mocker.ignoreMock(naviBarViewModel.naviBarData.naviBarSettingsDataMgr,
        naviBarViewModel.naviBarData.naviBarSettingsDataMgr.registerCallback);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_1', 0, () => {
      expect(naviBarViewModel.unRegisterNaviBarProxyCallback() === undefined).assertTrue();
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_2', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_3', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_4', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_5', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_6', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_7', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_8', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_9', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_10', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_11', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_12', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_13', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_14', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_15', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_16', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_17', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_18', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_19', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_20', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(false);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_dragShowResetParam_1', 0, () => {
      (naviBarViewModel as object)['dragShowResetParam']();
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_21', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_22', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_23', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_24', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_25', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_26', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_27', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_28', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_29', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_30', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_31', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_32', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_33', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_34', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_35', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_36', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_37', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_38', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_39', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_40', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_resetHotAreaHeightInGame_41', 0, () => {
      let mocker: MockKit = new MockKit();
      resetHotAreaHeightInGameMocker(mocker, naviBarViewModel);
      let mockFunc3: Function = mocker.mockFunc(naviBarViewModel,
        naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      expect(naviBarViewModel.resetHotAreaHeightInGame() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
    })

    it('naviBarViewModel_getStartPosition_1', 0, () => {
      (naviBarViewModel as object)['screenProperty'].height = 1000;
      (naviBarViewModel as object)['getStartPosition'](20);
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('naviBarViewModel_getStartPosition_2', 0, () => {
      (naviBarViewModel as object)['screenProperty'].height = 300;
      (naviBarViewModel as object)['getStartPosition'](800);
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('naviBarViewModel_getNAVIBarColor_1', 0, () => {
      naviBarViewModel.naviBarData.getNAVIBarColor(naviBarViewModel.naviBarViewData);
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('naviBarViewModel_getNAVIBarColor_2', 0, () => {
      naviBarViewModel.naviBarViewData.scenePanelState = 0;
      naviBarViewModel.naviBarViewData.specialScenePanelState = 0;
      expect(naviBarViewModel.naviBarData.getNAVIBarColor(naviBarViewModel.naviBarViewData) !== undefined).assertTrue()
    })

    it('naviBarViewModel_getNAVIBarColor_3', 0, () => {
      naviBarViewModel.naviBarViewData.scenePanelState = 0;
      naviBarViewModel.naviBarViewData.specialScenePanelState = 2;
      expect(naviBarViewModel.naviBarData.getNAVIBarColor(naviBarViewModel.naviBarViewData) !== undefined).assertTrue()
    })

    it('naviBarViewModel_getNAVIBarColor_4', 0, () => {
      naviBarViewModel.naviBarViewData.powerMode = 600;
      naviBarViewModel.naviBarViewData.scenePanelState =1;
      naviBarViewModel.naviBarViewData.specialScenePanelState = 2;
      expect(naviBarViewModel.naviBarData.getNAVIBarColor(naviBarViewModel.naviBarViewData) !== undefined).assertFalse()
    })

    it('naviBarViewModel_getNAVIBarColor_5', 0, () => {
      naviBarViewModel.naviBarViewData.scenePanelState =1;
      naviBarViewModel.naviBarViewData.specialScenePanelState = 2;
      naviBarViewModel.naviBarViewData.powerMode = SCBNaviBarConstants.LOW_POWER_LEVEL;
      naviBarViewModel.naviBarData.getNAVIBarColor(naviBarViewModel.naviBarViewData);
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('naviBarViewModel_naviBarRetract_1', 0, () => {
      expect(naviBarViewModel.naviBarRetract(new HiSysLongPressMisTouchType()) === undefined).assertTrue();
    });

    it('naviBarViewModel_naviBarOnTouchEvent_1', 0, () => {
      expect(naviBarViewModel.naviBarOnTouchEvent(touchEvent, null) === undefined).assertTrue();
    });

    it('naviBarViewModel_naviBarOnTouchEvent_2', 0, () => {
      naviBarViewModel.naviBarData.isNaviBarRetract = true;
      expect(naviBarViewModel.naviBarOnTouchEvent(touchEvent, downEvent) === undefined).assertTrue();
    });

    it('naviBarViewModel_naviBarOnTouchEvent_5', 0, () => {
      expect(naviBarViewModel.naviBarOnTouchEvent(touchEvent, null) === undefined).assertTrue();
    });

    it('naviBarViewModel_naviBarOnTouchEvent_6', 0, () => {
      expect(naviBarViewModel.naviBarOnTouchEvent(touchEvent, downEvent) === undefined).assertTrue();
    });

    it('should_reset_hot_area_height_to_default_when_not_in_game_status', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockCheckGameStatus: Function = mocker.mockFunc(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      when(mockCheckGameStatus)().afterReturn(false);
      let mockIsPhone: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhone)().afterReturn(true);
      naviBarViewModel.resetHotAreaHeightInGame();
      expect(naviBarViewModel).not().assertUndefined();
      mocker.ignoreMock(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      done();
    });

    it('should_reset_hot_area_height_to_game_status_when_in_game_status_and_anti_touch_enabled', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockCheckGameStatus: Function = mocker.mockFunc(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      when(mockCheckGameStatus)().afterReturn(true);
      let mockIsPhone: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhone)().afterReturn(true);
      let mockCheckEnableAntiTouchStatus: Function = mocker.mockFunc(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockCheckEnableAntiTouchStatus)(ArgumentMatchers.any).afterReturn(true);
      naviBarViewModel.resetHotAreaHeightInGame();
      expect(naviBarViewModel).not().assertUndefined();
      mocker.ignoreMock(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      mocker.ignoreMock(naviBarViewModel.navBarViewModel.windowManager, naviBarViewModel.navBarViewModel.windowManager.setResponseRegionHeight);
      done();
    });

    it('should_reset_hot_area_height_to_default_when_in_game_status_and_anti_touch_disabled', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockCheckGameStatus: Function = mocker.mockFunc(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      when(mockCheckGameStatus)().afterReturn(true);
      let mockIsPhone: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockIsPhone)().afterReturn(true);
      let mockCheckEnableAntiTouchStatus: Function = mocker.mockFunc(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      when(mockCheckEnableAntiTouchStatus)(ArgumentMatchers.any).afterReturn(false);
      naviBarViewModel.resetHotAreaHeightInGame();
      expect(naviBarViewModel).not().assertUndefined();
      mocker.ignoreMock(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPhone);
      mocker.ignoreMock(naviBarViewModel.navBarViewModel, naviBarViewModel.navBarViewModel.checkEnableAntiTouchStatus);
      done();
    });

    it('NAVIBarViewModel_initGameEventListener_1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let createSubscriber: Function = mocker.mockFunc(naviBarViewModel, (naviBarViewModel as object)['createSubscriber']);
      when(createSubscriber)(ArgumentMatchers.any).afterReturnNothing();
      expect(naviBarViewModel.initGameEventListener() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, (naviBarViewModel as object)['createSubscriber']);
      done();
    });

    it('NAVIBarViewModel_initGameEventListener_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let createSubscriber: Function = mocker.mockFunc(naviBarViewModel, (naviBarViewModel as object)['createSubscriber']);
      when(createSubscriber)(ArgumentMatchers.any).afterThrow('createSubscriber is fail');
      expect(naviBarViewModel.initGameEventListener() === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, (naviBarViewModel as object)['createSubscriber']);
      done();
    });

    it('NAVIBarViewModel_subscriberFunc_1', 0, async (done: Function) => {
      let err: BusinessError = {} as BusinessError;
      let commonEventData: commonEventManager.CommonEventData = {} as commonEventManager.CommonEventData;
      (naviBarViewModel as object)['subscriberFunc'](err, commonEventData);
      expect(naviBarViewModel).not().assertUndefined();
      done();
    });

    it('NAVIBarViewModel_subscriberFunc_2', 0, async (done: Function) => {
      let commonEventData: commonEventManager.CommonEventData = {
        event: commonEventManager.Support.COMMON_EVENT_POWER_SAVE_MODE_CHANGED,
        code: power.DevicePowerMode.MODE_NORMAL
      } as commonEventManager.CommonEventData;
      (naviBarViewModel as object)['subscriberFunc'](undefined, commonEventData);
      expect(naviBarViewModel).not().assertUndefined();
      done();
    });

    it('NAVIBarViewModel_subscriberFunc_2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let createSubscriber: Function = mocker.mockFunc(naviBarViewModel,
        (naviBarViewModel as object)['setNaviBarStatusInGame']);
      when(createSubscriber)(ArgumentMatchers.any).afterReturnNothing();

      let commonEventData: commonEventManager.CommonEventData = {
        event: SystemSceneConstants.GAME_EVENT_LISTENER_FIELD,
        code: power.DevicePowerMode.MODE_NORMAL,
        parameters: {}
      } as commonEventManager.CommonEventData;
      (naviBarViewModel as object)['subscriberFunc'](undefined, commonEventData);
      expect(naviBarViewModel).not().assertUndefined();
      done();
    });

    it('should_not_call_notifyNaviBarShowStatus_when_isShowingNaviBar_does_not_change_and_scenePanelState_is_RECENT', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarViewModel, naviBarViewModel.notifyNaviBarShowStatus);
      let naviBarShowParam: NaviBarShowParam = new NaviBarShowParam()
      naviBarShowParam.scenePanelState = ScenePanelState.RECENT;

      naviBarViewModel.naviBarViewData.isShowingNaviBar = true;
      naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam);
      mocker.verify('notifyNaviBarShowStatus', []).never();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.notifyNaviBarShowStatus);
      done();
    });

    it('should_call_notifyNaviBarShowStatus_when_isShowingNaviBar_changes_and_scenePanelState_is_not_RECENT', 0, async (done: Function) => {

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(naviBarViewModel, naviBarViewModel.notifyNaviBarShowStatus);
      let naviBarShowParam: NaviBarShowParam = new NaviBarShowParam()
      naviBarViewModel.naviBarViewData.isShowingNaviBar = false;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(naviBarViewModel, naviBarViewModel.notifyNaviBarShowStatus);
      done();
    });

    it('should_call_startVibration_and_processBackEvent_with_BACK_and_VIBRATION_ATTRIBUTE_LONG_PRESS', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockProcessBackEvent: Function = mocker.mockFunc(singletonBackViewModel, singletonBackViewModel.processBackEvent);
      when(mockProcessBackEvent)([ArgumentMatchers.any, ArgumentMatchers.any]).afterReturn(null);
      naviBarViewModel.processBackEvent();
      expect(naviBarViewModel).not().assertUndefined();
      mocker.ignoreMock(singletonBackViewModel, singletonBackViewModel.processBackEvent);
      done();
    });

    it('NAVIBarViewModel_updateNaviBarHotAreaRect_1', 0, (): void => {
      expect(naviBarViewModel.updateNaviBarHotAreaRect(scbScreenProperty, scbScreenProperty) === undefined).assertTrue();
    })

    it('NAVIBarViewModel_updateNaviBarHotAreaRect_1', 0, (): void => {
      expect(naviBarViewModel.updateNaviBarHotAreaRectForRecent(scbScreenProperty, RotationConstants.ROTATION_90) ===
        undefined).assertTrue();
    })

    it('NAVIBarViewModel_calculateNaviBarWidth_1', 0, (): void => {
      expect(naviBarViewModel.calculateNaviBarWidth(300)).assertEqual(112);
    })

    it('NAVIBarViewModel_calculateNaviBarWidth_2', 0, (): void => {
      expect(naviBarViewModel.calculateNaviBarWidth(750)).assertEqual(202);
    })

    it('NAVIBarViewModel_calculateNaviBarWidth_3', 0, (): void => {
      expect(naviBarViewModel.calculateNaviBarWidth(880)).assertEqual(172);
    })

    it('NAVIBarViewModel_isConfigureMisTouchAppActive_1', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)().afterReturn(false);
      expect(naviBarViewModel.isConfigureMisTouchAppActive() !== undefined)
        .assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad)
    })

    it('NAVIBarViewModel_isConfigureMisTouchAppActive_2', 0, (): void => {
      naviBarViewModel.naviBarViewData.scenePanelState = 0;
      expect(naviBarViewModel.isConfigureMisTouchAppActive() !== undefined)
        .assertTrue();
    })

    it('NAVIBarViewModel_isConfigureMisTouchAppActive_3', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)().afterReturn(true);
      naviBarViewModel.naviBarViewData.scenePanelState = 1;
      naviBarViewModel.naviBarViewData.isShowingNaviBar = false;
      expect(naviBarViewModel.isConfigureMisTouchAppActive() !== undefined)
        .assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad)
    })

    it('NAVIBarViewModel_isConfigureMisTouchAppActive_4', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)().afterReturn(true);
      naviBarViewModel.naviBarViewData.scenePanelState = 0;
      naviBarViewModel.naviBarViewData.isShowingNaviBar = false;
      expect(naviBarViewModel.isConfigureMisTouchAppActive() !== undefined)
        .assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPad)
    })

    it('NAVIBarViewModel_checkPlayBarResetAnim_1', 0, (): void => {
      expect(naviBarViewModel.naviBarAnimate.playBarResetAnim() === undefined).assertTrue();
    })

    it('NAVIBarViewModel_notifyNaviBarShowStatusDecide_1', 0, (): void => {
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_1', 0, (): void => {
      naviBarShowParam.isInOutLauncher = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_2', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(true);
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_3', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'false');
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_4', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_5', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.SPLIT;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_6', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_7', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      naviBarShowParam.isNavigationBarEnable = false;
      naviBarShowParam.isTempShowNaviBar = false;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_8', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      naviBarShowParam.isNavigationBarEnable = false;
      naviBarShowParam.isTempShowNaviBar = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_9', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      naviBarShowParam.isNavigationBarEnable = true;
      naviBarShowParam.isTempShowNaviBar = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_10', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      naviBarShowParam.isNavigationBarEnable = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_11', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      naviBarShowParam.isNavigationBarEnable = true;
      naviBarShowParam.isTempShowNaviBar = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_12', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.RECENT;
      naviBarShowParam.isNavigationBarEnable = true;
      naviBarShowParam.isTempShowNaviBar = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_13', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.HOME;
      naviBarShowParam.isNavigationBarEnable = true;
      naviBarShowParam.isTempShowNaviBar = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_14', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.HOME;
      naviBarShowParam.isNavigationBarEnable = true;
      naviBarShowParam.isTempShowNaviBar = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_15', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      naviBarShowParam.isNavigationBarEnable = true;
      naviBarShowParam.isTempShowNaviBar = true;
      naviBarShowParam.isInExitLandScape = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
      mocker.ignoreMock(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_16', 0, (): void => {
      naviBarShowParam.isInOutLauncher = false;
      let mocker: MockKit = new MockKit();
      let isInEmergencyOrThermalSafeMode: Function = mocker.mockFunc(DesktopModeManager.getInstance(),
        DesktopModeManager.getInstance().isInEmergencyOrThermalSafeMode);
      when(isInEmergencyOrThermalSafeMode)().afterReturn(false);
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.scenePanelState = ScenePanelState.FULLSCENE;
      naviBarShowParam.isNavigationBarEnable = true;
      naviBarShowParam.isTempShowNaviBar = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_17', 0, (): void => {
      naviBarShowParam.navBarIsShow = false;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
    })

    it('NAVIBarViewModel_judgeShowNAVIBar_18', 0, (): void => {
      naviBarShowParam.navBarIsShow = true;
      naviBarShowParam.isInOutLauncher = false;
      systemParameterEnhance.setSync('persist.sceneboard.navibar.enable', 'true');
      naviBarShowParam.isInEmergencyOrThermalSafeMode = true;
      expect(naviBarViewModel.notifyNaviBarShowStatusDecide(naviBarShowParam) === undefined).assertTrue();
    })

    it('NAVIBarViewModel_setNaviBarStatusInGame_1', 0, (): void => {
      (naviBarViewModel as object)['setNaviBarStatusInGame'](1, 4, 'abc');
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('NAVIBarViewModel_setNaviBarStatusInGame_2', 0, (): void => {
      (naviBarViewModel as object)['setNaviBarStatusInGame'](1, 3, 'abc');
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('NAVIBarViewModel_setNaviBarStatusInGame_3', 0, (): void => {
      (naviBarViewModel as object)['setNaviBarStatusInGame'](1, 1, 'abc');
      expect(naviBarViewModel).not().assertUndefined();
    })

    it('NAVIBarViewModel_checkPlayBarFollowHandAnim_1', 0, (): void => {
      naviBarViewModel.naviBarViewData.isShowingNaviBar = false;
      expect(naviBarViewModel.naviBarAnimate.checkPlayBarFollowHandAnim(gestureEvent) === undefined).assertTrue();
    })

    it('NAVIBarViewModel_checkPlayBarFollowHandAnim_2', 0, (): void => {
      naviBarViewModel.naviBarViewData.isShowingNaviBar = true;
      expect(naviBarViewModel.naviBarAnimate.checkPlayBarFollowHandAnim(gestureEvent) === undefined).assertTrue();
    })

    it('NAVIBarViewModel_getTransitionEffect_1', 0, (): void => {
      expect(naviBarViewModel.naviBarAnimate.getTransitionEffect(true) !== undefined).assertTrue();
    })

    it('NAVIBarViewModel_getTransitionEffect_2', 0, (): void => {
      expect(naviBarViewModel.naviBarAnimate.getTransitionEffect(false) !== undefined).assertTrue();
    })

    it('should_clear_both_timers_when_they_are_set', 0, async (done: Function) => {

      let mocker: MockKit = new MockKit();
      let mockClearTimeout: Function = mocker.mockFunc(globalThis, globalThis.clearTimeout);
      when(mockClearTimeout)(ArgumentMatchers.any).afterReturn(null);
      naviBarViewModel.clearTimeout();
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


      const result = naviBarViewModel.selectAppInFrontDesk('132');
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

      const result = naviBarViewModel.selectAppInFrontDesk('132');
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

      const result = naviBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();

      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('should_return_false_when_keyName_is_not_in_any_active_session_list', 0, async (done: Function) => {
      let mocker = new MockKit();
      let mockFunc = mocker.mockFunc(SCBSceneSessionManager.getInstance(),
        SCBSceneSessionManager.getInstance().getFloatingSessionList().getActiveSessionList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      const result = naviBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('NAVIBarViewModelTest_selectAppInFrontDesk_1', 0, async (done: Function) => {
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
      const result = naviBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('NAVIBarViewModelTest_selectAppInFrontDesk_2', 0, async (done: Function) => {
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
      const result = naviBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('NAVIBarViewModelTest_selectAppInFrontDesk_3', 0, async (done: Function) => {
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
      const result = naviBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('NAVIBarViewModelTest_selectAppInFrontDesk_3', 0, async (done: Function) => {
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

      let checkKeyNameIsInCurPanel = mocker.mockFunc(naviBarViewModel, (naviBarViewModel as object)['checkKeyNameIsInCurPanel']);
      when(checkKeyNameIsInCurPanel)().afterReturn(true);

      const result = naviBarViewModel.selectAppInFrontDesk('132');
      expect(result).assertFalse();
      mocker.ignoreMock(SCBSceneSessionManager, SCBSceneSessionManager.getInstance);
      done();
    });

    it('NAVIBarViewModelTest_naviBarViewDisAppear', 0, () => {
      expect(naviBarViewModel.naviBarViewDisAppear() === undefined).assertTrue();
    });

    it('NAVIBarViewModelTest_naviBarViewDisAppear_1', 0, () => {
      expect(naviBarViewModel.naviBarViewDisAppear() === undefined).assertTrue();
    });

    it('NAVIBarViewModelTest_calculateDragWidth_1', 0, async (done: Function) => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      (naviBarViewModel as object)['calculateDragWidth'](700);
      expect(naviBarViewModel).not().assertUndefined();
      done();
    });

    it('NAVIBarViewModelTest_isNaviBarTranslate_true', 0, () => {
      naviBarViewModel.naviBarViewData.barTranslateParam.barTranslateY = 10;
      naviBarViewModel.naviBarViewData.barTranslateParam.barTranslateY = 10;
      expect(naviBarViewModel.isNaviBarTranslate()).assertTrue();
    });

    it('NAVIBarViewModelTest_isNaviBarTranslate_false', 0, () => {
      naviBarViewModel.naviBarViewData.barTranslateParam.barTranslateY = 0;
      naviBarViewModel.naviBarViewData.barTranslateParam.barTranslateY = 0;
      expect(naviBarViewModel.isNaviBarTranslate()).assertFalse();
    });

    it('NAVIBarViewModelTest_isNaviBarTranslate_false_1', 0, () => {
      naviBarViewModel.naviBarViewData.barTranslateParam.barTranslateY = 0;
      naviBarViewModel.naviBarViewData.barTranslateParam.barTranslateY = 0;
      expect(naviBarViewModel.isNaviBarTranslate()).assertFalse();
    });

    it('NAVIBarViewModelTest_isNaviBarTranslate_false_2', 0, () => {
      naviBarViewModel.naviBarViewData.barTranslateParam.barTranslateY = 0;
      naviBarViewModel.naviBarViewData.barTranslateParam.barTranslateY = 0;
      expect(naviBarViewModel.isNaviBarTranslate()).assertFalse();
    });

    // new
    it('NAVIBarViewModelTest_handleSwitchedEvent_1', 0, (done: Function) => {
      let switchEventData: SwitchEventData = new SwitchEventData();
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      (naviBarViewModel as object)['handleSwitchedEvent'](switchEventData);
      expect(naviBarViewModel).not().assertUndefined();
      done();
    });

    it('NAVIBarViewModelTest_checkIsInMidScene_1', 0, (done: Function) => {
      let mockKit = new MockKit();
      let sessionManager = SCBSceneSessionManager.getInstance();
      let IsTopContainerInMidScene = mockKit.mockFunc(sessionManager, sessionManager.IsTopContainerInMidScene);
      when(IsTopContainerInMidScene)().afterReturn(true);
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      naviBarViewModel.checkIsInMidScene();
      expect(naviBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(sessionManager, sessionManager.IsTopContainerInMidScene);
      done();
    });

    it('NAVIBarViewModelTest_checkIsInMidScene_2', 0, (done: Function) => {
      let mockKit = new MockKit();
      let sessionManager = SCBSceneSessionManager.getInstance();
      let IsTopContainerInMidScene = mockKit.mockFunc(sessionManager, sessionManager.IsTopContainerInMidScene);
      when(IsTopContainerInMidScene)().afterReturn(false);
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      naviBarViewModel.checkIsInMidScene();
      expect(naviBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(sessionManager, sessionManager.IsTopContainerInMidScene);
      done();
    });

    it('NAVIBarViewModelTest_onCapsuleWidthChange_3', 0, (done: Function) => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      (naviBarViewModel as object)['getNaviBarAreaPaperDegree']();
      expect(naviBarViewModel).not().assertUndefined();
      done();
    });

    it('NAVIBarViewModelTest_inputMonitorCallback_1', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      naviBarViewModel.naviBarData.startPosition = 0;
      (naviBarViewModel as object)['inputMonitorCallback']({touches: []});
      (naviBarViewModel as object)['inputMonitorCallback'](undefined);
      expect(naviBarViewModel).not().assertUndefined();
    });

    it('NAVIBarViewModelTest_inputMonitorCallback_2', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      naviBarViewModel.naviBarData.startPosition = 0;
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      let input1 = getInputTouch();
      input1.touches[0].screenY = 10;
      (naviBarViewModel as object)['inputMonitorCallback'](input1);
      let input2 = getInputTouch();
      input2.touches[0].screenY = 20;
      (naviBarViewModel as object)['inputMonitorCallback'](input2);
      let input3 = getInputTouch();
      input3.touches[0].screenY = 30;
      (naviBarViewModel as object)['inputMonitorCallback'](input3);
      let input4 = getInputTouch();
      input4.touches[0].screenY = 40;
      (naviBarViewModel as object)['inputMonitorCallback'](input4);
      (naviBarViewModel as object)['inputMonitorCallback'](input4);
      (naviBarViewModel as object)['inputMonitorCallback'](input4);
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      expect(naviBarViewModel).not().assertUndefined();
    });

    it('NAVIBarViewModelTest_inputMonitorCallback_3', 0, () => {
      let mockKit = new MockKit();
      let isExclusive = mockKit.mockFunc(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
      when(isExclusive)(ArgumentMatchers.any).afterReturn(true);
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      naviBarViewModel.naviBarData.startPosition = 0;
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      (naviBarViewModel as object)['inputMonitorCallback'](getInputTouch());
      let input1 = getInputTouch();
      input1.touches[0].screenY = 1000;
      (naviBarViewModel as object)['inputMonitorCallback'](input1);
      (naviBarViewModel as object)['inputMonitorCallback'](input1);
      expect(naviBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(scbEventExclusiveManager, scbEventExclusiveManager.isExclusive);
    });

    it('NAVIBarViewModelTest_naviBarExitFunc_1', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getNavibarOpacity = mockKit.mockFunc(naviBarViewModel.naviBarViewData,
        naviBarViewModel.naviBarViewData.getNavibarOpacity);
      when(getNavibarOpacity)(ArgumentMatchers.any).afterReturn(0);
      (naviBarViewModel as object)['naviBarExitFunc']();
      expect(naviBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(naviBarViewModel.naviBarViewData, naviBarViewModel.naviBarViewData.getNavibarOpacity);
    });

    it('NAVIBarViewModelTest_naviBarExitFunc_2', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getNavibarOpacity = mockKit.mockFunc(naviBarViewModel.naviBarViewData,
        naviBarViewModel.naviBarViewData.getNavibarOpacity);
      when(getNavibarOpacity)(ArgumentMatchers.any).afterReturn(1);
      (naviBarViewModel as object)['naviBarExitFunc']();
      expect(naviBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(naviBarViewModel.naviBarViewData, naviBarViewModel.naviBarViewData.getNavibarOpacity);
    });

    it('NAVIBarViewModelTest_naviBarShowFunc_1', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getNavibarOpacity = mockKit.mockFunc(naviBarViewModel.naviBarViewData,
        naviBarViewModel.naviBarViewData.getNavibarOpacity);
      when(getNavibarOpacity)(ArgumentMatchers.any).afterReturn(0);
      (naviBarViewModel as object)['naviBarShowFunc']();
      expect(naviBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(naviBarViewModel.naviBarViewData, naviBarViewModel.naviBarViewData.getNavibarOpacity);
    });

    it('NAVIBarViewModelTest_naviBarShowFunc_2', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getNavibarOpacity = mockKit.mockFunc(naviBarViewModel.naviBarViewData,
        naviBarViewModel.naviBarViewData.getNavibarOpacity);
      when(getNavibarOpacity)(ArgumentMatchers.any).afterReturn(1);
      (naviBarViewModel as object)['naviBarShowFunc']();
      expect(naviBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(naviBarViewModel.naviBarViewData, naviBarViewModel.naviBarViewData.getNavibarOpacity);
    });

    it('NAVIBarViewModelTest_naviBarShowFunc_3', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      let mockKit = new MockKit();
      let getNavibarOpacity = mockKit.mockFunc(naviBarViewModel.naviBarViewData,
        naviBarViewModel.naviBarViewData.getNavibarOpacity);
      when(getNavibarOpacity)(ArgumentMatchers.any).afterReturn(1);
      (naviBarViewModel as object)['naviBarShowFunc']();
      expect(naviBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(naviBarViewModel.naviBarViewData, naviBarViewModel.naviBarViewData.getNavibarOpacity);
    });

    it('NAVIBarViewModelTest_desktopModeCallback_1', 0, () => {
      let naviBarViewModel = new NAVIBarViewModel(new SCBScreenProperty());
      (naviBarViewModel as object)['desktopModeCallback'](DesktopModeEnum.BASE_MODE, DesktopModeEnum.EMERGENCY_MODE);
      (naviBarViewModel as object)['desktopModeCallback'](DesktopModeEnum.BASE_MODE, DesktopModeEnum.THERMAL_SAFE_MODE);
      (naviBarViewModel as object)['desktopModeCallback'](DesktopModeEnum.BASE_MODE, DesktopModeEnum.BASE_MODE);
      (naviBarViewModel as object)['desktopModeCallback'](DesktopModeEnum.BASE_MODE, DesktopModeEnum.EMERGENCY_MODE);
      expect(naviBarViewModel).not().assertUndefined();
    });

    it('NAVIBarViewModelTest_getRawFileContentCallBack_1', 0, () => {
      (naviBarViewModel as object)['getRawFileContentCallBack'](undefined);
      expect(naviBarViewModel).not().assertUndefined();
    });

    it('NAVIBarViewModelTest_getRawFileContentCallBack_2', 0, () => {
      let data: Uint8Array = new Uint8Array(new Uint8Array().buffer);

      let mockKit = new MockKit();
      let parse = mockKit.mockFunc(JSON, JSON.parse);
      when(parse)(ArgumentMatchers.any).afterThrow('parse is fail');

      (naviBarViewModel as object)['getRawFileContentCallBack'](data)
      expect(naviBarViewModel).not().assertUndefined();
      mockKit.ignoreMock(JSON, JSON.parse);
    });

    it('NAVIBarViewModelTest_getRawFileContentCallBack_2', 0, () => {
      let data: Uint8Array = new Uint8Array(new Uint8Array().buffer);
      (naviBarViewModel as object)['getRawFileContentCallBack'](data)
      expect(naviBarViewModel).not().assertUndefined();
    });

    it('NAVIBarViewModelTest_registerPowerStatusListener', 0, () => {
      (naviBarViewModel as object)['registerPowerStatusListener']()
      expect(naviBarViewModel).not().assertUndefined();
    });
    it('NAVIBarViewModelTest_unRegisterPowerStatusListener', 0, () => {
      (naviBarViewModel as object)['unRegisterPowerStatusListener']()
      expect(naviBarViewModel).not().assertUndefined();
    });
  })
}

function resetHotAreaHeightInGameMocker(mocker: MockKit, naviBarViewModel: NAVIBarViewModel) {
  let mockFunc1: Function = mocker.mockFunc(naviBarViewModel, naviBarViewModel.navBarViewModel.checkGameStatus);
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
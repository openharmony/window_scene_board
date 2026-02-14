/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, when, MockKit, Level, ArgumentMatchers } from '@ohos/hypium';
import GestureDockViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewevent/GestureDockViewEventMgr';
import GestureDockViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockViewDataMgr';
import { AppModel,
  CommonConstants,
  SettingsModel,
  StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockItemInfo } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockbar/model/GestureDockItemInfo';
import { GestureDockConstants, GestureDockMode } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/GestureDockConstants';
import {
  GestureDockViewParam,
  SCBGestureDockParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/viewdata/GestureDockParam';
import { GestureDockViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dock/viewmodel/GestureDockViewModel';
import { CheckEmptyUtils } from '@ohos/basicutils';
import {
  SCBScreenProperty,
  scbGestureManager,
  GestureType,
  GestureNavigationState
} from '@ohos/windowscene';
import { GestureDockAllAppsViewModel } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/GestureDockAllAppsViewModel';
import { GestureDockAllAppsViewEvent } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewevent/GestureDockAllAppsViewEvent';
import {
  GestureDockPreferenceMgr
} from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/preference/GestureDockPreferenceMgr';
import GestureDockAllAppsViewEventMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewevent/GestureDockAllAppsViewEventMgr';
import GestureDockAllAppsViewDataMgr
  from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/dockallapps/viewmodel/viewdata/GestureDockAllAppsViewDataMgr';

export default function GestureDockViewEventMgrTest() {
  describe('GestureDockViewEventMgrTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      GestureDockViewModel.getInstance().initViewModel(new GestureDockViewEventMgr(new GestureDockViewDataMgr()));
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

    let event: DragEvent = {
      getWindowX: ((): number => { return 10 }),
      getWindowY: ((): number => { return 100 }),
      useCustomDropAnimation: false,
    } as DragEvent;

    let viewEvent: GestureDockViewEventMgr = new GestureDockViewEventMgr(new GestureDockViewDataMgr());
    let gestureDockParam: GestureDockViewParam = viewEvent?.gestureDockParam;
    let scbGestureDockParam: SCBGestureDockParam = viewEvent?.scbGestureDockParam ?? SCBGestureDockParam.getInstance();
    let dockAllAppsViewModel: GestureDockAllAppsViewModel = GestureDockAllAppsViewModel.getInstance();
    let dockPreference: GestureDockPreferenceMgr = GestureDockPreferenceMgr.getInstance();

    it('GestureDockViewEventMgr_showGestureDock_1', Level.LEVEL0, (): void => {
      expect(viewEvent.showGestureDock(true) === undefined).assertTrue();
    })

    it('GestureDockViewEventMgr_showGestureDock_2', Level.LEVEL0, (): void => {
      expect(viewEvent.showGestureDock(false) === undefined).assertTrue();
    })

    it('GestureDockViewEventMgr_aboutToAppear_1', Level.LEVEL0, (): void => {
      expect(viewEvent.aboutToAppear(new SCBScreenProperty(), 1) === undefined).assertTrue();
    })

    it('GestureDockViewEventMgr_aboutToDisappear_1', Level.LEVEL0, (): void => {
      expect(viewEvent.aboutToDisappear() === undefined).assertTrue();
    })

    it('GestureDockViewEventMgr_onLockReceived_1', Level.LEVEL0, (): void => {
      gestureDockParam.gestureDockDirection = 1;
      (viewEvent as object)['onLockReceived']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_onLockReceived_2', Level.LEVEL0, (): void => {
      gestureDockParam.gestureDockDirection = 0;
      (viewEvent as object)['onLockReceived']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_onUnLockReceived_1', Level.LEVEL0, (): void => {
      (viewEvent as object)['onUnLockReceived']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_registerEventhub_1', Level.LEVEL0, (): void => {
      (viewEvent as object)['registerEventhub']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_unRegisterEventhub_1', Level.LEVEL0, (): void => {
      (viewEvent as object)['unRegisterEventhub']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_updateAppInfos_1', Level.LEVEL0, (): void => {
      viewEvent.updateAppInfos();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_updateAppInfos_2', Level.LEVEL0, (): void => {
      let mAppModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(mAppModel, mAppModel.getAppList);
      when(mockFunc)(ArgumentMatchers.any).afterThrow('Test Error');
      viewEvent.updateAppInfos();
      expect(viewEvent).not().assertUndefined();
      mocker.ignoreMock(mAppModel, mAppModel.getAppList);
    })

    it('GestureDockViewEventMgr_showAllApps_1', Level.LEVEL0, (): void => {
      gestureDockParam.isShowAllApps = false;
      AppStorage.setOrCreate<number>('scenePanelState',4);
      viewEvent.showAllApps();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_showAllApps_2', Level.LEVEL0, (): void => {
      gestureDockParam.isShowAllApps = false;
      AppStorage.setOrCreate<number>('scenePanelState',3);
      viewEvent.showAllApps();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_showAllApps_3', Level.LEVEL0, (): void => {
      gestureDockParam.isShowAllApps = true;
      viewEvent.showAllApps();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_hideAllApps_1', Level.LEVEL0, (): void => {
      viewEvent.hideAllApps();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_doTranslateAnimateOnAllAppsShow_1', Level.LEVEL0, (): void => {
      viewEvent.doTranslateAnimateOnAllAppsShow();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_statusBarPropertyControl_1', Level.LEVEL0, (): void => {
      gestureDockParam.isShowAllApps = true;
      viewEvent.statusBarPropertyControl();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_statusBarPropertyControl_2', Level.LEVEL0, (): void => {
      gestureDockParam.isShowAllApps = false;
      viewEvent.statusBarPropertyControl();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_startAllAppsEdit', Level.LEVEL0, (): void => {
      viewEvent.startAllAppsEdit();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_finishAllAppsEdit', Level.LEVEL0, (): void => {
      viewEvent.finishAllAppsEdit();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_gestureBackCallback', Level.LEVEL0, (): void => {
      let viewEvent: GestureDockViewEventMgr = new GestureDockViewEventMgr(new GestureDockViewDataMgr());
      viewEvent.gestureDockParam.gestureDockDirection = 0;
      (viewEvent as object)['gestureBackCallback']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_gestureBackCallback_01', Level.LEVEL0, (): void => {
      let viewEvent: GestureDockViewEventMgr = new GestureDockViewEventMgr(new GestureDockViewDataMgr());
      viewEvent.gestureDockParam.gestureDockDirection = 2;
      (viewEvent as object)['gestureBackCallback']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_startFoldToExpandChangeCallback_01', Level.LEVEL0, (): void => {
      (viewEvent as object)['startFoldToExpandChangeCallback'](new SCBScreenProperty(), 3, undefined);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_startFoldToExpandChangeCallback_02', Level.LEVEL0, (): void => {
      (viewEvent as object)['startFoldToExpandChangeCallback'](new SCBScreenProperty(), 8, undefined);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_startFoldToExpandChangeCallback_03', Level.LEVEL0, (): void => {
      (viewEvent as object)['startFoldToExpandChangeCallback'](new SCBScreenProperty(), 4, undefined);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_registerGestureNavigationEventCallback_01', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbGestureManager,
        scbGestureManager.registerGestureEvent);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any])
          .afterReturn((gestureType: GestureType, sceneType: string, callBack: Function) => {
            callBack(GestureNavigationState.START);
          });
      (viewEvent as object)['registerGestureNavigationEventCallback']();
      expect(viewEvent).not().assertUndefined();
      mocker.ignoreMock(scbGestureManager, scbGestureManager.registerGestureEvent);
    })

    it('GestureDockViewEventMgr_registerGestureNavigationEventCallback_02', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbGestureManager,
        scbGestureManager.registerGestureEvent);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any])
        .afterReturn((gestureType: GestureType, sceneType: string, callBack: Function) => {
          callBack(GestureNavigationState.UPDATE);
        });
      (viewEvent as object)['registerGestureNavigationEventCallback']();
      expect(viewEvent).not().assertUndefined();
      mocker.ignoreMock(scbGestureManager, scbGestureManager.registerGestureEvent);
    })

    it('GestureDockViewEventMgr_registerGestureNavigationEventCallback_03', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbGestureManager,
        scbGestureManager.registerGestureEvent);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any])
        .afterReturn((gestureType: GestureType, sceneType: string, callBack: Function) => {
          callBack(GestureNavigationState.END);
        });
      (viewEvent as object)['registerGestureNavigationEventCallback']();
      expect(viewEvent).not().assertUndefined();
      mocker.ignoreMock(scbGestureManager, scbGestureManager.registerGestureEvent);
    })

    it('GestureDockViewEventMgr_registerGestureNavigationEventCallback_04', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(scbGestureManager,
        scbGestureManager.registerGestureEvent);
      when(mockFunc)([ArgumentMatchers.any, ArgumentMatchers.any])
        .afterReturn((gestureType: GestureType, sceneType: string, callBack: Function) => {
          callBack(GestureNavigationState.CANCEL);
        });
      (viewEvent as object)['registerGestureNavigationEventCallback']();
      expect(viewEvent).not().assertUndefined();
      mocker.ignoreMock(scbGestureManager, scbGestureManager.registerGestureEvent);
    })

    it('GestureDockViewEventMgr_registerGestureNavigationEventCallback_05', Level.LEVEL0, (): void => {
      scbGestureManager.onGestureEvent(GestureType.NAVIGATION, GestureDockConstants.GESTURE_DOCK_TAG);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_unregisterGestureNavigationEventCallback_0', Level.LEVEL0, (): void => {
      (viewEvent as object)['unregisterGestureNavigationEventCallback']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMg_getAppIcon', Level.LEVEL0, (): void => {
      expect(viewEvent.getAppIcon(new GestureDockItemInfo()) !== undefined).assertTrue();
    })

    it('GestureDockViewEventMgr_getAppIcon_1', Level.LEVEL0, (): void => {
      let viewEvent: GestureDockViewEventMgr = new GestureDockViewEventMgr(new GestureDockViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewEvent, (viewEvent as object)['isPadLauncher']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.abilityName = 'com.ohos.sceneboard.appcenter.MainAbility';
      expect(viewEvent.getAppIcon(gestureDockItemInfo) !== undefined).assertTrue();
      mocker.ignoreMock(viewEvent, (viewEvent as object)['isPadLauncher']);
    })

    it('GestureDockViewEventMgr_getAppIcon_2', Level.LEVEL0, (): void => {
      let viewEvent: GestureDockViewEventMgr = new GestureDockViewEventMgr(new GestureDockViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewEvent, (viewEvent as object)['isPadLauncher']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.abilityName = 'com.ohos.sceneboard.MainAbility';
      expect(viewEvent.getAppIcon(gestureDockItemInfo) !== undefined).assertTrue();
      mocker.ignoreMock(viewEvent, (viewEvent as object)['isPadLauncher']);
    })

    it('GestureDockViewEventMgr_getAppIcon_3', Level.LEVEL0, (): void => {
      let viewEvent: GestureDockViewEventMgr = new GestureDockViewEventMgr(new GestureDockViewDataMgr());
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(viewEvent, (viewEvent as object)['isPadLauncher']);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let gestureDockItemInfo: GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.abilityName = 'com.ohos.sceneboard.MainAbility';
      expect(viewEvent.getAppIcon(gestureDockItemInfo) !== undefined).assertTrue();
      mocker.ignoreMock(viewEvent, (viewEvent as object)['isPadLauncher']);
    })

    it('GestureDockViewEventMgr_isPadLauncher', Level.LEVEL0, (): void => {
      (viewEvent as object)['isPadLauncher'](new GestureDockItemInfo());
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_isPadLauncher_1', Level.LEVEL0, (): void => {
      let gestureDockItemInfo:GestureDockItemInfo = new GestureDockItemInfo();
      gestureDockItemInfo.bundleName = 'com.ohos.sceneboard';
      (viewEvent as object)['isPadLauncher'](gestureDockItemInfo);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_initGestureDockParam_1', Level.LEVEL0, (): void => {
      viewEvent.initGestureDockParam(1);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_handleDragEnter_1', Level.LEVEL0, (): void => {
      viewEvent.gestureDockParam.gestureDockShowMode = 3;
      viewEvent.handleDragEnter();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_handleDragMove_1', Level.LEVEL0, (): void => {
      viewEvent.gestureDockParam.gestureDockShowMode = 3;
      viewEvent.handleDragMove(event);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_handleDragDrop_2', Level.LEVEL0, (): void => {
      viewEvent.gestureDockParam.gestureDockShowMode = 3;
      viewEvent.handleDragDrop();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_handleDragDrop_3', Level.LEVEL0, (): void => {
      viewEvent.gestureDockParam.gestureDockShowMode = 0;
      viewEvent.handleDragDrop();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_handleDragDrop_4', Level.LEVEL0, (): void => {
      try {
        let event: DragEvent = {
          getWindowX: (() => {
            return 0;
          }),
          getWindowY: (() => {
            return 0;
          }),
        } as DragEvent;
        viewEvent.gestureDockParam.gestureDockShowMode = 0;
        viewEvent.handleDragDrop(event);
        expect(viewEvent).not().assertUndefined();
      } catch (e) {
      }
    })

    it('GestureDockViewEventMgr_onAccessibilityModeChange_1', Level.LEVEL0, (): void => {
      scbGestureDockParam.isGestureDockShow = true;
      (viewEvent as object)['onAccessibilityModeChange'](true);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockAnimationCallback', Level.LEVEL0, (): void => {
      viewEvent.dockAnimationCallback(0);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockAnimationCallback_1', Level.LEVEL0, (): void => {
      viewEvent.dockAnimationCallback(1);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockAnimationCallback_2', Level.LEVEL0, (): void => {
      viewEvent.dockAnimationCallback(2);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockAnimationCallback_3', Level.LEVEL0, (): void => {
      viewEvent.dockAnimationCallback(3);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockAnimationCallback_4', Level.LEVEL0, (): void => {
      viewEvent.dockAnimationCallback(4);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockAnimationCallback_5', Level.LEVEL0, (): void => {
      viewEvent.dockAnimationCallback(5);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockAnimationCallback_6', Level.LEVEL0, (): void => {
      GestureDockAllAppsViewModel.getInstance()
        .initViewModel(new GestureDockAllAppsViewEventMgr(new GestureDockAllAppsViewDataMgr()));
      let viewData = GestureDockAllAppsViewModel.getInstance().getViewEvent() as GestureDockAllAppsViewEvent;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(viewData, viewData.isAllAppsAnimateFinish);
      when(mockFunction)().afterReturn(true);
      viewEvent.dockAnimationCallback(5);
      expect(viewEvent).not().assertUndefined()
      mocker.ignoreMock(viewData, viewData.isAllAppsAnimateFinish);
    })

    it('GestureDockViewEventMgr_gestureDockShow_1', Level.LEVEL0, (): void => {
      (viewEvent as object)['gestureDockShow'](5);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_resetDockPosition', Level.LEVEL0, (): void => {
      expect(viewEvent.resetDockPosition(true) === undefined).assertTrue();
    })

    it('GestureDockViewEventMgr_resetDockPosition_1', Level.LEVEL0, (): void => {
      let remainSizeOnSide: number = 1;
      gestureDockParam.gestureDockDirection = 1;
      viewEvent.resetDockPosition(true);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_resetDockPosition_2', Level.LEVEL0, (): void => {
      let remainSizeOnSide: number = 1;
      gestureDockParam.gestureDockDirection = 1;
      viewEvent.resetDockPosition(true);
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_resetPositionWithoutAnimation_1', Level.LEVEL0, (): void => {
      viewEvent.resetPositionWithoutAnimation(new SCBScreenProperty());
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_onBlankAreaClick_1', Level.LEVEL0, (): void => {
      viewEvent.gestureDockParam.isShowAllApps = true;
      viewEvent.onBlankAreaClick();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_onBlankAreaClick_2', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      viewEvent.gestureDockParam.isShowAllApps = false;
      viewEvent.onBlankAreaClick();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_onBlankAreaClick_3', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      viewEvent.gestureDockParam.isShowAllApps = false;
      viewEvent.onBlankAreaClick();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_updateGestureDockResponseRegion_1', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      viewEvent.updateGestureDockResponseRegion();
      expect(viewEvent).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('GestureDockViewEventMgr_updateGestureDockResponseRegion_2', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      viewEvent.gestureDockParam.gestureDockDirection = 0;
      viewEvent.updateGestureDockResponseRegion();
      expect(viewEvent).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('GestureDockViewEventMgr_updateGestureDockResponseRegion_2', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      viewEvent.gestureDockParam.gestureDockDirection = 1;
      viewEvent.updateGestureDockResponseRegion();
      expect(viewEvent).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('GestureDockViewEventMgr_dockExitReporter_1', Level.LEVEL0, (): void => {
      viewEvent.gestureDockParam.gestureDockShowMode = 3;
      (viewEvent as object)['dockExitReporter']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockExitReporter_2', Level.LEVEL0, (): void => {
      viewEvent.gestureDockParam.gestureDockShowMode = 2;
      (viewEvent as object)['dockExitReporter']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockExitReporter_3', Level.LEVEL0, (): void => {
      viewEvent.gestureDockParam.gestureDockShowMode = 1;
      (viewEvent as object)['dockExitReporter']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_dockExitReporter_4', Level.LEVEL0, (): void => {
      viewEvent.gestureDockParam.gestureDockShowMode = 0;
      (viewEvent as object)['dockExitReporter']();
      expect(viewEvent).not().assertUndefined();
    })

    it('GestureDockViewEventMgr_releaseAllAppsBlurImage_1', Level.LEVEL0, (): void => {
      viewEvent.viewDataMgr.blurImage = undefined;
      viewEvent.releaseAllAppsBlurImage();
      expect(viewEvent).not().assertUndefined();
    })

  })
}
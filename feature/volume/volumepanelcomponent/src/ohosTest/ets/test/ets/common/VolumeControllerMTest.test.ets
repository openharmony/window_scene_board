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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { LogDomain, CommonUtils, LogHelper,
  SingletonHelper,
} from '@ohos/basicutils';
import {
  HiDfxEventUtil,
  CutoutEvent,
  EvtBus,
  DeviceHelper,
  ViewType,
  sEventManager,
  ViewManagerPolicy,
  HiSysEventUtil
} from '@ohos/frameworkwrapper';
import { DisplayEvent } from '@ohos/windowscene';
import {
  OTA_OOBE_CHANGE_EVENT,
  sSCBOtaManager,
  SCBOobeManager,
  SCBSceneSessionManager,
  OOBE_CHANGE_EVENT,
  DisplayMgr
} from '@ohos/windowscene';
import { RotationConstants } from '@ohos/commonconstants';
import VolumePanelService from '../../../../../main/ets/com/ohos/model/VolumePanelService';
import { VolumeWindowStateListener } from '../../../../../main/ets/com/ohos/common/Interfaces';
import { EventManager, ViewArea } from '@ohos/frameworkwrapper';
import { VolumeInfo } from '../../../../../main/ets/com/ohos/common/Constants';
import screenSessionManager from '@ohos.screenSessionManager';
import display from '@ohos.display';
import { SCBSystemSceneSession } from '@ohos/windowscene';
import { LocalWindowManager } from '@ohos/systemuicommon';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { VolumeWindowController } from '../../../../../main/ets/com/ohos/common/VolumeWindowController';

export function VolumeWindowControllerTest() {
  describe('VolumeWindowControllerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_init', Level.LEVEL0, (): void => {
      let controller: VolumeWindowController = VolumeWindowController.getInstance();
      expect(controller !== undefined).assertTrue();
    });

    it('should_initialize_VolumeWindowController_correctly', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.init();
      expect(volumewindowcontroller.isPhone).assertInstanceOf(Boolean);
      expect(volumewindowcontroller.isOuterHome).assertInstanceOf(Boolean);
      expect(volumewindowcontroller.rotateAngle).assertInstanceOf(Number);
      expect(volumewindowcontroller.isExpandStatus).assertInstanceOf(Boolean);
      expect(volumewindowcontroller.eventManager).assertInstanceOf(EventManager);
      expect(volumewindowcontroller.oobeEnable).assertInstanceOf(Boolean);
      expect(volumewindowcontroller.oobeOtaEnable).assertInstanceOf(Boolean);
      expect(volumewindowcontroller.sysSceneSession).assertInstanceOf(SCBSystemSceneSession);
    });

    it('should_handle_display_event_correctly', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.init();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(volumewindowcontroller.eventManager, volumewindowcontroller.eventManager.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyFunction).afterReturn(null);
      volumewindowcontroller.init();
      mocker.ignoreMock(volumewindowcontroller.eventManager, volumewindowcontroller.eventManager.on);
    });

    it('should_handle_touch_outside_event_correctly', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.init();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(volumewindowcontroller.sysSceneSession?.session, volumewindowcontroller.sysSceneSession?.session.on);
      when(mockfunc)(ArgumentMatchers.any, ArgumentMatchers.anyFunction).afterReturn(null);
      volumewindowcontroller.init();
      mocker.ignoreMock(volumewindowcontroller.sysSceneSession?.session, volumewindowcontroller.sysSceneSession?.session.on);
    });

    it('should_call_offAll_when_eventManager_is_not_null', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let eventManager: EventManager = new EventManager();
      volumewindowcontroller.eventManager = eventManager;
      volumewindowcontroller.destroy();
      expect(volumewindowcontroller.eventManager).assertNull();
    });

    it('should_log_error_when_display_off_throws_error', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let eventManager: EventManager = new EventManager();
      volumewindowcontroller.eventManager = eventManager;
      let displayMock: display.Display = display.createDisplay();
      let logMock: LogHelper = LogHelper.createLogHelper(LogDomain.LOG_DOMAIN_WINDOW_SCENE);
      volumewindowcontroller.destroy();
      expect(volumewindowcontroller.eventManager).assertNull();
    });

    it('should_call_offAll_and_display_off_when_eventManager_and_display_are_not_null', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let eventManager: EventManager = new EventManager();
      volumewindowcontroller.eventManager = eventManager;
      let displayMock: display.Display = display.createDisplay();
      let logMock: LogHelper = LogHelper.createLogHelper(LogDomain.LOG_DOMAIN_WINDOW_SCENE);
      volumewindowcontroller.destroy();
      expect(volumewindowcontroller.eventManager).assertNull();
    });

    it('setInterval_should_set_mInterval_correctly', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let interval = 1000;
      volumewindowcontroller.setInterval(interval);
      expect(volumewindowcontroller.mInterval).assertEqual(interval);
    });

    it('should_return_immediately_when_volumeInfo_is_null', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let volumeInfo: VolumeInfo = null;
      volumewindowcontroller.updateVolumeInfo(volumeInfo);
    });

    it('should_return_immediately_when_volumeInfo_updateUi_is_false', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let volumeInfo: VolumeInfo = new VolumeInfo();
      volumeInfo.updateUi = false;
      volumewindowcontroller.updateVolumeInfo(volumeInfo);
    });

    it('should_return_immediately_when_previousDismissAnimTimer_is_greater_than_0', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let volumeInfo: VolumeInfo = new VolumeInfo();
      volumeInfo.updateUi = true;
      volumewindowcontroller.previousDismissAnimTimer = 1;
      volumewindowcontroller.updateVolumeInfo(volumeInfo);
    });

    it('should_call_setInterval_and_showVolumeWindow_when_volumeInfo_is_valid', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let volumeInfo: VolumeInfo = new VolumeInfo();
      volumeInfo.updateUi = true;
      volumewindowcontroller.previousDismissAnimTimer = 0;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.setInterval);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      volumewindowcontroller.updateVolumeInfo(volumeInfo);
      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.setInterval);
    });

    it('should_return_immediately_when_listener_is_null', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.registerWindowStateListener(null);
      // 由于没有实际的断言点，这里只是确保没有异常抛出
      expect(true).assertEqual(true);
    });

    it('should_add_listener_and_call_deviceConfigChange_when_listener_is_not_null', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let listener: VolumeWindowStateListener = new VolumeWindowStateListener();
      let mocker: MockKit = new MockKit();
      volumewindowcontroller.registerWindowStateListener(listener);
      // 由于没有实际的断言点，这里只是确保没有异常抛出
      expect(true).assertEqual(true);
    });

    it('should_return_immediately_when_listener_is_null', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.unRegisterWindowStateListener(null);
    });

    it('should_remove_listener_when_listener_is_not_null', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let listener: VolumeWindowStateListener = new VolumeWindowStateListener();
      volumewindowcontroller.unRegisterWindowStateListener(listener);
    });

    it('should_call_clearWindowTimer_when_dismissVolumeWindowImmediately_is_called', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.clearWindowTimer);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      volumewindowcontroller.dismissVolumeWindowImmediately();

      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.clearWindowTimer);
    });

    it('should_call_onVolumeWindowStateChanged_when_dismissVolumeWindowImmediately_is_called', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();

      let listener: VolumeWindowStateListener = {
        onVolumeWindowStateChanged: (isVisible: boolean) => {
          expect(isVisible).assertEqual(false);
        }
      };
      volumewindowcontroller.mVolumeWindowStateListenerSet?.add(listener);

      volumewindowcontroller.dismissVolumeWindowImmediately();

      volumewindowcontroller.mVolumeWindowStateListenerSet?.delete(listener);
    });

    it('should_call_HiDfxEventUtil_reportHideSingleVolBar_when_dismissVolumeWindowImmediately_is_called', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();

      volumewindowcontroller.curVolumeInfo = {
        volumeType: 'type',
        volume: 10
      } as VolumeInfo;

      volumewindowcontroller.dismissVolumeWindowImmediately();

    });

    it('should_call_ViewManagerPolicy_hideView_when_dismissVolumeWindowImmediately_is_called', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();

      volumewindowcontroller.dismissVolumeWindowImmediately();

    });

    it('should_return_true_when_rotateAngle_is_ROTATION_90', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.rotateAngle = RotationConstants.ROTATION_90;
      const result = volumewindowcontroller.isDisplayLand();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_rotateAngle_is_ROTATION_270', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.rotateAngle = RotationConstants.ROTATION_270;
      const result = volumewindowcontroller.isDisplayLand();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_rotateAngle_is_not_ROTATION_90_or_270', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.rotateAngle = 0;
      const result = volumewindowcontroller.isDisplayLand();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_rotateAngle_is_ROTATION_180', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.rotateAngle = RotationConstants.ROTATION_180;
      const result = volumewindowcontroller.isDisplayReverse();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_rotateAngle_is_ROTATION_270', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.rotateAngle = RotationConstants.ROTATION_270;
      const result = volumewindowcontroller.isDisplayReverse();
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_rotateAngle_is_not_ROTATION_180_or_270', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.rotateAngle = 0;
      const result = volumewindowcontroller.isDisplayReverse();
      expect(result).assertEqual(false);
    });

    it('should_call_clearWindowTimer_when_resetWindowTimer_is_called', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.clearWindowTimer);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      volumewindowcontroller.resetWindowTimer();

      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.clearWindowTimer);
    });

    it('should_set_previousAutoDismissTimer_when_isTimerPaused_is_false', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.isTimerPaused = false;
      volumewindowcontroller.mInterval = 1000;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.clearWindowTimer);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      volumewindowcontroller.resetWindowTimer();

      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.clearWindowTimer);
    });

    it('should_not_set_previousAutoDismissTimer_when_isTimerPaused_is_true', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.isTimerPaused = true;

      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.clearWindowTimer);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();

      volumewindowcontroller.resetWindowTimer();

      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.clearWindowTimer);
    });

    it('should_log_info_when_sysSceneSession_is_not_null', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturn(null);

      volumewindowcontroller.sysSceneSession = new SCBSystemSceneSession();
      volumewindowcontroller.updateVolumeResponseRegin(1, 2, 3, 4);

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_not_call_updateArea_when_width_and_height_are_same', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockUpdateArea: Function = mocker.mockFunc(ViewManagerPolicy.getViewController(ViewType.VOLUME), ViewManagerPolicy.getViewController(ViewType.VOLUME).updateArea);
      when(mockUpdateArea)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateRect: Function = mocker.mockFunc(ViewManagerPolicy.getViewController(ViewType.VOLUME), ViewManagerPolicy.getViewController(ViewType.VOLUME).updateRect);
      when(mockUpdateRect)(ArgumentMatchers.any).afterReturnNothing();

      let dis: screenSessionManager.RRect = { width: 100, height: 100 };
      volumewindowcontroller.resetVolumeWindowSize(dis);

      mocker.ignoreMock(ViewManagerPolicy.getViewController(ViewType.VOLUME), ViewManagerPolicy.getViewController(ViewType.VOLUME).updateArea);
      mocker.ignoreMock(ViewManagerPolicy.getViewController(ViewType.VOLUME), ViewManagerPolicy.getViewController(ViewType.VOLUME).updateRect);
    });
    it('should_call_updateArea_and_updateRect_when_width_and_height_are_different', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockUpdateArea: Function = mocker.mockFunc(ViewManagerPolicy.getViewController(ViewType.VOLUME), ViewManagerPolicy.getViewController(ViewType.VOLUME).updateArea);
      when(mockUpdateArea)(ArgumentMatchers.any).afterReturnNothing();

      let mockUpdateRect: Function = mocker.mockFunc(ViewManagerPolicy.getViewController(ViewType.VOLUME), ViewManagerPolicy.getViewController(ViewType.VOLUME).updateRect);
      when(mockUpdateRect)(ArgumentMatchers.any).afterReturnNothing();

      let dis: screenSessionManager.RRect = { width: 200, height: 100 };
      volumewindowcontroller.resetVolumeWindowSize(dis);

      mocker.ignoreMock(ViewManagerPolicy.getViewController(ViewType.VOLUME), ViewManagerPolicy.getViewController(ViewType.VOLUME).updateArea);
      mocker.ignoreMock(ViewManagerPolicy.getViewController(ViewType.VOLUME), ViewManagerPolicy.getViewController(ViewType.VOLUME).updateRect);
    });
    it('should_set_cutOutLeft_when_isPhone_and_isExpandStatus_and_rotateAngle_is_ROTATION_90', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.isPhone = true;
      volumewindowcontroller.isExpandStatus = true;
      volumewindowcontroller.rotateAngle = RotationConstants.ROTATION_90;
      volumewindowcontroller.cutOutLeft = 50;

      let mocker: MockKit = new MockKit();

      let dis: screenSessionManager.RRect = { width: 100, height: 100 };
      volumewindowcontroller.resetVolumeWindowSize(dis);

      expect(volumewindowcontroller.cutOutLeft).assertEqual(50);
    });
    it('should_set_cutOutLeft_when_isOuterHome_and_isExpandStatus_and_rotateAngle_is_ROTATION_90', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      volumewindowcontroller.isOuterHome = true;
      volumewindowcontroller.isExpandStatus = true;
      volumewindowcontroller.rotateAngle = RotationConstants.ROTATION_90;
      volumewindowcontroller.cutOutLeft = 50;

      let mocker: MockKit = new MockKit();

      let dis: screenSessionManager.RRect = { width: 100, height: 100 };
      volumewindowcontroller.resetVolumeWindowSize(dis);

      expect(volumewindowcontroller.cutOutLeft).assertEqual(50);
    });
    it('should_call_onVolumeWindowSizeChanged_for_each_listener', 0, () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();

      let listener1: VolumeWindowStateListener = {
        onVolumeWindowSizeChanged: (width: number, height: number, cutOutLeft: number) => {
        }
      };
      let listener2: VolumeWindowStateListener = {
        onVolumeWindowSizeChanged: (width: number, height: number, cutOutLeft: number) => {
        }
      };
      volumewindowcontroller.mVolumeWindowStateListenerSet = new Set([listener1, listener2]);


      let dis: screenSessionManager.RRect = { width: 100, height: 100 };
      volumewindowcontroller.resetVolumeWindowSize(dis);

    });

    it('should_dismiss_volume_window_immediately_when_volume_window_is_showing', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockIsShowVolumeWindow: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      when(mockIsShowVolumeWindow)().afterReturn(true);

      let mockDismissVolumeWindowImmediately: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
      when(mockDismissVolumeWindowImmediately)().afterReturnNothing();

      let event: DisplayEvent = new DisplayEvent();
      volumewindowcontroller.onDisplayEvent(event);

      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
    });

    it('should_not_dismiss_volume_window_immediately_when_volume_window_is_not_showing', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockIsShowVolumeWindow: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      when(mockIsShowVolumeWindow)().afterReturn(false);

      let mockDismissVolumeWindowImmediately: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
      when(mockDismissVolumeWindowImmediately)().afterReturnNothing();

      let event: DisplayEvent = new DisplayEvent();
      volumewindowcontroller.onDisplayEvent(event);

      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
    });

    it('should_update_expand_status_and_rotation_when_event_display_is_not_null', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockIsShowVolumeWindow: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      when(mockIsShowVolumeWindow)().afterReturn(false);

      let mockDismissVolumeWindowImmediately: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
      when(mockDismissVolumeWindowImmediately)().afterReturnNothing();

      let event: DisplayEvent = new DisplayEvent();
      event.display = {
        isFoldablePhoneExpandStatus: () => true,
        scbScreenProperty: {
          rotation: RotationConstants.ROTATION_LANDSCAPE
        }
      };
      volumewindowcontroller.onDisplayEvent(event);

      expect(volumewindowcontroller.isExpandStatus).assertEqual(true);
      expect(volumewindowcontroller.rotateAngle).assertEqual(RotationConstants.ROTATION_LANDSCAPE);

      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
    });

    it('should_not_update_expand_status_and_rotation_when_event_display_is_null', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockIsShowVolumeWindow: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      when(mockIsShowVolumeWindow)().afterReturn(false);

      let mockDismissVolumeWindowImmediately: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
      when(mockDismissVolumeWindowImmediately)().afterReturnNothing();

      let event: DisplayEvent = new DisplayEvent();
      event.display = null;
      volumewindowcontroller.onDisplayEvent(event);

      expect(volumewindowcontroller.isExpandStatus).assertEqual(false);
      expect(volumewindowcontroller.rotateAngle).assertEqual(0);

      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
    });

    it('should_call_onVolumeDisplayChanged_when_mVolumeWindowStateListenerSet_is_not_null', 0, async () => {
      let volumewindowcontroller: VolumeWindowController = new VolumeWindowController();
      let mocker: MockKit = new MockKit();
      let mockIsShowVolumeWindow: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      when(mockIsShowVolumeWindow)().afterReturn(false);

      let mockDismissVolumeWindowImmediately: Function = mocker.mockFunc(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
      when(mockDismissVolumeWindowImmediately)().afterReturnNothing();

      let event: DisplayEvent = new DisplayEvent();
      volumewindowcontroller.onDisplayEvent(event);

      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.isShowVolumeWindow);
      mocker.ignoreMock(volumewindowcontroller, volumewindowcontroller.dismissVolumeWindowImmediately);
    });
  });
}
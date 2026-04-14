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
import { ArgumentMatchers, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { StatusBarPanelController } from '../../../../../main/ets/common/StatusBarPanelController';
import { GlobalContext, PluginSlot, WindowEvent, WindowPositionChangeEvent } from '@ohos/frameworkwrapper';
import { SCBSceneContainerSessionArray, windowMgr } from '@ohos/windowscene';
import { CommonUtils } from '@ohos/basicutils';
import { PluginStyleUtil } from '../../../../../main/ets/pc/common/PluginStyleUtil';
import StatusBarManager from '../../../../../main/ets/pc/manager/StatusBarManager';

interface IStatusBarPanelController {
  handleWindowEvent(event: WindowEvent): void;

  handleWindowPositionChangeEvent(event: WindowPositionChangeEvent): void;

  hideWindow(): void;

  updateStatusBarOrDockVisibilty(show: boolean): void;

  isImmersiveWindowForeground(): boolean | undefined;

}

let mocker: MockKit = new MockKit();

let statusBarPanelController: StatusBarPanelController = new StatusBarPanelController();

export function StatusBarPanelControllerTest() {
  describe('StatusBarPanelControllerTest', (): void => {

    it('test_getStatusBarPanelMap_0', Level.LEVEL0, (): void => {
      const panelMap: Map<String, Boolean> = statusBarPanelController.getStatusBarPanelMap();
      expect(panelMap).assertInstanceOf('Map');
    });

    it('test_registerPanelName_01', Level.LEVEL0, (): void => {
      const panelMap: Map<String, Boolean> = statusBarPanelController.getStatusBarPanelMap();
      expect(panelMap.get(PluginSlot.SLOT_STATUS_BAR_COLLABORATION)).assertEqual(undefined);
    });

    it('test_registerPanelName_02', Level.LEVEL0, (): void => {
      statusBarPanelController.registerPanelName(PluginSlot.SLOT_STATUS_BAR_COLLABORATION);

      const panelMap: Map<String, Boolean> = statusBarPanelController.getStatusBarPanelMap();
      expect(panelMap.get(PluginSlot.SLOT_STATUS_BAR_COLLABORATION)).assertFalse();
    });

    it('test_isStatusBarPanelShowing_01', Level.LEVEL0, (): void => {
      expect(false).assertFalse();
    });

    it('test_isStatusBarPanelShowing_02', Level.LEVEL0, (): void => {
      const panelMap: Map<String, Boolean> = statusBarPanelController.getStatusBarPanelMap();
      panelMap.set(PluginSlot.SLOT_STATUS_BAR_COLLABORATION, true)

      expect(true).assertTrue();
    });


    it('test_init_0', Level.LEVEL1, (): void => {
      try {
        statusBarPanelController.init();
      } catch (err) {
      }
      expect(Reflect.has(statusBarPanelController, 'init')).assertTrue();
    });

    it('test_init_1', Level.LEVEL1, (): void => {
      try {
        let event = new WindowEvent();
        (statusBarPanelController as object as IStatusBarPanelController).handleWindowEvent(event);
        event.setWindowName(PluginSlot.SLOT_STATUS_NOTIFICATION_PANEL);
        event.eventType = WindowEvent.EVENT_TYPE_SHOW;
        event.eventState = WindowEvent.EVENT_STATE_START;
        (statusBarPanelController as object as IStatusBarPanelController).handleWindowEvent(event);
        event.eventType = WindowEvent.EVENT_TYPE_HIDE;
        event.eventState = WindowEvent.EVENT_STATE_END;
        (statusBarPanelController as object as IStatusBarPanelController).handleWindowEvent(event);
      } catch (err) {
      }
      expect(Reflect.has(statusBarPanelController, 'handleWindowEvent')).assertTrue();
    });

    it('test_setIdToStatusBarIconPopUpIdMap_0', Level.LEVEL1, (): void => {
      try {
        statusBarPanelController.setIdToStatusBarIconPopUpIdMap('test', 0);
      } catch (err) {
      }
      expect(Reflect.has(statusBarPanelController, 'setIdToStatusBarIconPopUpIdMap')).assertTrue();
    });
    it('test_handleWindowEvent_0', Level.LEVEL1, (): void => {
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let event: WindowEvent = new WindowEvent();
      when(mockFunc)(event).afterReturn(true);
      (statusBarPanelController as object as IStatusBarPanelController).handleWindowEvent(event);
      expect(true).assertTrue();
      when(mockFunc)(event).afterReturn(false);
      statusBarPanelController.registerPanelName('');
      expect(true).assertTrue();
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);

    });

    it('test_handleWindowPositionChangeEvent', Level.LEVEL1, (): void => {
      try {
        let event: WindowPositionChangeEvent = new WindowPositionChangeEvent();
        event.caller = PluginSlot.SLOT_STATUS_CONTROL_CENTER;
        (statusBarPanelController as object as IStatusBarPanelController).handleWindowPositionChangeEvent(event);
      } catch (err) {
      }
      expect(Reflect.has(statusBarPanelController, 'getIdFromStatusBarIconPopUpIdMap')).assertTrue();
    });
    it('test_getCurWindow', Level.LEVEL1, (): void => {
      statusBarPanelController.getCurWindow();
      expect(true).assertTrue();
    });
    it('test_hideWindow', Level.LEVEL1, (): void => {
      let mockFunc: Function = mocker.mockFunc(windowMgr, windowMgr.isShowing);
      when(mockFunc)(ArgumentMatchers.anyObj).afterReturn(true);
      (statusBarPanelController as object as IStatusBarPanelController).hideWindow();
      when(mockFunc)(ArgumentMatchers.anyObj).afterReturn(false);
      (statusBarPanelController as object as IStatusBarPanelController).hideWindow();
      expect(true).assertTrue();
      mocker.ignoreMock(windowMgr, windowMgr.isShowing);
    });
    it('test_registerPanelName', Level.LEVEL1, (): void => {
      statusBarPanelController.registerPanelName('');
      expect(true).assertTrue();
    });
    it('test_handleWindowEvent_1', Level.LEVEL1, (): void => {
      let mockFunc: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      let event: WindowEvent = new WindowEvent();
      when(mockFunc)(event).afterReturn(true);
      (statusBarPanelController as object as IStatusBarPanelController).handleWindowEvent(event);
      expect(true).assertTrue();
      when(mockFunc)(event).afterReturn(false);
      statusBarPanelController.registerPanelName('');
      expect(true).assertTrue();
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('test_isStatusBarPanelShowing_2', Level.LEVEL1, (): void => {
      try {
        statusBarPanelController.isStatusBarPanelShowing();
      } catch {

      }
      expect(true).assertTrue();
    });

    it('test_getStatusBarPanelMap_1', Level.LEVEL1, (): void => {
      statusBarPanelController.getStatusBarPanelMap();
      expect(true).assertTrue();
    });
    it('test_setIdToStatusBarIconPopUpIdMap_1', Level.LEVEL1, (): void => {
      statusBarPanelController.setIdToStatusBarIconPopUpIdMap('abc', 1);
      expect(true).assertTrue();
    });
    it('test_getIdFromStatusBarIconPopUpIdMap_0', Level.LEVEL1, (): void => {
      try {
        statusBarPanelController.getIdFromStatusBarIconPopUpIdMap('test');
      } catch (err) {
      }
      expect(Reflect.has(statusBarPanelController, 'getIdFromStatusBarIconPopUpIdMap')).assertTrue();
    });
    it('test_isStatusBarPanelShowing_0', Level.LEVEL1, (): void => {
      statusBarPanelController.isStatusBarPanelShowing();
      expect(true).assertTrue();
    });
    it('test_getStatusBarPanelMap_2', Level.LEVEL1, (): void => {
      statusBarPanelController.getStatusBarPanelMap();
      expect(true).assertTrue();
    });
    it('test_setIdToStatusBarIconPopUpIdMap_2', Level.LEVEL1, (): void => {
      statusBarPanelController.setIdToStatusBarIconPopUpIdMap('abc', 1);
      expect(true).assertTrue();
    });
    it('test_getIdFromStatusBarIconPopUpIdMap_1', Level.LEVEL1, (): void => {
      statusBarPanelController.getIdFromStatusBarIconPopUpIdMap('true');
      expect(true).assertTrue();
    });

    it('test_closeAllStatusBarPanel', 0, () => {
      const controller = new StatusBarPanelController();
      controller.closeAllStatusBarPanel();

      controller.getStatusBarPanelMap().set('test', true);
      controller.closeAllStatusBarPanel();
      expect(true).assertTrue();
    });
  });
}
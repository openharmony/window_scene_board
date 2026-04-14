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
import {
  SingletonHelper,
  LogDomain,
  LogHelper,
  CommonUtils
} from '@ohos/basicutils';
import {
  PluginClickInfo,
  PluginParseInfo,
  PluginComponentInfo,
  PluginInfo,
  obtainLocalEvent,
  sEventManager
} from '@ohos/frameworkwrapper';
import { FASlotName } from '@ohos/commonconstants';
import { PluginComponentMgr, PluginPushListener } from '../../../main/ets/plugin/PluginComponentManager';
import { performanceMonitor } from '@kit.ArkUI';
import sDropDownPanelManager from '../../../main/ets/manager/DropDownPanelManager';
import { SubpageElementInfo } from '../../../main/ets/template/newStyle/SubpageMenuViewData';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { ToggleSubWindowController } from '../../../main/ets/windowmanager/ToggleSubWindowController';
export default function ToggleSubWindowControllerTest() {
  describe('registerSubWindowInfo_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_immediately_when_pluginSlot_is_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let pluginSlot: string = '';
      let pluginInfo: PluginInfo = new PluginComponentInfo();
      togglesubwindowcontroller.registerSubWindowInfo(pluginSlot, pluginInfo);
      expect(togglesubwindowcontroller.subWindowInfo.size).assertEqual(0);
    });
    it('should_return_immediately_when_pluginInfo_is_invalid', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let pluginSlot: string = 'slot1';
      let pluginInfo: PluginInfo = new PluginComponentInfo();
      togglesubwindowcontroller.registerSubWindowInfo(pluginSlot, pluginInfo);
      expect(togglesubwindowcontroller.subWindowInfo.size).assertEqual(0);
    });
    it('should_add_pluginInfo_to_subWindowInfo_when_pluginSlot_and_pluginInfo_are_valid', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let pluginSlot: string = 'slot1';
      let pluginInfo: PluginInfo = new PluginComponentInfo();
      togglesubwindowcontroller.registerSubWindowInfo(pluginSlot, pluginInfo);
      expect(togglesubwindowcontroller.subWindowInfo.size).assertEqual(1);
    });
    it('should_return_undefined_when_pluginSlot_is_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let result = togglesubwindowcontroller.getSubWindowInfo('');
      expect(result).assertEqual(undefined);
    });

    it('should_return_pluginInfo_when_pluginSlot_is_not_empty_and_exists_in_subWindowInfo', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();

      let mockPluginInfo: PluginInfo = new PluginComponentInfo();

      let result = togglesubwindowcontroller.getSubWindowInfo('testSlot');
      expect(result).assertDeepEquals(mockPluginInfo);
    });

    it('should_return_undefined_when_pluginSlot_is_not_empty_but_does_not_exist_in_subWindowInfo', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();


      let result = togglesubwindowcontroller.getSubWindowInfo('testSlot');
      expect(result).assertEqual(undefined);
    });

    it('should_return_immediately_when_currentShowingSlot_is_not_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentShowingSlot = 'someSlot';
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString).afterReturnNothing();

      togglesubwindowcontroller.showSubWindow('someSlot');

      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_set_currentShowingSlot_and_call_other_functions_when_currentShowingSlot_is_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentShowingSlot = '';
      let mocker: MockKit = new MockKit();
      let mockfunc1: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      let mockfunc2: Function = mocker.mockFunc(PluginComponentMgr, PluginComponentMgr.registerPushListener);
      let mockfunc3: Function = mocker.mockFunc(sEventManager, sEventManager.publish);
      let mockfunc4: Function = mocker.mockFunc(togglesubwindowcontroller, togglesubwindowcontroller.getSubWindowInfo);

      when(mockfunc1)(ArgumentMatchers.anyString).afterReturnNothing();
      when(mockfunc2)(ArgumentMatchers.any).afterReturnNothing();
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(true);
      when(mockfunc4)(ArgumentMatchers.anyString).afterReturn({ pluginParseInfo: {} } as PluginInfo);

      togglesubwindowcontroller.showSubWindow('someSlot');

      expect(togglesubwindowcontroller.currentShowingSlot).assertEqual('someSlot');
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(PluginComponentMgr, PluginComponentMgr.registerPushListener);
      mocker.ignoreMock(sEventManager, sEventManager.publish);
      mocker.ignoreMock(togglesubwindowcontroller, togglesubwindowcontroller.getSubWindowInfo);
    });

    it('should_log_currentShowingSlot_when_currentShowingSlot_is_not_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      togglesubwindowcontroller.currentShowingSlot = 'slot1';
      togglesubwindowcontroller.showSubWindowByClickInfo('slot2', new PluginClickInfo());

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_set_currentShowingSlot_and_publish_event_when_currentShowingSlot_is_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let eventManager: sEventManager = sEventManager.INSTANCE;
      let mockfuncLog: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      let mockfuncEvent: Function = mocker.mockFunc(eventManager, eventManager.publish);

      when(mockfuncLog)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();
      when(mockfuncEvent)(ArgumentMatchers.any).afterReturn(true);

      togglesubwindowcontroller.currentShowingSlot = '';
      togglesubwindowcontroller.showSubWindowByClickInfo('slot2', new PluginClickInfo());

      expect(togglesubwindowcontroller.currentShowingSlot).assertEqual('slot2');
      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(eventManager, eventManager.publish);
    });

    it('should_return_immediately_when_currentShowingSlot_is_not_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentShowingSlot = 'someSlot';
      let info: PluginClickInfo = new PluginClickInfo();
      let subInfo: SubpageElementInfo = new SubpageElementInfo();
      togglesubwindowcontroller.showCustomSubWindowByClick('someSlot', info, subInfo);
      expect(togglesubwindowcontroller.currentClickInfo).assertDeepEquals(info);
      expect(togglesubwindowcontroller.currentSubInfo).assertDeepEquals(subInfo);
    });

    it('should_set_showing_slot_and_publish_event_when_currentShowingSlot_is_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentShowingSlot = '';
      let info: PluginClickInfo = new PluginClickInfo();
      let subInfo: SubpageElementInfo = new SubpageElementInfo();
      let mocker: MockKit = new MockKit();
      let mockPublish: Function = mocker.mockFunc(sEventManager, sEventManager.publish);
      when(mockPublish)(ArgumentMatchers.any).afterReturn(true);
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();
      let mockSetShowingSlot: Function = mocker.mockFunc(togglesubwindowcontroller, togglesubwindowcontroller.setShowingSlot);
      when(mockSetShowingSlot)(ArgumentMatchers.anyString).afterReturnNothing();
      togglesubwindowcontroller.showCustomSubWindowByClick('someSlot', info, subInfo);
      expect(togglesubwindowcontroller.currentClickInfo).assertDeepEquals(info);
      expect(togglesubwindowcontroller.currentSubInfo).assertDeepEquals(subInfo);
      mocker.ignoreMock(sEventManager, sEventManager.publish);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(togglesubwindowcontroller, togglesubwindowcontroller.setShowingSlot);
    });

    it('should_log_info_when_setShowingSlot_is_called', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.setShowingSlot(FASlotName.SLOT_1);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
    it('should_set_currentShowingSlot_when_setShowingSlot_is_called', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.setShowingSlot(FASlotName.SLOT_1);

      expect(togglesubwindowcontroller.currentShowingSlot).assertEqual(FASlotName.SLOT_1);
    });

    it('should_log_info_and_publish_event_when_hideWindow_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();

      let logHelperMock: LogHelper = LogHelper.getInstance();
      let mockLogInfo: Function = mocker.mockFunc(logHelperMock, logHelperMock.showInfo);
      when(mockLogInfo)(ArgumentMatchers.anyString).afterReturnNothing();


      let eventMock: sEventManager = sEventManager.getInstance();
      let mockPublish: Function = mocker.mockFunc(eventMock, eventMock.publish);
      when(mockPublish)(ArgumentMatchers.any).afterReturn(true);


      let pluginComponentMgrMock: PluginComponentMgr = PluginComponentMgr.getInstance();
      let mockUnregisterPushListener: Function = mocker.mockFunc(pluginComponentMgrMock, pluginComponentMgrMock.unregisterPushListener);
      when(mockUnregisterPushListener)(ArgumentMatchers.any).afterReturnNothing();

      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.hideWindow();

      mocker.ignoreMock(logHelperMock, logHelperMock.showInfo);
      mocker.ignoreMock(eventMock, eventMock.publish);
      mocker.ignoreMock(pluginComponentMgrMock, pluginComponentMgrMock.unregisterPushListener);
    });
    it('should_call_hideWindow_when_onScreenOff_is_called', 0, async () => {
      let mocker: MockKit = new MockKit();
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mockfunc: Function = mocker.mockFunc(togglesubwindowcontroller, togglesubwindowcontroller.hideWindow);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);

      togglesubwindowcontroller.onScreenOff();

      mocker.ignoreMock(togglesubwindowcontroller, togglesubwindowcontroller.hideWindow);
    });

    it('should_return_false_when_currentShowingSlot_is_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentShowingSlot = '';
      const result = togglesubwindowcontroller.onBackPress();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_currentShowingSlot_is_FASlotName.WIFI_UI_EXTENSION', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentShowingSlot = FASlotName.WIFI_UI_EXTENSION;
      const result = togglesubwindowcontroller.onBackPress();
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_currentShowingSlot_is_FASlotName.BLUETOOTH_UI_EXTENSION', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentShowingSlot = FASlotName.BLUETOOTH_UI_EXTENSION;
      const result = togglesubwindowcontroller.onBackPress();
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_currentShowingSlot_is_not_empty_and_not_FASlotName.WIFI_UI_EXTENSION_or_FASlotName.BLUETOOTH_UI_EXTENSION', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentShowingSlot = 'someOtherSlot';
      const result = togglesubwindowcontroller.onBackPress();
      expect(result).assertEqual(true);
    });

    it('should_return_true_when_subWindowInfo_has_windowName', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();

      togglesubwindowcontroller.subWindowInfo.set('windowName', new PluginInfo());

      const result = togglesubwindowcontroller.isSubpageWindow('windowName');
      expect(result).assertEqual(true);

    });

    it('should_return_false_when_subWindowInfo_does_not_have_windowName', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();


      const result = togglesubwindowcontroller.isSubpageWindow('windowName');
      expect(result).assertEqual(false);

    });

    it('should_return_undefined_when_subWindowInfo_is_empty', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let result = togglesubwindowcontroller.getClickInfo(FASlotName.槽_1);
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_slot_is_not_found', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();

      let result = togglesubwindowcontroller.getClickInfo(FASlotName.槽_1);
      expect(result).assertUndefined();

    });

    it('should_return_pluginClickInfo_when_slot_is_found', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let pluginInfo: PluginInfo = new PluginInfo();
      pluginInfo.pluginParseInfo = new PluginParseInfo();
      pluginInfo.pluginParseInfo.subPageClickInfo = new PluginClickInfo();
      togglesubwindowcontroller.subWindowInfo.set(FASlotName.槽_1, pluginInfo);

      let result = togglesubwindowcontroller.getClickInfo(FASlotName.槽_1);
      expect(result).assertInstanceOf(PluginClickInfo);

    });

    it('should_return_currentShowingSlot_when_getCurrentSubPanelSlot_is_called', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(togglesubwindowcontroller, togglesubwindowcontroller.getCurrentSubPanelSlot);
      when(mockfunc)().afterReturn("mockSlot");

      togglesubwindowcontroller.currentShowingSlot = "mockSlot";
      const result = togglesubwindowcontroller.getCurrentSubPanelSlot();
      expect(result).assertEqual("mockSlot");

      mocker.ignoreMock(togglesubwindowcontroller, togglesubwindowcontroller.getCurrentSubPanelSlot);
    });
    it('should_return_undefined_when_currentClickInfo_is_undefined', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentClickInfo = undefined;
      const result = togglesubwindowcontroller.getCurrentClickInfo();
      expect(result).assertUndefined();
    });

    it('should_return_currentClickInfo_when_currentClickInfo_is_defined', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(togglesubwindowcontroller, togglesubwindowcontroller.getCurrentClickInfo);
      when(mockfunc)().afterReturn(new PluginClickInfo());
      const result = togglesubwindowcontroller.getCurrentClickInfo();
      expect(result).assertInstanceOf(PluginClickInfo);
      mocker.ignoreMock(togglesubwindowcontroller, togglesubwindowcontroller.getCurrentClickInfo);
    });

    it('should_return_undefined_when_currentSubInfo_is_undefined', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentSubInfo = undefined;
      const result = togglesubwindowcontroller.getSubpageElementInfo();
      expect(result).assertUndefined();
    });
    it('should_return_currentSubInfo_when_currentSubInfo_is_defined', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let subpageElementInfo: SubpageElementInfo = new SubpageElementInfo();
      togglesubwindowcontroller.currentSubInfo = subpageElementInfo;
      const result = togglesubwindowcontroller.getSubpageElementInfo();
      expect(result).assertDeepEquals(subpageElementInfo);
    });
    it('should_return_immediately_when_pluginInfo_pluginSlot_is_not_equal_to_currentShowingSlot', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let pluginInfo: PluginComponentInfo = new PluginComponentInfo();
      pluginInfo.pluginParseInfo = new PluginParseInfo();
      pluginInfo.pluginParseInfo.pluginSlot = 'slot1';
      togglesubwindowcontroller.currentShowingSlot = 'slot2';

      togglesubwindowcontroller.onPush(pluginInfo);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_call_hideWindowDirectly_and_hideWindow_when_pluginInfo_requestCloseWindow_is_true', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let pluginInfo: PluginComponentInfo = new PluginComponentInfo();
      pluginInfo.pluginParseInfo = new PluginParseInfo();
      pluginInfo.pluginParseInfo.pluginSlot = 'slot1';
      pluginInfo.requestCloseWindow = true;

      let mockHideWindowDirectly: Function = mocker.mockFunc(sDropDownPanelManager, sDropDownPanelManager.hideWindowDirectly);
      when(mockHideWindowDirectly)().afterReturnNothing();

      let mockHideWindow: Function = mocker.mockFunc(togglesubwindowcontroller, togglesubwindowcontroller.hideWindow);
      when(mockHideWindow)().afterReturnNothing();

      togglesubwindowcontroller.currentShowingSlot = 'slot1';
      togglesubwindowcontroller.onPush(pluginInfo);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(sDropDownPanelManager, sDropDownPanelManager.hideWindowDirectly);
      mocker.ignoreMock(togglesubwindowcontroller, togglesubwindowcontroller.hideWindow);
    });

    it('should_not_call_hideWindowDirectly_and_hideWindow_when_pluginInfo_requestCloseWindow_is_false', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let pluginInfo: PluginComponentInfo = new PluginComponentInfo();
      pluginInfo.pluginParseInfo = new PluginParseInfo();
      pluginInfo.pluginParseInfo.pluginSlot = 'slot1';
      pluginInfo.requestCloseWindow = false;

      let mockHideWindowDirectly: Function = mocker.mockFunc(sDropDownPanelManager, sDropDownPanelManager.hideWindowDirectly);
      when(mockHideWindowDirectly)().afterReturnNothing();

      let mockHideWindow: Function = mocker.mockFunc(togglesubwindowcontroller, togglesubwindowcontroller.hideWindow);
      when(mockHideWindow)().afterReturnNothing();

      togglesubwindowcontroller.currentShowingSlot = 'slot1';
      togglesubwindowcontroller.onPush(pluginInfo);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
      mocker.ignoreMock(sDropDownPanelManager, sDropDownPanelManager.hideWindowDirectly);
      mocker.ignoreMock(togglesubwindowcontroller, togglesubwindowcontroller.hideWindow);
    });
    it('should_return_pluginClickInfo_when_slot_is_found', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let pluginInfo: PluginInfo = new PluginInfo();
      pluginInfo.pluginParseInfo = new PluginParseInfo();
      pluginInfo.pluginParseInfo.subPageClickInfo = new PluginClickInfo();
      togglesubwindowcontroller.subWindowInfo.set(FASlotName.槽_1, pluginInfo);

      let result = togglesubwindowcontroller.getClickInfo(FASlotName.槽_1);
      expect(result).assertInstanceOf(PluginClickInfo);

    });

    it('should_return_currentShowingSlot_when_getCurrentSubPanelSlot_is_called', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();

      let mockfunc: Function = mocker.mockFunc(togglesubwindowcontroller, togglesubwindowcontroller.getCurrentSubPanelSlot);
      when(mockfunc)().afterReturn("mockSlot");

      togglesubwindowcontroller.currentShowingSlot = "mockSlot";
      const result = togglesubwindowcontroller.getCurrentSubPanelSlot();
      expect(result).assertEqual("mockSlot");

      mocker.ignoreMock(togglesubwindowcontroller, togglesubwindowcontroller.getCurrentSubPanelSlot);
    });
    it('should_return_undefined_when_currentClickInfo_is_undefined', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentClickInfo = undefined;
      const result = togglesubwindowcontroller.getCurrentClickInfo();
      expect(result).assertUndefined();
    });

    it('should_return_currentClickInfo_when_currentClickInfo_is_defined', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(togglesubwindowcontroller, togglesubwindowcontroller.getCurrentClickInfo);
      when(mockfunc)().afterReturn(new PluginClickInfo());
      const result = togglesubwindowcontroller.getCurrentClickInfo();
      expect(result).assertInstanceOf(PluginClickInfo);
      mocker.ignoreMock(togglesubwindowcontroller, togglesubwindowcontroller.getCurrentClickInfo);
    });

    it('should_return_undefined_when_currentSubInfo_is_undefined', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      togglesubwindowcontroller.currentSubInfo = undefined;
      const result = togglesubwindowcontroller.getSubpageElementInfo();
      expect(result).assertUndefined();
    });
    it('should_return_currentSubInfo_when_currentSubInfo_is_defined', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let subpageElementInfo: SubpageElementInfo = new SubpageElementInfo();
      togglesubwindowcontroller.currentSubInfo = subpageElementInfo;
      const result = togglesubwindowcontroller.getSubpageElementInfo();
      expect(result).assertDeepEquals(subpageElementInfo);
    });
    it('should_return_immediately_when_pluginInfo_pluginSlot_is_not_equal_to_currentShowingSlot', 0, () => {
      let togglesubwindowcontroller: ToggleSubWindowController = new ToggleSubWindowController();
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.INSTANCE;
      let mockfunc: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockfunc)(ArgumentMatchers.anyString, ArgumentMatchers.any).afterReturnNothing();

      let pluginInfo: PluginComponentInfo = new PluginComponentInfo();
      pluginInfo.pluginParseInfo = new PluginParseInfo();
      pluginInfo.pluginParseInfo.pluginSlot = 'slot1';
      togglesubwindowcontroller.currentShowingSlot = 'slot2';

      togglesubwindowcontroller.onPush(pluginInfo);

      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

  });
}

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

import { ArrayUtils } from '@ohos/basicutils';
import { FASlotName } from '@ohos/commonconstants';
import { DeviceHelper, PluginConstants, PluginInfo, PluginToggleEvent } from '@ohos/frameworkwrapper';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import sWifiController from '@ohos/wificomponent/src/main/ets/default/controller/WifiController';
import { DropdownBackPressEvent } from '../../../../../../..';
import { ToggleData } from '../../../../../../main/ets/com/ohos/common/Constants';
import { DevHelper } from '../../../../../../main/ets/com/ohos/common/DevHelper';
import { QuickToggleController } from '../../../../../../main/ets/com/ohos/controller/QuickToggleController';


export function QuickToggleControllerTest() {
  let mocker: MockKit;
  let cQuickToggleController: QuickToggleController

  describe('QuickToggleControllerTest', (): void => {

    beforeEach((): void => {
    })
    beforeAll(() => {
      mocker = new MockKit();
    })
    afterEach((): void => {

    })
    afterAll((): void => {
      mocker.clearAll();
    })


    it('QuickToggleControllerTest01', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest02', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      // isPhone mock测试
      let isPhone = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);

      when(isPhone)().afterReturn(true);
      expect(DeviceHelper.isPhone()).assertTrue();

      when(isPhone)().afterReturn(false);
      expect(DeviceHelper.isPhone()).assertFalse();
      mocker.clear(DeviceHelper);
    })

    it('QuickToggleControllerTest03', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.releaseLottieData();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest04', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getToggleData();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest05', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getDefaultQuickToggleData();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest06', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getAllToggleData();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest07', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let isDark: boolean = true;
      sQuickToggleController.getLottieDataDownResource(isDark);
      isDark = false;
      sQuickToggleController.getLottieDataDownResource(isDark);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleControllerTest08', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let isDark: boolean = true;
      sQuickToggleController.getLottieDataUpResource(isDark);
      isDark = false;
      sQuickToggleController.getLottieDataUpResource(isDark);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_handlePluginEventTest01', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let sPluginToggleEvent = new PluginToggleEvent();
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
      sPluginToggleEvent.eventType  = PluginConstants.EVENT_TYPE_UPDATE_PLUGIN;
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
      sPluginToggleEvent.eventType  = PluginConstants.EVENT_TYPE_DELETE_PLUGIN;
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_handlePluginEventTest02', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let sPluginToggleEvent = new PluginToggleEvent();
      sPluginToggleEvent.eventType = 2;
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_handlePluginEventTest03', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let sPluginToggleEvent = new PluginToggleEvent();
      sPluginToggleEvent.eventType = 3;
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_handlePluginEventTest04', 0, (): void => {
      let sQuickToggleController = new QuickToggleController();
      let sPluginToggleEvent = new PluginToggleEvent();
      sPluginToggleEvent.eventType = 4;
      (sQuickToggleController as object)['handlePluginEvent'](sPluginToggleEvent);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_addUpdatePluginTest1', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      let pluginInfos = new Array<PluginInfo>();
      (sQuickToggleController as object)['addUpdatePlugin'](pluginInfos);
      expect(ArrayUtils.isEmpty(pluginInfos)).assertTrue();
      let isEmpty = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(isEmpty)(pluginInfos).afterReturn(false);
      (sQuickToggleController as object)['addUpdatePlugin'](pluginInfos);
      expect(ArrayUtils.isEmpty(pluginInfos)).assertFalse();
      mocker.clear(ArrayUtils);
    })

    it('QuickToggleController_removePluginTest1', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      let pluginInfos = new Array<PluginInfo>();
      (sQuickToggleController as object)['removePlugin'](pluginInfos);
      let isEmpty = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);

      when(isEmpty)(pluginInfos).afterReturn(false);
      (sQuickToggleController as object)['removePlugin'](pluginInfos);

      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');

      when(isEmpty)(pluginInfos).afterReturn(true);
      (sQuickToggleController as object)['removePlugin'](pluginInfos);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
      mocker.clear(ArrayUtils);
    })

    it('QuickToggleController_removePluginTest2', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      let pluginInfos = new Array<PluginInfo>();
      (sQuickToggleController as object)['removePlugin'](pluginInfos);
      let isEmpty = mocker.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(isEmpty)(pluginInfos).afterReturn(false);
      (sQuickToggleController as object)['removePlugin'](pluginInfos);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
      mocker.clear(ArrayUtils);
    })

    it('QuickToggleController_getToggleGridTemplateTest1', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getToggleGridTemplate(2);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_createToggleControllerTest1', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.createToggleModelAndInit(FASlotName.WIFI);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_createToggleControllerTest2', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.createToggleModelAndInit(FASlotName.BLUETOOTH);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_createToggleControllerTest3', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.createToggleModelAndInit(FASlotName.MEETING);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_createToggleControllerTest4', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.createToggleModelAndInit(FASlotName.KEY_MOUSE_SHARE);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_refreshToggleDataTest1', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.refreshToggleData(true);
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_getPluginToggleDataTest1', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getPluginToggleData();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_getToggleColumnTest1', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getToggleColumn();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_getToggleColumnTest2', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getToggleColumn();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_getToggleColumnTest3', 0, async (): Promise<void> => {
      let sQuickToggleController = new QuickToggleController();
      sQuickToggleController.getToggleColumn();
      expect(sQuickToggleController.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_onToggleDataChange_Test01', 0, async (): Promise<void> => {
      let controller = new QuickToggleController();
      let refreshToggleData = mocker.mockFunc(controller, controller.refreshToggleData);
      when(refreshToggleData)(ArgumentMatchers.any).afterReturn(new ToggleData());

      controller.onToggleDataChange();

      when(refreshToggleData)(ArgumentMatchers.any).afterReturn(controller.toggleData);
      controller.onToggleDataChange();

      expect(controller.toggleDataUri).assertInstanceOf('String');
      mocker.clear(controller);
    })

    it('QuickToggleController_saveQuickToggleData_Test01', 0, async (): Promise<void> => {
      let controller = new QuickToggleController();
      controller.saveQuickToggleData(['1','2']);
      expect(controller.toggleDataUri).assertInstanceOf('String');
    })

    it('QuickToggleController_getQuickToggleColumn_Test01', 0, async (): Promise<void> => {
      let controller = new QuickToggleController();
      let cols = controller.getQuickToggleColumn();
      expect(cols).assertLarger(1);
    })

    it('DevHelperTest_Test01', 0, async (): Promise<void> => {
      DevHelper.isDevMode = true;
      DevHelper.getStrParam('test', 'test');
      DevHelper.getNumParam('testNum', 1);
      DevHelper.isDevMode = false;
      DevHelper.getStrParam('test', 'test');
      DevHelper.getNumParam('testNum', 1);
      expect(DevHelper.isDevMode).assertFalse();
    })

    it('DropdownBackPressEvent_Test01', 0, async (): Promise<void> => {
      DropdownBackPressEvent.getInstance();
      DropdownBackPressEvent.getInstance();
      expect(DevHelper.isDevMode).assertFalse();
    })

    it('ToggleData_Test01', 0, async (): Promise<void> => {
      let data1 = new ToggleData();
      let data2 = new ToggleData();
      expect(data1.equals(data2)).assertTrue();
      data1.otherToggle.push('wifi');
      expect(data1.equals(data2)).assertFalse();
      data1.topToggle.push('wlan');
      expect(data1.equals(data2)).assertFalse();
    })
  })
}
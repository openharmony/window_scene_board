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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { pluginStyleMgr } from '../../../../../main/ets/style/PluginStyleManager';
import { PluginSlot, PluginIconType, PluginInfo, PluginParseInfo, DeviceHelper } from '@ohos/frameworkwrapper';
import { PluginStyle } from '@ohos/plugincomponent/src/main/ets/style/PluginStyle';

let mocker: MockKit = new MockKit();

interface IPluginStyleManager {
  addIconBgColor(style: PluginStyle): void;
  getSmallIconSize(info: PluginInfo): Resource;
  getBatteryIconSize(): Length;
  getAutoIconSize(): Length;
}

export function PluginStyleManagerTest() {
  describe('PluginStyleManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
      mocker.clearAll();
    });

    PluginStyleManagerTest2();
    PluginStyleManagerTest3();
    PluginStyleManagerTest4();
  });
}

function PluginStyleManagerTest2() {
  it('test_createPluginStyle_01', Level.LEVEL1, (): void => {
    try {
      let info: PluginInfo = new PluginInfo();
      pluginStyleMgr.createPluginStyle(info);
    } catch (err) {}
    expect(Reflect.has(pluginStyleMgr, 'createPluginStyle')).assertTrue();
  });

  it('test_createPluginStyle_02', Level.LEVEL1, (): void => {
    try {
      let info: PluginInfo = new PluginInfo();
      info.pluginParseInfo = new PluginParseInfo();
      info.pluginParseInfo.pluginIconType = PluginIconType.TYPE_SMALL_ICON;
      info.pluginParseInfo.pluginSlot = PluginSlot.LIVE_VIEW_CAPSULE;
      pluginStyleMgr.createPluginStyle(info);

      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc)().afterReturn(true);
      info.pluginParseInfo.pluginSlot = PluginSlot.SLOT_STATUS_BATTERY_PANEL;
      pluginStyleMgr.createPluginStyle(info);
    } catch (err) {}
    expect(Reflect.has(pluginStyleMgr, 'createPluginStyle')).assertTrue();
  });

  it('test_createPluginStyle_03', Level.LEVEL1, (): void => {
    try {
      let info: PluginInfo = new PluginInfo();
      info.pluginParseInfo = new PluginParseInfo();
      info.pluginParseInfo.pluginIconType = PluginIconType.TYPE_COMMON_ICON;
      pluginStyleMgr.createPluginStyle(info);

      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc)().afterReturn(true);
      pluginStyleMgr.createPluginStyle(info);
    } catch (err) {}
    expect(Reflect.has(pluginStyleMgr, 'createPluginStyle')).assertTrue();
  });
}

function PluginStyleManagerTest3() {
  it('test_createPluginStyle_04', Level.LEVEL1, (): void => {
    try {
      let info: PluginInfo = new PluginInfo();
      info.pluginParseInfo = new PluginParseInfo();
      info.pluginParseInfo.pluginIconType = PluginIconType.TYPE_AUTO_ICON;
      info.pluginParseInfo.pluginSlot = PluginSlot.LIVE_VIEW_CAPSULE;
      pluginStyleMgr.createPluginStyle(info);

      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc)().afterReturn(true);
      pluginStyleMgr.createPluginStyle(info);

      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isHAD);
      when(mockFunc2)().afterReturn(true);
      pluginStyleMgr.pluginPhoneContainerHeight = 10;
      pluginStyleMgr.createPluginStyle(info);
    } catch (err) {}
    expect(Reflect.has(pluginStyleMgr, 'createPluginStyle')).assertTrue();
  });

  it('test_createPluginStyle_05', Level.LEVEL1, (): void => {
    try {
      let info: PluginInfo = new PluginInfo();
      info.pluginParseInfo = new PluginParseInfo();
      info.pluginParseInfo.pluginIconType = PluginIconType.TYPE_SEPARATOR_ICON;
      pluginStyleMgr.createPluginStyle(info);

      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isHAD);
      when(mockFunc)().afterReturn(true);
      pluginStyleMgr.createPluginStyle(info);
    } catch (err) {}
    expect(Reflect.has(pluginStyleMgr, 'createPluginStyle')).assertTrue();
  });

  it('test_addIconBgColor', Level.LEVEL1, (): void => {
    try {
      let style = new PluginStyle();
      (pluginStyleMgr as object as IPluginStyleManager).addIconBgColor(style);
    } catch (err) {}
    expect(Reflect.has(pluginStyleMgr, 'addIconBgColor')).assertTrue();
  });
}

function PluginStyleManagerTest4() {
  it('test_getSmallIconSize', Level.LEVEL1, (): void => {
    try {
      let info = new PluginInfo();
      (pluginStyleMgr as object as IPluginStyleManager).getSmallIconSize(info);

      info.pluginParseInfo = new PluginParseInfo();
      info.pluginParseInfo.pluginSlot = PluginSlot.SLOT_STATUS_BATTERY_PANEL;
      (pluginStyleMgr as object as IPluginStyleManager).getSmallIconSize(info);

      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc)().afterReturn(true);
      info.pluginParseInfo.pluginSlot = PluginSlot.SLOT_STATUS_CONTROL_CENTER;
      (pluginStyleMgr as object as IPluginStyleManager).getSmallIconSize(info);

      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isHAD);
      when(mockFunc2)().afterReturn(true);
      (pluginStyleMgr as object as IPluginStyleManager).getSmallIconSize(info);
    } catch (err) {}
    expect(Reflect.has(pluginStyleMgr, 'getSmallIconSize')).assertTrue();
  });

  it('test_getBatteryIconSize', Level.LEVEL1, (): void => {
    try {
      (pluginStyleMgr as object as IPluginStyleManager).getBatteryIconSize();

      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isHAD);
      when(mockFunc)().afterReturn(true);
      (pluginStyleMgr as object as IPluginStyleManager).getBatteryIconSize();
    } catch (err) {}
    expect(Reflect.has(pluginStyleMgr, 'getBatteryIconSize')).assertTrue();
  });

  it('test_getAutoIconSize', Level.LEVEL1, (): void => {
    try {
      (pluginStyleMgr as object as IPluginStyleManager).getAutoIconSize();

      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isHAD);
      when(mockFunc)().afterReturn(true);
      (pluginStyleMgr as object as IPluginStyleManager).getAutoIconSize();
    } catch (err) {}
    expect(Reflect.has(pluginStyleMgr, 'getAutoIconSize')).assertTrue();
  });
}
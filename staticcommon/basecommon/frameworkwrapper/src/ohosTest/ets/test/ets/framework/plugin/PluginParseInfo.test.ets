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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { PluginParseInfo, PluginClickInfo } from '../../../../../../main/ets/plugin/PluginParseInfo';
import { PluginSlot, PluginIconType, PluginWindowType, PluginAbilityType,
  PluginConstants  } from '../../../../../../main/ets/plugin/PluginConstants';
import { DeviceHelper } from '../../../../../../main/ets/TsIndex';
import { CommonUtils } from '@ohos/basicutils';

const mPluginParseInfo: PluginParseInfo = new PluginParseInfo();
const mPluginClickInfo: PluginClickInfo = new PluginClickInfo();

export function PluginParseInfoTest() {
  describe('PluginParseInfoTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('checkUpdate_isInvalid_true', 0, () => {
      expect(mPluginParseInfo.checkUpdate(null)).assertFalse();
    })

    it('deserialize_isInvalid_false', 0, () => {
      mPluginParseInfo.deserialize(null);
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.pluginTemplateName = 'pluginTemplateName';
      newPlugin.pluginBackTemplateName = 'pluginBackTemplateName ';
      newPlugin.contentColor = 'contentColor ';
      newPlugin.pluginIconWidth = 0;
      mPluginParseInfo.deserialize(newPlugin);
      expect(mPluginParseInfo.pluginTemplateName === 'pluginTemplateName').assertTrue();
      expect(mPluginParseInfo.checkUpdate(newPlugin)).assertTrue();
    })

    it('checkUpdate_priority', 0, () => {
      mPluginParseInfo.deserialize(null);
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.pluginTemplateName = 'pluginTemplateName';
      newPlugin.pluginBackTemplateName = 'pluginBackTemplateName ';
      newPlugin.contentColor = 'contentColor ';
      newPlugin.moduleName = 'moduleName';
      newPlugin.pluginAbilityName = 'pluginAbilityName';
      newPlugin.pluginPosition = 'pluginPosition';
      newPlugin.pluginIconWidth = 0;
      newPlugin.pluginType = 0;
      newPlugin.pluginSlot = 'slot';
      newPlugin.pluginDeviceType = 'type';
      newPlugin.labelResName = 'labelResName';
      mPluginParseInfo.deserialize(newPlugin);
      newPlugin.pluginPriority = 0;
      expect(mPluginParseInfo.checkUpdate(newPlugin)).assertTrue();
    })

    it('checkUpdate_isneedredhot', 0, () => {
      mPluginParseInfo.deserialize(null);
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.pluginTemplateName = 'pluginTemplateName';
      newPlugin.pluginBackTemplateName = 'pluginBackTemplateName ';
      newPlugin.contentColor = 'contentColor ';
      newPlugin.moduleName = 'moduleName';
      newPlugin.pluginAbilityName = 'pluginAbilityName';
      newPlugin.pluginPosition = 'pluginPosition';
      newPlugin.pluginPriority = 0;
      newPlugin.pluginIconWidth = 0;
      newPlugin.pluginType = 0;
      newPlugin.pluginSlot = 'slot';
      newPlugin.pluginDeviceType = 'type';
      newPlugin.labelResName = 'labelResName';
      newPlugin.isNeedRedHot = false;
      mPluginParseInfo.deserialize(newPlugin);
      newPlugin.isNeedRedHot = true;
      expect(mPluginParseInfo.checkUpdate(newPlugin)).assertTrue();
    })

    it('checkUpdate_clickinfo', 0, () => {
      mPluginParseInfo.deserialize(null);
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.pluginTemplateName = 'pluginTemplateName';
      newPlugin.pluginBackTemplateName = 'pluginBackTemplateName ';
      newPlugin.contentColor = 'contentColor ';
      newPlugin.moduleName = 'moduleName';
      newPlugin.pluginAbilityName = 'pluginAbilityName';
      newPlugin.pluginPosition = 'pluginPosition';
      newPlugin.pluginPriority = 0;
      newPlugin.pluginIconWidth = 0;
      newPlugin.pluginType = 0;
      newPlugin.pluginSlot = 'slot';
      newPlugin.pluginDeviceType = 'type';
      newPlugin.labelResName = 'labelResName';
      newPlugin.isNeedRedHot = false;
      newPlugin.clickInfo = new PluginClickInfo();
      mPluginParseInfo.deserialize(newPlugin);
      expect(mPluginParseInfo.checkUpdate(newPlugin)).assertTrue();
    })

    it('checkUpdate_long_clickinfo', 0, () => {
      mPluginParseInfo.deserialize(null);
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.pluginTemplateName = 'pluginTemplateName';
      newPlugin.pluginBackTemplateName = 'pluginBackTemplateName ';
      newPlugin.contentColor = 'contentColor ';
      newPlugin.moduleName = 'moduleName';
      newPlugin.pluginAbilityName = 'pluginAbilityName';
      newPlugin.pluginPosition = 'pluginPosition';
      newPlugin.pluginPriority = 0;
      newPlugin.isNeedRedHot = false;
      newPlugin.pluginIconWidth = 0;
      newPlugin.pluginType = 0;
      newPlugin.pluginSlot = 'slot';
      newPlugin.pluginDeviceType = 'type';
      newPlugin.labelResName = 'labelResName';
      newPlugin.clickInfo = new PluginClickInfo();
      newPlugin.longClickInfo = new PluginClickInfo();
      mPluginParseInfo.deserialize(newPlugin);
      expect(mPluginParseInfo.checkUpdate(newPlugin)).assertTrue();
    })

    it('checkUpdate_subpageclickinfo', 0, () => {
      mPluginParseInfo.deserialize(null);
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.pluginTemplateName = 'pluginTemplateName';
      newPlugin.pluginBackTemplateName = 'pluginBackTemplateName ';
      newPlugin.contentColor = 'contentColor ';
      newPlugin.moduleName = 'moduleName';
      newPlugin.pluginAbilityName = 'pluginAbilityName';
      newPlugin.pluginPosition = 'pluginPosition';
      newPlugin.pluginPriority = 0;
      newPlugin.isNeedRedHot = false;
      newPlugin.pluginIconWidth = 0;
      newPlugin.pluginType = 0;
      newPlugin.pluginSlot = 'slot';
      newPlugin.pluginDeviceType = 'type';
      newPlugin.labelResName = 'labelResName';
      newPlugin.clickInfo = new PluginClickInfo();
      newPlugin.longClickInfo = new PluginClickInfo();
      newPlugin.subPageClickInfo = new PluginClickInfo();
      mPluginParseInfo.deserialize(newPlugin);
      expect(mPluginParseInfo.checkUpdate(newPlugin)).assertTrue();
    })

    it('checkDeserialize_if_branch', 0, (): void => {
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.clickInfo = new PluginClickInfo();
      newPlugin.longClickInfo = new PluginClickInfo();
      newPlugin.subPageClickInfo = new PluginClickInfo();
      newPlugin.rightClickInfo = new PluginClickInfo();
      newPlugin.doubleClickInfo = new PluginClickInfo();
      mPluginParseInfo.pluginSlot = '';
      mPluginParseInfo.checkDeserialize(newPlugin);
      expect(mPluginParseInfo.pluginIconType).not().assertEqual('small');
    })

    it('checkDeserialize_if_else', 0, (): void => {
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.pluginIconType = 'small';
      newPlugin.pluginPosition = 'top';
      mPluginParseInfo.pluginSlot = 'pluginSlotName';
      mPluginParseInfo.checkDeserialize(newPlugin);
      expect(mPluginParseInfo.pluginIconType).assertEqual('small');
    })

    it('checkDeserialize_if_else_rightClickObj', 0, (): void => {
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.rightClickInfo = new PluginClickInfo();
      newPlugin.rightClickInfo.clickType = 'test_type';

      newPlugin.pluginIconType = 'small';
      newPlugin.pluginPosition = 'top';
      mPluginParseInfo.pluginSlot = 'pluginSlotName';
      mPluginParseInfo.checkDeserialize(newPlugin);
      expect(mPluginParseInfo.rightClickInfo).not().assertUndefined();
      expect(mPluginParseInfo.rightClickInfo.clickType).assertEqual('test_type');
    })

    it('checkDeserialize_if_else_doubleClickObj', 0, (): void => {
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.doubleClickInfo = new PluginClickInfo();
      newPlugin.doubleClickInfo.clickType = 'test_type';

      newPlugin.pluginIconType = 'small';
      newPlugin.pluginPosition = 'top';
      mPluginParseInfo.pluginSlot = 'pluginSlotName';
      mPluginParseInfo.checkDeserialize(newPlugin);
      expect(mPluginParseInfo.doubleClickInfo).not().assertUndefined();
      expect(mPluginParseInfo.doubleClickInfo.clickType).assertEqual('test_type');
    })

    it('PluginParseInfoTest_copy', 0, (): void => {
      expect(mPluginParseInfo.equals(null)).assertFalse();
      expect(mPluginParseInfo.copy(null) === undefined).assertTrue();
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.clickInfo = new PluginClickInfo();
      newPlugin.longClickInfo = new PluginClickInfo();
      newPlugin.rightClickInfo = new PluginClickInfo();
      newPlugin.doubleClickInfo = new PluginClickInfo();
      mPluginParseInfo.copy(newPlugin);
    })

    it('checkParams', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(PluginSlot, PluginSlot.getDefaultPosition);
      const mockFunc2: Function = mocker.mockFunc(PluginIconType, PluginIconType.getDefaultType);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('');
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('');
      expect(mPluginParseInfo.checkParams() === undefined).assertTrue();
      mocker.clear(PluginSlot);
      mocker.clear(PluginIconType);
      mocker.clearAll();
    })

    it('PluginClickInfoTest_all_functions', 0, (): void => {
      expect(mPluginClickInfo.deserialize(null) === undefined).assertTrue();
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      mPluginClickInfo.equals(newPlugin);
      expect(mPluginClickInfo.equals(null)).assertFalse();
      mPluginClickInfo.copy(null);
    })

    it('PluginClickInfoTest_equals_false', 0, (): void => {
      let clickInfo = new PluginClickInfo();
      let otherInfo = new PluginClickInfo();
      otherInfo.clickType = 'type';
      otherInfo.windowType = 'type';
      otherInfo.abilityType = 'type';
      otherInfo.uiExtensionType = 'type';
      otherInfo.windowPosition = 1;
      otherInfo.windowHeight = 1;
      otherInfo.bundleName = 'bundleName';
      otherInfo.enableOperate = 'enableOperate';
      otherInfo.requestType = 1;
      let ret = clickInfo.equals(otherInfo);
      expect(ret).assertFalse();
    })

    it('PluginClickInfoTest_equals_true', 0, (): void => {
      let clickInfo = new PluginClickInfo();
      clickInfo.clickType = 'type';
      clickInfo.windowType = 'type';
      clickInfo.abilityType = 'type';
      clickInfo.uiExtensionType = 'type';
      clickInfo.windowPosition = 1;
      clickInfo.windowHeight = 1;
      clickInfo.bundleName = 'bundleName';
      clickInfo.enableOperate = 'enableOperate';
      clickInfo.requestType = 1;

      let otherInfo = new PluginClickInfo();
      otherInfo.clickType = 'type';
      otherInfo.windowType = 'type';
      otherInfo.abilityType = 'type';
      otherInfo.uiExtensionType = 'type';
      otherInfo.windowPosition = 1;
      otherInfo.windowHeight = 1;
      otherInfo.bundleName = 'bundleName';
      otherInfo.enableOperate = 'enableOperate';
      otherInfo.requestType = 1;
      let ret = clickInfo.equals(otherInfo);
      expect(ret).assertTrue();
    })

    it('PluginParseInfoTest_getWindowWidth', 0, (): void => {
      expect(PluginWindowType.getWindowWidth('')).assertEqual(0);
      expect(PluginWindowType.getWindowWidth('small')).assertLarger(0);
      expect(PluginWindowType.getWindowWidth('common')).assertLarger(0);
      expect(PluginWindowType.getWindowWidth('large')).assertLarger(0);
    })

    it('PluginParseInfoTest_isTypeExtension', 0, (): void => {
      expect(PluginAbilityType.isTypeExtension('')).assertFalse();
      expect(PluginAbilityType.isTypeExtension('service_extension')).assertTrue();
    })

    it('PluginParseInfoTest_getDefaultDeviceType', 0, (): void => {
      expect(PluginSlot.getDefaultDeviceType('action.systemui.plugin.TOGGLE', 'toggle_Demo')).assertEqual('phone');
      expect(PluginSlot.getDefaultDeviceType('action.systemui.plugin.TOGGLE', '')).assertNull();
      expect(PluginSlot.getDefaultDeviceType('', 'status_bar_search')).assertEqual('2in1');
      expect(PluginSlot.getDefaultDeviceType('', 'status_bar_battery')).assertEqual('phone');
      expect(PluginSlot.getDefaultDeviceType('', '')).assertNull();
    })

    it('PluginParseInfoTest_checkDeserialize_001', 0, (): void => {
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      mPluginParseInfo.pluginSlot = '';
      mPluginParseInfo.checkDeserialize(newPlugin);
      expect(mPluginParseInfo.pluginSlot === undefined).assertTrue();
    })

    it('PluginParseInfoTest_copy_002', 0, (): void => {
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      let ret = mPluginParseInfo.copy(newPlugin);
      expect(ret == null).assertTrue();
    })

    it('PluginParseInfoTest_copy_if_else_subPageClickInfo', 0, (): void => {
      let newPlugin: PluginParseInfo = new PluginParseInfo();
      newPlugin.subPageClickInfo = new PluginClickInfo();
      newPlugin.subPageClickInfo.clickType = 'click_type';
      mPluginParseInfo.copy(newPlugin);
      expect(mPluginParseInfo.subPageClickInfo).not().assertUndefined();
    })

    it('PluginParseInfoTest_checkParams_003', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(PluginSlot, PluginSlot.getDefaultPosition);
      const mockFunc3: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('test');
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      mPluginParseInfo.pluginIconType = 'test';
      expect(mPluginParseInfo.checkParams() === undefined).assertTrue();
      mocker.ignoreMock(PluginSlot, PluginSlot.getDefaultPosition);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    })

    it('PluginParseInfoTest_checkParams_004', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(PluginSlot, PluginSlot.getDefaultPosition);
      const mockFunc2: Function = mocker.mockFunc(PluginIconType, PluginIconType.getDefaultType);
      const mockFunc3: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('test');
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('test');
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      mPluginParseInfo.pluginIconType = '';
      expect(mPluginParseInfo.checkParams() === undefined).assertTrue();
      mocker.ignoreMock(PluginSlot, PluginSlot.getDefaultPosition);
      mocker.ignoreMock(PluginIconType, PluginIconType.getDefaultType);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    })

    it('PluginParseInfoTest_checkParams_005', 0, (): void => {
      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(PluginSlot, PluginSlot.getDefaultPosition);
      const mockFunc2: Function = mocker.mockFunc(PluginIconType, PluginIconType.getDefaultType);
      const mockFunc3: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn('test');
      when(mockFunc2)(ArgumentMatchers.any).afterReturn('');
      when(mockFunc3)(ArgumentMatchers.any).afterReturn(true);
      mPluginParseInfo.pluginIconType = '';
      expect(mPluginParseInfo.checkParams() === undefined).assertTrue();
      mocker.ignoreMock(PluginSlot, PluginSlot.getDefaultPosition);
      mocker.ignoreMock(PluginIconType, PluginIconType.getDefaultType);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
    })

    it('PluginParseInfoTest_setPriority_006', 0, (): void => {
      expect((mPluginParseInfo as object)['setPriority']() === undefined).assertTrue();
    })

    it('PluginParseInfoTest_setPriority_007', 0, (): void => {
      let parseInfo: PluginParseInfo = new PluginParseInfo();
      parseInfo.action = PluginConstants.ACTION_PLUGIN_STATUS_BAR;
      parseInfo.pluginPosition = 'right';
      parseInfo.pluginSlot = 'status_bar_wifi';
      (parseInfo as object)['setPriority']();
      expect((parseInfo as object)['pluginPriority'] >= 0).assertTrue();
    })

    it('PluginParseInfoTest_setPriority_008', 0, (): void => {
      let parseInfo: PluginParseInfo = new PluginParseInfo();
      parseInfo.action = PluginConstants.ACTION_PLUGIN_STATUS_BAR;
      parseInfo.pluginPosition = 'right';
      parseInfo.pluginSlot = 'not_exits_slot';
      (parseInfo as object)['pluginPriority'] = Number.MAX_VALUE;
      (parseInfo as object)['setPriority']();
      expect((parseInfo as object)['pluginPriority'] === Number.MAX_VALUE).assertTrue();
    })

    it('PluginParseInfoTest_setPriority_009', 0, (): void => {
      let parseInfo: PluginParseInfo = new PluginParseInfo();
      parseInfo.action = PluginConstants.ACTION_PLUGIN_STATUS_BAR;
      parseInfo.pluginPosition = 'right';
      parseInfo.pluginSlot = 'not_exits_slot';
      (parseInfo as object)['pluginPriority'] = 1;
      (parseInfo as object)['setPriority']();
      expect((parseInfo as object)['pluginPriority'] === Number.MAX_VALUE).assertTrue();
    })

    it('PluginParseInfoTest_checkWindowPosition_if', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);

      let parseInfo: PluginParseInfo = new PluginParseInfo();
      let clickInfo = new PluginClickInfo();
      (parseInfo as object)['checkWindowPosition'](clickInfo);
      expect(clickInfo.windowPosition).assertUndefined();
      mocker.clear(CommonUtils);
      mocker.ignoreMock(CommonUtils,mockFun);
      mocker.clearAll();
    })
  })
}

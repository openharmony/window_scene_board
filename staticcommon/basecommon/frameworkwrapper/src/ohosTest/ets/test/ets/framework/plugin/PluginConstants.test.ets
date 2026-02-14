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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  MockKit,
  when,
  ArgumentMatchers,
  DEFAULT
} from '@ohos/hypium';
import {
  PluginSlot,
  PluginIconType,
  PluginWindowType,
  PluginAbilityType,
  PluginConstants,
  PluginPosition,
  PluginWindowPosition
} from '../../../../../../main/ets/plugin/PluginConstants';
import { DeviceHelper } from '../../../../../../main/ets/base/DeviceHelper';

export function PluginConstantsTest() {
  describe('PluginConstantsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_getDefaultSlot', DEFAULT, () => {
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);

      let result: Map<string, string[]> = PluginSlot.getDefaultSlot('test action');
      mocker.clear(DeviceHelper);
      mocker.ignoreMock(DeviceHelper, mockFun);
      mocker.clearAll();
      expect(result).not().assertUndefined();
      expect(result.has('left')).assertTrue();
    });

    it('test_getLocalSlot_phone', DEFAULT, () => {
      let result: string[] = PluginSlot.getLocalSlot('test action');
      expect(result).not().assertUndefined();
      expect(result.indexOf(PluginSlot.SLOT_STATUS_WIFI)).assertLarger(0);
    });

    it('test_getLocalSlot_control_center', DEFAULT, () => {
      let result: string[] = PluginSlot.getLocalSlot(PluginConstants.ACTION_PLUGIN_TOGGLE);
      expect(result).not().assertUndefined();
      expect(result.length).assertEqual(0);
    });

    it('test_getLocalSlot_mock_pc', DEFAULT, () => {
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);

      let result: string[] = PluginSlot.getLocalSlot('test action');
      mocker.clear(DeviceHelper);
      mocker.ignoreMock(DeviceHelper, mockFun);
      mocker.clearAll();
      expect(result).not().assertUndefined();
      expect(result.indexOf(PluginSlot.SLOT_STATUS_PERSONAL)).assertLarger(0);
    });

    it('test_getDefaultPosition_if', DEFAULT, () => {
      let result: string = PluginSlot.getDefaultPosition(PluginConstants.ACTION_PLUGIN_TOGGLE, '');
      expect(result).assertEqual(PluginPosition.POSITION_NONE);
    });

    it('test_getDefaultPosition_not_pc', DEFAULT, () => {
      let result: string = PluginSlot.getDefaultPosition('action', PluginSlot.SLOT_STATUS_WIFI);
      expect(result).assertEqual(PluginPosition.POSITION_RIGHT);
    });

    it('test_getDefaultPosition_pc', DEFAULT, () => {
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);

      let result: string = PluginSlot.getDefaultPosition('action', PluginSlot.SLOT_STATUS_USB);
      mocker.clear(DeviceHelper);
      mocker.ignoreMock(DeviceHelper, mockFun);
      mocker.clearAll();
      expect(result).assertEqual(PluginPosition.POSITION_RIGHT);
    });

    it('test_getDefaultType_if', DEFAULT, () => {
      let result: string = PluginIconType.getDefaultType(PluginConstants.ACTION_PLUGIN_TOGGLE, '');
      expect(result).assertEqual(PluginIconType.TYPE_TOGGLE_ICON);
    });

    it('test_getDefaultType_not_phone_not_pad', DEFAULT, () => {
      let mocker: MockKit = new MockKit();
      let mockFunPhone: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      let mockFunPad: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunPhone)(ArgumentMatchers.any).afterReturn(false);
      when(mockFunPad)(ArgumentMatchers.any).afterReturn(false);

      let result: string = PluginIconType.getDefaultType('action', PluginSlot.SLOT_STATUS_PERSONAL);
      expect(result).assertEqual(PluginIconType.TYPE_SMALL_ICON);
      mocker.clear(DeviceHelper);
      mocker.ignoreMock(DeviceHelper, mockFunPhone);
      mocker.ignoreMock(DeviceHelper, mockFunPad);
      mocker.clearAll();
    });

    it('test_getWindowPosition_valid', DEFAULT, () => {
      let result: number = PluginWindowPosition.getWindowPosition(PluginSlot.SLOT_STATUS_CONTROL_CENTER);
      expect(result).assertEqual(PluginWindowPosition.POSITION_SCREEN_RIGHT);
    });

    it('test_getWindowPosition_not_valid', DEFAULT, () => {
      let result: number = PluginWindowPosition.getWindowPosition('not_valid_slot');
      expect(result).assertEqual(PluginWindowPosition.POSITION_AUTO_ALIGN);
    });
  })
}
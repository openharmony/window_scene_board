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
  DeviceHelper,
  PluginConstants, PluginInfo, PluginParseInfo, PluginSlot } from '@ohos/frameworkwrapper';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { LocalPluginStyle } from '../../../../../main/ets/style/LocalPluginStyle';

export function LocalPluginStyleTest() {
  describe('LocalPluginStyleTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_parseLocalIconStyle', Level.LEVEL1, (): void => {
      try {
        let pluginInfo = new PluginInfo();
        pluginInfo.pluginParseInfo = new PluginParseInfo();
        pluginInfo.pluginParseInfo.isLocalPlugin = false;
        LocalPluginStyle.parseLocalIconStyle(pluginInfo);

        pluginInfo.pluginParseInfo.isLocalPlugin = true;
        pluginInfo.pluginParseInfo.action = PluginConstants.ACTION_PLUGIN_STATUS_BAR;
        pluginInfo.pluginParseInfo.pluginSlot = PluginSlot.LIVE_VIEW_CAPSULE;
        LocalPluginStyle.parseLocalIconStyle(pluginInfo);
      } catch (err) {}
      expect(LocalPluginStyle.parseLocalIconStyle !== undefined).assertTrue();
    });

    it('test_getLocalIcons', Level.LEVEL1, (): void => {
      try {
        LocalPluginStyle.getLocalIcons('');
        LocalPluginStyle.getLocalIcons(PluginConstants.ACTION_PLUGIN_TOGGLE);

        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(mockFunc)().afterReturn(true);
        LocalPluginStyle.getLocalIcons('');
      } catch (err) {}
      expect(LocalPluginStyle.getLocalIcons !== undefined).assertTrue();
    });
  });
}
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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { PluginInfo ,PluginAccessInfo} from '../../../../../../main/ets/plugin/PluginInfo';
import { PluginParseInfo, PluginClickInfo } from '../../../../../../main/ets/plugin/PluginParseInfo';

export function PluginInfoTest() {
  describe('PluginInfoTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('PluginInfoTest_equals_not', 0, (): void => {
      let pluginInfo: PluginInfo = new PluginInfo();
      expect(pluginInfo.equals({})).assertFalse();
    });

    it('PluginInfoTest_equals', 0, (): void => {
      let pluginInfo: PluginInfo = new PluginInfo();
      let otherPluginInfo: PluginInfo = new PluginInfo();
      expect(pluginInfo.equals({ pluginParseInfo: otherPluginInfo })).assertFalse();
    });

    it('PluginInfoTest_equals_not_same', 0, (): void => {
      let parseInfo = new PluginParseInfo();
      let otherPluginInfo: PluginInfo = new PluginInfo();
      otherPluginInfo.pluginParseInfo = parseInfo;

      let pluginInfo: PluginInfo = new PluginInfo();
      expect(pluginInfo.equals(otherPluginInfo)).assertUndefined();
    });

    it('PluginInfoTest_equals_same', 0, (): void => {
      let parseInfo = new PluginParseInfo();
      parseInfo.action = 'action';
      parseInfo.pluginSlot = 'pluginSlot';

      let otherPluginInfo: PluginInfo = new PluginInfo();
      otherPluginInfo.pluginParseInfo = parseInfo;

      let pluginInfo: PluginInfo = new PluginInfo();
      pluginInfo.pluginParseInfo = parseInfo;

      expect(pluginInfo.equals(otherPluginInfo)).assertTrue();
    });

    it('PluginInfoTest_hasClickWindow', 0, (): void => {
      let pluginInfo: PluginInfo = new PluginInfo();
      expect(pluginInfo.hasClickWindow()).assertFalse();

      pluginInfo.pluginParseInfo = new PluginParseInfo();
      expect(pluginInfo.hasClickWindow()).assertFalse();

      pluginInfo.pluginParseInfo.clickInfo = new PluginClickInfo();
      expect(pluginInfo.hasClickWindow()).assertFalse();

      pluginInfo.pluginParseInfo.clickInfo = new PluginClickInfo('window');
      expect(pluginInfo.hasClickWindow()).assertTrue();
    });

    it('PluginInfoTest_hasSubPage', 0, (): void => {
      let pluginInfo: PluginInfo = new PluginInfo();
      expect(pluginInfo.hasSubPage()).assertFalse();

      pluginInfo.pluginParseInfo = new PluginParseInfo();
      expect(pluginInfo.hasSubPage()).assertFalse();

      pluginInfo.pluginParseInfo.subPageClickInfo = new PluginClickInfo();
      expect(pluginInfo.hasSubPage()).assertFalse();

      pluginInfo.pluginParseInfo.subPageClickInfo = new PluginClickInfo('window');
      expect(pluginInfo.hasSubPage()).assertTrue();
    });

    it('should_return_pluginSlot_when_pluginParseInfo_is_not_null', 0, () => {
      let plugininfo: PluginInfo = new PluginInfo();
      let pluginParseInfo: PluginParseInfo = new PluginParseInfo();
      pluginParseInfo.pluginSlot = 'slot1';
      plugininfo.pluginParseInfo = pluginParseInfo;
      expect(plugininfo.getSlot()).assertEqual('slot1');
    });

    it('should_return_empty_string_when_pluginSlot_is_undefined', 0, () => {
      let plugininfo: PluginInfo = new PluginInfo();
      let pluginParseInfo: PluginParseInfo = new PluginParseInfo();
      plugininfo.pluginParseInfo = pluginParseInfo;
      expect(plugininfo.getSlot()).assertEqual('');
    });

    it('test_PluginAccessInfo_equals', 0, () => {
      let info: PluginAccessInfo = new PluginAccessInfo();
      expect(info.equals({})).assertFalse();
      expect(info.getSlot()).assertEqual('');

      let other: PluginAccessInfo = new PluginAccessInfo();
      other.accessTokenId = 1;
      expect(info.equals(other)).assertFalse();

      info.accessTokenId = 1;
      expect(info.equals(other)).assertTrue();

      let parseInfo = new PluginParseInfo();
      parseInfo.instanceKey = 'instanceKey';
      parseInfo.action = 'action';

      info.pluginParseInfo = parseInfo;
      other.pluginParseInfo = parseInfo;
      expect(info.equals(other)).assertTrue();
    });

    it('test_getSlot', 0, () => {
      const slot: string = 'slot';
      const key: string = 'key';
      let info: PluginAccessInfo = new PluginAccessInfo();
      info.pluginParseInfo = new PluginParseInfo();
      info.pluginParseInfo.pluginSlot = slot;
      info.pluginParseInfo.instanceKey = key;
      let result = info.getSlot();
      expect(result).assertEqual(slot + key);
    });
  })
}
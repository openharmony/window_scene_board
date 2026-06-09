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
import { describe, it, expect, MockKit, when } from '@ohos/hypium';
import { PluginComponentInfo, PluginSlot } from '@ohos/frameworkwrapper';
import { PluginToggleData } from '@ohos/screenlockcommon';
import { PluginToggleController } from '../../../../../main/ets/controller/PluginToggleController';

export function pluginToggleControllerTest() {
  let pluginInfo: PluginComponentInfo = new PluginComponentInfo();
  let pluginToggleControllerInstance: PluginToggleController = new PluginToggleController('test', pluginInfo);

  describe('pluginToggleControllerTest', () => {
    it('initPluginToggleControllerTest', 0, () => {
      expect(pluginToggleControllerInstance instanceof PluginToggleController).assertTrue();
    });

    it('getDataTest', 0, () => {
      let dataTest = pluginToggleControllerInstance.getData();
      expect(dataTest instanceof PluginToggleData).assertTrue();
    });

    it('isAvailableTest_false', 0, () => {
      (pluginToggleControllerInstance as object)['isConnect'] = false;
      let isRes = pluginToggleControllerInstance.isAvailable();
      expect(isRes).assertFalse();
    });

    it('isAvailableTest_ture', 0, () => {
      (pluginToggleControllerInstance as object)['isConnect'] = true;
      let isRes = pluginToggleControllerInstance.isAvailable();
      expect(isRes).assertTrue();
    });

  })
}
export function pluginToggleControllerTest_two() {
  let pluginInfo: PluginComponentInfo = new PluginComponentInfo();
  let pluginToggleControllerInstance: PluginToggleController = new PluginToggleController('test', pluginInfo);
  describe('pluginToggleControllerTest_two', () => {
    it('handleClickTest_01', 0, () => {
      (pluginToggleControllerInstance as object)['slot'] = PluginSlot.SLOT_CONTROL_SHARE;
      let handleClickRes = pluginToggleControllerInstance.handleOneClick();
      expect(handleClickRes).assertTrue();
    });
    it('handleClickTest_02', 0, () => {
      (pluginToggleControllerInstance as object)['slot'] = 'test';
      let handleClickRes = pluginToggleControllerInstance.handleOneClick();
      expect(handleClickRes).assertFalse();
    });
    it('handleLongClickTest_01', 0, () => {
      (pluginToggleControllerInstance as object)['isPc'] = true;
      let handleLongClickRes = pluginToggleControllerInstance.handleLongClick();
      expect(handleLongClickRes).assertFalse();
    });
    it('handleLabelClickTest_01', 0, () => {
      let handleLabelClickRes = pluginToggleControllerInstance.handleLabelClick(PluginSlot.SLOT_CONTROL_SHARE);
      expect(handleLabelClickRes).assertTrue();
    });
    it('handleHoverTest_01', 0, () => {
      pluginToggleControllerInstance.handleHover(true)
      expect(true).assertTrue();
    });
    it('handleHoverTest_02', 0, () => {
      pluginToggleControllerInstance.handleHover(false);
      expect(true).assertTrue();
    });
  });
}
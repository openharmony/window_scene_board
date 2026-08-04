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

import { describe, expect, it, MockKit, when } from '@ohos/hypium';
import { UIExtensionContentSession } from '@kit.AbilityKit';
import AodIntentConst from '@ohos/aod/src/main/ets/intents/AodIntentConst';
import AodIntentExecutorImpl from '@ohos/phonebase/src/main/ets/SceneBoard/aod/intents/AodIntentExecutorImpl';
import insightIntent from '@ohos.app.ability.insightIntent';
import { aodSettingsModule } from '@ohos/aod';

export function AodIntentExecutorImplTest() {
  describe('AodIntentExecutorImplTest', () => {
    it('AodIntentExecutorImplTest_onExecuteInUIAbilityBackgroundMode', 0, () => {
      let name = 'CheckSettingItem';
      let param: Record<string, string> = { 'itemName': AodIntentConst.AOD_SWITCH, 'switchFlag': '0' };
      let executor = new AodIntentExecutorImpl();
      let res = executor.onExecuteInUIAbilityBackgroundMode(name, param);
      expect(res).not().assertNull();
    });

    it('AodIntentExecutorImplTest_onExecuteInUIAbilityBackgroundMode1', 0, () => {
      let name = 'CheckSettingItem';
      let param: Record<string, string> = { 'itemName': 'default', 'switchFlag': '0' };
      let executor = new AodIntentExecutorImpl();
      let res = executor.onExecuteInUIAbilityBackgroundMode(name, param);
      expect(res).not().assertNull();
    });

    it('AodIntentExecutorImplTest_onExecuteInUIAbilityBackgroundMode2', 0, () => {
      let name = 'GetSettingSwitch';
      let param: Record<string, string> = { 'itemName': AodIntentConst.AOD_SWITCH, 'switchFlag': '0' };
      let executor = new AodIntentExecutorImpl();
      let res = executor.onExecuteInUIAbilityBackgroundMode(name, param);
      expect(res).not().assertNull();
    });

    it('AodIntentExecutorImplTest_onExecuteInUIAbilityBackgroundMode3', 0, () => {
      let name = 'GetSettingSwitch';
      let param: Record<string, string> = { 'itemName': 'default', 'switchFlag': '0' };
      let executor = new AodIntentExecutorImpl();
      let res = executor.onExecuteInUIAbilityBackgroundMode(name, param);
      expect(res).not().assertNull();
    });

    it('AodIntentExecutorImplTest_onExecuteInUIAbilityBackgroundMode4', 0, () => {
      let name = 'SetSettingSwitch';
      let param: Record<string, string> = { 'itemName': AodIntentConst.AOD_SWITCH, 'switchFlag': '0' };
      let executor = new AodIntentExecutorImpl();
      let res = executor.onExecuteInUIAbilityBackgroundMode(name, param);
      expect(res).not().assertNull();
    });

    it('AodIntentExecutorImplTest_onExecuteInUIAbilityBackgroundMode5', 0, () => {
      let name = 'SetSettingSwitch';
      let param: Record<string, string> = { 'itemName': 'default', 'switchFlag': '0' };
      let executor = new AodIntentExecutorImpl();
      let res = executor.onExecuteInUIAbilityBackgroundMode(name, param);
      expect(res).not().assertNull();
    });

    it('AodIntentExecutorImplTest_onExecuteInUIAbilityBackgroundMode6', 0, () => {
      let name = 'default';
      let param: Record<string, string> = { 'itemName': 'default', 'switchFlag': '0' };
      let executor = new AodIntentExecutorImpl();
      let res = executor.onExecuteInUIAbilityBackgroundMode(name, param);
      expect(res).not().assertNull();
    });

    it('AodIntentExecutorImpl_getAodSwitchIntent', 0, () => {
      let aodIntentExecutorImpl = new AodIntentExecutorImpl();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aodSettingsModule, aodSettingsModule.isSwitchOpen);
      when(mockFunc)().afterReturn(true);
      let result: insightIntent.ExecuteResult = (aodIntentExecutorImpl as object)['getAodSwitchIntent']('name');
      expect(result).not().assertNull();
      mocker.clear(aodSettingsModule);
      mocker.clearAll();
    });

    it('AodIntentExecutorImpl_checkSettingItem1', 0, () => {
      let aodIntentExecutorImpl = new AodIntentExecutorImpl();
      let result: insightIntent.ExecuteResult =
        (aodIntentExecutorImpl as object)['checkSettingItem'](AodIntentConst.AOD_MODE_TIMER);
      expect(result).not().assertNull();
    });

    it('AodIntentExecutorImpl_checkSettingItem2', 0, () => {
      let aodIntentExecutorImpl = new AodIntentExecutorImpl();
      let result: insightIntent.ExecuteResult =
        (aodIntentExecutorImpl as object)['checkSettingItem'](AodIntentConst.AOD_MODE_ALL_DAY);
      expect(result).not().assertNull();
    });

    it('AodIntentExecutorImpl_checkAodDisplayMode', 0, () => {
      let aodIntentExecutorImpl = new AodIntentExecutorImpl();
      let result: insightIntent.ExecuteResult =
        (aodIntentExecutorImpl as object)['checkAodDisplayMode'](AodIntentConst.AOD_MODE_ALL_DAY);
      expect(result).not().assertNull();
    });

    it('AodIntentExecutorImpl_setAodSwitchIntent1', 0, () => {
      let aodIntentExecutorImpl = new AodIntentExecutorImpl();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(aodSettingsModule, aodSettingsModule.isSwitchOpen);
      when(mockFunc)().afterReturn(true);
      let result: insightIntent.ExecuteResult =
        (aodIntentExecutorImpl as object)['setAodSwitchIntent'](AodIntentConst.AOD_MODE_ALL_DAY, 1);
      expect(result).not().assertNull();
      mocker.clear(aodSettingsModule);
      mocker.clearAll();
    });

  })

}
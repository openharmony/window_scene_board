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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import SwitchIntentExecutorImpl from '@ohos/phonebase/src/main/ets/intents/SwitchIntentExecutorImpl';
import insightIntent from '@ohos.app.ability.insightIntent';
import { IntentNameConstants } from '@ohos/phonebase/src/main/ets/intents/IntentCodeConstant';

export default function SwitchIntentExecutorTest() {
  describe('SwitchIntentExecutorTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('setSettingSwitchTest', 0, async (done: Function): Promise<void> => {
      let intentExecutor: SwitchIntentExecutorImpl = new SwitchIntentExecutorImpl();
      let itemName: string = 'desktop_slide';
      let switchFlag: number = 0;
      let rsp: insightIntent.ExecuteResult = await intentExecutor.setSettingSwitch(itemName, switchFlag);
      expect(rsp !== null).assertEqual(true);
      done();
    })

    it('getSettingSwitchTest', 0, async (done: Function): Promise<void> => {
      let intentExecutor: SwitchIntentExecutorImpl = new SwitchIntentExecutorImpl();
      let itemName: string = 'desktop_slide';
      let rsp: insightIntent.ExecuteResult = await intentExecutor.getSettingSwitch(itemName);
      expect(rsp !== null).assertEqual(true);
      done();
    })

    it('checkSettingSwitchTest', 0, async (done: Function): Promise<void> => {
      let intentExecutor: SwitchIntentExecutorImpl = new SwitchIntentExecutorImpl();
      let itemName: string = 'desktop_slide';
      let rsp: insightIntent.ExecuteResult = await intentExecutor.checkSettingSwitch(itemName);
      expect(rsp !== null).assertEqual(true);
      done();
    })

    it('onExecuteInUIAbilityBackgroundModeTest', 0, async (done: Function): Promise<void> => {
      let intentExecutor: SwitchIntentExecutorImpl = new SwitchIntentExecutorImpl();
      let itemName: string = 'desktop_slide';
      let intentParam: Record<string, Object> = {
        'itemName': itemName
      };

      let rsp: insightIntent.ExecuteResult | Promise<insightIntent.ExecuteResult> =
      intentExecutor.onExecuteInUIAbilityBackgroundMode(IntentNameConstants.CHECK_SETTING_ITEM, intentParam);
      expect(rsp !== null).assertEqual(true);


      intentParam = {
        'itemName': itemName
      };
      rsp = intentExecutor.onExecuteInUIAbilityBackgroundMode(IntentNameConstants.GET_SETTING_SWITCH, intentParam);
      expect(rsp !== null).assertEqual(true);


      intentParam = {
        'itemName': itemName,
        'switchFlag': 1
      };
      rsp = intentExecutor.onExecuteInUIAbilityBackgroundMode(IntentNameConstants.SET_SETTING_SWITCH, intentParam);
      expect(rsp !== null).assertEqual(true);
      rsp = intentExecutor.onExecuteInUIAbilityBackgroundMode('abc', intentParam);
      expect(rsp !== null).assertEqual(true);
      done();
    })

    it('setSwitchInternal', 0, async (done: Function): Promise<void> => {
      let intentExecutor: SwitchIntentExecutorImpl = new SwitchIntentExecutorImpl();
      let itemName: string = 'desktop_slide';
      let switchFlag: number = 0;
      await intentExecutor.setSwitchInternal(itemName, switchFlag);
      switchFlag = 1;
      await intentExecutor.setSwitchInternal(itemName, switchFlag);
      expect(true).assertTrue();
      done();
    })
  })
}
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
import ScbIntentExecutorImpl from '@ohos/phonebase/src/main/ets/intents/executor/ScbIntentExecutorImpl';
import insightIntent from '@ohos.app.ability.insightIntent';
import { IntentType } from '@ohos/phonebase/src/main/ets/intents/utils/IntentConstants';

/**
 * Intent Framework Executor Implementation Test Function
 *
 * @since 2024-05-23
 */
export default function ScbIntentExecutorImplTest() {
  describe('ScbIntentExecutorImplTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('onExecuteInUIAbilityBackgroundModeTest', 0, async (done: Function): Promise<void> => {
      let intentExecutor: ScbIntentExecutorImpl = new ScbIntentExecutorImpl();
      let itemName: string = 'PIP_SWITCH';
      let intentParam: Record<string, Object> = {
        'itemName': itemName
      };

      let rsp: insightIntent.ExecuteResult | Promise<insightIntent.ExecuteResult> =
        intentExecutor.onExecuteInUIAbilityBackgroundMode(IntentType.CHECK_SETTING_ITEM, intentParam);
      expect(rsp !== null).assertEqual(true);


      intentParam = {
        'itemName': itemName
      };
      rsp = intentExecutor.onExecuteInUIAbilityBackgroundMode(IntentType.GET_SETTING_SWITCH, intentParam);
      expect(rsp !== null).assertEqual(true);


      intentParam = {
        'itemName': itemName,
        'switchFlag': 1
      };
      rsp = intentExecutor.onExecuteInUIAbilityBackgroundMode(IntentType.SET_SETTING_SWITCH, intentParam);
      expect(rsp !== null).assertEqual(true);
      rsp = intentExecutor.onExecuteInUIAbilityBackgroundMode('abc', intentParam);
      expect(rsp !== null).assertEqual(true);
      done();
    })

    it('onExecuteInUIExtensionAbility', 0, async (done: Function): Promise<void> => {
      let intentExecutor: ScbIntentExecutorImpl = new ScbIntentExecutorImpl();
      let itemName: string = 'PIP_SWITCH';
      let intentParam: Record<string, Object> = {
        'itemName': itemName
      };

      let rsp: insightIntent.ExecuteResult | Promise<insightIntent.ExecuteResult> =
        intentExecutor.onExecuteInUIAbilityBackgroundMode(IntentType.LOAD_SETTING_CARD, intentParam);
      expect(rsp !== null).assertEqual(true);
      done();
    })
  })
}
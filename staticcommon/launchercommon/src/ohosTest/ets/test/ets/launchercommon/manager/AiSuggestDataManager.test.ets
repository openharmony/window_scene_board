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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { AiSuggestDataManager, AiSuggestionDataCallback } from '../../../../../../main/ets/TsIndex';

export default function AiSuggestDataManagerTest() {
  describe('AiSuggestDataManagerTest', () => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_AiSuggestDataManager', 0, async (done: Function) => {
      const instance: AiSuggestDataManager = AiSuggestDataManager.getInstance();
      expect(instance instanceof AiSuggestDataManager).assertTrue();
      done();
    })

    it('test_registerCallback', 0, async (done: Function) => {
      const aiSuggestDataManager: AiSuggestDataManager = AiSuggestDataManager.getInstance();
      const cardId: string = '100';
      const callback: AiSuggestionDataCallback = {
        onUpdate: () => {
          return () => {
          }
        }
      };
      aiSuggestDataManager.registerCallback(cardId, callback);
      expect(aiSuggestDataManager['formCallbackMap'].get(cardId)?.isEmpty()).assertFalse();
      aiSuggestDataManager.registerCallback('', callback);
      expect(aiSuggestDataManager['formCallbackMap'].get(cardId)?.isEmpty()).assertFalse();
      done();
    })

    it('test_updateAiSuggestData', 0, async (done: Function) => {
      const aiSuggestDataManager: AiSuggestDataManager = AiSuggestDataManager.getInstance();
      const cardId: string = '101';
      const callback: AiSuggestionDataCallback = {
        onUpdate: () => {
          return () => {
          }
        }
      };
      aiSuggestDataManager.registerCallback(cardId, callback);
      expect(aiSuggestDataManager['formCallbackMap'].get(cardId)?.isEmpty()).assertFalse();
      aiSuggestDataManager.updateAiSuggestData('');
      expect(aiSuggestDataManager['formCallbackMap'].get(cardId)?.isEmpty()).assertFalse();
      aiSuggestDataManager.updateAiSuggestData(cardId);
      expect(aiSuggestDataManager['formCallbackMap'].get(cardId)?.isEmpty()).assertFalse();
      done();
    })

    it('test_unRegisterCallback', 0, async (done: Function) => {
      const aiSuggestDataManager: AiSuggestDataManager = AiSuggestDataManager.getInstance();
      const cardId: string = '102';
      const callback: AiSuggestionDataCallback = {
        onUpdate: () => {
          return () => {
          }
        }
      };
      aiSuggestDataManager.registerCallback(cardId, callback);
      expect(aiSuggestDataManager['formCallbackMap'].get(cardId)?.isEmpty()).assertFalse();
      aiSuggestDataManager.unRegisterCallback(cardId, callback);
      expect(aiSuggestDataManager['formCallbackMap'].get(cardId) === undefined).assertTrue();
      done();
    })

  })
}
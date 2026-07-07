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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
} from '@ohos/hypium';
import { Response } from '@ohos/launchercommon/src/main/ets/constants/Response';
import {
  AiSuggestionService,
} from '../../../../../../main/ets/default/service/AiSuggestionService';

/**
 * AiSuggestionService测试
 *
 * @since 2023-10-17
 */
export function AiSuggestionServiceTest() {
  describe('AiSuggestionServiceTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('AiSuggestionServiceTest_onCall', 0, async (done: Function): Promise<void> => {
      const aiService = new AiSuggestionService();
      expect(await aiService.onCall(null)).assertEqual(Response.INVALID_METHOD_ERROR);

      const invalidMsg = 'callSuggestion';
      expect(await aiService.onCall(JSON.stringify(invalidMsg))).assertEqual(Response.INVALID_METHOD_ERROR);
      done();
    });

    it('testIsSupportSegments', 0, () => {
      const aiService = new AiSuggestionService();
      expect(aiService.isSupportSegments()).assertEqual(true);
    });
  });
}
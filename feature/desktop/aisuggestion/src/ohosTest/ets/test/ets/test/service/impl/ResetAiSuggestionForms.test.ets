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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { LauncherCardInfo } from '../../../../../../../main/ets/default/bean/LauncherCardInfo';
import { AiSuggestionFormManager } from '../../../../../../../main/ets/default/manager/AiSuggestionFormManager';

/**
 * ResetAiSuggestionForms测试
 *
 * @since 2023-10-17
 */
export function ResetAiSuggestionFormsTest() {
  describe('ResetAiSuggestionFormsTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('testExecute', 0, (): void => {
      const map: Map<string, LauncherCardInfo> = AiSuggestionFormManager.getInstance().getAllCardInfoCache();
      for (const cardId of map.keys()) {
        AiSuggestionFormManager.getInstance().resetCardInfo(cardId);
      }
    })
  });
}
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
import { AiSuggestionConstants } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionConstants';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';
import { JsonHelper } from '../../../../../../main/ets/default/utils/JsonHelper';

/**
 * JsonHelper测试
 *
 * @since 2024-1-11
 */
export function JsonHelperTest() {
  describe('JsonHelperTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testLogReplacer', 0, (): void => {
      let recItem: LauncherRecItem = new LauncherRecItem();
      recItem.icon = '1';
      recItem.serviceId = '2';
      const str = JSON.stringify(recItem, JsonHelper.logReplacer);
      expect(str.indexOf('icon') === AiSuggestionConstants.INVALID_INDEX).assertTrue();
      expect(str.indexOf('serviceId') === AiSuggestionConstants.INVALID_INDEX).assertFalse();
    });

    it('testDbReplacer', 0, (): void => {
      let recItem: LauncherRecItem = new LauncherRecItem();
      recItem.icon = '1';
      recItem.serviceId = '2';
      const str = JSON.stringify(recItem, JsonHelper.dbReplacer);
      expect(str.indexOf('icon') === AiSuggestionConstants.INVALID_INDEX).assertTrue();
      expect(str.indexOf('serviceId') === AiSuggestionConstants.INVALID_INDEX).assertFalse();
    });
  });
}
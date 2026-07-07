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
import { DataPreference } from '../../../../../../main/ets/default/utils/DataPreference';

/**
 * JsonHelper测试
 *
 * @since 2024-1-11
 */
export function DataPreferenceTest() {
  describe('DataPreferenceTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('DataPreferenceTest_testConstructor', 0, (): void => {
      try {
        new DataPreference('');
      } catch(err) {
        expect((err as Error).message).assertEqual('preferencesFileName can not be null!');
      }
      expect(new DataPreference('preferencesFileName')).not().assertNull();
    });
  });
}
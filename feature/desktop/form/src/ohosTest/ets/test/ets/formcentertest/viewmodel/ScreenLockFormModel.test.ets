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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Level,
} from '@ohos/hypium';
import ScreenLockFormModel from '../../../../../../main/ets/default/viewmodel/ScreenLockFormModel';

const FORM_LOCATION_KEY = 'ohos.extra.param.key.form_location';
const SCREEN_LOCK_KEY: number = 6;

export function ScreenLockFormModelTest() {
  describe('ScreenLockFormModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getScreenLockWant', TestType.FUNCTION | Level.LEVEL0, () => {
      let screenFormModel: ScreenLockFormModel = new ScreenLockFormModel();
      let want: Want = screenFormModel.getScreenLockWant();
      expect(want.parameters?.[FORM_LOCATION_KEY]).assertEqual(SCREEN_LOCK_KEY);
    });
  })
}
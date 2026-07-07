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
  it,
  describe,
  expect,
  TestType,
  Size,
  Level,
} from '@ohos/hypium';
import { LauncherRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/LauncherRecItem';

export function LauncherRecItemTest() {
  describe('LauncherRecItemTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testIsValid', TestType.FUNCTION | Level.LEVEL0 | Size.SMALLTEST, (): void => {

      let rectItem: LauncherRecItem = new LauncherRecItem();
      expect(LauncherRecItem.isValid(rectItem)).assertFalse();

      rectItem.itemType = 0;
      expect(LauncherRecItem.isValid(rectItem)).assertFalse();

      rectItem.rowStart = 0;
      expect(LauncherRecItem.isValid(rectItem)).assertFalse();

      rectItem.columnStart = 0;
      expect(LauncherRecItem.isValid(rectItem)).assertFalse();

      rectItem.rowSpan = 1;
      expect(LauncherRecItem.isValid(rectItem)).assertFalse();

      rectItem.columnSpan = 1;
      expect(LauncherRecItem.isValid(rectItem)).assertTrue();
    });
  });
}
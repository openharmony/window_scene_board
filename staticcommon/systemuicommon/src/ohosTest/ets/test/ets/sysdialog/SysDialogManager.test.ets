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
import { sysDialogMgr } from '@ohos/systemuiutils/src/main/ets/TsIndex';
import { SysDialogType } from '@ohos/systemuiutils/src/main/ets/TsIndex';

const DEFAULT = 0;

export function SysDialogManagerTest() {
  describe('SysDialogManagerTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('SysDialogManager_01', DEFAULT, () => {
      let dialogType = sysDialogMgr.getDialogState(SysDialogType.TYPE_DEFAULT);
      expect(dialogType !== undefined).assertTrue();
    })
  })
}
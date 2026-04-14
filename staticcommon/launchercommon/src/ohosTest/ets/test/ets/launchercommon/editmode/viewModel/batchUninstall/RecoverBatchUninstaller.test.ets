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

import { describe, expect, it } from '@ohos/hypium';
import { ForwardType } from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/BatchUninstallChain';
import {
  RecoverBatchUninstaller
} from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/RecoverBatchUninstaller';
import { GridLayoutItemInfo } from '../../../../../../../../main/ets/TsIndex';

export default function RecoverBatchUninstallerTest() {
  describe('RecoverBatchUninstallerTest', () => {
    let uninstaller = new RecoverBatchUninstaller();

    it('test_doHandleData', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      uninstaller.doHandleData([item], ForwardType.DRAG_END)
    })

  })
}

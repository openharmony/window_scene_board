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

import { describe, expect, it } from '@ohos/hypium';
import { ForwardType } from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/BatchUninstallChain';
import {
  RemoveBatchUninstaller
} from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/RemoveBatchUninstaller';
import { AppStatus, CommonConstants, GridLayoutItemInfo } from '../../../../../../../../main/ets/TsIndex';

export default function RemoveBatchUninstallerTest() {
  describe('RemoveBatchUninstallerTest', () => {
    let uninstaller = new RemoveBatchUninstaller();

    // 带分身主应用
    let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
    item1.typeId = CommonConstants.TYPE_APP;
    item1.bundleName = 'bundleName1';
    item1.appIndex = 0;
    item1.isUninstallAble = true;
    item1.appStatus = AppStatus.INSTALLED;

    // 可卸载分身
    let item6: GridLayoutItemInfo = new GridLayoutItemInfo();
    item6.typeId = CommonConstants.TYPE_APP;
    item6.bundleName = 'bundleName1';
    item6.appIndex = 2;
    item6.isUninstallAble = true;
    item6.appStatus = AppStatus.INSTALLED;

    it('test_doHandleData', 0, () => {
      uninstaller.doHandleData([item1,item6], ForwardType.CANCEL_REMOVE);
      uninstaller.doHandleData([item1,item6], ForwardType.CONFIRM_REMOVE);
    })

  })
}

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
  LongPressBatchUninstaller
} from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/LongPressBatchUninstaller';
import { AppStatus, CommonConstants, GridLayoutItemInfo } from '../../../../../../../../main/ets/TsIndex';

export default function LongPressBatchUninstallerTest() {
  describe('LongPressBatchUninstallerTest', () => {
    let uninstaller = new LongPressBatchUninstaller();

    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.typeId = CommonConstants.TYPE_APP;
    item.bundleName = 'bundleName1';
    item.appIndex = 0;
    item.container = 213;
    item.isUninstallAble = true;
    item.appStatus = AppStatus.INSTALLED;

    it('test_doHandleData', 0, () => {
      let editModeViewData = uninstaller.doHandleData([item], ForwardType.CANCEL_REMOVE);
      editModeViewData = uninstaller.doHandleData([item], ForwardType.LONG_PRESS_END);
      editModeViewData = uninstaller.doHandleData([item], ForwardType.LONG_PRESS);
      item.isUninstallAble = false;
      editModeViewData = uninstaller.doHandleData([item], ForwardType.LONG_PRESS);
    })

    it('test_existsUninstallable_0', 0, () => {
      item.isUninstallAble = false;
      let existsUninstallable: boolean = (uninstaller as object)['existsUninstallable']([item]);
      expect(existsUninstallable).assertTrue();
    })

    it('test_existsUninstallable_1', 0, () => {
      item.isUninstallAble = true;
      let existsUninstallable: boolean = (uninstaller as object)['existsUninstallable']([item]);
      expect(existsUninstallable).assertTrue();
    })

    it('test_existsUninstallable_2', 0, () => {
      let existsUninstallable: boolean = (uninstaller as object)['existsUninstallable']([]);
      expect(existsUninstallable).assertFalse();
    })

    it('test_isAllCanDirectlyRemove', 0, () => {
      item.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      let isAllCanDirectlyRemove: boolean = (uninstaller as object)['isAllCanDirectlyRemove']([item]);
      expect(isAllCanDirectlyRemove).assertTrue();

      item.typeId = CommonConstants.TYPE_APP;
      item.appStatus = AppStatus.DOWNLOADING;
      isAllCanDirectlyRemove = (uninstaller as object)['isAllCanDirectlyRemove']([item]);
      expect(isAllCanDirectlyRemove).assertTrue();

      item.isUninstallAble = false;
      isAllCanDirectlyRemove = (uninstaller as object)['isAllCanDirectlyRemove']([item]);
      expect(isAllCanDirectlyRemove).assertTrue();
    })

  })
}

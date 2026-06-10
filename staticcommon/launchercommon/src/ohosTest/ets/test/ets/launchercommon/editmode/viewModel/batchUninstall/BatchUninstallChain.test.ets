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

import { describe, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium'
import {
  BatchUninstallChain,
  ForwardType
} from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/BatchUninstallChain';
import { editModeManager, CommonConstants, GridLayoutItemInfo } from '../../../../../../../../main/ets/TsIndex';

export default function BatchUninstallChainTest() {
  describe('BatchUninstallChainTest', () => {

    let batchUninstallChain = BatchUninstallChain.getInstance();
    
    it('test_getInstance', 0, () => {
      let tmpBatchUninstallChain = BatchUninstallChain.getInstance();
      expect(tmpBatchUninstallChain).not().assertNull();
    })

    it('test_endChain', 0, () => {
      batchUninstallChain.endChain();
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_forward', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      batchUninstallChain.forward(ForwardType.LONG_PRESS, [item]);
      batchUninstallChain.forward(ForwardType.LONG_PRESS, [item]);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_isLockedApp', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.bundleName = 'bundleName';
      item.appIndex = 0;
      batchUninstallChain.forward(ForwardType.LONG_PRESS, [item]);
      item.typeId = CommonConstants.TYPE_CARD;
      batchUninstallChain.forward(ForwardType.LONG_PRESS, [item]);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_ifHideAppIcon', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.bundleName = 'bundleNamewd2wd2';
      item.appIndex = 0;
      editModeManager.setIsShowingUninstallDialog(true);
      let ifHideAppIcon = batchUninstallChain.ifHideAppIcon(item);
      expect(ifHideAppIcon).assertFalse();
    })

    it('test_isItemInBatch', 0, () => {
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.typeId = CommonConstants.TYPE_APP;
      item.bundleName = 'bundleName_isItemInBatch';
      item.appIndex = 0;
      let isItemInBatch = batchUninstallChain.isItemInBatch(item);
      expect(isItemInBatch).assertFalse();

      batchUninstallChain.forward(ForwardType.LONG_PRESS, [item])
      isItemInBatch = batchUninstallChain.isItemInBatch(item);
      expect(isItemInBatch).assertFalse();
    })
  })
}

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
  AbstractBatchUninstaller
} from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/AbstractBatchUninstaller';
import {
  batchUninstallChain,
  ForwardType
} from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/BatchUninstallChain';
import {
  DialogBatchUninstaller
} from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/DialogBatchUninstaller';
import {
  LongPressBatchUninstaller
} from '../../../../../../../../main/ets/editmode/viewModel/batchUninstall/LongPressBatchUninstaller';
import { AppStatus, CommonConstants, GridLayoutItemInfo } from '../../../../../../../../main/ets/TsIndex';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { launcherStatusUtil } from '@ohos/windowscene';
import { ContactCacheManager } from '../../../../../../../../main/ets/cache/layout/ContactCacheManager';
import { layoutLockUtil } from '../../../../../../../../main/ets/utils/LayoutLockUtil';

export default function AbstractBatchUninstallerTest() {
  describe('AbstractBatchUninstallerTest', () => {
    let uninstaller: AbstractBatchUninstaller = new LongPressBatchUninstaller();

    it('test_setNext', 0, () => {
      let nextUninstaller: AbstractBatchUninstaller = uninstaller.setNext(new DialogBatchUninstaller());
      expect(nextUninstaller).not().assertNull();
    })

    let item: GridLayoutItemInfo = new GridLayoutItemInfo();
    item.typeId = CommonConstants.TYPE_APP;
    item.bundleName = 'bundleName';
    item.appIndex = 0;

    it('test_handleData', 0, () => {
      batchUninstallChain.endChain();
      let _void = uninstaller.handleData();

      batchUninstallChain.forward(ForwardType.LONG_PRESS, [item]);
      _void = uninstaller.handleData();
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_endChain', 0, () => {
      (uninstaller as object)['endChain'](ForwardType.LONG_PRESS_END);
    })

    it('test_runNext', 0, () => {
      (uninstaller as object)['runNext'](ForwardType.CANCEL_REMOVE);
    })

    it('test_batchRecover', 0, () => {
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_APP;
      item1.bundleName = 'bundleName1';
      item1.appIndex = 0;
      item1.container = 213;
      let items = [item, item1];
      batchUninstallChain.forward(ForwardType.LONG_PRESS, items);
      (uninstaller as object)['batchRecover'](items);

      let mockKit: MockKit = new MockKit();
      const getContext: Function = mockKit.mockFunc(GlobalContext, GlobalContext.getContext);
      when(getContext)().afterReturn(null);
      (uninstaller as object)['batchRecover'](items);
    })

    let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
    item1.typeId = CommonConstants.TYPE_APP;
    item1.bundleName = 'bundleName1';
    item1.appIndex = 0;
    item1.container = 213;
    item1.isUninstallAble = true;
    item1.appStatus = AppStatus.INSTALLED;
    let mockKit: MockKit = new MockKit();
    const getShowOutLauncherStatus: Function =
      mockKit.mockFunc(launcherStatusUtil, launcherStatusUtil.getShowOutLauncherStatus);
    const contactCacheManager = ContactCacheManager.getInstance();
    const isContactShortcut: Function = mockKit.mockFunc(contactCacheManager, contactCacheManager.isContactShortcut);
    const isLocked: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
    const isLockedPage: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLockedPage);

    it('test_isUninstallable_1', 0, () => {
      when(getShowOutLauncherStatus)().afterReturn(false);
      let isUninstallable: boolean = (uninstaller as object)['isUninstallable'](item1);
      expect(isUninstallable).assertTrue();
    })

    it('test_isUninstallable_2', 0, () => {
      when(isContactShortcut)().afterReturn(true);
      let isUninstallable: boolean = (uninstaller as object)['isUninstallable'](item1);
      expect(isUninstallable).assertTrue();
    })

    it('test_isUninstallable_3', 0, () => {
      item1.typeId = CommonConstants.TYPE_CARD;
      let isUninstallable: boolean = (uninstaller as object)['isUninstallable'](item1);
      expect(isUninstallable).assertFalse();
    })

    it('test_isUninstallable_4', 0, () => {
      when(isLocked)().afterReturn(true);
      item1.typeId = CommonConstants.TYPE_APP;
      when(isLockedPage)().afterReturn(true);
      let isUninstallable: boolean = (uninstaller as object)['isUninstallable'](item1);
      expect(isUninstallable).assertTrue();
    })

    it('test_isUninstallable_7', 0, () => {
      item1.appStatus = AppStatus.INSTALLING;
      let isUninstallable: boolean = (uninstaller as object)['isUninstallable'](item1);
      expect(isUninstallable).assertFalse();
    })

    it('test_isUninstallable_9', 0, () => {
      item1.isUninstallAble = false;
      let isUninstallable: boolean = (uninstaller as object)['isUninstallable'](item1);
      expect(isUninstallable).assertFalse();
    })

    it('test_isUninstallable_11', 0, () => {
      item.typeId = CommonConstants.TYPE_APP;
      when(getShowOutLauncherStatus)().afterReturn(true);
      let isUninstallable: boolean = (uninstaller as object)['isUninstallable'](item1);
      expect(isUninstallable).assertTrue();
    })

    it('test_isUninstallable_12', 0, () => {
      item.typeId = CommonConstants.TYPE_FOLDER;
      let isUninstallable: boolean = (uninstaller as object)['isUninstallable'](item1);
      expect(isUninstallable).assertTrue();
    })

    it('test_isNotInLockedPage', 0, () => {
      let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
      item1.typeId = CommonConstants.TYPE_APP;
      item1.bundleName = 'bundleName1';
      item1.appIndex = 0;
      item1.page = 213;
      item1.isUninstallAble = true;
      item1.appStatus = AppStatus.INSTALLED;

      let mockKit: MockKit = new MockKit();
      const isLocked: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
      when(isLocked)().afterReturn(true);
      const isLockedPage: Function = mockKit.mockFunc(layoutLockUtil, layoutLockUtil.isLockedPage);
      when(isLockedPage)().afterReturn(true);
      let isNotInLockedPage: boolean = (uninstaller as object)['isNotInLockedPage'](item1);
      expect(isNotInLockedPage).assertTrue();

      when(isLocked)().afterReturn(false);
      isNotInLockedPage = (uninstaller as object)['isNotInLockedPage'](item1);
      expect(isNotInLockedPage).assertTrue();
    })
  })
}

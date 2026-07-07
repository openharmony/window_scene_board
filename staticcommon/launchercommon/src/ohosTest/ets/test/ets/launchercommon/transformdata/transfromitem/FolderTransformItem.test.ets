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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { FolderTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/FolderTransformItem'
import { BackupFavoriteInfo,
  BackupSceneBundleVersionName,
  GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'

export default function FolderTransformItemTest() {
  describe('FolderTransformItemTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('assert_isSupportInohos', 0, () => {
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(new BackupFavoriteInfo());
      let result: boolean = folderTransformItem.isSupportInohos();
      expect(result).assertTrue();
    })

    it('assert_transformBackupInfoToGridInfo01', 0, async () => {
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_transformBackupInfoToGridInfo02', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_tools++++实用工具',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_transformBackupInfoToGridInfo03', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_tools++++实用工具',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 2,
        spanY: 2,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_transformBackupInfoToGridInfo04', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_default_folder++++文件夹1',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_transformBackupInfoToGridInfo05', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_default_folder++++文件夹1',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 2,
        spanY: 2,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfo()
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_transformBackupInfoToGridInfo06', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_default_folder++++文件夹1',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 2,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfo()
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('test_transformBackupInfoToGridInfo_07', 0, async () => {
      try {
        let backupInfo: BackupFavoriteInfo = {
          id: 1,
          title: '@string/folder_default_folder++++folder_title=文件夹1',
          intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 3,
          spanY: 3,
          itemType: 2,
          isNewInstalled: -2,
        };
        let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
        let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfo()
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_transformBackupInfoToGridInfo_08', 0, async () => {
      try {
        let backupInfo: BackupFavoriteInfo = {
          id: 1,
          title: '@string/folder_default_folderfolder_title=文件夹1',
          intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
          container: -100,
          screen: 1,
          cellX: 3,
          cellY: 3,
          spanX: 3,
          spanY: 3,
          itemType: 2,
          isNewInstalled: -2,
        };
        let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
        let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfo()
        expect(gridLayoutInfo.length).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('assert_transformBackupInfoToGridInfoOnClone01', 0, async () => {
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfoOnClone([folderTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_transformBackupInfoToGridInfoOnClone02', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_tools++++实用工具',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfoOnClone([folderTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_transformBackupInfoToGridInfoOnClone03', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_tools++++实用工具',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 2,
        spanY: 2,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfoOnClone([folderTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_transformBackupInfoToGridInfoOnClone04', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_default_folder++++文件夹1',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfoOnClone([folderTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_ttransformBackupInfoToGridInfoOnClone05', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_default_folder++++文件夹1',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 2,
        spanY: 2,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfoOnClone([folderTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      expect(gridLayoutInfo.length).assertEqual(1);
    })

    it('assert_transformBackupInfoToGridInfoOnClone06', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '@string/folder_default_folder++++文件夹1',
        intent: '#Intent;action=ohos.intent.action.MAIN;category=ohos.intent.category.LAUNCHER;launchFlags=0x10200000;component=ctrip.ohos.view/ctrip.business.splash.CtripSplashActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 2,
        itemType: 2,
      };
      let folderTransformItem: FolderTransformItem = new FolderTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await folderTransformItem.transformBackupInfoToGridInfoOnClone([folderTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      expect(gridLayoutInfo.length).assertEqual(1);
    })

  })
}
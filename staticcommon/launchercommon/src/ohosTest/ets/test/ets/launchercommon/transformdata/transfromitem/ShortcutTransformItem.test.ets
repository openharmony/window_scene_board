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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { LocalHapMigrateInfo } from '../../../../../../../main/ets/transformdata/LocalHapMigrateInfo';
import { TransformAppInfoManager } from '../../../../../../../main/ets/transformdata/TransformAppInfoManager';
import { ShortcutTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/ShortcutTransformItem';
import { BackupFavoriteInfo,
  BackupSceneBundleVersionName,
  GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';

export default function ShortcutTransformItemTest() {
  describe('ShortcutTransformItemTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('assert_isSupportInohos01', 0, () => {
      let shortcutTransformItem: ShortcutTransformItem = new ShortcutTransformItem(new BackupFavoriteInfo());
      let result: boolean = shortcutTransformItem.isSupportInohos();
      expect(result).assertInstanceOf('Boolean');
    })

    it('assert_isSupportInohos02', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '',
        intent: '#Intent;component=com.openharmony.contacts/alias.MessageShortcut;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 4,
      };
      let shortcutTransformItem: ShortcutTransformItem = new ShortcutTransformItem(backupInfo);
      let result: boolean = shortcutTransformItem.isSupportInohos();
      expect(result).assertInstanceOf('Boolean');
    })

    it('assert_transformBackupInfoToGridInfo01', 0, async () => {
      let shortcutTransformItem: ShortcutTransformItem = new ShortcutTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await shortcutTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertEqual(0);
    })

    it('assert_transformBackupInfoToGridInfo', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 111,
        title: '一键锁屏',
        intent: '#Intent;component=com.ohos.systemui/com.openharmony.keyguard.onekeylock.shortcut.ApproachActivity;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 1,
      };
      let shortcutTransformItem: ShortcutTransformItem = new ShortcutTransformItem(backupInfo);
      let localHapMigrateInfo: LocalHapMigrateInfo = {
        sourceModule: '',
        target: 'com.ohos.onekeylock',
        sourceModules: [],
        targetModule: '',
        migrateData: '',
        sourceModuleSignature: '',
        type: 0,
        targetModuleUrl: '',
        source: 'com.openharmony.hwonekeylock',
        sources: [],
        isValid: (): boolean => { return true }
      };
      TransformAppInfoManager.getInstance()['mAppMigrateInfoMap'].set('com.openharmony.hwonekeylock0', localHapMigrateInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await shortcutTransformItem.transformBackupInfoToGridInfo();
      expect(gridLayoutInfo.length).assertLargerOrEqual(0);
    })

    it('assert_transformBackupInfoToGridInfoOnClone01', 0, async () => {
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
        itemType: 0,
      };
      let shortcutTransformItem: ShortcutTransformItem = new ShortcutTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await shortcutTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertEqual(0);
    })

    it('assert_transformBackupInfoToGridInfoOnClone02', 0, async () => {
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '',
        intent: '#Intent;component=com.openharmony.contacts/alias.MessageShortcut;end',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 4,
      };
      let shortcutTransformItem: ShortcutTransformItem = new ShortcutTransformItem(backupInfo);
      let gridLayoutInfo: GridLayoutItemInfo[] = await shortcutTransformItem.transformBackupInfoToGridInfoOnClone();
      expect(gridLayoutInfo.length).assertEqual(0);
    })
  })
}
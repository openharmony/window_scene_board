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
import { BaseTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/BaseTransformItem'
import { BackupFavoriteInfo,
  BackupSceneBundleVersionName,
  dataConvert,
  GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex'

export default function BaseTransformItemTest() {
  describe('BaseTransformItemTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    it('assert_isSupportInohos', 0, () => {
      let baseTransformItem: BaseTransformItem = new BaseTransformItem(new BackupFavoriteInfo());
      let result: boolean = baseTransformItem.isSupportInohos();
      expect(result).assertFalse();
    })

    it('assert_transformBackupInfoToGridInfo', 0, async () => {
      let baseTransformItem: BaseTransformItem = new BaseTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await baseTransformItem.transformBackupInfoToGridInfo([baseTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_MIGRATE_ohos);
      expect(gridLayoutInfo.length).assertEqual(0);
    })

    it('assert_transformBackupInfoToGridInfoOnClone', 0, async () => {
      let baseTransformItem: BaseTransformItem = new BaseTransformItem(new BackupFavoriteInfo());
      let gridLayoutInfo: GridLayoutItemInfo[] = await baseTransformItem.transformBackupInfoToGridInfoOnClone([baseTransformItem],
        BackupSceneBundleVersionName.HWLAUNCHER_TO_ohos);
      expect(gridLayoutInfo.length).assertEqual(0);
    })

    it('assert_buildGridInfoByBackupInfo', 0, async () => {
      let baseTransformItem: BaseTransformItem = new BaseTransformItem(new BackupFavoriteInfo());
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.id = 1;
      backupInfo.spanX = 1;
      backupInfo.spanY = 1;
      backupInfo.screen = 1;
      backupInfo.cellX = 1;
      backupInfo.cellY = 1;
      backupInfo.container = 1;
      backupInfo.profileId = 1;
      dataConvert.setCurUserId(100);
      let ret = baseTransformItem['buildGridInfoByBackupInfo'](backupInfo);
      dataConvert.setCurUserId(0);
      ret = baseTransformItem['buildGridInfoByBackupInfo'](backupInfo);
      expect(ret.id).assertEqual(1);
    })
  })
}
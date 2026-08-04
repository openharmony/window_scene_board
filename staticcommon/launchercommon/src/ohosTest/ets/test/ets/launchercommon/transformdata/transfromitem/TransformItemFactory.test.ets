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
import { BackupItemType } from '../../../../../../../main/ets/model/BackupFavoriteInfo'
import { AppTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/AppTransformItem'
import { BaseTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/BaseTransformItem'
import { CardTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/CardTransformItem'
import {
  CombineCardTransformItem
} from '../../../../../../../main/ets/transformdata/transfromitem/CombineCardTransformItem'
import { FolderTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/FolderTransformItem'
import { ShortcutTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/ShortcutTransformItem'
import {
  StackCardTransformItem
} from '../../../../../../../main/ets/transformdata/transfromitem/StackCardTransformItem'
import { TransformItemFactory } from '../../../../../../../main/ets/transformdata/transfromitem/TransformItemFactory'
import { WidgetTransformItem } from '../../../../../../../main/ets/transformdata/transfromitem/WidgetTransformItem'
import { BackupFavoriteInfo } from '../../../../../../../main/ets/TsIndex'

export default function TransformItemFactoryTest() {
  describe('TransformItemFactoryTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('assert_app_transformItem00', 0, () => {
      let transformItemFactoryInstance: TransformItemFactory = TransformItemFactory.getInstance();
      expect(transformItemFactoryInstance instanceof TransformItemFactory).assertTrue();
    })

    it('assert_app_transformItem01', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo: BackupFavoriteInfo = {
        id: 1,
        title: '天气',
        intent: '',
        container: -100,
        screen: 1,
        cellX: 3,
        cellY: 3,
        spanX: 1,
        spanY: 1,
        itemType: 0,
      };
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_APP;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof AppTransformItem).assertTrue();
    })

    it('assert_folder_transformItem02', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_FOLDER;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof FolderTransformItem).assertTrue();
    })

    it('assert_folder_transformItem03', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_LIVE_FOLDER;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof FolderTransformItem).assertTrue();
    })

    it('assert_folder_transformItem04', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_BIG_FOLDER;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof FolderTransformItem).assertTrue();
    })

    it('assert_folder_transformItem05', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_WIDGET;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof WidgetTransformItem).assertTrue();
    })

    it('assert_folder_transformItem06', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_SHORTCUT;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof ShortcutTransformItem).assertTrue();
    })

    it('assert_folder_transformItem06_1', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_SPECIAL_SHORTCUT;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof ShortcutTransformItem).assertTrue();
    })

    it('assert_folder_transformItem07', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_CARD;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof CardTransformItem).assertTrue();
    })

    it('assert_folder_transformItem08', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_STACK_CARD;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof StackCardTransformItem).assertTrue();
    })

    it('assert_folder_transformItem09', 0, () => {
      let transformItemFactory: TransformItemFactory = new TransformItemFactory();
      let backupInfo = new BackupFavoriteInfo();
      backupInfo.itemType = BackupItemType.BACKUP_ITEM_TYPE_COMBINE_CARD;
      let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
      expect(baseTransformItem instanceof CombineCardTransformItem).assertTrue();
    })

    it('test_getTransformItem_10', 0, () => {
      try {
        let backupInfo = new BackupFavoriteInfo();
        backupInfo.itemType = -99;
        let transformItemFactory: TransformItemFactory = new TransformItemFactory();
        let baseTransformItem: BaseTransformItem = transformItemFactory.getTransformItem(backupInfo);
        expect(baseTransformItem instanceof BaseTransformItem).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })
  })
}
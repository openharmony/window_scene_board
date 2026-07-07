/**
 * Copyright (c) 2024-2024 Huawei Device Co., Ltd.
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
import { BackupItemType, BackupFavoriteInfo } from '../../model/BackupFavoriteInfo';
import { AppTransformItem } from './AppTransformItem';
import { BaseTransformItem } from './BaseTransformItem';
import { CardTransformItem } from './CardTransformItem';
import { CombineCardTransformItem } from './CombineCardTransformItem';
import { FolderTransformItem } from './FolderTransformItem';
import { ShortcutTransformItem } from './ShortcutTransformItem';
import { StackCardTransformItem } from './StackCardTransformItem';
import { WidgetTransformItem } from './WidgetTransformItem';

export class TransformItemFactory {
  private static mInstance: TransformItemFactory;

  static getInstance(): TransformItemFactory {
    if (TransformItemFactory.mInstance == null) {
      TransformItemFactory.mInstance = new TransformItemFactory();
    }
    return TransformItemFactory.mInstance;
  }

  public getTransformItem(backupInfo: BackupFavoriteInfo): BaseTransformItem {
    switch (backupInfo.itemType) {
      case BackupItemType.BACKUP_ITEM_TYPE_APP:
        return new AppTransformItem(backupInfo);
      case BackupItemType.BACKUP_ITEM_FOLDER:
        return new FolderTransformItem(backupInfo);
      case BackupItemType.BACKUP_ITEM_LIVE_FOLDER:
        return new FolderTransformItem(backupInfo);
      case BackupItemType.BACKUP_ITEM_TYPE_WIDGET:
        return new WidgetTransformItem(backupInfo);
      case BackupItemType.BACKUP_ITEM_TYPE_SPECIAL_SHORTCUT:
      case BackupItemType.BACKUP_ITEM_TYPE_SHORTCUT:
        return new ShortcutTransformItem(backupInfo);
      case BackupItemType.BACKUP_ITEM_TYPE_CARD:
        return new CardTransformItem(backupInfo);
      case BackupItemType.BACKUP_ITEM_BIG_FOLDER:
        return new FolderTransformItem(backupInfo);
      case BackupItemType.BACKUP_ITEM_TYPE_STACK_CARD:
        return new StackCardTransformItem(backupInfo);
      case BackupItemType.BACKUP_ITEM_TYPE_COMBINE_CARD:
        return new CombineCardTransformItem(backupInfo);
      default:
        return new BaseTransformItem(backupInfo);
    }
  }
}
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

import type image from '@ohos.multimedia.image';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GridLayoutItemInfo } from '../TsIndex';
import { InputRecItem } from './InputRecItem';

const TAG = 'LauncherRecItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 语音助手建议卡片显示的item
 *
 * @since 2023-10-08
 */
export class LauncherRecItem extends InputRecItem {
  public cardId: string = '';

  public appIconId: number = 0;

  public isCreating: boolean = false; // 是否创建中

  public icon: string | image.PixelMap = '';

  public appIndex: number = 0;

  public badgeNumber: number = 0;

  public keyName: string = '';

  public isTransparent: boolean = false;

  public extend1?: string;

  public subLauncherRecItems: LauncherRecItem[] = [];

  public static isValid(item: LauncherRecItem): boolean {
    return !CheckEmptyUtils.isEmpty(item) && !CheckEmptyUtils.isEmpty(item.itemType) &&
      !CheckEmptyUtils.isEmpty(item.rowStart) && !CheckEmptyUtils.isEmpty(item.columnStart) &&
      !CheckEmptyUtils.isEmpty(item.rowSpan) && !CheckEmptyUtils.isEmpty(item.columnSpan);
  }

  /**
   * 获取唯一值
   *
   * @param formItem 卡片
   * @param item item
   * @param iconSize 图标大小
   * @returns 唯一值
   */
  public static getItemUniqueKey(formItem: GridLayoutItemInfo, item: LauncherRecItem): string {
    const itemKey = LauncherRecItem.getUniqueId(item);
    log.showInfo(`getItemUniqueKey item ${formItem?.cardId} uniqueKey: ${itemKey}`);
    return itemKey;
  }

  /**
   * 获取应用组的唯一值
   *
   * @param formItem 卡片
   * @param item item
   * @returns 唯一值
   */
  public static getSubItemUniqueKey(formItem: GridLayoutItemInfo, item: LauncherRecItem): string {
    let subItemKey = '';
    if (!item) {
      return subItemKey;
    }
    if (item.subLauncherRecItems) {
      subItemKey = item.subLauncherRecItems.map(subItem => {
        return LauncherRecItem.getUniqueId(subItem);
      }).join('_');
    }
    log.showInfo(`getItemUniqueKey item ${formItem?.cardId} subItemKey: ${subItemKey}`);
    return subItemKey;
  }

  /**
   * 通过推荐数据生成唯一ID
   *
   * @param item 推荐数据
   * @param iconSize 图标大小
   * @param formItemWidth 卡片宽度
   * @param formItemHeight 卡片高度
   * @returns 唯一ID
   */
  public static getUniqueId(item: LauncherRecItem): string {
    if (CheckEmptyUtils.isEmpty(item)) {
      return '';
    }
    return [item.serviceId, item.rowStart, item.columnStart,
      item.appIconId, item.iconUrl, item.deepLink, item.badgeNumber, item.bundleName,
      item.moduleName, item.abilityName, item.formName, item.dimension].join('_');
  }
}

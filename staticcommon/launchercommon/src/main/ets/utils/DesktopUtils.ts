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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { DeviceHelper, GlobalContext } from '@ohos/frameworkwrapper';
import { CommonConstants, GridLayoutItemInfo, DockItemInfo, ContactCacheManager } from '../TsIndex';
import { ResourceManager } from '@ohos/frameworkwrapper';
import { util } from '@kit.ArkTS';
import { settings, systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG = 'DesktopUtils';
const log = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * Desktop utils
 */
export class DesktopUtils {
  public static getGridItemId(indexInSwiper: number, item: GridLayoutItemInfo, isOuterDesktop: boolean = false): string {
    if (!item) {
      log.showError(`get gridItemId fail, item is invalid.`);
      return '';
    }
    if (item.typeId === CommonConstants.TYPE_APP) {
      let itemId:string = CommonConstants.SWIPER_GRID_TAG + item.bundleName + `${item.appIndex ?? 0}`;
      itemId = isOuterDesktop ? itemId + '_OuterDesktop' : itemId;
    }

    return CommonConstants.SWIPER_GRID_TAG + '[' + DesktopUtils.getItemKey(item, isOuterDesktop) + ',' +
      indexInSwiper + ']';
  }

  /**
   * 生成唯一id
   *
   * @returns 唯一id
   */
  public static generateRandomUUID(): string {
    return util.generateRandomUUID();
  }

  // 组件在宫格内位置变化不触发forEach刷新，需要把获取组件相关属性值的索引和row以及column解绑
  public static getItemKey(item: GridLayoutItemInfo, isOuterDesktop: boolean = false): string {
    if (!item) {
      log.showError(`get gridItemId fail, item is invalid.`);
      return '';
    }
    let itemKey =
      `${item.bundleName}_${item.folderId ?? ''}_${item.cardId ?? ''}_${item.appIconId}_${item.formStackId ??
        ''}_${item.shortcutId ?? ''}_${item.appIndex ?? 0}`;
    return isOuterDesktop ? (itemKey + `_OuterDesktop`) : itemKey;
  }

  /**
   * 桌面元素对象转换为string字符串
   * @param item 桌面元素对象
   * @returns string字符串
   */
  public static desktopItemsToString(item: GridLayoutItemInfo | GridLayoutItemInfo[]): string {
    if (!item) {
      return '';
    }
    if (Array.isArray(item)) {
      let ret: string = '[';
      item.forEach((it: GridLayoutItemInfo) => {
        ret += `{${DesktopUtils.itemToString(it)}}`;
      });
      ret += ']';
      return ret;
    } else {
      return `{${DesktopUtils.itemToString(item)}}`;
    }
  }

  /**
   * 元素转换为字符串
   * @param item 元素对象
   * @returns 字符串
   */
  private static itemToString(item: GridLayoutItemInfo): string {
    return [`id:${item.id ?? 0}`, `infoId:${item.infoId ?? ''}`, `cardId:${item.cardId ?? ''}`,
      `folderId:${item.folderId ?? ''}`, `formStackId:${item.formStackId ?? ''}`, `container:${item.container ?? 0}`,
      `ino:${item.ino ?? ''}`, `fileType:${item.fileType ?? 0}`,
      `badgeNumber:${item.badgeNumber ?? 0}`, `typeId:${item.typeId ?? 0}`, `area:${item.area ?? ''}`,
      `page:${item.page}`, `column:${item.column}`, `row:${item.row}`, `kindId:${item.kindId ?? 0}`,
      `portraitPage:${item.portraitPage ?? -1}`, `portraitRow:${item.portraitRow ?? -1}`,
      `portraitColumn:${item.portraitColumn ?? -1}`, `portraitWidth: ${item.portraitArea?.[0] ?? -1}`,
      `portraitHeight: ${item.portraitArea?.[1] ?? -1}`, `landscapePage: ${item.landscapePage ?? -1}`,
      `landscapeRow: ${item.landscapeRow ?? -1}`, `landscapeColumn: ${item.landscapeColumn ?? -1}`,
      `landscapeWidth: ${item.landscapeArea?.[0] ?? -1}`, `landscapeHeight: ${item.landscapeArea?.[1] ?? -1}`,
      `bundleName:${item.bundleName}`, `abilityName:${item.abilityName}`, `moduleName:${item.moduleName ?? ''}`,
      `keyName:${item.keyName ?? ''}`, `appIconId:${item.appIconId}`, `appLabelId:${item.appLabelId ?? 0}`,
      `appName:${item.appName ?? ''}`, `cardName:${item.cardName ?? ''}`, `appStatus:${item.appStatus}`,
      `isTransparent:${item.isTransparent}`,
      `shortcutId:${item.shortcutId ?? ''}`, `appIndex:${item.appIndex ?? 0}`, `intent:${item.intent ?? ''}`]
      .join(', ');
  }

  /**
   * 获取桌面图标无障碍描述
   *
   * @param isAccessibilityMode 是否无障碍模式
   * @param isLockLayoutInEditMode 是否编辑锁定模式
   * @param item 组件信息
   * @returns 无障碍朗读描述内容
   */
  public static getAccessibilityDescription(isAccessibilityMode: boolean, isLockLayoutInEditMode: boolean,
    item: GridLayoutItemInfo | DockItemInfo): string {
    if (!isAccessibilityMode || isLockLayoutInEditMode) {
      return '';
    }
    const isContactShortcut: boolean = ContactCacheManager.getInstance().isContactShortcut(item);
    const resourceManager = ResourceManager.getInstance();
    return isContactShortcut ? resourceManager.getStringByName('double_tap_to_execute') :
    resourceManager.getStringByName('tap_with_menu_reader_text');
  }
}
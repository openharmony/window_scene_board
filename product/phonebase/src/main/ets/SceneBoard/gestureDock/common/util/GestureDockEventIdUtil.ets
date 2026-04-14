/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockItemInfo } from '../../dockbar/model/GestureDockItemInfo';
import { GestureDockConstants } from '../GestureDockConstants';

/**
 * 侧边dock工具类
 */
export class GestureDockEventIdUtil {
  /**
   * 获取开始挤位动效的事件Id
   *
   * @param itemInfo
   * @returns startSqueezeEventId
   */
  public static getStartSqueezeEventId(itemInfo: GestureDockItemInfo): string {
    return `${GestureDockConstants.GESTURE_DOCK_ITEM_SQUEEZE_START}${itemInfo.bundleName}${itemInfo.appIndex}`;
  }

  /**
   * 获取DockItem是否显示的事件Id
   *
   * @param itemInfo
   * @returns dockItemVisibleEventId
   */
  public static getDockItemVisibleEventId(itemInfo: GestureDockItemInfo | undefined): string {
    return `${GestureDockConstants.GESTURE_DOCK_VISIBLE}${itemInfo?.bundleName}${itemInfo?.appIndex}`;
  }

  /**
   * 获取DockItem拖拽松手的事件Id
   *
   * @param itemInfo
   * @returns dockItemDropEventId
   */
  public static getDockItemDropEventId(itemInfo: GestureDockItemInfo): string {
    return `${GestureDockConstants.GESTURE_DOCK_ITEM_DROP}${itemInfo?.bundleName}${itemInfo?.appIndex}`;
  }

  /**
   * 获取AllApps应用置灰的事件Id
   *
   * @param itemInfo
   * @returns allAppsGrayEventId
   */
  public static getAllAppsGrayEventId(itemInfo: GestureDockItemInfo): string {
    return `gray_${GestureDockConstants.GESTURE_DOCK_ALL_APPS}${itemInfo?.bundleName}${itemInfo?.appIndex}`;
  }

  /**
   * 获取AllApps应用置灰的事件Id
   *
   * @param bundleName
   * @param appIndex
   * @returns allAppsGrayEventIdByString
   */
  public static getAllAppsGrayEventIdByString(bundleName?: string, appIndex?: number): string {
    return `gray_${GestureDockConstants.GESTURE_DOCK_ALL_APPS}${bundleName}${appIndex}`;
  }

  /**
   * 获取拖拽截图的应用Id
   *
   * @param itemInfo
   * @param dockDirection
   * @returns snapShotItemId
   */
  public static getSnapShotItemId(itemInfo: GestureDockItemInfo, dockDirection: number): string {
    return GestureDockConstants.GESTURE_DOCK_ITEM_TAG + itemInfo?.bundleName + itemInfo?.appIndex + dockDirection;
  }

  /**
   * 获取ResidentLayoutAppTag
   *
   * @param itemInfo
   * @returns ResidentLayoutAppTag
   */
  public static getResidentLayoutAppTag(itemInfo: GestureDockItemInfo): string {
    return CommonConstants.RESIDENT_LAYOUT_APP_TAG + itemInfo?.bundleName + itemInfo?.abilityName + itemInfo?.appIndex;
  }
}
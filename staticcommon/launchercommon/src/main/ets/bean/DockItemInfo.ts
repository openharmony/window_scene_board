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

import type GridLayoutItemInfo from './GridLayoutItemInfo';
import { RecentBundleMissionInfo } from './RecentBundleMissionInfo';
import type rdb from '@ohos.data.relationalStore';
import {GridLayoutInfoEnums} from '../db/column/GridLayoutInfoColumns';

/**
 * Item info of smartdock item.
 */
export class DockItemInfo extends RecentBundleMissionInfo {
  /**
   * Type of smartdock item:
   * 0: appications
   * 1: forms
   * 2: launcher functions
   */
  public itemType?: number;

  /**
   * true if this item is editable
   */
  public editable?: boolean;

  /**
   * true if this item is visible
   */
  public visible: boolean = true;

  /**
   * true if this item border is visible
   */
  public borderVisible: boolean = false;

  /**
   * non-zero if this item is shaking
   * */
  public shake: number = 0;

  public layoutInfo?: Array<GridLayoutItemInfo[]>;

  /**
   * icon Id
   */
  public iconId?: string;

  /**
   * custom folder in dock
   */
  public extend1?: string;

  /**
   * id 文件夹id(数据库里的每行数据主键_id值)
   */
  public id?: number;

  /**
   * Indicates bundleName.
   */
  public oldBundleNames?: string[] = [];

  /**
   * dock: - 101
   * 文件夹: 文件夹id
   */
  public container?: number;

  /**
   * Type of icon:
   * app
   * continue
   * app and continue
   * car
   * distributed communication
   * multi-screen collaboration
   */
  public iconType?: IconType = IconType.APP;

  /**
   *  app image
   *
   */
  public image?: string;

  /**
   * 远端设备类型：PHONE，PAD，PC等
   */
  public remoteDeviceTypeStr?: string;

  /**
   * 感知场景类型
   */
  public perceptionSceneType?: string;

  /**
   * 克隆或者升级场景
   */
  public callerName?: string;

  /**
   *  将dockItem转化为ValuesBucket
   *
   * @param item 待转化元素
   * @returns 转化结果
   */
  public static toValuesBucket(item: DockItemInfo): rdb.ValuesBucket {
    if (!item) {
      return {};
    }
    return {
      [GridLayoutInfoEnums.INFO_ID]: item.appId,
      [GridLayoutInfoEnums.TYPE_ID]: item.itemType,
      [GridLayoutInfoEnums.BUNDLE_NAME]: item.bundleName,
      [GridLayoutInfoEnums.MODULE_NAME]: item.moduleName,
      [GridLayoutInfoEnums.ABILITY_NAME]: item.abilityName,
      [GridLayoutInfoEnums.APP_ICON_ID]: item.appIconId,
      [GridLayoutInfoEnums.APP_LABEL_ID]: item.appLabelId,
      [GridLayoutInfoEnums.INFO_NAME]: item.appName,
      [GridLayoutInfoEnums.ICON_RESOURCE]: item.iconId,
      [GridLayoutInfoEnums.WIDTH]: 1,
      [GridLayoutInfoEnums.HEIGHT]: 1,
      [GridLayoutInfoEnums.USER_ID]: 100,
      [GridLayoutInfoEnums.ROW]: 0,
      [GridLayoutInfoEnums.APP_STATUS]: item.appStatus,
      [GridLayoutInfoEnums.APP_INDEX]: item.appIndex ?? 0,
      [GridLayoutInfoEnums.SHORTCUT_ID]: item.shortcutId ?? '',
    };
  }
}

/**
 * Dock图标类型
 */
export const enum IconType {
  /**
   * 应用图标
   */
  APP = 'app',
  /**
   * 车机
   */
  CAR = 'car',
  /**
   * 多屏协同
   */
  MULTI_SCREEN_COLLABORATION = 'multi-screen collaboration'
}

/**
 * Dock图标感知场景类型
 */
export const enum PerceptionSceneType {
  /**
   * 车控场景
   */
  CAR_SCENE = '10_0',
  /**
   * 多屏协同场景
   */
  MULTI_SCREEN_COLLABORATION_SCENE = '10_1',
  /**
   * 门店app场景
   */
  STORE_APP_SCENE = '10_2',
}

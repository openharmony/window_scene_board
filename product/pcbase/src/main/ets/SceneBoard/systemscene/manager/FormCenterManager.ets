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

import { Logger, LogDomain } from '@ohos/basicutils';
import { AppItemInfo,
  CardItemInfo,
  FormCenterLocation, GridLayoutItemInfo, GridLayoutUtil,
  LaunchLayoutCacheManager } from '@ohos/launchercommon';
import { Position } from '@kit.ArkUI';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { ObjectCopyUtil } from '@ohos/componenthelper';
import StyleManager from '@ohos/form/src/main/ets/default/manager/StyleManager';

const TAG = 'FormCenterManager';
const log = Logger.getLogHelper(LogDomain.FORM);

const FORM_CENTER_SAFE_HEIGHT = 16;

export class FormCenterManager {
  private static instance: FormCenterManager | undefined = undefined;
  private desktopContext: UIContext | undefined = undefined;

  public static getInstance(): FormCenterManager {
    if (FormCenterManager.instance) {
      return FormCenterManager.instance;
    }
    FormCenterManager.instance = new FormCenterManager();
    return FormCenterManager.instance;
  }

  public init(desktopContext?: UIContext): void {
    this.desktopContext = desktopContext;
  }

  /**
   * 根据卡片中心位置，计算卡片中心偏移量
   * @param formCenterLocation
   * @returns
   */
  public getFormCenterPosition(formCenterLocation?: FormCenterLocation): Position {
    log.showInfo(TAG, `getFormCenterPosition, formCenterLocation:${formCenterLocation}`);
    let position: Position =
      ObjectCopyUtil.deepClone(StyleManager.getSheetFormStyle().sheetOffset ?? { x: 0, y: -16 }) as Position;
    if (!formCenterLocation) {
      return position;
    }
    if (formCenterLocation === FormCenterLocation.DESKTOP) {
      return position;
    }
    if (formCenterLocation === FormCenterLocation.DESKTOP_C_SIDE) {
      return position;
    }
    return position;
  }

  /**
   * 获取卡片中心入口位置，B面/C面/默认
   * @param layoutInfo
   * @param position
   * @returns
   */
  public getFormCenterEnterLocation(layoutInfo?: AppItemInfo | GridLayoutItemInfo, position?: Position):
    FormCenterLocation {
      return FormCenterLocation.DESKTOP;
  }

  private getLocationByPosition(position: Position): FormCenterLocation {
    return FormCenterLocation.DESKTOP_C_SIDE;
  }

  private getLocationByGridLayoutInfo(itemInfo?: GridLayoutItemInfo): FormCenterLocation {
    if (!itemInfo) {
      log.showInfo(TAG, 'getLocationByGridLayoutInfo, item is null');
      return FormCenterLocation.DESKTOP;
    }
    let layoutInfo: GridLayoutItemInfo | undefined = itemInfo;
    const cacheLayoutInfo = LaunchLayoutCacheManager.getInstance().selectGridLayoutItemById(layoutInfo?.infoId);
    log.showInfo(TAG, `getLocationByGridLayoutInfo, item container:${itemInfo.container}, layoutInfo \
    typeID:${layoutInfo?.typeId}, page:${layoutInfo?.page}, cacheInfo page:${cacheLayoutInfo?.page}`);
    // 优先使用缓存数据，避免因为横竖屏共用组件 组件内数据更新不及时 导致参数异常 位置信息异常问题
    layoutInfo = cacheLayoutInfo ?? layoutInfo;
    if (!layoutInfo) {
      log.showWarn(TAG, 'getLocationByGridLayoutInfo layoutInfo is null');
      return FormCenterLocation.DESKTOP;
    }
    return (layoutInfo?.page ?? 0) % 2 === 0 ? FormCenterLocation.DESKTOP_B_SIDE : FormCenterLocation.DESKTOP_C_SIDE;
  }
}
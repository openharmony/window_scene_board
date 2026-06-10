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

import IconInfo from './IconInfo';
import { image } from '@kit.ImageKit';
import { IconExtendParam } from './IconExtendParam';

export interface IconCacheInterface {
  /**
   * 异步方法获取融合图标
   *
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @param param 扩展参数
   * @returns 返回融合图标的string类型
   */
  getCombIcon(bundleName: string, moduleName: string, abilityName: string, param: IconExtendParam): Promise<IconInfo>;

  /**
   * 同步方法获取融合图标
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @returns 返回融合图标的string类型
   */
  getCombIconSync(bundleName: string, moduleName: string, abilityName: string, appIndex?: number): image.PixelMap;

  /**
   * 获取icon信息，包括icon类型，融合图标和前景背景图
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @param appIndex
   * @param combIconFlag
   * @returns 返回icon信息
   */
  getIconResource(bundleName: string, moduleName: string, abilityName: string, appIndex?: number, combIconFlag?: boolean): Promise<IconInfo>;

  /**
   * 设置单个icon图标缓存
   *
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @param iconInfo
   */
  setIconResource(bundleName: string, moduleName: string, abilityName: string, iconInfo:IconInfo,
    param: IconExtendParam):Promise<void>;

  /**
   * 批量设置icon图标缓存
   *
   * @param iconInfos 图标参数集合
   * @param batchId 刷新任务批次,如非资源全量刷新场景可不传
   * @param allFinished 刷新任务结束回调，如不需要完成回调可不传或传空
   */
  setIconResourceArray(iconInfos: IconInfo[], batchId?: number, allFinished?: () => void):Promise<void>;

  /**
   * 删除所有的图标缓存
   */
  deleteAllCache(): Promise<void>;

  /**
   * 删除单个图标缓存
   * @param bundleName
   */
  deleteCache(bundleName: string): Promise<void | boolean>;

  /**
   * 设置icon图标名称缓存
   * @param bundleName
   * @param moduleName
   * @param abilityName
   * @param appName
   * @returns
   */
  setIconNameResource(bundleName: string, moduleName: string, abilityName: string,
    appName: string, appIndex?: number): Promise<void>;
}
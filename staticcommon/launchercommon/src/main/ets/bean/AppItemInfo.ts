/**
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

import { CheckEmptyUtils } from '@ohos/basicutils/src/main/ets/utils/CheckEmptyUtils';
import { AppItemInfoBase } from '@ohos/frameworkcommon/src/main/ets/bean/AppItemInfoBase';
import { BaseIconInfo } from './BaseIconInfo';

/**
 * common app info extends
 */
export class AppItemInfo extends AppItemInfoBase implements BaseIconInfo {
  /**
   * componentId
   */
  public componentId?: string;
  /**
   * Indicates app id.
   */
  public appId?: string;

  /**
   * Indicates appIconId.
   */
  public appIconId: number = 0;

  /**
   * Indicates applicationIconId.
   */
  public applicationIconId?: number;

  /**
   * Indicates appLabelId.
   */
  public appLabelId?: number;

  /**
   * Indicates labelId.
   */
  public labelId?: Resource;

  /**
   * Indicates applicationLabelId.
   */
  public applicationLabelId?: number;

  /**
   * Indicates abilityName.
   */
  public abilityName: string = '';

  /**
   * Indicates is system App.
   */
  public isSystemApp?: boolean;

  /**
   * Indicates is uninstallAble.
   */
  public isUninstallAble?: boolean;

  /**
   * badge number
   */
  public badgeNumber?: number;

  /**
   * Indicates is checked
   */
  public checked?: boolean;

  /**
   * install time
   */
  public installTime?: string;

  /**
   * area Type
   */
  public areaType?: number;

  public moduleName?: string;

  public keyName?: string;

  /**
   * GridLayoutItemInfo: type  0:app  1:card  3:bigfolder
   */
  public typeId?: number;

  /**
   * GridLayoutItemInfo: area
   */
  public area?: number[];

  /**
   * GridLayoutItemInfo: page
   */
  public page?: number;

  /**
   * GridLayoutItemInfo: column of positions
   */
  public column?: number;

  /**
   * GridLayoutItemInfo: row of positions
   */
  public row?: number;

  /**
   * GridLayoutItemInfo: row of positons
   */
  public kindId?: number;

  /**
   * 包类型:APP = 0, ATOMIC_SERVICE = 1
   */
  public bundleType?: number;

  /**
   * 下载进度
   */
  public downloadProgress?: number = 0;

  /**
   * 应用状态：下载中、暂停下载等
   */
  public appStatus?: number | undefined = 0;

  /**
   * 图标资源
   */
  public iconResource?: string | undefined;

  /**
   * 任务创建者的名字
   */
  public callerName?: string | undefined;

  /**
   * app应用路径
   */
  public codePath?: string | undefined;

  /**
   * 快捷方式id
   */
  public shortcutId?: string;

  /**
   * 应急模式标识
   */
  public isEmergency?: boolean;

  /**
   * 应用分身标识
   */
  public appIndex?: number = 0;

  /**
   * 应用来源
   */
  public installSource?: string;

  /**
   * 特殊应用标识
   */
  public intent?: string = '';

  /**
   * 是否支持应用多实例
   */
  public enableNewAppInstance?: boolean = false;

  public isAppLocked?: boolean = false;

  /**
   * 设置dock栏独立图标的Ability实例的窗口id
   */
  public persistentId?: string;

  /**
   * 应用多实例标识
   */
  public appInstanceKey?: string = '';

  /**
   * GridLayoutItemInfo: bigfolder id
   * Not in bigfolder: - 100
   * In a bigfolder: ID of the bigfolder.
   */
  public container?: number;

  public isActionItem?: boolean;

  // 可选参数尽量不要传递undefined，防止图标无法区分 注意：taskpool中无法使用此函数
  public static getKeyName(item: BaseIconInfo): string {
    if (CheckEmptyUtils.isEmpty(item)) {
      return '';
    }
    return `${item.bundleName}${item.abilityName}${item.moduleName}${item.appIndex ?? 0}${item.shortcutId ?? ''}`;
  }
}
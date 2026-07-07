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

import systemparameter from '@ohos.systemparameter';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'BaseDeliverUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class BaseDeliverUtil {
  private static containerFolderMap: Map<string, string> = new Map();

  /**
   * 获取备份文件夹列表
   */
  public static getContainerFolderMap(): Map<string, string> {
    return BaseDeliverUtil.containerFolderMap;
  }

  /**
   * 是否支持备份
   *
   * @returns 是否支持备份
   */
  public static isSupportDeliver(): boolean {
    let oldParam: string = systemparameter.getSync('const.app_eco.support_ohos', 'default');
    let newParam: string = systemparameter.getSync('persist.ohos_fusion_mgr.ctl.support_ohos', 'default');
    log.showInfo('get default const.app_eco.support_ohos: ' + oldParam +
      ' get default persist.ohos_fusion_mgr.ctl.support_ohos: ' + newParam);

    return oldParam === 'true' || newParam === 'true';
  }

  /**
   * 是否有备份应用
   *
   * @returns 是否有备份应用
   */
  public static isHaveDeliverApps(): boolean {
    if (!BaseDeliverUtil.isSupportDeliver()) {
      return false;
    }
    return !CheckEmptyUtils.isEmpty(BaseDeliverUtil.containerFolderMap) && BaseDeliverUtil.containerFolderMap.size > 0;
  }
}
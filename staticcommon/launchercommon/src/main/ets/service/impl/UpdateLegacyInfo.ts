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

import {
  LogDomain,
  Logger,
  CommonUtils
} from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import preferences from '@ohos.data.preferences';
import type ctx from '@ohos.app.ability.common';
import type { IExecutor } from '../IExecutor';
import { CloneCloudServiceResponse } from '../../constants/DesktopServiceConstant';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import { AppStatus, CommonConstants, LegacyInfo } from '../../TsIndex';
import { LaunchLayoutCacheManager } from '../../TsIndex';
import { RdbStoreManager } from '../../TsIndex';
import { launcherStatusUtil } from '@ohos/windowscene/src/main/ets/TsIndex';

const TAG: string = 'UpdateLegacyInfo';
const log: Logger = Logger.getLogHelper(LogDomain.BACKUP);

/**
 * 更新克隆签名
 *
 * @since 2024-08-03
 */
export class UpdateLegacyInfo implements IExecutor {
  private legacyInfoList: Array<LegacyInfo> = [];

  async execute(extra?: object): Promise<string> {
    let msg = extra as ExtraInfo;
    this.legacyInfoList = msg?.list as LegacyInfo[];
    let updateInfoList: GridLayoutItemInfo[] = new Array<GridLayoutItemInfo>();
    let pkgSignatureMap: Map<string, string> = new Map();
    for (let i = 0; i < this.legacyInfoList?.length; i++) {
      try {
        let curItem = this.legacyInfoList[i];
        log.showInfo(TAG, `backUp item = ${curItem.pkgName}`);
        pkgSignatureMap.set(curItem.pkgName, curItem.pkgSignature);
        let gridLayoutItemInfoList: GridLayoutItemInfo[] =
        LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(curItem.pkgName);
        log.showInfo(TAG, `gridLayoutItemInfoList = ${gridLayoutItemInfoList.length}`);
        if (gridLayoutItemInfoList.length > 0) {
          let gridLayoutItemInfo: GridLayoutItemInfo = gridLayoutItemInfoList[0];
          if (gridLayoutItemInfo.appStatus !== AppStatus.WAIT_FOR_HARMONY) {
            log.showInfo(TAG, `${gridLayoutItemInfo.bundleName} is not wait for harmony`);
            continue;
          }
          let extendInfo: Map<string, Object> = CommonUtils.jsonStrToMap(gridLayoutItemInfo.intent);
          let legacyInfo: LegacyInfo = extendInfo.get('legacyInfo') as LegacyInfo;
          legacyInfo.pkgSignature = curItem.pkgSignature;
          extendInfo.set('legacyInfo', legacyInfo);
          gridLayoutItemInfo.intent = CommonUtils.mapToJonStr(extendInfo);
          updateInfoList.push(gridLayoutItemInfo);
        }
      } catch (err) {
        log.showError(TAG, `update pkgSignature error ${err}`);
      }
    };
    this.updatePreferences(pkgSignatureMap);
    RdbStoreManager.getInstance().insertGridLayoutInfo(updateInfoList);
    return CloneCloudServiceResponse.SUCCESS;
  }

  private async updatePreferences(pkgSignatureMap: Map<string, string>): Promise<void> {
    try {
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      const preference: preferences.Preferences =
        preferences.getPreferencesSync(context, { name: CommonConstants.RESTORE_LAUNCHER_DATA });
      let pkgList: string[] = preference.getSync('RestorePkgData', null) as string[];
      let legacyInfoList: LegacyInfo[] = preference.getSync('RestoreLegacyInfoData', []) as LegacyInfo[];
      for (let i = 0; i < pkgList.length; i++) {
        let pkgName: string = pkgList[i];
        if (pkgSignatureMap.has(pkgName)) {
          log.showWarn(TAG, `update ${pkgName} pkgSignature`);
          legacyInfoList[i].pkgSignature = pkgSignatureMap.get(pkgName) ?? '';
        }
      }
      preference.putSync('RestoreLegacyInfoData', legacyInfoList);
      preference.flushSync();
    } catch (err) {
      log.showError(TAG, `update preference error ${err}`);
    }
  }
}

class ExtraInfo {
  public list: LegacyInfo[] = [];
}
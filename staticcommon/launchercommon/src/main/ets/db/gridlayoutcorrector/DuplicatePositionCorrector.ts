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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { HashMap } from '@kit.ArkTS';
import { AppItemInfo } from '../../bean/AppItemInfo';
import GridLayoutItemInfo from '../../bean/GridLayoutItemInfo';
import GridLayoutUtil from '../../utils/GridLayoutUtil';
import { AbstractGridLayoutCorrector } from './AbstractGridLayoutCorrector';
import { AppStatus, CommonConstants } from '../../constants/CommonConstants';

const TAG = 'DuplicatePositionCorrector';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export class DuplicatePositionCorrector extends AbstractGridLayoutCorrector {
  handleData(girdLayoutInfo: GridLayoutItemInfo[], isOuter?: boolean): void {
    if (GridLayoutUtil.ifDuplicatePosition(girdLayoutInfo)) {
      log.showError('GridLayoutItemInfo has duplicate position');
    }
  }
}

/**
 * 断电等异常场景下重启后把应用下载状态重置为暂停下载
 */
export class ChangeAppStatusToPauseCorrector extends AbstractGridLayoutCorrector {
  private mInstalledApps: AppItemInfo[] = [];

  constructor(installedApps: AppItemInfo[]) {
    super();
    this.mInstalledApps = installedApps;
  }

  handleData(girdLayoutInfos: GridLayoutItemInfo[], isOuter?: boolean): void {
    let bmsAppMap: HashMap<string, AppItemInfo> = new HashMap<string, AppItemInfo>();
    this.mInstalledApps?.filter(item => !CheckEmptyUtils.isEmpty(item))?.forEach(installAppItem => {
      bmsAppMap.set(this.getKeyName(installAppItem), installAppItem);
    });
    girdLayoutInfos?.forEach(girdItem => {
      if (CheckEmptyUtils.isEmpty(girdItem)) {
        log.showError(`check app status item is null.`);
        return;
      }
      if (girdItem.typeId === CommonConstants.TYPE_FOLDER) {
        girdItem.layoutInfo?.flat().forEach(folderItemInfo => {
          this.checkGirdLayoutInfo(bmsAppMap, folderItemInfo);
        });
      } else if (girdItem.typeId === CommonConstants.TYPE_APP) {
        this.checkGirdLayoutInfo(bmsAppMap, girdItem);
      }
    });
  }

  private checkGirdLayoutInfo(bmsAppMap: HashMap<String, AppItemInfo>, itemInfo: GridLayoutItemInfo): void {
    let keyName = this.getKeyName(itemInfo);
    if (bmsAppMap.hasKey(keyName)) {
      let installItem = bmsAppMap.get(keyName);
      if (itemInfo.appStatus !== AppStatus.INSTALLED || itemInfo.appIconId !== installItem.appIconId ||
        itemInfo.appLabelId !== installItem.appLabelId) {
        itemInfo.appStatus = AppStatus.INSTALLED;
        itemInfo.appIconId = installItem.appIconId;
        itemInfo.appLabelId = installItem.appLabelId;
        log.showInfo(`refresh install app status.`);
      }
    } else {
      this.updateAppStatus(itemInfo);
    }
  }

  private updateAppStatus(item: GridLayoutItemInfo): void {
    if (item.appStatus === AppStatus.WAITING || item.appStatus === AppStatus.DOWNLOADING ||
      item.appStatus === AppStatus.INSTALL_WAITING || item.appStatus === AppStatus.INSTALLING) {
      item.appStatus = AppStatus.PAUSING;
      log.showInfo(`change app download status to pause success.`);
    }
  }

  private getKeyName(item: AppItemInfo | GridLayoutItemInfo): string {
    if (CheckEmptyUtils.isEmpty(item)) {
      return '';
    }
    return `${item.bundleName}${item.abilityName}${item.moduleName}${item.appIndex ?? 0}${item.shortcutId ?? ''}`;
  }
}
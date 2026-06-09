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
import { CommonConstants, DockItemInfo } from '@ohos/launchercommon';
import { SmartDockStyleConfig } from '@ohos/smartdock/src/main/ets/default/common/SmartDockStyleConfig';

@Observed
export class ScbExtDockViewData {
  lightPositionX: number = 0;
  lightPositionY: number = 0;
  lightPositionZ: number = 150;
  intensityValue: number = 0;
  dockHeight: number = 0;
  /* Dock栏整体动效参数 */
  scaleRatio: number = 1;
  blurRatio: number = 0;
  residentListAreaWidth: number = 0;
  recentListAreaWidth: number = 0;

  appCenterItem: DockItemInfo | null = null;
  recentCenterItem: DockItemInfo | null = null;
  fileManagerItem: DockItemInfo | null = null;

  localResidentList: DockItemInfo[] = [];
  localRecentList: DockItemInfo[] = [];
  systemItemList: DockItemInfo[] = [];

  public updateLocalResidentList(globalResidentList: DockItemInfo[]): void {
    let localResidentList: DockItemInfo[] = [];

    let isPcMode = false;
    for (let i = globalResidentList.length - 1; i >= 0; i--) {
      if (globalResidentList[i]?.abilityName === CommonConstants.APPCENTER_ABILITY && !isPcMode) {
        this.appCenterItem = globalResidentList[i];
        continue;
      }
      if (globalResidentList[i]?.abilityName === CommonConstants.RECENT_ABILITY && !isPcMode) {
        this.recentCenterItem = globalResidentList[i];
        continue;
      }
      if (globalResidentList[i]?.bundleName === CommonConstants.FILE_MANAGER_BUNDLE && !isPcMode) {
        this.fileManagerItem = globalResidentList[i];
        continue;
      }
      if (globalResidentList[i]?.abilityName === CommonConstants.RECYCLE_BIN_ABILITY) {
        localResidentList.push(globalResidentList[i]);
        continue;
      }

      localResidentList.unshift(globalResidentList[i]);
    }

    if (this.recentCenterItem) {
      localResidentList.unshift(this.recentCenterItem); // 把任务中心常驻区的开头(可被翻页隐藏)
    }
    if (this.appCenterItem) {
      localResidentList.unshift(this.appCenterItem); // 把应用中心加到常驻区的开头(可被翻页隐藏)
    }
    if (this.fileManagerItem) {
      localResidentList.unshift(this.fileManagerItem); // 把文管加到常驻区的开头(可被翻页隐藏)
    }

    this.localResidentList = localResidentList;
  }

  public updateLocalRecentList(appList: DockItemInfo[]): void {
    let localRecentList: DockItemInfo[] = [];
    for (let i = 0; i < appList.length; i++) {
      localRecentList.push(appList[i]);
    }
    this.localRecentList = localRecentList;
  }

  public recalculateDockLayout(globalResidentList: DockItemInfo[], globalRecentList: DockItemInfo[],
    cfg: SmartDockStyleConfig): void {
    let residentAppNum: number = 0;
    let recentAppNum: number = 0;

    residentAppNum = globalResidentList.length;
    recentAppNum = globalRecentList.length;

    this.residentListAreaWidth = residentAppNum * (cfg.mListItemWidth + cfg.mListItemGap);
    this.recentListAreaWidth = (cfg.mListItemWidth + cfg.mListItemGap) * recentAppNum;
  }
}
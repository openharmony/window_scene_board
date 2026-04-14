/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
import { AppItemInfo } from '../bean/AppItemInfo';
import { LogDomain, LogHelper, CheckEmptyUtils, ObjUtil } from '@ohos/basicutils';
import { RecentBundleMissionInfo } from '../bean/RecentBundleMissionInfo';
import { StyleConstants } from '../constants/StyleConstants';

const TAG = 'RunningTask';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

@Component
export struct RunningTask {
  appInfo: AppItemInfo = new AppItemInfo();
  @StorageLink('missionInfoList') @Watch('onDockListChange') missionInfoList: Array<RecentBundleMissionInfo> = [];
  @State isRunningApp: boolean = false;
  @Link currColorMode : number;
  @Prop ratio: number = 1;
  private shadowStyle: ShadowOptions = {
    radius: StyleConstants.RUNNING_DEFAULT_SHADOW_RADIUS,
    color: StyleConstants.RUNNING_DEFAULT_SHADOW_COLOR
  };

  public aboutToAppear(): void {
    this.onDockListChange();
  }

  private checkAppInstanceKey(appInstanceKey?: string, toAppInstanceKey?: string): boolean {
    if (CheckEmptyUtils.checkStrIsEmpty(appInstanceKey) && CheckEmptyUtils.checkStrIsEmpty(toAppInstanceKey)) {
      return true;
    }
    if (!CheckEmptyUtils.checkStrIsEmpty(appInstanceKey) && CheckEmptyUtils.checkStrIsEmpty(toAppInstanceKey)) {
      return false;
    }
    if (CheckEmptyUtils.checkStrIsEmpty(appInstanceKey) && !CheckEmptyUtils.checkStrIsEmpty(toAppInstanceKey)) {
      return false;
    }
    return appInstanceKey === toAppInstanceKey;
  }

  private isSameDockItem(itemInfo: AppItemInfo, other?: RecentBundleMissionInfo): boolean {
    const itemPersistentId = itemInfo.persistentId || '';
    const otherPersistentId = other?.persistentId || '';
    return itemPersistentId === otherPersistentId &&
      itemInfo?.bundleName === other?.bundleName &&
      itemInfo?.appIndex === other?.appIndex &&
    this.checkAppInstanceKey(itemInfo?.appInstanceKey, other?.appInstanceKey);
  }

  private onDockListChange(): void {
    if (ObjUtil.isInvalid(this.appInfo)) {
      log.showDebug('appInfo is empty');
      return;
    }
    if (CheckEmptyUtils.isEmptyArr(this.missionInfoList)) {
      this.isRunningApp = false;
      return;
    }
    for (let i = 0; i < this.missionInfoList.length; i++) {
      if (this.isSameDockItem(this.appInfo, this.missionInfoList[i])) {
        this.isRunningApp = true;
        log.showInfo('isRunning: ' + this.appInfo.bundleName + ', missionInfoList length: ' + this.missionInfoList.length);
        return;
      }
    }
    this.isRunningApp = false;
  }

  build() {
    if (this.isRunningApp) {
      Column()
        .width(StyleConstants.DEFAULT_4 * this.ratio)
        .height(StyleConstants.DEFAULT_4 * this.ratio)
        .margin({ bottom: 2 * this.ratio})
        .opacity(0.8)
        .borderRadius(2 * this.ratio)
        .backgroundColor(this.currColorMode === 0 ? Color.White : Color.Black)
        .id(`${TAG}_Column_${this.appInfo.bundleName}`)
    }
  }
}
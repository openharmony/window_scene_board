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

import { GestureDockItemInfo } from '../../model/GestureDockItemInfo';
import { ArrayList } from '@kit.ArkTS';
import BundleManager from '@ohos.bundle.bundleManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { CommonConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockBarViewDataMgr } from '../viewdata/GestureDockBarViewDataMgr';
import {
  DockBarScrollerParam,
} from '../viewdata/GestureDockBarParam';
import { GestureDockUtil } from '../../../common/util/GestureDockUtil';
import { GestureDockPreferenceMgr } from '../../../common/preference/GestureDockPreferenceMgr';

const TAG = 'GestureDockAppDataHandler';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * GestureDockAppDataHandler
 */
export default class GestureDockAppDataHandler {
  private viewDataMgr: GestureDockBarViewDataMgr;
  private dockBarScrollerParam: DockBarScrollerParam;

  /**
   * 构造器
   *
   * @param GestureDockBarViewDataMgr
   */
  constructor(viewDataMgr: GestureDockBarViewDataMgr) {
    this.viewDataMgr = viewDataMgr;
    this.dockBarScrollerParam = this.viewDataMgr.dockBarScrollerParam;
  }

  /**
   * 过滤最近任务区数据
   */
  public removeRecentItemInfosInResident(): void {
    let itemInfos = new ArrayList<GestureDockItemInfo>();
    this.dockBarScrollerParam.recentApps?.forEach((value: GestureDockItemInfo) => {
      log.showInfo(`removeRecentItemInfosInResident itemInfo.appindex: ${value.appIndex}`);
      if (!this.isInResidentApps(value)) {
        itemInfos.add(value);
      }
    });
    this.dockBarScrollerParam.recentApps = itemInfos.convertToArray();
    this.dockBarScrollerParam.isRecentAppShow = this.dockBarScrollerParam.recentApps.length !== 0;
  }

  /**
   * 应用是否在Dock栏常驻区里
   *
   * @param 最近任务区item
   */
  private isInResidentApps(recentItemInfo: GestureDockItemInfo): boolean {
    let isInResidentApps: boolean = false;
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
    residentApps.forEach((value: GestureDockItemInfo) => {
      if (GestureDockUtil.areTwoAppItemsSame(recentItemInfo, value)) {
        isInResidentApps = true;
      }
    })
    return isInResidentApps;
  }

  /**
   * 最近任务区过滤支持侧边Dock展示的应用
   */
  public filterRecentItemInfosBySupportDockApps(): void {
    let originRecentAppsLength = this.dockBarScrollerParam.recentApps?.length;
    for (let i = this.dockBarScrollerParam.recentApps?.length - 1; i >= 0; i--) {
      let item = this.dockBarScrollerParam.recentApps[i];
      let queryKey = item.bundleName + item.moduleName + item.abilityName;
      let supportModes = SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo(queryKey);
      // 过滤掉不支持悬浮窗的app
      if (!(supportModes?.indexOf(BundleManager.SupportWindowMode.FLOATING) > -1) &&
        !SCBSceneSessionManager.getInstance().isInMultiWindowForceSupportList(item.bundleName) ||
        item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        this.dockBarScrollerParam.recentApps.splice(i, 1);
        continue;
      }
    }
    // update preference data
    if (originRecentAppsLength !== this.dockBarScrollerParam.recentApps.length) {
      GestureDockPreferenceMgr.getInstance().updateRecentPreferenceGestureDock(this.dockBarScrollerParam.recentApps);
    }
  }

  /**
   * 常规任务区过滤支持悬浮窗的应用
   */
  public filterResidentItemInfosBySupportDockApps(): void {
    let residentApps = AppStorage.get('gestureDockList') as GestureDockItemInfo[];
    let originDockAppsLength = residentApps?.length;
    for (let i = residentApps?.length - 1; i >= 0; i--) {
      let item = residentApps[i];
      let queryKey = item.bundleName + item.moduleName + item.abilityName;
      let supportModes = SCBSceneSessionManager.getInstance().getAbilityWindowSupportInfo(queryKey);
      // 过滤掉不支持悬浮窗的app
      if (!(supportModes?.indexOf(BundleManager.SupportWindowMode.FLOATING) > -1) &&
        !SCBSceneSessionManager.getInstance().isInMultiWindowForceSupportList(item.bundleName) ||
        item.typeId === CommonConstants.TYPE_SHORTCUT_ICON) {
        residentApps.splice(i, 1);
      }
    }
    // update preference data
    if (originDockAppsLength !== residentApps.length) {
      GestureDockPreferenceMgr.getInstance().updateDockAppsPreference(residentApps);
      AppStorage.setOrCreate('gestureDockList', residentApps);
    }
  }
}
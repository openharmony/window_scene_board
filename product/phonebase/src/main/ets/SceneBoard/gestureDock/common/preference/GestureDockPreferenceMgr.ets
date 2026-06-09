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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { AppItemInfo, AppModel,
  CommonConstants,
  DockItemInfo,
  EventConstants,
  GestureDockModeConfig,
  launcherAbilityManager,
  ReceiveEventInfo,
  ResidentLayoutCacheMgr} from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockItemInfo } from '../../dockbar/model/GestureDockItemInfo';
import { GestureDockConstants } from '../GestureDockConstants';
import { GestureDockUtil } from '../util/GestureDockUtil';
import dataPreferences from '@ohos.data.preferences';
import { BusinessError } from '@kit.BasicServicesKit';
import { GestureDockViewModel } from '../../dock/viewmodel/GestureDockViewModel';
import { SceneInfoAdapterUtil } from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  SCBSceneSessionManager,
  SceneStateChangeCallback } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import { GestureDockDataController } from '../../dockallapps/viewmodel/viewdata/GestureDockDataController';

const TAG = 'GestureDockPreferenceUtil';
const log = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

const GESTURE_DOCK_PREFERENCE = 'GestureDockPreference';

/**
 * GestureDockPreferenceMgr
 */
export class GestureDockPreferenceMgr {
  private static mInstance: GestureDockPreferenceMgr | null = null;
  private preference?: dataPreferences.Preferences;
  public appList: AppItemInfo[] = [];
  protected mAppModel: AppModel = AppModel.getInstance();

  public static getInstance(): GestureDockPreferenceMgr {
    if (!GestureDockPreferenceMgr.mInstance) {
      GestureDockPreferenceMgr.mInstance = new GestureDockPreferenceMgr();
    }
    return GestureDockPreferenceMgr.mInstance;
  }

  private constructor() {
    try {
      let context = GlobalContext.getContext();
      if (context) {
        this.preference = dataPreferences.getPreferencesSync(context, {
          name: GESTURE_DOCK_PREFERENCE
        });
      }
    } catch (err) {
      log.showError(`getPreferencesSync error, BusinessError code is ${(err as BusinessError).code}`);
    }
    this.registerAppUpdateListener();
  }

  /**
   * 同步文件中的数据到内存中
   */
  public syncPreferencesCache(): void {
    let context = GlobalContext.getContext();
    if (context) {
      dataPreferences.removePreferencesFromCacheSync(context, {
        name: GESTURE_DOCK_PREFERENCE
      });
      try {
        this.preference = dataPreferences.getPreferencesSync(context, {
          name: GESTURE_DOCK_PREFERENCE
        });
      } catch (err) {
        log.showError(`getPreferencesSync error: ${err.code}, ${err.message}`);
      }
    }
  }

  /**
   * 注册应用信息更新监听器
   */
  public registerAppUpdateListener(): void {
    // 应用卸载/安装监听
    localEventManager.registerEventListener(this.appEventListener, [
      EventConstants.EVENT_REQUEST_RECOMMEND_FORM_ADD, EventConstants.EVENT_REQUEST_RECOMMEND_FORM_UPDATE,
      EventConstants.EVENT_REQUEST_RECOMMEND_FORM_DELETE
    ]);
    log.showInfo('local listener on create');
  }

  /**
   * 反注册应用信息更新监听器
   */
  public unRegisterAppUpdateListener(): void {
    localEventManager.unregisterEventListener(this.appEventListener);
    log.showInfo('local listener on destroy');
  }

  private readonly appEventListener: ReceiveEventInfo = {
    onReceiveEvent: (event: string, params: string): void => {
      log.showInfo(`getDockApps appEventListener: ${event}, params: ${params}`);
      if (event === EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_DELETE) {
        this.appList = this.mAppModel.getAppList();
        this.getDockApps()
          .then((dockAppList) => this.updateDockAppsPreference(dockAppList));
      } else if ([EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_ADD,
        EventConstants.EVENT_REQUEST_PAGEDESK_ITEM_UPDATE].includes(event)) {
        this.appList = this.mAppModel.getAppList();
      }
    }
  };

  /**
   * 获取侧边栏最近任务列表
   *
   * @returns 侧边栏最近任务列表
   */
  public async getRecentDockList(): Promise<GestureDockItemInfo[]> {
    log.showInfo(`getRecentDockList`);
    let originRecentApps = this.preference?.getSync(GestureDockConstants.GESTURE_DOCK_RECENT_NAME, '') as AppItemInfo[];
    if (GestureDockUtil.isEmptyArr(originRecentApps)) {
      log.showInfo('get preference length is 0');
      return [];
    }
    let recentApps = originRecentApps;
    this.appList = GestureDockDataController.getInstance().getAllAppsList();
    recentApps = recentApps.filter(item1 => {
      return this.appList.some(item2 => {
        let isSame = GestureDockUtil.areTwoAppItemsSame(item1, item2);
        if (isSame) {
          item1.intent = item2.intent;
        }
        return isSame;
      })
    });
    log.showInfo(`recentApp length:${recentApps.length}`);
    let dockItemInfoList: GestureDockItemInfo[] = [];
    for (let index = 0; index < recentApps.length; index++) {
      let recentItemInfo = recentApps[index] as GestureDockItemInfo;
      recentItemInfo.editable = false;
      recentItemInfo.visible = true;
      let dockItemInfo: DockItemInfo = new DockItemInfo();
      if (recentItemInfo.isActionItem) {
        dockItemInfo = await GestureDockDataController.getInstance().createDockAppInfo(recentApps[index], index);
      } else {
        dockItemInfo =
          await ResidentLayoutCacheMgr.getInstance().createDockAppInfo(recentItemInfo, index) as DockItemInfo;
      }
      let gestureDockItemInfo = dockItemInfo as GestureDockItemInfo;
      if (CheckEmptyUtils.isEmpty(gestureDockItemInfo) || launcherAbilityManager.isIgnoreApp(recentItemInfo)) {
        log.showWarn(`getRecentDockList no exist: ${recentItemInfo?.bundleName},appindex ${recentItemInfo?.appIndex}`);
        continue;
      }
      log.showInfo(`getRecentDockList bundleName: ${gestureDockItemInfo?.bundleName},appindex ${gestureDockItemInfo?.appIndex}`);
      dockItemInfoList.push(gestureDockItemInfo);
    }
    log.showInfo(`dockDataList size is ${dockItemInfoList.length}`);
    // update persistent data
    if (originRecentApps.length !== recentApps.length) {
      this.updateRecentPreferenceGestureDock(dockItemInfoList);
    }
    return dockItemInfoList;
  }

  /**
   * 获取常驻区list
   *
   * @return dockAppList 侧边dock中常驻区List
   */
  public async getDockApps(): Promise<GestureDockItemInfo[]> {
    let appInfoList: AppItemInfo[] = [];
    let isNeedUpdatePreference = false;
    try {
      if (this.preference?.hasSync(GestureDockConstants.GESTURE_DOCK_APPS_NAME)) {
        let dockApps = this.preference?.getSync(GestureDockConstants.GESTURE_DOCK_APPS_NAME, []) as AppItemInfo[];
        appInfoList = dockApps.filter(item1 => {
          return this.appList.some(item2 => {
            let isSame = !CheckEmptyUtils.isEmpty(item1.bundleName) &&
            GestureDockUtil.areTwoAppItemsSame(item1, item2);
            if (isSame) {
              item1.intent = item2.intent;
            }
            return isSame;
          })
        });
        log.showInfo(`getDockApps from preference; appList:${appInfoList.length}; config:${dockApps.length}`);
      } else {
        let outerCfgFiles = await GestureDockModeConfig.getInstance().getResidentAppLayoutConfig();
        appInfoList =
          outerCfgFiles?.layoutInfo.filter(item1 => this.appList.some(item2 =>
          GestureDockUtil.areTwoAppItemsSame(item1, item2))) ?? [];
        log.showInfo(`getDockApps from ResidentAppLayoutConfig; appList:${appInfoList.length}; config:${outerCfgFiles?.layoutInfo.length}`);
        isNeedUpdatePreference = true;
      }
    } catch (error) {
      log.showError(`getDockApps asynchronous operation failed, Code is ${error.code}, message is ${error.message}`);
    }
    let dockAppList: GestureDockItemInfo[] = [];
    appInfoList.forEach((item) => {
      log.showInfo(`getDockApps item bundleName:${item.bundleName}; appIndex:${item.appIndex}`);
      if (item.bundleName.length > 0) {
        dockAppList.push(this.buildGestureDockItemInfo(item));
      }
    });
    log.showInfo(`getDockApps length:${dockAppList.length};isNeedUpdatePreference:${isNeedUpdatePreference}`);
    if (isNeedUpdatePreference) {
      // 更新Preference数据
      this.updateDockAppsPreference(dockAppList);
    }
    return dockAppList;
  }

  private sceneStateChange: SceneStateChangeCallback = (sceneInfo, isForeground) => {
    log.showInfo(`onSceneStateChange,isForegroud:${isForeground},bundleName:${sceneInfo.bundleName},appIndex:${sceneInfo.appIndex} sceneInfo.abilityName:${sceneInfo.abilityName}`);
    if (isForeground) {
      this.addGestureDockRecentPreference(sceneInfo.bundleName, sceneInfo.appIndex, sceneInfo.abilityName);
    }
  }

  /**
   * 反注册监听
   */
  public unregisterSceneStateChangeCallback(): void {
    SCBSceneSessionManager.getInstance()
      .unregisterSceneStateChangeCallback(SCBSceneSessionManager.getInstance().mainScreenId, this.sceneStateChange);
    log.showInfo('GestureDockPreference unregisterSceneStateChangeCallback');
  }

  /**
   * 注册监听
   */
  public registerSceneStateChangeCallback(): void {
    SCBSceneSessionManager.getInstance()
      .registerSceneStateChangeCallback(SCBSceneSessionManager.getInstance().mainScreenId, this.sceneStateChange);
    log.showInfo(`GestureDockPreference registerSceneStateChangeCallback:${SCBSceneSessionManager.getInstance().mainScreenId}`);
  }

  /**
   * 添加应用至最近任务，更新preference
   *
   * @param bundleName 包名
   * @param appIndex appIndex
   * @param abilityName abilityName
   *
   */
  public addGestureDockRecentPreference(bundleName?: string, appIndex?: number, abilityName?: string): void {
    log.showInfo('addGestureDockRecentPreference');
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.showWarn('addGestureDockRecentPreference, bundleName is null');
      return;
    }
    GestureDockViewModel.getInstance().getViewEvent()?.resetPositionWithoutAnimation();
    let appList = AppModel.getInstance().getAppList();
    let appItem = appList.find((item) => item.appIndex === appIndex && item.abilityName === abilityName);
    if (appItem === undefined) {
      appItem = GestureDockDataController.getInstance().getAppItemInfo(bundleName, appIndex, abilityName);
    }
    if (appItem === undefined) {
      log.showInfo('app not found in appList');
      return;
    }
    log.showInfo(`addGestureDockRecentPreference, bundleName:${bundleName} appIndex:${appIndex} abilityName:${appItem.abilityName}.`);
    let recentApps =
      this.preference?.getSync(GestureDockConstants.GESTURE_DOCK_RECENT_NAME, '') as GestureDockItemInfo[];
    if (GestureDockUtil.isEmptyArr(recentApps)) {
      log.showInfo('get preference length is 0');
      let recentTaskInfo = GestureDockUtil.buildDockItemInfo(appItem) as GestureDockItemInfo;
      recentApps = [];
      recentApps.push(recentTaskInfo);
    } else {
      let index = recentApps.findIndex((item) => item.appIndex === appIndex && item.abilityName === abilityName);
      log.showInfo(`Index is ${index}`);
      switch (index) {
        case -1:
          let recentTaskInfo = GestureDockUtil.buildDockItemInfo(appItem) as GestureDockItemInfo;
          recentApps.unshift(recentTaskInfo);
          break;
        case 0:
          // 如果当前应用已经在第一位了，则不需要刷新数据库和列表
          log.showInfo('app is already first in recent dock');
          return;
        default:
        // 如已在最近任务区存在，则把顺序调整为第一位
          recentApps.unshift(recentApps[index]);
          recentApps.splice(index + 1, 1);
          break;
      }
      if (recentApps.length > GestureDockConstants.GESTURE_DOCK_MAX_COUNT) {
        // 删除超出的元素
        recentApps.splice(GestureDockConstants.GESTURE_DOCK_MAX_COUNT);
      }
    }
    log.showInfo(`recent size is ${recentApps.length}`);
    this.updateRecentPreferenceGestureDock(recentApps);
  }

  /**
   * 更新最近任务区的Preference
   *
   * @param
   */
  public updateRecentPreferenceGestureDock(recentDockList: GestureDockItemInfo[]): void {
    log.showInfo(`recentList length is ${recentDockList.length}`);
    let recentPreferenceList: AppItemInfo[] = [];
    for (let index = 0; index < recentDockList.length; index++) {
      const dockItem = recentDockList[index];
      if (CheckEmptyUtils.isEmpty(dockItem.bundleName)) {
        log.showError('bundleName empty');
        continue;
      }
      let preItem = new AppItemInfo();
      preItem.bundleName = dockItem.bundleName
      preItem.abilityName = dockItem.abilityName
      preItem.moduleName = dockItem.moduleName
      preItem.appIndex = dockItem.appIndex
      preItem.typeId = dockItem.typeId
      preItem.isActionItem = dockItem.isActionItem;
      preItem.appLabelId = dockItem.appLabelId
      preItem.intent = dockItem.intent
      recentPreferenceList.push(preItem);
    }
    this.syncPreferencesCache();
    this.preference?.putSync(GestureDockConstants.GESTURE_DOCK_RECENT_NAME, recentPreferenceList);
    this.preference?.flush();
  }

  /**
   * 构造GestureDockItemInfo
   *
   * @param dockAppList 侧边dock中常驻区List
   */
  public updateDockAppsPreference(dockAppList: GestureDockItemInfo[]): void {
    let preferenceList: AppItemInfo[] = [];
    for (let index = 0; index < dockAppList.length; index++) {
      const dockItem = dockAppList[index];
      if (CheckEmptyUtils.isEmpty(dockItem.bundleName)) {
        log.showError('bundleName empty');
        continue;
      }
      let preItem = new AppItemInfo();
      preItem.bundleName = dockItem.bundleName;
      preItem.abilityName = dockItem.abilityName;
      preItem.moduleName = dockItem.moduleName;
      preItem.appIndex = dockItem.appIndex;
      preItem.typeId = dockItem.typeId;
      preItem.isActionItem = dockItem.isActionItem;
      preItem.intent = dockItem.intent
      preferenceList.push(preItem);
    }
    log.showInfo(`updateDockAppsPreference length:${preferenceList.length}`);
    if (GestureDockUtil.isEmptyArr(preferenceList)) {
      const preItem = new AppItemInfo();
      preferenceList.push(preItem);
    }
    this.syncPreferencesCache();
    this.preference?.putSync(GestureDockConstants.GESTURE_DOCK_APPS_NAME, preferenceList);
    this.preference?.flush();
  }

  /**
   * 构造GestureDockItemInfo
   *
   * @param appInfo 侧边dock中appInfo
   * @returns 三级缓存图标
   */
  private buildGestureDockItemInfo(appInfo: AppItemInfo): GestureDockItemInfo {
    if (!appInfo) {
      log.showInfo(`appInfo null`);
      return new GestureDockItemInfo();
    }
    let isFolder: boolean = appInfo.typeId === CommonConstants.TYPE_FOLDER;
    const dockItemInfo = new GestureDockItemInfo();
    dockItemInfo.itemType = isFolder ? CommonConstants.TYPE_FOLDER : CommonConstants.TYPE_APP;
    dockItemInfo.typeId = isFolder ? CommonConstants.TYPE_FOLDER : CommonConstants.TYPE_APP;
    dockItemInfo.editable = true;
    dockItemInfo.appName = appInfo.appName;
    dockItemInfo.bundleName = appInfo.bundleName;
    dockItemInfo.moduleName = appInfo.moduleName;
    dockItemInfo.abilityName = appInfo.abilityName;
    dockItemInfo.keyName = appInfo.keyName;
    dockItemInfo.appIconId = appInfo.appIconId;
    dockItemInfo.appLabelId = appInfo.appLabelId;
    dockItemInfo.applicationLabelId = appInfo.applicationLabelId;
    dockItemInfo.applicationName = appInfo.applicationName;
    dockItemInfo.areaType = CommonConstants.TYPE_AREA_DOCK;
    dockItemInfo.isUninstallAble = appInfo.isUninstallAble;
    dockItemInfo.codePath = appInfo?.codePath;
    dockItemInfo.visible = true;
    dockItemInfo.row = 0;
    dockItemInfo.column = appInfo.column;
    dockItemInfo.area = [1, 1];
    dockItemInfo.appIndex = appInfo.appIndex;
    dockItemInfo.badgeNumber = appInfo.badgeNumber;
    dockItemInfo.layoutInfo = isFolder ? (appInfo as GestureDockItemInfo).layoutInfo : undefined;
    dockItemInfo.isActionItem = appInfo.isActionItem;
    dockItemInfo.intent = appInfo.intent;
    return dockItemInfo;
  }
}
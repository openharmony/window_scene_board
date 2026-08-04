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
import { SCBConstants } from '@ohos/commonconstants';
import { DeviceHelper, sEventManager } from '@ohos/frameworkwrapper';
import {
  ResUtils,
  SCBSceneContainerSession,
  SCBSceneSession,
  SCBSceneSessionManager,
  OOBE_CHANGE_EVENT,
  OTA_OOBE_CHANGE_EVENT
} from '@ohos/windowscene';
import {
  AppItemInfo,
  CommonConstants,
  DockItemInfo,
  RecentBundleMissionInfo,
  ShortcutInfo,
  ShortcutViewModel,
  EnterpriseSpaceUtil,
  ResidentLayoutCacheMgr,
  GetHideAppsFromConfig,
  DeleteDockItem
} from '@ohos/launchercommon/src/main/ets/TsIndex';
import SmartDockModel from '@ohos/smartdock/src/main/ets/default/model/SmartDockModel';
import SmartDockConstants from '@ohos/smartdock/src/main/ets/default/common/constants/SmartDockConstants';
import { PcDockIndepentIconMgr } from '../manager/PcDockIndependentIconMgr';
import { promptAction } from '@kit.ArkUI';
import { PCDockUtils } from '../utils/PCDockUtils';
import { PcSmartDockEventMgr } from '../manager/PcSmartDockEventMgr';
import PcModeContinuableModel from '@ohos/smartdock/src/main/ets/default/pcmode/model/PcModeContinuableModel';

const TAG = 'PcSmartDockModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

const GUIDE_BUNDLE_NAME = 'com.ohos.startupguide';
const HISEARCH_PC_BUNDLE_NAME = 'com.ohos.hisearch';
const HMMODEL_PC_BUNDLE_NAME = 'com.ohos.hmmodelfoundation';

/**
 * 回收站窗口状态信息
 */
export type RecycleBinRecord = Record<'screenId' | 'persistentId', number>;

/**
 * PC形态下dock栏数据处理
 */
export class PcSmartDockModel extends SmartDockModel {
  private static instance: PcSmartDockModel | null = null;
  private allShortcutInfoList: ShortcutInfo[] = [];
  private sessionMap: Map<number, string[]> = new Map();
  private hideInRecentListSessions: Set<SCBSceneContainerSession> = new Set();
  private recycleBinStatus: RecycleBinRecord = {
    'screenId': -1,
    'persistentId': -1,
  };

  private constructor() {
    super();

    const isHwItOS = EnterpriseSpaceUtil.hwItOsCheck();
    log.showInfo(`hwItOsCheck result:${isHwItOS}`);
    if (isHwItOS) {
      this.oobeEventListen();
      this.vpnEventListen();
    }
  }

  static getInstance(): PcSmartDockModel {
    if (!PcSmartDockModel.instance) {
      PcSmartDockModel.instance = new PcSmartDockModel();
      if (DeviceHelper.isPC()) {
        globalThis.SmartDockModel = PcSmartDockModel.instance;
      }
      log.showInfo('getInstance!');
    }
    return PcSmartDockModel.instance;
  }

  public addItemToSessionMap(persistentId: number, bundleName: string, appInstanceKey: string): void {
    this.sessionMap.set(persistentId, [bundleName, appInstanceKey]);
  }

  public clearSessionMap(): void {
    this.sessionMap.clear();
  }

  /**
   * 响应dock栏数据变化
   *
   * @param containerSessionList
   * @param tag
   * @returns
   */
  public async initRecentDataList(containerSessionList: SCBSceneContainerSession[], tag?: string): Promise<void> {
    log.showInfo(`initRecentDataList invoked from ${tag}, containerSessionList length: ${containerSessionList?.length}`);
    let recentMissionsList: RecentBundleMissionInfo[] = [];
    const missionInfos: RecentBundleMissionInfo[] = [];
    const currCmdId: number = ++this.processCmdId;
    this.allShortcutInfoList = await ShortcutViewModel.getInstance().getAllDesktopShortcutFromBMS();
    log.showInfo(`initRecentDataList getAllDesktopShortcutFromBMS - length: ${this.allShortcutInfoList.length}`);
    if (this.processCmdId !== currCmdId) {
      log.showWarn(`renturn : currCmdId: ${currCmdId}, this.processCmdId: ${this.processCmdId}`);
      return;
    }
    const appList = this.mAppModel.getAppList();
    this.appList = appList;
    this.fillRecentMissionInfoList(appList, containerSessionList, recentMissionsList);
    log.showInfo(`fillRecentMissionInfoList recentMissionsList.length=${recentMissionsList.length}`);

    recentMissionsList.forEach(item => {
      let missionInfo = this.buildMissionInfo(item);
      missionInfos.push(missionInfo);
    });
    if (!SCBSceneSessionManager.getInstance().isPcMode()) {
      let openAppNameList = this.initOpenAppNameList(appList, recentMissionsList);
      AppStorage.setOrCreate('openAppNameList', openAppNameList);
    }
    log.showInfo(`before removeInResident recentMissionsList.length=${recentMissionsList.length}`);
    // 移除常驻区的app
    let mResidentList = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    recentMissionsList = await this.excludeInResidentFrom(mResidentList, recentMissionsList);

    recentMissionsList = this.excludeInCollaborationList(recentMissionsList);

    log.showInfo(`recentMissionsList.length=${recentMissionsList.length}`);

    let reOrderRecentList = this.reOrderRecentList(recentMissionsList);
    PcModeContinuableModel.getInstance().updateDisappearContinuableItem(reOrderRecentList);
    AppStorage.setOrCreate('recentList', reOrderRecentList);
    AppStorage.setOrCreate('missionInfoList', missionInfos);
    this.mMissionInfoList = missionInfos;
    log.showInfo(`init recentList.length: ${recentMissionsList.length} missionInfoList.length: ${missionInfos.length}`);
  }

  reOrderRecentList(recentMissionsList: Array<RecentBundleMissionInfo>): Array<RecentBundleMissionInfo> {
    let recentList = AppStorage.get('recentList') as Array<RecentBundleMissionInfo>;
    let openAppNameList = AppStorage.get('openAppNameList') as Array<string>;
    let reOrderRecentList: RecentBundleMissionInfo[] = [];

    if (CheckEmptyUtils.isEmptyArr(recentList)) {
      if (!CheckEmptyUtils.isEmptyArr(recentMissionsList)) {
        return recentMissionsList;
      }
    }
    recentList.forEach(item => {
      let newItem: RecentBundleMissionInfo | undefined = recentMissionsList.find(newItem =>
      SmartDockModel.getInstance().isSameDockItem(newItem, item));
      if (openAppNameList.includes(item.bundleName) && CheckEmptyUtils.isEmpty(newItem) &&
      CheckEmptyUtils.isEmpty(item?.persistentId)) {
        item.missionInfoList = [];
        reOrderRecentList.push(item);
      } else if (!CheckEmptyUtils.isEmpty(newItem)) {
        reOrderRecentList.push(newItem!);
      }
    });
    recentMissionsList.forEach(item => {
      if (!reOrderRecentList.includes(item)) {
        reOrderRecentList.push(item);
      }
    });
    return reOrderRecentList;
  }

  public async excludeInResidentFrom(mResidentList: DockItemInfo[],
    recentMissionsList: RecentBundleMissionInfo[]): Promise<RecentBundleMissionInfo[]> {
    const inResidentFilter = await Promise.all(recentMissionsList.map(async (recent) => {
      return await this.isInResidentList(mResidentList, recent);
    }));
    recentMissionsList = recentMissionsList.filter((recent, i) => {
      const remainInRecent = !inResidentFilter[i];
      log.showInfo(`recentAbility=${recent.abilityName}, remainInRecent:${remainInRecent}`);
      return remainInRecent;
    });
    return recentMissionsList;
  }

  public buildMissionInfo(item: RecentBundleMissionInfo): RecentBundleMissionInfo {
    let missionInfo = new RecentBundleMissionInfo();
    missionInfo.appName = item.appName;
    missionInfo.bundleName = item.bundleName;
    missionInfo.moduleName = item.moduleName;
    missionInfo.abilityName = item.abilityName;
    missionInfo.appIndex = item.appIndex;
    missionInfo.shortcutId = item.shortcutId;
    missionInfo.missionInfoList = item.missionInfoList;
    if (item.persistentId) {
      missionInfo.persistentId = item.persistentId;
    }
    missionInfo.appInstanceKey = item?.appInstanceKey;
    missionInfo.intent = item?.intent;
    return missionInfo;
  }

  private async isInResidentList(mResidentList: DockItemInfo[], recent: RecentBundleMissionInfo): Promise<boolean> {
    log.showInfo(`isInResidentList, recent.bundle=${recent.bundleName}, recent.ability=${recent.abilityName}, recent.shortcutId=${recent.shortcutId}`);
    if (recent.persistentId) {
      return false;
    }
    const inResidentFilter = await Promise.all(mResidentList.map(async (dockItem) => {
      if (dockItem.bundleName === recent.bundleName &&
      CheckEmptyUtils.checkStrIsEmpty(dockItem.appInstanceKey) &&
        !CheckEmptyUtils.checkStrIsEmpty(recent.appInstanceKey)) {
        dockItem.appInstanceKey = recent.appInstanceKey;
      }
      log.showInfo(`isInResidentList : ${dockItem?.bundleName}, ${dockItem?.appIndex}, ${dockItem?.appInstanceKey}`);
      // 1. dock栏持久区，不存在与最近任务同一个bundle下的item
      if (!SmartDockModel.getInstance().checkSameDockItem(dockItem, recent)) {
        return false;
      }
      // 2. dock栏持久区，存在与最近任务同一个bundle下的item
      // dock持久区存在快捷方式图标，且启动的新窗口未快捷方式启动类型，完全相同时，认定在持久区存在
      if (!!dockItem.shortcutId || !!recent.shortcutId) {
        const shortcutInfo = await ShortcutViewModel.getInstance().getShortcutInfo(dockItem);
        const wantBundle = shortcutInfo?.wants?.[0].targetBundle;
        const wantModule = shortcutInfo?.wants?.[0].targetModule;
        log.showInfo(`isInResidentList, want:${wantBundle}, ${wantModule}, ${shortcutInfo?.id}`);
        return wantBundle === recent.bundleName && shortcutInfo?.id === recent.shortcutId;
      }
      return true;
    }));
    return !!mResidentList.find((_dockItem, i) => inResidentFilter[i]);
  }

  /**
   * 构造dock栏运行态任务信息
   *
   * @param appList
   * @param containerSessionList
   * @param recentMissionsList
   */
  fillRecentMissionInfoList(appList: AppItemInfo[], containerSessionList: SCBSceneContainerSession[],
    recentMissionsList: Array<RecentBundleMissionInfo>): void {
    this.refreshSCBSceneContainerSession();
    let noAppDesktopIconList: string[] = [];
    for (let i = 0; i < containerSessionList.length; ++i) {
      const allSession = this.getAllSession(containerSessionList[i]);
      if (CheckEmptyUtils.isEmptyArr(allSession)) {
        continue;
      }
      if (this.hideInRecentListSessions.has(containerSessionList[i])) {
        log.showInfo('Session in hideInRecentListSessions, Skip');
        continue;
      }

      for (let currentSession of allSession) {
        let isNotDealApp: boolean = (currentSession.sceneInfo.bundleName === GUIDE_BUNDLE_NAME ||
          currentSession.sceneInfo.bundleName === HMMODEL_PC_BUNDLE_NAME ||
          this.isVassiatant(currentSession.sceneInfo.bundleName, currentSession.sceneInfo?.abilityName) ||
          currentSession.sceneInfo.bundleName === HISEARCH_PC_BUNDLE_NAME) ||
          GetHideAppsFromConfig.getInstance().isHideApp(currentSession.sceneInfo.bundleName);
        if (isNotDealApp) {
          continue;
        }

        log.showInfo(`session sceneInfo: bundleName=${currentSession.sceneInfo.bundleName},abilityName=${currentSession.sceneInfo.abilityName},appIndex:${currentSession.sceneInfo.appIndex}`);
        let recentTaskInfo = this.getAbilityItemInfo(currentSession);
        const isIndependentIconAbility: boolean = PcDockIndepentIconMgr.getInstance().isIndependentIconAbility(
          currentSession.sceneInfo?.bundleName, String(currentSession.sceneInfo?.persistentId));
        let notMerge: boolean = (isIndependentIconAbility);
        if (notMerge && recentTaskInfo) {
          log.showInfo(`dont merge shortcut scene to athers, currentSceneInfo: ${recentTaskInfo.bundleName},${recentTaskInfo.moduleName},${recentTaskInfo.abilityName},${recentTaskInfo.shortcutId},${currentSession.sceneInfo.persistentId}`);
          recentTaskInfo.missionInfoList = [];
          recentTaskInfo.missionInfoList.push(containerSessionList[i]);
          this.fillRecentTaskInfoWithPersistentId(recentTaskInfo, currentSession, isIndependentIconAbility);
          recentMissionsList.push(recentTaskInfo);
          continue;
        }

        let localMissionInfo =
          recentMissionsList.find((item) => !item.shortcutId &&
          CheckEmptyUtils.isEmpty(item?.persistentId) &&
          PcSmartDockEventMgr.getInstance().checkSameDockItemBySceneInfo(currentSession.sceneInfo, item));
        if (localMissionInfo) {
          log.showInfo(`localMissionInfo: ability:${localMissionInfo.shortcutId}`);
          localMissionInfo.missionInfoList?.push(containerSessionList[i]);
        } else {
          let appItem: AppItemInfo | undefined =
            appList.find(item => (PCDockUtils.isSameBundle(item.bundleName,
              currentSession.sceneInfo.bundleName)) &&
              item.appIndex === (PCDockUtils.isDlpIndex(currentSession.sceneInfo.appIndex) ? 0 :
              currentSession.sceneInfo.appIndex));
          let recentTaskInfo = new RecentBundleMissionInfo();
          if (CheckEmptyUtils.isEmpty(appItem)) {
            log.showInfo(`app not found in appList: ${currentSession.sceneInfo.bundleName}`);
            recentTaskInfo = this.getAbilityItemInfo(currentSession) ?? recentTaskInfo;
            noAppDesktopIconList.push(currentSession.sceneInfo.bundleName);
          } else if (appItem) {
            appItem.appInstanceKey = currentSession.sceneInfo?.appInstanceKey;
            this.appItemCopyToRecentTaskInfo(appItem, recentTaskInfo);
          }
          recentTaskInfo.missionInfoList = [];
          recentTaskInfo.missionInfoList.push(containerSessionList[i]);
          log.showInfo(`dont merge scene to athers, currentSceneInfo: ${recentTaskInfo.bundleName},${recentTaskInfo.moduleName},${recentTaskInfo.abilityName},${recentTaskInfo.shortcutId},${currentSession.sceneInfo.persistentId},${recentTaskInfo.appIndex}`);
          recentMissionsList.push(recentTaskInfo);
        }
      }
    }
    AppStorage.setOrCreate('noAppDesktopIconList', noAppDesktopIconList);
  }

  public fillRecentTaskInfoWithPersistentId(recentTaskInfo: RecentBundleMissionInfo,
    currentSession: SCBSceneSession, isIndependentIconAbility: boolean): void {
    if (isIndependentIconAbility) {
      recentTaskInfo.persistentId = String(currentSession.sceneInfo.persistentId);
      recentTaskInfo.appIndex = currentSession.sceneInfo.appIndex;
    }
  }

  /**
   * 获取运行任务对应的abilityItem信息
   *
   * @param currentSession
   * @returns
   */
  public getAbilityItemInfo(currentSession: SCBSceneSession): RecentBundleMissionInfo | undefined {
    const recentInfo = super.getAbilityItemInfo(currentSession);
    const startFromShortcutID = currentSession.sceneInfo?.want?.parameters?.[SCBConstants.START_FROM_SHORTCUT_ID] || '';
    if (!!startFromShortcutID && recentInfo) {
      log.showInfo(`getAbilityItemInfo, bundle:${currentSession.sceneInfo.bundleName}, shortcutId:${startFromShortcutID}`);
      recentInfo.shortcutId = startFromShortcutID as string;
      recentInfo.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      // shortcut类型添加到桌面时，abilityName为空，这里保持一致
      recentInfo.abilityName = '';
      if (this.allShortcutInfoList) {
        let shortcutInfo = this.allShortcutInfoList.find(item => item.id === startFromShortcutID);
        recentInfo.appLabelId = shortcutInfo?.labelId || recentInfo.appLabelId;
        if (!CheckEmptyUtils.isEmpty(shortcutInfo?.iconId) || !CheckEmptyUtils.isEmpty(shortcutInfo?.icon)) {
          recentInfo.appIconId = shortcutInfo?.iconId ?? 0;
          recentInfo.iconResource = shortcutInfo?.icon;
        }
      }
    }
    return recentInfo;
  }

  public getAllSession(containerSession: SCBSceneContainerSession): Array<SCBSceneSession> {
    let primarySession: SCBSceneSession | null = containerSession.primarySession;
    let secondSession: SCBSceneSession | null = containerSession.secondarySession;
    if (primarySession?.sceneInfo) {
      log.showInfo(`getAllSession in one containerSession: ${primarySession.sceneInfo.bundleName} ${primarySession.sceneInfo.abilityName}`);
    }
    let allSession: SCBSceneSession[] = [];
    if (!CheckEmptyUtils.isEmpty(primarySession)) {
      allSession.push(primarySession!);
    }
    if (!CheckEmptyUtils.isEmpty(secondSession)) {
      allSession.push(secondSession!);
    }
    return allSession;
  }

  public isDuplicate(list: AppItemInfo[], appInfo: AppItemInfo): boolean {
    const duplicate = list.find(item => {
      log.showInfo(`isDuplicate in dockResident: keyName:${item.keyName}, appInfo.keyName:${appInfo.keyName},` +
        ` item.shortcutId:${item.shortcutId}, appInfo.shortcutId:${appInfo.shortcutId}`);
      return item.keyName === appInfo.keyName &&
        item.appIndex === appInfo.appIndex &&
        (item.shortcutId ?? '') === (appInfo.shortcutId ?? '');
    });
    if (duplicate) {
      try {
        promptAction.showToast({
          message: ResUtils.getInnerString($r('app.string.duplicate_add')),
          bottom: this.getToastBottom(),
          showMode: promptAction.ToastShowMode.TOP_MOST
        });
      } catch (err) {
        log.error('[isDuplicate showToast] failed, error -> ', err);
      }
    }
    log.showInfo(`isDuplicate in dockResident: ${!!duplicate}`);
    return !!duplicate;
  }

  public checkAppInstanceKey(appInstanceKey?: string, toAppInstanceKey?: string): boolean {
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

  /**
   * 监听oobe事件，it镜像企业空间中隐藏应用市场
   */
  public oobeEventListen(): void {
    log.showInfo('oobeEventListen start');
    sEventManager.subscribe(OOBE_CHANGE_EVENT, this.onOOBEChange.bind(this));
    sEventManager.subscribe(OTA_OOBE_CHANGE_EVENT, this.onOOBEChange.bind(this));
  }

  public onOOBEChange(enable: boolean): void {
    try {
      log.showInfo(`Oobe state change ${enable}`);
      if (enable) {
        log.showError(`Oobe is unenable`);
        return;
      }
      const pass: boolean = EnterpriseSpaceUtil.envCheck();
      if (!pass) {
        log.showWarn(`enterorise space check not pass`);
        return;
      }
      EnterpriseSpaceUtil.getNeedHiddenAppList().forEach((bundleName) => {
        const dockItem = this.getDockItemByBundleName(bundleName);
        if (dockItem) {
          log.showInfo(`dock hide: ${bundleName}, dockItem is ${JSON.stringify(dockItem)}`);
          this.deleteDockItem(dockItem as DeleteDockItem, SmartDockConstants.RESIDENT_DOCK_TYPE);
        }
      });
    } catch (err) {
      log.showError(`Oobe change callback error: ${err?.code} ${err?.message}`);
    }
  }

  public vpnEventListen(): void {
    log.showInfo('start vpn event listen');
    EnterpriseSpaceUtil.onvpnConfigChange(() => {
      log.showInfo(`vpn event listen callback`);
      const pass: boolean = EnterpriseSpaceUtil.envCheck();
      log.showInfo(`vpn envCheck result: ${pass}`);
      if (!pass) {
        log.showWarn(`enterorise space check not pass`);
        return;
      }
      EnterpriseSpaceUtil.getNeedHiddenAppList().forEach((bundleName) => {
        const dockItem = this.getDockItemByBundleName(bundleName);
        if (dockItem) {
          log.showInfo(`dock hide: ${bundleName}, dockItem is ${dockItem.appName}`);
          this.deleteDockItem(dockItem as DeleteDockItem, SmartDockConstants.RESIDENT_DOCK_TYPE);
        }
      });
    });
  }

  public checkIsSameItem(dockItem: DockItemInfo | RecentBundleMissionInfo,
    item: AppItemInfo | DockItemInfo): boolean {
    return dockItem?.bundleName === item?.bundleName &&
      dockItem?.abilityName === item?.abilityName &&
      dockItem?.appIndex === item?.appIndex &&
    PcSmartDockModel.getInstance().checkAppInstanceKey(dockItem?.appInstanceKey, item?.appInstanceKey) &&
      (dockItem?.persistentId ?? '') === (item.persistentId ?? '');
  }

  public excludeInCollaborationList(recentMissionsList: Array<RecentBundleMissionInfo>):
    Array<RecentBundleMissionInfo> {
    let collaborationDataList: RecentBundleMissionInfo[] | undefined = AppStorage.get('collaborationDataList');
    let reOrderRecentList: RecentBundleMissionInfo[] = [];

    if (CheckEmptyUtils.isEmptyArr(collaborationDataList)) {
      return recentMissionsList;
    }
    recentMissionsList.forEach(item => {
      const index: number = collaborationDataList!.findIndex((dockItem: RecentBundleMissionInfo) => {
        return this.checkIsSameItem(dockItem, item);
      });
      if (index < 0) {
        reOrderRecentList.push(item);
      }
    });
    return reOrderRecentList;
  }

  public addHideInRecentListSessions(session: SCBSceneContainerSession): void {
    if (this.hideInRecentListSessions.has(session)) {
      log.showDebug(`Already Added, bundleName is ${session.primarySession?.sceneInfo?.bundleName}` +
        ` abilityName is ${session.primarySession?.sceneInfo?.abilityName}`);
    } else {
      log.showInfo(`addHideInRecentListSessions, bundleName is ${session.primarySession?.sceneInfo?.bundleName}` +
        ` abilityName is ${session.primarySession?.sceneInfo?.abilityName}`);
      this.hideInRecentListSessions.add(session);
    }
  }

  public deleteHideInRecentListSessions(session: SCBSceneContainerSession): void {
    if (this.hideInRecentListSessions.has(session)) {
      log.showInfo(`deleteHideInRecentListSessions, bundleName is ${session.primarySession?.sceneInfo?.bundleName}` +
        ` abilityName is ${session.primarySession?.sceneInfo?.abilityName}`);
      this.hideInRecentListSessions.delete(session);
    } else {
      log.showError(`NOT in list , bundleName is ${session.primarySession?.sceneInfo?.bundleName}` +
        ` abilityName is ${session.primarySession?.sceneInfo?.abilityName}`);
    }
  }

  /**
   * 更新窗口列表
   */
  public refreshSCBSceneContainerSession(): void {
    let containerSessionList: SCBSceneContainerSession[] =
      SCBSceneSessionManager.getInstance().getContainerSessionList();
    log.showInfo(`refreshSCBSceneContainerSession : containerSessionList.length: ${containerSessionList.length}`);

    let id: number = -1;
    let bundleName: string = '';
    let appInstanceKey: string = '';
    this.sessionMap.clear();
    containerSessionList.forEach((item) => {
      // 二分模式主屏
      if (item?.primarySession?.sceneInfo.persistentId) {
        id = item?.primarySession?.sceneInfo.persistentId;
        bundleName = item?.primarySession?.sceneInfo.bundleName ?? '';
        appInstanceKey = item?.primarySession?.sceneInfo.appInstanceKey ?? '';
        this.sessionMap.set(id, [bundleName, appInstanceKey]);
        log.showInfo(`refreshSCBSceneContainerSession : add: ${id}, ${bundleName}, ${appInstanceKey}`);
      }

      // 二分模式次屏
      if (item?.secondarySession?.sceneInfo.persistentId) {
        id = item?.secondarySession?.sceneInfo.persistentId;
        bundleName = item?.secondarySession?.sceneInfo.bundleName ?? '';
        appInstanceKey = item?.secondarySession?.sceneInfo.appInstanceKey ?? '';
        this.sessionMap.set(id, [bundleName, appInstanceKey]);
        log.showInfo(`refreshSCBSceneContainerSession : add: ${id}, ${bundleName}, ${appInstanceKey}`);
      }
    });

    log.showInfo(`refreshSCBSceneContainerSession : sessionMap: ${this.sessionMap.size}`);
  }

  /**
   * 更新常驻区多实例应用的AppInstanceKey
   *
   * @param persistentId 窗口id
   */
  public updateAppInstanceKeyInResident(persistentId?: number): void {
    // 根据窗口id获取对应的包名和实例id
    let bundleName: string = '';
    let appInstanceKey: string = '';
    if (persistentId && this.sessionMap.has(persistentId)) {
      let sessions: string[] | undefined = this.sessionMap.get(persistentId);
      if (sessions && sessions.length >= 2) {
        bundleName = sessions[0];
        appInstanceKey = sessions[1];
      }
    }

    if (!bundleName) {
      log.showWarn(`updateAppInstanceKeyInResident : return : bundleName is null`);
      return;
    }

    // 获取所有多实例id
    let appInstanceKeys: string[] = [];
    this.sessionMap.forEach(value => {
      if (bundleName === value[0] && !!value[1]) {
        appInstanceKeys.push(value[1]);
      }
    });
    log.showWarn(`updateAppInstanceKeyInResident : bundleName: ${bundleName}, appInstanceKey: ${appInstanceKey}, ` +
      `appInstanceKeys: ${JSON.stringify(appInstanceKeys)}`);

    if (appInstanceKeys.length > 1) {
      // 如果多实例窗口有多个
      this.swapAppInstanceKeyInResident(bundleName, appInstanceKey, appInstanceKeys);
    } else {
      // 如果多实例窗口仅个
      this.clearAppInstanceKeyInResident(bundleName);
    }
  }

  /**
   * 更新回收站状态
   *
   * @param { RecycleBinRecord } status - 回收站状态信息
   */
  public updateRecycleBinStatus(status?: RecycleBinRecord): void {
    if (!status) {
      log.warn(`updateRecycleBinStatus : reset recyclebin status`);
      this.recycleBinStatus = {
        'screenId': -1,
        'persistentId': -1,
      }
      return;
    }

    this.recycleBinStatus = status;
    log.info(`updateRecycleBinStatus : ${JSON.stringify(status)}`);
  }

  /**
   * 获取回收站状态
   *
   * @returns { RecycleBinRecord } - 回收站状态信息
   */
  public getRecycleBinStatus(): RecycleBinRecord {
    return this.recycleBinStatus;
  }

  /**
   * 查找并清理常驻区多实例应用的AppInstanceKey
   *
   * @param bundleName 应用包名
   */
  public clearAppInstanceKeyInResident(bundleName: string): void {
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    residentList?.forEach((item) => {
      // 查找并清理常驻区多实例应用的AppInstanceKey，appInstanceKey存在则表示此窗口为多实例窗口
      if (item.bundleName === bundleName && !!item.appInstanceKey) {
        log.showInfo(`clearAppInstanceKey : bundleName: ${bundleName}`);
        item.appInstanceKey = undefined;
      }
    });
  }

  private swapAppInstanceKeyInResident(bundleName: string, appInstanceKey: string, appInstanceKeys: string[]): void {
    // 非多实例引用，不需要处理
    if (!appInstanceKey) {
      log.showWarn(`swapAppInstanceKeyInResident : return : appInstanceKey: ${appInstanceKey}`);
      return;
    }

    // 查询待关闭的实例是否来自常驻区
    let isFromResident: boolean = false;
    let hasRunningAppInResident: boolean = false;
    let itemInResident: DockItemInfo = new DockItemInfo();
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    residentList?.filter(item => item.bundleName === bundleName)
      .forEach((item) => {
        itemInResident = item;
        hasRunningAppInResident = this.checkAppIsRunning(item);
        if (item.appInstanceKey === appInstanceKey) {
          isFromResident = true;
        }
        log.showInfo(`swapAppInstanceKeyInResident : hasRunningAppInResident: ${hasRunningAppInResident}, ` +
          `isFromResident: ${isFromResident}`);
      });

    if (!itemInResident.appInstanceKey) {
      log.showWarn(`swapAppInstanceKeyInResident : return : item not found in resident, or item has no appInstanceKey`);
      return;
    }

    // 待关闭的实例来自常驻区，且非运行状态，是未知错误
    if (isFromResident && !hasRunningAppInResident) {
      log.showError(`swapAppInstanceKeyInResident : return : unknown error`);
      return;
    }

    // 待关闭的实例来自暂住区，且常驻区有运行的实例，则不需要处理
    if (!isFromResident && hasRunningAppInResident) {
      log.showWarn(`swapAppInstanceKeyInResident : return : running app in resident`);
      return;
    }

    // 待关闭的实例来自常驻区 或 待关闭的实例来暂常驻区且常驻区没有实例在运行
    if (isFromResident || (!isFromResident && !hasRunningAppInResident)) {
      let instanceIds: number[] = appInstanceKeys.filter(key => key !== appInstanceKey)
        .map<number>(key => {
          let temp = key.split('_');
          return Number(temp[temp.length - 1]);
        });

      // 如果包含非数字，是未知错误
      if (instanceIds.includes(NaN)) {
        log.showError(`swapAppInstanceKeyInResident : return : there are invalid appInstanceKeys`);
        return;
      }

      // 计算下一个实例id(最小可用id)
      // 若当前id为[0, 1, 2]，则下一个id为3
      // 若当前id为[0, 2, 5, 6]，则下一个id为1
      // 若当前id为[2, 5, 6]，则下一个id为0
      log.showInfo(`swapAppInstanceKeyInResident : instanceIds: ${instanceIds}`);
      let max = Math.max(...instanceIds);
      for (let i = 0; i <= max + 1; i++) {
        if (!instanceIds.includes(i)) {
          let key = itemInResident.appInstanceKey;
          let temp: string[] = key.split('_');
          temp[temp.length - 1] = i.toString();
          itemInResident.appInstanceKey = temp.join('_');
          log.showInfo(`swapAppInstanceKeyInResident : ${itemInResident.bundleName} update appInstanceKey : ` +
            `${key} -> ${itemInResident.appInstanceKey}`);
          break;
        }
      }
    }
  }

  private isVassiatant(bundleName: string, abilityName: string): boolean {
    return false;
  }
}

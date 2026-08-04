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

import statusBar from '@ohos.pcService.statusBar';
import { SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import {
  DeviceHelper,
  EventManager,
  EvtBus,
  PluginAccessInfo,
  PluginClickInfo,
  PluginClickType,
  PluginConstants,
  PluginIconType,
  PluginInfo,
  PluginParseInfo,
  PluginPosition,
  PluginType,
  PluginUpdateEvent,
  PluginWindowType
} from '@ohos/frameworkwrapper';
import { ExtendMap } from '@ohos/basicutils/src/main/ets/utils/ExtendMap';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { GetHideAppsFromConfig } from '@ohos/launchercommon/src/main/ets/layoutconfig/GetHideAppsFromConfig';
import {
  StatusBarConnectEvent,
  StatusBarServiceEventManager,
  StatusBarServiceInfo,
  TrayManager,
} from '@ohos/statusbarextensionservice';
import { AppClientNotifier } from '@ohos/statusbarextensionservice/src/main/ets/service/AppClientNotifier';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBSceneContainerSessionArray } from '@ohos/windowscene/src/main/ets/TsIndex';
import { PluginPositionType } from '../common/PluginConstants';

const TAG = 'StatusBarIconManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
const statusBarRemoteManager = StatusBarServiceEventManager.getInstance();

export interface StatusBarMenuChange {
  groupMenu: statusBar.StatusBarGroupMenu[];
  tokenId: number;
  instanceKey: string;
}

interface AccessEvent {
  accessPluginInfoAdd: Function;
  accessPluginInfoRemove: Function;
  accessPanelHeightChange: Function;
  accessMenuChange: Function;
  accessIconChange: Function;
  accessHoverTipsChange: Function;
}

interface ICallback {
  isDeleted: boolean;
  type: StatusBarConnectEvent;
}

export class PcStatusBarIconManager {
  private pluginInfos: PluginInfo[] = [];
  private addAccessPluginInfo: Function | null = null;
  private removeAccessPluginInfo: Function | null = null;
  private tokenIdAccessPluginMap: ExtendMap<PluginAccessInfo> = new ExtendMap<PluginAccessInfo>();
  private changeAccessMenu: Function | null = null;
  private updateAccessPanelHeight: Function | null = null;
  private changeAccessIcon: Function | null = null;
  private changeAccessHoverTips: Function | null = null;
  private eventMgr: EventManager = EvtBus.createEventManager();

  /**
   * 获取所有应用窗口containerSession
   */
  private getContainerSessionListCallback?: Function;

  constructor() {
  }

  private statusBarServiceEvent = (info: StatusBarServiceInfo, callback?: Function): void => {
    const slot = info.tokenId;
    log.showDebug('statusBarServiceEvent type: ' + info.type + ' slot: ' + slot);
    if (!info.data.instanceKey) {
      info.data.instanceKey = '';
    }
    if (GetHideAppsFromConfig.getInstance().isHideApp(info.bundleName)) {
      log.showError('statusBarServiceEvent has Hide App: ' + info.bundleName + ', not deal');
      return;
    }
    switch (info.type) {
      case StatusBarConnectEvent.ADD_TO_STATUS_BAR:
        if (info.data.statusBarItem) {
          this.addIconToStatusBar(info);
        }
        break;
      case StatusBarConnectEvent.REMOVE_FROM_STATUS_BAR:
        this.removeIconFromStatusBar(slot, info.data.instanceKey, callback);
        break;
      case StatusBarConnectEvent.UPDATE_RIGHT_MENU:
        if (info.data?.statusBarMenu) {
          this.updateStatusBarMenu(slot, info.data.instanceKey, info.data.statusBarMenu);
        }
        break;
      case StatusBarConnectEvent.UPDATE_QUICK_OPERATION_HEIGHT:
        if (info.data?.operationHeight) {
          this.updateQuickOperationHeight(slot, info.data.instanceKey, info.data.operationHeight);
        }
        break;
      case StatusBarConnectEvent.UPDATE_STATUSBAR_ICON:
        if (info.data?.statusBarIcon) {
          this.updateIconToStatusBar(slot, info.data.instanceKey, info.data.statusBarIcon);
        }
        break;
      case StatusBarConnectEvent.UPDATE_HOVERTIPS:
        if (info.data?.hoverTips) {
          this.updateHoverTips(slot, info.data.instanceKey, info.data.hoverTips);
        }
        break;
      default:
        break;
    }
  };

  public static getInstance(): PcStatusBarIconManager {
    return SingletonHelper.getInstance(PcStatusBarIconManager, TAG);
  }

  public initPluginInfo(pluginInfos: PluginInfo[]): void {
    this.pluginInfos = pluginInfos;
    // tokenIdAccessPluginMap与pluginInfos进行同步
    for (let i = 0; i < this.pluginInfos.length; i++) {
      let pluginInfo = this.pluginInfos[i];
      if (pluginInfo?.pluginParseInfo?.isAccessPlugin) {
        let accessPluginInfo = pluginInfo as PluginAccessInfo;
        this.tokenIdAccessPluginMap.setData(accessPluginInfo?.accessTokenId,
          accessPluginInfo?.pluginParseInfo.instanceKey ?? '', accessPluginInfo);
      }
    }
  }

  public registerAccessChangeEvent(event: AccessEvent): void {
    statusBarRemoteManager.registerStatusBarServiceEvent(this.statusBarServiceEvent);

    this.addAccessPluginInfo = event.accessPluginInfoAdd;
    this.removeAccessPluginInfo = event.accessPluginInfoRemove;
    this.changeAccessMenu = event.accessMenuChange;
    this.updateAccessPanelHeight = event.accessPanelHeightChange;
    this.changeAccessIcon = event.accessIconChange;
    this.changeAccessHoverTips = event.accessHoverTipsChange;
    log.showInfo('registerAccessChangeEvent method has been init...');
  }

  public unRegisterAllAccessChangeEvent(): void {
    statusBarRemoteManager.unRegisterStatusBarEvent(this.statusBarServiceEvent);

    this.addAccessPluginInfo = null;
    this.removeAccessPluginInfo = null;
    this.changeAccessMenu = null;
    this.updateAccessPanelHeight = null;
    this.changeAccessIcon = null;
    this.changeAccessHoverTips = null;
    log.showInfo('unRegisterAccessChangeEvent method has been remove...');
  }

  public createTrayManager(): void {
    TrayManager.getOrCreateTrayManager().registerTrayManagerListener((tokenId: number, pid: number,
      instanceKey: string, isDetached: boolean) => {
      this.attachOrDetachPidToPlugin(tokenId, pid, instanceKey, isDetached);
    });
    log.showInfo('createTrayManager method has been init...');
  }

  public deleteTrayManager(): void {
    TrayManager.deleteTrayManager();
  }

  public onProcessDead(bundleName: string, pid: number): void {
    log.showDebug('onProcessDead pid: ' + pid + ' bundleName ' + bundleName);
    this.tokenIdAccessPluginMap.forEach((value, key) => {
      if (value instanceof PluginAccessInfo) {
        if (value.pluginParseInfo.bundleName !== bundleName) {
          return;
        }
        if (value.pluginParseInfo.isAccessPlugin) {
          this.detachPidFromAccessPlugin(value.accessTokenId, value.pluginParseInfo.instanceKey, pid);
          TrayManager.getOrCreateTrayManager().tokenIdProcessExit(value.accessTokenId,
            pid, value.pluginParseInfo.instanceKey);
        }
      }
    });
  }

  // 绑定后台进程到图标上
  public attachOrDetachPidToPlugin(slot: number, processIndex: number,
    instanceIndex: string, isDetached: boolean): void {
    let pluginAccessInfo = this.tokenIdAccessPluginMap.getData(slot, instanceIndex);
    if (!pluginAccessInfo) {
      log.showError(`attachOrDetachPidToPlugin not found, slot: ${slot},
      processIndex: ${processIndex}, instanceIndex: ${instanceIndex}, isDetached: ${isDetached}`);
      return;
    }
    log.showInfo(`attachBackPidToPlugin slot: ${slot}, processIndex: ${processIndex},
      instanceKey: ${instanceIndex}, isDetached: ${isDetached}`);
    if (isDetached) {
      // 解绑不区分后台进程
      this.detachPidFromAccessPlugin(slot, instanceIndex, processIndex);
    } else {
      pluginAccessInfo.attachPids.add(processIndex);
    }
    // 绑定进程变化，更新页面的pluginInfo数据
    EvtBus.post(PluginUpdateEvent, { newInfo: pluginAccessInfo });
  }

  // 绑定前台进程到图标上
  private attachForePidToPlugin(slot: number, instanceIndex: string, processIndex: number): void {
    let pluginAccessInfo = this.tokenIdAccessPluginMap.getData(slot, instanceIndex);
    // 判断当前需要绑定的进程是否为后台进程，是后台进程则不存到前台进程数组中
    if (pluginAccessInfo && (!pluginAccessInfo.attachPids.has(processIndex))) {
      log.showInfo(`attachForePidToPlugin slot: ${slot}, processIndex: ${processIndex}`);
      pluginAccessInfo.pids.add(processIndex);
      // 绑定进程变化，更新页面的pluginInfo数据
      EvtBus.post(PluginUpdateEvent, { newInfo: pluginAccessInfo });
    }
  }

  private detachPidFromAccessPlugin(slot: number, instanceIndex: string, processIndex: number): void {
    let accessPlugin = this.tokenIdAccessPluginMap.getData(slot, instanceIndex);
    if (accessPlugin === undefined) {
      log.showError(`detachPidFromAccessPlugin invalid: ${slot} ${instanceIndex} ${processIndex}`);
      return;
    }
    log.showInfo('detachPidFromAccessPlugin processIndex: ' + processIndex + ' bundleName: ' + slot +
      ' instanceIndex: ' + instanceIndex + ' attach processIndex len: ' + accessPlugin.attachPids.size +
      ' process len: ' + accessPlugin.pids.size);
    if (accessPlugin.pids.has(processIndex)) {
      accessPlugin.pids.delete(processIndex);
    }
    if (accessPlugin.attachPids.has(processIndex)) {
      accessPlugin.attachPids.delete(processIndex);
    }
    let pidSet: Set<number> = new Set();
    pidSet.add(processIndex);
    AppClientNotifier.getInstance().unregisterClient(pidSet);
    // 绑定进程变化，更新页面的pluginInfo数据
    EvtBus.post(PluginUpdateEvent, { newInfo: accessPlugin });
    if (accessPlugin.attachPids.size > 0 || accessPlugin.pids.size > 0) {
      log.showInfo(`detachPidFromAccessPlugin directly return. The process exist`);
      return;
    }
    this.removeIconFromStatusBar(slot, instanceIndex);
  }

  private includeDuplicatePlugin(bundleName: string, tokenId: number, instanceKey: string): boolean {
    for (let i = 0; i < this.pluginInfos.length; i++) {
      let pluginInfo = this.pluginInfos[i];
      // 最新开发的三方接入使用accessTokenId进行图标区分，其余采用bundleName区分
      if (pluginInfo?.pluginParseInfo?.isAccessPlugin) {
        let info = pluginInfo as PluginAccessInfo;
        if (info.accessTokenId === tokenId && info.pluginParseInfo.instanceKey === instanceKey) {
          return true;
        }
      } else {
        if (pluginInfo?.pluginParseInfo?.bundleName === bundleName) {
          return true;
        }
      }
    }
    return false;
  }

  private createPluginAccessInfo(info: StatusBarServiceInfo): PluginAccessInfo {
    let item: PluginAccessInfo = new PluginAccessInfo();
    item.attachPids = new Set<number>();
    item.pids = new Set<number>([info.pid]);
    item.accessTokenId = info.tokenId;
    item.icon = info.data.statusBarItem?.icons!;
    item.menuInfo = info.data.statusBarItem?.statusBarGroupMenu ?? [];

    item.pluginParseInfo = new PluginParseInfo();
    item.pluginParseInfo.isAccessPlugin = true;
    item.pluginParseInfo.pluginIconWidth = StyleConstants.PC_STATUS_BAR_ACCESS_ICON_SIZE;
    item.pluginParseInfo.pluginType = PluginType.PLUGIN_TYPE_MESSAGE;
    item.pluginParseInfo.pluginSlot = info.tokenId?.toString();
    item.pluginParseInfo.isLocalPlugin = false;
    item.pluginParseInfo.isNeedRedHot = false;
    item.pluginParseInfo.bundleName = info.bundleName;
    item.pluginParseInfo.action = PluginConstants.ACTION_PLUGIN_STATUS_BAR;
    item.pluginParseInfo.pluginDeviceType = DeviceHelper.TYPE_2IN1;
    item.pluginParseInfo.pluginTemplateName = '';
    item.pluginParseInfo.pluginBackTemplateName = '';
    item.pluginParseInfo.contentColor = StyleConstants.DEFAULT_FONT_COLOR;
    item.pluginParseInfo.pluginPosition = PluginPositionType[PluginPositionType.BOTTOM_RIGHT];
    item.pluginParseInfo.pluginIconType = PluginIconType.TYPE_SMALL_ICON;
    item.pluginParseInfo.instanceKey = info.data.instanceKey!;

    item.pluginParseInfo.clickInfo = new PluginClickInfo();
    item.pluginParseInfo.clickInfo.windowType = PluginWindowType.TYPE_LARGE;
    item.pluginParseInfo.appIndex = info.appIndex;
    if (info.data.statusBarItem?.quickOperation) {
      item.title = info.data.statusBarItem.quickOperation?.title ?? '';
      item.pluginParseInfo.moduleName = info.data.statusBarItem.quickOperation?.moduleName ?? '';
      item.pluginParseInfo.pluginAbilityName = info?.data.statusBarItem.quickOperation?.abilityName ?? '';
      item.pluginParseInfo.clickInfo.clickType = info.data.statusBarItem.quickOperation?.abilityName ?
        PluginClickType.TYPE_WINDOW : PluginClickType.TYPE_ABILITY;
      const windowHeight: number =
        info.data.statusBarItem.quickOperation?.height ?? StyleConstants.DEFAULT_FORM_COMPONENT_HEIGHT;
      item.pluginParseInfo.clickInfo.windowHeight = windowHeight;
      item.loadingStatus = info.data.statusBarItem?.quickOperation.loadingStatus ?? false;
    }
    return item;
  }

  /**
   * 注意：以下方法由外部接口调用，不可随意更改
   *
   * 添加第三方应用图标至状态栏
   * @param bundleName 包名
   * @param info 第三方图标相关信息
   */
  public addIconToStatusBar(info: StatusBarServiceInfo): void {
    if (this.addAccessPluginInfo === null) {
      log.showError('the callback method to add icon is null');
      return;
    }
    if (info.pid < 0) {
      log.showError('the pid is error');
      return;
    }
    const slot = info.tokenId;
    const isDuplicate: boolean = this.includeDuplicatePlugin(info.bundleName, slot, info.data.instanceKey ?? '');
    log.showInfo(`addIconToStatusBar. bundleName: ${info.bundleName}, slot: ${slot}, pid: ${info.pid}, isDuplicate: ${isDuplicate}`);
    if (isDuplicate) {
      this.attachForePidToPlugin(slot, info.data.instanceKey ?? '', info.pid);
      return;
    }

    let item = this.createPluginAccessInfo(info);
    this.addAccessPluginInfo(item);
    this.pluginInfos.push(item as PluginInfo);
    this.tokenIdAccessPluginMap.setData(slot, info.data.instanceKey ?? '', item);
    TrayManager.getOrCreateTrayManager().createTrayForApp(slot, info.bundleName, [info.pid], info.data.instanceKey ?? '');
  }

  /**
   * 注意：以下方法由外部接口调用，不可随意更改
   *
   * 从状态栏移除第三方应用图标
   * @param bundleName 包名
   */
  public removeIconFromStatusBar(slot: number, instanceIndex: string, callback?: Function): void {
    if (this.removeAccessPluginInfo === null || !this.tokenIdAccessPluginMap.hasData(slot, instanceIndex)) {
      log.showInfo(`removeAccessPluginInfo is null or no such slot ${slot}`);
      this.replyDeletedRes(false, callback!);
      return;
    }
    let pluginAccessInfo = this.tokenIdAccessPluginMap.getData(slot, instanceIndex);
    log.showInfo(`removeIconFromStatusBar slot: ${slot}, instanceIndex: ${instanceIndex},
    foreground-pids: ${pluginAccessInfo?.pids.size}, background-pids: ${pluginAccessInfo?.attachPids.size}`);
    // 如果有后台进程且无前台窗口，不允许移除图标
    if (pluginAccessInfo?.attachPids.size! > 0 &&
      !this.checkPluginHasForegroundWindow(pluginAccessInfo!.pids, pluginAccessInfo!.attachPids)) {
      log.showInfo('removeIconFromStatusBar has background-pid and no foreground-window, not allow to remove');
      this.replyDeletedRes(false, callback!);
      return;
    }
    this.removeAccessPluginInfo(slot, instanceIndex, (isDelete: boolean) => {
      if (!isDelete) {
        this.replyDeletedRes(false, callback!);
        return;
      }
      TrayManager.getOrCreateTrayManager().deleteTrayForApp(slot, instanceIndex);
      const index = this.pluginInfos.findIndex((item: PluginInfo) => {
        if (item instanceof PluginAccessInfo) {
          return item.accessTokenId === slot && item.pluginParseInfo.instanceKey === instanceIndex;
        }
        return false;
      });
      this.pluginInfos.splice(index, 1);
      this.tokenIdAccessPluginMap.deleteData(slot, instanceIndex);
      this.replyDeletedRes(true, callback!);
    });
  }

  /**
   * 返回移除结果
   *
   * @param isDeleted 是否移除成功
   * @param callback callback
   */
  private replyDeletedRes(isDeleted: boolean, callback: Function): void {
    if (!callback) {
      log.showError(`notifyDeleteRes callback invalid`);
      return;
    }
    callback({
      isDeleted: isDeleted,
      type: StatusBarConnectEvent.REMOVE_FROM_STATUS_BAR
    } as ICallback);
  }

  /**
   * 注意：以下方法由外部接口调用，不可随意更改
   *
   * 更新右键菜单
   * @param statusBarMenu 菜单更新信息
   */
  public updateStatusBarMenu(tokenId: number, instanceKey: string, menuInfo: statusBar.StatusBarGroupMenu[]): void {
    if (this.changeAccessMenu === null) {
      log.showInfo('changeAccessMenu is null');
      return;
    }
    const statusBarMenu: StatusBarMenuChange = {
      groupMenu: menuInfo,
      tokenId: tokenId,
      instanceKey: instanceKey,
    };
    this.changeAccessMenu(statusBarMenu);
  }

  /**
   * 注意：以下方法由外部接口调用，不可随意更改
   *
   * 更新三方接入图标左键二级面板的自定义区域高度
   * @param tokenId
   * @param height
   */
  public updateQuickOperationHeight(tokenId: number, instanceKey: string, height: number): void {
    if (this.tokenIdAccessPluginMap.hasData(tokenId, instanceKey) &&
      this.updateAccessPanelHeight && height > 0) {
      this.updateAccessPanelHeight(tokenId, instanceKey, height);
    }
    log.info('statusbar update quick operation height');
  }

  /**
   * 注意：以下方法由外部接口调用，不可随意更改
   *
   * 更新三方接入图标
   * @param tokenId
   * @param icons
   */
  public updateIconToStatusBar(tokenId: number, instanceKey: string, icons: statusBar.StatusBarIcon): void {
    if (this.changeAccessIcon === null) {
      return;
    }
    this.changeAccessIcon(tokenId, instanceKey, icons);
  }

  public updateHoverTips(tokenId: number, instanceKey: string, hoverTips: string): void {
    if (this.changeAccessHoverTips === null) {
      return;
    }
    this.changeAccessHoverTips(tokenId, instanceKey, hoverTips);
  }

  public registerGetContainerSessionListCallback(callback: Function): void {
    this.getContainerSessionListCallback = callback;
  }

  public unregisterGetContainerSessionListCallback(): void {
    this.getContainerSessionListCallback = undefined;
  }

  public checkPluginHasForegroundWindow(foregroundPids: Set<number>, attachPids: Set<number>): boolean {
    if (foregroundPids.size === 0 && attachPids.size === 0) {
      log.showInfo('checkPluginHasForegroundWindow foreground-pid and background-pid empty');
      return true;
    }
    // 获取所有的container session
    if (!this.getContainerSessionListCallback) {
      log.showError('callback invalid');
      return false;
    }
    let containerSessionLists: SCBSceneContainerSessionArray = this.getContainerSessionListCallback();
    // 遍历所有的container session，判断是否有前台窗口
    for (let containerSession of containerSessionLists) {
      if (containerSession.primarySession) {
        let primarySessionPid = sceneSessionManager.getWindowPid(containerSession.primarySession.session.persistentId);
        if (primarySessionPid && (foregroundPids.has(primarySessionPid) ||
        attachPids.has(primarySessionPid)) && containerSession.primarySession.isSessionForeground()) {
          log.showInfo('checkPluginHasForegroundWindow has foreground-window session1');
          return true;
        }
      }
      if (containerSession.secondarySession) {
        let secondarySessionPid =
          sceneSessionManager.getWindowPid(containerSession.secondarySession.session.persistentId);
        if (secondarySessionPid && (foregroundPids.has(secondarySessionPid) ||
        attachPids.has(secondarySessionPid)) && containerSession.secondarySession.isSessionForeground()) {
          log.showInfo('checkPluginHasForegroundWindow has foreground-window session2');
          return true;
        }
      }
    }
    return false;
  }
}
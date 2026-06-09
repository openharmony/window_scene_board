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
import { PcStatusBarIconManager, StatusBarMenuChange } from '../manager/PcStatusBarIconManager';
import { PluginProperty } from '../viewdata/PluginProperty';
import { PluginAccessBase } from './PluginAccessBase';
import { PluginListAdapter } from '../pluginData/PluginListAdapter';
// import statusBar from '@hms.pcService.statusBar';
import StatusBarEventPoster from '../manager/StatusBarEventPoster';
import {
  AccessPanelHeightChangeEvent,
  CapsuleVisibleEvent,
  EventManager, EvtBus, PluginAccessInfo,
  PluginChangeEvent,
  PluginIconChangeEvent,
  PluginPosition} from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'MessageAccess';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

/**
 * 通过一步直达方式接入
 */
export class MessageAccess extends PluginAccessBase {
  private eventMgr: EventManager = EvtBus.createEventManager();

  protected initDiff(): void {
    PcStatusBarIconManager.getInstance().createTrayManager();
    // 接入第三方应用回调初始化
    PcStatusBarIconManager.getInstance().registerAccessChangeEvent({
      accessPluginInfoAdd: (pluginInfo: PluginAccessInfo): void => {
        this.addAccessPluginInfo(pluginInfo)
      },
      accessPluginInfoRemove: (tokenId: number, instanceKey: string, callback?: Function): void => {
        this.removeAccessPluginInfo(tokenId, instanceKey, callback)
      },
      accessMenuChange: (statusBarMenu: StatusBarMenuChange): void => {
        this.updateAccessMenuInfo(statusBarMenu)
      },
      accessPanelHeightChange: (tokenId: number, instanceKey: string, height: number): void => {
        this.updateAccessPanelHeight(tokenId, instanceKey, height)
      },
      accessIconChange: (tokenId: number, instanceKey: string, icons: ESObject): void => {
        this.updateAccessIconInfo(tokenId, instanceKey, icons)
      }
    });
    this.eventMgr.on(CapsuleVisibleEvent, this.onCapsuleVisibleEvent);
  }

  private onCapsuleVisibleEvent = (event: CapsuleVisibleEvent) => {
    if (event.visible) {
      return;
    }
    PcStatusBarIconManager.getInstance().onProcessDead(PluginListAdapter.getInstance()
      .getPluginPropertyBySlot(event.pluginSlot)?.pluginInfo?.pluginParseInfo?.bundleName!, event.requestPid!);
  }

  private addAccessPluginInfo(pluginInfo: PluginAccessInfo): void {
    log.showInfo('addAccessPluginInfo info:' + pluginInfo.getSlot() + ' package:' +
      pluginInfo.pluginParseInfo.bundleName);
    this.notifyAddData([pluginInfo]);
  }

  private removeAccessPluginInfo(slot: number, instanceIndex: string, callback?: Function): void {
    log.showInfo('removeAccessPluginInfo slot: ' + slot + ' instanceIndex: ' + instanceIndex);
    const pluginInfo = PluginListAdapter.getInstance().getPluginPropertyByTokenId(slot, instanceIndex);
    if (CheckEmptyUtils.isEmpty(pluginInfo)) {
      callback?.(false);
      return;
    }

    const info = pluginInfo?.pluginInfo as PluginAccessInfo;
    const pluginInstanceIndex = info?.pluginParseInfo?.instanceKey;
    log.showInfo('removeAccessPluginInfo slot: ' + slot +
      ' bundleName: ' + info?.pluginParseInfo?.bundleName + ' pluginInstanceIndex: ' + pluginInstanceIndex);
    callback?.(true);
    this.notifyRemoveData([info]);
  }

  /**
   * 更新第三方图标
   *
   * @param slot
   * @param icons 图标信息
   */
  private updateAccessIconInfo(slot: number, instanceIndex: string, icons: ESObject) {
    log.showInfo(`updateAccessIconInfo ${slot} ${instanceIndex}`);
    const pluginInfo: PluginProperty | null = PluginListAdapter.getInstance()
      .getPluginPropertyByTokenId(slot, instanceIndex);
    if (pluginInfo) {
      (pluginInfo.pluginInfo as PluginAccessInfo).icon = icons;
      StatusBarEventPoster.getInstance().postExternalEvent(PluginIconChangeEvent, {
        tokenId: slot,
        instanceKey: instanceIndex,
      } as PluginIconChangeEvent);
    }
    const eventData: PluginChangeEvent = {
      pluginInfos: [], position: PluginPosition.POSITION_RIGHT
    }
    StatusBarEventPoster.getInstance().postExternalEvent(PluginChangeEvent, eventData);
  }

  /**
   * 更新第三方图标右键菜单信息
   *
   * @param statusBarMenu 菜单信息
   */
  private updateAccessMenuInfo(statusBarMenu: StatusBarMenuChange): void {
    const instanceIndex: string = statusBarMenu.instanceKey;
    const slot: number = statusBarMenu.tokenId;
    log.showInfo(`updateAccessMenuInfo ${instanceIndex}
      ${slot} ${statusBarMenu.groupMenu.length}`);
    const pluginInfo: PluginProperty | null = PluginListAdapter.getInstance()
      .getPluginPropertyByTokenId(slot, instanceIndex);
    if (pluginInfo && pluginInfo.pluginInfo) {
      // (pluginInfo.pluginInfo as PluginAccessInfo).menuInfo = statusBarMenu.groupMenu;
      const eventData: PluginChangeEvent = {
        pluginInfos: [], position: PluginPosition.POSITION_RIGHT
      }
      StatusBarEventPoster.getInstance().postExternalEvent(PluginChangeEvent, eventData);
    }
  }

  private updateAccessPanelHeight(slot: number, instanceIndex: string, height: number): void {
    const pluginInfo: PluginProperty | null = PluginListAdapter.getInstance()
      .getPluginPropertyByTokenId(slot, instanceIndex);
    if (pluginInfo && pluginInfo.pluginInfo) {
      pluginInfo.pluginInfo.pluginParseInfo.clickInfo.windowHeight = height;
    }

    const panelHeightEvent: AccessPanelHeightChangeEvent = {
      windowHeight: height,
      instanceKey: instanceIndex,
      tokenId: slot,
    };
    log.showInfo(`updateAccessPanelHeight ${slot} ${instanceIndex} ${height}`);
    StatusBarEventPoster.getInstance().postExternalEvent(AccessPanelHeightChangeEvent, panelHeightEvent);
  }

  protected deInitDiff(): void {
    PcStatusBarIconManager.getInstance().unRegisterAllAccessChangeEvent();
    PcStatusBarIconManager.getInstance().deleteTrayManager();
    this.eventMgr.offAll();
  }
}
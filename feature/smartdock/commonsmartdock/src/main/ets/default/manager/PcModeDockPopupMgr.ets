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

import { DockItemInfo, EventConstants, ResidentLayoutCacheMgr } from '@ohos/launchercommon';
import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { localEventManager } from '@ohos/frameworkwrapper';
import { ArrayList } from '@kit.ArkTS';
import { CollaborationLayoutCacheMgr } from '@ohos/launchercommon/src/main/ets/dock/cache/CollaborationLayoutCacheMgr';

const TAG = 'PcModeDockPopupMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'PCDock-' + TAG);

export class PcModeDockPopupMgr {
  private static instance: PcModeDockPopupMgr;
  private currItem: DockItemInfo | null = null;
  private controllerMap: Map<string, ArrayList<PcModeDockPopupController>> =
    new Map<string, ArrayList<PcModeDockPopupController>>();

  private constructor() {
    this.init();
    log.showInfo('PcModeDockPopupMgr constructor');
  }

  static getInstance(): PcModeDockPopupMgr {
    if (!PcModeDockPopupMgr.instance) {
      PcModeDockPopupMgr.instance = new PcModeDockPopupMgr();
    }
    return PcModeDockPopupMgr.instance;
  }

  private init() {
    this.currItem = null;
    this.registerPcModeDockListener();
  }

  public setCurrItem(item: DockItemInfo | null): void {
    this.currItem = item;
  }

  public getCurrItem(): DockItemInfo | null {
    return this.currItem;
  }

  public isPopupShow(item: DockItemInfo): boolean {
    if (this.currItem === item) {
      return true;
    }
    return false;
  }

  public registerPopupController(item: DockItemInfo, controller: PcModeDockPopupController): void {
    const key: string = this.getKeyName(item);
    let controllers: ArrayList<PcModeDockPopupController> = this.controllerMap.get(key) ??
      new ArrayList<PcModeDockPopupController>();
    controllers?.add(controller);
    this.controllerMap.set(key, controllers);
  }

  public unRegisterPopupController(item: DockItemInfo, controller: PcModeDockPopupController): void {
    const key: string = this.getKeyName(item);
    let controllers: ArrayList<PcModeDockPopupController> = this.controllerMap.get(key) ??
      new ArrayList<PcModeDockPopupController>();
    if (!CheckEmptyUtils.isEmptyArr(controllers.convertToArray())) {
      controllers?.remove(controller);
    }
    if (controllers?.isEmpty()) {
      this.controllerMap.delete(key);
    }
  }

  public closeOtherPopups(item: DockItemInfo): void {
    log.showInfo(`closeOtherPopups happen`);
    let residentList: DockItemInfo[] = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
    let recentList: DockItemInfo[] = AppStorage.get('recentList') ?? [];
    const collaborationList: DockItemInfo[] = CollaborationLayoutCacheMgr.getInstance().getAllDockItems();
    residentList.forEach((listItem: DockItemInfo) => {
      if (listItem?.bundleName === item?.bundleName && listItem?.abilityName === item.abilityName) {
        return;
      }
      this.controllerMap.get(this.getKeyName(listItem))?.forEach(
          (controller: PcModeDockPopupController) => controller.popupAndMenuClose());
    });
    recentList.forEach((listItem: DockItemInfo) => {
      if (listItem?.bundleName === item?.bundleName && listItem?.abilityName === item.abilityName) {
        return;
      }
      this.controllerMap.get(this.getKeyName(listItem))?.forEach(
          (controller: PcModeDockPopupController) => controller.popupAndMenuClose());
    });
    collaborationList?.forEach((listItem: DockItemInfo) => {
      if (listItem?.bundleName === item?.bundleName && listItem?.abilityName === item.abilityName) {
        return;
      }
      this.controllerMap.get(this.getKeyName(listItem))?.forEach(
        (controller: PcModeDockPopupController) => controller.popupAndMenuClose());
    });
  }

  private getKeyName(item: DockItemInfo): string {
    if (CheckEmptyUtils.isEmpty(item)) {
      log.showError(`getkeyName item is null error`);
      return '';
    }
    const key: string = item?.bundleName + '_' + item?.abilityName + '_' + 'pcmode';
    log.showDebug(`getkeyName key: ${key}`);
    return key;
  }

  private registerPcModeDockListener(): void {
    localEventManager.registerEventListener(this.pcModeDockListener, [EventConstants.EVENT_PC_DOCK_CLOSE_POPUP]);
    log.showInfo('registerPcModeDockListener');
  }

  private readonly pcModeDockListener: PcModeDockPopupListener = {
    onReceiveEvent: (event: string): void => {
      log.showInfo(`pcModeDockPopupMgr, receive event : ${event}`);
      if (event === EventConstants.EVENT_PC_DOCK_CLOSE_POPUP) {
        this.closeOtherPopups(new DockItemInfo());
        AppStorage.setOrCreate('isHoverSnapshot', false);
      }
    }
  };
}

export interface PcModeDockPopupController {
  popupAndMenuClose: Function;
}

interface PcModeDockPopupListener {
  onReceiveEvent: Function;
}
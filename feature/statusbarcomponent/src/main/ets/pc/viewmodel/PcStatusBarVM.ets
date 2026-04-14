/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
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

import { ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { GlobalContext, PluginSlot } from '@ohos/frameworkwrapper';
import osAccount from '@ohos.account.osAccount';
import { BusinessError } from '@kit.BasicServicesKit';
import type ctx from '@ohos.app.ability.common';
import Settings from '@ohos.settings';
import { PluginSlotMappingNew } from '../common/PluginSlotMappingNew';

const TAG = 'PcStatusBarVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const accountManager: osAccount.AccountManager = osAccount.getAccountManager();
const SETTINGS_PC_STATUSBAR_DYNAMIC_PLUGS: string = 'settings.pcstatusbar.dynamicPlugs';
const SETTINGS_PC_STATUSBAR_TRAY_PLUGS: string = 'settings.pcstatusbar.trayPlugs';
const INVALID_ID: number = -1;
const VIRTUAL_KEYBOARD_BUNDLE_NAME = 'com.ohos.virtualkeyboard';
const SUPER_PRIVACY_DIRTY_SLOT: Map<string, string> = new Map([
  ['status_bar_super_privacy_paddle', PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE],
  ['status_bar_super_privacy_setting_paddle', PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE],
  ['status_bar_super_privacy_soft', PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT],
  ['status_bar_super_privacy_setting_soft', PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PC_SOFT]]
);

export interface objData {
  plugList: Record<string, Array<string>>;
}

export default class PcStatusBarVM {
  private static instance: PcStatusBarVM;
  private dynamicPlugsListResult: objData = {
    plugList: {}
  }
  private trayPlugsListResult: objData = {
    plugList: {}
  }
  private currentUserId: number = INVALID_ID;

  public static getInstance(): PcStatusBarVM {
    if (!PcStatusBarVM.instance) {
      PcStatusBarVM.instance = new PcStatusBarVM();
    }
    return PcStatusBarVM.instance;
  }

  private getContext(): ctx.ServiceExtensionContext {
    return GlobalContext.getContext();
  }

  public init(): void {
    log.showInfo('init');
    if (!accountManager) {
      log.showError('accountManager invaild!');
      return;
    }
    try {
      accountManager.getForegroundOsAccountLocalId().then((currentUserId) => {
        this.currentUserId = currentUserId;
        this.dynamicPlugsListResult.plugList[currentUserId] = [];
        this.trayPlugsListResult.plugList[currentUserId] = [];
        log.showInfo('get current userId success');
        if (this.getContext() === undefined) {
          log.showError('init context invaild!');
          return;
        }
        if (this.currentUserId < 0) {
          return;
        }

        Settings.getValue(this.getContext(), SETTINGS_PC_STATUSBAR_DYNAMIC_PLUGS, (err, data) => {
          if (err) {
            log.showError('get SETTINGS_PC_STATUSBAR_DYNAMIC_PLUGS catch error');
            this.dynamicPlugsListResult.plugList[currentUserId] = [];
            return;
          }
          this.dealDynamicData(data);
        })
        Settings.getValue(this.getContext(), SETTINGS_PC_STATUSBAR_TRAY_PLUGS, (err, data) => {
          if (err) {
            log.showError('get SETTINGS_PC_STATUSBAR_TRAY_PLUGS catch error');
            this.trayPlugsListResult.plugList[currentUserId] = [];
            return;
          }
          this.dealTrayData(data);
        })
      }).catch((error: BusinessError) => {
        log.showError('get current userId error:' + JSON.stringify(error));
      });
    } catch (err) {
      log.showError('init fail');
    }
  }

  private dealDynamicData(data: string) {
    let emptyList: objData = {
      plugList: {}
    }
    try {
      log.showInfo('dealDynamicData:' + data);
      this.dynamicPlugsListResult = data.length > 0 ? JSON.parse(data) : emptyList;
      if (this.dynamicPlugsListResult.plugList[this.currentUserId] === undefined ||
        this.dynamicPlugsListResult.plugList[this.currentUserId] === null) {
        log.showInfo('add empty dynamic array for currentUser');
        this.dynamicPlugsListResult.plugList[this.currentUserId] = [];
      }
      this.handleDynamicPlugSort();
    } catch (err) {
      log.showError('dealDynamicData fail');
    }
  }

  private handleDynamicPlugSort(): void {
    if (this.dynamicPlugsListResult.plugList[this.currentUserId].length <= 0) {
      return;
    }
    this.handleDirtyData();
    let dynamicPlugs: string[] = this.dynamicPlugsListResult.plugList[this.currentUserId];
    let fromStrIndex: number = dynamicPlugs.indexOf(PluginSlot.SLOT_CAPSULE_KEY_MOUSE);
    if (fromStrIndex !== -1) {
      dynamicPlugs.splice(fromStrIndex, 1);
    }
    let pcSoftStrIndex: number = dynamicPlugs.indexOf(PluginSlot.SLOT_STATUS_SUPER_PRIVACY_PADDLE);
    let wzStrIndex: number = dynamicPlugs.indexOf(PluginSlot.SLOT_STATUS_LOCATION);
    log.showInfo('ys slot index ' + pcSoftStrIndex + ' wz slot index:' + wzStrIndex);
    dynamicPlugs.splice(wzStrIndex !== -1 &&
      wzStrIndex < pcSoftStrIndex ? wzStrIndex : pcSoftStrIndex, 0, PluginSlot.SLOT_CAPSULE_KEY_MOUSE);
    this.reSortByFixedSlot(dynamicPlugs);
    this.saveDynamicPlugs(dynamicPlugs);
  }

  private reSortByFixedSlot(dynamicPlugs: string[]) {
    let existDynamicFixedSlot: string[] = [];
    // 先从存在的数据中查找动态区固定顺序图标是否存在
    PluginSlotMappingNew.dynamicFixedSlot.forEach((slot: string) => {
      if (dynamicPlugs.includes(slot) && !existDynamicFixedSlot.includes(slot)) {
        existDynamicFixedSlot.push(slot);
      }
    });
    // 删除存在的数据中的固定区图标
    existDynamicFixedSlot.forEach((slot: string) => {
      let index: number = dynamicPlugs.indexOf(slot);
      dynamicPlugs.splice(index, 1);
    });
    // 将固定区图标重新保存在右端
    dynamicPlugs.push(...existDynamicFixedSlot);
  }

  private handleDirtyData(): void {
    // 虚拟键盘在历史版本存储的key值为包名，与预期不符，影响新架构下图标排序，需要修正为 pluginSlot
    let index = ArrayUtils.findIndex(this.dynamicPlugsListResult.plugList[this.currentUserId],
      VIRTUAL_KEYBOARD_BUNDLE_NAME);
    if (index > -1) {
      this.dynamicPlugsListResult.plugList[this.currentUserId].splice(index, 1,
        PluginSlot.SLOT_STATUS_VIRTUAL_KEYBOARD);
    }
    // 超级隐私代码迁移后slot名称变化，兼容ota升级场景
    SUPER_PRIVACY_DIRTY_SLOT.forEach((value, key) => {
      let index = ArrayUtils.findIndex(this.dynamicPlugsListResult.plugList[this.currentUserId], key);
      if (index > -1) {
        log.showWarn(`handleDirtyData change ${key} to ${value}`);
        let find = ArrayUtils.findIndex(this.dynamicPlugsListResult.plugList[this.currentUserId], value) > -1;
        if (find) {
          this.dynamicPlugsListResult.plugList[this.currentUserId].splice(index, 1);
        } else {
          this.dynamicPlugsListResult.plugList[this.currentUserId].splice(index, 1, value);
        }
      }
    });
  }

  private dealTrayData(data: string) {
    let emptyList: objData = {
      plugList: {}
    }
    log.showInfo('dealTrayData:' + data);
    try {
      log.showError('dealTrayData' + data);
      this.trayPlugsListResult = data.length > 0 ? JSON.parse(data) : emptyList;
      if (this.trayPlugsListResult.plugList[this.currentUserId] === undefined ||
        this.trayPlugsListResult.plugList[this.currentUserId] === null) {
        log.showInfo('add empty dynamic array for currentUser');
        this.trayPlugsListResult.plugList[this.currentUserId] = [];
      }
      this.handleTrayKeyMousePlug();
    } catch (err) {
      log.showError('dealDynamicData fail');
    }
  }

  private handleTrayKeyMousePlug(): void {
    if (this.trayPlugsListResult.plugList[this.currentUserId].length <= 0) {
      return;
    }
    let trayPlugs: string[] = this.trayPlugsListResult.plugList[this.currentUserId];
    let fromStrIndex: number = trayPlugs.indexOf(PluginSlot.SLOT_CAPSULE_KEY_MOUSE);
    if (fromStrIndex == -1) {
      return;
    }
    trayPlugs.splice(fromStrIndex, 1);
    this.saveTrayPlugs(trayPlugs);
  }

  getDynamicPlugs(): string[] {
    if (this.currentUserId < 0) {
      return [];
    }
    return this.dynamicPlugsListResult.plugList[this.currentUserId];
  }

  saveDynamicPlugs(plugs: string[]): void {
    if (this.currentUserId < 0) {
      return;
    }
    this.dynamicPlugsListResult.plugList[this.currentUserId] = [...plugs];
    if (this.getContext() === undefined) {
      log.showError('init context invaild!');
      return;
    }
    try {
      Settings.setValue(this.getContext(), SETTINGS_PC_STATUSBAR_DYNAMIC_PLUGS,
        JSON.stringify(this.dynamicPlugsListResult)).then((result) => {
        log.showInfo(`setValue SETTINGS_PC_STATUSBAR_DYNAMIC_PLUGS result: ${result}`);
      }).catch((error: BusinessError) => {
        log.showError('setValue SETTINGS_PC_STATUSBAR_DYNAMIC_PLUGS error:' + JSON.stringify(error));
      });
    } catch (err) {
      log.showError('saveTrayPlugs fail');
    }
  }

  getTrayPlugs(): string[] {
    if (this.currentUserId < 0) {
      return [];
    }
    return this.trayPlugsListResult.plugList[this.currentUserId];
  }

  saveTrayPlugs(plugs: string[]): void {
    if (this.currentUserId < 0) {
      return;
    }
    this.trayPlugsListResult.plugList[this.currentUserId] = [...plugs];
    if (this.getContext() === undefined) {
      log.showError('init context invaild!');
      return;
    }
    try {
      Settings.setValue(this.getContext(), SETTINGS_PC_STATUSBAR_TRAY_PLUGS,
        JSON.stringify(this.trayPlugsListResult)).then((result) => {
        log.showInfo(`setValue SETTINGS_PC_STATUSBAR_TRAY_PLUGS result: ${result}`);
      }).catch((error: BusinessError) => {
        log.showError('setValue SETTINGS_PC_STATUSBAR_DYNAMIC_PLUGS error:' + JSON.stringify(error));
      });
    } catch (err) {
      log.showError('saveTrayPlugs fai');
    }
  }
}
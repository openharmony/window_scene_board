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

import { CheckEmptyUtils, LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  AccountMgr,
  EventManager,
  EvtBus,
  GlobalContext,
  obtainLocalEvent,
  obtainStartAbilityWithWant,
  ProcessStateChangeEvent,
  sEventManager,
  sSettingsUtil
} from '@ohos/frameworkwrapper';
import { SettingsConstants, SettingsKeyConstants } from '@ohos/commonconstants';
import Want from '@ohos.app.ability.Want';
import { Context } from '@kit.AbilityKit';
import settings from '@ohos.settings';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import appManager from '@ohos.app.ability.appManager';
import { osAccount } from '@kit.BasicServicesKit';
import { ToggleBaseViewModel } from '@ohos/controlcentercommon/src/main/ets/toggle/vm/ToggleBaseViewModel';
import { Constants } from '../common/Constants';
import { EventManagerAdapter } from '@ohos/systemuicommon';

const TAG = 'Ctrl.SuperHubToggleController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.CC, TAG);
const MAIN_USER_ID: number = 100;
const UID_2_USER_ID: number = 200000;

export class SuperHubToggleController extends ToggleBaseViewModel {
  private eventManager: EventManager = EvtBus.createEventManager();
  private userId: number = MAIN_USER_ID;
  private processCount: number = 0;

  constructor() {
    super();
    this.getViewData().icon = $r('app.media.ic_transfer_station');
    this.getViewData().label = $r('app.string.control_center_complex_toggle_superhub_title');
  }

  onStart(): void {
    super.onStart();
    log.info('onStart')
    this.initUserId();
    // 开关状态初始化获取 数据库字段=0 可信 data.length === 0 可信，开关状态跟随这两个状态计算
    try {
      let curState = sSettingsUtil.getSecureValue(SettingsKeyConstants.SUPERHUB_TOGGLE_ENABLE,
        SettingsConstants.SUPERHUB_ENABLE_DEFAULT);
      appManager.getRunningProcessInfoByBundleName(Constants.SUPERHUB_BUNDLE_NAME)
        .then((data) => {
          if (CheckEmptyUtils.isEmptyArr(data)) {
            return;
          }
          this.processCount = data.length;
          this.getViewData().isOn = data.length > 0 && curState !== SettingsConstants.SUPERHUB_ENABLE_DEFAULT;
        })
        .catch((error: Error) => { log.showError('getRunningProcessInfoByBundleName execute try error', error) });
    } catch (e) {
      log.showError(`onStart getRunningProcessInfoByBundleName error! error code=${e.code}`);
    }
    try {
      // 注册中转站开关监听
      let result = settings.registerKeyObserver(GlobalContext.getContext(), SettingsKeyConstants.SUPERHUB_TOGGLE_ENABLE,
        settings.domainName.USER_SECURITY, () => {
          this.onSuperHubSwitchDataChange();
        });
      log.showInfo(`init SuperHubSwitchKeyObserver result ${result}`);
    } catch (error) {
      log.showInfo(`Failed to SuperHubSwitchKeyObserver, error: ${error.message}`);
    }
    this.eventManager.on(ProcessStateChangeEvent, this.onProcessStateChange)
    log.showInfo(`onstart SuperHubSwitchData data: ${this.getViewData().isOn}`);
  }

  private async initUserId(): Promise<void> {
    try {
      let accountManager: osAccount.AccountManager = osAccount.getAccountManager();
      let userId: number = await accountManager.getForegroundOsAccountLocalId();
      if (AccountMgr.isInvalidAccount(userId)) {
        log.showWarn('current user id invalid');
        return;
      }
      this.userId = userId;
      log.showInfo(`initUserId cur userId=${userId}`);
    } catch (e) {
      log.showError(`initUserId OsAccount localId failed! error code=${e.code}`);
    }
  }

  private onSuperHubSwitchDataChange(): void {
    try {
      let state = sSettingsUtil.getSecureValue(SettingsKeyConstants.SUPERHUB_TOGGLE_ENABLE,
        SettingsConstants.SUPERHUB_ENABLE_DEFAULT);
      const isEnable: boolean = state !== SettingsConstants.SUPERHUB_ENABLE_DEFAULT;
      log.showInfo(`onSuperHubSwitchDataChange isEnable: ${isEnable}`);
      if (this.getViewData().isOn !== isEnable) {
        this.getViewData().isOn = isEnable;
      }
    } catch (e) {
      log.showError(`settings getSecureValue error:${e}`);
    }
  };

  private onProcessStateChange = (event: ProcessStateChangeEvent): void => {
    log.showInfo(`onProcessStateChange-${event.bundleName}; visible=${event.visible}; pid=${event.requestPid}; uid=${event.requestUid}; userId=${this.userId}; cur processCount=${this.processCount}`);
    if (event.bundleName !== Constants.SUPERHUB_BUNDLE_NAME ||
      this.userId !== Math.floor((event.requestUid ?? 0) / UID_2_USER_ID)) {
      return;
    }
    // 中转站同包名进程计数
    this.processCount = this.processCount + (event.visible ? 1 : -1);
    // 中转站进程彻底关闭，刷新数据库
    if (event.visible !== this.getViewData().isOn && !event.visible && this.processCount === 0) {
      try {
        let context: Context = GlobalContext.getContext();
        if (!context) {
          log.error('set SUPERHUB_TOGGLE_ENABLE error! context is undefined or null');
          return;
        }
        log.warn(`set SUPERHUB_TOGGLE_ENABLE ValueSync updateData=0`);
        if (!settings.setValueSync(context, SettingsKeyConstants.SUPERHUB_TOGGLE_ENABLE, '0',
          settings.domainName.USER_SECURITY)) {
          log.warn('set SUPERHUB_TOGGLE_ENABLE ValueSync fail');
        }
      } catch (error) {
        log.error('Update settingsdata error', error);
      }
    }
  };

  onStop(): void {
    super.onStop();
    log.showInfo('onStop');
    this.eventManager.offAll();
    settings.unregisterKeyObserver(GlobalContext.getContext(), SettingsKeyConstants.SUPERHUB_TOGGLE_ENABLE,
      settings.domainName.USER_SECURITY);
  }

  isAvailable(): boolean {
      return true;
  }

  handleOneClick(): boolean {
    log.info('handleClick start')
    let wantInfo: Want = {
      deviceId: '', // deviceId为空表示本设备
      bundleName: Constants.SUPERHUB_BUNDLE_NAME,
      abilityName: Constants.SUPERHUB_ABILITY_NAME,
      action:'controlCenter'
    }
    try {
      log.info('Begin to startOrStop ability')
      this.handleClickWithScreenLockAndEdit(() => GlobalContext.getContext().startAbility(wantInfo));
    } catch (error) {
      log.error(`Start ability failed with ${error}`)
    }
    // 关闭控制中心
    EventManagerAdapter.startAbility(obtainLocalEvent('hideControlPanel', ''));
    DropDownPanelManager.animToDismissEvent();
    log.info('handleClick end')
    return true;
  }
}
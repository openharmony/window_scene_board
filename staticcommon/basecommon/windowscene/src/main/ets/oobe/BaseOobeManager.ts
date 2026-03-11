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

import {commonBundleManager} from '@ohos/frameworkwrapper';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { AccountMgr } from '@ohos/frameworkwrapper';
import { SCBSceneSessionManager } from '../scene/session/SCBSceneSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus } from '@ohos/frameworkwrapper';
import { OobeActivatedEvent } from '@ohos/frameworkwrapper';
import { ExtAppConstants } from '@ohos/commonconstants';
import type dataShare from '@ohos.data.dataShare';
import sTrustListOobeManager from './trustlist/TrustListOobeManager';
import { StartAbilityUtil } from '../startAbility/StartAbilityUtil';
import systemParameter from '@ohos.systemparameter';
import deviceInfo from '@ohos.deviceInfo';
import { GestureEnableCaller, scbGestureManager } from '../gesturenavigation/SCBGestureManager';
import type ServiceExtensionContext from 'application/ServiceExtensionContext';

export const ADMIN_USERID = 100;

const TAG = 'BaseOobeManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DISPLAY_VERSION_PARAM = 'const.build.ver.physical';

/**
 * base oobe manager
 */
export abstract class BaseOobeManager {
  protected context?: ServiceExtensionContext;
  protected spaceNumber: number = ADMIN_USERID;
  protected helper?: dataShare.DataShareHelper;
  protected uri?: string;
  protected pureShowStatus?: string;
  private oobeEvent: OobeActivatedEvent = new OobeActivatedEvent();

  constructor() {
    EvtBus.produceOn(OobeActivatedEvent, this.onProduceOobeEvent.bind(this));
  }

  /**
   * 判断当前是否在OOBE阶段
   *
   * @return {boolean} true-在OOBE阶段；false-不在OOBE阶段
   */
  public isOobeActivated(): boolean {
    log.showInfo('isOobeActivated base');
    return false;
  }

  sessionExceptionCallback = (bundleName: string, moduleName: string, abilityName: string): void => {
    log.showWarn('sessionExceptionCallback is called');
    if (!this.isOobeActivated()) {
      log.showError('sessionExceptionCallback oobe is finished');
      return;
    }
    let isTrustFlag: boolean = sTrustListOobeManager.isTrustlistForWms(bundleName, moduleName, abilityName);
    if (!isTrustFlag) {
      log.showWarn('sessionExceptionCallback ability is not in trust list');
      return;
    }

    // 这里传的persistentId为之前的，避免重新走startupguide生命周期
    log.showWarn('start oobe again');
    this.startOobeAbility();
  };

  /**
   * 结束开机向导
   */
  protected finishOobe(): void {
    log.showWarn('finish oobe');
    SCBSceneSessionManager.getInstance().unRegisterSessionExceptionListener();
    this.setGesture(true);
    this.postOobeEvent();
    this.helper?.off('dataChange', this.uri as string, () => {
      log.showInfo('unregister oobe settings helper');
    });
  }

  /**
   * 拉起OOBE之前
   * 1.白名单是否初始化
   * 2.应用异常监听
   * 3.监听数据库
   */
  protected async beforeStartOobe(): Promise<void> {
    log.showInfo('before start oobe');
    await sTrustListOobeManager.initTrustlist(this.spaceNumber);
    SCBSceneSessionManager.getInstance().registerSessionExceptionListener(this.sessionExceptionCallback);
    this.postOobeEvent();
    log.showInfo('before start oobe end');
  }

  private setGesture(isEnable: boolean): void {
    if (DeviceHelper.isWatch()) {
      // 这里手机和手表的业务逻辑不同，手表oobe需要自己去控制哪个界面可以右滑退出，哪个界面不可以退出，内部消费边缘手势事件，所以不能把边缘手势禁掉。
      return;
    }
    if (!isEnable) {
      // 禁用手势
      scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.OOBE, false, false);
    } else {
      // 启用手势
      scbGestureManager.setGestureNavigationEnable(GestureEnableCaller.OOBE, true, true);
    }
  }

  /**
   * OOBE阶段变化事件生产者
   *
   * @returns OOBE阶段变化事件
   */
  private onProduceOobeEvent(): OobeActivatedEvent {
    return this.oobeEvent;
  }

  /**
   * 发送OOBE阶段变化事件
   */
  private postOobeEvent(): void {
    this.oobeEvent.isActivated = this.isOobeActivated();
    EvtBus.post(OobeActivatedEvent, this.oobeEvent);
  }

  /**
   * 拉起OOBE
   */
  protected async startOobe(): Promise<void> {
    await this.beforeStartOobe();
    log.showInfo('start oobe');
    this.setGesture(false);
    this.startOobeAbility();
  }

  private startOobeAbility(): void {
    // 根据设备类型去区分不同的产品oobeModuleName，后期这里需要重构。
    let oobeModuleName = ExtAppConstants.MODULE_OOBE_PHONE;
    if (DeviceHelper.isPcNot2in1Device()) {
      oobeModuleName = ExtAppConstants.MODULE_OOBE_PC;
    } else if (DeviceHelper.isWatch()) {
      oobeModuleName = ExtAppConstants.MODULE_OOBE_WATCH;
    } else {
      oobeModuleName = ExtAppConstants.MODULE_OOBE_PHONE;
    }
    log.showWarn('start oobe ability');
    StartAbilityUtil.startAbilityFromOther({
      bundleName: ExtAppConstants.PKG_OOBE,
      abilityName: ExtAppConstants.ABILITY_OOBE,
      moduleName: oobeModuleName,
    }, false);
  }

  /**
   * 获取settingData的secure表的uri
   */
  protected async getSecureUri(key: string, spaceNumber?: number): Promise<string> {
    if (!spaceNumber) {
      spaceNumber = await AccountMgr.getCurrentAccountId();
    }
    log.showInfo('getSecureUri spaceNumber: %{public}d key: %{public}s', spaceNumber, key);
    return `datashare:///com.ohos.settingsdata/entry/settingsdata/USER_SETTINGSDATA_SECURE_${spaceNumber}?Proxy=true&key=${key}`;
  }

  /**
   * OOBE是否安装
   */
  protected async isStartupGuideInstalled(): Promise<boolean> {
    let bundleInfo = await commonBundleManager.getBundleInfoByBundleIncludeDisable(ExtAppConstants.PKG_OOBE);
    return bundleInfo ? true : false;
  }

  /**
   * 启用/禁用OOBE的ability
   */
  protected async setOobeMainAbilityEnable(isEnabled: boolean): Promise<void> {
    let ret = await commonBundleManager.setAbilityEnabledByAbilityName(ExtAppConstants.PKG_OOBE, ExtAppConstants.ABILITY_OOBE, isEnabled);
    log.showInfo('set oobe ability enable success: %{public}s', ret);
  }

  /**
   * OOBE是否启用
   */
  protected async isOobeMainAbilityEnable(): Promise<boolean> {
    let abilityInfo = await commonBundleManager.getAbilityInfoOnCurrentUser(ExtAppConstants.PKG_OOBE, ExtAppConstants.ABILITY_OOBE);
    return abilityInfo ? true : false;
  }

  /**
   * 获取版本号
   */
  protected getDisplayVersion(): string {
    let displayVersion: string = '';
    displayVersion = systemParameter.getSync(DISPLAY_VERSION_PARAM, '');
    if (displayVersion) {
      log.showInfo('get displayVersion by const.build.ver.physical is %{public}s', displayVersion);
      return displayVersion;
    }
    log.showInfo('get displayVersion by deviceInfo.displayVersion is %{public}s', deviceInfo.displayVersion);
    return deviceInfo.displayVersion;
  }
}

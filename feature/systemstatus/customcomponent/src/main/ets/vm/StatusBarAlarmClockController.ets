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

import { LogDomain, Logger, SingletonHelper, CommonUtils, CheckEmptyUtils } from '@ohos/basicutils';
import { EvtBus, GlobalContext, PackageCommonEvent, PluginRequestEvent, PluginSlot } from '@ohos/frameworkwrapper';
import { AlarmClockData } from '../common/Constants';
import { BusinessError, commonEventManager, settings } from '@kit.BasicServicesKit';
import { BaseController } from '@ohos/controlcentercommon/Index';
import bundleManager from '@ohos.bundle.bundleManager';

const TAG = 'Model.AlarmClockController';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

const DEFAULT_ALARMING_TIME = '0';

const SETTING_ITEM_NAME_NEAREST_ALARMING_TIME: string = 'nearestAlarmingTime';

const CLOCK_APP_BUNDLE_NAME = 'com.ohos.clock';
export class StatusBarAlarmClockController extends BaseController<AlarmClockData> {
  public static get = SingletonHelper.createFactory(() => new StatusBarAlarmClockController);
  private mAlarmClockData: AlarmClockData = new AlarmClockData();
  private isExistClockApp: boolean = true;

  constructor() {
    super();
    this.onStart();
  }

  public getData() {
    return this.mAlarmClockData;
  }

  isAvailable(): boolean {
    return true;
  }

  getSbPluginSlot(): string {
    return PluginSlot.SLOT_STATUS_ALARM_CLOCK;
  }

  onStart(): void {
    log.showInfo(TAG, 'AlarmClockController onStart');
    super.onStart();
    this.isExistClockApp = this.getClockApplicationExistFlag();
    this.registerAlarmClockObserver();
    EvtBus.on(PackageCommonEvent, this.onPackageChange);
    this.onNearestAlarmingTimeChange();
  }

  onStop(): void {
    log.showInfo(TAG, 'AlarmClockController onStop');
    super.onStop();
    EvtBus.off(PackageCommonEvent, this.onPackageChange);
    this.unRegisterAlarmClockObserver();
  }

  private onPackageChange = (event: PackageCommonEvent) => {
    if (CommonUtils.isInvalid(event?.event)) {
      log.showWarn(TAG, 'handlePackageEvent package event unknown');
      return;
    }
    log.showInfo(TAG, `handlePackageEvent event = ${event.event} bundleName: ${event.bundleName} ` +
      `isModuleUpdate: ${event.isModuleUpdate} bundleType: ${event.bundleType} ` +
      `atomicServiceModuleUpgrade: ${event.atomicServiceModuleUpgrade} appIndex: ${event.appIndex}`);
    if (event.bundleName !== CLOCK_APP_BUNDLE_NAME) {
      return;
    }
    switch (event.event) {
      case commonEventManager.Support.COMMON_EVENT_PACKAGE_ADDED:
        this.isExistClockApp = true;
        this.onNearestAlarmingTimeChange();
        break;
      case commonEventManager.Support.COMMON_EVENT_PACKAGE_REMOVED:
        this.isExistClockApp = false;
        this.onNearestAlarmingTimeChange();
        break;
      case commonEventManager.Support.COMMON_EVENT_PACKAGE_CHANGED:
        break;
      default:
        log.showInfo(TAG, 'handlePackageEvent unknown package event ' + event.event);
        break;
    }
  };

  private getClockApplicationExistFlag(): boolean {
    let bundleInfo: bundleManager.BundleInfo;
    const bundleFlag = bundleManager.BundleFlag.GET_BUNDLE_INFO_DEFAULT;
    const bundleName = CLOCK_APP_BUNDLE_NAME;
    try {
      bundleInfo = bundleManager.getBundleInfoSync(bundleName, bundleFlag);
      if (CheckEmptyUtils.isEmpty(bundleInfo)) {
        log.showError(TAG, 'getBundleInfoSync bundleInfo is empty');
        return false;
      }
    } catch (err) {
      let code = (err as BusinessError)?.code;
      log.showError(TAG, `getBundleInfoSync failed error code: ${code}`);
      return false;
    }
    return true;
  }

  private registerAlarmClockObserver(): void {
    try {
      let context = GlobalContext.getContext();
      settings.registerKeyObserver(context, SETTING_ITEM_NAME_NEAREST_ALARMING_TIME, settings.domainName.USER_PROPERTY,
        (err, val) => {
          if (err !== undefined) {
            log.showError(TAG, `registerAlarmClockObserver error code:${err.code}, message:${err.message}`);
          }
          log.showInfo(TAG, 'onNearestAlarmingTimeChange');
          this.onNearestAlarmingTimeChange();
        });
    } catch (err) {
      log.showError(TAG, `registerAlarmClockObserver error code:${err?.code}, message:${err?.message}`);
    }
  }

  private unRegisterAlarmClockObserver(): void {
    let result: boolean = false;
    try {
      result = settings.unregisterKeyObserver(GlobalContext.getContext()
        , SETTING_ITEM_NAME_NEAREST_ALARMING_TIME, settings.domainName.USER_PROPERTY);
    } catch (err) {
      log.showError(TAG, `unRegisterAlarmClockObserver, try err code: ${err?.code}, msg: ${err?.message}`);
    }
    log.showInfo(TAG, `unRegisterAlarmClockObserver, unregister result: ${result}`);
  }

  private onNearestAlarmingTimeChange(): void {
    let nearestAlarmingTime =
      settings.getValueSync(GlobalContext.getContext(), SETTING_ITEM_NAME_NEAREST_ALARMING_TIME, DEFAULT_ALARMING_TIME,
        settings.domainName.USER_PROPERTY);
    let isEnable = (nearestAlarmingTime !== DEFAULT_ALARMING_TIME) && this.isExistClockApp;
    log.showInfo(TAG, `onNearestAlarmingTimeChange nearestAlarmingTime: ${nearestAlarmingTime} isExistClockApp ${this.isExistClockApp}.`)
    this.mAlarmClockData.isAlarmClockExist = isEnable;
    this.handleStatusBarState(isEnable);
  }

  private handleStatusBarState(newState: boolean): void {
    let oldState = this.sbPluginRequest.isVisible();
    log.showInfo(TAG, `alarm clock status bar status change, newState: ${newState}, oldState: ${oldState}`);
    if (oldState !== newState) {
      this.sbPluginRequest.setIsVisible(newState);
      EvtBus.post(PluginRequestEvent, this.sbPluginRequest);
    }
  }
}
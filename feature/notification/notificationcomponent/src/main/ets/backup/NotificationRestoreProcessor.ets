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

import { LogHelper, LogDomain, ArrayUtils } from '@ohos/basicutils';
import { SettingsConstants } from '@ohos/commonconstants';
import NtfManger from '@ohos.notificationManager';
import { NotificationBackupEntity } from '@ohos/systemuicommon/src/main/ets/model/NotificationBackupEntity';
import {
  NotificationConfigEntity
} from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEntity';
import {
  NtfReminderConfig
} from '@ohos/systemuicommon/src/main/ets/model/NtfRemindFlags';
import {
  SystemuiConstants
} from '@ohos/systemuicommon/src/main/ets/constants/SystemuiConstants';
import notificationManager from '@ohos.notificationManager';
import { notificationConfigManager } from '../manager/NotificationConfigManager';
import { BusinessError } from '@kit.BasicServicesKit';
import { bundleManager } from '@kit.AbilityKit';
import {
  AppFoundationServiceExtensionManager
} from '@ohos/launchercommon/src/main/ets/manager/AppFoundationServiceExtensionManager';
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppItemInfo';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';
import { NotificationExceptionCode } from '../maintenance/NotificationExceptionCode';
import { NotificationSysEventReporter } from '@ohos/systemuicommon';
import { NotificationSwitchRecoverParams } from '@ohos/systemuicommon/src/main/ets/utils/NotificationSysEventReporter';

const TAG: string = 'NotificationAppBackupProcess';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const DEFAULT_USER_ID: number = 100;

export class NotificationAppBackupProcess {
  private originAppSettings: NotificationConfigEntity[] = [];
  private backupData: NotificationBackupEntity[] = [];
  private userAppKeys: Map<string, number> = new Map();
  private userReportDatas: Map<string, NotificationSwitchRecoverParams> = new Map();
  private userId: number = DEFAULT_USER_ID;

  public async onRestoreApp(map: Map<string, string[]>, userId: number, isDelay: boolean,
    totalAppArr: AppItemInfo[]): Promise<void> {
    log.showInfo(`backup onRestoreApp, ${isDelay}`);
    if (isDelay) {
      await this.initDelayConfigData(map, userId);
    } else {
      await this.initConfigData(map, userId, totalAppArr);
    }
    await this.restoreAll(map);
  }

  private async initAppRelation(pkgNames: string[], map: Map<string, string[]>,
    totalAppArr: AppItemInfo[]): Promise<void> {
    let appServiceManager: AppFoundationServiceExtensionManager = AppFoundationServiceExtensionManager.getInstance();
    log.showInfo(`initAppRelation, ${pkgNames}`);
    await appServiceManager.queryAppMappingInfo(pkgNames);
    let relationMap: Map<string, string[]> = appServiceManager.getohosAppMap();
    relationMap?.forEach((value, key) => {
      if (!map.has(key) && totalAppArr.find((app) => value?.includes(app.bundleName))) {
        log.showInfo(`set appRelation, ${key}, ${value}`);
        map.set(key, value);
      }
    });
  }


  private async updateBundleInfo(bundle: string): Promise<void> {
    log.showInfo(`updateBundleInfo:  ${bundle}`);
    try {
      let bundleInfo =
        await bundleManager.getApplicationInfo(bundle, bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT,
          this.userId);
      this.userAppKeys.set(bundleInfo.name ?? '', bundleInfo.uid);
    } catch (error) {
      LogWithHa.error(log, `getApplicationInfo failed, ${bundle}, ${error?.message}`,
        NotificationExceptionCode.UPDATE_APP_INFO_FAIL, error, bundle);
    }
  }

  private async loadBundleInfo(): Promise<void> {
    try {
      let bundleInfoList =
        await bundleManager.getAllApplicationInfo(bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT,
          this.userId);
      for (let value of bundleInfoList) {
        log.showInfo(`loadBundleInfo, ${value.name}, ${value.uid}`);
        this.userAppKeys.set(value.name ?? '', value.uid);
      }
    } catch (error) {
      LogWithHa.error(log, `getAllApplicationInfo failed, ${error?.message}`, NotificationExceptionCode.LOAD_APP_INFO_FAIL,
        error);
    }
  }

  private async initConfigData(map: Map<string, string[]>, userId: number, totalAppArr: AppItemInfo[]): Promise<void> {
    log.showInfo(`backup init`);
    this.userId = userId;
    this.backupData = await NotificationBackupEntity.queryListByProps({});
    this.originAppSettings = await NotificationConfigEntity.queryListByProps({});
    await this.initAppRelation(this.backupData.filter((data) => data.isPkgName && !map.has(data.appName)).
    map((data) => data.appName), map, totalAppArr);
    await this.loadBundleInfo();
  }

  private async initDelayConfigData(map: Map<string, string[]>, userId: number): Promise<void> {
    log.showInfo(`backup delay init`);
    this.userId = userId;
    this.originAppSettings = await NotificationConfigEntity.queryListByProps({});
    for (const keys of map.values()) {
      for (const key of keys) {
        await this.updateBundleInfo(key);
      }
    }
    const predicates = NotificationBackupEntity.getPredicates();
    predicates.inCondition({ appName: Array.from(map.keys())});
    this.backupData = await NotificationBackupEntity.queryList(predicates);
  }

  private initReportParam(param: NotificationSwitchRecoverParams, entry: NotificationBackupEntity, appName: string,
    uid?: number): void {
    if (appName) {
      param.BUNDLE_NAME = appName;
    }
    if (uid) {
      param.UID = uid;
    }
    if (entry.notificationEnable !== undefined) {
      param.ENABLE = entry.notificationEnable ? 1 : 0;
    }
    if (entry.showBadge !== undefined) {
      param.BADGE = entry.showBadge ? 1 : 0;
    }
    if (entry.isPinTop !== undefined) {
      param.PINTOP = entry.isPinTop ? 1 : 0;
    }
  }

  private async restoreAll(map: Map<string, string[]>): Promise<void> {
    log.showInfo(`restoreAll, size: ${this.backupData.length}, map size : ${map.size}`);
    for (const entry of this.backupData) {
      let bundleNames = entry.isPkgName ? map.get(entry.appName) : [entry.appName];
      if (!bundleNames || bundleNames.length === 0) {
        log.showInfo(`no bundleName, ${entry.appName}`);
        continue;
      }
      for (const bundleName of bundleNames) {
        let reportParam = this.userReportDatas.get(bundleName);
        if (!reportParam) {
          reportParam = new NotificationSwitchRecoverParams();
          this.userReportDatas.set(bundleName ?? '', reportParam);
        }
        let uid = this.userAppKeys.get(bundleName);
        this.initReportParam(reportParam, entry, bundleName, uid);
        reportParam.ENABLE_RES = await this.setEnable(bundleName, entry) ? 0 : 1;
        reportParam.SLOT_FLAGS_RES = await this.setRemindStyle(bundleName, entry) ? 0 : 1;
        reportParam.BADGE_RES = await this.setBadge(bundleName, entry) ? 0 : 1;
      }
    }
    await this.restorePinTop(map);
    this.report();
  }

  private async restorePinTop(map: Map<string, string[]>): Promise<void> {
    let needCancelPinTop: string[] = [];
    let needSetPinTop: string[] = [];
    for (const entry of this.backupData) {
      let bundleNames = entry?.isPkgName ? map.get(entry.appName) : [entry.appName];
      if (!bundleNames) {
        continue;
      }
      for (const bundleName of bundleNames) {
        if (entry.isPinTop) {
          needSetPinTop.push(bundleName);
          continue;
        }
        needCancelPinTop.push(bundleName);
      }
    }
    await this.setPinTop(needCancelPinTop, needSetPinTop);
  }

  private async setPinTop(needCancelPinTop: string[], needSetPinTop: string[]): Promise<void> {
    let appPinTopConfigList = this.originAppSettings.filter((value) => value.pinTop).map((value) => value.bundle);
    let appConfigList = this.originAppSettings.map((value) => value.bundle);
    log.showInfo(`syncPinTopSettings,appConfigList: ${appConfigList.length}`);
    let needCancelPinTopNum = await this.cancelTinTop(needCancelPinTop, appPinTopConfigList, appConfigList);
    if (needSetPinTop.length > 0) {
      let needSyncPinTopSettings = needSetPinTop.filter((value) => ArrayUtils.contains(appConfigList, value) &&
        !ArrayUtils.contains(appPinTopConfigList, value));
      let needPinTopNum =
        Math.min(Math.max(SystemuiConstants.PIN_TOP_APPS_LIMIT - appPinTopConfigList.length + needCancelPinTopNum, 0),
          SystemuiConstants.PIN_TOP_APPS_LIMIT);
      log.showInfo(`needSyncPinTopSettings size : ${needSyncPinTopSettings.length} ,appPinTopConfigList.length : ${
      appPinTopConfigList.length}, needCancelPinTopNum: ${needCancelPinTopNum}`);
      for (let index = 0; needPinTopNum > 0 && index < needSyncPinTopSettings.length; index++) {
        let bundleName = needSyncPinTopSettings[index];
        try {
          let isEnable = await NtfManger.isNotificationEnabled({
            bundle: bundleName,
          });
          log.showInfo(`isNotificationEnabled: ${isEnable}, bundleName: ${bundleName}`);
          needPinTopNum -= await this.setPinTopWithResult(isEnable, bundleName);
        } catch (error) {
          log.showError(`set pintop error, ${(error as BusinessError)?.code}`);
        }
      }
    }
  }

  private async setPinTopWithResult(isEnable: boolean, bundleName: string): Promise<number> {
    if (isEnable) {
      let pinRet = await this.setPinTopWithUid(bundleName, true);
      return pinRet ? 1 : 0;
    }
    return 0;
  }

  private async cancelTinTop(needCancelPinTop: string[], appPinTopConfigList: string[],
    appConfigList: string[]): Promise<number> {
    let needCancelPinTopNum = 0;
    if (needCancelPinTop.length > 0) {
      let needSyncCancelPinTopSettings = needCancelPinTop.filter((value) => ArrayUtils.contains(appConfigList, value) &&
      ArrayUtils.contains(appPinTopConfigList, value));
      needCancelPinTopNum = needSyncCancelPinTopSettings.length;
      for (const needSyncCancelPinTopSetting of needSyncCancelPinTopSettings) {
        await this.setPinTopWithUid(needSyncCancelPinTopSetting, false);
      }
    }
    return needCancelPinTopNum;
  }

  private async setPinTopWithUid(bundleName: string, enable: boolean): Promise<boolean> {
    let valueIndex = this.originAppSettings.findIndex((value) => value.bundle === bundleName);
    if (valueIndex === -1) {
      log.showError(`no config exist, bundleName: ${bundleName}`);
      return new Promise((resolve) => {
        resolve(false);
      });
    }
    let uid = this.originAppSettings[valueIndex]?.uid;
    log.showInfo(`get appInfo , bundleName is ${bundleName}, uid is ${uid}`);
    try {
      let success: boolean = await notificationConfigManager.setPinTopState(uid, enable);
      log.showInfo(`setPinTopState bundleName is ${bundleName}, enable : ${enable}, ret:${success}`);
      return new Promise((resolve) => {
        resolve(success);
      });
    } catch (err) {
      LogWithHa.error(log, `setPinTopState bundleName is ${bundleName}, enable : ${enable}, error:${err.message}`,
        NotificationExceptionCode.RESTORE_PIN_TOP_FAIL, err, bundleName);
      return new Promise((resolve) => {
        resolve(false);
      });
    }
  }

  private async setRemindStyle(pkgName: string, data: NotificationBackupEntity, uid?:number): Promise<boolean> {
    if (data?.bannerNotifyEnable === undefined && data?.lockNotifyEnable === undefined &&
      data?.soundEnable === undefined && data?.vibrationEnable === undefined) {
      return false;
    }
    try {
      await this.setRemindStyleIfNeed(data, pkgName);
    } catch (error) {
      LogWithHa.error(log, `query enable fail , bundle: ${pkgName}`, NotificationExceptionCode.RESTORE_STYLE_FAIL,
        error, pkgName);
      return false;
    }
    return true;
  }

  private async setRemindStyleIfNeed(enableSettingInfo: NotificationBackupEntity, bundleName: string):
    Promise<void> {
    let uid = this.userAppKeys.get(bundleName);
    if (!uid) {
      log.showError(`query uid failed , bundleName: ${bundleName}`);
      return;
    }
    let config = new NtfReminderConfig(0);
    config.setOnScreen(true);
    config.setStatusBarIcon(true);
    config.setBanner(enableSettingInfo.bannerNotifyEnable === '1');
    config.setLockScreen(enableSettingInfo.lockNotifyEnable === '1');
    config.setSound(parseInt(enableSettingInfo.soundEnable) === SettingsConstants.SWITCH_OPEN);
    config.setVibration(parseInt(enableSettingInfo.vibrationEnable) === SettingsConstants.SWITCH_OPEN);
    log.showInfo(`setRemindStyleIfNeed, bundleName: ${bundleName}, uid: ${uid}, config: ${config.flags}`);
    let reportParam = this.userReportDatas.get(bundleName);
    if (reportParam) {
      reportParam.SLOT_FLAGS = config.flags;
    }
    await this.setSlotFlags(bundleName, uid, config.flags);
  }

  private async setSlotFlags(bundleName: string, uid: number, slotFlags: number): Promise<void> {
    try {
      log.showInfo('SetSlotFlags to [%{public}d] start.', slotFlags);
      let bundle: notificationManager.BundleOption = {
        bundle: bundleName,
        uid: uid
      };
      await notificationManager.setSlotFlagsByBundle(bundle, slotFlags);
      log.showInfo('SetSlotFlags to [%{public}d] succeed', slotFlags);
      return Promise.resolve();
    } catch (e) {
      LogWithHa.error(log, `SetSlotFlags to ${slotFlags} error by ${e.code}`,
        NotificationExceptionCode.RESTORE_FLAG_FAIL, e, bundleName);
      return Promise.reject(e);
    }
  };

  private async setBadge(pkgName: string, data: NotificationBackupEntity, uid?:number): Promise<boolean> {
    if (data?.showBadge === undefined) {
      return false;
    }
    log.showInfo(`setBadge, bundleName: ${pkgName}, enable: ${data.showBadge}`);
    uid = uid ?? this.userAppKeys.get(pkgName);
    try {
      await notificationManager.displayBadge({
        bundle: pkgName,
        uid: uid,
      }, data.showBadge);
    } catch (error) {
      LogWithHa.error(log, `setBadge fail , bundle: ${pkgName},enable: ${data.showBadge}, error: ${error?.message}`,
        NotificationExceptionCode.RESTORE_BADGE_FAIL, error, pkgName);
      return false;
    }
    return true;
  }

  private async setEnable(pkgName: string, data: NotificationBackupEntity, uid?:number): Promise<boolean> {
    if (data?.notificationEnable === undefined) {
      return false;
    }
    log.showInfo(`setEnable, bundle: ${pkgName}, enable: ${data.notificationEnable}, uid ${uid}`);
    try {
      let bundle: notificationManager.BundleOption = {
        bundle: pkgName,
      };
      if (uid) {
        bundle.uid = uid;
      }
      await NtfManger.setNotificationEnable(bundle, data.notificationEnable);
    } catch (error) {
      LogWithHa.error(log, `enable fail , bundle: ${pkgName}, error: ${error?.message}`,
        NotificationExceptionCode.RESTORE_ENABLE_FAIL, error, pkgName);
      return false;
    }
    return true;
  }

  private report(): void {
    this.userReportDatas.forEach((value, key) => {
      NotificationSysEventReporter.ntfSwitchRecover(value, false);
      log.showInfo(`NotificationSysEventReporter: ${JSON.stringify(value)}`);
    });
  }
}
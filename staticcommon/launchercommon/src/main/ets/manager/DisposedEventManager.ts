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
import type ctx from '@ohos.app.ability.common';
import {
  CommonEvent,
  DisposedRuleAddEvent,
  DisposedRuleDeleteEvent,
  UpdateMigrateStatusChangeEvent
} from '@ohos/frameworkwrapper/src/main/ets/eventbus/events/CommonEvents';
import {
  LogDomain,
  LogHelper,
  CheckEmptyUtils,
  CommonUtils
} from '@ohos/basicutils/src/main/ets/TsIndex';
import { EvtBus, GlobalContext, } from '@ohos/frameworkwrapper';
import { NumberConstants } from '@ohos/commonconstants';
import { common } from '@kit.AbilityKit';
import { AppToHapMappingManager } from '../base/AppToHapMappingManager';
import installer from '@ohos.bundle.installer';
import { preferences } from '@kit.ArkData';
// import migrate from '@ohos.migrate';
// import bmsBrokerAdapter from '@hms.virtService.bmsBrokerAdapter';
import { BusinessError } from '@kit.BasicServicesKit';
import bundleManager from '@ohos.bundle.bundleManager';
import { CommonConstants, GridLayoutItemInfo, LaunchLayoutCacheManager } from '../TsIndex';

const TAG = 'DisposedEventManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const INT_TYPE: string = '5';
const STRING_TYPE: string = '9';
const EXTERNAL_CODE: string = '1';
const TASK_CONTEXT: string = '{\"backup\":1}';
const RGM_TASK_NOT_EXISTS_CODE: number = 1;

/**
 * DisposedEventManager
 *
 * @since 2024-07-26
 */
export class DisposedEventManager {
  private static sInstance: DisposedEventManager;
  private ruledBundleNamesMap: Map<string, string> = new Map();
  private preferences: preferences.Preferences | null = null;
  private preferencesFileName: string = 'eventManagerFile';
  private migrationSuccess: number = 22;
  private migrationFail: number = 23;
  private installedBundleNamesMap: Map<string, string> = new Map();

  private constructor() {
    this.init();
  };

  private init(): void {
    let options: preferences.Options = { name: this.preferencesFileName };
    try {
      this.preferences = preferences.getPreferencesSync(GlobalContext.getInstance()
        .getObject('desktopContext') as common.ApplicationContext, options);
    } catch (error) {
      log.showError('getPreferencesSync with error %{public}s', error.message);
    }
    if (this.preferences == null) {
      return;
    }
    let allKeys: string[] = Object.keys(this.preferences?.getAllSync());
    if (CheckEmptyUtils.isEmptyArr(allKeys)) {
      return;
    }
    allKeys.forEach(bundle => {
      this.ruledBundleNamesMap.set(bundle, this.preferences?.getSync(bundle, '') as string);
    });
  }

  public static getInstance(): DisposedEventManager {
    if (!DisposedEventManager.sInstance) {
      DisposedEventManager.sInstance = new DisposedEventManager();
    }
    return DisposedEventManager.sInstance;
  }

  public async initEvent(): Promise<void> {
    log.showInfo('initEvent');
    EvtBus.on(DisposedRuleAddEvent, (event: CommonEvent) => this.handleDisposedRuleEvent(event));
    EvtBus.on(DisposedRuleDeleteEvent, (event: CommonEvent) => this.handleDisposedRuleEvent(event));
    EvtBus.on(UpdateMigrateStatusChangeEvent, (event: CommonEvent) => this.handleDisposedRuleEvent(event));

    let completedMigrationBundle: string[] = [];

    // for (let bundleName of this.ruledBundleNamesMap.keys()) {
    //   await migrate.getMigrator().getHapMigrationTaskStatus(bundleName).then(
    //     (reserveMigrationStatus: migrate.ReserveMigrationStatus) => {
    //     log.showInfo('getHapMigrationTaskStatus code : %{public}d bundleName : %{public}s',
    //       reserveMigrationStatus.errorInfo?.code, bundleName);
    //     // 请求未发现任务，删除处置中的应用
    //     if (reserveMigrationStatus.errorInfo?.code === RGM_TASK_NOT_EXISTS_CODE) {
    //       completedMigrationBundle.push(bundleName);
    //       return;
    //     }
    //     if (reserveMigrationStatus.errorInfo?.code === NumberConstants.CONSTANT_NUMBER_ZERO &&
    //       (reserveMigrationStatus.status === this.migrationSuccess ||
    //         reserveMigrationStatus.status === this.migrationFail)) {
    //       log.showInfo('getHapMigrationTaskStatus reserveMigrationStatus: ' + bundleName);
    //       completedMigrationBundle.push(bundleName);
    //     }
    //   }).catch((err: Error) => {
    //     log.info('getHapMigrationTaskStatus reserveMigrationStatus error' + err);
    //   });
    // }
    completedMigrationBundle.forEach((bundleName) => {
      let packageName: string | undefined = this.ruledBundleNamesMap.get(bundleName);
      if (packageName) {
        installer.getBundleInstallerSync().uninstall(packageName);
      }
      this.ruledBundleNamesMap.delete(bundleName);
      this.preferences?.delete(bundleName);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.
      eventHub.emit(`disposedRuleEvent${bundleName}name`, 0);
    });
    this.preferences?.flush();
  }

  private handleDisposedRuleEvent(event: CommonEvent): void {
    log.showInfo('handleDisposedRuleEvent %{public}s', event.event);
    switch (event.event) {
      case DisposedRuleAddEvent.DISPOSED_RULE_ADD_EVENT:
        this.setDisposedStatusAndMigration(event);
        break;
      case DisposedRuleDeleteEvent.DISPOSED_RULE_DELETE_EVENT:
        this.setAppNameToNormal(event);
        break;
      case UpdateMigrateStatusChangeEvent.UPDATE_MIGRATE_STATUS_CHANGE_EVENT:
        this.uninstallPackage(event);
        break;
      default:
        break;
    }
  }

  private setAppNameToNormal(event: CommonEvent): void {
    let appId: string = event.parameters?.appId ?? '';
    let hmBundleName: string = appId.substring(0, appId.indexOf('_'));
    if (CheckEmptyUtils.isEmpty(hmBundleName)) {
      log.error('update migrate status change event bundleName is undefined');
      return;
    }
    this.deleteDisposedCache(hmBundleName);
  }

  private deleteDisposedCache(hmBundleName: string): void {
    if (this.ruledBundleNamesMap.has(hmBundleName)) {
      this.ruledBundleNamesMap.delete(hmBundleName);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.
      eventHub.emit(`disposedRuleEvent${hmBundleName}name`, 0);
      this.preferences?.delete(hmBundleName);
      this.preferences?.flush();
    }
  }

  private setDisposedStatusAndMigration(event: CommonEvent): void {
    try {
      let want = CommonUtils.jsonStrToMap(event.data).get('want') as string;
      if (CheckEmptyUtils.isEmpty(want)) {
        log.error('disposed rule add event want is undefined');
        return;
      }
      let parameters: string = CommonUtils.jsonStrToMap(want).get('parameters') as string;
      let map: Map<string, Record<string, Object>> = CommonUtils.jsonStrToMapRecord(parameters);
      let code: string = map.get('APPGALLERY_APP_STATUS_EXTERNAL_CODE')?.[INT_TYPE] as string;
      let bundleName: string = map.get('KEY_DISPOSED_BUNDLE_NAME')?.[STRING_TYPE] as string;
      let packageName = AppToHapMappingManager.getInstance().getPackageName(bundleName);
      log.showInfo('setDisposedStatusAndMigration: external_code is ' + code);
      log.showInfo('setDisposedStatusAndMigration: bundleName is ' + bundleName);

      if (code === EXTERNAL_CODE && !CheckEmptyUtils.isEmpty(packageName) && !CheckEmptyUtils.isEmpty(bundleName)) {
        let gridLayoutItemInfo: GridLayoutItemInfo[] =
          LaunchLayoutCacheManager.getInstance().getAllSameBundleNameAppItem(bundleName);
        if (CheckEmptyUtils.isEmptyArr(gridLayoutItemInfo)) {
          log.showInfo(`this grid Layout itemInfo is empty.`);
          return;
        }
        let mainAppItem: GridLayoutItemInfo | undefined =
          gridLayoutItemInfo.find(item => item.bundleName === bundleName &&
            item.appIndex === CommonConstants.MAIN_APP_INDEX);
        if (CheckEmptyUtils.isEmpty(mainAppItem) || !CheckEmptyUtils.isEmpty(mainAppItem?.callerName)) {
          log.showInfo(`this app item is empty or callerName is not default`);
          return;
        }
        this.startMigration(bundleName, packageName);
      }
    } catch (err) {
      log.showError('parse json string error%{public}d:%{public}s', err.code, err.message);
    }
  }

  private startMigration(bundleName: string, packageName: string): void {
    if (this.installedBundleNamesMap.has(bundleName) && !this.ruledBundleNamesMap.has(bundleName)) {
      bundleManager.getBundleInfo(
        packageName,
        bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_SIGNATURE_INFO
      ).then(res => {
        this.ruledBundleNamesMap.set(bundleName, packageName);
        this.preferences?.putSync(bundleName, packageName);
        this.preferences?.flush();
        (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.
        eventHub.emit(`disposedRuleEvent${bundleName}name`, 1);
        log.info('setDisposedStatusAndMigration bundleName: %{public}s, packageName: %{public}s', bundleName,
          packageName);
        // bmsBrokerAdapter.setDisposedStatus(packageName);
        // migrate.getMigrator().startHapMigration(packageName, bundleName, res.signatureInfo?.fingerprint)
        //   .catch((err: BusinessError) => {
        //     this.deleteDisposedCache(bundleName);
        //     log.error('setDisposedStatusAndMigration: err = ' + err?.message);
        //   });
      }).catch((error: Error) => {
        this.deleteDisposedCache(bundleName);
        log.error('getBundleInfo: err = ' + error?.message);
      });
    } else {
      this.installedBundleNamesMap.set(bundleName, packageName);
    }
  }

  private uninstallPackage(event: CommonEvent): void {
    let bundleName: string = event.parameters?.bundleName;
    if (CheckEmptyUtils.isEmpty(bundleName)) {
      log.error('update migrate status change event bundleName is undefined');
      return;
    }
    this.installedBundleNamesMap.delete(bundleName);
    if (this.ruledBundleNamesMap.has(bundleName)) {
      this.ruledBundleNamesMap.delete(bundleName);
      (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext)?.
      eventHub.emit(`disposedRuleEvent${bundleName}name`, 0);
      this.preferences?.delete(bundleName);
      this.preferences?.flush();
    }
    let packageName = AppToHapMappingManager.getInstance().getPackageName(bundleName);
    if (!CheckEmptyUtils.isEmpty(packageName)) {
      installer.getBundleInstallerSync().uninstall(packageName);
    }
  }

  public getRuledBundleNamesMap(): Map<string, string> {
    return this.ruledBundleNamesMap;
  }

  public handleAppInstalled(event: CommonEvent): void {
    if (event.parameters && event.parameters.taskContext === TASK_CONTEXT) {
      log.showInfo('handleAppInstalled startMigration');
      let bundleName: string = event.parameters.bundleName;
      let packageName: string = AppToHapMappingManager.getInstance().getPackageName(bundleName);
      this.startMigration(bundleName, packageName);
    }
  }
}

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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { GlobalContext } from '@ohos/frameworkwrapper';
import { commonEventManager } from '@kit.BasicServicesKit';
import { CommonEventSubscribeManager } from '@ohos/systemuicommon/src/main/ets/manager/CommonEventSubscribeManager';
import { notificationStore } from '@ohos/systemuicommon/src/main/ets/database/NotificationStore';
import { SystemUICommonUtil } from '@ohos/systemuicommon/src/main/ets/utils/SystemUICommonUtil';
import { SystemuiConstants } from '@ohos/systemuicommon/src/main/ets/constants/SystemuiConstants';
import { NotificationAppBackupProcess } from './NotificationRestoreProcessor';
import { taskpool } from '@kit.ArkTS';
import type abilityCommon from '@ohos.app.ability.common';
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/bean/AppItemInfo';
import { AppModel } from '@ohos/launchercommon/src/main/ets/model/AppModel';
import { transferRelationManager } from '@ohos/launchercommon/src/main/ets/manager/TransferRelationManager';

const TAG: string = 'NotificationRestoreManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const DEFAULT_USER_ID: number = 100;

export class NotificationRestoreManager {
  public static get = SingletonHelper.createFactory(() => new NotificationRestoreManager());
  protected isBackupReady = false;
  protected delayData: DelayedAppParameters[] = [];
  private relationMap: Map<string, string[]> = new Map();
  private subscriberRestore?: commonEventManager.CommonEventSubscriber;
  private subscriberDelayRestore?: commonEventManager.CommonEventSubscriber;
  private userId: number = DEFAULT_USER_ID;
  private runner: taskpool.SequenceRunner = new taskpool.SequenceRunner(taskpool.Priority.LOW);

  public init(): void {
    this.initSysTransfer();
    this.subscribeBackupComplete();
    this.subscriberDelayedRestore();
  }

  public destroy(): void {
    this.unsubscribeBackupComplete();
    this.unsubscribeDelayedRestore();
  }

  private unsubscribeDelayedRestore(): void {
    if (this.subscriberDelayRestore) {
      commonEventManager.unsubscribe(this.subscriberDelayRestore);
      this.subscriberDelayRestore = undefined;
    }
  }

  private async subscriberDelayedRestore(): Promise<void> {
    commonEventManager.createSubscriber(CommonEventSubscribeManager.COMMON_EVENT_RESTORE_START).then((res) => {
      this.subscriberDelayRestore = res;
      commonEventManager.subscribe(this.subscriberDelayRestore, (err, data) => {
        if (err) {
          log.showError(`receive delayed restore err, code: ${err?.code}, messge:${err?.message}`);
          return;
        }
        log.showInfo(`get subscriberDelayedRestore event`);
        this.parseData(data);
      });
    });
  }

  private parseData(data: commonEventManager.CommonEventData): void {
    let bundleInfo: DelayedAppParameters = data.parameters as DelayedAppParameters;
    try {
      if (bundleInfo.userId && bundleInfo.userId !== this.userId) {
        log.showWarn(`event.userId:${bundleInfo.userId} not match curUserId:${this.userId} !`);
        return;
      }
      //不支持分身应用克隆
      if (bundleInfo.index && bundleInfo.index !== 0) {
        log.showInfo(`not support ${bundleInfo.bundleName} ${bundleInfo.index}`);
        return;
      }
      let detail =
        SystemUICommonUtil.safeParseJson<Detail[]>(data.parameters?.detail);
      if (detail) {
        bundleInfo.detail = detail;
      }
      if (bundleInfo.detail) {
        this.startDelayRestore(bundleInfo);
      }
    } catch (err) {
      log.showError(`delayed event parse err:${err.message}`);
    }
  }

  private async startDelayRestore(param: DelayedAppParameters): Promise<void> {
    log.showInfo(`backup onRestoreDelayApp, isReady: ${this.isBackupReady}`);
    if (this.isBackupReady) {
      let relationMap: Map<string, string[]> = new Map();
      this.transDelayToRelationMap(param, relationMap);
      const restoreAppTask: taskpool.Task =
        new taskpool.Task('onRestoreAppTask', onRestoreAppTask, GlobalContext.getContext(), relationMap, this.userId,
          true, AppModel.getInstance().getAppList());
      await this.runner.execute(restoreAppTask);
      return;
    }
    this.delayData.push(param);
  }

  private transDelayToRelationMap(param: DelayedAppParameters, relationMap: Map<string, string[]>): void {
    param?.detail?.[0]?.detail?.forEach((bundle) => {
      if (bundle?.target && bundle?.source) {
        let target = relationMap.get(bundle.source);
        if (!target) {
          target = [];
        }
        if (target.includes(bundle.target)) {
          return;
        }
        target.push(bundle.target);
        relationMap.set(bundle.source, target);
      }
    });
  }

  private initSysTransfer(): void {
    let isLoad = transferRelationManager.getIsLoaded();
    if (!isLoad) {
      transferRelationManager.loadTransferInfos().then(() => {
        log.showInfo(`transfer load complete`);
      });
    }
  }

  private unsubscribeBackupComplete(): void {
    if (this.subscriberRestore) {
      commonEventManager.unsubscribe(this.subscriberRestore);
      this.subscriberRestore = undefined;
    }
  }

  private subscribeBackupComplete(): void {
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [SystemuiConstants.NOTIFICATION_BACK_UP_EVENT],
      publisherBundleName: 'com.ohos.sceneboard',
      publisherPermission: 'ohos.permission.NOTIFICATION_CONTROLLER',
    };
    commonEventManager.createSubscriber(subscribeInfo).then((res) => {
      this.subscriberRestore = res;
      commonEventManager.subscribe(this.subscriberRestore, (err, data) => {
        if (err) {
          log.showError(`subscribeBackupComplete failed, code:${err.code}, message:${err.message}`);
          return;
        }
        log.showInfo(`get subscribeBackupComplete event`);
        // 如何界定上一次恢复已经完成，发两次事件？
        this.onNtfBackup(data?.data === 'START');
      });
    });
  }

  private async onNtfBackup(isStart: boolean): Promise<void> {
    if (isStart) {
      await this.resetBackupData();
    } else {
      await this.initBackupData();
      this.transAllToRelationMap();
      const restoreAppTask: taskpool.Task =
        new taskpool.Task('onRestoreAppTask', onRestoreAppTask, GlobalContext.getContext(), this.relationMap,
          this.userId, false, AppModel.getInstance().getAppList());
      await this.runner.execute(restoreAppTask);
    }
  }

  private transAllToRelationMap(): void {
    log.showInfo(`transAllToRelationMap, ${transferRelationManager.getTransInfos().size}`);
    transferRelationManager.getTransInfos().forEach((value, key) => {
      value.forEach((model) => {
        if (!model?.getTargetBundleName()) {
          return;
        }
        let target = this.relationMap.get(key);
        if (!target) {
          target = [];
        }
        if (target.includes(model.getTargetBundleName())) {
          return;
        }
        target.push(model.getTargetBundleName());
        this.relationMap.set(key, target);
      });
    });
    this.delayData.forEach((param) => this.transDelayToRelationMap(param, this.relationMap));
  }

  private async resetBackupData(): Promise<void> {
    log.showInfo(`backup reset`);
    this.isBackupReady = false;
    this.delayData = [];
    this.relationMap.clear();
  }

  private async initBackupData(): Promise<void> {
    log.showInfo(`backup init`);
    this.isBackupReady = true;
  }
}

export class DelayedAppParameters {
  public bundleName?: string;
  public detail?: Detail[];
  public index?: number;
  public moduleName?: string;
  public userId?: number;
}

export class Detail {
  public detail?: BundleReflection[];
}

export class BundleReflection {
  public target?: string;
  public source?: string;
}

export async function onRestoreAppTask(context: abilityCommon.ServiceExtensionContext, map: Map<string, string[]>,
  userId: number, isDelay: boolean, totalAppArr: AppItemInfo[]): Promise<void> {
  'use concurrent';
  await notificationStore.init(context);
  GlobalContext.setContext(context);
  let backupProcess: NotificationAppBackupProcess = new NotificationAppBackupProcess();
  await backupProcess.onRestoreApp(map, userId, isDelay, totalAppArr);
}

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
import { wantAgent } from '@kit.AbilityKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';
import { ClickNotificationMaintenance, ClickRegion, LogWithHa,
  NotificationSysEventReporter, SystemuiConstants } from '@ohos/systemuicommon';
import { Singleton } from '@ohos/systemuicommon/src/main/ets/utils/Singleton';
import { RemindType } from '@ohos/systemuicommon/src/main/ets/maintenance/StatisticsConstants';
import { BaseInfo,
  ClickNotificationErrorCode } from '@ohos/systemuicommon/src/main/ets/maintenance/ClickNotificationMaintenance';
import { NotificationExceptionCode } from '../NotificationExceptionCode';
import { ANSReportMaintenance } from '../ANSReportMaintenance';
import { WantAgentUtil } from '@ohos/systemuicommon/src/main/ets/utils/WantAgentUtil';
import Account from '@ohos.account.osAccount';
import { ADMIN_USERID } from '@ohos/windowscene';

const TAG = 'NotificationMaintenanceEvent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

const ACTION_MAINTENANCE = 'event.notification.maintenance.dot';
const ACTION_PREMISSION = 'ohos.permission.NOTIFICATION_CONTROLLER';

enum EventType {
  ANS = 'ANS',
}

export interface DataProcess {
  bundleName?: string;
  hashCode?: string;
  errorCode?: number;
  subType?: number;
  subCode?: number;
  message?: string;
  id?: number;
  userId?: number;
  transTime?: string;
  startSource?: number;
  event?: number;
  msg: string;
  type: number;
  result: number;
  reason: number;
}

export class NotificationMaintenanceEvent {
  @Singleton.decorate()
  public static get instance(): NotificationMaintenanceEvent { return new NotificationMaintenanceEvent(); }

  // 0: 拉起指定页面成功,2: 拉起指定页面失败，拉起主页成功,3: 用户指定拉起主页成功.
  private static readonly successCode: Set<number> = new Set([0, 2, 3]);

  public actionMaintenance?: DataProcess;
  private stateSubscriber?: commonEventManager.CommonEventSubscriber;

  public async subscribeCastConnectState(): Promise<void> {
    let userId = 0;
    try {
      userId = await Account.getAccountManager().getOsAccountLocalId();
    } catch (e) {
      log.showError('getCurrentAccountId failed');
    }
    if (this.stateSubscriber || userId !== ADMIN_USERID) {
      log.showError(`stateSubscriber is already subscribe ${userId !== ADMIN_USERID}`);
      return;
    }
    // 订阅连接状态事件
    const subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [ACTION_MAINTENANCE],
      publisherPermission: ACTION_PREMISSION
    };

    // 创建订阅者回调
    commonEventManager.createSubscriber(subscribeInfo, (err: BusinessError, data) => {
      if (err) {
        log.showError(`createSubscriber error. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      log.showInfo('createSubscriber Succeeded');
      this.stateSubscriber = data;
      // 订阅公共事件回调
      if (this.stateSubscriber) {
        this.subscribeConnectStatus();
      } else {
        log.showError('subscriber is undefined');
      }
    });
  }

  private subscribeConnectStatus(): void {
    commonEventManager.subscribe(this.stateSubscriber, (err: BusinessError, commonEventData) => {
      if (err) {
        log.showError(`subscribe error. Code is ${err.code}, message is ${err.message}`);
        return;
      }
      log.showInfo(`commonEventData succeed, type: ${commonEventData.data}`);
      if (commonEventData.data === EventType.ANS) {
        ANSReportMaintenance.instance.doReport(commonEventData.parameters?.haInfo);
      } else {
        let info: Object | null = null;
        try {
          info = JSON.parse(commonEventData.parameters?.info);
        } catch (e) {
          log.showError('info Error parsing JSON:', e);
        }
        this.actionMaintenance = info as DataProcess;
        if (!this.actionMaintenance) {
          LogWithHa.error(log, `actionMaintenance is undefined`);
        }
      }
    });
  }

  public unSubscribe(): void {
    if (!this.stateSubscriber) {
      log.showError('unSubscribe but stateSubscriber is undefined');
      return;
    }
    try {
      commonEventManager.unsubscribe(this.stateSubscriber, (err: BusinessError) => {
        if (err) {
          log.showError(`unsubscribe failed, code is ${err.code}, message is ${err.message}`);
        } else {
          this.stateSubscriber = undefined;
          log.showInfo('unsubscribe success');
        }
      });
    } catch (error) {
      this.stateSubscriber = undefined;
      let err: BusinessError = error as BusinessError;
      log.showError(`unsubscribe failed, code is ${err.code}, message is ${err.message}`);
    }
  }
}

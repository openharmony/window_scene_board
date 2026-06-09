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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { MaintenanceRecordType } from '@ohos/systemuiutils/src/main/ets/maintenance/MaintenanceModel';
import { SingletonHelper } from '@ohos/basicutils';
import { NotificationMaintenance, NotificationMaintenanceExt,
  NotificationMaintenanceNtfType } from './NotificationMaintenance';
import { StatisticsMaintenance } from './StatisticsMaintenance';
import { BusinessError } from '@kit.BasicServicesKit';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'RemindNotificationMaintenance');

/**
 * 通知提醒错误码，901-950
 */
export enum RemindNotificationErrorCode {
  PLAY_ERROR = 901,
  AVPLAYER_CALLBACK_ERROR = 902,
  LONG_VIBRATION_ERROR = 903,
  CUSTOM_SOUND_INVALID = 904,
  GET_VOLUME_ERROR = 905,
  GET_AVPLAYER_ERROR = 906,
  SYS_PLAY_ERROR = 907,
  SYS_IS_PLAYING = 908,
  GET_SYS_PLAYER_ERROR = 909,
}

export interface RemindNotificationMaintenanceExt extends NotificationMaintenanceExt {
  toneAllow?: boolean;
  vibrationAllow?: boolean;
  customSound?: boolean;
  ringMode?: number;
  code?: number;
  message?: string;
  type?: number;
}

/**
 * 通知提醒运维打点
 */
export class RemindNotificationMaintenance extends NotificationMaintenance<RemindNotificationMaintenanceExt> {
  public static get = SingletonHelper.createFactory(() => new RemindNotificationMaintenance());

  private constructor() {
    super(MaintenanceRecordType.NOTIFICATION_REMIND);
  }

  public saveInfo(ext: RemindNotificationMaintenanceExt): void {
    this.ext = ext;
  }

  public getInfo(): RemindNotificationMaintenanceExt {
    return this.ext;
  }

  public addError(errorCode: RemindNotificationErrorCode): void {
    this.addErrorCode(errorCode);
  }

  public reportRemind(errorCode?: RemindNotificationErrorCode, e?: BusinessError,
    info?: RemindNotificationMaintenanceExt): void {
    try {
      if (info) {
        this.ext = info;
      }
      if (!this.ext.hashCode && !this.ext.bundleName) {
        log.showWarn('no info to report');
        return;
      }
      if (errorCode) {
        this.addErrorCode(errorCode);
      } else {
        // 无error，调用接口成功统计
        StatisticsMaintenance.get().remindNtf(this.ext.hashCode, this.ext.bundleName,
          this.ext.ntfType === NotificationMaintenanceNtfType.NORMAL ? false : true);
        this.ext = { errorCodes: [] };
        return;
      }
      this.ext.ringMode = StatisticsMaintenance.get().getRingMode();
      this.ext.code = e?.code;
      this.ext.message = e?.message;
      if (this.ext.errorCodes?.length) {
        this.report();
      }
      this.ext = {};
    } catch (e) {
      log.error('report remind error, ' + e);
    }
  }
}
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

import { ReportDomain, HiSysReportEvent } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/HiSysReportEvent';
import { ReportParams } from '@ohos/managementcomponent/src/main/ets/com/ohos/common/ReportParams';

/**
 * 桌面编辑打点上报工具类
 */
export class NotificationSysEventUtil {
  private static readonly NOTIFICATION_UE: HiSysReportEvent | undefined =
  HiSysReportEvent.getHiSysReportEvent(ReportDomain.NOTIFICATION_UE);

  // 设置_通知和状态栏_修改设置
  public static readonly SYS_UI_SETTING_MODIFY: string = 'SYS_UI_SETTING_MODIFY';
  // 设置_通知和状态栏_设置状态
  public static readonly SYS_UI_SETTING_STATUS: string = 'SYS_UI_SETTING_STATUS';

  static async reportSysUiSettingModify(name: string, value: number): Promise<void> {
    let params: SysUiSettingReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: await ReportParams.getVersionCode(),
      NAME: name,
      VALUE: value
    };
    NotificationSysEventUtil.NOTIFICATION_UE?.reportBehavior(NotificationSysEventUtil.SYS_UI_SETTING_MODIFY, params);
  }

  static async reportSysUiSettingStatus(name: string, value: number): Promise<void> {
    let params: SysUiSettingReportParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: await ReportParams.getVersionCode(),
      NAME: name,
      VALUE: value
    };
    NotificationSysEventUtil.NOTIFICATION_UE?.reportBehavior(NotificationSysEventUtil.SYS_UI_SETTING_STATUS, params);
  }
}

export class SysUiSettingReportParams {
  public PNAMEID?: string;
  public PVERSIONID?: string;
  public NAME?: string;
  public VALUE?: number;
}
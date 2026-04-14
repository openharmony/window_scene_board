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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { HiSysReportEvent, ReportDomain } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/HiSysReportEvent';
import { FoldParams, ReportParams } from '@ohos/frameworkwrapper/src/main/ets/hisysevent/ReportParams';
import { ScreenSessionAdapter } from '../adapter/ScreenSessionAdapter';

const TAG = 'HiSysReportBase';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

// 基本参数
export class BaseParams {
  public async init(): Promise<this> {
    this.PNAMEID = ReportParams.PACKAGE_NAME;
    this.PVERSIONID = await ReportParams.getVersionCode();
    return this;
  }

  PNAMEID: string;
  PVERSIONID: string;
  TRACE_ID?: string;
}

// 带折叠的基本参数
export class FoldBaseParams extends BaseParams {
  constructor() {
    super();
    this.FOLDDEVICETYPE = FoldParams.FOLD_DEVICE_TYPE;
    (async (): Promise<void> => {
      this.ISFOLDEXPAND = FoldParams.getDisplayType(await ScreenSessionAdapter.isFoldablePhoneExpandStatus());
    })();
  }
  FOLDDEVICETYPE: number;
  ISFOLDEXPAND: boolean;
}

/**
 * SystemUI hiSysEvent上报基类
 */
export class HiSysReportBase {
  private static readonly NOTIFICATION_UE: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(ReportDomain.NOTIFICATION_UE);

  public static async reportBehavior(name: string, params: BaseParams): Promise<void> {
    HiSysReportBase.NOTIFICATION_UE.reportBehavior(name, params);
  }

  public static async reportStatistic(name: string, params: BaseParams): Promise<void> {
    HiSysReportBase.NOTIFICATION_UE.reportStatistic(name, params);
  }

  public static async reportFault(name: string, params: Object): Promise<void> {
    HiSysReportBase.NOTIFICATION_UE.reportFault(name, params);
  }
}
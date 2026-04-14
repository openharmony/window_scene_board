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

import type { StartAppFromDockParams, StartAppFromPopupParams } from '@ohos/frameworkwrapper';
import { HiSysEventUtil, ReportParams } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import hiSysEvent from '@ohos.hiSysEvent';

const TAG = 'DockHiSysEventMgr';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, 'Dock-' + TAG);

export class DockHiSysEventMgr {
  private static SCENE_BOARD_UE_DOMAIN: string = 'SCENE_BOARD_UE';

  private static readonly START_APP_FROM_DOCK = 'START_APP_FROM_DOCK';

  private static readonly START_APP_FROM_POPUP = 'START_APP_FROM_POPUP';

  /**
   * report when click dock item
   *
   * @param keyName: bundleName_abilityName
   */
  static reportStartAppFromDockData(keyName: string): void {
    const params: StartAppFromDockParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DTYPE: 0,
      KEYNAME: keyName
    };
    HiSysEventUtil.report(DockHiSysEventMgr.SCENE_BOARD_UE_DOMAIN, DockHiSysEventMgr.START_APP_FROM_DOCK,
      hiSysEvent.EventType.BEHAVIOR, params);
  }

  /**
   * report when click dock popup
   *
   * @param bundleName
   */
  static reportStartAppFromPopup(bundleName: string): void {
    const params: StartAppFromPopupParams = {
      PNAMEID: ReportParams.PACKAGE_NAME,
      PVERSIONID: ReportParams.PROCESS_NAME,
      DTYPE: 0,
      KEYNAME: bundleName
    };
    HiSysEventUtil.reportEvent(DockHiSysEventMgr.START_APP_FROM_POPUP, params, hiSysEvent.EventType.BEHAVIOR);
  }
}
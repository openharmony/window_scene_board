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

import hiSysEvent from '@ohos.hiSysEvent';
import { BusinessError } from '@ohos.base';
import { ReportParams } from '@ohos/frameworkwrapper';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'PcCalendarHiEvent';
const DOMAIN_CALENDAR_UE: string = 'CALENDAR_UE'; // UE行为打点
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);


export interface ReportHiEventParams {
  PNAMEID?: string;
  PVERSIONID?: string;
  STATUS?: string;
}

export class ReportUtil {
  // 打开关闭日历二级菜单
  public static readonly calendarPanelChange: string = 'CALENDAR_PANEL_CHANGE';
  // 点击切换日历二级菜单月份
  public static readonly clickCalendarPanelArrow: string = 'CLICK_CALENDAR_PANEL_ARROW';
  // 点击跳转日期和时间设置
  public static readonly clickCalendarToSetting: string = 'CLICK_CALENDAR_TO_SETTING';

  /**
   * 行为数据打点
   *
   * @param eventName 事件名
   * @param eventParams 事件参数
   */
  static reportBehaviorEvent(eventName: string, eventParams?: object): void {
    ReportUtil.reportHiEvent(DOMAIN_CALENDAR_UE, hiSysEvent.EventType.BEHAVIOR, eventName, eventParams || {});
  }

  /**
   * 数据打点
   *
   * @param eventDomain 事件所在域
   * @param eventType 事件类型
   * @param eventName 事件名称
   * @param eventParams 事件参数
   */
  private static async reportHiEvent(eventDomain: string, eventType: number, eventName: string,
    eventParams: ReportHiEventParams): Promise<void> {
    // 拼装默认参数
    eventParams.PNAMEID = ReportParams.PACKAGE_NAME;
    eventParams.PVERSIONID = ReportParams.PACKAGE_NAME;

    hiSysEvent.write({
      domain: eventDomain,
      name: eventName,
      eventType: eventType,
      params: eventParams
    }
    ).then(() => {
      log.showInfo(`Report write ${eventName} success code: ${eventName}`);
    }).catch((err: BusinessError) => {
      log.showError(`Report write ${eventName} failed by error: ${err.message}`);
    });
  }
}
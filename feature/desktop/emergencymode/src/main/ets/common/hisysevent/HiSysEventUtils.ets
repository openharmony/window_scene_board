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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { HiSysReportEvent, ReportParams } from '@ohos/frameworkwrapper';
import { HiSysClickAppParams, HiSysCommonParams, HiSysSaveParams } from './HiSysCommonParams';
import { HiSysEventNameData, HiSysDomain } from './HiSysEventNameData';

const TAG = 'HiSysEventUtils';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
/**
 * emergency thermal dotting tool
 */
export class HiSysEventUtils {
  private static mEmergencyReportEvent: HiSysReportEvent =
    HiSysReportEvent.getHiSysReportEvent(HiSysDomain.EMERGENCY_UE);

  private static mThermalReportEvent: HiSysReportEvent = HiSysReportEvent.getHiSysReportEvent(HiSysDomain.THERMAL_UE);

  /**
   * emergency common dotting
   * @param tagName
   * @param func
   * @param sceneName
   */
  public static reportEmergencyCommonEvent(tagName: string, func: string, eventName: string): void {
    let params: HiSysCommonParams = new HiSysCommonParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.TAG_NAME = tagName;
    params.FUNC = func;
    HiSysEventUtils.mEmergencyReportEvent.reportBehavior(eventName, params);
  }

  /**
   * emergency common dotting
   * @param tagName
   * @param func
   * @param appNum
   * @param appNames
   */
  public static reportEmergencySaveEvent(tagName: string, func: string, appNum: number, appNames: string): void {
    let params: HiSysSaveParams = new HiSysSaveParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.TAG_NAME = tagName;
    params.FUNC = func;
    params.APP_NUM = appNum;
    params.APP_NAMES = appNames;
    HiSysEventUtils.mEmergencyReportEvent.reportBehavior(HiSysEventNameData.EMERGENCY_SAVE, params);
  }

  /**
   *
   * @param tagName
   * @param func
   * @param appName
   */
  public static reportEmergencyClickAppEvent(tagName: string, func: string, appName: string): void {
    let params: HiSysClickAppParams = new HiSysClickAppParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.TAG_NAME = tagName;
    params.FUNC = func;
    params.APP_NAME = appName;
    HiSysEventUtils.mEmergencyReportEvent.reportBehavior(HiSysEventNameData.EMERGENCY_CLICK_APP, params);
  }

  /**
   * thermal common dotting
   * @param tagName
   * @param func
   * @param sceneName
   */
  public static reportThermalCommonEvent(tagName: string, func: string, eventName: string): void {
    let params: HiSysCommonParams = new HiSysCommonParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.TAG_NAME = tagName;
    params.FUNC = func;
    HiSysEventUtils.mThermalReportEvent.reportBehavior(eventName, params);
  }

  /**
   *
   * @param tagName
   * @param func
   * @param appName
   */
  public static reportThermalClickAppEvent(tagName: string, func: string, appName: string): void {
    let params: HiSysClickAppParams = new HiSysClickAppParams();
    params.PNAMEID = ReportParams.PACKAGE_NAME;
    params.PVERSIONID = ReportParams.PROCESS_NAME;
    params.TAG_NAME = tagName;
    params.FUNC = func;
    params.APP_NAME = appName;
    HiSysEventUtils.mThermalReportEvent.reportBehavior(HiSysEventNameData.THERMAL_CLICK_APP, params);
  }

}
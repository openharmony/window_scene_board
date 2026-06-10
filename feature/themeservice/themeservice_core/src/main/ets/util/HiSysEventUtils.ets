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
import { BusinessError, systemDateTime } from '@kit.BasicServicesKit';
import { hiSysEvent } from '@kit.PerformanceAnalysisKit';
import { FileUtil, TsLog } from '@ohos/themeservicebase';
import { reportTimeService } from '../cache/ReportTimeCache';
import { ActivateDurationErr, ActivateTheme, ApplyTheme, InjectThemeSearch } from './HiSysEventParam';

const TAG = 'HiSysEventUtils';
const PNAMEID: string = 'ThemeService';
const FILE_OR_FOLDER_PATH_LIST =
  [`/system/app/SceneBoard/SceneBoard_ThemeServiceCore.hap`, `/data/storage/el1/base/files/theme_service`];
const ONE_DAY_MILL: number = 86400000;
const BYTES_GEAR0: number = 700 * 1024;
const BYTES_GEAR1: number = 1048576;
const BYTES_GEAR2: number = 1048576 * 100;
const BYTES_GEAR3: number = 1048576 * 500;
const BYTES_GEAR4: number = 1048576 * 1024;

export const enum ActivateThemeErrType {
  COPY_FAIL = 0,
  ACTIVATE_FAIL = 1
}

export class HiSysEventUtils {
  public static async reportDataSize(): Promise<void> {
    if (!await HiSysEventUtils.isLastReportMoreThan24Hour()) {
      return;
    }
    let dataSizeArray: number[] = [0, 0]; //目录占用大小和FILE_OR_FOLDER_PATH数组对应
    dataSizeArray[0] = await FileUtil.getFileSize(FILE_OR_FOLDER_PATH_LIST[0]);
    dataSizeArray[1] = await FileUtil.getFileSize(`${FILE_OR_FOLDER_PATH_LIST[1]}/t_pkg`) +
      await FileUtil.getFileSize(`${FILE_OR_FOLDER_PATH_LIST[1]}/t_pre_pkg`) +
      await FileUtil.getFileSize(`${FILE_OR_FOLDER_PATH_LIST[1]}/t_wallpaper`);
    let dataObj: Record<string, Object> = {};
    dataObj['COMPONENT_NAME'] = 'ThemeEngine'; //应用部件名
    dataObj['PARTITION_NAME'] = '/data'; //固定传/data
    dataObj['FILE_OR_FOLDER_PATH'] = FILE_OR_FOLDER_PATH_LIST;
    dataObj['FILE_OR_FOLDER_SIZE'] =
      [HiSysEventUtils.DistinguishingGear(dataSizeArray[0]), HiSysEventUtils.DistinguishingGear(dataSizeArray[1])];
    let sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: 'THEMEEDITOR_UE',
      name: 'USER_DATA_SIZE',
      eventType: hiSysEvent.EventType.STATISTIC,
      params: dataObj,
    };
    reportHiSysEvent(sysEventInfo, () => {
      HiSysEventUtils.saveTimestamp(); //保存当前时间戳到本地preference
    });
  }

  //保存当前时间戳到本地preference
  private static saveTimestamp(): void {
    reportTimeService().update(systemDateTime.getTime());
  }

  private static async isLastReportMoreThan24Hour(): Promise<boolean> {
    const reportTime: Nullable<number> = await reportTimeService().get();
    try {
      if (!reportTime) {
        return true;
      }
      //根据上一次打点时间戳判断是否经过了24小时
      if (systemDateTime.getTime() - reportTime.valueOf() >= ONE_DAY_MILL) {
        return true;
      }
    } catch (error) {
      TsLog.error(TAG, `getTime err: ${error}`);
    }
    return false;
  }

  private static DistinguishingGear(size: number): number {
    if (size < BYTES_GEAR0) {
      return 0;
    } else if (size < BYTES_GEAR1) {
      return 1;
    } else if (size < BYTES_GEAR2) {
      return 2;
    } else if (size < BYTES_GEAR3) {
      return 3;
    } else if (size < BYTES_GEAR4) {
      return 4;
    } else {
      return 5;
    }
  }

  public static reportActivateTheme(themeId: string, themeOrigin: string, type: number, message?: string): void {
    let param: ActivateTheme = {
      ID: themeId,
      ORIGIN: mappingOriginToNum(themeOrigin),
      TYPE: type,
      MESSAGE: message,
    };
    let sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: 'THEME',
      name: 'TS_ACTIVATE_THEME',
      eventType: hiSysEvent.EventType.STATISTIC,
      params: param,
    };
    reportHiSysEvent(sysEventInfo);
  }

  public static reportActivateDuration(themeId: string, themeOrigin: string, startTime: string, duration: string,
    result: number): void {
    let param: ActivateDurationErr = {
      ID: themeId,
      ORIGIN: mappingOriginToNum(themeOrigin),
      START_TIME: startTime,
      DURATION: duration,
      RESULT: result,
    };
    let sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: 'THEME',
      name: 'TS_ACTIVATE_DURATTION_EXCEPTION',
      eventType: hiSysEvent.EventType.STATISTIC,
      params: param,
    };
    reportHiSysEvent(sysEventInfo);
  }

  public static reportThemeSearch(locale: string, status: number, ids: string[], versions: string[]) {
    let id: string = ids.join(',');
    let version: string = versions.join(',');
    let param: InjectThemeSearch = {
      LOCALE: locale,
      STATUS: status,
      ID: id,
      VERSION: version
    };
    let sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: 'THEME',
      name: 'TS_SEARCH_INJECT',
      eventType: hiSysEvent.EventType.STATISTIC,
      params: param,
    };
    reportHiSysEvent(sysEventInfo);
  }

  public static async reportApplyTheme(themeId: string): Promise<void> {
    let applyThemeParam: ApplyTheme = {
      PNAMEID: PNAMEID,
      THEME_TITLE: themeId
    };
    let sysEventInfo: hiSysEvent.SysEventInfo = {
      domain: 'THEMEEDITOR_UE',
      name: 'APPLY_THEME',
      eventType: hiSysEvent.EventType.BEHAVIOR,
      params: applyThemeParam,
    };
    reportHiSysEvent(sysEventInfo);
  }
}

async function reportHiSysEvent(sysEventInfo: hiSysEvent.SysEventInfo,
  callback?: () => Promise<void> | void): Promise<void> {
  try {
    hiSysEvent.write(sysEventInfo)
      .catch(
        (err: BusinessError) => {
          TsLog.error(TAG, `HiSysEventUtil reportHiSysEvent error:${err?.code},  message:${err?.message}`);
        },
      )
      .then(
        async () => {
          TsLog.info(TAG, `HiSysEventUtil reportHiSysEvent ${sysEventInfo.name} success.`);
          if (callback) {
            await callback();
          }
        });
  } catch (err) {
    TsLog.error(TAG, `reportHiSysEvent error:${err}`);
  }
}

function mappingOriginToNum(origin: string): number {
  return origin === 'preset' ? 0 : origin === 'online' ? 2 : 1;
}
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

const TAG = 'Recess';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SCB, TAG);

export enum DayMark {
  NORMAL,
  OFF,
  WORK,
}

export class AllRecess {
  public year: number = 0;
  public version: string = '';
  public workday: number[] = [];
  public freeday: number[] = [];
}

export class RecessInfo {
  public recessYear: number = 0;
  public recessVersion: number = 0;
  public recessWorkDays: number[] = [];
  public recessOffDays: number[] = [];
}

interface Collection {
  length?: number,
  size?: number
}

export class Recess {
  public recessInfo: RecessInfo[] = [];

  /**
   * 解析班休数据
   *
   * @param json 班休数据
   * @param isOldRecess 是否老版班休数据
   *
   * @returns recess 解析后的班休数据
   */
  public static parseDataToRecess(jsonData: string, isOldRecess: boolean): Recess | undefined {
    try {
      if (!jsonData) {
        log.showWarn(`parseDataToRecess jsonData is empty`);
        return undefined;
      }
      const recess = new Recess();
      if (isOldRecess) {
        let recessJson: RecessInfo[] = JSON.parse(jsonData);
        if (Recess.isEmptyArray(recessJson)) {
          log.showWarn(`parseDataToRecess recessJson is empty`);
          return undefined;
        }
        recessJson.forEach((item, index) => {
          recess.recessInfo.push(item);
        });
      } else {
        let recessJson: AllRecess[] = JSON.parse(jsonData);
        if (Recess.isEmptyArray(recessJson)) {
          log.showWarn(`parseDataToRecess recessJson is empty`);
          return undefined;
        }
        recessJson.forEach((item, index) => {
          const value: RecessInfo = recess.formatValues(item);
          recess.recessInfo.push(value);
        });
      }

      return recess;
    } catch (error) {
      log.showError(`parseDataToRecess code: ${error?.code} msg: ${error?.message}`);
      return undefined;
    }
  }

  formatValues(data: AllRecess): RecessInfo {
    const value: RecessInfo = {
      recessYear: data.year,
      recessVersion: data.version ? Number(data.version) : 0,
      recessWorkDays: data.workday,
      recessOffDays: data.freeday
    };
    return value;
  }

  public static isEmptyArray(array: Collection | undefined): boolean {
    if (!array) {
      return true;
    }
    return (array.length !== undefined && array.length <= 0) || array.size !== undefined && array.size <= 0;
  }
}

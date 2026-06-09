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
import {
  LogHelper,
  LogDomain,
  CheckEmptyUtils,
} from '@ohos/basicutils';
import { Alarm } from '@ohos/componenthelper';
import { FormStackModel } from './FormStackModel';
import {
  CardSourceType,
  Extend1Data,
  FormCommonUtil,
  GridLayoutItemInfo,
  WeeklyReporter,
} from '@ohos/launchercommon';
import systemDateTime from '@ohos.systemDateTime';
import { FormStackHiSysEventUtil } from './FormStackHiSysEventUtil';
import type { PeriodicStatisticsEvent } from './FormStackHiSysEventUtil';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'FormStackEventReporter';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.FORM, TAG);
// 一天的毫秒数
const ONE_DAY_MILL: number = 86400000;
// 一个小时的毫秒数
const ONE_HOUR_MILL: number = 3600000;
// 一分钟的毫秒数
const ONE_MINUTE_MILL: number = 60000;
// 一秒的毫秒数
const ONE_SECOND_MILL: number = 1000;
// 每周编号0~6
const ONE_WEEK_DAYS: number = 6;

const AREA_LENGTH: number = 2;

/**
 * 堆叠卡片
 *
 * @since 2023-12-26
 */
export class FormStackEventReporter {
  private static instance: FormStackEventReporter;

  private reportAlarm: Alarm = new Alarm();

  private readonly mFormStackModel: FormStackModel;

  private constructor() {
    this.mFormStackModel = new FormStackModel();
  }

  private weeklyTask = (): Promise<void> => this.reportWeeklyState();

  /**
   * get FormStackEventReporter instance
   *
   * @return FormStackEventReporter instance
   */
  static getInstance(): FormStackEventReporter {
    if (FormStackEventReporter.instance == null) {
      FormStackEventReporter.instance = new FormStackEventReporter();
    }
    return FormStackEventReporter.instance;
  }

  /**
   * 开始计时
   *
   * @returns void
   */
  startReportAlarm(): void {
    WeeklyReporter.getInstance().unRegisterTask(this.weeklyTask);
    WeeklyReporter.getInstance().registerTask(this.weeklyTask);
  }

  private reportWeeklyFormStackState(): void {
    let isOuter: boolean = false;
    this.reportFormStackState(isOuter);
  }

  private reportWeeklyOuterFormStackState(): void {
    let isOuter: boolean = true;
    this.reportFormStackState(isOuter);
  }

  /**
   * 堆叠卡片_堆叠卡片状态点周报（周日0点上报）
   *
   * @returns void
   */
  async reportWeeklyState(): Promise<void> {
    log.showInfo('start report form stack weekly state');
    this.reportWeeklyFormStackState();
  }

  async reportFormStackState(isOuter: boolean): Promise<void> {
    try {
      let formStackList: GridLayoutItemInfo[] = this.mFormStackModel.getFormStackList(isOuter);
      const currentTime: string = systemDateTime.getTime().toString();
      let formStackNum: number = formStackList.length;
      if (formStackList.length === 0) {
        let event: PeriodicStatisticsEvent = {
          totalNum: 0,
          formStackID: '-1',
          area: [-1, -1],
          page: -1,
          column: -1,
          row: -1,
          totalSubCardsNum: 0,
          subCardPackageName: '-1',
          formType: -1,
          formName: '-1',
          serialNum: currentTime,
          presetsNum: 0,
          upgradeNum: 0,
          sourceType: ''
        };
        FormStackHiSysEventUtil.reportStatisticsData([event], isOuter);
        return;
      }
      let events: PeriodicStatisticsEvent[] = [];
      for (let i = 0; i < formStackList.length; i++) {
        this.collectStatisticsData(currentTime, formStackNum, formStackList[i], events);
      }
      FormStackHiSysEventUtil.reportStatisticsData(events, isOuter);
    } catch (error) {
      log.error('reportWeeklyState error', error);
    }
  }

  private collectStatisticsData(currentTime: string, formStackNum: number, formStackItem: GridLayoutItemInfo,
    events: PeriodicStatisticsEvent[]): void {
    if (!formStackItem.area || formStackItem.area.length < AREA_LENGTH) {
      log.showError(`reportWeeklyState, property area is invalid, formStackID=${formStackItem.formStackId}`);
      return;
    }
    if (CheckEmptyUtils.isEmptyArr(formStackItem.layoutInfo?.[0])) {
      log.showError(`reportWeeklyState, layoutInfo is invalid, formStackID=${formStackItem.formStackId}`);
      return;
    }
    let cardItem: GridLayoutItemInfo;
    let migrateCount: number = 0;
    let presetsCount: number = 0;
    if (!formStackItem.layoutInfo) {
      return;
    }

    formStackItem.layoutInfo[0].forEach(item => {
      const sourceType: string = Extend1Data.getCardSourceType(item.extend1);
      if (sourceType === CardSourceType.UPGRADE_MIGRATE) {
        migrateCount++;
      } else if (sourceType === CardSourceType.SYS_PRESETS) {
        presetsCount++;
      } else {}
    });
    for (cardItem of formStackItem.layoutInfo[0]) {
      let event: PeriodicStatisticsEvent = {
        totalNum: formStackNum,
        formStackID: formStackItem.formStackId as string,
        area: formStackItem.area,
        page: formStackItem.page as number,
        column: formStackItem.column as number,
        row: formStackItem.row as number,
        totalSubCardsNum: formStackItem.layoutInfo[0].length,
        subCardPackageName: cardItem.bundleName,
        formType: FormCommonUtil.getFormType(cardItem.gameCardInfo),
        formName: cardItem.cardName as string,
        serialNum: currentTime,
        presetsNum: presetsCount,
        upgradeNum: migrateCount,
        sourceType: Extend1Data.getCardSourceType(cardItem.extend1),
      };
      events.push(event);
    }
    log.showInfo('reportWeeklyState serialNum:%{public}s, FANum:%{public}d, FormStackID:%{public}s',
      currentTime, formStackItem.layoutInfo[0].length, formStackItem.formStackId);
  }
}
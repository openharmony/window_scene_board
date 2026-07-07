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

import { CheckEmptyUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus } from '@ohos/frameworkwrapper';
import { CardItemInfo, PageDesktopModel } from '@ohos/launchercommon';
import { AiSuggestionUtil } from '@ohos/launchercommon/src/main/ets/aisuggestion/AiSuggestionUtil';
import { LauncherExposeEventLogs } from '../bean/LauncherExposeEventLogs';
import { AbilityFormUtil } from '../utils/AbilityFormUtil';
import { VoiceInStackExposeEvent } from '@ohos/launchercommon/src/main/ets/aisuggestion/VoiceInStackExposeEvent';

const TAG: string = 'ExposeEventRecorder';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.AISUGGESTION, TAG);

/**
 * 语音助手建议卡片曝光记录
 *
 * @since 2023-08-11
 */
export class ExposeEventRecorder {
  private static mInstance: ExposeEventRecorder;
  /** 有效曝光时长 */
  private static readonly validExposeDuration: number = 500;
  /** 最大记录条数 */
  private static readonly maxRecordItems: number = 300;
  /** 曝光临时数据 */
  private mExposeEventTemps: LauncherExposeEventLogs[] = [];
  /** 曝光有效数据 */
  private mExposeEventRecords: LauncherExposeEventLogs[] = [];

  private constructor() {
    EvtBus.on(VoiceInStackExposeEvent, (data: VoiceInStackExposeEvent) => {
      this.recordExposeVoiceInStack(data.cardItemList, data.stackPage, data.topCardItem);
    });
  }

  /**
   * 获取单例对象
   *
   * @return 单例
   */
  static getInstance(): ExposeEventRecorder {
    if (ExposeEventRecorder.mInstance == null) {
      ExposeEventRecorder.mInstance = new ExposeEventRecorder();
    }
    return ExposeEventRecorder.mInstance;
  }

  /**
   * 获取曝光数据
   *
   * @returns 曝光数据
   */
  getExposeEventLogs(): LauncherExposeEventLogs[] {
    // 捐赠并清除所有曝光数据
    const length = this.mExposeEventRecords.length;
    log.showDebug(`getExposeEventLogs size = ${length}`);
    return this.mExposeEventRecords.splice(0, length);
  }

  /**
   * 卡片刷新-记录曝光
   *
   * @param info 卡片信息
   */
  recordExposeOnRefresh(cardId: string): void {
    log.showInfo(`recordExposeOnRefresh ${cardId}`);
    if (!cardId) {
      log.showDebug('recordExposeOnRefresh invalid info');
      return;
    }

    if (!AbilityFormUtil.isAbilityFormVisible(cardId) ||
      !this.mExposeEventTemps.find(tempLog => tempLog.formId === cardId)) {
      log.showDebug(`recordExposeOnRefresh ${cardId} is invisible`);
      return;
    }
    this.recordExposeEndByFormId(cardId);
    this.recordExposeStart(new LauncherExposeEventLogs(cardId));
  }

  /**
   * 卡片曝光结束
   *
   * 卡片刷新/重置/移除，结束上一次曝光
   *
   * @param formId 卡片ID
   */
  recordExposeEndByFormId(formId: string): void {
    log.showInfo(`recordExposeEndByFormId ${formId}`);
    let tempIndex = this.mExposeEventTemps.findIndex(tempLog => tempLog.formId === formId);
    if (tempIndex < 0) {
      log.showDebug(`recordExposeEndByFormId ${formId} is not found in temp logs`);
      return;
    }
    this.recordExposeEnd(this.mExposeEventTemps.splice(tempIndex, 1)[0]);
  }

  /**
   * 记录堆叠中的语音助手卡片曝光数据
   *
   * @param stackItemInfo 堆叠信息
   * @param topCardItem 置顶卡片
   */
  private recordExposeVoiceInStack(cardItemList: CardItemInfo[], stackPage: number, topCardItem: CardItemInfo): void {
    if (CheckEmptyUtils.isEmptyArr(cardItemList) || CheckEmptyUtils.isEmpty(topCardItem)) {
      log.showWarn('recordExposeVoiceInStack input params is invalid');
      return;
    }

    const pageIndex: number = PageDesktopModel.getInstance().getPageIndex();
    if (stackPage !== pageIndex) {
      log.showWarn(`recordExposeVoiceInStack formstack is invible,${stackPage}_${pageIndex}`);
      return;
    }

    for (const cardItem of cardItemList) {
      if (!cardItem) {
        log.showWarn('recordExposeVoiceInStack cardItem is invalid');
        continue;
      }
      const isVoiceAbility = AiSuggestionUtil.isVoiceAbilityForm(cardItem.bundleName, cardItem.abilityName);
      if (!isVoiceAbility) {
        continue;
      }
      if (topCardItem.cardId === cardItem.cardId) {
        this.recordExposeStart(new LauncherExposeEventLogs(topCardItem.cardId));
      } else {
        this.recordExposeEndByFormId(cardItem.cardId);
      }
    }
  }

  /**
   * 页面状态改变-记录曝光
   *
   * 1、桌面左右页面切换
   * 2、桌面可见（onForeground）
   */
  async recordExposeOnPageChange(): Promise<void> {
    log.showInfo('recordExposeOnPageChange');
    if (this.mExposeEventTemps.length > 0) {
      this.recordExposeEndWhenInvisible();
    }
    // 获取当前页可见的语音助手卡片集合并记录卡片曝光开始时间
    for (let cardItem of AbilityFormUtil.getVisibleVoiceList()) {
      if (!cardItem.cardId) {
        log.showWarn('recordExposeOnPageChange cardId invalid');
        continue;
      }
      this.recordExposeStart(new LauncherExposeEventLogs(cardItem.cardId));
    }
  }

  /**
   * 记录曝光结束时间，排除当前页面已有的卡片
   */
  recordExposeEndWhenInvisible(): void {
    log.showDebug('recordExposeEndWhenInvisible');
    for (let i = this.mExposeEventTemps.length - 1; i >= 0; i--) {
      const tempItem = this.mExposeEventTemps[i];
      if (!AbilityFormUtil.isAbilityFormVisible(tempItem.formId)) {
        this.recordExposeEndByFormId(tempItem.formId);
      }
    }
  }

  /**
   * 记录曝光结束时间
   *
   * 1、桌面左右页面切换
   * 2、桌面不可见（onBackground）
   */
  recordExposeEndAll(): void {
    log.showInfo('recordExposeEndAll');
    this.mExposeEventTemps.forEach(tempLog => {
      this.recordExposeEnd(tempLog);
    });
    this.mExposeEventTemps.splice(0, this.mExposeEventTemps.length);
  }

  /**
   * 记录曝光开始时间
   *
   * @param tempInfo 临时记录
   */
  private recordExposeStart(tempInfo: LauncherExposeEventLogs): void {
    const formId = tempInfo.formId;
    log.showInfo(`recordExposeStart ${formId}`);
    let tempIndex = this.mExposeEventTemps.findIndex(tempItem => tempItem.formId === formId);
    if (tempIndex < 0) {
      this.mExposeEventTemps.push(tempInfo);
    } else {
      log.showInfo(`formId ${formId} has in record`);
    }
  }

  /**
   * 记录曝光结束时间，时间有效则增加一条有效曝光记录
   *
   * @param tempInfo 临时记录
   */
  private recordExposeEnd(tempInfo: LauncherExposeEventLogs): void {
    log.showInfo(`recordExposeEnd ${tempInfo.formId}`);
    tempInfo.endTime = Date.now();
    if (tempInfo.endTime - tempInfo.startTime > ExposeEventRecorder.validExposeDuration) {
      this.addRecord(tempInfo);
    }
  }

  /**
   * 增加一条有效曝光记录
   *
   * @param recordInfo 曝光记录
   */
  private addRecord(recordInfo: LauncherExposeEventLogs): void {
    log.showInfo(`addRecord ${JSON.stringify(recordInfo)}`);
    if (this.mExposeEventRecords.length >= ExposeEventRecorder.maxRecordItems) {
      // 记录数量超标，移除一条老数据
      this.mExposeEventRecords.shift();
    }
    this.mExposeEventRecords.push(recordInfo);
  }
}
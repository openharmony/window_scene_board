/*
 * Copyright (c) 2026 Huawei Device Co., Ltd. All rights reserved.
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

import settings from '@ohos.settings';
import systemTimer from '@ohos.systemTimer';
import wantAgent from '@ohos.app.ability.wantAgent';
import { WantAgent } from '@ohos.wantAgent';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import { LogUtil } from '@ohos/scene.common/src/main/ets/utils/LogUtil';
import { JsonUtil } from '@ohos/scene.common/src/main/ets/utils/JsonUtil';
import { StringUtil } from '@ohos/scene.common/src/main/ets/utils/StringUtil';
import { CheckEmptyUtils } from '@ohos/scene.common/src/main/ets/utils/CheckEmptyUtils';
import { SettingsDataUtils } from '@ohos/scene.common/src/main/ets/utils/SettingsDataUtils';
import { AbilityContextManager } from '@ohos/scene.common/src/main/ets/ability/AbilityContextManager';
import { GlobalContext } from '@ohos/scene.common/src/main/ets/utils/GlobalContext';
import { IntelligentSceneConstant } from '@ohos/scene.common/src/main/ets/utils/AbilityUtils';
import { ConfigDataManager } from '@ohos/scene.datamanage/src/main/ets/manager/ConfigDataManager';
import { El1ConfigDataManager } from '@ohos/scene.datamanage/src/main/ets/manager/El1ConfigDataManager';
import { ConfigData } from '@ohos/scene.datamanage/src/main/ets/model/base/ConfigModel';
import { ConfigType } from '@ohos/scene.datamanage/src/main/ets/model/base/ConfigType';
import { LoopType, TimeCondition } from '@ohos/scene.datamanage/src/main/ets/model/TriggerCondition';
import { DateTimeUtil } from '@ohos/scene.datamanage/src/main/ets/utils/DateTimeUtil';

/* instrument ignore file */
const TAG: string = 'SceneTimeScheduleManager:';
const TIMER_ID_KEY: string = 'scene_time_schedule_timer_id';
const TIMER_CONTEXT_KEY: string = 'TimerContext';
const NO_TIMER: number = -1;
const SERVICE_ABILITY: string = 'com.ohos.intelligentscene.SceneTimeScheduleService';

export interface ActiveTimeHit {
  modeId: string;
  condition: TimeCondition;
  startMs: number;
  endMs: number;
}

interface EnabledTimeCondition {
  modeId: string;
  condition: TimeCondition;
}

/**
 * 情景模式定时条件本地调度（对齐设置深色模式定时）：
 * 本地判时段 + systemTimer 到点 + TIME_CHANGED 立即重算。
 * 作为 ECA/Awareness 不可用时的兜底。
 */
export class SceneTimeScheduleManager {
  private static instance: SceneTimeScheduleManager;

  public static getInstance(): SceneTimeScheduleManager {
    if (!SceneTimeScheduleManager.instance) {
      SceneTimeScheduleManager.instance = new SceneTimeScheduleManager();
    }
    return SceneTimeScheduleManager.instance;
  }

  private getContext(context?: common.Context): common.Context | undefined {
    if (!CheckEmptyUtils.isEmpty(context)) {
      return context;
    }
    let ctx = AbilityContextManager.getContext();
    if (CheckEmptyUtils.isEmpty(ctx)) {
      ctx = AbilityContextManager.getExtContext();
    }
    if (CheckEmptyUtils.isEmpty(ctx)) {
      ctx = GlobalContext.getInstance().get(TIMER_CONTEXT_KEY) as Context;
    }
    return ctx as common.Context | undefined;
  }

  /**
   * 静态订阅生命周期短：拉起 SceneTimeScheduleService 执行切换。
   */
  public requestApplyViaService(context?: common.Context): void {
    const ctx: common.Context | undefined = this.getContext(context);
    if (CheckEmptyUtils.isEmpty(ctx) || ctx === undefined) {
      LogUtil.showError(TAG, 'requestApplyViaService context invalid');
      return;
    }
    const validCtx: common.Context = ctx as common.Context;
    try {
      const want: Want = {
        bundleName: IntelligentSceneConstant.BUNDLE_NAME,
        abilityName: SERVICE_ABILITY,
      };
      (validCtx as common.UIAbilityContext).startServiceExtensionAbility(want).then(() => {
        LogUtil.showInfo(TAG, 'requestApplyViaService service started');
      }).catch((err: BusinessError) => {
        LogUtil.showError(TAG, `requestApplyViaService start failed: ${err?.code} ${err?.message}`);
        void this.startTimeAlarm(Date.now() + 200, validCtx);
      });
    } catch (error) {
      LogUtil.showError(TAG, `requestApplyViaService exception: ${(error as BusinessError)?.message}`);
      void this.startTimeAlarm(Date.now() + 200, validCtx);
    }
  }

  public async collectActiveHits(): Promise<ActiveTimeHit[]> {
    const conditions: EnabledTimeCondition[] = await this.loadEnabledTimeConditions();
    const now: Date = new Date();
    const hits: ActiveTimeHit[] = [];
    for (const item of conditions) {
      const range: Date[] | undefined = this.getActiveRangeIfMatch(item.condition, now);
      if (!range) {
        continue;
      }
      const hit: ActiveTimeHit = {
        modeId: item.modeId,
        condition: item.condition,
        startMs: range[0].getTime(),
        endMs: range[1].getTime(),
      };
      hits.push(hit);
    }
    hits.sort((a: ActiveTimeHit, b: ActiveTimeHit) => Number(a.modeId) - Number(b.modeId));
    return hits;
  }

  public async refreshTimer(context?: common.Context): Promise<void> {
    const nextMs: number = await this.getNextBoundaryMs();
    if (nextMs <= 0) {
      this.stopAlarm(context);
      LogUtil.showInfo(TAG, 'refreshTimer no next boundary, stop alarm');
      return;
    }
    LogUtil.showInfo(TAG, `refreshTimer nextMs=${nextMs}, now=${Date.now()}`);
    await this.startTimeAlarm(nextMs, context);
  }

  private async loadEnabledTimeConditions(): Promise<EnabledTimeCondition[]> {
    const configTypes: ConfigType[] = [
      ConfigType.TRIGGER_CONDITION_TIME,
      ConfigType.TEMPORARY_TIME_CONDITION,
    ];
    const el1: ConfigData[] = await El1ConfigDataManager.getInstance().queryConfigDataByConfigType(configTypes);
    const el2: ConfigData[] = await ConfigDataManager.getInstance().queryConfigDataByConfigType(configTypes);
    const all: ConfigData[] = [...el1, ...el2];
    const result: EnabledTimeCondition[] = [];
    for (const data of all) {
      const condition: TimeCondition = JsonUtil.fromJson(data.configValue) as TimeCondition;
      if (!condition?.enable) {
        continue;
      }
      condition.configId = data.configId;
      const item: EnabledTimeCondition = {
        modeId: data.modeId,
        condition: condition,
      };
      result.push(item);
    }
    return result;
  }

  /**
   * 若条件在当前时刻生效，返回 [start, end) 对应 Date；否则 undefined。
   */
  private getActiveRangeIfMatch(condition: TimeCondition, now: Date): Date[] | undefined {
    if (StringUtil.isEmpty(condition.timeStart) || StringUtil.isEmpty(condition.timeEnd)) {
      return undefined;
    }
    if (!this.isLoopDayMatch(condition, now)) {
      return undefined;
    }
    let baseDate: Date = new Date(now);
    if (condition.loopType === LoopType.ONE_TIME) {
      if (StringUtil.isEmpty(condition.loopDays)) {
        return undefined;
      }
      baseDate = DateTimeUtil.parseStringToDate(condition.loopDays);
    }
    const range: Date[] = DateTimeUtil.parseTimeRange(baseDate, condition.timeStart, condition.timeEnd);
    // 跨天：若 now 在结束侧凌晨，base 可能需用昨天
    if (now < range[0] || now >= range[1]) {
      const yesterday: Date = new Date(now);
      yesterday.setDate(yesterday.getDate() - 1);
      if (condition.loopType !== LoopType.ONE_TIME && this.isLoopDayMatch(condition, yesterday)) {
        const crossRange: Date[] = DateTimeUtil.parseTimeRange(yesterday, condition.timeStart, condition.timeEnd);
        if (now >= crossRange[0] && now < crossRange[1]) {
          return crossRange;
        }
      }
      return undefined;
    }
    return range;
  }

  private isLoopDayMatch(condition: TimeCondition, day: Date): boolean {
    switch (condition.loopType) {
      case LoopType.ONE_TIME: {
        if (StringUtil.isEmpty(condition.loopDays)) {
          return false;
        }
        return DateTimeUtil.formatDateToString(day) === condition.loopDays;
      }
      case LoopType.EVERY_DAY:
      case LoopType.WORKDAY:
      case LoopType.HOLIDAY:
        // WORKDAY/HOLIDAY 无日历时按每天处理，后续可接节假日数据
        return true;
      case LoopType.EVERY_WEEK: {
        if (StringUtil.isEmpty(condition.loopDays)) {
          return false;
        }
        const jsDay: number = day.getDay(); // 0=Sun
        const fenceDay: number = jsDay === 0 ? 7 : jsDay; // 1=Mon ... 7=Sun
        return condition.loopDays.split(',').map((s: string) => s.trim()).includes(String(fenceDay));
      }
      default:
        return false;
    }
  }

  private async getNextBoundaryMs(): Promise<number> {
    const conditions: EnabledTimeCondition[] = await this.loadEnabledTimeConditions();
    if (conditions.length === 0) {
      return -1;
    }
    const now: number = Date.now();
    let nearest: number = -1;
    for (const item of conditions) {
      const candidates: number[] = this.getBoundaryCandidates(item.condition, new Date(now));
      for (const ts of candidates) {
        if (ts <= now) {
          continue;
        }
        if (nearest < 0 || ts < nearest) {
          nearest = ts;
        }
      }
    }
    return nearest;
  }

  private getBoundaryCandidates(condition: TimeCondition, now: Date): number[] {
    const result: number[] = [];
    if (StringUtil.isEmpty(condition.timeStart) || StringUtil.isEmpty(condition.timeEnd)) {
      return result;
    }
    // 检查今天与昨天、明天，覆盖跨天与单次
    for (let offset = -1; offset <= 1; offset++) {
      const day: Date = new Date(now);
      day.setDate(now.getDate() + offset);
      if (!this.isLoopDayMatch(condition, day)) {
        continue;
      }
      let base: Date = day;
      if (condition.loopType === LoopType.ONE_TIME) {
        base = DateTimeUtil.parseStringToDate(condition.loopDays);
        if (DateTimeUtil.formatDateToString(base) !== DateTimeUtil.formatDateToString(day)) {
          continue;
        }
      }
      const range: Date[] = DateTimeUtil.parseTimeRange(base, condition.timeStart, condition.timeEnd);
      result.push(range[0].getTime(), range[1].getTime());
    }
    return result;
  }

  private async getAlarmWantAgent(): Promise<WantAgent | undefined> {
    try {
      const wantAgentInfo: wantAgent.WantAgentInfo = {
        wants: [
          {
            bundleName: IntelligentSceneConstant.BUNDLE_NAME,
            abilityName: SERVICE_ABILITY,
          }
        ],
        actionType: wantAgent.OperationType.START_ABILITY,
        wantAgentFlags: [wantAgent.WantAgentFlags.UPDATE_PRESENT_FLAG],
        requestCode: 0,
      };
      return await wantAgent.getWantAgent(wantAgentInfo);
    } catch (error) {
      LogUtil.showError(TAG, `getAlarmWantAgent failed: ${(error as BusinessError).message}`);
      return undefined;
    }
  }

  private getTimerId(context?: common.Context): number {
    const ctx: common.Context | undefined = this.getContext(context);
    if (CheckEmptyUtils.isEmpty(ctx) || ctx === undefined) {
      return NO_TIMER;
    }
    return Number(SettingsDataUtils.getSettingsDataWithContext(ctx as common.Context, TIMER_ID_KEY,
      String(NO_TIMER), settings.domainName.USER_PROPERTY));
  }

  private stopAlarmSelf(timerId: number): void {
    if (!timerId || timerId === NO_TIMER) {
      return;
    }
    try {
      systemTimer.stopTimer(timerId);
      LogUtil.showInfo(TAG, `stopTimer ${timerId}`);
    } catch (error) {
      LogUtil.showError(TAG, `stopTimer failed: ${(error as BusinessError).message}`);
    }
  }

  public stopAlarm(context?: common.Context): void {
    const ctx: common.Context | undefined = this.getContext(context);
    this.stopAlarmSelf(this.getTimerId(ctx));
    if (!CheckEmptyUtils.isEmpty(ctx) && ctx !== undefined) {
      SettingsDataUtils.setSettingsDataWithContext(ctx as common.Context, TIMER_ID_KEY, String(NO_TIMER),
        settings.domainName.USER_PROPERTY);
    }
  }

  private async startTimeAlarm(alarmTime: number, context?: common.Context): Promise<void> {
    const ctx: common.Context | undefined = this.getContext(context);
    if (CheckEmptyUtils.isEmpty(ctx) || ctx === undefined) {
      LogUtil.showError(TAG, 'startTimeAlarm context invalid');
      return;
    }
    const validCtx: common.Context = ctx as common.Context;
    try {
      this.stopAlarmSelf(this.getTimerId(validCtx));
      const agent = await this.getAlarmWantAgent();
      if (!agent) {
        LogUtil.showError(TAG, 'startTimeAlarm wantAgent invalid');
        return;
      }
      const timerId = await systemTimer.createTimer({
        type: systemTimer.TIMER_TYPE_EXACT | systemTimer.TIMER_TYPE_WAKEUP,
        repeat: false,
        wantAgent: agent,
        autoRestore: true
      });
      SettingsDataUtils.setSettingsDataWithContext(validCtx, TIMER_ID_KEY, String(timerId),
        settings.domainName.USER_PROPERTY);
      await systemTimer.startTimer(timerId, alarmTime);
      LogUtil.showInfo(TAG, `startTimeAlarm timerId=${timerId}, alarmTime=${alarmTime}`);
    } catch (error) {
      LogUtil.showError(TAG, `startTimeAlarm failed: ${(error as BusinessError).message}`);
    }
  }
}

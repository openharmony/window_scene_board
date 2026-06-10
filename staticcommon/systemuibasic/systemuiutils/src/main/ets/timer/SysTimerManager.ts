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
import { SingletonHelper, LogDomain, LogHelper, CommonUtils } from '@ohos/basicutils';
import systemTimer from '@ohos.systemTimer';
import type { BusinessError } from '@ohos.base';
import Queue from '@ohos.util.Queue';
import systemDateTime from '@ohos.systemDateTime';

const TAG = 'SysTimerManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 定时器默认1分钟
 */
const DEFAULT_TRIGGER_TIME = 60000;

/**
 * 定时器执行函数类型
 */
enum TimerExeType {
  /**
   * 开启定时器
   */
  TYPE_START_TIMER,

  /**
   * 暂停定时器
   */
  TYPE_STOP_TIMER
}

/**
 * 定时器执行函数数据
 */
interface TimerExeData {
  /**
   * 函数执行类型
   */
  type: TimerExeType;

  /**
   * 函数入参，定时器ID
   */
  timerId?: number;

  /**
   * 函数入参，定时器目标时间戳
   */
  triggerTimer?: number;
}

/**
 * 内部定时数据管理
 */
class TimerData {
  /**
   * 定时器执行函数队列，保证调用链的时序
   */
  private timerExeQueue: Queue<TimerExeData>;

  /**
   * 请求定时器启动前的自增ID
   */
  private autoIncrementId: number = 0;

  /**
   * 当前函数执行队列是否正在运行
   */
  private isExeQueueRunning: boolean = false;

  /**
   * 定时器唯一标示
   */
  readonly key: string;

  /**
   * 内部定时器到时触发回调
   */
  innerOnTimer: () => void;

  /**
   * 当前已创建的定时器ID
   */
  timerId?: number;

  /**
   * 外部定时器到时触发回调
   */
  outOnTimer?: (key: string) => void;

  /**
   * 定时器触发时长，毫秒数
   */
  triggerTime?: number;

  /**
   * 定时器起始时刻(开机时长时刻值)
   */
  startRealTime?: number;

  /**
   * 构造
   *
   * @param key 唯一标示
   * @param ignoreTriggerTimeCheck 是否忽略触发时间校验
   */
  constructor(key: string, ignoreTriggerTimeCheck?: boolean) {
    this.key = key;
    this.timerExeQueue = new Queue();

    // 定时器到时触发回调
    this.innerOnTimer = (): void => {
      // 当前时刻满足时间差，则认为有效回调
      let currentRealTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP) ?? 0;
      if (ignoreTriggerTimeCheck || currentRealTime - (this.startRealTime ?? 0) >= (this.triggerTime ?? 0)) {
        log.showWarn(`innerOnTimer trigger ${this.key}`);
        // 外部定时触发回调
        this.outOnTimer?.(this.key);
        // 回调完成，取消监听器，防止多次回调
        this.outOnTimer = undefined;
      }
    };
  }

  /**
   * 自增ID值
   */
  autoIncrement(): void {
    this.autoIncrementId++;
  }

  /**
   * 获取当前自增ID值
   *
   * @returns 自增ID值
   */
  getAutoIncrementId(): number {
    return this.autoIncrementId;
  }

  /**
   * 开启定时器
   */
  startTimer(): void {
    if (CommonUtils.isInvalid(this.timerId) || CommonUtils.isInvalid(this.triggerTime)) {
      log.showWarn('startTimer no timer or trigger: ' + this.triggerTime);
      return;
    }

    // 计算目标时间戳
    this.startRealTime = systemDateTime.getUptime(systemDateTime.TimeType.STARTUP) ?? 0;
    let triggerTimer = this.startRealTime + (this.triggerTime ?? 0);

    // 入队列
    this.enqueueExe({
      type: TimerExeType.TYPE_START_TIMER,
      timerId: this.timerId,
      triggerTimer: triggerTimer
    });

    // 开启队列
    this.startExeQueue();
  }

  /**
   * 暂停定时器
   */
  stopTimer(): void {
    if (CommonUtils.isInvalid(this.timerId)) {
      return;
    }
    this.enqueueExe({
      type: TimerExeType.TYPE_STOP_TIMER,
      timerId: this.timerId
    });
    this.startExeQueue();
  }

  /**
   * 销毁定时器
   *
   * @param timerId 定时器ID
   * @param isResetId true重置成员变量timerId
   */
  destroyTimer(timerId?: number, isResetId?: boolean): void {
    if (CommonUtils.isNumber(timerId)) {
      try {
        systemTimer.destroyTimer(timerId);
      } catch (e) {
        let error = e as BusinessError;
        log.showError('destroyTimer error: ' + error?.message);
      }
    }
    if (isResetId) {
      this.timerId = undefined;
    }
  }

  /**
   * 函数执行入队列
   *
   * @param data 函数执行数据
   */
  private enqueueExe(data: TimerExeData): void {
    this.timerExeQueue.add(data);
  }

  /**
   * 定时器函数执行
   *
   * @returns void
   */
  private async startExeQueue(): Promise<void> {
    if (this.timerExeQueue.length === 0 || this.isExeQueueRunning) {
      return;
    }
    this.isExeQueueRunning = true;
    let data = this.timerExeQueue.pop();
    switch (data?.type) {
      // 开启定时器
      case TimerExeType.TYPE_START_TIMER:
        await this.startInnerTimer(data?.timerId, data?.triggerTimer);
        break;
      // 停止定时器
      case TimerExeType.TYPE_STOP_TIMER:
        await this.stopInnerTimer(data?.timerId);
        break;
      default:
        break;
    }
    this.isExeQueueRunning = false;
    this.startExeQueue();
  }

  /**
   * 开启定时时器
   *
   * @param timerId 定时器ID
   * @param triggerTime 定时目标时间戳
   * @returns
   */
  private async startInnerTimer(timerId?: number, triggerTime?: number): Promise<void> {
    if (CommonUtils.isInvalid(timerId) || CommonUtils.isInvalid(triggerTime)) {
      return;
    }
    try {
      await systemTimer.startTimer(timerId, triggerTime);
    } catch (e) {
      let error = e as BusinessError;
      log.showError('stopTimer error: ' + error?.message);
    }
  }

  /**
   * 暂停定时器
   *
   * @param timerId 定时器ID
   */
  private async stopInnerTimer(timerId?: number): Promise<void> {
    if (CommonUtils.isNumber(timerId)) {
      try {
        await systemTimer.stopTimer(timerId);
      } catch (e) {
        let error = e as BusinessError;
        log.showError('stopTimer error: ' + error?.message);
      }
    }
  }
}

/**
 * 系统定时器启动入参
 */
export interface SysTimerParam {
  /**
   * 定时器唯一标示
   */
  key: string;

  /**
   * 定时时长，毫秒
   */
  triggerTime?: number;

  /**
   * 定时触发回调
   *
   * @param key 定时器标示
   */
  onTimer?: (key: string) => void;

  /**
   * 是否忽略触发时间校验
   */
  ignoreTriggerTimeCheck?: boolean;
}

/**
 * 系统定时器管理
 */
class SysTimerManager {
  /**
   * 定时器集
   */
  private timerMap: Map<string, TimerData> = new Map();

  /**
   * 开启定时任务
   *
   * @param param 定时任务参数
   */
  startTimer(param: SysTimerParam): void {
    if (CommonUtils.isEmpty(param?.key)) {
      log.showWarn('startTimer key invalid.');
      return;
    }

    // 构造定时数据
    let data = this.timerMap.get(param?.key);
    if (CommonUtils.isInvalid(data) || !data) {
      data = new TimerData(param?.key, param?.ignoreTriggerTimeCheck);
      this.timerMap.set(param?.key, data);
    }
    data.triggerTime = param?.triggerTime ?? DEFAULT_TRIGGER_TIME;
    data.outOnTimer = param?.onTimer;

    // 停止老任务，开启新任务
    data.stopTimer();
    data.autoIncrement();
    this.startInnerTimer(data, data.getAutoIncrementId());
  }

  /**
   * 暂停定时任务
   *
   * @param key 定时任务标示
   */
  stopTimer(key: string): void {
    let data = this.timerMap.get(key);
    data?.stopTimer();
  }

  /**
   * 销毁定时任务
   *
   * @param key 定时任务标示
   */
  destroyTimer(key: string): void {
    let data = this.timerMap.get(key);

    // 清除数据
    this.timerMap.delete(key);

    // 销毁定时器
    data?.destroyTimer(data?.timerId, true);
  }

  /**
   * 开启定时器
   *
   * @param data 定时器数据
   * @param currentId 当前自增ID
   * @returns void
   */
  private async startInnerTimer(data: TimerData, currentId: number): Promise<void> {
    if (CommonUtils.isInvalid(data)) {
      return;
    }

    // 创建定时器
    let timerId = data.timerId;
    if (CommonUtils.isInvalid(timerId)) {
      timerId = await systemTimer.createTimer({
        // 精确定时唤醒，采用开机时长
        type: systemTimer.TIMER_TYPE_WAKEUP | systemTimer.TIMER_TYPE_EXACT | systemTimer.TIMER_TYPE_REALTIME,
        repeat: false,
        // 到时回调
        callback: data.innerOnTimer
      });

      // 定时器创建成功时，校验自增ID，不匹配则直接销毁
      if (data.getAutoIncrementId() !== currentId) {
        data.destroyTimer(timerId);
        return;
      }

      // 匹配，启用该定时器
      data.timerId = timerId;
    }

    // 正常启动定时器
    data.startTimer();
  }
}

// 单例
export let sysTimerMgr: SysTimerManager = SingletonHelper.getInstance(SysTimerManager, TAG);
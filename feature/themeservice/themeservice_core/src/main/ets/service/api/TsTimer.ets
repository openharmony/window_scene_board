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

/**
 * 定时器启动入参
 */
export interface TimerParam {

  /**
   * 定时器到期时间，采用开机时长，毫秒
   */
  endTime: number;

  /**
   * 定时触发回调
   *
   * @param key 定时器标示
   */
  onTimer: () => void;
}

/**
 * Ts内部定时器管理类
 */
export interface TsTimer {

  /**
   * 启动一个定时器
   * @param {TimerParam} timerParam - 定时器参数，包含定时器的各种设置
   * @return {Promise<Nullable<number>>} 返回一个Promise，如果定时器成功启动，返回定时器的ID，如果失败，返回undefined
   */
  startTimer(timerParam: TimerParam): Promise<Nullable<number>>;

  /**
   * 停止定时器
   * @param {number} timerId 已启动的定时器ID
   * @return {Promise<boolean>} 返回一个Promise，如果定时器成功停止，返回true，否则返回false
   */
  stopTimer(timerId: number): Promise<boolean>;

  /**
   * 停止所有定时器
   */
  cleanTimer(): void;
}
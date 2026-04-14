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

import { AnyClock } from '../../editsheet/models/AnyClock';
import { IClockThemeStyleChange } from '../interface/IClockThemeStyleChange';

/**
 * 时钟主题样式辅助工具
 */
export class ClockThemeHelper {
  // 单例
  private static sInstance?: ClockThemeHelper;

  // 时钟主题样式切换监听器
  private readonly clockStyleListener: Set<IClockThemeStyleChange> = new Set();

  private constructor() {
  }

  /**
   * 注册时钟主题样式切换监听
   *
   * @param listener 监听器
   */
  public registerClockThemeStyleListener(listener: IClockThemeStyleChange): void {
    this.clockStyleListener.add(listener);
  }

  /**
   * 注销时钟主题样式切换监听
   *
   * @param listener 监听器
   */
  public unregisterClockThemeStyleListener(listener: IClockThemeStyleChange): void {
    this.clockStyleListener.delete(listener);
  }

  /**
   * 刷新时钟主题样式
   *
   * @param clockStyle 最新时钟样式
   * @param gridWidth 最新单元栅格大小
   */
  public updateClockThemeStyle(clockStyle: AnyClock, gridWidth?: number): void {
    this.clockStyleListener.forEach((listener) => listener?.onClockThemeChange(clockStyle, gridWidth));
  }

  /**
   * 单例
   *
   * @returns 实例
   */
  public static getInstance(): ClockThemeHelper {
    if (!ClockThemeHelper.sInstance) {
      ClockThemeHelper.sInstance = new ClockThemeHelper();
    }
    return ClockThemeHelper.sInstance;
  }
}
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

import { FolderAnimationCycleArray } from './FolderAnimationCycleArray';

/**
 * 文件夹动效播放的记录器：记录文件夹动效执行过程的状态变量与动效参数，用于DFX
 */
export class FolderAnimationPlaybackManager {
  private static instance: FolderAnimationPlaybackManager;
  private array: FolderAnimationCycleArray = new FolderAnimationCycleArray(100);

  public static getInstance(): FolderAnimationPlaybackManager {
    if (!FolderAnimationPlaybackManager.instance) {
      FolderAnimationPlaybackManager.instance = new FolderAnimationPlaybackManager();
    }

    return FolderAnimationPlaybackManager.instance;
  }

  /**
   * 结论更新的信息
   *
   * @param id 区分更新的observer
   * @param type 区分更新操作
   * @param fromValue 更改前的值
   * @param toValue 更改后的值
   * @param delay 动效延迟时间
   * @param duration 动效执行时间
   * @param curve 动效曲线
   */
  public record(id: string, type: string, fromValue: number, toValue: number, delay: number, duration?: number,
    curve?: number): void {
    this.array.push(id, type, fromValue, toValue, delay, duration, curve);
  }
}
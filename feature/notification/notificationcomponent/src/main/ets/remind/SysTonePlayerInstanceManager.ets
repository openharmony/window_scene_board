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
import { SysTonePlayer } from './SysTonePlayer';

/**
 * 系统播放器实例管理
 */
export class SysTonePlayerInstanceManager {
  /**
   * 系统播放器单例
   */
  private static playerInstance: SysTonePlayer | undefined = undefined;

  /**
   * 获取系统播放器单例，作为普通铃声播放器
   * @returns
   */
  public static instance(): SysTonePlayer {
    if (SysTonePlayerInstanceManager.playerInstance) {
      return SysTonePlayerInstanceManager.playerInstance;
    }
    SysTonePlayerInstanceManager.playerInstance = new SysTonePlayer();
    return SysTonePlayerInstanceManager.playerInstance;
  }

  /**
   * 获取一个系统播放器实例，在VoIP通知不携带长震动的场景下，使用新实例播放短振动，避免与普通系统铃声冲突
   * @returns
   */
  public static voipSysToneInstance(): SysTonePlayer {
    return new SysTonePlayer();
  }
}
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

export class ClockOneShortConsts  {
  /**
   * AOD到进入桌面：包含全屏AOD到桌面、局部AOD到桌面
   */
  public static readonly AOD_TO_DESKTOP_CLOCK_ANIMATION = 'AOD_TO_DESKTOP_CLOCK_ANIMATION';
  /**
   * 全屏AOD进入桌面，执行时钟变形动画
   */
  public static readonly FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION = 'FULL_AOD_TO_DESKTOP_CLOCK_ANIMATION';
  /**
   * AOD解锁，触发时钟变形动画执行后，触发执行解锁后的其他处理（包括隐藏窗口等）
   */
  public static readonly AOD_TO_DESKTOP_UNLOCKING = 'AOD_TO_DESKTOP_UNLOCKING';
  /**
   * 桌面进入全屏AOD，执行时钟变形动画
   */
  public static readonly DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION = 'DESKTOP_TO_FULL_AOD_CLOCK_ANIMATION';
  /**
   * 桌面进入全屏AOD，动效执行完锁屏后
   */
  public static readonly DESKTOP_TO_FULL_AOD_CLOCK_LOCKING = 'DESKTOP_TO_FULL_AOD_CLOCK_LOCKING';

  // 半屏AOD场景
  /**
   * 桌面进入半屏AOD，执行时钟变形动画
   */
  public static readonly DESKTOP_TO_PART_AOD_CLOCK_ANIMATION = 'DESKTOP_TO_PART_AOD_CLOCK_ANIMATION';
  /**
   * 半屏AOD到桌面，执行时钟变形动画
   */
  public static readonly PART_AOD_TO_DESKTOP_CLOCK_ANIMATION = 'PART_AOD_TO_DESKTOP_CLOCK_ANIMATION';
  /**
   * 半屏AOD到锁屏，执行时钟变形动画
   */
  public static readonly PART_AOD_TO_SL_CLOCK_ANIMATION = 'PART_AOD_TO_SL_CLOCK_ANIMATION';
  /**
   * 锁屏到半屏AOD，执行时钟变形动画
   */
  public static readonly SL_TO_PART_AOD_CLOCK_ANIMATION = 'SL_TO_PART_AOD_CLOCK_ANIMATION';
  /**
   * 进入AOD，一帧刷新
   */
  public static readonly DESKTOP_TO_PART_AOD_NO_ANIM = 'DESKTOP_TO_PART_AOD_NO_ANIM'

  /**
   * 局部AOD到锁屏，一直刷新
   */
  public static readonly NO_ANIM_PART_AOD_TO_SL = 'NO_ANIM_PART_AOD_TO_SL';

  /**
   * 局部AOD到锁屏，一直刷新
   */
  public static readonly NO_ANIM_SL_TO_PART_AOD = 'NO_ANIM_SL_TO_PART_AOD';

  /**
   * 局部AOD到桌面，一帧刷新
   */
  public static readonly NO_ANIM_PART_AOD_TO_DESKTOP = 'NO_ANIM_PART_AOD_TO_DESKTOP';
}
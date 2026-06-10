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


export class ScreenLockToDesktopConsts {
  /**
   * 人脸解锁进入桌面，执行时钟变形动画
   */
  public static readonly FACE_TO_DESKTOP_CLOCK_ANIMATION = 'FACE_TO_DESKTOP_CLOCK_ANIMATION';

  /**
   * 人脸解锁，触发时钟变形动画执行后，触发执行解锁后的其他处理（包括隐藏窗口等）
   */
  public static readonly FACE_TO_DESKTOP_UNLOCKING = 'FACE_TO_DESKTOP_UNLOCKING';

  /**
   * 滑动解锁，执行离手时钟变形动画
   */
  public static readonly SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION = 'SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION';

  /**
   * 滑动解锁，执行离手时钟字号变化动画
   */
  public static readonly SLIDE_UP_TO_DO_FONTSIZE_ANIMATION = 'SLIDE_UP_TO_DO_FONTSIZE_ANIMATION';

  /**
   * 滑动解锁，触发时钟变形动画执行后，触发执行解锁后的其他处理（包括隐藏窗口等）
   */
  public static readonly SLIDE_UP_TO_DESKTOP_UNLOCKING = 'SLIDE_UP_TO_DESKTOP_UNLOCKING';

  /**
   * 无密码或者解锁成功时，键盘按键解锁，执行时钟变形动画
   */
  public static readonly KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION = 'KEYPRESS_TO_DESKTOP_CLOCK_ANIMATION';

  /**
   * 无密码或者解锁成功时，键盘按键解锁，触发时钟变形动画执行后，触发执行解锁后的其他处理（包括隐藏窗口等）
   */
  public static readonly KEYPRESS_TO_DESKTOP_UNLOCKING = 'KEYPRESS_TO_DESKTOP_UNLOCKING';

  /**
   * 指纹解锁，执行时钟变形动画
   */
  public static readonly FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION = 'FINGERPRINT_TO_DESKTOP_CLOCK_ANIMATION';

  /**
   * 指纹解锁，触发时钟变形动画执行后，触发执行解锁后的其他处理（包括隐藏窗口等）
   */
  public static readonly FINGERPRINT_TO_DESKTOP_UNLOCKING = 'FINGERPRINT_TO_DESKTOP_UNLOCKING';

  /**
   * 滑动解锁，执行跟手时钟变形动画
   */
  public static readonly SLIDE_MOVE_CLOCK_ANIMATION = 'SLIDE_MOVE_CLOCK_ANIMATION';

  /**
   * 锁屏时钟动画结束时，通知桌面开始做天气时钟动画
   */
  public static readonly DESKTOP_CLOCK_ANIMATION_START = 'DESKTOP_CLOCK_ANIMATION_START';

  /**
   * 滑动距离不够，动画回退
   */
  public static readonly SLIDE_UP_TO_RESET_CLOCK_ANIMATION = 'SLIDE_UP_TO_RESET_CLOCK_ANIMATION';

  /**
   * 桌面到AOD动画结束事件
   */
  public static readonly DESKTOP_TO_AOD_ANIM_FINISHED = 'DESKTOP_TO_AOD_ANIM_FINISHED';
}
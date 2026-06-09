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
 * 资源管理
 */
export abstract class AbsResourceManager {

  /**
   *
   * 获取电池进度条
   * @param batterySoc 电量
   * @param isShowBatterySoc 是否显示电量
   * @param isBatteryCharging 是否充电
   * @returns
   */
  abstract getProgress(batterySoc: number, isShowBatterySoc: boolean, isBatteryCharging: boolean): Resource | undefined;

  /**
   *
   * 获取电池图标
   * @param isBrightOrDark 深浅色
   * @param isShowBatterySoc 是否显示电量
   * @param isBatteryCharging 是否充电
   * @returns
   */
  abstract getImage(isBrightOrDark: boolean, isShowBatterySoc: boolean, isBatteryCharging: boolean, chargerType: number): Resource | undefined;

  /**
   *
   * 获取音量图标
   * @returns
   */
  abstract getPcSoundIcons(): Map<string, Resource>;

  /**
   * 获取通知中心图标
   * @returns
   */
  abstract getPcNotificationIcons(): Map<string, Resource>;

  /**
   * 获取系统菜单图标
   * @returns
   */
  abstract getPcPersonalIcons(): Map<string, Resource>;

  /**
   * 获取控制中心图标
   * @returns
   */
  abstract getPcControlCenterIcons(): Map<string, Resource>;

  /**
   * 获取系统菜单图标
   * @returns
   */
  abstract getPcSystemMenuOffIcon(): Map<string, Resource>;
}
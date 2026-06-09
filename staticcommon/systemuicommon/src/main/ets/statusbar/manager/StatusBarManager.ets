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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import lazy { StatusBarMoveDownVmV1, StatusBarMoveDownVmV2 } from '../vm/StatusBarMoveDownVm';
const TAG = 'StatusBarManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
/**
 * 状态栏管理接口
 */
export interface IStatusBarManager {
  /**
   * 锁屏是否隐藏
   */
  isKeyguardHide: boolean;
  /**
   * 设置状态栏类型
   *
   * @return true 下拉面板状态栏
   */
  setStatusBarType(statusBarType?: number, isDropDown?: boolean): void;

  /**
   * 下拉面板状态栏类型
   *
   * @return true 下拉面板状态栏
   */
  isDropdown(): boolean;

  /**
   * 获取状态栏类型
   *
   * @return 状态栏类型
   */
  getStatusBarType(): number;

  /**
   * 获取状态栏透明度动效时长
   * @return 状态栏透明度动效时长
   */
  getStatusBarOpacityDuration(): number;

  /**
   * 注册状态栏隐藏事件
   */
  registerStatusbarHideEvent(statusbarEvent: Function | undefined): void;

  /**
   * 获取状态栏下沉Vm
   * @return 返回状态栏下沉vm
   */
  getMoveDownVM(): StatusBarMoveDownVmV2 | StatusBarMoveDownVmV1;
}

/**
 * 状态栏栏管理类
 */
export class StatusBarManager {
  private static instance?: IStatusBarManager;

  public static setInstance(instance: IStatusBarManager | undefined) {
    log.showInfo(`set status bar manager instance ${instance}.`);
    StatusBarManager.instance = instance;
  }

  public static getInstance(): IStatusBarManager | undefined {
    return StatusBarManager.instance;
  }
}

export enum HideStatusBarScene {
  NORMAL = 0, // 常规进应用
  FROM_DROPDOWN = 2 // 应用内下拉收起进应用
}

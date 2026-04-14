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

import { CommonUtils, SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { NtfSettingsDialogVM } from '../vm/NtfSettingsDialogVM';
import { NotificationEntry } from '../model/NotificationEntry';
import { NotificationType } from '../common/NotificationType';

const TAG = 'NtfSettingsDialogController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.NC, TAG);

/**
 * 通知设置弹框控制器
 *
 * @since 2023-01-13
 */
class NtfSettingsDialogController {
  /**
   * 一个面板一个VM
   * NotificationType => VM
   */
  private settingsDialogVMs: Map<number, NtfSettingsDialogVM> = new Map([
    [NotificationType.TYPE_PC, new NtfSettingsDialogVM()],
    [NotificationType.TYPE_TV, new NtfSettingsDialogVM()],
    [NotificationType.TYPE_PHONE_DROPDOWN, new NtfSettingsDialogVM()],
    [NotificationType.TYPE_PHONE_KEYGUARD, new NtfSettingsDialogVM()],
  ]);

  /**
   * 弹框控制，一个面板一个控制器
   * NotificationType => 控制器
   */
  private settingsControllers: Map<number, CustomDialogController | null> = new Map();

  /**
   * 设置弹窗事件集合
   */
  private settingsClickEventsMap: Map<number, SettingClickEvents> = new Map();

  /**
   * 弹框当前是否正在显示
   * NotificationType => 弹框是否显示
   */
  private isDialogShowings: Map<number, boolean> = new Map();

  /**
   * 设置回调集
   */
  private settingDialogCallbacks: Set<SettingDialogCallback> = new Set();

  /**
   * 获取通知实体
   *
   * @param ntfType 通知类型
   * @returns 通知实体（可空）
   */
  public getNtfEntryByType(ntfType: number): NotificationEntry | undefined {
    return this.getSettingsDialogVM(ntfType)?.getNtfEntry() as NotificationEntry;
  }

  /**
   * 设置对应面板弹框控制器
   *
   * @param ntfType 通知面板类型
   * @param controller 控制器
   */
  setDialogController(ntfType: number, controller: CustomDialogController | null): void {
    if (CommonUtils.isInvalid(controller)) {
      this.settingsControllers.delete(ntfType);
      return;
    }
    this.settingsControllers.set(ntfType, controller);
  }

  /**
   * 设置弹窗事件
   *
   * @param ntfType 面板类型
   * @param events 事件列表
   */
  setSettingEvents(ntfType: number, events: SettingClickEvents): void {
    if (CommonUtils.isInvalid(events)) {
      this.settingsClickEventsMap.delete(ntfType);
      return;
    }
    this.settingsClickEventsMap.set(ntfType, events);
  }

  /**
   * 删除弹窗事件
   *
   * @param ntfType 面板类型
   */
  deleteSettingEvents(ntfType: number): void {
    if (!this.settingsClickEventsMap.has(ntfType)) {
      return;
    }
    this.settingsClickEventsMap.delete(ntfType);
  }

  /**
   * 获取事件列表
   *
   * @param ntfType 面板类型
   * @returns 事件列表
   */
  getSettingEvents(ntfType: number): SettingClickEvents | undefined {
    return this.settingsClickEventsMap.get(ntfType);
  }

  /**
   * 获取面板对应的弹框VM
   *
   * @param ntfType 面板类型
   * @return 弹框VM
   */
  getSettingsDialogVM(ntfType: number): NtfSettingsDialogVM | undefined {
    return this.settingsDialogVMs.get(ntfType);
  }

  /**
   * 弹出弹框
   *
   * @param ntfType 通知所在面板类型
   * @param ntfEntry 通知数据
   */
  showDialog(ntfType: number, ntfEntry: NotificationEntry): void {
    if (CommonUtils.isInvalid(ntfEntry)) {
      return;
    }
    this.settingsDialogVMs.get(ntfType)?.setDialogNtfEntry(ntfEntry);
    this.isDialogShowings.set(ntfType, true);
    log.showInfo('showDialog: ' + ntfType + ', ' + ntfEntry.toSimpleString());
  }

  /**
   * 隐藏弹框
   *
   * @param ntfType 面板类型
   */
  hideDialog(ntfType: number): void {
    this.cancelBlur();
    let dialogVM = this.settingsDialogVMs.get(ntfType);
    if (CommonUtils.isInvalid(dialogVM)) {
      return;
    }
    let isShowing = this.isShowing(ntfType);
    log.showInfo(
      'hideDialog: ' + ntfType + ', ' + dialogVM?.getNtfEntry()?.toSimpleString() + ',isShowing:' + isShowing);
    dialogVM?.setDialogNtfEntry(null);
    this.isDialogShowings.set(ntfType, false);
  }

  /**
   * 弹框是否可见
   *
   * @param ntfType 面板类型
   */
  isShowing(ntfType: number): boolean {
    return this.isDialogShowings.get(ntfType) ?? false;
  }

  /**
   * 取消全屏模糊
   */
  cancelBlur() {
    this.settingDialogCallbacks.forEach((callback: SettingDialogCallback) => {
      callback.cancelBlur?.();
    });
  }

  /**
   * 注册设置弹窗监听器
   *
   * @param settingDialogCallback 回调器
   */
  registerSettingDialogCallback(settingDialogCallback: SettingDialogCallback): void {
    this.settingDialogCallbacks.add(settingDialogCallback);
  }

  /**
   * 注销设置弹窗监听器
   *
   * @param settingDialogCallback
   */
  unregisterSettingDialogCallback(settingDialogCallback: SettingDialogCallback): void {
    this.settingDialogCallbacks.delete(settingDialogCallback);
  }
}

/**
 * 设置按钮处理结果回调
 */
export interface SettingDialogCallback {
  /**
   * 取消全屏模糊
   */
  cancelBlur?(): void;
}

/**
 * 设置按钮弹窗点击事件
 */
export interface SettingClickEvents {
  /**
   * 置顶事件
   *
   * @param enable 是否置顶
   */
  changeAppPinTopConfig?: (enable: boolean) => void
  /**
   * 静默提醒事件
   *
   * * @param enable 是否静默
   */
  changeSilenceConfig?: (enable: boolean) => void
}

// 单例
export let ntfSettingsDC: NtfSettingsDialogController = SingletonHelper.getInstance(NtfSettingsDialogController, TAG);
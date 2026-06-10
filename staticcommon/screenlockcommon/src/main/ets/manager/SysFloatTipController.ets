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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';

const TAG = 'SysFloatTipController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

const SYS_TIP_DIALOG_DURATION = 2000;

/**
 * 仿系统悬浮提示框控制器（层级高于System Float window时使用）
 *
 * @since 2023-12-26
 */
class SysFloatTipController {
  private mapSysFloatTipCallback: Map<string, SysFloatTipCallback> = new Map();

  private timeOutId: number = -1;

  /**
   * 只能有一个对话框展示
   */
  private whoIsShowing: string | undefined = undefined;

  public registerCallback(sysFloatTipCallback: SysFloatTipCallback): void {
    if (!sysFloatTipCallback) {
      return;
    }
    log.showInfo(`${sysFloatTipCallback.getComponentId()} registerCallback`);
    this.clearComponentIdCallback(sysFloatTipCallback.getComponentId());
    this.mapSysFloatTipCallback.set(sysFloatTipCallback.getComponentId(), sysFloatTipCallback);
  }

  public unRegisterCallback(sysFloatTipCallback: SysFloatTipCallback): void {
    log.showInfo(`${sysFloatTipCallback.getComponentId()} unRegisterCallback`);
    this.clearComponentIdCallback(sysFloatTipCallback.getComponentId());
  }

  private clearComponentIdCallback(componentId: string): void {
    if (this.mapSysFloatTipCallback.get(componentId) && this.whoIsShowing === componentId) {
      this.setFloatTipDialogVisible(componentId, false);
      this.clearShowingInfo();
    }
    this.mapSysFloatTipCallback.delete(componentId);
  }

  private clearShowingInfo(): void {
    this.whoIsShowing = undefined;
    clearTimeout(this.timeOutId);
    this.timeOutId = -1;
  }

  public setFloatTipDialogVisible(componentId: string, isShow: boolean,
                                  duration: number = SYS_TIP_DIALOG_DURATION): void {
    if (!this.mapSysFloatTipCallback.get(componentId)) {
      log.showWarn(`${componentId} is undefined or null, register first.`);
      return;
    }
    if (isShow && this.whoIsShowing && this.whoIsShowing !== componentId) {
      this.mapSysFloatTipCallback.get(this.whoIsShowing)?.setSysFloatTipDialogVisible(false);
    }
    if (this.whoIsShowing === componentId || isShow) {
      this.clearShowingInfo();
    }
    this.mapSysFloatTipCallback.get(componentId)?.setSysFloatTipDialogVisible(isShow);
    if (isShow) {
      this.whoIsShowing = componentId;
      this.timeOutId = setTimeout(() => {
        this.mapSysFloatTipCallback.get(componentId)?.setSysFloatTipDialogVisible(false);
        this.whoIsShowing = undefined;
      }, duration);
    }
  }

  public setTipMessage(componentId: string, tipMessage: string): void {
    if (tipMessage) {
      this.mapSysFloatTipCallback.get(componentId)?.setTipMessage(tipMessage);
    } else {
      log.showWarn('param invalid.');
    }
  }

  public setTipMarginBottom(componentId: string, tipMarginBottom: number): void {
    this.mapSysFloatTipCallback.get(componentId)?.setTipMarginBottom(tipMarginBottom);
  }
}

/**
 * 组件回调器
 */
export interface SysFloatTipCallback {
  /**
   * 设置悬浮弹框文字提示内容
   *
   * @param tipMessage
   */
  setTipMessage(tipMessage: string): void;

  /**
   * 设置悬浮弹框底部边距
   *
   * @param tipMessage
   */
  setTipMarginBottom(tipMarginBottom: number): void;

  /**
   * 展示/隐藏悬浮弹框
   *
   * @param tipMessage
   */
  setSysFloatTipDialogVisible(isShowDialog: boolean): void;

  /**
   * 获取组件ID
   *
   * @param componentId
   */
  getComponentId(): string;
}

// 单例
export let screenLockSysFloatTipControl: SysFloatTipController =
  SingletonHelper.getInstance(SysFloatTipController, TAG);
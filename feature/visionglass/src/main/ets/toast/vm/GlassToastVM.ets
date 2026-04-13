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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { Rect } from '../../scene/common/GlassSceneManager';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';
import GlassToastConstant from '../common/GlassToastConstant';
import { GlassShowToastOptions, GlassToastManager } from '../manager/GlassToastManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, 'GlassToastVM');

export class GlassToastVM {
  private static instance?: GlassToastVM;
  private callBack?: ToastContentCallBack;
  private timerId?: number;
  private toastOpt?: GlassShowToastOptions;
  private toastUpdate: (opt: GlassShowToastOptions) => void = (opt) => {
    if (this.toastOpt) {
      this.hideToast();
    }
    this.toastOpt = opt;
    this.showToast(opt);
  }

  private destroy(): void {
    this.removeAutoCancelTimer();
  }

  private constructor() {
  }

  public static getInstance(): GlassToastVM {
    if (!GlassToastVM.instance) {
      log.showInfo(`getInstance new instance`);
      GlassToastVM.instance = new GlassToastVM();
    }
    return GlassToastVM.instance;
  }

  public static destroyInstance(): void {
    log.showInfo(`destroyInstance`);
    GlassToastVM.instance?.destroy();
    GlassToastVM.instance = undefined;
  }

  public init(callBack: ToastContentCallBack): void {
    this.callBack = callBack;
    GlassToastManager.getInstance().registerOptChanged(this.toastUpdate);
  }

  private hideToast(): void {
    log.info('hideToast');
    GlassToastManager.getInstance().setNtfWindowVisibility(false);
    this.callBack?.notifyToastChange(null);
  }

  private showToast(opt: GlassShowToastOptions): void {
    log.info('showToast');
    this.callBack?.notifyToastChange(opt);
    this.setAutoCancelTimer(opt);
    this.startShowWindow();
  }

  private startShowWindow(): void {
    log.info('startShowWindow');
    GlassToastManager.getInstance().setNtfWindowVisibility(true);
    const rect: Rect | undefined = GlassToastManager.getInstance().getPanelRect();
    if (rect) {
      GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_TOAST, {
        top: rect.top !== undefined ? rect.top : 0
      });
    }
  }

  /**
   * 设置Toast自动隐藏定时器
   */
  private setAutoCancelTimer(opt: GlassShowToastOptions | null): void {
    log.info('setAutoCancelTimer');
    this.removeAutoCancelTimer();
    if (!this.callBack) {
      return;
    }
    if (!opt) {
      return;
    }
    this.timerId = setTimeout(() => {
      this.removeAutoCancelTimer();
      this.hideToast();
    }, opt.duration ? opt.duration : GlassToastConstant.TOAST_DURATION);
  }

  /**
   * 取消Toast自动隐藏定时器
   */
  private removeAutoCancelTimer(): void {
    if (!this.timerId) {
      return;
    }
    clearTimeout(this.timerId);
    this.timerId = undefined;
  }
}

export interface ToastContentCallBack {
  getToast(): GlassShowToastOptions | null;

  notifyToastChange(ntf: GlassShowToastOptions | null): void;
}
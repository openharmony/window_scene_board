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
import type { Rect } from '../../scene/common/GlassSceneManager';
import { GlassLayoutManager } from '../../common/manager/GlassLayoutManager';
import GlassToastConstant from '../common/GlassToastConstant';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';

const TAG = 'GlassShowToastOptions';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);
const WINDOW_LEFT_SCALE: number = 2;

export interface GlassShowToastOptions {
  message: string | Resource;
  duration?: number;
  bottom?: number;
  backgroundColor?: ResourceColor;
  textColor?: ResourceColor;
  backgroundBlurStyle?: BlurStyle;
  shadow?: ShadowOptions | ShadowStyle;
  width?: number;
}

export class GlassToastManager {
  private static instance?: GlassToastManager;
  private windowRect?: Rect;
  private optCallback?: (opt: GlassShowToastOptions) => void;

  private destroy(): void {
    this.optCallback = undefined;
  }

  private constructor() {
  }

  /*
   * 获取当前toast管理单实例
   *
   * @return GlassToastManager
   * */
  public static getInstance(): GlassToastManager {
    if (!GlassToastManager.instance) {
      log.showInfo(`getInstance new instance`);
      GlassToastManager.instance = new GlassToastManager();
    }
    return GlassToastManager.instance;
  }

  /*
   * 注销单实例
   * */
  public static destroyInstance(): void {
    log.showInfo(`destroyInstance`)
    GlassToastManager.instance?.destroy();
    GlassToastManager.instance = undefined;
  }

  /*
   * 初始化窗口rect
   * */
  public init(): void {
    this.windowRect = {
      top: GlassToastConstant.TOAST_TOP,
      left: (GlassLayoutManager.getInstance().getScreenWidthPx() - GlassToastConstant.TOAST_WIDTH) / WINDOW_LEFT_SCALE,
      width: GlassToastConstant.TOAST_WIDTH,
      height: GlassToastConstant.TOAST_HEIGHT
    };
    this.updateWindowRect();
  }

  /*
   * 展示toast
   *
   * @param options
   * */
  public showToast(options: GlassShowToastOptions): void {
    if (!options) {
      log.showInfo(`showToast cancel,options is invalid`);
      return;
    }
    if (this.windowRect && options.bottom) {
      this.windowRect.top = GlassLayoutManager.getInstance().getScreenHeightPx() - options.bottom;
    }
    if (this.windowRect && options.width) {
      this.windowRect.left = (GlassLayoutManager.getInstance().getScreenWidthPx() - options.width) / WINDOW_LEFT_SCALE;
      this.windowRect.width = options.width;
    }
    log.showInfo(`showToast, windowRect is ${JSON.stringify(this.windowRect)}, options.width is ${options.width}`);
    if (this.optCallback) {
      this.updateWindowRect();
      this.optCallback(options);
    }
  }

  /*
   * 设置toast窗口显示隐藏
   *
   * @param visibility
   * */
  public setNtfWindowVisibility(visibility: boolean): void {
    log.info(`setNtfWindowVisibility`);
    if (visibility) {
      GlassSystemSceneManager.getInstance().showSystemView(GlassSystemSceneType.GLASS_TOAST);
    } else {
      GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_TOAST);
    }
  }

  /*
   * 注册配置变更回调
   *
   * @param callback
   * */
  public registerOptChanged(callback: (opt: GlassShowToastOptions) => void): void {
    if (!callback) {
      log.showInfo(`registerOptChanged cancel,callback is invalid`);
      return;
    }
    this.optCallback = callback;
  }

  /*
   * 注销配置变更回调
   * */
  public unregisterOptChanged(): void {
    this.optCallback = undefined;
  }

  /*
   * 获取当前窗口rect
   *
   * @param Rect | undefined
   * */
  public getPanelRect(): Rect | undefined {
    return this.windowRect;
  }

  /*
   * 更新toast窗口宽高坐标
   * */
  private updateWindowRect(): void {
    log.showInfo(`updateWindowRect,rect is undefined ${this.windowRect === undefined}`);
    if (this.windowRect) {
      GlassSystemSceneManager.getInstance().updateWindowRect(GlassSystemSceneType.GLASS_TOAST, {
        top: this.windowRect.top ? -this.windowRect.top : -GlassToastConstant.TOAST_TOP,
        left: this.windowRect.left,
        width: this.windowRect.width,
        height: this.windowRect.height
      });
    }
  }
}
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

import { LogDomain, Logger } from '@ohos/basicutils';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import { AIEffectVoiceCancelNotifyManager } from './AIEffectVoiceCancelNotifyManager';
import { NotDisturbTimerManager } from './NotDisturbTimerManager';
import { SoundPermissionManager } from './SoundPermissionManager';

const TAG = 'PanelManager';
const log = Logger.getLogHelper(LogDomain.SCB);

export interface PanelManagerBase {

  /*
   * 组件初始化接口，在Panel组件aboutToAppear中被调用
   */
  init: () => void;

  /*
   * 组件销毁接口，在Panel组件aboutToDisappear中被调用
   */
  destroy: () => void;
}

export interface PanelStateChangeListener {
  /*
   * 在Panel组件打开/关闭时被调用
   */
  onPanelForegroundStatusChange?: (isPanelForeground: boolean) => void;

  /*
   * 在切换系统语言时被调用
   */
  onLanguageChange?: () => void;
};

export class PanelManager {
  private static instance: PanelManager;
  private baseList: PanelManagerBase[] = [];
  private panelStateChangeListeners = new Set<PanelStateChangeListener>();
  private isPanelForeground: boolean = false;

  private constructor() {
    if (DeviceHelper.isPcNot2in1Device()) {
      this.baseList.push(NotDisturbTimerManager.getInstance());
    }
    this.baseList.push(SoundPermissionManager.getInstance());
    this.baseList.push(AIEffectVoiceCancelNotifyManager.getInstance());
  }

  public static getInstance(): PanelManager {
    if (PanelManager.instance) {
      return PanelManager.instance;
    }
    PanelManager.instance = new PanelManager();
    return PanelManager.instance;
  }

  public registerPanelStateChangeListener(listener: PanelStateChangeListener, caller: string): void {
    if (!listener) {
      log.showError(TAG, `${caller} registerPanelStateChangeListener invalid listener`);
      return;
    }
    this.panelStateChangeListeners.add(listener);
    log.showInfo(TAG, `${caller} register panelStateChangeListeners size: ${this.panelStateChangeListeners.size}`);
  }

  public unregisterPanelStateChangeListener(listener: PanelStateChangeListener, caller: string): void {
    if (!listener) {
      log.showError(TAG, `${caller} unregisterPanelStateChangeListener invalid listener`);
      return;
    }
    this.panelStateChangeListeners.delete(listener);
    log.showInfo(TAG, `${caller} unregister panelStateChangeListeners size: ${this.panelStateChangeListeners.size}`);
  }

  public getPanelForegroundStatus(): boolean {
    return this.isPanelForeground;
  }

  public init(): void {
    this.baseList.forEach((item) => {
      item.init();
    })
  }

  public destroy(): void {
    this.baseList.forEach((item) => {
      item.destroy();
    })
  }

  public onPageShow(): void {
    this.isPanelForeground = true;
    this.panelStateChangeListeners.forEach((item) => {
      item.onPanelForegroundStatusChange?.(true);
    })
  }

  public onPageHide(): void {
    this.isPanelForeground = false;
    this.panelStateChangeListeners.forEach((item) => {
      item.onPanelForegroundStatusChange?.(false);
    })
  }
  
  public onLanguageChange(): void {
    this.panelStateChangeListeners.forEach((item) => {
      item.onLanguageChange?.();
    })
  }
}
// @ts-nocheck
/**
 * Copyright (c) 2021-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import display from '@ohos.display';
import featureAbility from '@ohos.ability.featureAbility';
import window from '@ohos.window';
import { LogDomain, LogHelper } from '@ohos/basicutils';

const TAG = 'WindowManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

export type WindowInfo = {
  visibility: boolean;
};

const DEFAULT_WINDOW_INFO: WindowInfo = {
  visibility: false
};

/**
 * Wrapper class for window interfaces.
 */
class WindowManager {
  private mDisplayData = null;

  private mIsSystemBarOfDockShow: boolean = true;

  RECENT_WINDOW_NAME = 'RecentView';

  DESKTOP_WINDOW_NAME = 'EntryView';

  APP_CENTER_WINDOW_NAME = 'AppCenterView';

  DOCK_WINDOW_NAME = 'DockView';

  FORM_MANAGER_WINDOW_NAME = 'FormManagerView';

  WALLPAPER_WINDOW_NAME = 'WallpaperView';

  GESTURENAV_WINDOW_NAME = 'GestureBackView';

  DESKTOP_RANK = window.WindowType.TYPE_DESKTOP;

  RECENT_RANK = window.WindowType.TYPE_LAUNCHER_RECENT;

  APP_CENTER_RANK = window.WindowType.TYPE_LAUNCHER_RECENT;

  FORM_MANAGER_RANK = 2100;

  DOCK_RANK = window.WindowType.TYPE_LAUNCHER_DOCK;

  WALLPAPER_RANK = window.WindowType.TYPE_WALLPAPER;

  GESTURENAV_RANK = window.WindowType.TYPE_FLOAT;

  SYSTEM_BAR_TINT_CHANGE = 'systemBarTintChange';

  STARTUP_GUIDE_PROCESS_NAME = 'com.ohos.startupguide';

  mWindowInfos: Map<string, WindowInfo> = new Map();

  /**
   * get WindowManager instance
   *
   * @return WindowManager singleton
   */
  static getInstance(): WindowManager {
    if (globalThis.WindowManager == null) {
      globalThis.WindowManager = new WindowManager();
    }
    return globalThis.WindowManager;
  }

  /**
   * 获取全屏窗口宽度
   *
   * @return 窗口宽度
   */
  getWindowWidth(): number {
    if (this.mDisplayData == null) {
      this.mDisplayData = this.getWindowDisplayData();
    }
    return px2vp(this.mDisplayData.width);
  }

  /**
   * 获取全屏窗口高度
   *
   * @return 窗口高度
   */
  getWindowHeight(): number {
    if (this.mDisplayData == null) {
      this.mDisplayData = this.getWindowDisplayData();
    }
    if (this.mDisplayData) {
      return px2vp(this.mDisplayData.height);
    } else {
      return 0;
    }
  }

  private getWindowDisplayData(): Display | null {
    let displayData = null;
    try {
      displayData = display.getDefaultDisplaySync();
    } catch (err) {
      log.error('getWindowDisplayData error', error);
    }
    return displayData;
  }

  isSplitWindowMode(mode): boolean {
    if ((mode === featureAbility.AbilityWindowConfiguration.WINDOW_MODE_SPLIT_PRIMARY) ||
    (mode === featureAbility.AbilityWindowConfiguration.WINDOW_MODE_SPLIT_SECONDARY)) {
      return true;
    }
    return false;
  }

  /**
   * 隐藏状态栏
   *
   * @param name windowName
   */
  hideWindowStatusBar(name: string): void {
    let names: Array<'status' | 'navigation'> = ['navigation'];
    this.setWindowSystemBar(name, names);
  }

  /**
   * 显示状态栏
   *
   * @param name
   */
  showWindowStatusBar(name: string): void {
    let names: Array<'status' | 'navigation'> = ['navigation', 'status'];
    this.setWindowSystemBar(name, names);
  }

  /**
   * 设置状态栏与导航栏显隐
   *
   * @param windowName
   * @param names 值为 'status'|'navigation' 枚举
   */
  private setWindowSystemBar(windowName: string, names: Array<'status' | 'navigation'>): void {
    this.findWindow(windowName, win => {
      win.setWindowSystemBarEnable(names).then(() => {
        log.showInfo('set statusBar success');
      }).catch(err => {
        log.error('setWindowSystemBar error', err);
      });
    });
  }

  hideWindow(name: string, callback?: Function): void {
    log.showInfo(`hideWindow, name ${name}`);
    this.findWindow(name, (win) => {
      log.showInfo(`hideWindow, findWindow callback name: ${name}`);
      win.hide().then(() => {
        this.mWindowInfos.set(name, { ...(this.mWindowInfos.get(name) ?? DEFAULT_WINDOW_INFO), visibility: false });
        log.showInfo(`hideWindow, hide then name: ${name}`);
        if (callback) {
          callback(win);
        }
      });
    });
  }

  minimizeAllApps(): void {
    display.getDefaultDisplay().then(dis => {
      window.minimizeAll(dis.id).then(() => {
        log.showInfo('Launcher minimizeAll');
      });
    });
    this.destroyWindow(this.FORM_MANAGER_WINDOW_NAME);
  }

  destroyWindow(name: string, callback?: Function): void {
    log.showInfo(`destroyWindow, name ${name}`);
    this.findWindow(name, (win) => {
      log.showInfo(`hideWindow, findWindow callback name: ${name}`);
      win.destroy().then(() => {
        this.mWindowInfos.set(name, { ...(this.mWindowInfos.get(name) ?? DEFAULT_WINDOW_INFO), visibility: false });
        log.showInfo(`destroyWindow, destroy then name: ${name}`);
        if (callback) {
          callback(win);
        }
      });
    });
  }

  findWindow(name: string, callback?: Function): void {
    log.showInfo(`findWindow, name ${name}`);
    void window.find(name)
      .then((win) => {
        log.showInfo(`findWindow, find then name: ${name}`);
        if (callback) {
          callback(win);
        }
      });
  }
}

export const windowManager = WindowManager.getInstance();

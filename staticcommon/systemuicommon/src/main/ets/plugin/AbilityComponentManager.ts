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

import Context from '@ohos.app.ability.common';
import Window from '@ohos.window';
import { CommonUtils, ArrayUtils, SingletonHelper, LogDomain, LogHelper } from '@ohos/basicutils';
import { windowMgr, WindowAnimMgr, } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { PluginConstants } from '@ohos/frameworkwrapper';

const TAG = "SysUI-AbilityComponentManager";
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 等待获取context类型
 */
type ContextResolve = (context: Context.BaseContext | PromiseLike<Context.BaseContext>) => void;

/**
 * AbilityComponent组件使用管理
 *
 * @since 2022-10-22
 */
class AbilityComponentManager {
  /**
   * 用于window创建的context
   */
  private windowContext: Context.BaseContext;

  /**
   * 窗口根布局，用于承载AbilityComponent组件
   */
  private pageContent: string;

  /**
   * 缓存等待context
   */
  private contextResolves: Set<ContextResolve> = new Set();

  /**
   * 缓存已创建Ability Window
   * 窗口名 => 窗口
   */
  private windows: Map<string, Window.Window> = new Map();

  /**
   * 初始化
   *
   * @param context 环境，用于窗口创建
   * @param pageContent 窗口根布局
   */
  init(context: Context.BaseContext, pageContent: string): void {
    this.windowContext = context;
    this.pageContent = pageContent;
    // 等待回调
    if (!ArrayUtils.isEmpty(this.contextResolves)) {
      this.contextResolves.forEach((resolve) => {
        resolve(context);
      });
      this.contextResolves.clear();
    }
  }

  /**
   * 创建承载AbilityComponent的窗口
   *
   * @param windowName 窗口名称
   * @param position 窗口位置
   * @param bundleName AbilityComponent包名
   * @param abilityName AbilityComponent组件名
   */
  async createAbilityWindow(windowName: string, position: Window.Rect, bundleName: string, abilityName: string):
    Promise<Window.Window> {
    return new Promise((resolve) => {
      if (CommonUtils.isEmpty(bundleName) || CommonUtils.isEmpty(abilityName)) {
        log.showWarn('createAbilityWindow param invalid');
        return;
      }
      this.getContext().then((context) => {
        let storage = new LocalStorage();
        storage.setOrCreate(PluginConstants.STORAGE_KEY_PLUGIN_SLOT, windowName);
        storage.setOrCreate(PluginConstants.STORAGE_KEY_BUNDLE_NAME, bundleName);
        storage.setOrCreate(PluginConstants.STORAGE_KEY_ABILITY_NAME, abilityName);
        windowMgr.createWindow(windowName, context, position, this.pageContent, storage).then((window) => {
          log.showInfo('createAbilityWindow: ' + windowName);
          this.windows.set(windowName, window);
          // 设置窗口动画
          windowMgr.setWindowAnim(windowName, WindowAnimMgr.createPcPanelWinAnim(window));
          // 默认圆角
          windowMgr.updateWindowRadius(windowName, WindowConstants.getDefaultRadius());
          // 窗口背景模糊
          windowMgr.setWindowBackBlur(windowName, WindowConstants.BLUR_BG_COLOR);
          // 窗口阴影
          windowMgr.setWindowShadow(windowName, WindowConstants.SHADOW_RADIUS, WindowConstants.SHADOW_COLOR,
            WindowConstants.SHADOW_OFFSET_X, WindowConstants.SHADOW_OFFSET_Y);
          resolve(window);
        });
      });
    });
  }

  /**
   * 销毁所有窗口
   */
  destroyAllAbilityWindow(): void {
    log.showInfo('destroyAllAbilityWindow');
    this.windows.forEach((window, windowName) => {
      windowMgr.destroyWindow(windowName);
    });
    this.windows.clear();
  }

  /**
   * 销毁窗口
   *
   * @param windowName 窗口名
   */
  destroyAbilityWindow(windowName: string): void {
    if (this.windows.delete(windowName)) {
      log.showInfo('destroyAbilityWindow: ' + windowName);
      windowMgr.destroyWindow(windowName);
    }
  }

  /**
   * 获取context
   *
   * @return 窗口context
   */
  private async getContext(): Promise<Context.BaseContext> {
    if (!CommonUtils.isInvalid(this.windowContext)) {
      return this.windowContext;
    }
    return new Promise((resolve) => {
      this.contextResolves.add(resolve);
    });
  }
}

// 单例
export let AbilityComponentMgr = SingletonHelper.getInstance(AbilityComponentManager, TAG);
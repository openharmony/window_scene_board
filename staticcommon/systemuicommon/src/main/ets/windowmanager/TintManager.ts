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

import { SingletonHelper, CommonUtils, ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { EvtBus, StatusBarTintEvent, } from '@ohos/frameworkwrapper';
import { DisplayConstants } from '@ohos/windowscene';
import Window from '@ohos.window';
import Context from '@ohos.app.ability.common';

const TAG = 'SysUI_TintManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 状态栏窗口类型
 */
const TYPE_STATUS_BAR = Window.WindowType.TYPE_STATUS_BAR;

/**
 * 状态栏/导航栏沉浸式管理
 *
 * @since 2022-11-17
 */

class TintManager {
  /**
   * 当前displayID
   */
  private currentDisplayId: number = DisplayConstants.INVALID_DISPLAY;

  /**
   * 状态栏沉浸式变化事件
   */
  private sbTintEvent: StatusBarTintEvent = new StatusBarTintEvent();

  /**
   * 初始化
   */
  init(context: Context.ExtensionContext): void {
    // 当前display
    this.currentDisplayId = context.config?.displayId;
    if (this.currentDisplayId === DisplayConstants.INVALID_DISPLAY) {
      this.currentDisplayId = DisplayConstants.DEFAULT_DISPLAY;
    }
    // 生产者事件
    EvtBus.produceOn(StatusBarTintEvent, (): StatusBarTintEvent => this.sbTintEvent);
  }

  /**
   * 沉浸式状态变化回调
   *
   * @param state 当前状态
   */
  private onSystemBarTintChange(state: Window.SystemBarTintState): void {
    log.showDebug('onSystemBarTintChange ' + state?.displayId + ', cur: ' + this.currentDisplayId +
      ', type: ' + TYPE_STATUS_BAR);
    if (CommonUtils.isInvalid(state)) {
      return;
    }
    // 屏幕不匹配
    if (state.displayId !== this.currentDisplayId) {
      return;
    }
    // 无沉浸式
    if (ArrayUtils.isEmpty(state.regionTint)) {
      return;
    }
    // 状态栏类型
    let sbRegionTint: Array<Window.SystemBarRegionTint> = new Array();
    state.regionTint.forEach((tint) => {
      // 过滤状态栏
      if (tint.type !== TYPE_STATUS_BAR) {
        return;
      }
      sbRegionTint.push(tint);
    });
    this.sbTintEvent.regionTint = sbRegionTint;
    // 发送事件
    this.postEvent();
  }

  /**
   * 发送状态栏沉浸式事件
   */
  private postEvent(): void {
    EvtBus.post(StatusBarTintEvent, this.sbTintEvent);
    log.showInfo('postEvent');
  }
}

// 单例
export let TintMgr: TintManager = SingletonHelper.getInstance(TintManager, TAG);
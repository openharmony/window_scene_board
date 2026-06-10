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
import type ctx from '@ohos.app.ability.common';
import type { BusinessError } from '@ohos.base';
import { CommonUtils } from '@ohos/basicutils/src/main/ets/utils/CommonUtils';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { SingletonHelper } from '@ohos/basicutils/src/main/ets/utils/SingletonHelper';
import { GlobalContext } from '../TsIndex';

const TAG = 'EventHubManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);

/**
 * context中EventHub工具管理
 */
class EventHubManager {
  /**
   * 大桌面context
   */
  private desktopCtx?: ctx.ServiceExtensionContext;

  /**
   * 注册事件
   *
   * @param event 事件名
   * @param callback 事件回调函数
   */
  on(event: string, callback: Function): void {
    try {
      this.getContext()?.eventHub?.on(event, callback);
    } catch (e) {
      let error = e as BusinessError;
      log.showError('on error: ' + event + ', ' + error?.message);
    }
  }

  /**
   * 注销事件
   *
   * @param event 事件名
   * @param callback 回调函数
   */
  off(event: string, callback?: Function): void {
    try {
      this.getContext()?.eventHub?.off(event, callback);
    } catch (e) {
      let error = e as BusinessError;
      log.showError('off error: ' + event + ', ' + error?.message);
    }
  }

  /**
   * 事件发送
   *
   * @param event 事件名
   * @param args 事件参数
   */
  emit(event: string, ...args: Object[]): void {
    try {
      this.getContext()?.eventHub?.emit(event, args);
    } catch (e) {
      let error = e as BusinessError;
      log.showError('emit error: ' + event + ', ' + error?.message);
    }
  }

  /**
   * 获取context
   *
   * @returns ctx
   */
  private getContext(): ctx.ServiceExtensionContext | undefined {
    if (CommonUtils.isInvalid(this.desktopCtx)) {
      this.desktopCtx = GlobalContext.getContext();
    }
    if (CommonUtils.isInvalid(this.desktopCtx)) {
      log.showWarn('getContext fail.');
    }
    return this.desktopCtx;
  }
}

// 单例
export let evtHubMgr: EventHubManager = SingletonHelper.getInstance(EventHubManager, TAG);
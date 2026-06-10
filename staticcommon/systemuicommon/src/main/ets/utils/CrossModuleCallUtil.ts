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

const TAG = 'CrossModuleCallUtil';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 跨模块调用方法定义
 */
interface CrossModuleCallFn {
  /**
   * 判断通知中心是否有指定的通知
   * @param uid 应用uid
   * @param notificationId 通知ID
   * @returns 如果通知中心有指定的通知则返回true
   */
  hasNotification: (uid: number, notificationId: number) => boolean;

  /**
   * pad模式下状态栏鼠标点击事件判断
   * @param leftArea 鼠标悬浮/点击时间组
   * @param rightArea 鼠标悬浮/点击电池组
   * @returns 如果状态栏被禁用返回false
   */
  onMouseStyleEvent: (leftArea: boolean, rightArea: boolean) => boolean;
}

/**
 * 跨模块调用方法的工具，用来解决同层模块间调用的问题，避免同层模块横向依赖
 */
class CrossModuleCallUtil {
  private fnMap: Map<keyof CrossModuleCallFn, CrossModuleCallFn[keyof CrossModuleCallFn]> = new Map();

  /**
   * 注册一个方法
   * @param fnName 方法名
   * @param fn 方法回调体
   */
  register<N extends keyof CrossModuleCallFn>(fnName: N, fn: CrossModuleCallFn[N]): void {
    this.fnMap.set(fnName, fn);
  }

  /**
   * 取消注册一个方法
   * @param fnName 方法名
   */
  unregister<N extends keyof CrossModuleCallFn>(fnName: N): void {
    this.fnMap.delete(fnName);
  }

  /**
   * 检查方法是否已经注册
   * @param fnName 方法名
   * @returns
   */
  hasRegistered<N extends keyof CrossModuleCallFn>(fnName: N): boolean {
    return this.fnMap.has(fnName);
  }

  /**
   * 调用方法
   * @param fnName 方法名
   * @param args 方法参数
   * @returns 方法返回结果
   */
  call<N extends keyof CrossModuleCallFn>(fnName: N, ...args: Parameters<CrossModuleCallFn[N]>):
    ReturnType<CrossModuleCallFn[N]> {
    const fn = this.fnMap.get(fnName) as Function;
    if (!fn) {
      log.error(`Function ${fnName as string} is not registered.`);
      return undefined as unknown as ReturnType<CrossModuleCallFn[N]>;
    }
    return fn(...args) as unknown as ReturnType<CrossModuleCallFn[N]>;
  }
}

export const crossModuleCallUtil = new CrossModuleCallUtil();
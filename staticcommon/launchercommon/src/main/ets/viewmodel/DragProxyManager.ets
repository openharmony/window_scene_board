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
import { IDesktopDragHandler } from './IDesktopDragHandler';
import { IDockDragHandler } from './IDockDragHandler';

const TAG = 'DragProxyManager';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

export class DragProxyManager {
  private static instance: DragProxyManager;

  private array: Array<ProxyDragHandler> = [];

  private constructor() {
  }

  public static getInstance(): DragProxyManager {
    if (!DragProxyManager.instance) {
      DragProxyManager.instance = new DragProxyManager();
    }
    return DragProxyManager.instance;
  }

  /**
   * 注册feature层拖拽业务类
   *
   * @param type 业务类型
   * @param handler 业务处理handler
   */
  public register(type: DragHandlerType, handler: ProxyDragHandler): void {
    if (this.array[type]) {
      log.showWarn(TAG, `the view model(${type}) has been registered, we will replace it ..`);
    }
    this.array[type] = handler;
  }

  /**
   * 根据业务类型获取业务DragHandler
   *
   * @param type 业务类型
   * @returns 业务handler
   */
  public get(msg: string, type: DragHandlerType): ProxyDragHandler | undefined {
    const handler: ProxyDragHandler | undefined = this.array[type];
    if (!handler) {
      log.showWarn(TAG, '(%{public}s) get the handler %{public}d fail with not register', msg, type);
    }
    return handler;
  }
}

export type ProxyDragHandler = IDesktopDragHandler | IDockDragHandler;

/**
 * 业务类型的枚举
 */
export enum DragHandlerType {
  DESKTOP,
  DOCK
}
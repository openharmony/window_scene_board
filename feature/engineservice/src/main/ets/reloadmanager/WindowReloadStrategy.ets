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

import lazy ArrayList from '@ohos.util.ArrayList';
import { Log } from '../utils/Log';
import lazy { ReloadStrategy, WindowReloadListener } from './ReloadStrategy';

const TAG: string = 'WindowReloadStrategy';

/**
 * Defines action for scenarios that requires the window reload on device status change
 *
 * @since 2024-03-25
 */
export class WindowReloadStrategy implements ReloadStrategy {
  // List of listeners that registered by the resource usage objects.
  public listenerList: ArrayList<WindowReloadListener> = new ArrayList<WindowReloadListener>();

  private static instance: WindowReloadStrategy;

  /**
   * Get the strategy's singleton instance
   *
   * @returns Singleton instance of window reload strategy
   */
  public static getInstance(): WindowReloadStrategy {
    if (!WindowReloadStrategy.instance) {
      WindowReloadStrategy.instance = new WindowReloadStrategy();
    }
    return WindowReloadStrategy.instance;
  }

  /**
   * Notify all registered listeners when reload was request by the engine client
   *
   * @param reloadParam Including resource qualifier for current device status
   */
  public onReloadRequested(reloadParam: object): void {
    if (!reloadParam) {
      Log.error(TAG, 'reloadParam is null.')
      return;
    }
    let isKeyInvalid: boolean = reloadParam['resourceQualifier'] === undefined ||
      reloadParam['screenWidth'] === undefined || reloadParam['screenHeight'] === undefined;
    let isValueInvalid: boolean = Number.isNaN(reloadParam['resourceQualifier']) ||
      Number.isNaN(reloadParam['screenWidth']) || Number.isNaN(reloadParam['screenHeight']);
    if (isKeyInvalid || isValueInvalid) {
      Log.warn(TAG, 'onReloadRequested reloadParam is invalid');
      return;
    }
    this.listenerList.forEach((listener) => {
      listener.reloadWindow(reloadParam['resourceQualifier'] as number, reloadParam['screenWidth'] as number,
        reloadParam['screenHeight'] as number);
    });
  }

  /**
   * Register object's listener for calling when requested
   *
   * @param listener Custom listener for device status update
   */
  public addReloadListener(listener: WindowReloadListener): void {
    this.listenerList.add(listener);
  }

  /**
   * Remove existing listener when not in use
   *
   * @param listener Listener that to be removed
   */
  public removeReloadListener(listener: WindowReloadListener): void {
    if (!this.listenerList.has(listener)) {
      return;
    }

    try {
      this.listenerList.remove(listener);
    } catch (err) {
      Log.error(TAG, `Error on removing reload listener ${err.code}`);
    }
  }
}
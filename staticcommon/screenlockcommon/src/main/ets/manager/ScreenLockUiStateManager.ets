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

import { CommonUtils, SingletonHelper } from '@ohos/basicutils';
import { SlMainStateType, SlSubStateType } from '../constants/SlStateType';
import { ISlState } from '../interface/ISlState';
import { ISlStateChangeListener } from '../interface/ISlStateChangeListener';

const TAG = 'ScreenLockUiStateManager';

/**
 * 锁屏页面状态变量统一管理
 */
export class ScreenLockUiStateManager {
  private slAllState: Map<SlMainStateType, ISlState | undefined> = new Map(); // 锁屏页面全状态管理
  private slStateListeners: Map<SlMainStateType, Set<ISlStateChangeListener>> = new Map(); // 锁屏页面状态变化监听器集
  private onSlStateChangeListener: ISlStateChangeListener = { // 锁屏状态切换监听
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType) => this.notifyStateChange(mainType, subType)
  };

  public setSlState(mainType: SlMainStateType, state?: ISlState): void { // 缓存锁屏主类型状态
    let oldState = this.slAllState.get(mainType);
    if (oldState !== state) {
      if (oldState) { // 注销状态切换监听
        oldState.slStateChangeListener = undefined;
      }
      if (state) { // 状态切换监听统一管理
        state.slStateChangeListener = this.onSlStateChangeListener;
      }
      this.slAllState.set(mainType, state);
      this.notifyStateChange(mainType);
    }
  }

  public getSlState(mainType: SlMainStateType): ISlState | undefined { // 获取锁屏主类型状态
    return this.slAllState.get(mainType);
  }

  public registerSlStateChangeListener(listener: ISlStateChangeListener, slMainType?: SlMainStateType): () => void {
    // 注册锁屏状态切换监听
    let mainType = slMainType ?? listener?.slMainStateType;
    if (mainType) {
      let listeners = this.slStateListeners.get(mainType);
      if (CommonUtils.isInvalid(listeners)) {
        listeners = new Set();
        this.slStateListeners.set(mainType, listeners);
      }
      listeners?.add(listener);
      return () => this.unregisterSlStateChangeListener(listener, slMainType);
    }
    return () => {};
  }

  public unregisterSlStateChangeListener(listener: ISlStateChangeListener, slMainType?: SlMainStateType): void {
    // 注销锁屏状态监听
    let mainType = slMainType ?? listener?.slMainStateType;
    if (mainType) {
      this.slStateListeners.get(mainType)?.delete(listener);
    }
  }

  private notifyStateChange(mainType: SlMainStateType, subType?: SlSubStateType): void { // 通知状态切换
    this.slStateListeners?.get(mainType)?.forEach((listener) => {
      listener?.onSlStateChange?.(mainType, subType);
    });
  }
}

// 单例
export let slUiStateMgr: ScreenLockUiStateManager = SingletonHelper.getInstance(ScreenLockUiStateManager, TAG);
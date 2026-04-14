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

import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import {
  OneMirrorStaticStateType,
  SlMainStateType,
  SlSubStateType,
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ImmersiveConstants } from '../../common/ImmersiveConstants';

const TAG: string = 'ImmersiveEventStopHandle';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);
const MAX_LISTENER_LENGTH = 100;
/**
 * 沉浸锁屏事件拦截监听
 */
export interface IImmersiveEventStopListener {
  onEventStop: (isStop: boolean) => void; // 事件是否拦截变化回调
}

/**
 * 沉浸锁屏事件拦截
 */
export class ImmersiveEventStopHandle {
  // 是否强制拦截事件
  private isStopEvent: boolean = false;

  // 事件拦截监听
  private eventStopListeners: Set<IImmersiveEventStopListener> = new Set(); // 事件拦截监听集

  /**
   * 锁屏状态切换监听器
   */
  private slStaticStateListener: ISlStateChangeListener = {
    slMainStateType: SlMainStateType.SL_ONE_MIRROR_STATIC_STATE,
    onSlStateChange: (mainType: SlMainStateType, subType?: SlSubStateType): void => {
      // 胶囊上划或者列表下划过程中，如果灭屏，需要恢复位置
      if (subType !== OneMirrorStaticStateType.ONE_MIRROR_ANIM_STATE &&
        subType !== OneMirrorStaticStateType.IS_AOD_SHOWING) {
        return;
      }

      let slOneMirrorState = slUiStateMgr.getSlState(SlMainStateType.SL_ONE_MIRROR_STATIC_STATE);
      let stopState = slOneMirrorState?.getSlState(OneMirrorStaticStateType.ONE_MIRROR_ANIM_STATE) as boolean ||
        slOneMirrorState?.getSlState(OneMirrorStaticStateType.IS_AOD_SHOWING) as boolean;
      if (stopState !== this.isStopEvent) {
        log.showInfo(`stop event state change, isStopEvent=${stopState}`);
        this.isStopEvent = stopState;
        this.eventStopListeners.forEach((listener) => {
          listener?.onEventStop(this.isStopEvent);
        })
      }
    }
  };

  /**
   * 初始化
   */
  init(): void {
    slUiStateMgr.registerSlStateChangeListener(this.slStaticStateListener);
  }

  /**
   * 释放资源
   */
  destroy(): void {
    slUiStateMgr.unregisterSlStateChangeListener(this.slStaticStateListener);
  }

  /**
   * 注册事件拦截监听
   */
  public registerEventStopListener(listener: IImmersiveEventStopListener): void {
    // 已注册长度超过MAX_LISTENER_LENGTH时禁止注册，防止内存溢出
    if (!listener || this.eventStopListeners.has(listener) || this.eventStopListeners.size > MAX_LISTENER_LENGTH) {
      return;
    }
    this.eventStopListeners.add(listener);
  }

  /**
   * 解注册事件拦截监听
   */
  public unregisterEventStopListener(listener: IImmersiveEventStopListener): void {
    if (!listener || !this.eventStopListeners.has(listener)) {
      return;
    }
    this.eventStopListeners.delete(listener);
  }
}

// 默认事件拦截器
export const defaultStopHandle: ImmersiveEventStopHandle = new ImmersiveEventStopHandle();
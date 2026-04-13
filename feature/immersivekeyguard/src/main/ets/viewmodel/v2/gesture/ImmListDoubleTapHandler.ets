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

import {
  IBaseStateChangeListener,
  SlImmBindStPt,
  SlStateId,
  StateType
} from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ScreenLockNotificationConst, screenLockSysFloatTipControl } from '@ohos/screenlockcommon/Index';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { slImmBindSt } from '../../../model/data/v2/SlImmBindStateV2';
import { ImmBaseDoubleTapHandler } from './ImmBaseDoubleTapHandler';

/**
 * 沉浸列表条目单双击处理
 */
export abstract class ImmListDoubleTapHandler extends ImmBaseDoubleTapHandler {
  // 点击回调
  protected _callback?: () => void;

  /**
   * 设置点击回调
   *
   * @param callback 点击回调
   */
  public setClickCallback(callback?: () => void): void {
    if (!callback) {
      this._callback = undefined;
      slImmBindSt.unregisterStateChangeListener(this.onSecureLockedStateChange);
      return;
    }
    this._callback = callback;
    slImmBindSt.registerStateChangeListener(this.onSecureLockedStateChange);
    this._isDoubleTapSupported = slImmBindSt.isSecureAndLocked();
  }

  /**
   * 弹出提示
   *
   * @param tip 提示语
   */
  protected promptFloatTip(tip: string): void {
    const componentId = ScreenLockNotificationConst.NTF_KEY_GUARD_TIP;
    screenLockSysFloatTipControl.setTipMessage(componentId,
      ResUtils.getInnerStringByName(tip));
    screenLockSysFloatTipControl.setFloatTipDialogVisible(componentId, true,
      ScreenLockNotificationConst.CLICK_TOAST_SHOW_DURATION);
  }

  /**
   * 锁屏上锁状态监听回调
   */
  private onSecureLockedStateChange: IBaseStateChangeListener = {
    listenerName: 'ImmNormalItemDoubleTapHandler_secure_locked_state_listener',
    onStateChange: (stateType: StateType, stateId: SlStateId, property?: SlImmBindStPt | undefined): void => {
      // 锁屏上锁状态切换时，同步更新是否支持双击
      if (property === SlImmBindStPt.PT_SECURE_LOCKED) {
        this._isDoubleTapSupported = slImmBindSt.isSecureAndLocked();
      }
    }
  }
}
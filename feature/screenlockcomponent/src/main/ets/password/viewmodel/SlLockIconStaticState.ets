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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import {
  LockIconStaticStateType,
  SlMainStateType,
  WidgetStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ISlStateChangeListener } from '@ohos/screenlockcommon/src/main/ets/interface/ISlStateChangeListener';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';

const TAG = 'SlLockIconStaticState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁头非UI状态变量管理
 */
export class SlLockIconStaticState extends WidgetStaticState<LockIconStaticStateType> {
  public slStateChangeListener?: ISlStateChangeListener | undefined; // 复写ISlState
  private slLockIconAnimCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);

  constructor() {
    super(SlMainStateType.SL_LOCK_ICON_WG_STATIC_STATE);
  }

  protected initSetMethods(): void { // 复写 WidgetStaticState
  }

  protected initGetMethods(): void { // 复写 WidgetStaticState
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlLockIconAnimCtrl);
  }

  private getMethodSlLockIconAnimCtrl(st: SlLockIconStaticState): WidgetAnimState {
    return st.getSlLockIconAnimCtrl();
  }

  public getSlLockIconAnimCtrl(): WidgetAnimState { // 获取锁头动效管理
    return this.slLockIconAnimCtrl;
  };
}
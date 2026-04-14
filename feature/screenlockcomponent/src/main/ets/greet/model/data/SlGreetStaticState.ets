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
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import {
  SlGreetStaticStateType,
  SlMainStateType,
  WidgetStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';

const TAG = 'SlGreetStaticState';

export class SlGreetStaticState extends WidgetStaticState<SlGreetStaticStateType> {
  private slLockGreetAnimCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);

  constructor() {
    super(SlMainStateType.SL_LOCK_GREET_WG_STATIC_STATE);
  }

  protected initGetMethods(): void { // 复写 WidgetStaticState
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlLockGreetAnimCtrl);
  }

  private getMethodSlLockGreetAnimCtrl(st: SlGreetStaticState): WidgetAnimState {
    return st.getSlLockGreetAnimCtrl();
  }

  public getSlLockGreetAnimCtrl(): WidgetAnimState { // 获取锁头动效管理
    return this.slLockGreetAnimCtrl;
  };
}
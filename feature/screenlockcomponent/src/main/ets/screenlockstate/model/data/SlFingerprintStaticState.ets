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

import {
  FingerprintStaticStateType,
  SlMainStateType,
  WidgetStaticStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';

const TAG = 'SlFingerprintStaticState';

/**
 * 锁屏指纹非UI状态变量管理
 */
export class SlFingerprintStaticState extends WidgetStaticState<FingerprintStaticStateType> {
  private animCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);

  constructor() {
    super(SlMainStateType.SL_FINGERPRINT_WG_STATIC_STATE);
  }

  protected initSetMethods(): void { // 复写 WidgetStaticState
  }

  protected initGetMethods(): void { // 复写 WidgetStaticState
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL,
      (st: SlFingerprintStaticState): WidgetAnimState => st.getSlFingerAnimCtrl());
  }

  public getSlFingerAnimCtrl(): WidgetAnimState {
    return this.animCtrl;
  };
}
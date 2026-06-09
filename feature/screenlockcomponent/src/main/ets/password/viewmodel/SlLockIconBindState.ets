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

import { ArrayUtils } from '@ohos/basicutils';
import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { LockIconBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BlurFreezeScene } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';

const DEFAULT_FREEZE_SCENE = 'default_freeze_scene';

// 锁屏组件，通知列表组件UI绑定状态
@Observed
export class SlLockIconBindState extends WidgetBindState<LockIconBindStateType> {
  @Track private _isChangeColor: boolean = false;

  public setChangeColor(value: boolean):void {
    this._isChangeColor = value;
  }

  public getChangeColor(): boolean {
    return this._isChangeColor;
  }

  constructor() {
    super(SlMainStateType.SL_LOCK_ICON_WG_BIND_STATE);
  }
}
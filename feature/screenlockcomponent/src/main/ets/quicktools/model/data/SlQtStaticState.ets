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

import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { QtStaticStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

const TAG = 'SlQtStaticState';

// 锁屏组件，快捷工具图标组件静态状态管理
export class SlQtStaticState extends WidgetStaticState<QtStaticStateType> {
  private slQtAnimCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);

  constructor() {
    super(SlMainStateType.SL_QT_WG_STATIC_STATE);
  }

  public getSlQtAnimCtrl(): WidgetAnimState {
    return this.slQtAnimCtrl;
  };
}
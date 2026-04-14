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
  OuterToolsStaticStateType,
  SlMainStateType,
  WidgetStaticStateType,
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

const TAG = 'SlOuterToolsStaticState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏小外屏底部工具非UI状态变量管理
 */
export class SlOuterToolsStaticState extends WidgetStaticState<OuterToolsStaticStateType> {
  private slOuterToolsAnimCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);

  constructor() {
    super(SlMainStateType.SL_OUTER_TOOL_WG_STATIC_STATE);
  }

  // 复写 WidgetStaticState
  protected initSetMethods(): void {
    super.initSetMethods();
  }

  private getMethodSlOuterToolsAnimCtrl(st: SlOuterToolsStaticState): WidgetAnimState {
    return st.getSlOuterToolsAnimCtrl();
  }

  // 复写 WidgetStaticState
  protected initGetMethods(): void {
    super.initGetMethods();
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlOuterToolsAnimCtrl);
  }

  // 获取锁屏小外屏底部工具动效管理
  public getSlOuterToolsAnimCtrl(): WidgetAnimState {
    return this.slOuterToolsAnimCtrl;
  };
}
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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { OuterFormStaticStateType, SlMainStateType,
  WidgetStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';

const TAG = 'SlOuterFormStaticState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏小外屏服务卡片非UI状态变量管理
 */
export class SlOuterFormStaticState extends WidgetStaticState<OuterFormStaticStateType> {
  private slOuterFormAnimCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);
  private opacity: number = 1; // 透明度 //@Trace

  constructor() {
    super(SlMainStateType.SL_OUTER_FORM_WG_STATIC_STATE);
  }

  protected initSetMethods(): void { // 复写 WidgetStaticState
    super.initSetMethods();
    this.setMethods.set(OuterFormStaticStateType.OPACITY_ALPHA, this.setMethodOpacity);
  }

  private setMethodOpacity(st: SlOuterFormStaticState, value: number): void {
    st.setOpacity(value);
  }

  private getMethodOpacity(st: SlOuterFormStaticState): number {
    return st.getOpacity();
  }

  private getMethodSlOuterFormAnimCtrl(st: SlOuterFormStaticState): WidgetAnimState {
    return st.getSlOuterFormAnimCtrl();
  }

  protected initGetMethods(): void { // 复写 WidgetStaticState
    super.initGetMethods();
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlOuterFormAnimCtrl);
    this.getMethods.set(OuterFormStaticStateType.OPACITY_ALPHA, this.getMethodOpacity);
  }

  public setOpacity(opacity: number): void {
    this.opacity = opacity;
  }

  public getOpacity(): number {
    return this.opacity;
  }

  public getSlOuterFormAnimCtrl(): WidgetAnimState { // 获取锁屏小外屏服务卡片动效管理
    return this.slOuterFormAnimCtrl;
  };
}
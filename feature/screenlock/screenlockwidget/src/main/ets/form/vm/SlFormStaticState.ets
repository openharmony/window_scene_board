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
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { FormWgStaticStateType, SlMainStateType,
  WidgetStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { BaseState } from '@ohos/screenlockcommon/src/main/ets/TsIndex';

const TAG = 'SlClockStaticState';
// 锁屏组件，服务卡片组件静态状态管理
export class SlFormStaticState extends WidgetStaticState<FormWgStaticStateType> {
  private slFormAnimCtrl: WidgetAnimState = BaseState.wrap(WidgetAnimState, TAG);
  private formShowCount: number = 0; // 服务卡片可见栅格数
  private isFormPanelShow: boolean = true; // 锁屏卡片面板是否可见

  constructor() {
    super(SlMainStateType.SL_FORM_WG_STATIC_STATE);
  }

  protected initSetMethods(): void { // 复写WidgetStaticState
    this.setMethods.set(FormWgStaticStateType.FORM_SHOW_COUNT, this.setMethodFormShowCount);
  }

  private setMethodFormShowCount(st: SlFormStaticState, value: number): void {
    st.setFormShowCount(value);
  }

  private getMethodFormShowCount(st: SlFormStaticState): number {
    return st.getFormShowCount();
  }

  protected initGetMethods(): void { // 复写WidgetStaticState
    this.getMethods.set(WidgetStaticStateType.WIDGET_ANIM_CTRL, this.getMethodSlFormAnimCtrl);
    this.getMethods.set(FormWgStaticStateType.FORM_SHOW_COUNT, this.getMethodFormShowCount);
  }

  public getMethodSlFormAnimCtrl(st: SlFormStaticState): WidgetAnimState {
    return st.getSlFormAnimCtrl();
  }

  public getSlFormAnimCtrl(): WidgetAnimState { // 获取锁屏时钟动效管理
    return this.slFormAnimCtrl;
  }

  public setFormShowCount(count: number): void { // 服务卡片显示栅格数
    if (this.formShowCount !== count) {
      this.formShowCount = count;
      this.notifyStateChange(FormWgStaticStateType.FORM_SHOW_COUNT);
    }
  }

  public getFormShowCount(): number { // 服务卡片显示栅格数
    return this.formShowCount;
  }

  public setFormPanelShow(isShow: boolean): void { // 服务卡片面板是否在显示
    if (this.isFormPanelShow !== isShow) {
      this.isFormPanelShow = isShow;
      this.notifyStateChange(FormWgStaticStateType.IS_FORM_PANEL_SHOW);
    }
  }

  public getFormPanelShow(): boolean { // 服务卡片面板显示状态
    return this.isFormPanelShow;
  }
}
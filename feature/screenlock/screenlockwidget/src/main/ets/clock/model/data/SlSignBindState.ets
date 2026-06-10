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

import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import {
  SignatureBindStateType,
  SlMainStateType
} from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

// 锁屏签名组件UI绑定状态
@Observed
export class SlSignBindState extends WidgetBindState<SignatureBindStateType> {
  /**
   * 签名输入面板的高度,默认值为未打开艺术签名特性时的值
   */
  @Track private signPanelHeight: number = 88;

  constructor() {
    super(SlMainStateType.SL_SIGN_WG_BIND_STATE);
    this.initSetMethods();
    this.initGetMethods();
  }

  protected initSetMethods(): void { // 赋值函数统一管理
    this.setMethods.set(SignatureBindStateType.SL_SUPPORT_ART_SIGN, this.setMethodPanelHeight);
  }

  protected initGetMethods(): void { // 取值函数统一管理
    this.getMethods.set(SignatureBindStateType.SL_SUPPORT_ART_SIGN, this.getMethodPanelHeight);
  }

  private setMethodPanelHeight(st: SlSignBindState, panelHeight: number): void {
    st.setPanelHeight(panelHeight);
  }

  /**
   * 设置签名输入面板的高度
   *
   * @param panelHeight 签名输入面板的高度
   */
  public setPanelHeight(panelHeight: number): void {
    if (this.signPanelHeight !== panelHeight) {
      this.signPanelHeight = panelHeight;
      this.notifyStateChange(SignatureBindStateType.SL_SUPPORT_ART_SIGN);
    }
  }

  private getMethodPanelHeight(st: SlSignBindState): number {
    return st.getPanelHeight();
  }

  /**
   * 获取签名输入面板的高度
   *
   * @returns 签名输入面板的高度
   */
  public getPanelHeight(): number {
    return this.signPanelHeight;
  }
}
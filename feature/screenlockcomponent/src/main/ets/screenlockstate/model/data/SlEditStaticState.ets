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

import { WidgetStaticState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { EditStaticStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

// 锁屏编辑静态状态管理
export class SlEditStaticState extends WidgetStaticState<EditStaticStateType> {
  private isCancelEdit: boolean = false; // 是否取消锁屏编辑

  constructor() {
    super(SlMainStateType.SL_EDIT_STATIC_STATE);
  }

  protected initSetMethods(): void { // 复写WidgetStaticState
    this.setMethods.set(EditStaticStateType.IS_CANCEL_EDIT, this.setMethodEditCancel);
  }

  protected initGetMethods(): void { // 复写WidgetStaticState
    this.getMethods.set(EditStaticStateType.IS_CANCEL_EDIT, this.getMethodCancelEdit);
  }

  private setMethodEditCancel(st: SlEditStaticState, isCancel: boolean): void {
    st.setEditCancel(isCancel);
  }

  private getMethodCancelEdit(st: SlEditStaticState): boolean {
    return st.getCancelEdit();
  }

  public setEditCancel(isCancel: boolean): void {
    if (this.isCancelEdit !== isCancel) {
      this.isCancelEdit = isCancel;
    }
    this.notifyStateChange(EditStaticStateType.IS_CANCEL_EDIT);
  }

  public getCancelEdit(): boolean {
    return this.isCancelEdit;
  }
}
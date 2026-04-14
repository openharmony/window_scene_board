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

import { WidgetBindState } from '@ohos/screenlockcommon/src/main/ets/bean/SlWidgetState';
import { ClockEditBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';

/**
 * 锁屏时钟编辑面板绑定状态
 */
@Observed
export class SlClockEditorBindState extends WidgetBindState<ClockEditBindStateType> {
  /**
   * 是否显示时钟卡片编辑
   */
  @Track private isShowFormBindSheet: boolean = false

  constructor() {
    super(SlMainStateType.SL_CLOCK_EDIT_BIND_STATE);
    this.initSetMethods();
    this.initGetMethods();
  }

  public setIsShowFormBindSheet(isShowFormBindSheet: boolean): void {
    if (this.isShowFormBindSheet !== isShowFormBindSheet) {
      this.isShowFormBindSheet = isShowFormBindSheet;
      this.notifyStateChange(ClockEditBindStateType.IS_SHOW_FORM_BIND_SHEET);
    }
  }

  public getIsShowFormBindSheet(): boolean {
    return this.isShowFormBindSheet;
  }

  protected initSetMethods(): void { // 赋值函数统一管理
    this.setMethods.set(ClockEditBindStateType.IS_SHOW_FORM_BIND_SHEET,
      (state: SlClockEditorBindState,
        isShowFormBindSheet: boolean) => state?.setIsShowFormBindSheet(isShowFormBindSheet));
  }

  protected initGetMethods(): void { // 取值函数统一管理
    this.getMethods.set(ClockEditBindStateType.IS_SHOW_FORM_BIND_SHEET,
      (state: SlClockEditorBindState) => state?.getIsShowFormBindSheet());
  }
}
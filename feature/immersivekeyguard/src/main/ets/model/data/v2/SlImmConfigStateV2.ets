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

import { SlImmConfigStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SlConfigBaseState } from '@ohos/screenlockcommon/Index';

/**
 * 沉浸模块配置状态管理器
 */
export class SlImmConfigStateV2 extends SlConfigBaseState<SlImmConfigStPt, SlImmConfigStateV2> {
  // 沉浸列表模块是否开启，默认开启
  private _isListEnable: boolean = true;
  // 沉浸胶囊模块是否开启，默认开启
  private _isCapEnable: boolean = true;
  // 沉浸大卡模块是否开启，默认开启
  private _isCardEnable: boolean = true;

  protected constructor() {
    super(SlStateId.SL_IMMERSIVE_STATE);
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlImmConfigStPt.PT_LIST_ENABLE, this.setListEnable);
    this.addSetMethod(SlImmConfigStPt.PT_CAP_ENABLE, this.setCapEnable);
    this.addSetMethod(SlImmConfigStPt.PT_CARD_ENABLE, this.setCardEnable);
  }

  protected getTarInstance(): SlImmConfigStateV2 {
    return this;
  }

  /**
   * 赋值列表开关
   *
   * @param isEnable true启动列表
   * @returns 链式
   */
  public setListEnable(isEnable: boolean): SlImmConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isListEnable !== result) {
      this._isListEnable = result;
      this.notifyStateChange(SlImmConfigStPt.PT_LIST_ENABLE);
    }
    return this;
  }

  /**
   * 列表是否启用
   *
   * @returns true启用
   */
  public isListEnable(): boolean {
    return this._isListEnable;
  }

  /**
   * 赋值胶囊开关
   *
   * @param isEnable true启动胶囊
   * @returns 链式
   */
  public setCapEnable(isEnable: boolean): SlImmConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isCapEnable !== result) {
      this._isCapEnable = result;
      this.notifyStateChange(SlImmConfigStPt.PT_CAP_ENABLE);
    }
    return this;
  }

  /**
   * 胶囊是否启用
   *
   * @returns true启用
   */
  public isCapEnable(): boolean {
    return this._isCapEnable;
  }

  /**
   * 赋值大卡开关
   *
   * @param isEnable true启用大卡
   * @returns 链式
   */
  public setCardEnable(isEnable: boolean): SlImmConfigStateV2 {
    let result = isEnable ?? false;
    if (this._isCardEnable !== result) {
      this._isCardEnable = result;
      this.notifyStateChange(SlImmConfigStPt.PT_CARD_ENABLE);
    }
    return this;
  }

  /**
   * 大卡是否启用
   *
   * @returns true启用
   */
  public isCardEnable(): boolean {
    return this._isCardEnable;
  }
}
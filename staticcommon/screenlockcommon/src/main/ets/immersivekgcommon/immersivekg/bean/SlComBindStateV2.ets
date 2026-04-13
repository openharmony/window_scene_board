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
import { BaseState } from '../../base/bean/BaseState';
import { SlComBinStPt, SlStateId } from '../constants/SlStateConst';
import { SlViewBindState } from './SlViewBindState';

/**
 * 锁屏模块通用UI绑定状态属性集
 */
@ObservedV2
export class SlComBindStateV2 extends SlViewBindState<SlComBinStPt> {
  // 无障碍是否开启
  @Trace private _isAccessibilityMode: boolean = false;

  protected constructor() {
    super(SlStateId.SL_COM_STATE);
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlComBinStPt.PT_ACCESSIBILITY_MODE, this.setAccessibilityMode);
  }

  protected initGetMethods(): void {
    super.initGetMethods();
    this.addGetMethod(SlComBinStPt.PT_ACCESSIBILITY_MODE, this.isAccessibilityMode);
  }

  /**
   * 设置无障碍开启状态
   *
   * @param isAccessibility true开启无障碍
   */
  public setAccessibilityMode(isAccessibility?: boolean): void {
    let result = isAccessibility ?? false;
    if (this._isAccessibilityMode !== result) {
      this._isAccessibilityMode = result;
      this.notifyStateChange(SlComBinStPt.PT_ACCESSIBILITY_MODE);
    }
  }

  /**
   * 当前无障碍开启状态
   *
   * @returns true无障碍开启
   */
  public isAccessibilityMode(): boolean {
    return this._isAccessibilityMode;
  }
}

// 单例，多产品共享
export const slComBindSt: SlComBindStateV2 = BaseState.wrap(SlComBindStateV2);
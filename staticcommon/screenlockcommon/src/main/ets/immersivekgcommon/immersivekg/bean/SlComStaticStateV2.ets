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
import { SlComStaticStPt, SlStateId } from '../constants/SlStateConst';
import { SlViewStaticState } from './SlViewStaticState';

/**
 * 锁屏模块通用静态状态属性集
 */
export class SlComStaticStateV2 extends SlViewStaticState<SlComStaticStPt> {
  // 是否亮屏状态，默认亮屏
  private _isScreenOn: boolean = true;

  protected constructor() {
    super(SlStateId.SL_COM_STATE);
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlComStaticStPt.PT_SCREEN_ON, this.setScreenOn);
  }

  protected initGetMethods(): void {
    super.initGetMethods();
    this.addGetMethod(SlComStaticStPt.PT_SCREEN_ON, this.isScreenOn);
  }

  /**
   * 设置亮屏状态
   *
   * @param isScreenOn true亮屏
   */
  public setScreenOn(isScreenOn?: boolean): void {
    let result = isScreenOn ?? false;
    if (this._isScreenOn !== result) {
      this._isScreenOn = result;
      this.notifyStateChange(SlComStaticStPt.PT_SCREEN_ON);
    }
  }

  /**
   * 当前亮屏状态
   *
   * @returns true亮屏
   */
  public isScreenOn(): boolean {
    return this._isScreenOn;
  }
}

// 单例，多产品共享
export const slComStaticSt: SlComStaticStateV2 = BaseState.wrap(SlComStaticStateV2);
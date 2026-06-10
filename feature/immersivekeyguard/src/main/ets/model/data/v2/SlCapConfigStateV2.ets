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
import { SlCapConfigStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SlConfigBaseState } from '@ohos/screenlockcommon/Index';

/**
 * 沉浸胶囊配置状态管理器
 */
export class SlCapConfigStateV2 extends SlConfigBaseState<SlCapConfigStPt, SlCapConfigStateV2> {
  // 实况胶囊扩展区按钮显示个数，默认1个
  private _btnCount: number = 1;

  // 计算胶囊宽度、个数是否使用屏幕高度，默认使用宽度
  private _isUseHeightCal: boolean = false;

  protected constructor() {
    super(SlStateId.SL_CAP_STATE);
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(SlCapConfigStPt.PT_BTN_COUNT, this.setShowBtnCount);
  }

  protected getTarInstance(): SlCapConfigStateV2 {
    return this;
  }

  /**
   * 设置胶囊可显示按钮个数
   *
   * @param btnCount 按钮个数
   */
  public setShowBtnCount(btnCount?: number): SlCapConfigStateV2 {
    let result = btnCount ?? 0;
    if (this._btnCount !== result) {
      this._btnCount = result;
      this.notifyStateChange(SlCapConfigStPt.PT_BTN_COUNT);
    }
    return this;
  }

  /**
   * 胶囊可显示按钮个数
   *
   * @returns 按钮个数
   */
  public getShowBtnCount(): number {
    return this._btnCount;
  }

  /**
   * 是否使用屏幕高度计算胶囊宽度
   *
   * @param isUseHeight true使用屏幕高度计算
   */
  public setUseHeightCal(isUseHeight?: boolean): SlCapConfigStateV2 {
    let result = isUseHeight ?? false;
    if (this._isUseHeightCal !== result) {
      this._isUseHeightCal = result;
      this.notifyStateChange(SlCapConfigStPt.PT_USE_HEIGHT_CAL);
    }
    return this;
  }

  /**
   * 是否使用屏幕高度计算胶囊宽度
   *
   * @returns true使用屏幕高度计算
   */
  public isUseHeightCal(): boolean {
    return this._isUseHeightCal;
  }
}
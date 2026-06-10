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
import { LogDomain, Logger } from '@ohos/basicutils';
import { SlCapBindStPt, SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SlViewBindState } from '@ohos/screenlockcommon/Index';

const TAG = 'SlCapBindStateV2';
const log: Logger = Logger.getLogHelper(LogDomain.KG);

/**
 * 沉浸胶囊UI绑定状态管理器
 */
@ObservedV2
export class SlCapBindStateV2 extends SlViewBindState<SlCapBindStPt> {
  // 实况胶囊扩展区按钮显示个数，默认1个
  @Trace private _btnCount: number = 1;

  // 当前胶囊是否正在强提醒
  @Trace private _isCapRemind: boolean = false;

  protected constructor() {
    super(SlStateId.SL_CAP_STATE);
  }

  protected initGetMethods(): void {
    super.initGetMethods();
    this.addGetMethod(SlCapBindStPt.PT_BTN_COUNT, this.getShowBtnCount);
    this.addGetMethod(SlCapBindStPt.PT_CAP_REMIND, this.getShowBtnCount);
  }

  /**
   * 设置胶囊可显示按钮个数
   *
   * @param btnCount 按钮个数
   */
  public setShowBtnCount(btnCount?: number): void {
    let result = btnCount ?? 0;
    if (this._btnCount !== result) {
      this._btnCount = result;
      this.notifyStateChange(SlCapBindStPt.PT_BTN_COUNT);
      log.showInfo(TAG, `setShowBtnCount: ${btnCount}`);
    }
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
   * 赋值胶囊强提醒状态
   *
   * @param isRemind true强提醒
   */
  public setCapRemind(isRemind: boolean): void {
    let result = isRemind ?? false;
    if (this._isCapRemind !== result) {
      this._isCapRemind = result;
      this.notifyStateChange(SlCapBindStPt.PT_CAP_REMIND);
      log.showInfo(TAG, `setCapRemind: ${result}`);
    }
  }

  /**
   * 胶囊当前是否强提醒状态
   *
   * @returns true强提醒
   */
  public isCapRemind(): boolean {
    return this._isCapRemind;
  }
}
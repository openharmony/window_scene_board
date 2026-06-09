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
import { SlStateId, SlListBindStPt } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SlViewBindState } from '@ohos/screenlockcommon/Index';

const TAG = 'SlListBindStateV2';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 沉浸列表UI绑定状态管理器
 */
@ObservedV2
export class SlListBindStateV2 extends SlViewBindState<SlListBindStPt> {
  // 列表滑动是否开启，默认开启
  @Trace private _isScrollerEnable?: boolean = true;

  // 列表条目横滑是否开启，默认开启
  @Trace private _isItemSwipeEnable: boolean = true;

  protected constructor() {
    super(SlStateId.SL_LIST_STATE);
  }

  protected initGetMethods(): void {
    super.initGetMethods();
    this.addGetMethod(SlListBindStPt.PT_LIST_SCROLLER_ENABLE, this.isScrollerEnable);
    this.addGetMethod(SlListBindStPt.PT_ITEM_SWIPE_ENABLE, this.isItemSwipeEnable);
  }

  /**
   * 设置列表滑动开关
   *
   * @param isEnable true开启滑动
   */
  public setScrollerEnable(isEnable?: boolean): void {
    if (this._isScrollerEnable !== isEnable) {
      log.showInfo(`setScrollerEnable: ${isEnable}`);
      this._isScrollerEnable = isEnable;
      this.notifyStateChange(SlListBindStPt.PT_LIST_SCROLLER_ENABLE);
    }
  }

  /**
   * 当前列表滑动是否开启
   *
   * @returns true开启滑动
   */
  public isScrollerEnable(): boolean {
    return this._isScrollerEnable ?? false;
  }

  /**
   * 设置列表条目横滑开关
   *
   * @param isEnable true开启滑动
   */
  public setItemSwipeEnable(isEnable?: boolean): void {
    let result = isEnable ?? false;
    if (this._isItemSwipeEnable !== result) {
      log.showInfo(`setItemSwipeEnable: ${isEnable}`);
      this._isItemSwipeEnable = result;
      this.notifyStateChange(SlListBindStPt.PT_ITEM_SWIPE_ENABLE);
    }
  }

  /**
   * 当前列表条目横滑是否开启
   *
   * @returns true开启滑动
   */
  public isItemSwipeEnable(): boolean {
    return this._isItemSwipeEnable;
  }
}
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
import { BindBaseStateV2 } from '../../base/bean/BindBaseStateV2';
import { BaseObj } from '../../base/constants/BaseType';
import { SlStateId, SlStateProperty, SlViewBindStPt } from '../constants/SlStateConst';

const TAG = 'SlViewBindState';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 锁屏组件UI绑定状态基类
 */
@ObservedV2
export class SlViewBindState<T extends SlStateProperty> extends BindBaseStateV2 {
  // 组件是否可见，默认可见
  @Trace private _isViewVisible?: boolean = true;

  protected constructor(name: SlStateId) {
    super(name);
  }

  protected initSetMethods(): void {
    this.addSetMethod(SlViewBindStPt.PT_VIEW_VISIBLE, this.setViewVisible);
  }

  protected initGetMethods(): void {
    this.addGetMethod(SlViewBindStPt.PT_VIEW_VISIBLE, this.isViewVisible);
  }

  public setStateValue(property: SlViewBindStPt | T, value?: BaseObj): SlViewBindState<T> {
    return super.setStateValue(property, value) as SlViewBindState<T>;
  }

  public getStateValue(property: SlViewBindStPt | T, scene?: BaseObj): BaseObj | undefined {
    return super.getStateValue(property, scene);
  }

  public getStateId(): SlStateId {
    return super.getStateId() as SlStateId;
  }

  /**
   * 设置组件可见性
   *
   * @param isVisible 可见性
   */
  public setViewVisible(isVisible?: boolean): void {
    if (this._isViewVisible !== isVisible) {
      log.showInfo(`${this.splicePrint()} setViewVisible: ${isVisible}`);
      this._isViewVisible = isVisible;
      this.notifyStateChange(SlViewBindStPt.PT_VIEW_VISIBLE);
    }
  }

  /**
   * 当前组件可见性
   *
   * @returns true可见
   */
  public isViewVisible(): boolean {
    return this._isViewVisible ?? false;
  }
}
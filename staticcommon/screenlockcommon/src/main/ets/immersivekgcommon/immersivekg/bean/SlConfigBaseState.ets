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
import { BaseObj } from '../../base/constants/BaseType';
import { ConfigBaseState } from '../../base/bean/ConfigBaseState';
import { SlConfigStPt, SlStateId, SlStateProperty } from '../constants/SlStateConst';
import { SizeBpSplice } from '../../base/utils/ScreenBreakPoint';

/**
 * 锁屏模块配置类型状态基类
 */
export abstract class SlConfigBaseState<T extends SlStateProperty, C extends SlConfigBaseState<T, C>>
  extends ConfigBaseState {
  // 屏幕断点拼接类型
  private _bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT;

  protected constructor(name: SlStateId) {
    super(name);
  }

  protected initSetMethods(): void {
    this.addSetMethod(SlConfigStPt.PT_SIZE_BP_SPLICE, this.setBpSplice);
  }

  protected initGetMethods(): void {
    this.addGetMethod(SlConfigStPt.PT_SIZE_BP_SPLICE, this.getBpSplice);
  }

  public setStateValue(property: SlConfigStPt | T, value?: BaseObj): C {
    return super.setStateValue(property, value) as C;
  }

  public getStateValue(property: SlConfigStPt | T, scene?: BaseObj): BaseObj | undefined {
    return super.getStateValue(property, scene);
  }

  public getStateId(): SlStateId {
    return super.getStateId() as SlStateId;
  }

  /**
   * 子类目标实例
   *
   * @returns 子类实例
   */
  protected abstract getTarInstance(): C;

  /**
   * 赋值屏幕断点拼接类型
   *
   * @param bpSplice 拼接类型
   * @returns 链式
   */
  public setBpSplice(bpSplice: SizeBpSplice): C {
    let result = bpSplice ?? SizeBpSplice.DEFAULT;
    if (this._bpSplice !== result) {
      this._bpSplice = result;
      this.notifyStateChange(SlConfigStPt.PT_SIZE_BP_SPLICE);
    }
    return this.getTarInstance();
  }

  /**
   * 取值屏幕断点拼接类型
   *
   * @returns 拼接类型
   */
  public getBpSplice(): SizeBpSplice {
    return this._bpSplice;
  }
}
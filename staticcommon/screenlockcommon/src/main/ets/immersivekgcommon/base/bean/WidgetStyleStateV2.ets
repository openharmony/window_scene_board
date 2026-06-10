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
import { StateType } from '../constants/BaseType';
import { WProperty } from '../constants/WidgetPropertyConst';
import { WStyleProperty } from '../constants/WidgetPropertyConst';
import { LimitSet } from '../utils/LimitSet';
import { SizeBpSplice } from '../utils/ScreenBreakPoint';
import { WidgetPropertyStateV2 } from './WidgetPropertyStateV2';

/**
 * 组件样式状态基类
 */
@ObservedV2
export class WidgetStyleStateV2 extends WidgetPropertyStateV2<WidgetStyleStateV2> {
  // 配置场景，配置为null的属性标记集
  private readonly _nullCfgPt: LimitSet<WProperty> = new LimitSet();

  // 屏幕断点拼接类型
  @Trace private bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT;

  // 样式配置标识
  @Trace private _configId?: string;

  protected getTarInstance(): WidgetStyleStateV2 {
    return this;
  }

  protected initSetMethods(): void {
    super.initSetMethods();
    this.addSetMethod(WStyleProperty.SIZE_BP_SPLICE, this.setBpSplice);
  }

  protected initGetMethods(): void {
    super.initGetMethods();
    this.addSetMethod(WStyleProperty.SIZE_BP_SPLICE, this.getBpSplice);
  }

  /**
   * 复写IBaseState，状态类型
   *
   * @returns 状态类型
   */
  public getStateType(): StateType {
    return StateType.STYLE;
  }

  /**
   * 赋值样式配置标识
   *
   * @param id 标识
   * @returns 链式
   */
  public setConfigId(id: string): WidgetStyleStateV2 {
    if (this._configId !== id) {
      this._configId = id;
      this.notifyStateChange(WStyleProperty.CONFIG_ID);
    }
    return this;
  }

  /**
   * 取值样式配置标识
   *
   * @returns 标识
   */
  public getConfigId(): string | undefined {
    return this._configId;
  }

  /**
   * 赋值屏幕断点拼接类型
   *
   * @param bpSplice 拼接类型
   * @returns 链式
   */
  public setBpSplice(bpSplice: SizeBpSplice): WidgetStyleStateV2 {
    let result = bpSplice ?? SizeBpSplice.DEFAULT;
    if (this.bpSplice !== result) {
      this.bpSplice = result;
      this.notifyStateChange(WStyleProperty.SIZE_BP_SPLICE);
    }
    return this;
  }

  /**
   * 取值屏幕断点拼接类型
   *
   * @returns 拼接类型
   */
  public getBpSplice(): SizeBpSplice {
    return this.bpSplice;
  }

  /**
   * 配置null的属性标识
   *
   * @param pt 属性标识
   * @returns 链接
   */
  public buildCfgPtNull(pt: WProperty): WidgetStyleStateV2 {
    this._nullCfgPt.add(pt);
    return this;
  }

  /**
   * 取值属性标识是否配置为null
   *
   * @param pt 属性标识
   * @returns 有配置则为null，无配置则为undefined
   */
  public getPtNullValue(pt: WProperty): null | undefined {
    return this._nullCfgPt.has(pt) ? null : undefined;
  }
}
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
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/utils/LimitMap';
import { SizeBpSplice } from '@ohos/screenlockcommon/src/main/ets/immersivekgcommon/base/utils/ScreenBreakPoint';
import { ALL_CLOCK_WG_ID, ClockLayout, ClockWidgetId } from '../../../common/WidgetParam';
import { DateWeekLunarStyle } from '../../common/ClockConstants';
import { ElementConf, ClockLayoutCopyUtil } from '../../common/ClockLayoutParam';
import { BaseClockStyleConfig } from './BaseClockStyleConfig';

// 局部AOD日期星期农历间距
export const AOD_DEFAULT_MERGE_MARGIN = 0;

/**
 * 时钟样式配置
 */
export class AodClockStyleConfig extends BaseClockStyleConfig {
  // 时钟收起样式下各元素配置
  private readonly _aodClockElementMap: Map<SizeBpSplice, LimitMap<ClockWidgetId, ElementConf>> = new Map();
  private _aodElementArrMap: Map<SizeBpSplice, ElementConf[]> = new Map();
  private _aodClockMarginMap: Map<SizeBpSplice, Margin> = new Map();
  private _mergeWeekLunarStyleMap: Map<SizeBpSplice, DateWeekLunarStyle> = new Map();

  /**
   * 取值局部AOD样式元素配置集
   *
   * @returns 元素集
   */
  public getAodElementArr(): ElementConf[] {
    let bp: SizeBpSplice = this.getCurBpStatus();
    if (this._aodElementArrMap.has(bp)) {
      return this._aodElementArrMap.get(bp) ?? [];
    }
    this._aodElementArrMap.set(bp, []);
    ALL_CLOCK_WG_ID.forEach((id) => {
      let cfg = this.getAodElement(id);
      if (cfg) {
        this._aodElementArrMap.get(bp)?.push(cfg);
      }
    });
    return this._aodElementArrMap.get(bp) ?? [];
  }

  /**
   * 绑定时钟局部AOD态元素
   *
   * @param element 元素
   * @returns 链式
   */
  public bindAodClockLayout(element: ElementConf): AodClockStyleConfig {
    if (element) {
      let bp: SizeBpSplice = element.bp ?? SizeBpSplice.DEFAULT;
      if (!this._aodClockElementMap.has(bp)) {
        this._aodClockElementMap.set(bp , new LimitMap());
      }
      this._aodClockElementMap.get(bp)?.set(element.id, element);
    }
    return this;
  }

  /**
   * 绑定时钟局部AOD态Margin
   *
   * @param value Margin
   * @returns 链式
   */
  public bindAodClockMargin(value: Margin, bp: SizeBpSplice = SizeBpSplice.DEFAULT): AodClockStyleConfig {
    if (value) {
      this._aodClockMarginMap.set(bp, value);
    }
    return this;
  }

  /**
   * 绑定时钟局部AOD态是否合并日期与农历
   *
   * @param isMerge 是否合并
   * @returns 链式
   */
  public bindMergeWeekLunar(style: DateWeekLunarStyle, bp: SizeBpSplice = SizeBpSplice.DEFAULT): AodClockStyleConfig {
    this._mergeWeekLunarStyleMap.set(bp, style);
    return this;
  }

  /**
   * 取值时钟局部AOD样式元素配置
   *
   * @param id 元素标识
   * @returns 元素配置
   */
  public getAodElement(id: ClockWidgetId): Nullable<ElementConf> {
    return this._aodClockElementMap.get(this.getCurBpStatus())?.get(id);
  }

  /**
   * 获取局部AOD时钟Margin值
   *
   * @returns Margin
   */
  public getAodClockMargin(): Nullable<Margin> {
    return this._aodClockMarginMap.get(this.getCurBpStatus());
  }

  /**
   * 获取局部AOD时钟是否合并
   *
   * @returns boolean
   */
  public getMergeWeekLunarStyle(): Nullable<DateWeekLunarStyle> {
    return this._mergeWeekLunarStyleMap.get(this.getCurBpStatus());
  }

  /**
   * 实例构造
   *
   * @param clockLayout 时钟样式类型
   * @returns 样式配置
   */
  public static wrap(clockLayout: ClockLayout): AodClockStyleConfig {
    return new AodClockStyleConfig(clockLayout ?? ClockLayout.DEFAULT_CLOCK_LAYOUT);
  }

  /**
   * 样式复制
   *
   * @param clockLayout 样式类型
   * @returns 复制实例
   */
  public copy(clockLayout?: ClockLayout): AodClockStyleConfig {
    const newCfg: AodClockStyleConfig = new AodClockStyleConfig(clockLayout ?? this.getClockLayout());
    this._aodClockElementMap.forEach((value: LimitMap<ClockWidgetId, ElementConf>, bp: SizeBpSplice) => {
      value.forEach((element) =>
        newCfg.bindAodClockLayout(ClockLayoutCopyUtil.copyElement(element) ?? element));
    });

    this._aodClockMarginMap.forEach((value: Margin, bp: SizeBpSplice) => {
      newCfg._aodClockMarginMap.set(bp, value);
    });

    this._mergeWeekLunarStyleMap.forEach((value: DateWeekLunarStyle, bp: SizeBpSplice) => {
      newCfg._mergeWeekLunarStyleMap.set(bp, value);
    });
    return newCfg;
  }
}
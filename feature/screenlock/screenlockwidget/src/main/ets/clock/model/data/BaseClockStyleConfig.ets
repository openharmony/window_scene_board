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
import { ObjectCopyUtil } from '@ohos/componenthelper';
import { SizeBpSplice } from '@ohos/screenlockcommon';
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { ALL_CLOCK_WG_ID, ClockComFamily, ClockLayout, ClockWidgetId } from '../../../common/WidgetParam';
import { ClockGridParam, ClockGridParamCorrection, ElementConf, ClockLayoutCopyUtil } from '../../common/ClockLayoutParam';
import { IClockStyleConfig } from './IClockStyleConfig';

/**
 * 时钟样式配置
 */
export abstract class BaseClockStyleConfig implements IClockStyleConfig {
  // 时钟样式类型
  protected readonly _clockLayout: ClockLayout;

  // 时钟展开样式下各元素配置
  protected readonly _expandElementMap: Map<SizeBpSplice, LimitMap<ClockWidgetId, ElementConf>> = new Map();

  // 时钟收起样式下各元素配置
  protected _collapseElementMap: Map<SizeBpSplice, LimitMap<ClockWidgetId, ElementConf>> = new Map();

  // 时钟展开样式下栅格配置
  protected _expandGridMap: Map<SizeBpSplice, ClockGridParam> = new Map();

  // 时钟收起样式下栅格配置
  protected _collapseGridMap: Map<SizeBpSplice, ClockGridParam> = new Map();

  // 解锁时钟一镜到底动效，时钟收起样式下栅格配置
  protected _oneShotCollapseGridMap: Map<SizeBpSplice, ClockGridParam> = new Map();

  // 时钟样式映射字体样式
  protected _fontFamilyMap: Map<SizeBpSplice, string> = new Map();

  // 时钟展开样式元素配置集
  protected _expandElementArrMap: Map<SizeBpSplice, ElementConf[]> = new Map();

  // 时钟收起样式元素配置集
  protected _collapseElementArrMap: Map<SizeBpSplice, ElementConf[]> = new Map();

  protected constructor(clockLayout: ClockLayout) {
    this._clockLayout = clockLayout;
  }

  /**
   * 样式复制
   *
   * @param clockLayout 样式类型
   * @returns 复制实例
   */
  public abstract copy(clockLayout?: ClockLayout): BaseClockStyleConfig;

  /**
   * 取值时钟样式类型
   *
   * @returns 样式类型
   */
  public getClockLayout(): ClockLayout {
    return this._clockLayout;
  }

  /**
   * 获取当前断点状态
   *
   * @returns 当前断点
   */
  protected getCurBpStatus(): SizeBpSplice {
    return SizeBpSplice.DEFAULT;
  }

  /**
   * 取值展开样式元素配置集
   *
   * @returns 元素集
   */
  public getExpandElementArr(): ElementConf[] {
    let bp: SizeBpSplice = this.getCurBpStatus();
    if (this._expandElementArrMap.has(bp)) {
      return this._expandElementArrMap.get(bp) ?? [];
    }
    this._expandElementArrMap.set(bp, []);
    ALL_CLOCK_WG_ID.forEach((id) => {
      let cfg = this.getExpandElement(id, bp);
      if (cfg) {
        this._expandElementArrMap.get(bp)?.push(cfg);
      }
    });
    return this._expandElementArrMap.get(bp) ?? [];
  }

  /**
   * 取值收起样式元素配置集
   *
   * @returns 元素集
   */
  public getCollapseElementArr(): ElementConf[] {
    let bp: SizeBpSplice = this.getCurBpStatus();
    if (this._collapseElementArrMap.has(bp)) {
      return this._collapseElementArrMap.get(bp) ?? [];
    }
    this._collapseElementArrMap.set(bp, []);
    ALL_CLOCK_WG_ID.forEach((id) => {
      let cfg = this.getCollapseElement(id);
      if (cfg) {
        this._collapseElementArrMap.get(bp)?.push(cfg);
      }
    });
    return this._collapseElementArrMap.get(bp) ?? [];
  }

  /**
   * 取值时钟展开样式元素配置
   *
   * @param id 元素标识
   * @returns 元素配置
   */
  public getExpandElement(id: ClockWidgetId, bp: SizeBpSplice): ElementConf | undefined {
    return this._expandElementMap.get(bp)?.get(id) ??
      this._expandElementMap.get(SizeBpSplice.DEFAULT)?.get(id);
  }

  /**
   * 取值时钟收起样式元素配置
   *
   * @param id 元素标识
   * @returns 元素配置
   */
  public getCollapseElement(id: ClockWidgetId): ElementConf | undefined {
    return this._collapseElementMap.get(this.getCurBpStatus())?.get(id) ??
      this._collapseElementMap.get(SizeBpSplice.DEFAULT)?.get(id);
  }

  /**
   * 取值时钟展开样式栅格配置
   *
   * @returns 栅格配置
   */
  public getExpandGrid(): ClockGridParam | undefined {
    return this._expandGridMap.get(this.getCurBpStatus()) ?? this._expandGridMap.get(SizeBpSplice.DEFAULT);
  }

  /**
   * 取值时钟收起样式栅格配置
   *
   * @returns 栅格配置
   */
  public getCollapseGrid(): ClockGridParam | undefined {
    return this._collapseGridMap.get(this.getCurBpStatus()) ?? this._collapseGridMap.get(SizeBpSplice.DEFAULT);
  }

  /**
   * 取值时钟一镜到底收起样式栅格配置
   *
   * @returns 栅格配置
   */
  public getOneShotGrid(): ClockGridParam | undefined {
    return this._oneShotCollapseGridMap.get(this.getCurBpStatus()) ??
      this._oneShotCollapseGridMap.get(SizeBpSplice.DEFAULT);
  }

  /**
   * 取值时钟样式默认字体配置
   *
   * @returns 字体配置
   */
  public getFontFamily(): string {
    return this._fontFamilyMap.get(this.getCurBpStatus()) ??
      this._fontFamilyMap.get(SizeBpSplice.DEFAULT) ?? ClockComFamily.HARMONY_CLOCK_01;
  }


  /**
   * 根据ID复制并绑定多设备样式，并且进行纵坐标偏移
   *
   * @param iDArr 元素ID数组
   * @param fromBp 原有断点类型
   * @param toBp 目标断点类型
   * @param offsetY 纵坐标偏移数值
   * @returns 链式
   */
  public copyAndBindClockWithOffsetY(iDArr: ClockWidgetId[], fromBp: SizeBpSplice, toBp: SizeBpSplice,
    offsetY: number): BaseClockStyleConfig {
    iDArr.forEach((id) => {
      this.bindExpandElement(ClockLayoutCopyUtil.copyElementWithParam(
        this.getExpandElement(id, fromBp), offsetY, toBp));
    })
    return this;
  }

  /**
   * 时钟展开样式的元素绑定
   *
   * @param element 元素
   * @returns 链式
   */
  public bindExpandElement(element: ElementConf): BaseClockStyleConfig {
    if (element) {
      let bp: SizeBpSplice = element.bp ?? SizeBpSplice.DEFAULT;
      if (!this._expandElementMap.has(bp)) {
        this._expandElementMap.set(bp , new LimitMap());
      }
      this._expandElementMap.get(bp)?.set(element.id, element);
    }
    return this;
  }

  /**
   * 时钟收起样式的元素绑定
   *
   * @param element 元素
   * @returns 链式
   */
  public bindCollapseElement(element: ElementConf): BaseClockStyleConfig {
    if (element) {
      let bp: SizeBpSplice = element.bp ?? SizeBpSplice.DEFAULT;
      if (!this._collapseElementMap.has(bp)) {
        this._collapseElementMap.set(bp, new LimitMap());
      }
      this._collapseElementMap.get(bp)?.set(element.id, element);
    }
    return this;
  }

  /**
   * 复制时钟收起样式
   * @param clockStyleConfig
   * @returns
   */
  public copyCollapseElementConfig(clockStyleConfig: BaseClockStyleConfig): BaseClockStyleConfig {
    clockStyleConfig._collapseElementMap.forEach((value: LimitMap<ClockWidgetId, ElementConf>, key: SizeBpSplice) => {
      this._collapseElementMap.set(key, value);
    });
    return this;
  }

  /**
   * 时钟展开样式的栅格绑定
   *
   * @param grid 栅格
   * @returns 链式
   */
  public bindExpandGrid(grid: ClockGridParam): BaseClockStyleConfig {
    if (grid) {
      this._expandGridMap.set(grid.bp ?? SizeBpSplice.DEFAULT, grid);
    }
    return this;
  }

  /**
   * 时钟收起样式的栅格绑定
   *
   * @param grid 栅格
   * @returns 链式
   */
  public bindCollapseGrid(grid: ClockGridParam): BaseClockStyleConfig {
    if (grid) {
      this._collapseGridMap.set(grid.bp ?? SizeBpSplice.DEFAULT, grid)
    }
    return this;
  }

  /**
   * 时钟一镜到底动效收起样式的栅格绑定
   *
   * @param grid 栅格
   * @returns 链式
   */
  public bindOneShotCollapseGrid(grid: ClockGridParamCorrection): BaseClockStyleConfig {
    let bp: SizeBpSplice = grid.bp ?? SizeBpSplice.DEFAULT;
    let oldGrid: ClockGridParam | undefined = this._collapseGridMap.get(bp);
    if (grid && oldGrid) {
      // 一镜到底配置以原收起样式为原型
      this._oneShotCollapseGridMap.set(bp, ObjectCopyUtil.deepClone(oldGrid));
      let oneShotCollapseGrid: ClockGridParam | undefined = this._oneShotCollapseGridMap.get(bp);
      if (oneShotCollapseGrid) {
        oneShotCollapseGrid.singleLineDate = grid.singleLineDate;
        oneShotCollapseGrid.dateSeperate = grid.dateSeperate;
        oneShotCollapseGrid.dynamicLunar = grid.dynamicLunar;
      }
    }
    return this;
  }

  /**
   * 时钟样式默认字体
   *
   * @param fontFamily 字体
   * @returns 链式
   */
  public bindFontFamily(fontFamily: string, bp: SizeBpSplice = SizeBpSplice.DEFAULT): BaseClockStyleConfig {
    if (fontFamily) {
      this._fontFamilyMap.set(bp, fontFamily);
    }
    return this;
  }

  /**
   * 绑定子样式
   *
   * @param newCfg 新的样式配置
   * @param arr 子样式数组
   */
  protected bindChildElementArr(newCfg: BaseClockStyleConfig, arr: ElementConf[]): void {
    arr.forEach((cf) => {
      newCfg.bindExpandElement(ClockLayoutCopyUtil.copyElement(cf) ?? cf);
    })
  }

  protected copyProperties(newCfg: BaseClockStyleConfig): void {
    this._expandElementMap.forEach((value: LimitMap<ClockWidgetId, ElementConf>, bp: SizeBpSplice) => {
      value.forEach((element) => {
        if (element.child) {
          this.bindChildElementArr(newCfg, element.child);
        } else {
          newCfg.bindExpandElement(ClockLayoutCopyUtil.copyElement(element) ?? element);
        }
      });
    });

    this._collapseElementMap.forEach((value: LimitMap<ClockWidgetId, ElementConf>, bp: SizeBpSplice) => {
      value.forEach((element) =>
      newCfg.bindCollapseElement(ClockLayoutCopyUtil.copyElement(element) ?? element));
    });

    this._expandGridMap.forEach((value: ClockGridParam, bp: SizeBpSplice) => {
      let newGrid: ClockGridParam | undefined = ClockLayoutCopyUtil.copyGridParam(value);
      if (newGrid) {
        newCfg._expandGridMap.set(bp, newGrid);
      }
    });

    this._collapseGridMap.forEach((value: ClockGridParam, bp: SizeBpSplice) => {
      let newGrid: ClockGridParam | undefined = ClockLayoutCopyUtil.copyGridParam(value);
      if (newGrid) {
        newCfg._collapseGridMap.set(bp, newGrid);
      }
    })

    this._oneShotCollapseGridMap.forEach((value: ClockGridParam, bp: SizeBpSplice) => {
      let newGrid: ClockGridParam | undefined = ClockLayoutCopyUtil.copyGridParam(value);
      if (newGrid) {
        newCfg._oneShotCollapseGridMap.set(bp, newGrid);
      }
    })

    newCfg._fontFamilyMap.forEach((value: string, bp: SizeBpSplice) => {
      newCfg._fontFamilyMap.set(bp, value);
    })
  }
}
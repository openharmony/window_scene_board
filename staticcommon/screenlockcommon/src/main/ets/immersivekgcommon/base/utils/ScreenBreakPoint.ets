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
import { Context, UIContext } from '@ohos.arkui.UIContext';
import { settings } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LimitMap } from './LimitMap';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const CALC_TAG = 'BpCalculator';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, CALC_TAG);

// 设备默认dpi键值
const DEFAULT_DPI_KEY: string = 'default_display_dpi';
// 基础DPI
const BASE_DPI: number = 160;

// 屏幕宽高断点枚举
export enum SizeBp {
  XS = 'XSmall',
  SM = 'Small',
  MD = 'Medium',
  LG = 'Large',
  XL = 'XLarge',
}

// 屏幕断点拼接枚举(宽 + 高)
export enum SizeBpSplice {
  DEFAULT = 'Default', // 默认，拼接场景超出范围时取默认值
  SM = 'Small_Medium', // 概括小外屏
  MS = 'Medium_Small', // 概括直板机、大折叠折叠态横屏，超大屏F态横屏，小折叠内屏横屏
  LS = 'Large_Small', // 概括PAD横屏，超大屏G态横屏
  XS = 'XLarge_Small', // 概括PC大屏、PAD横屏
  MM = 'Medium_Medium', // 概括大折叠展开态竖屏、横屏，超大屏M态竖屏、横屏
  SL = 'Small_Large', // 概括直板机、大折叠折叠态竖屏，超大屏F态竖屏，小折叠内屏竖屏
  LL = 'Large_Large', // 概括PAD竖屏
  ML = 'Medium_Large', // 概括PAD竖屏，超大屏G态竖屏
}

// 屏幕宽高断点状态
export interface ScreenBp {
  // 屏幕宽高，vp
  screenWidth: number;
  screenHeight: number;
  // 宽高断点
  widthBp: SizeBp;
  heightBp: SizeBp;
  // 断点拼接（宽+高）
  bpSplice: SizeBpSplice;
}

// 断点枚举的映射
enum SizeBpNum {
  XS = 0,
  SM,
  MD,
  LG,
  XL
}

// 宽度断点阈值节点(VP)
enum WidthBpNode {
  XS = 320,
  SM = 600,
  MD = 840,
  LG = 1440,
}

// 高度断点阈值节点(高宽比)
enum HeightBpNode {
  SM = 0.8,
  MD = 1.2,
}

// 拼接宽高断点
function spliceBp(widthBp: SizeBp, heightBp: SizeBp): string {
  return `${widthBp}_${heightBp}`;
}

// 断点拼接默认映射关系
const BP_SPLICE: Map<string, SizeBpSplice> = new Map([
  [spliceBp(SizeBp.SM, SizeBp.MD), SizeBpSplice.SM],
  [spliceBp(SizeBp.MD, SizeBp.SM), SizeBpSplice.MS],
  [spliceBp(SizeBp.LG, SizeBp.SM), SizeBpSplice.LS],
  [spliceBp(SizeBp.XL, SizeBp.SM), SizeBpSplice.XS],
  [spliceBp(SizeBp.MD, SizeBp.MD), SizeBpSplice.MM],
  [spliceBp(SizeBp.SM, SizeBp.LG), SizeBpSplice.SL],
  [spliceBp(SizeBp.LG, SizeBp.LG), SizeBpSplice.LL],
  [spliceBp(SizeBp.MD, SizeBp.LG), SizeBpSplice.ML],
]);

// 屏幕断点计算器
export class BpCalculator {
  // 设备默认DPI
  private static _defaultDpi: number = 0;

  private constructor() {
  }

  /**
   * 刷新默认DPI
   *
   * @param context 环境
   */
  public static updateDefaultDpi(context?: Context): void {
    if (BpCalculator._defaultDpi !== 0) {
      return;
    }
    if (context) {
      try {
        BpCalculator._defaultDpi = parseInt(settings.getValueSync(context, DEFAULT_DPI_KEY, '0'));
      } catch (e) {
        log.showError('updateDefaultDpi err.');
      }
    }
  }

  /**
   * 计算屏幕宽高断点状态
   *
   * @param screenW 屏幕宽，px
   * @param screenH 屏幕高，px
   * @param ctx 环境
   * @returns 断点状态
   */
  public static calcScreenBp(screenW: number, screenH: number, ctx?: UIContext): ScreenBp {
    let dpiWidth = BpCalculator.px2vpWithDefaultDpi(screenW);
    let dpiHeight = BpCalculator.px2vpWithDefaultDpi(screenH);
    let widthBp = BpCalculator.calibrateWidthBp(BpCalculator.getWidthBp(dpiWidth));
    let heightBp = BpCalculator.getHeightBp(dpiWidth, dpiHeight);
    let vpWidth = BpCalculator.px2vpWithContext(screenW, ctx);
    let vpHeight = BpCalculator.px2vpWithContext(screenH, ctx);
    // 断点拼接，不存在即取默认
    let bpSplice = BP_SPLICE.get(spliceBp(widthBp, heightBp)) ?? SizeBpSplice.DEFAULT;
    return { screenWidth: vpWidth, screenHeight: vpHeight, widthBp: widthBp, heightBp: heightBp, bpSplice: bpSplice };
  }

  private static px2vpWithDefaultDpi(value: number): number {
    if (BpCalculator._defaultDpi !== 0) {
      const density = BpCalculator._defaultDpi / BASE_DPI;
      return value / density;
    }
    return px2vp(value);
  }

  private static px2vpWithContext(value: number, ctx?: UIContext): number {
    if (ctx) {
      return ctx.px2vp(value);
    }
    return px2vp(value);
  }

  private static calibrateWidthBp(oriBp: SizeBp): SizeBp {
    // 校准横向断点，当横向断点落在LG范围时，如果非PAD或超大屏设备，则统一按直板机横屏处理
    if (oriBp !== SizeBp.LG) {
      return oriBp;
    }
    if (DeviceHelper.isUltraScreenProduct() || DeviceHelper.isPad() || DeviceHelper.isPC()) {
      return oriBp;
    }
    return SizeBp.MD;
  }

  private static getWidthBp(screenW: number): SizeBp {
    if (screenW < WidthBpNode.XS) {
      return SizeBp.XS;
    } else if (screenW >= WidthBpNode.XS && screenW < WidthBpNode.SM) {
      return SizeBp.SM;
    } else if (screenW >= WidthBpNode.SM && screenW < WidthBpNode.MD) {
      return SizeBp.MD;
    } else if (screenW >= WidthBpNode.MD && screenW < WidthBpNode.LG) {
      return SizeBp.LG;
    } else {
      return SizeBp.XL;
    }
  }

  private static getHeightBp(screenW: number, screenH: number): SizeBp {
    if (screenW === 0) { // 默认直板机竖屏
      return SizeBp.LG;
    }
    let aspectRatio = screenH / screenW;
    if (aspectRatio < HeightBpNode.SM) {
      return SizeBp.SM;
    } else if (aspectRatio >= HeightBpNode.SM && aspectRatio < HeightBpNode.MD) {
      return SizeBp.MD;
    } else {
      return SizeBp.LG;
    }
  }
}

const TAG = 'BpComparator';
const MAX_LIMIT = 10;

// 屏幕断点比较器
export class BpComparator {
  // 断点数值映射关系
  private static readonly BP_MAP: Map<SizeBp, SizeBpNum> = new Map([
    [SizeBp.XS, SizeBpNum.XS],
    [SizeBp.SM, SizeBpNum.SM],
    [SizeBp.MD, SizeBpNum.MD],
    [SizeBp.LG, SizeBpNum.LG],
    [SizeBp.XL, SizeBpNum.XL],
  ]);

  // 断点比较器
  private static readonly BP_CPT: LimitMap<SizeBp, BpComparator> = new LimitMap(TAG, MAX_LIMIT);

  /**
   * 锚定断点
   */
  private readonly anchorBp: SizeBp;

  private constructor(anchor: SizeBp) {
    this.anchorBp = anchor;
  }

  /**
   * 断点相等判断
   *
   * @param tarBp 目标断点
   * @returns true相等
   */
  public equals(tarBp: SizeBp): boolean {
    return tarBp === this.anchorBp;
  }

  /**
   * 断点大于判断
   *
   * @param tarBp 目标断点
   * @returns true目标断点大于锚定断点
   */
  public more(tarBp: SizeBp): boolean {
    let tarMap = BpComparator.BP_MAP.get(tarBp) ?? SizeBpNum.XS;
    let anchorMap = BpComparator.BP_MAP.get(this.anchorBp) ?? SizeBpNum.XS;
    return tarMap > anchorMap;
  }

  /**
   * 断点小于判断
   *
   * @param tarBp 目标断点
   * @returns true目标断点小于锚定断点
   */
  public less(tarBp: SizeBp): boolean {
    let tarMap = BpComparator.BP_MAP.get(tarBp) ?? SizeBpNum.XS;
    let anchorMap = BpComparator.BP_MAP.get(this.anchorBp) ?? SizeBpNum.XS;
    return tarMap < anchorMap;
  }

  /**
   * 断点大于等于判断
   *
   * @param tarBp 目标断点
   * @returns true目标断点大于等于锚定断点
   */
  public moreEquals(tarBp: SizeBp): boolean {
    let tarMap = BpComparator.BP_MAP.get(tarBp) ?? SizeBpNum.XS;
    let anchorMap = BpComparator.BP_MAP.get(this.anchorBp) ?? SizeBpNum.XS;
    return tarMap >= anchorMap;
  }

  /**
   * 断点小于等于判断
   *
   * @param tarBp 目标断点
   * @returns true目标断点小于等于锚定断点
   */
  public lessEquals(tarBp: SizeBp): boolean {
    let tarMap = BpComparator.BP_MAP.get(tarBp) ?? SizeBpNum.XS;
    let anchorMap = BpComparator.BP_MAP.get(this.anchorBp) ?? SizeBpNum.XS;
    return tarMap <= anchorMap;
  }

  /**
   * 获取比较器
   *
   * @param anchorBp 锚定断点
   * @returns 比较器
   */
  public static getCpt(anchorBp: SizeBp): BpComparator {
    let cpt = BpComparator.BP_CPT.get(anchorBp);
    if (!cpt) {
      cpt = new BpComparator(anchorBp);
      BpComparator.BP_CPT.set(anchorBp, cpt);
    }
    return cpt;
  }

  /**
   * XS断点比较器
   *
   * @returns 比较器
   */
  public static getXSCpt(): BpComparator {
    return BpComparator.getCpt(SizeBp.XS);
  }

  /**
   * SM断点比较器
   *
   * @returns 比较器
   */
  public static getSMCpt(): BpComparator {
    return BpComparator.getCpt(SizeBp.SM);
  }

  /**
   * MD断点比较器
   *
   * @returns 比较器
   */
  public static getMDCpt(): BpComparator {
    return BpComparator.getCpt(SizeBp.MD);
  }

  /**
   * LG断点比较器
   *
   * @returns 比较器
   */
  public static getLGCpt(): BpComparator {
    return BpComparator.getCpt(SizeBp.LG);
  }

  /**
   * XL断点比较器
   *
   * @returns 比较器
   */
  public static getXLCpt(): BpComparator {
    return BpComparator.getCpt(SizeBp.XL);
  }
}
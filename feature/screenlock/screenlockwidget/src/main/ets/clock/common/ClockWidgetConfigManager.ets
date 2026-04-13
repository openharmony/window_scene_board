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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { LimitMap } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { aodClock01, comClock01 } from '../constants/ComClockLayout01';
import { aodClock02, comClock02 } from '../constants/ComClockLayout02';
import { aodClock03, comClock03 } from '../constants/ComClockLayout03';
import { aodClock04, comClock04 } from '../constants/ComClockLayout04';
import { aodClock05, comClock05 } from '../constants/ComClockLayout05';
import { aodClock06, comClock06 } from '../constants/ComClockLayout06';
import { aodClock07, comClock07 } from '../constants/ComClockLayout07';
import { aodClock08, comClock08 } from '../constants/ComClockLayout08';
import { aodUdClock01, udClock01 } from '../constants/UDClockLayout01';
import { aodUdClock02, udClock02 } from '../constants/UDClockLayout02';
import { aodUdClock03, udClock03 } from '../constants/UDClockLayout03';
import { aodUdClock04, udClock04 } from '../constants/UDClockLayout04';
import { ElementConf, ClockGridParam } from './ClockLayoutParam';
import { ClockComFamily, ClockLayout } from '../../common/WidgetParam';
import {
  TextSizeConf,
  TEXT_SIZE_FOR_HARMONY_CLOCK_01,
  TEXT_SIZE_FOR_HARMONY_CLOCK_02,
  TEXT_SIZE_FOR_HARMONY_CLOCK_03,
  TEXT_SIZE_FOR_HARMONY_CLOCK_04,
  TEXT_SIZE_FOR_HARMONY_CLOCK_05,
  TEXT_SIZE_FOR_HARMONY_CLOCK_06,
  TEXT_SIZE_FOR_HARMONY_CLOCK_07,
  TEXT_SIZE_FOR_HARMONY_CLOCK_08,
  TEXT_SIZE_FOR_HARMONY_CLOCK_UD_LAYOUT1,
  TEXT_SIZE_FOR_HARMONY_CLOCK_UD_LAYOUT_2_4
} from '../constants/TextSizeForDIffFontFamily';
import { UDFontAdapterUtil } from './UDFontAdapterUtil';
import { IClockConfigManager } from '../../common/adapter/IClockConfigManager';
import { IClockStyleConfig } from '../model/data/IClockStyleConfig';
import { aodComClock01V, comClock01V } from '../constants/ComClockLayout01V';
import { aodComClock02V, comClock02V } from '../constants/ComClockLayout02V';
import { aodComClock05V, comClock05V } from '../constants/ComClockLayout05V';
import { aodComClock06V, comClock06V } from '../constants/ComClockLayout06V';
import { AodClockStyleConfig, AOD_DEFAULT_MERGE_MARGIN } from '../model/data/AodClockStyleConfig';
import { DateWeekLunarStyle } from './ClockConstants';

const TAG: string = 'ClockWidgetConfigManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

/**
 * 时钟样式配置管理类
 */
export class ClockWidgetConfigManager implements IClockConfigManager {
  // 时钟样式配置表
  private readonly clockStyleCfg: LimitMap<ClockLayout, IClockStyleConfig> = new LimitMap();
  private readonly aodClockStyleCfg: LimitMap<ClockLayout, AodClockStyleConfig> = new LimitMap();
  // 字体样式大小配置
  private textSizeForDiffFontFamilyMap: Map<string, TextSizeConf> = new Map();

  constructor() {
    // 数字时钟样式01
    this.bindClockStyleCfg(comClock01);
    // 数字时钟样式02
    this.bindClockStyleCfg(comClock02);
    // 数字时钟样式03
    this.bindClockStyleCfg(comClock03);
    // 数字时钟样式03
    this.bindClockStyleCfg(comClock04);
    // 数字时钟样式05
    this.bindClockStyleCfg(comClock05);
    // 数字时钟样式06
    this.bindClockStyleCfg(comClock06);
    // 数字时钟样式07
    this.bindClockStyleCfg(comClock07);
    // 数字时钟样式08
    this.bindClockStyleCfg(comClock08);

    // 数字时钟样式翻转样式
    this.bindClockStyleCfg(comClock01V);
    this.bindClockStyleCfg(comClock02V);
    this.bindClockStyleCfg(comClock05V);
    this.bindClockStyleCfg(comClock06V);

    this.initForOneShot();
    this.initStyle4UD();
    this.initAodStyle();
  }

  private initStyle4UD() {
    if (!UDFontAdapterUtil.isUD()) {
      return;
    }
    // UD数字时钟样式01
    this.bindClockStyleCfg(udClock01);
    // UD数字时钟样式02
    this.bindClockStyleCfg(udClock02);
    // UD数字时钟样式03
    this.bindClockStyleCfg(udClock03);
    // UD数字时钟样式04
    this.bindClockStyleCfg(udClock04);

    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_ULT_01, TEXT_SIZE_FOR_HARMONY_CLOCK_UD_LAYOUT1);
    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_ULT_2_4,
      TEXT_SIZE_FOR_HARMONY_CLOCK_UD_LAYOUT_2_4);

    this.bindAodClockStyleCfg(aodUdClock01);
    this.bindAodClockStyleCfg(aodUdClock02);
    this.bindAodClockStyleCfg(aodUdClock03);
    this.bindAodClockStyleCfg(aodUdClock04);
  }

  private initForOneShot() {
    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_01, TEXT_SIZE_FOR_HARMONY_CLOCK_01);
    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_02, TEXT_SIZE_FOR_HARMONY_CLOCK_02);
    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_03, TEXT_SIZE_FOR_HARMONY_CLOCK_03);
    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_04, TEXT_SIZE_FOR_HARMONY_CLOCK_04);
    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_05, TEXT_SIZE_FOR_HARMONY_CLOCK_05);
    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_06, TEXT_SIZE_FOR_HARMONY_CLOCK_06);
    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_07, TEXT_SIZE_FOR_HARMONY_CLOCK_07);
    this.textSizeForDiffFontFamilyMap.set(ClockComFamily.HARMONY_CLOCK_08, TEXT_SIZE_FOR_HARMONY_CLOCK_08);
  }

  private initAodStyle() {
    // 局部AOD时钟样式
    this.bindAodClockStyleCfg(aodClock01);
    this.bindAodClockStyleCfg(aodClock02);
    this.bindAodClockStyleCfg(aodClock03);
    this.bindAodClockStyleCfg(aodClock04);
    this.bindAodClockStyleCfg(aodClock05);
    this.bindAodClockStyleCfg(aodClock06);
    this.bindAodClockStyleCfg(aodClock07);
    this.bindAodClockStyleCfg(aodClock08);

    // 数字时钟样式翻转样式
    this.bindAodClockStyleCfg(aodComClock01V);
    this.bindAodClockStyleCfg(aodComClock02V);
    this.bindAodClockStyleCfg(aodComClock05V);
    this.bindAodClockStyleCfg(aodComClock06V);
  }

  public bindClockStyleCfg(cfg: IClockStyleConfig): void {
    if (cfg) {
      this.clockStyleCfg.set(cfg.getClockLayout(), cfg);
    }
  }

  public bindAodClockStyleCfg(cfg: AodClockStyleConfig): void {
    if (cfg) {
      this.aodClockStyleCfg.set(cfg.getClockLayout(), cfg);
    }
  }


  public deleteClockStyleCfg(cfg: IClockStyleConfig): void {
    if (cfg) {
      this.clockStyleCfg.delete(cfg.getClockLayout());
    }
  }

  /**
   * 获取目标样式的展开态时钟配置参数
   *
   * @param type 目标样式
   * @returns 时钟配置参数
   */
  public getExpandClockStyleByType(type: ClockLayout): ElementConf[] | undefined {
    let newType: ClockLayout = this.getTargetLayoutType(type);
    return this.clockStyleCfg.get(newType)?.getExpandElementArr();
  }

  /**
   * 获取目标样式的收起态时钟配置参数
   *
   * @param type 目标样式
   * @returns 时钟配置参数
   */
  public getCollapseClockStyleByType(type: ClockLayout): ElementConf[] | undefined {
    let newType: ClockLayout = this.getTargetLayoutType(type);
    return this.clockStyleCfg.get(newType)?.getCollapseElementArr();
  }

  /**
   * 获取目标样式的展开态时钟网格参数
   *
   * @param type 目标样式
   * @returns 时钟网格参数
   */
  public getExpandClockGridType(type: ClockLayout): ClockGridParam | undefined {
    let newType: ClockLayout = this.getTargetLayoutType(type);
    return this.clockStyleCfg.get(newType)?.getExpandGrid();
  }

  /**
   * 获取目标样式的收起态时钟网格参数
   *
   * @param type 目标样式
   * @returns 时钟网格参数
   */
  public getCollapseClockGridType(type: ClockLayout): ClockGridParam | undefined {
    let newType: ClockLayout = this.getTargetLayoutType(type);
    return this.clockStyleCfg.get(newType)?.getCollapseGrid();
  }

  /**
   * 获取一镜到底动画目标样式的收起态时钟网格参数
   *
   * @param type 目标样式
   * @returns 时钟网格修正参数
   */
  public getOneShotAniCollapseClockGridType(type: ClockLayout): ClockGridParam | undefined {
    let newType: ClockLayout = this.getTargetLayoutType(type);
    return this.clockStyleCfg.get(newType)?.getOneShotGrid();
  }

  /**
   * 获取目标样式的默认字体
   *
   * @param type 目标样式
   * @returns 默认字体
   */
  public getClockDefaultFontFamily(type: ClockLayout): string {
    let newType: ClockLayout = this.getTargetLayoutType(type);
    let defaultFontFamily: string | undefined = this.clockStyleCfg.get(newType)?.getFontFamily();
    let fontFamily: string = ClockComFamily.HARMONY_CLOCK_01;
    if (defaultFontFamily) {
      fontFamily = defaultFontFamily;
    }
    return fontFamily;
  }

  private getTargetLayoutType(type: ClockLayout): ClockLayout {
    let newType: ClockLayout = type;
    if (type === ClockLayout.DIMENSION_4_4 || type === ClockLayout.DIMENSION_4_2) {
      newType = ClockLayout.DEFAULT_CLOCK_LAYOUT;
    } else if (type === ClockLayout.DIMENSION_2_4) {
      newType = ClockLayout.NORMAL_CLOCK_LAYOUT;
    }
    newType = UDFontAdapterUtil.transferLayout4UD(newType);
    // 不存在映射类型，使用原类型
    if (!this.clockStyleCfg.has(newType)) {
      return type;
    }
    return newType;
  }

  /**
   * 获取字体对应的渲染尺寸信息
   *
   * @param fontFamily
   * @returns 字体对应的渲染尺寸信息
   */
  public getTextSizeConf(fontFamily: string): TextSizeConf | undefined {
    return this.textSizeForDiffFontFamilyMap.get(fontFamily);
  }

  /**
   * 获取局部AOD一镜到底假AOD状态
   * @param type ClockLayout
   * @returns ElementConf[]
   */
  public getAodClockStyleByType(type: ClockLayout): Nullable<ElementConf[]> {
    let newType: ClockLayout = this.getTargetLayoutType(type);
    return this.aodClockStyleCfg.get(newType)?.getAodElementArr();
  }

  /**
   * 获取AOD样式锁屏时钟顶部距离
   * @param type ClockLayout
   * @returns number
   */
  public getAodClockMarginByType(type: ClockLayout): Nullable<Margin> {
    let newType: ClockLayout = this.getTargetLayoutType(type);
    return this.aodClockStyleCfg.get(newType)?.getAodClockMargin();
  }

  /**
   * 获取时钟有签名后是否合并为一行
   * @param type ClockLayout
   * @returns boolean
   */
  public getAodClockMergeWeekLunar(type: ClockLayout): Nullable<DateWeekLunarStyle> {
    let newType: ClockLayout = this.getTargetLayoutType(type);
    return this.aodClockStyleCfg.get(newType)?.getMergeWeekLunarStyle();
  }
}

export let clockWidgetConfigManager = SingletonHelper.getInstance(ClockWidgetConfigManager, TAG);

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

import { BaseState,
  SlStateMgr,
  SlStateId } from '@ohos/screenlockcommon/src/main/ets/TsIndex';
import { SizeBpSplice, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { CapShowType, CapStyleSuffix } from '../../common/constants/ImmCapConst';
import { CardShowType } from '../../common/constants/ImmCardConst';
import { CardStyleSuffix } from '../../common/constants/ImmCardConst';
import { ListStyleSuffix } from '../../common/constants/ImmListConst';
import { IImmStyleConfigHelper } from '../../common/interface/IImmStyleConfigHelper';
import { SlCapConfigStateV2 } from '../data/v2/SlCapConfigStateV2';
import { SlCardConfigStateV2 } from '../data/v2/SlCardConfigStateV2';
import { SlImmConfigStateV2 } from '../data/v2/SlImmConfigStateV2';
import { SlImmStateConfig } from '../data/v2/SlImmStateConfig';
import { SlListConfigStateV2 } from '../data/v2/SlListConfigStateV2';
import lazy { CapStyleConfigH } from './CapStyleConfigHelper';
import lazy { CardStyleConfigH } from './CardStyleConfigHelper';
import lazy { ListStyleConfigH } from './ListStyleConfigHelper';

// 沉浸模块默认配置
const IMM_DEFAULT_CONFIG = BaseState.wrap<SlImmConfigStateV2>(SlImmConfigStateV2);

/**
 * 沉浸模块默认样式配置统一管理
 */
export class ImmStyleConfigH implements IImmStyleConfigHelper {
  // 实例管理
  private static sInstance: Map<SlStateMgr, ImmStyleConfigH> = new Map();

  // 沉浸模块扩展配置
  private readonly immConfig: SlImmStateConfig = SlImmStateConfig.wrap(SlStateId.SL_IMMERSIVE_STATE)
    .bindConfig(IMM_DEFAULT_CONFIG);

  // 列表配置
  private listConfig?: ListStyleConfigH;

  // 胶囊配置
  private capConfig?: CapStyleConfigH;

  // 大卡配置
  private cardConfig?: CardStyleConfigH;

  private constructor() {
  }

  private getListCfg(): ListStyleConfigH {
    if (!this.listConfig) {
      this.listConfig = new ListStyleConfigH();
    }
    return this.listConfig;
  }

  private getCapCfg(): CapStyleConfigH {
    if (!this.capConfig) {
      this.capConfig = new CapStyleConfigH();
    }
    return this.capConfig;
  }

  private getCardCfg(): CardStyleConfigH {
    if (!this.cardConfig) {
      this.cardConfig = new CardStyleConfigH();
    }
    return this.cardConfig;
  }

  /**
   * 设置沉浸模块配置，用于产品差异化配置
   *
   * @param config 配置
   */
  public setImmConfig(config: SlImmConfigStateV2): void {
    if (config) {
      this.immConfig.bindBpConfig(config.getBpSplice(), config);
    }
  }

  /**
   * 取值沉浸模块配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 配置
   */
  public getImmConfig(bpSplice?: SizeBpSplice): SlImmConfigStateV2 {
    let bpResult = bpSplice ?? SizeBpSplice.DEFAULT;
    let config = this.immConfig.getBpConfig(bpResult);
    if (config) {
      return config;
    }
    // 无对应场景时，取默认值
    return this.immConfig.getConfig() ?? IMM_DEFAULT_CONFIG;
  }

  /**
   * 沉浸列表配置工具
   *
   * @param listCfg 列表配置
   */
  public setListConfigHelper(listCfg: ListStyleConfigH): void {
    if (listCfg) {
      this.listConfig = listCfg;
    }
  }

  /**
   * 取值列表样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getListRootStyle(bpSplice?: SizeBpSplice): WidgetStyleStateV2 {
    return this.getListCfg().getListRootStyle(bpSplice);
  }

  /**
   * 取值列表配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 配置
   */
  public getListConfig(bpSplice?: SizeBpSplice): SlListConfigStateV2 {
    return this.getListCfg().getListConfig(bpSplice);
  }

  /**
   * 取值列表条目样式配置
   *
   * @param listSf 样式后缀
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getListItemStyle(listSf: ListStyleSuffix, bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT): WidgetStyleStateV2 {
    return this.getListCfg().getListItemStyle(listSf, bpSplice);
  }

  /**
   * 沉浸胶囊配置工具
   *
   * @param capCfg 胶囊配置
   */
  public setCapConfigHelper(capCfg: CapStyleConfigH): void {
    if (capCfg) {
      this.capConfig = capCfg;
    }
  }

  /**
   * 取值胶囊样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCapRootStyle(bpSplice?: SizeBpSplice): WidgetStyleStateV2 {
    return this.getCapCfg().getCapRootStyle(bpSplice);
  }

  /**
   * 取值胶囊默认配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 胶囊配置
   */
  public getCapConfig(bpSplice?: SizeBpSplice): SlCapConfigStateV2 {
    return this.getCapCfg().getCapConfig(bpSplice);
  }

  /**
   * 取值胶囊条目样式配置
   *
   * @param capType 胶囊类型
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCapItemStyle(capType: CapShowType, bpSplice?: SizeBpSplice): WidgetStyleStateV2 {
    return this.getCapCfg().getCapItemStyle(capType, bpSplice);
  }

  /**
   * 取值胶囊通用布局样式配置
   *
   * @param capSf 胶囊样式后缀
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCapComViewStyle(capSf: CapStyleSuffix, bpSplice?: SizeBpSplice): WidgetStyleStateV2 | undefined {
    return this.getCapCfg().getCapComViewStyle(capSf, bpSplice);
  }

  /**
   * 沉浸大卡配置工具
   *
   * @param cardCfg 大卡配置
   */
  public setCardConfigHelper(cardCfg: CardStyleConfigH): void {
    if (cardCfg) {
      this.cardConfig = cardCfg;
    }
  }

  /**
   * 取值沉浸大卡默认配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 大卡配置
   */
  public getCardConfig(bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT): SlCardConfigStateV2 {
    return this.getCardCfg().getCardConfig(bpSplice);
  }

  /**
   * 取值沉浸大卡root样式配置
   *
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCardRootStyle(bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT): WidgetStyleStateV2 {
    return this.getCardCfg().getCardRootStyle(bpSplice);
  }

  /**
   * 取值沉浸大卡条目样式配置
   *
   * @param cardType 大卡类型
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCardItemStyle(cardType: CardShowType, bpSplice: SizeBpSplice = SizeBpSplice.DEFAULT): WidgetStyleStateV2 {
    return this.getCardCfg().getCardItemStyle(cardType, bpSplice);
  }

  /**
   * 取值沉浸大卡通用布局样式配置
   *
   * @param cardSf 通用布局样式后缀
   * @param bpSplice 屏幕断点拼接
   * @returns 样式配置
   */
  public getCardComViewStyle(cardSf: CardStyleSuffix, bpSplice?: SizeBpSplice): WidgetStyleStateV2 | undefined {
    return this.getCardCfg().getCardComViewStyle(cardSf, bpSplice);
  }

  /**
   * 实例获取
   *
   * @param mgrName 状态管理名
   * @returns 实例
   */
  public static getInstance(mgrName: SlStateMgr): ImmStyleConfigH {
    let helper = ImmStyleConfigH.sInstance.get(mgrName);
    if (helper) {
      return helper;
    }
    helper = new ImmStyleConfigH();
    ImmStyleConfigH.sInstance.set(mgrName, helper);
    return helper;
  }
}
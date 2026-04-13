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

import { WidgetAnimStateV2, WidgetStyleStateV2 } from '@ohos/screenlockcommon/Index';
import { CardAnimScene, CardAnimSuffix, CardShowType } from '../../../../common/constants/ImmCardConst';
import { IImmersiveCardAnimVm } from '../../../../common/interface/IImmersiveCardAnimVm';
import { ImmCardAnimConfig } from '../../../../model/data/config/ImmCardAnimConfig';
import { ImmCardCfgKey } from '../../../../model/data/config/ImmCardCfgKey';
import { ImmCardPtConfig } from '../../../../model/data/config/ImmCardPtConfig';
import { ImmCardCheckData } from '../../../../model/data/v2/ImmCardCheckData';
import { ImmCardDataArray } from '../../../../model/data/v2/ImmCardDataArray';
import { SlCardBindStateV2 } from '../../../../model/data/v2/SlCardBindStateV2';
import { ICardLifeCycleAnim } from './ICardLifeCycleAnim';
import { ImmBaseLifeCycleAnim } from './ImmBaseLifeCycleAnim';

/**
 * 沉浸大卡生命周期动效基类
 */
export abstract class CardBaseLifeCycleAnim extends ImmBaseLifeCycleAnim<ImmCardPtConfig, ImmCardAnimConfig>
  implements ICardLifeCycleAnim {
  /**
   * 动效场景
   *
   * @returns 场景
   */
  public abstract getAnimScene(): CardAnimScene;

  /**
   * 沉浸大卡动效配置实例
   *
   * @returns 动效配置
   */
  protected createAnimCfg(): ImmCardAnimConfig {
    return ImmCardAnimConfig.wrap(this.getAnimScene());
  }

  /**
   * 沉浸大卡根布局动效管理器
   *
   * @returns 动效管理器
   */
  protected getRootAnim(): WidgetAnimStateV2 | undefined {
    return this.getCardAnimVm()?.getRootAnimSt();
  }

  /**
   * 沉浸大卡条目通用动效管理器
   *
   * @param cardType 条目类型
   * @returns 动效管理器
   */
  protected getItemComAnim(cardType: CardShowType): WidgetAnimStateV2 | undefined {
    return this.getCardAnimVm()?.getItemComAnimSt(cardType);
  }

  /**
   * 沉浸大卡条目通用样式
   *
   * @param cardType 条目类型
   * @returns 样式管理器
   */
  protected getItemComStyle(cardType: CardShowType): WidgetStyleStateV2 | undefined {
    return this.getCardAnimVm()?.getItemComStyle(cardType);
  }

  /**
   * 沉浸大卡模块动效业务管理器
   *
   * @returns 动效业务
   */
  protected getCardAnimVm(): IImmersiveCardAnimVm | undefined {
    return this.vmInjector?.getImmersiveCardAnimVm();
  }

  /**
   * 根布局动效key
   *
   * @returns key
   */
  protected getRootKey(): ImmCardCfgKey {
    return ImmCardCfgKey.genKey();
  }

  /**
   * 通用动效key
   *
   * @param cardType 沉浸大卡类型
   * @returns key
   */
  protected getItemComKey(cardType: CardShowType): ImmCardCfgKey {
    return ImmCardCfgKey.genKey(cardType, CardAnimSuffix.ITEM_COMMON_ANIM);
  }

  /**
   * 沉浸大卡UI绑定状态
   *
   * @returns 状态
   */
  protected getCardBindSt(): SlCardBindStateV2 | undefined {
    return this.vmInjector?.getImmersiveCardVm()?.getSlBindState() as SlCardBindStateV2;
  }

  /**
   * 沉浸大卡数据
   *
   * @returns 数据
   */
  protected getCardData(): ImmCardDataArray | undefined {
    return this.vmInjector?.getImmersiveCardVm()?.getSlCardData();
  }

  /**
   * 沉浸大卡数据动效检测列表
   *
   * @returns 数据列表
   */
  protected getCheckCardData(): ImmCardCheckData | undefined {
    return this.vmInjector?.getImmersiveCardVm()?.getCheckCardData();
  }
}
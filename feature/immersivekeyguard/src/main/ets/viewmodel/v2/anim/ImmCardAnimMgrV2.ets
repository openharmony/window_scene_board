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

import { curves } from '@kit.ArkUI';
import {
  AnimEvent,
  ComponentPosition,
  WidgetAnimState,
  WidgetAnimStateV2,
  WidgetStyleStateV2
} from '@ohos/screenlockcommon/Index';
import {
  CardAnimScene,
  CardAnimSuffix,
  CardCacheSuffix,
  CardShowType,
  CardStyleSuffix
} from '../../../common/constants/ImmCardConst';
import { ImmersiveComHelper } from '../../../common/helper/ImmersiveComHelper';
import { IImmersiveCardAnimVm } from '../../../common/interface/IImmersiveCardAnimVm';
import { IImmersiveCardVm } from '../../../common/interface/IImmersiveCardVm';
import { IImmItemHelperVm } from '../../../common/interface/IImmItemHelperVm';
import { ImmCardDataArray } from '../../../model/data/v2/ImmCardDataArray';
import { ImmAnimBaseMgrV2 } from './ImmAnimBaseManagerV2';

/**
 * 沉浸大卡模块动效管理业务
 */
export class ImmCardAnimMgrV2 extends ImmAnimBaseMgrV2 implements IImmersiveCardAnimVm {
  isCardValid(type: CardShowType): boolean {
    // 存在对应类型数据，则认定类型有效
    return Boolean(this.getCardData()?.getCardData(type));
  }

  isCardContent(type: CardShowType): boolean {
    return type === CardShowType.CARD_CONTENT;
  }

  isCardNone(type: CardShowType): boolean {
    return type === CardShowType.CARD_NONE;
  }

  isCardUpdate(type: CardShowType): boolean {
    return type === CardShowType.CARD_UPDATE_OLD;
  }

  isCardDelete(type: CardShowType): boolean {
    return type === CardShowType.CARD_DELETE;
  }

  getRootAnimSt(): WidgetAnimStateV2 {
    return this.getCardVm()?.getSlAnimState();
  }

  getItemComAnimSt(type: CardShowType): WidgetAnimStateV2 | undefined {
    return this.getItemHelper()?.getCardAnimH(CardAnimSuffix.ITEM_COMMON_ANIM)?.getItemSt(type);
  }

  getLiveCardAnimV1St(): WidgetAnimState {
    return ImmersiveComHelper.getLiveCardV1Anim();
  }

  getLiveCardAnimSt(type: CardShowType): WidgetAnimStateV2 | undefined {
    return this.getItemHelper()?.getCardAnimH(CardAnimSuffix.LIVE_CARD_ANIM)?.getItemSt(type);
  }

  getRootStyle(): WidgetStyleStateV2 {
    return this.getCardVm()?.getSlStyleState();
  }

  getItemComStyle(type: CardShowType): WidgetStyleStateV2 | undefined {
    return this.getItemHelper()?.getCardStyleH(CardStyleSuffix.ITEM_COMMON_STYLE)?.getItemSt(type);
  }

  getRootPos(): ComponentPosition {
    return this.getCardVm()?.getSlCacheState()?.getWidgetPosition();
  }

  getItemComPos(type: CardShowType): ComponentPosition | undefined {
    let helper = this.getItemHelper()?.getCardCacheH(CardCacheSuffix.ITEM_COMMON_CACHE);
    return helper?.getItemSt(type)?.getWidgetPosition();
  }

  getItemLivePos(groupKey?: string): ComponentPosition | undefined {
    return this.getCardVm()?.getRealLiveCardPos?.(groupKey);
  }

  getClickLivePos(): ComponentPosition | undefined {
    return this.getCardVm()?.getClickLiveCardPos?.();
  }

  getLiveCapPos(): ComponentPosition | undefined {
    return this.getCardVm()?.getLiveCapPos?.();
  }

  startLifeCycleAnim(scene?: CardAnimScene): void {
    // 无动效场景
    if (scene === undefined || scene === CardAnimScene.ANIM_NONE) {
      return;
    }
    // 开启生命周期动效
    this.getVmInjector()?.getCardLifeCycleAnimFactory()?.createImmAnim(scene)?.onLifeCycleAnim();
  }

  startLiveCardFoldAnim(endValue: AnimEvent): void {
    let animParam: AnimateParam = { curve: curves.interpolatingSpring(0, 1, 228, 23) };
    this.getAnimExeMgr()?.animateTo({
      mainScene: CardAnimScene.ANIM_LIVE_FOLD,
      oriParam: animParam,
      oriEvent: endValue
    });
  }

  private getCardData(): ImmCardDataArray | undefined {
    return this.getCardVm()?.getSlCardData();
  }

  private getCardVm(): IImmersiveCardVm {
    return this.getVmInjector()?.getImmersiveCardVm();
  }

  private getItemHelper(): IImmItemHelperVm {
    return this.getVmInjector()?.getImmItemHelperVm();
  }
}
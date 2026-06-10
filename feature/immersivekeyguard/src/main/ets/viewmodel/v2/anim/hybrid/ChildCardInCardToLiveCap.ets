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

import {
  WAnimProperty,
  WAnimScene,
  WBaseProperty
} from '@ohos/screenlockcommon';
import { CmpPosWrapper, WidgetPropertyConfig } from '@ohos/screenlockcommon/Index';
import { CardShowType } from '../../../../common/constants/ImmCardConst';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ChildHybridBaseAnim } from './ChildHybridBaseAnim';

/**
 * 大卡过渡实况胶囊动效中大卡子模块
 * 内容大卡渐隐，实况卡片从大卡区域过渡到胶囊区域
 */
export class ChildCardInCardToLiveCap extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // 胶囊大卡初始化
    initCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, scene).bindConfig(WBaseProperty.ALPHA, 1)
      .addPtState(this.getCardComAnim(CardShowType.CARD_CAP)))
      // 实况卡片初始化
      .bindConfig(this.getCardLiveKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .bindConfig(WBaseProperty.TRAN_X, 0).bindConfig(WBaseProperty.TRAN_Y, 0)
        .bindConfig(WBaseProperty.SCALE_X, 1).bindConfig(WBaseProperty.SCALE_Y, 1)
        .bindConfig(WBaseProperty.BORDER_RADIUS_TL, undefined)
        .addPtState(this.getCardLiveAnim(CardShowType.CARD_CAP)))
      // V1实况卡片初始化
      .bindConfig(this.getCardLiveV1Key(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .bindConfig(WBaseProperty.TRAN_X, 0).bindConfig(WBaseProperty.TRAN_Y, 0)
        .bindConfig(WBaseProperty.SCALE_X, 1).bindConfig(WBaseProperty.SCALE_Y, 1)
        .bindConfig(WBaseProperty.BORDER_RADIUS_TL, undefined)
        .addPtState(this.getCardLiveV1Anim()))
      // root大卡初始化
      .bindConfig(this.getCardRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene).addPtState(this.getCardRootAnim()));
  }

  public buildFinishCfg(finishCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildFinishCfg(finishCfg, scene);
    // 胶囊大卡finish
    finishCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardComAnim(CardShowType.CARD_CAP)))
      // 实况卡片finish
      .bindConfig(this.getCardLiveKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardLiveAnim(CardShowType.CARD_CAP)))
      // V1实况卡片finish
      .bindConfig(this.getCardLiveV1Key(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene).addPtState(this.getCardLiveV1Anim()))
      // root大卡finish
      .bindConfig(this.getCardRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene).addPtState(this.getCardRootAnim()));
  }

  public buildEndCfg(endCfg: ImmComPtConfig): void {
    this.addAlphaEndCfg(endCfg);
    this.addMainEndCfg(endCfg);
  }

  private addAlphaEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgAlphaName()) {
      return;
    }
    // 胶囊大卡
    endCfg.bindConfig(this.getCardComKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 0).addPtState(this.getCardComAnim(CardShowType.CARD_CAP)));
  }

  private addMainEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgMainName()) {
      return;
    }
    // 实况卡片
    endCfg.bindConfig(this.getCardLiveKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
      .addPtState(this.getCardLiveAnim(CardShowType.CARD_CAP)));
    // V1实况卡片
    endCfg.bindConfig(this.getCardLiveV1Key(), WidgetPropertyConfig.wrap()
      .addPtState(this.getCardLiveV1Anim()));
    // 动效结束，清除胶囊大卡
    endCfg.getAnimParam()?.addStaticFinish(() => {
      this.getCardData()?.tryDelAnimCheckData(CardShowType.CARD_CAP);
    });
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndConCard(animCfg);
  }

  private initEndConCard(animCfg: ImmComAnimConfig): void {
    // 大卡中实况卡片从大卡位置过渡到实况胶囊位置，跟随主动效
    let capCard = this.getCheckCardData()?.get(CardShowType.CARD_CAP);
    this.getCardData()?.setCardData(CardShowType.CARD_CAP, capCard);
    let groupKey = capCard?.getGroupKey();
    let capPos = CmpPosWrapper.wrapper(this.getLiveCapPos());
    let cardPos = CmpPosWrapper.wrapper(this.getImmLiveCardPos(groupKey));
    let endCfg = animCfg.getEndCfg(this.getCfgMainName());
    let cardEndCfg = endCfg?.getConfig(this.getCardLiveKey(CardShowType.CARD_CAP));
    let cardV1EndCfg = endCfg?.getConfig(this.getCardLiveV1Key());
    let tranX = capPos.getCmpCenterX() - cardPos.getCmpCenterX();
    let tranY = capPos.getCmpCenterY() - cardPos.getCmpCenterY();
    let cardW = cardPos.getCmpWidth();
    let cardH = cardPos.getCmpHeight();
    let scaleX = cardW === 0 ? 1 : (capPos.getCmpWidth() / cardW);
    let scaleY = cardH === 0 ? 1 : (capPos.getCmpHeight() / cardH);
    cardEndCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, capPos.getCmpRadius())
      .bindConfig(WBaseProperty.SCALE_X, scaleX).bindConfig(WBaseProperty.SCALE_Y, scaleY)
      .bindConfig(WBaseProperty.TRAN_X, tranX).bindConfig(WBaseProperty.TRAN_Y, tranY);
    cardV1EndCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, capPos.getCmpRadius())
      .bindConfig(WBaseProperty.SCALE_X, scaleX).bindConfig(WBaseProperty.SCALE_Y, scaleY)
      .bindConfig(WBaseProperty.TRAN_X, tranX).bindConfig(WBaseProperty.TRAN_Y, tranY);
  }
}
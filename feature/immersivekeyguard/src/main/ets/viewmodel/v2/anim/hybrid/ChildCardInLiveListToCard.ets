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
 * 实况列表过渡大卡动效中大卡子模块
 * 内容大卡渐显，实况卡片从列表区域过渡到大卡区域
 */
export class ChildCardInLiveListToCard extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // 内容大卡初始化
    initCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, scene).bindConfig(WBaseProperty.ALPHA, 0)
      .addPtState(this.getCardComAnim(CardShowType.CARD_CONTENT)))
      // 实况卡片初始化
      .bindConfig(this.getCardLiveKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardLiveAnim(CardShowType.CARD_CONTENT)))
      // V1实况卡片初始化
      .bindConfig(this.getCardLiveV1Key(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene).addPtState(this.getCardLiveV1Anim()))
      // root大卡初始化
      .bindConfig(this.getCardRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene).addPtState(this.getCardRootAnim()));
  }

  public buildFinishCfg(finishCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildFinishCfg(finishCfg, scene);
    // 内容大卡finish
    finishCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardComAnim(CardShowType.CARD_CONTENT)))
      // 实况卡片finish
      .bindConfig(this.getCardLiveKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardLiveAnim(CardShowType.CARD_CONTENT)))
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
    // 内容大卡
    endCfg.bindConfig(this.getCardComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 1).addPtState(this.getCardComAnim(CardShowType.CARD_CONTENT)));
  }

  private addMainEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgMainName()) {
      return;
    }
    // 实况卡片
    endCfg.bindConfig(this.getCardLiveKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.TRAN_X, 0).bindConfig(WBaseProperty.TRAN_Y, 0)
      .bindConfig(WBaseProperty.SCALE_X, 1).bindConfig(WBaseProperty.SCALE_Y, 1)
      .bindConfig(WBaseProperty.BORDER_RADIUS_TL, undefined)
      .addPtState(this.getCardLiveAnim(CardShowType.CARD_CONTENT)));
    // V1实况卡片
    endCfg.bindConfig(this.getCardLiveV1Key(), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.TRAN_X, 0).bindConfig(WBaseProperty.TRAN_Y, 0)
      .bindConfig(WBaseProperty.SCALE_X, 1).bindConfig(WBaseProperty.SCALE_Y, 1)
      .bindConfig(WBaseProperty.BORDER_RADIUS_TL, undefined)
      .addPtState(this.getCardLiveV1Anim()));
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndConCard(animCfg);
  }

  private initEndConCard(animCfg: ImmComAnimConfig): void {
    // 大卡中实况卡片从实况列表位置过渡到大卡位置，跟随主动效
    let conCardData = this.getCardData()?.getCardData(CardShowType.CARD_CONTENT);
    let groupKey = conCardData?.getGroupKey();
    let listPos = CmpPosWrapper.wrapper(this.getClickLivePos());
    let cardPos = CmpPosWrapper.wrapper(this.getImmLiveCardPos(groupKey));
    let initCfg = animCfg.getInitCfg();
    let cardInitCfg = initCfg?.getConfig(this.getCardLiveKey(CardShowType.CARD_CONTENT));
    let cardV1InitCfg = initCfg?.getConfig(this.getCardLiveV1Key());
    let tranX = listPos.getCmpCenterX() - cardPos.getCmpCenterX();
    let tranY = listPos.getCmpCenterY() - cardPos.getCmpCenterY();
    let cardW = cardPos.getCmpWidth();
    let cardH = cardPos.getCmpHeight();
    let scaleX = cardW === 0 ? 1 : (listPos.getCmpWidth() / cardW);
    let scaleY = cardH === 0 ? 1 : (listPos.getCmpHeight() / cardH);
    cardInitCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, listPos.getCmpRadius())
      .bindConfig(WBaseProperty.SCALE_X, scaleX).bindConfig(WBaseProperty.SCALE_Y, scaleY)
      .bindConfig(WBaseProperty.TRAN_X, tranX).bindConfig(WBaseProperty.TRAN_Y, tranY);
    cardV1InitCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, listPos.getCmpRadius())
      .bindConfig(WBaseProperty.SCALE_X, scaleX).bindConfig(WBaseProperty.SCALE_Y, scaleY)
      .bindConfig(WBaseProperty.TRAN_X, tranX).bindConfig(WBaseProperty.TRAN_Y, tranY);
  }
}
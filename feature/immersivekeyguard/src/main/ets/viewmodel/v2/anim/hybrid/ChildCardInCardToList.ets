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

import { WAnimProperty, WAnimScene, WBaseProperty } from '@ohos/screenlockcommon';
import { CmpPosWrapper, WidgetPropertyConfig } from '@ohos/screenlockcommon/Index';
import { CardShowType } from '../../../../common/constants/ImmCardConst';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ChildHybridBaseAnim } from './ChildHybridBaseAnim';

/**
 * 大卡过渡列表动效中大卡子模块
 * 列表大卡从大卡区域过渡到列表区域
 */
export class ChildCardInCardToList extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // 列表大卡初始化
    initCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_LIST), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, scene)
      .bindConfig(WBaseProperty.ALPHA, 1)
      .bindConfig(WBaseProperty.TRAN_X, 0)
      .bindConfig(WBaseProperty.TRAN_Y, 0)
      .addPtState(this.getCardComAnim(CardShowType.CARD_LIST)))
      // root大卡初始化
      .bindConfig(this.getCardRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardRootAnim()))
      // V1 root大卡初始化
      .bindConfig(this.getCardV1RootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .bindConfig(WBaseProperty.Z_INDEX, this.getCardRaiseZIndex())
        .addPtState(this.getCardV1RootAnim()));
  }

  public buildFinishCfg(finishCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildFinishCfg(finishCfg, scene);
    // 列表大卡finish
    finishCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_LIST), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardComAnim(CardShowType.CARD_LIST)))
      // root大卡finish
      .bindConfig(this.getCardRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardRootAnim()))
      // V1 root大卡finish
      .bindConfig(this.getCardV1RootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardV1RootAnim()));
  }

  public buildEndCfg(endCfg: ImmComPtConfig): void {
    this.addAlphaEndCfg(endCfg);
    this.addMainEndCfg(endCfg);
  }

  private addAlphaEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgAlphaName()) {
      return;
    }
    // 列表大卡
    endCfg.bindConfig(this.getCardComKey(CardShowType.CARD_LIST), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 0)
      .addPtState(this.getCardComAnim(CardShowType.CARD_LIST)));
  }

  private addMainEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgMainName()) {
      return;
    }
    // 列表大卡
    endCfg.bindConfig(this.getCardComKey(CardShowType.CARD_LIST), WidgetPropertyConfig.wrap()
      .addPtState(this.getCardComAnim(CardShowType.CARD_LIST)));
    // 动效结束，清除列表大卡
    endCfg.getAnimParam()?.addStaticFinish(() => {
      this.getCardData()?.tryDelAnimCheckData(CardShowType.CARD_LIST);
    });
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndConCard(animCfg);
  }

  private initEndConCard(animCfg: ImmComAnimConfig): void {
    let listCard = this.getCheckCardData()?.get(CardShowType.CARD_LIST);
    this.getCardData()?.setCardData(CardShowType.CARD_LIST, listCard);
    // 列表大卡从列表位置过渡到大卡位置，跟随主动效
    let groupKey = listCard?.getGroupKey();
    let listStyle = this.getListComStyle(groupKey);
    let cardStyle = this.getCardComStyle(CardShowType.CARD_CONTENT);
    let listPos = CmpPosWrapper.wrapper(this.getListPos(groupKey));
    let cardPos = CmpPosWrapper.wrapper(this.getCardPos(CardShowType.CARD_CONTENT));
    let initCfg = animCfg.getInitCfg();
    let cardInitCfg = initCfg?.getConfig(this.getCardComKey(CardShowType.CARD_LIST));
    let tranX = listPos.getCmpCenterX() - cardPos.getCmpCenterX();
    let tranY = listPos.getCmpCenterY() - cardPos.getCmpCenterY();
    cardInitCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, cardStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.WIDTH, cardPos.getCmpWidth())
      .bindConfig(WBaseProperty.HEIGHT, cardPos.getCmpHeight())
      .bindConfig(WBaseProperty.CLIP_W, cardPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, cardPos.getCmpHeight());
    let endCfg = animCfg.getEndCfg(this.getCfgMainName());
    let cardEndCfg = endCfg?.getConfig(this.getCardComKey(CardShowType.CARD_LIST));
    // 固定间距取大值
    let staticW = Math.max(listPos.getCmpWidth(), cardPos.getCmpWidth());
    cardEndCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, listStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.WIDTH, staticW)
      .bindConfig(WBaseProperty.TRAN_X, tranX)
      .bindConfig(WBaseProperty.TRAN_Y, tranY)
      .bindConfig(WBaseProperty.CLIP_W, listPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, listPos.getCmpHeight());
  }
}
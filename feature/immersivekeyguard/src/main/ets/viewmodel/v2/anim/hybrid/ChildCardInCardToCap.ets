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
import { CapShowType } from '../../../../common/constants/ImmCapConst';
import { CardShowType } from '../../../../common/constants/ImmCardConst';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ChildHybridBaseAnim } from './ChildHybridBaseAnim';

/**
 * 大卡过渡胶囊动效中大卡子模块
 * 胶囊大卡从大卡区域过渡到胶囊区域
 */
export class ChildCardInCardToCap extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // 胶囊大卡初始化
    initCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, scene)
      .bindConfig(WBaseProperty.ALPHA, 1)
      .bindConfig(WBaseProperty.TRAN_X, 0)
      .bindConfig(WBaseProperty.TRAN_Y, 0)
      // 大卡过渡出去，不允许交互
      .bindConfig(WBaseProperty.ENABLE, false)
      .addPtState(this.getCardComAnim(CardShowType.CARD_CAP)))
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
    // 胶囊大卡finish
    finishCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardComAnim(CardShowType.CARD_CAP)))
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
    // 胶囊大卡
    endCfg.bindConfig(this.getCardComKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 0)
      .addPtState(this.getCardComAnim(CardShowType.CARD_CAP)));
  }

  private addMainEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgMainName()) {
      return;
    }
    // 胶囊大卡
    endCfg.bindConfig(this.getCardComKey(CardShowType.CARD_CAP), WidgetPropertyConfig.wrap()
      .addPtState(this.getCardComAnim(CardShowType.CARD_CAP)));
    // 动效结束，清除胶囊大卡
    endCfg.getAnimParam()?.addStaticFinish(() => {
      this.getCardData()?.tryDelAnimCheckData(CardShowType.CARD_CAP);
    });
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndCapCard(animCfg);
  }

  private initEndCapCard(animCfg: ImmComAnimConfig): void {
    let capCard = this.getCheckCardData()?.get(CardShowType.CARD_CAP);
    this.getCardData()?.setCardData(CardShowType.CARD_CAP, capCard);
    // 胶囊大卡从大卡位置过渡到胶囊位置，跟随主动效；胶囊区分内容胶囊和非内容胶囊
    let capType = this.getCheckCapData()?.get(CapShowType.CAP_CARD_BACK)?.getCapShowType();
    let isContentCap = capType === CapShowType.CAP_CONTENT;
    let capStyle = this.getCapComStyle(isContentCap ? CapShowType.CAP_CONTENT : CapShowType.CAP_SHADOW);
    let cardStyle = this.getCardComStyle(CardShowType.CARD_CONTENT);
    let capPos = CmpPosWrapper.wrapper(this.getCapPos(isContentCap ? CapShowType.CAP_CONTENT : CapShowType.CAP_SHADOW));
    let cardPos = CmpPosWrapper.wrapper(this.getCardPos(CardShowType.CARD_CONTENT));
    let initCfg = animCfg.getInitCfg();
    let cardInitCfg = initCfg?.getConfig(this.getCardComKey(CardShowType.CARD_CAP));
    cardInitCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, cardStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.WIDTH, cardPos.getCmpWidth())
      .bindConfig(WBaseProperty.HEIGHT, cardPos.getCmpHeight())
      .bindConfig(WBaseProperty.CLIP_W, cardPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, cardPos.getCmpHeight());
    let endCfg = animCfg.getEndCfg(this.getCfgMainName());
    let cardEndCfg = endCfg?.getConfig(this.getCardComKey(CardShowType.CARD_CAP));
    let tranX = capPos.getCmpCenterX() - cardPos.getCmpCenterX();
    let tranY = capPos.getCmpCenterY() - cardPos.getCmpCenterY();
    cardEndCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, capStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, capPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, capPos.getCmpHeight())
      .bindConfig(WBaseProperty.TRAN_X, tranX)
      .bindConfig(WBaseProperty.TRAN_Y, tranY);
  }
}
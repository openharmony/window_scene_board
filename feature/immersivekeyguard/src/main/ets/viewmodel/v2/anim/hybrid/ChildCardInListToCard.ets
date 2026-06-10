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
  WBaseProperty,
  WDefault
} from '@ohos/screenlockcommon';
import { CmpPosWrapper, WidgetPropertyConfig } from '@ohos/screenlockcommon/Index';
import { CardShowType } from '../../../../common/constants/ImmCardConst';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ChildHybridBaseAnim } from './ChildHybridBaseAnim';

/**
 * 列表过渡大卡动效中大卡子模块
 * 内容大卡从列表区域过渡到大卡区域
 */
export class ChildCardInListToCard extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // 内容大卡初始化
    initCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, scene)
      .bindConfig(WBaseProperty.ALPHA, 0)
      .addPtState(this.getCardComAnim(CardShowType.CARD_CONTENT)))
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
    // 内容大卡finish
    finishCfg?.bindConfig(this.getCardComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCardComAnim(CardShowType.CARD_CONTENT)))
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
    this.addClickScaleEndCfg(endCfg);
    this.addMainEndCfg(endCfg);
  }

  private addAlphaEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgAlphaName()) {
      return;
    }
    // 内容大卡
    endCfg.bindConfig(this.getCardComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 1)
      .addPtState(this.getCardComAnim(CardShowType.CARD_CONTENT)));
  }

  private addClickScaleEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgClickName()) {
      return;
    }
    // 内容大卡
    endCfg.bindConfig(this.getCardComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.SCALE_X, 1)
      .bindConfig(WBaseProperty.SCALE_Y, 1)
      .addPtState(this.getCardComAnim(CardShowType.CARD_CONTENT)));
  }

  private addMainEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgMainName()) {
      return;
    }
    // 内容大卡
    endCfg.bindConfig(this.getCardComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.TRAN_X, 0)
      .bindConfig(WBaseProperty.TRAN_Y, 0)
      .addPtState(this.getCardComAnim(CardShowType.CARD_CONTENT)));
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndConCard(animCfg);
  }

  private initEndConCard(animCfg: ImmComAnimConfig): void {
    // 内容大卡从列表位置过渡到大卡位置，跟随主动效
    let conCardData = this.getCardData()?.getCardData(CardShowType.CARD_CONTENT);
    let groupKey = conCardData?.getGroupKey();
    let listItemVm = this.getListItemVm(conCardData?.getOriData());
    let listStyle = this.getListComStyle(groupKey);
    let cardStyle = this.getCardComStyle(CardShowType.CARD_CONTENT);
    let listPos = CmpPosWrapper.wrapper(this.getListPos(groupKey));
    let cardPos = CmpPosWrapper.wrapper(this.getCardPos(CardShowType.CARD_CONTENT));
    let initCfg = animCfg.getInitCfg();
    let cardInitCfg = initCfg?.getConfig(this.getCardComKey(CardShowType.CARD_CONTENT));
    let tranX = listPos.getCmpCenterX() - cardPos.getCmpCenterX();
    let tranY = listPos.getCmpCenterY() - cardPos.getCmpCenterY();
    let clickScale = listItemVm?.itemClickScale ?? WDefault.MAX_VALUE;
    // 卡片宽度与列表宽度不一致时，宽度过渡
    let cardW = cardPos.getCmpWidth();
    let staticW = Math.max(listPos.getCmpWidth(), cardW);
    cardInitCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, listStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.WIDTH, staticW)
      .bindConfig(WBaseProperty.HEIGHT, cardPos.getCmpHeight())
      .bindConfig(WBaseProperty.CLIP_W, listPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, listPos.getCmpHeight())
      .bindConfig(WBaseProperty.SCALE_X, clickScale)
      .bindConfig(WBaseProperty.SCALE_Y, clickScale)
      .bindConfig(WBaseProperty.TRAN_X, tranX)
      .bindConfig(WBaseProperty.TRAN_Y, tranY);
    let endCfg = animCfg.getEndCfg(this.getCfgMainName());
    let cardEndCfg = endCfg?.getConfig(this.getCardComKey(CardShowType.CARD_CONTENT));
    cardEndCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, cardStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.WIDTH, cardW)
      .bindConfig(WBaseProperty.CLIP_W, cardPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, cardPos.getCmpHeight());
  }
}
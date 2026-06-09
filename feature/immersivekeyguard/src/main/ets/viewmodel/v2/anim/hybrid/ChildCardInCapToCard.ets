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
import { CapShowType } from '../../../../common/constants/ImmCapConst';
import { CardShowType } from '../../../../common/constants/ImmCardConst';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ChildHybridBaseAnim } from './ChildHybridBaseAnim';

/**
 * 胶囊过渡大卡动效中大卡子模块
 * 内容大卡从胶囊区域过渡到大卡区域
 */
export class ChildCardInCapToCard extends ChildHybridBaseAnim {
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
    // 内容大卡从胶囊位置过渡到大卡位置，跟随主动效
    let conCapStyle = this.getCapComStyle(CapShowType.CAP_CONTENT);
    let conCardStyle = this.getCardComStyle(CardShowType.CARD_CONTENT);
    let conCapPos = CmpPosWrapper.wrapper(this.getCapPos(CapShowType.CAP_CONTENT));
    let conCardPos = CmpPosWrapper.wrapper(this.getCardPos(CardShowType.CARD_CONTENT));
    let initCfg = animCfg.getInitCfg();
    let conInitCfg = initCfg?.getConfig(this.getCardComKey(CardShowType.CARD_CONTENT));
    let tranX = conCapPos.getCmpCenterX() - conCardPos.getCmpCenterX();
    let tranY = conCapPos.getCmpCenterY() - conCardPos.getCmpCenterY();
    conInitCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, conCapStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.WIDTH, conCardPos.getCmpWidth())
      .bindConfig(WBaseProperty.HEIGHT, conCardPos.getCmpHeight())
      .bindConfig(WBaseProperty.CLIP_W, conCapPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, conCapPos.getCmpHeight())
      .bindConfig(WBaseProperty.TRAN_X, tranX)
      .bindConfig(WBaseProperty.TRAN_Y, tranY);
    let endCfg = animCfg.getEndCfg(this.getCfgMainName());
    let conEndCfg = endCfg?.getConfig(this.getCardComKey(CardShowType.CARD_CONTENT));
    conEndCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, conCardStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, conCardPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, conCardPos.getCmpHeight());
  }
}
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
 * 大卡过渡胶囊动效中胶囊子模块
 * 大卡胶囊从大卡区域过渡到胶囊区域，区分是否为内容胶囊、阴影胶囊；
 * 大卡胶囊为内容胶囊，则内容胶囊替代过渡动效；
 * 大卡胶囊为阴影胶囊，则阴影胶囊替代过渡动效；
 * 大卡胶囊独立，则大卡胶囊过渡到胶囊底部，按阴影胶囊位置算。
 */
export class ChildCapInCardToCap extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // root胶囊初始化
    initCfg?.bindConfig(this.getCapRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapRootAnim()))
      // 内容胶囊初始化
      .bindConfig(this.getCapComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊初始化
      .bindConfig(this.getCapComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapComAnim(CapShowType.CAP_SHADOW)))
      // 大卡胶囊初始化
      .bindConfig(this.getCapComKey(CapShowType.CAP_CARD_BACK), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapComAnim(CapShowType.CAP_CARD_BACK)));
  }

  public buildFinishCfg(finishCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildFinishCfg(finishCfg, scene);
    // 内容胶囊finish
    finishCfg?.bindConfig(this.getCapComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊finish
      .bindConfig(this.getCapComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapComAnim(CapShowType.CAP_SHADOW)))
      // 大卡胶囊finish
      .bindConfig(this.getCapComKey(CapShowType.CAP_CARD_BACK), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapComAnim(CapShowType.CAP_CARD_BACK)))
      // root胶囊finish
      .bindConfig(this.getCapRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapRootAnim()));
  }

  public buildEndCfg(endCfg: ImmComPtConfig): void {
    this.addMainEndCfg(endCfg);
  }

  private addMainEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgMainName()) {
      return;
    }
    // 主动效结束时，清除大卡胶囊数据
    endCfg.getAnimParam()?.addStaticFinish(() => {
      this.getCapData()?.remove(CapShowType.CAP_CARD_BACK);
    });
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndCardCap(animCfg);
    this.initEndContentCap(animCfg);
    this.initEndShadowCap(animCfg);
  }

  private initEndCardCap(animCfg: ImmComAnimConfig): void {
    // 大卡胶囊既不是内容胶囊，又不是阴影胶囊，则独立过渡
    let cardCap = this.getCheckCapData()?.get(CapShowType.CAP_CARD_BACK);
    let capType = cardCap?.getCapShowType();
    if (capType === CapShowType.CAP_SHADOW || capType === CapShowType.CAP_CONTENT) {
      return;
    }
    this.getCapData()?.setCapData(CapShowType.CAP_CARD_BACK, cardCap);
    let shadowCapStyle = this.getCapComStyle(CapShowType.CAP_SHADOW);
    let conCardStyle = this.getCardComStyle(CardShowType.CARD_CONTENT);
    let shadowCapPos = CmpPosWrapper.wrapper(this.getCapPos(CapShowType.CAP_SHADOW));
    let conCardPos = CmpPosWrapper.wrapper(this.getCardPos(CardShowType.CARD_CONTENT));
    let initCfg = animCfg.getInitCfg();
    let tranX = conCardPos.getCmpCenterX() - shadowCapPos.getCmpCenterX();
    let tranY = conCardPos.getCmpGlobalY() - shadowCapPos.getCmpGlobalY();
    let cardInitCfg = initCfg?.getConfig(this.getCapComKey(CapShowType.CAP_CARD_BACK));
    cardInitCfg?.bindConfig(WBaseProperty.MARGIN_T, shadowCapStyle?.getMarginT())
      .bindConfig(WBaseProperty.MARGIN_L, shadowCapStyle?.getMarginL())
      .bindConfig(WBaseProperty.MARGIN_R, shadowCapStyle?.getMarginR())
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, shadowCapStyle?.getBgBrightnessInner())
      .bindConfig(WBaseProperty.BORDER_RADIUS, conCardStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, conCardPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, conCardPos.getCmpHeight())
      .bindConfig(WBaseProperty.CLIP_ENABLE, true)
      .bindConfig(WBaseProperty.TRAN_X, tranX)
      .bindConfig(WBaseProperty.TRAN_Y, tranY)
      .bindConfig(WBaseProperty.ALPHA, 0);
    let endAlphaCfg = animCfg.getEndCfg(this.getCfgAlphaName());
    endAlphaCfg?.bindConfig(this.getCapComKey(CapShowType.CAP_CARD_BACK), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 1)
      .addPtState(this.getCapComAnim(CapShowType.CAP_CARD_BACK)));
    let endMainCfg = animCfg.getEndCfg(this.getCfgMainName());
    endMainCfg?.bindConfig(this.getCapComKey(CapShowType.CAP_CARD_BACK), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.BORDER_RADIUS, shadowCapStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, shadowCapPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, shadowCapPos.getCmpHeight())
      .bindConfig(WBaseProperty.TRAN_X, 0)
      .bindConfig(WBaseProperty.TRAN_Y, 0)
      .addPtState(this.getCapComAnim(CapShowType.CAP_CARD_BACK)));
  }

  private initEndContentCap(animCfg: ImmComAnimConfig): void {
    // 大卡胶囊是内容胶囊，则直接使用内容胶囊过渡
    let cardCap = this.getCheckCapData()?.get(CapShowType.CAP_CARD_BACK);
    let capType = cardCap?.getCapShowType();
    if (capType !== CapShowType.CAP_CONTENT) {
      return;
    }
    let conCapStyle = this.getCapComStyle(CapShowType.CAP_CONTENT);
    let conCardStyle = this.getCardComStyle(CardShowType.CARD_CONTENT);
    let contCapPos = CmpPosWrapper.wrapper(this.getCapPos(CapShowType.CAP_CONTENT));
    let conCardPos = CmpPosWrapper.wrapper(this.getCardPos(CardShowType.CARD_CONTENT));
    let initCfg = animCfg.getInitCfg();
    let tranX = conCardPos.getCmpCenterX() - contCapPos.getCmpCenterX();
    let tranY = conCardPos.getCmpGlobalY() - contCapPos.getCmpGlobalY();
    let conInitCfg = initCfg?.getConfig(this.getCapComKey(CapShowType.CAP_CONTENT));
    conInitCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, conCardStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, conCardPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, conCardPos.getCmpHeight())
      .bindConfig(WBaseProperty.CLIP_ENABLE, true)
      .bindConfig(WBaseProperty.TRAN_X, tranX)
      .bindConfig(WBaseProperty.TRAN_Y, tranY)
      .bindConfig(WBaseProperty.ALPHA, 0);
    let endAlphaCfg = animCfg.getEndCfg(this.getCfgAlphaName());
    endAlphaCfg?.bindConfig(this.getCapComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 1)
      .addPtState(this.getCapComAnim(CapShowType.CAP_CONTENT)));
    let endMainCfg = animCfg.getEndCfg(this.getCfgMainName());
    endMainCfg?.bindConfig(this.getCapComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.BORDER_RADIUS, conCapStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, contCapPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, contCapPos.getCmpHeight())
      .bindConfig(WBaseProperty.TRAN_X, 0)
      .bindConfig(WBaseProperty.TRAN_Y, 0)
      .addPtState(this.getCapComAnim(CapShowType.CAP_CONTENT)));
  }

  private initEndShadowCap(animCfg: ImmComAnimConfig): void {
    // 大卡胶囊是阴影胶囊，则直接使用阴影胶囊过渡
    let cardCap = this.getCheckCapData()?.get(CapShowType.CAP_CARD_BACK);
    let capType = cardCap?.getCapShowType();
    if (capType !== CapShowType.CAP_SHADOW) {
      return;
    }
    let shadowCapStyle = this.getCapComStyle(CapShowType.CAP_SHADOW);
    let conCardStyle = this.getCardComStyle(CardShowType.CARD_CONTENT);
    let shadowCapPos = CmpPosWrapper.wrapper(this.getCapPos(CapShowType.CAP_SHADOW));
    let conCardPos = CmpPosWrapper.wrapper(this.getCardPos(CardShowType.CARD_CONTENT));
    let initCfg = animCfg.getInitCfg();
    let tranX = conCardPos.getCmpCenterX() - shadowCapPos.getCmpCenterX();
    let tranY = conCardPos.getCmpGlobalY() - shadowCapPos.getCmpGlobalY();
    let shadowInitCfg = initCfg?.getConfig(this.getCapComKey(CapShowType.CAP_SHADOW));
    shadowInitCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, conCardStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, conCardPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, conCardPos.getCmpHeight())
      .bindConfig(WBaseProperty.CLIP_ENABLE, true)
      .bindConfig(WBaseProperty.TRAN_X, tranX)
      .bindConfig(WBaseProperty.TRAN_Y, tranY)
      .bindConfig(WBaseProperty.ALPHA, 0);
    let endAlphaCfg = animCfg.getEndCfg(this.getCfgAlphaName());
    endAlphaCfg?.bindConfig(this.getCapComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 1)
      .addPtState(this.getCapComAnim(CapShowType.CAP_SHADOW)));
    let endMainCfg = animCfg.getEndCfg(this.getCfgMainName());
    endMainCfg?.bindConfig(this.getCapComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.BORDER_RADIUS, shadowCapStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, shadowCapPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, shadowCapPos.getCmpHeight())
      .bindConfig(WBaseProperty.TRAN_X, 0)
      .bindConfig(WBaseProperty.TRAN_Y, 0)
      .addPtState(this.getCapComAnim(CapShowType.CAP_SHADOW)));
  }
}
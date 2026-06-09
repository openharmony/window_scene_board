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
 * 胶囊过渡大卡动效中胶囊子模块
 * 顶部大卡胶囊过渡到大卡UI区域；
 * 内容胶囊从阴影胶囊样式过渡到内容胶囊样式；
 * 阴影胶囊透明度渐显。
 */
export class ChildCapInCapToCard extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // 内容胶囊初始化
    initCfg?.bindConfig(this.getCapComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊初始化
      .bindConfig(this.getCapComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .bindConfig(WBaseProperty.ALPHA, 0)
        .addPtState(this.getCapComAnim(CapShowType.CAP_SHADOW)))
      // 大卡胶囊初始化
      .bindConfig(this.getCapComKey(CapShowType.CAP_CARD), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .bindConfig(WBaseProperty.ALPHA, 1)
        .bindConfig(WBaseProperty.TRAN_X, 0)
        .bindConfig(WBaseProperty.TRAN_Y, 0)
        .bindConfig(WBaseProperty.CLIP_ENABLE, true)
        // 胶囊过渡出去，不允许交互
        .bindConfig(WBaseProperty.ENABLE, false)
        .addPtState(this.getCapComAnim(CapShowType.CAP_CARD)))
      // root胶囊初始化
      .bindConfig(this.getCapRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapRootAnim()));
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
      .bindConfig(this.getCapComKey(CapShowType.CAP_CARD), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapComAnim(CapShowType.CAP_CARD)))
      // root胶囊finish
      .bindConfig(this.getCapRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapRootAnim()));
  }

  public buildEndCfg(endCfg: ImmComPtConfig): void {
    this.addAlphaEndCfg(endCfg);
    this.addMainEndCfg(endCfg);
  }

  private addAlphaEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgAlphaName()) {
      return;
    }
    // 内容胶囊
    endCfg.bindConfig(this.getCapComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
      .addPtState(this.getCapComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊，透明度渐显
      .bindConfig(this.getCapComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 1)
        .addPtState(this.getCapComAnim(CapShowType.CAP_SHADOW)))
      // 大卡胶囊，透明度渐隐
      .bindConfig(this.getCapComKey(CapShowType.CAP_CARD), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 0)
        .addPtState(this.getCapComAnim(CapShowType.CAP_CARD)));
  }

  private addMainEndCfg(endCfg: ImmComPtConfig): void {
    if (endCfg.getCfgName() !== this.getCfgMainName()) {
      return;
    }
    // 大卡胶囊
    endCfg.bindConfig(this.getCapComKey(CapShowType.CAP_CARD), WidgetPropertyConfig.wrap()
        .addPtState(this.getCapComAnim(CapShowType.CAP_CARD)));
    // 主动效结束时，清除大卡胶囊数据
    endCfg.getAnimParam()?.addStaticFinish(() => {
      this.getCapData()?.remove(CapShowType.CAP_CARD);
    });
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndCardCap(animCfg);
    this.initEndContentCap(animCfg);
  }

  private initEndCardCap(animCfg: ImmComAnimConfig): void {
    // 大卡胶囊从胶囊位置过渡到大卡位置，跟随主动效
    let cardCap = this.getCheckCapData()?.get(CapShowType.CAP_CARD);
    this.getCapData()?.setCapData(CapShowType.CAP_CARD, cardCap);
    let conCapStyle = this.getCapComStyle(CapShowType.CAP_CONTENT);
    let conCardStyle = this.getCardComStyle(CardShowType.CARD_CONTENT);
    let conCapPos = CmpPosWrapper.wrapper(this.getCapPos(CapShowType.CAP_CONTENT));
    let conCardPos = CmpPosWrapper.wrapper(this.getCardPos(CardShowType.CARD_CONTENT));
    let initCfg = animCfg.getInitCfg();
    let cardInitCfg = initCfg?.getConfig(this.getCapComKey(CapShowType.CAP_CARD));
    cardInitCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, conCapStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, conCapPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, conCapPos.getCmpHeight());
    let endCfg = animCfg.getEndCfg(this.getCfgMainName());
    let cardEndCfg = endCfg?.getConfig(this.getCapComKey(CapShowType.CAP_CARD));
    let tranX = conCardPos.getCmpCenterX() - conCapPos.getCmpCenterX();
    let tranY = conCardPos.getCmpGlobalY() - conCapPos.getCmpGlobalY();
    cardEndCfg?.bindConfig(WBaseProperty.BORDER_RADIUS, conCardStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, conCardPos.getCmpWidth())
      .bindConfig(WBaseProperty.CLIP_H, conCardPos.getCmpHeight())
      .bindConfig(WBaseProperty.TRAN_X, tranX)
      .bindConfig(WBaseProperty.TRAN_Y, tranY);
  }

  private initEndContentCap(animCfg: ImmComAnimConfig): void {
    // 内容胶囊从阴影样式过渡到内容样式，跟随透明度动效
    let shadowStyle = this.getCapComStyle(CapShowType.CAP_SHADOW);
    let contentStyle = this.getCapComStyle(CapShowType.CAP_CONTENT);
    let initCfg = animCfg.getInitCfg();
    let conInitCfg = initCfg?.getConfig(this.getCapComKey(CapShowType.CAP_CONTENT));
    conInitCfg?.bindConfig(WBaseProperty.MARGIN_T, shadowStyle?.getMarginT())
      .bindConfig(WBaseProperty.MARGIN_L, shadowStyle?.getMarginL())
      .bindConfig(WBaseProperty.MARGIN_R, shadowStyle?.getMarginR())
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, shadowStyle?.getBgBrightnessInner());
    let endCfg = animCfg.getEndCfg(this.getCfgAlphaName());
    let conEndCfg = endCfg?.getConfig(this.getCapComKey(CapShowType.CAP_CONTENT));
    conEndCfg?.bindConfig(WBaseProperty.MARGIN_T, contentStyle?.getMarginT())
      .bindConfig(WBaseProperty.MARGIN_L, contentStyle?.getMarginL())
      .bindConfig(WBaseProperty.MARGIN_R, contentStyle?.getMarginR())
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, contentStyle?.getBgBrightnessInner());
  }
}
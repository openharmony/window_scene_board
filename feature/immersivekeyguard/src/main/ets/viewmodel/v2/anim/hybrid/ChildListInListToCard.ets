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
 * 列表过渡大卡动效中列表子模块
 * 列表条目过渡到大卡UI区域
 */
export class ChildListInListToCard extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // root列表初始化
    initCfg?.bindConfig(this.getListRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getListRootAnim()))
      // V1 root列表初始化
      .bindConfig(this.getListV1RootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .bindConfig(WBaseProperty.Z_INDEX, this.getListRaiseZIndex())
        .addPtState(this.getListV1RootAnim()));
  }

  public buildFinishCfg(finishCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildFinishCfg(finishCfg, scene);
    // root列表finish
    finishCfg?.bindConfig(this.getListRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getListRootAnim()))
      // V1 root列表finish
      .bindConfig(this.getListV1RootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getListV1RootAnim()));
  }

  public buildEndCfg(endCfg: ImmComPtConfig): void {
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndListItem(animCfg);
  }

  private initEndListItem(animCfg: ImmComAnimConfig): void {
    // 列表条目从条目位置过渡到大卡位置，跟随主动效
    let cardData = this.getCardData()?.getCardData(CardShowType.CARD_CONTENT);
    let groupKey = cardData?.getGroupKey();
    let listStyle = this.getListComStyle(groupKey);
    let cardStyle = this.getCardComStyle(CardShowType.CARD_CONTENT);
    let listPos = CmpPosWrapper.wrapper(this.getListPos(groupKey));
    let cardPos = CmpPosWrapper.wrapper(this.getCardPos(CardShowType.CARD_CONTENT));
    let listComAnim = this.getListComAnim(groupKey);
    let listShadowAnim = this.getListShadowAnim(groupKey);
    // 初始化配置
    let initCfg = animCfg.getInitCfg();
    let listW = listPos?.getCmpWidth();
    let listH = listPos?.getCmpHeight();
    let cardW = cardPos.getCmpWidth();
    let cardH = cardPos.getCmpHeight();
    initCfg?.bindConfig(this.getListComKey(groupKey), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene)
      .bindConfig(WBaseProperty.Z_INDEX, this.getListItemRaiseZIndex())
      .bindConfig(WBaseProperty.WIDTH, listW).bindConfig(WBaseProperty.HEIGHT, listH)
      .bindConfig(WBaseProperty.TRAN_X, 0).bindConfig(WBaseProperty.TRAN_Y, 0)
      .bindConfig(WBaseProperty.BORDER_RADIUS, listStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, listW).bindConfig(WBaseProperty.CLIP_H, listH)
      .bindConfig(WBaseProperty.CLIP_ENABLE, true).bindConfig(WBaseProperty.ALPHA, 1)
      .addPtState(listComAnim))
      // 条目阴影由默认大小过渡到大卡大小
      .bindConfig(this.getListShadowKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene)
        .bindConfig(WBaseProperty.CLIP_W, undefined).bindConfig(WBaseProperty.CLIP_H, undefined)
        .bindConfig(WBaseProperty.CLIP_OFFSET_Y, undefined).bindConfig(WBaseProperty.ALIGN_CONTENT, undefined)
        .addPtState(listShadowAnim))
      // 标识背景动效中
      .bindConfig(this.getListBgKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene)
        .addPtState(this.getListBgAnim(groupKey)));
    // 动效结束配置
    let finishCfg = animCfg.getFinishCfg();
    finishCfg?.bindConfig(this.getListComKey(groupKey), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene).addPtState(listComAnim))
      .bindConfig(this.getListShadowKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene).addPtState(listShadowAnim))
      // 标识背景动效结束
      .bindConfig(this.getListBgKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene)
        .addPtState(this.getListBgAnim(groupKey)));
    // alpha动效终值配置
    let endAlphaCfg = animCfg.getEndCfg(this.getCfgAlphaName());
    endAlphaCfg?.bindConfig(this.getListComKey(groupKey), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 0).addPtState(listComAnim));
    let tranX = cardPos.getCmpCenterX() - listPos.getCmpCenterX();
    let tranY = cardPos.getCmpGlobalY() - listPos.getCmpGlobalY();
    // 主动效终值配置
    let endMainCfg = animCfg.getEndCfg(this.getCfgMainName());
    // 超出ListItem宽度时，左侧被限制，补位移
    tranX = cardW > listW ? tranX - (cardW - listW) / 2 : tranX;
    endMainCfg?.bindConfig(this.getListComKey(groupKey), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.BORDER_RADIUS, cardStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, cardW).bindConfig(WBaseProperty.CLIP_H, cardH)
      .bindConfig(WBaseProperty.TRAN_X, tranX).bindConfig(WBaseProperty.TRAN_Y, tranY)
      .addPtState(listComAnim))
      // 条目阴影由默认大小过渡到大卡大小
      .bindConfig(this.getListShadowKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.CLIP_W, cardW).bindConfig(WBaseProperty.CLIP_H, cardH)
        .bindConfig(WBaseProperty.CLIP_OFFSET_Y, 0).bindConfig(WBaseProperty.ALIGN_CONTENT, Alignment.Top)
        .addPtState(listShadowAnim));
  }
}
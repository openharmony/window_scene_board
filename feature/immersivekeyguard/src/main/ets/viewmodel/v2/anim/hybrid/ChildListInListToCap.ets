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
  WBaseProperty,
  WDefault
} from '@ohos/screenlockcommon';
import { CmpPosWrapper, WidgetPropertyConfig } from '@ohos/screenlockcommon/Index';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ChildHybridBaseAnim } from './ChildHybridBaseAnim';
import { CapShowType } from '../../../../common/constants/ImmCapConst';

// 条目配置参数
interface ItemParam {
  groupKey: string;
  capType: CapShowType;
  initCfg?: ImmComPtConfig;
  finishCfg?: ImmComPtConfig;
  endAlphaCfg?: ImmComPtConfig;
  endMainCfg?: ImmComPtConfig;
}

/**
 * 列表过渡胶囊动效中列表子模块
 * 列表条目从条目区域过渡到胶囊区域，多个条目同步过渡
 */
export class ChildListInListToCap extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // root列表初始化
    initCfg?.bindConfig(this.getListRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getListRootAnim()));
  }

  public buildFinishCfg(finishCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildFinishCfg(finishCfg, scene);
    // root列表finish
    finishCfg?.bindConfig(this.getListRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getListRootAnim()));
  }

  public buildEndCfg(endCfg: ImmComPtConfig): void {
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndListAll(animCfg);
  }

  private initEndListAll(animCfg: ImmComAnimConfig): void {
    // 列表条目从条目位置过渡到胶囊位置，第一个条目匹配内容胶囊位置，其他条目均匹配阴影胶囊位置
    let startIndex = this.getListStaticSt()?.getStartIndex() ?? 0;
    let endIndex = this.getListStaticSt()?.getEndIndex() ?? 0;
    let capChain = this.getCapAnimVm()?.getDefaultCapChain();
    let listData = this.getListData();
    let initCfg = animCfg.getInitCfg();
    let finishCfg = animCfg.getFinishCfg();
    let endAlphaCfg = animCfg.getEndCfg(this.getCfgAlphaName());
    let endMainCfg = animCfg.getEndCfg(this.getCfgMainName());
    for (let i = startIndex; i <= endIndex; i++) {
      let groupKey = listData?.[i]?.groupKey;
      if (groupKey === undefined || groupKey === this.extendAnimParam?.skipGroupKey) {
        continue;
      }
      capChain = this.getCapAnimVm()?.getValidCapChain(capChain);
      let capType = capChain?.getCapType() ?? CapShowType.CAP_SHADOW;
      capChain = capChain?.getNext();
      this.initEndListItem({ groupKey: groupKey, capType: capType, initCfg: initCfg,
        finishCfg: finishCfg, endAlphaCfg: endAlphaCfg, endMainCfg: endMainCfg});
    }
  }

  private initEndListItem(param: ItemParam): void {
    let groupKey = param.groupKey;
    let capType = param.capType;
    let listStyle = this.getListComStyle(groupKey);
    let listPos = CmpPosWrapper.wrapper(this.getListPos(groupKey));
    let capStyle = this.getCapComStyle(capType);
    let capPos = CmpPosWrapper.wrapper(this.getCapPos(capType));
    let listComAnim = this.getListComAnim(groupKey);
    let listShadowAnim = this.getListShadowAnim(groupKey);
    let listInnerAnim = this.getListInnerAnim(groupKey);
    let listW = listPos.getCmpWidth();
    let listH = listPos.getCmpHeight();
    let capW = capPos.getCmpWidth();
    let capH = capPos.getCmpHeight();
    // 条目内容缩放到胶囊大小，按宽度缩放
    let listScale = listW > 0 ? capW / listW : WDefault.MAX_VALUE;
    // 条目位移，条目布局顶部对齐，竖向位移按顶点计算
    let listTranX = capPos.getCmpCenterX() - listPos.getCmpCenterX();
    let listTranY = capPos.getCmpGlobalY() - listPos.getCmpGlobalY();
    // 动效初始配置
    param.initCfg?.bindConfig(this.getListComKey(groupKey), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene)
      .bindConfig(WBaseProperty.WIDTH, listW).bindConfig(WBaseProperty.HEIGHT, listH)
      .bindConfig(WBaseProperty.CLIP_W, listW).bindConfig(WBaseProperty.CLIP_H, listH)
      .bindConfig(WBaseProperty.BORDER_RADIUS, listStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_ENABLE, true).addPtState(listComAnim))
      // 条目阴影由默认大小过渡到胶囊大小
      .bindConfig(this.getListShadowKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene)
        .bindConfig(WBaseProperty.CLIP_W, undefined).bindConfig(WBaseProperty.CLIP_H, undefined)
        .bindConfig(WBaseProperty.CLIP_OFFSET_Y, undefined).bindConfig(WBaseProperty.ALIGN_CONTENT, undefined)
        .addPtState(listShadowAnim))
      // 缩放由inner承担
      .bindConfig(this.getListInnerKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene)
        .bindConfig(WBaseProperty.SCALE_X, 1).bindConfig(WBaseProperty.SCALE_Y, 1)
        .addPtState(listInnerAnim));
    // 动效结束配置
    param.finishCfg?.bindConfig(this.getListComKey(groupKey), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene).addPtState(listComAnim))
      .bindConfig(this.getListShadowKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene).addPtState(listShadowAnim))
      .bindConfig(this.getListInnerKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene).addPtState(listInnerAnim));
    // Alpha动效
    param.endAlphaCfg?.bindConfig(this.getListComKey(groupKey), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 0).addPtState(listComAnim));
    // 主动效终值配置
    param.endMainCfg?.bindConfig(this.getListComKey(groupKey), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.BORDER_RADIUS, capStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, capW).bindConfig(WBaseProperty.CLIP_H, capH)
      // 存在跟手缩放时，动效直接复位
      .bindConfig(WBaseProperty.SCALE_X, 1).bindConfig(WBaseProperty.SCALE_Y, 1)
      .bindConfig(WBaseProperty.TRAN_X, listTranX).bindConfig(WBaseProperty.TRAN_Y, listTranY)
      .addPtState(listComAnim))
      // 条目阴影由默认大小过渡到胶囊大小
      .bindConfig(this.getListShadowKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.CLIP_W, capW).bindConfig(WBaseProperty.CLIP_H, capH)
        .bindConfig(WBaseProperty.CLIP_OFFSET_Y, 0).bindConfig(WBaseProperty.ALIGN_CONTENT, Alignment.Top)
        .addPtState(listShadowAnim))
      // 缩放由inner承担
      .bindConfig(this.getListInnerKey(groupKey), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, listScale)
        .bindConfig(WBaseProperty.SCALE_Y, listScale)
        .addPtState(listInnerAnim));
  }
}
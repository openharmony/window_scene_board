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
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ImmComAnimConfig } from '../../../../model/data/config/ImmComAnimConfig';
import { ChildHybridBaseAnim } from './ChildHybridBaseAnim';
import { CapShowType } from '../../../../common/constants/ImmCapConst';

// 条目配置参数
interface ItemParam {
  animCfg: ImmComAnimConfig;
  groupKey: string;
  capType: CapShowType;
  index: number;
}

/**
 * 胶囊过渡列表动效中胶囊子模块
 * 胶囊从胶囊区域过渡到列表区域，多胶囊分开过渡
 */
export class ChildCapInCapToList extends ChildHybridBaseAnim {
  public buildInitCfg(initCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildInitCfg(initCfg, scene);
    // root胶囊初始化
    initCfg?.bindConfig(this.getCapRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapRootAnim()));
  }

  public buildFinishCfg(finishCfg: ImmComPtConfig, scene: WAnimScene): void {
    super.buildFinishCfg(finishCfg, scene);
    // root胶囊finish
    finishCfg?.bindConfig(this.getCapRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, scene)
        .addPtState(this.getCapRootAnim()));
  }

  public buildEndCfg(endCfg: ImmComPtConfig): void {
  }

  public onHybridAnim(animCfg: ImmComAnimConfig): void {
    this.initEndCapAll(animCfg);
  }

  private initEndCapAll(animCfg: ImmComAnimConfig): void {
    // 胶囊从胶囊位置过渡到列表位置，多个胶囊按序过渡
    let startIndex = this.getListStaticSt()?.getStartIndex() ?? 0;
    let endIndex = this.getListStaticSt()?.getEndIndex() ?? 0;
    let capChain = this.getCapAnimVm()?.getDefaultCapChain();
    let listData = this.getListData();
    let hasValidAnim: boolean = false;
    for (let i = startIndex; i <= endIndex; i++) {
      let groupKey = listData?.[i]?.groupKey;
      if (groupKey === undefined) {
        continue;
      }
      let isSkip = groupKey === this.extendAnimParam?.skipGroupKey;
      capChain = this.getCapAnimVm()?.getValidCapChain(capChain);
      let capType = capChain?.getCapType();
      if (capType) {
        hasValidAnim = true;
        if (isSkip) {
          this.initEndSkipCapItem(animCfg, groupKey);
        } else {
          this.initEndCapItem({ animCfg: animCfg, groupKey: groupKey, capType: capType, index: i });
        }
      }
      capChain = capChain?.getNext();
      // 胶囊类型消耗完毕
      if (capChain === undefined) {
        break;
      }
    }
    // 根组件根据是否有有效动效来决定是否加入动效
    let rootCfg = animCfg?.getInitCfg()?.getConfig(this.getCapRootKey());
    rootCfg?.bindConfig(WAnimProperty.ANIM_SCENE, hasValidAnim ? this.animStartScene : this.animFinishScene);
  }

  private initEndSkipCapItem(animCfg: ImmComAnimConfig, groupKey: string): void {
    // 跳过动效的胶囊条目保持不可见即可
    let capType = this.getCapData()?.findCapData(groupKey)?.getCapShowType();
    if (!capType) {
      return;
    }
    let capComAnim = this.getCapComAnim(capType);
    let initCfg = animCfg.getInitCfg();
    initCfg?.bindConfig(this.getCapComKey(capType), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene)
      // 胶囊不可见不允许点击
      .bindConfig(WBaseProperty.ENABLE, false)
      .bindConfig(WBaseProperty.ALPHA, 0).addPtState(capComAnim));
    let finishCfg = animCfg.getFinishCfg();
    finishCfg?.bindConfig(this.getCapComKey(capType), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene).addPtState(capComAnim));
  }

  private initEndCapItem(param: ItemParam): void {
    let animCfg = param.animCfg;
    let groupKey = param.groupKey;
    let oriCapType = param.capType;
    let index = param.index;
    let replaceCapType = this.getReplaceCapType(oriCapType);
    let listStyle = this.getListComStyle(groupKey);
    let listPos = CmpPosWrapper.wrapper(this.getListPos(groupKey));
    let capStyle = this.getCapComStyle(replaceCapType);
    let capPos = CmpPosWrapper.wrapper(this.getCapPos(replaceCapType));
    let capComAnim = this.getCapComAnim(oriCapType);
    let listW = listPos.getCmpWidth();
    let listH = listPos.getCmpHeight();
    let capW = capPos.getCmpWidth();
    let capH = capPos.getCmpHeight();
    // 胶囊位移
    let capTranX = listPos.getCmpCenterX() - capPos.getCmpCenterX();
    let capTranY = listPos.getCmpGlobalY() - capPos.getCmpGlobalY();
    // 动效初始配置
    let initCfg = animCfg.getInitCfg();
    initCfg?.bindConfig(this.getCapComKey(oriCapType), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene)
      // 胶囊不可见不允许点击
      .bindConfig(WBaseProperty.ENABLE, false)
      .bindConfig(WBaseProperty.MARGIN_T, capStyle?.getMarginT() ?? 0)
      .bindConfig(WBaseProperty.MARGIN_L, capStyle?.getMarginL() ?? 0)
      .bindConfig(WBaseProperty.MARGIN_R, capStyle?.getMarginR() ?? 0)
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, capStyle?.getBgBrightnessInner())
      .bindConfig(WBaseProperty.CLIP_W, capW).bindConfig(WBaseProperty.CLIP_H, capH)
      .bindConfig(WBaseProperty.BORDER_RADIUS, capStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_ENABLE, true).addPtState(capComAnim));
    // 动效结束配置
    let finishCfg = animCfg.getFinishCfg();
    finishCfg?.bindConfig(this.getCapComKey(oriCapType), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene).addPtState(capComAnim));
    // Alpha动效
    let endAlphaCfg = animCfg.getEndCfg(this.getCfgAlphaName(index));
    endAlphaCfg?.bindConfig(this.getCapComKey(oriCapType), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 0).addPtState(capComAnim));
    // 主动效终值配置
    let endMainCfg = animCfg.getEndCfg(this.getCfgMainName(index));
    endMainCfg?.bindConfig(this.getCapComKey(oriCapType), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.BORDER_RADIUS, listStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, listW).bindConfig(WBaseProperty.CLIP_H, listH)
      .bindConfig(WBaseProperty.TRAN_X, capTranX).bindConfig(WBaseProperty.TRAN_Y, capTranY)
      .addPtState(capComAnim));
  }

  private getReplaceCapType(oriCapType: CapShowType): CapShowType {
    // 检测动效条目是否当做内容胶囊过渡，当内容胶囊被跳过时，阴影胶囊则需要当内容胶囊过渡
    let groupKey = this.extendAnimParam?.skipGroupKey;
    if (!groupKey) {
      return oriCapType;
    }
    if (oriCapType !== CapShowType.CAP_SHADOW) {
      return oriCapType;
    }
    let skipType = this.getCapData()?.findCapData(groupKey)?.getCapShowType();
    if (skipType !== CapShowType.CAP_CONTENT) {
      return oriCapType;
    }
    return CapShowType.CAP_CONTENT;
  }
}
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

import { WAnimProperty, WAnimScene, WBaseProperty } from '@ohos/screenlockcommon';
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
 * 列表过渡胶囊动效中胶囊子模块
 * 胶囊从列表区域过渡到胶囊区域，多胶囊同步过渡
 */
export class ChildCapInListToCap extends ChildHybridBaseAnim {
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
    // 胶囊从列表位置过渡到胶囊位置，多个胶囊同步过渡
    let startIndex = this.getListStaticSt()?.getStartIndex() ?? 0;
    let endIndex = this.getListStaticSt()?.getEndIndex() ?? 0;
    let capChain = this.getCapAnimVm()?.getDefaultCapChain();
    let listData = this.getListData();
    let initCfg = animCfg.getInitCfg();
    let finishCfg = animCfg.getFinishCfg();
    let endAlphaCfg = animCfg.getEndCfg(this.getCfgAlphaName());
    let endMainCfg = animCfg.getEndCfg(this.getCfgMainName());
    let hasValidAnim: boolean = false;
    for (let i = startIndex; i <= endIndex; i++) {
      let groupKey = listData?.[i]?.groupKey;
      if (groupKey === undefined || groupKey === this.extendAnimParam?.skipGroupKey) {
        continue;
      }
      capChain = this.getCapAnimVm()?.getValidCapChain(capChain);
      let capType = capChain?.getCapType();
      if (capType) {
        hasValidAnim = true;
        this.initEndCapItem({ groupKey: groupKey, capType: capType, initCfg: initCfg,
          finishCfg: finishCfg, endAlphaCfg: endAlphaCfg, endMainCfg: endMainCfg});
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

  private initEndCapItem(param: ItemParam): void {
    let groupKey = param.groupKey;
    let capType = param.capType;
    let listStyle = this.getListComStyle(groupKey);
    let listPos = CmpPosWrapper.wrapper(this.getListPos(groupKey));
    let capStyle = this.getCapComStyle(capType);
    let capPos = CmpPosWrapper.wrapper(this.getCapPos(capType));
    let listComAnim = this.getListComAnim(groupKey);
    let listFoldAnim = this.getListFoldAnim(groupKey);
    let capComAnim = this.getCapComAnim(capType);
    let listW = listPos.getCmpWidth();
    let listH = listPos.getCmpHeight();
    let capW = capPos.getCmpWidth();
    let capH = capPos.getCmpHeight();
    // 条目当前位移 + 条目堆叠效果位移
    let listCurTranY = listComAnim?.getTranY() ?? 0;
    listCurTranY = listCurTranY + (listFoldAnim?.getTranY() ?? 0);
    // 条目当前缩放
    let listCurScaleX = listComAnim?.getScaleX() ?? 1;
    let listCurScaleY = listComAnim?.getScaleY() ?? 1;
    // 胶囊位移
    let capTranX = listPos.getCmpCenterX() - capPos.getCmpCenterX();
    let capTranY = listPos.getCmpGlobalY() - capPos.getCmpGlobalY() + listCurTranY;
    // 动效初始配置
    param.initCfg?.bindConfig(this.getCapComKey(capType), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animStartScene)
      .bindConfig(WBaseProperty.CLIP_W, listW).bindConfig(WBaseProperty.CLIP_H, listH)
      .bindConfig(WBaseProperty.TRAN_X, capTranX).bindConfig(WBaseProperty.TRAN_Y, capTranY)
      .bindConfig(WBaseProperty.SCALE_X, listCurScaleX).bindConfig(WBaseProperty.SCALE_Y, listCurScaleY)
      .bindConfig(WBaseProperty.BORDER_RADIUS, listStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.ALPHA, 0).bindConfig(WBaseProperty.CLIP_ENABLE, true)
      .addPtState(capComAnim));
    // 动效结束配置
    param.finishCfg?.bindConfig(this.getCapComKey(capType), WidgetPropertyConfig.wrap()
      .bindConfig(WAnimProperty.ANIM_SCENE, this.animFinishScene).addPtState(capComAnim));
    // Alpha动效
    param.endAlphaCfg?.bindConfig(this.getCapComKey(capType), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.ALPHA, 1).addPtState(capComAnim));
    // 主动效终值配置
    param.endMainCfg?.bindConfig(this.getCapComKey(capType), WidgetPropertyConfig.wrap()
      .bindConfig(WBaseProperty.BORDER_RADIUS, capStyle?.getBorderRadiusTL())
      .bindConfig(WBaseProperty.CLIP_W, capW).bindConfig(WBaseProperty.CLIP_H, capH)
      .bindConfig(WBaseProperty.TRAN_X, 0).bindConfig(WBaseProperty.TRAN_Y, 0)
      .bindConfig(WBaseProperty.SCALE_X, 1).bindConfig(WBaseProperty.SCALE_Y, 1)
      .addPtState(capComAnim));
  }
}
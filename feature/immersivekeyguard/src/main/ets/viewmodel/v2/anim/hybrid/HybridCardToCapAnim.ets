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

import { curves } from '@kit.ArkUI';
import { CardShowType } from '../../../../common/constants/ImmCardConst';
import { CfgNameCardCap, ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { ImmAnimParam } from '../../../../model/data/config/ImmAnimParam';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ChildCapInCardToCap } from './ChildCapInCardToCap';
import { ChildCardInCardToCap } from './ChildCardInCardToCap';
import { IChildHybridAnim } from './IChildHybridAnim';
import { ImmBaseHybridAnim } from './ImmBaseHybridAnim';

// alpha动效时长
const DURATION_ALPHA = 200;

/**
 * 大卡过渡胶囊动效
 */
export class HybridCardToCapAnim extends ImmBaseHybridAnim {
  public getAnimScene(): ImmComAnimScene {
    return ImmComAnimScene.ANIM_CARD_CAP;
  }

  protected initCfg(): void {
    super.initCfg();
    this.buildInitCfg(ImmComPtConfig.wrap(CfgNameCardCap.CFG_INIT));
    this.buildFinishCfg(ImmComPtConfig.wrap(CfgNameCardCap.CFG_FINISH));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgAlphaPrefix())
      .buildAnimParam(ImmAnimParam.wrap()
        .buildAnimParam({ duration: DURATION_ALPHA, curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1) })));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgMainPrefix())
      .buildAnimParam(ImmAnimParam.wrap().buildMainAnim(true)
        .buildAnimParam({ curve: curves.interpolatingSpring(0, 1, 228, 24.5) })));
  }

  public onHybridAnim(): void {
    // 播控过渡时，透明度直接切换，无动效过渡
    let cardData = this.getCardCheckData()?.get(CardShowType.CARD_CAP);
    let isMediaCenter = cardData?.isMediaCenter();
    let endAlphaCfg = this.animCfg?.getEndCfg(this.getCfgAlphaPrefix());
    endAlphaCfg?.getAnimParam()?.updateDuration(isMediaCenter ? 0 : DURATION_ALPHA);
    // 播控动效开启
    if (isMediaCenter) {
      this.startMediaAnim();
    }
    super.onHybridAnim();
  }

  protected createChildAnim(): IChildHybridAnim[] {
    return [
      new ChildCapInCardToCap(this.vmInjector),
      new ChildCardInCardToCap(this.vmInjector)
    ];
  }

  /**
   * 打断动效
   */
  public interruptAnim(): void {
    // 打断列表到胶囊动效、胶囊到大卡动效、列表过渡大卡动效
    this.getAnimMgr()?.interruptAnim(ImmComAnimScene.ANIM_LIST_CAP_FIX)
      .interruptAnim(ImmComAnimScene.ANIM_CAP_CARD)
      .interruptAnim(ImmComAnimScene.ANIM_LIST_CARD);
  }

  protected getCfgAlphaPrefix(): string {
    return CfgNameCardCap.CFG_END_ALPHA;
  }

  protected getCfgMainPrefix(): string {
    return CfgNameCardCap.CFG_END_MAIN;
  }
}
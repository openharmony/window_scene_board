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
import { CfgNameListCard, ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { ImmAnimParam } from '../../../../model/data/config/ImmAnimParam';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ChildCapInListToCap } from './ChildCapInListToCap';
import { ChildCardInListToCard } from './ChildCardInListToCard';
import { ChildListInListToCap } from './ChildListInListToCap';
import { ChildListInListToCard } from './ChildListInListToCard';
import { IChildHybridAnim } from './IChildHybridAnim';
import { ImmBaseHybridAnim } from './ImmBaseHybridAnim';

// alpha动效时长
const DURATION_ALPHA = 200;

/**
 * 列表过渡大卡动效
 */
export class HybridListToCardAnim extends ImmBaseHybridAnim {
  public getAnimScene(): ImmComAnimScene {
    return ImmComAnimScene.ANIM_LIST_CARD;
  }

  protected initCfg(): void {
    super.initCfg();
    this.buildInitCfg(ImmComPtConfig.wrap(CfgNameListCard.CFG_INIT));
    this.buildFinishCfg(ImmComPtConfig.wrap(CfgNameListCard.CFG_FINISH));
    // 跟随时钟延时动效
    let clockDelay = this.getClockAnimVm()?.getClockAnimDelay() ?? 0;
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgAlphaPrefix())
      .buildAnimParam(ImmAnimParam.wrap()
        .buildAnimParam({ delay: clockDelay, duration: DURATION_ALPHA,
          curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1) })));
    // 按压回弹动效
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgClickPrefix())
      .buildAnimParam(ImmAnimParam.wrap()
        .buildAnimParam({ duration: DURATION_ALPHA, curve: Curve.Linear })));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgMainPrefix())
      .buildAnimParam(ImmAnimParam.wrap().buildMainAnim(true)
        .buildAnimParam({ delay: clockDelay, curve: curves.interpolatingSpring(0, 1, 228, 24.5) })));
  }

  public onHybridAnim(): void {
    // 刷新配置实例，存在skip，防止老配置污染
    this.animCfg?.clearEndCfg();
    this.initCfg();
    // 播控过渡时，透明度直接切换，无动效过渡
    let conData = this.getCardData()?.getCardData(CardShowType.CARD_CONTENT);
    let isMediaCenter = conData?.isMediaCenter();
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
      new ChildListInListToCard(this.vmInjector),
      new ChildCardInListToCard(this.vmInjector),
      // 同步列表过渡胶囊
      new ChildListInListToCap(this.vmInjector),
      new ChildCapInListToCap(this.vmInjector),
    ];
  }

  /**
   * 打断动效
   */
  public interruptAnim(): void {
    // 打断列表下滑胶囊回退动效、胶囊到列表动效、大卡到列表动效
    this.getAnimMgr()?.interruptAnim(ImmComAnimScene.ANIM_LIST_CAP_TOUCH_BACK)
      .interruptAnim(ImmComAnimScene.ANIM_CAP_LIST_FIX)
      .interruptAnim(ImmComAnimScene.ANIM_CARD_LIST);
  }

  protected getCfgAlphaPrefix(): string {
    return CfgNameListCard.CFG_END_ALPHA;
  }

  protected getCfgClickPrefix(): string {
    return CfgNameListCard.CFG_END_CLICK_SCALE;
  }

  protected getCfgMainPrefix(): string {
    return CfgNameListCard.CFG_END_MAIN;
  }
}
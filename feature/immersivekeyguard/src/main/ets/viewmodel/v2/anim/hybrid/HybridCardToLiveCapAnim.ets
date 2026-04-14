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

import { curves } from '@kit.ArkUI';
import { CfgNameCardLiveCap, ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { ImmAnimParam } from '../../../../model/data/config/ImmAnimParam';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ChildCardInCardToLiveCap } from './ChildCardInCardToLiveCap';
import { IChildHybridAnim } from './IChildHybridAnim';
import { ImmBaseHybridAnim } from './ImmBaseHybridAnim';

/**
 * 沉浸大卡过渡实况胶囊动效
 */
export class HybridCardToLiveCapAnim extends ImmBaseHybridAnim {
  public getAnimScene(): ImmComAnimScene {
    return ImmComAnimScene.ANIM_CARD_LIVE_CAP;
  }

  protected initCfg(): void {
    super.initCfg();
    this.buildInitCfg(ImmComPtConfig.wrap(CfgNameCardLiveCap.CFG_INIT));
    this.buildFinishCfg(ImmComPtConfig.wrap(CfgNameCardLiveCap.CFG_FINISH));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgAlphaPrefix())
      .buildAnimParam(ImmAnimParam.wrap()
        .buildAnimParam({ duration: 150, curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1) })));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgMainPrefix())
      .buildAnimParam(ImmAnimParam.wrap().buildMainAnim(true)
        .buildAnimParam({ curve: curves.interpolatingSpring(0, 1, 228, 30) })));
  }

  protected createChildAnim(): IChildHybridAnim[] {
    return [
      new ChildCardInCardToLiveCap(this.vmInjector),
    ];
  }

  /**
   * 打断动效
   */
  public interruptAnim(): void {
    // 打断大卡到实况列表、实况列表到大卡动效
    this.getAnimMgr()?.interruptAnim(ImmComAnimScene.ANIM_CARD_LIVE_LIST)
      .interruptAnim(ImmComAnimScene.ANIM_LIVE_LIST_CARD);
  }

  protected getCfgAlphaPrefix(): string {
    return CfgNameCardLiveCap.CFG_END_ALPHA;
  }

  protected getCfgMainPrefix(): string {
    return CfgNameCardLiveCap.CFG_END_MAIN;
  }
}
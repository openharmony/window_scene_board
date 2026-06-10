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
import { CfgNameCapCardSwitch, ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { ImmAnimParam } from '../../../../model/data/config/ImmAnimParam';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ChildCapInCapCardSwitch } from './ChildCapInCapCardSwitch';
import { ChildCardInCapCardSwitch } from './ChildCardInCapCardSwitch';
import { IChildHybridAnim } from './IChildHybridAnim';
import { ImmBaseHybridAnim } from './ImmBaseHybridAnim';

// alpha动效时长
const DURATION_ALPHA = 200;

/**
 * 胶囊大卡互切动效
 */
export class HybridCapCardSwitchAnim extends ImmBaseHybridAnim {
  public getAnimScene(): ImmComAnimScene {
    return ImmComAnimScene.ANIM_CAP_CARD_SWITCH;
  }

  protected initCfg(): void {
    super.initCfg();
    this.buildInitCfg(ImmComPtConfig.wrap(CfgNameCapCardSwitch.CFG_INIT));
    this.buildFinishCfg(ImmComPtConfig.wrap(CfgNameCapCardSwitch.CFG_FINISH));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgAlphaPrefix())
      .buildAnimParam(ImmAnimParam.wrap()
        .buildAnimParam({ duration: DURATION_ALPHA, curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1) })));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgMainPrefix())
      .buildAnimParam(ImmAnimParam.wrap().buildMainAnim(true)
        .buildAnimParam({ curve: curves.interpolatingSpring(0, 1, 228, 24.5) })));
  }

  public onHybridAnim(): void {
    this.interruptAnim();
    super.onHybridAnim();
  }

  protected createChildAnim(): IChildHybridAnim[] {
    return [
      new ChildCapInCapCardSwitch(this.vmInjector),
      new ChildCardInCapCardSwitch(this.vmInjector)
    ];
  }

  /**
   * 打断动效
   */
  public interruptAnim(): void {
    this.getAnimMgr()?.interruptAnim(ImmComAnimScene.ANIM_LIST_CAP_FIX)
      // 打断自身
      .interruptAnim(ImmComAnimScene.ANIM_CAP_CARD_SWITCH)
      .interruptAnim(ImmComAnimScene.ANIM_CAP_LIST_FIX)
      .interruptAnim(ImmComAnimScene.ANIM_CAP_CARD)
      .interruptAnim(ImmComAnimScene.ANIM_CAP_LIST_TOUCH_BACK);
  }

  protected getCfgAlphaPrefix(): string {
    return CfgNameCapCardSwitch.CFG_END_ALPHA;
  }

  protected getCfgMainPrefix(): string {
    return CfgNameCapCardSwitch.CFG_END_MAIN;
  }
}
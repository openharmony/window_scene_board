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
import { CfgNameListCap, ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { ImmAnimParam } from '../../../../model/data/config/ImmAnimParam';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ChildCapInListToCap } from './ChildCapInListToCap';
import { ChildClockInListToCap } from './ChildClockInListToCap';
import { ChildListInListToCap } from './ChildListInListToCap';
import { IChildHybridAnim } from './IChildHybridAnim';
import { ImmBaseHybridAnim } from './ImmBaseHybridAnim';

/**
 * 列表过渡胶囊动效
 */
export class HybridListToCapAnim extends ImmBaseHybridAnim {
  public getAnimScene(): ImmComAnimScene {
    return ImmComAnimScene.ANIM_LIST_CAP_FIX;
  }

  protected initCfg(): void {
    super.initCfg();
    this.buildInitCfg(ImmComPtConfig.wrap(CfgNameListCap.CFG_INIT));
    this.buildFinishCfg(ImmComPtConfig.wrap(CfgNameListCap.CFG_FINISH));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgAlphaPrefix())
      .buildAnimParam(ImmAnimParam.wrap().buildAnimParam({duration: 100, curve: Curve.Linear})));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgMainPrefix())
      .buildAnimParam(ImmAnimParam.wrap().buildMainAnim(true)
        .buildAnimParam({curve: this.getMainCurve()})));
  }

  public onHybridAnim(): void {
    // 刷新配置实例，存在skip，防止老配置污染
    this.animCfg?.clearEndCfg();
    this.initCfg();
    // 弹簧动效速度
    let vel = this.extendAnimParam?.vel ?? 0;
    let endMainCfg = this.animCfg?.getEndCfg(this.getCfgMainPrefix());
    endMainCfg?.getAnimParam()?.updateCurve(this.getMainCurve(vel));
    super.onHybridAnim();
  }

  protected createChildAnim(): IChildHybridAnim[] {
    return [
      new ChildListInListToCap(this.vmInjector),
      new ChildCapInListToCap(this.vmInjector),
      new ChildClockInListToCap(this.vmInjector)
    ];
  }

  /**
   * 打断动效
   */
  public interruptAnim(): void {
    // 打断胶囊到列表动效、大卡到列表动效、列表下滑回退动效
    this.getAnimMgr()?.interruptAnim(ImmComAnimScene.ANIM_CAP_LIST_FIX)
      .interruptAnim(ImmComAnimScene.ANIM_CARD_LIST)
      .interruptAnim(ImmComAnimScene.ANIM_LIST_CAP_TOUCH_BACK);
  }

  protected getCfgAlphaPrefix(): string {
    return CfgNameListCap.CFG_END_ALPHA;
  }

  protected getCfgMainPrefix(): string {
    return CfgNameListCap.CFG_END_MAIN;
  }

  private getMainCurve(vel: number = 0): ICurve {
    return curves.interpolatingSpring(vel, 1, 228, 24.5);
  }
}
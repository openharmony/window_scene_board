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
import { CfgNameCapList, ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { ImmAnimParam } from '../../../../model/data/config/ImmAnimParam';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ChildCapInCapToList } from './ChildCapInCapToList';
import { ChildClockInCapToList } from './ChildClockInCapToList';
import { ChildListInCapToList } from './ChildListInCapToList';
import { IChildHybridAnim } from './IChildHybridAnim';
import { ImmBaseHybridAnim } from './ImmBaseHybridAnim';

// 条目动效时延间隔
const ITEM_ANIM_DELAY = 50;

/**
 * 胶囊过渡列表动效
 */
export class HybridCapToListAnim extends ImmBaseHybridAnim {
  public getAnimScene(): ImmComAnimScene {
    return ImmComAnimScene.ANIM_CAP_LIST_FIX;
  }

  protected initCfg(): void {
    super.initCfg();
    this.buildInitCfg(ImmComPtConfig.wrap(CfgNameCapList.CFG_INIT));
    this.buildFinishCfg(ImmComPtConfig.wrap(CfgNameCapList.CFG_FINISH));
  }

  public onHybridAnim(): void {
    // 提前清空终值动效
    this.animCfg?.clearEndCfg();
    // 初始化、finish配置
    this.buildInitCfg(ImmComPtConfig.wrap(CfgNameCapList.CFG_INIT));
    this.buildFinishCfg(ImmComPtConfig.wrap(CfgNameCapList.CFG_FINISH));
    let startIndex = this.getListStaticSt()?.getStartIndex() ?? 0;
    let endIndex = this.getListStaticSt()?.getEndIndex() ?? 0;
    let clockDelay = this.getClockAnimVm()?.getClockAnimDelay() ?? 0;
    let listData = this.getListData();
    let vel = this.extendAnimParam?.vel ?? 0;
    let lastEndCfg: ImmComPtConfig | undefined = undefined;
    for (let i = startIndex; i <= endIndex; i++) {
      let groupKey = listData?.[i]?.groupKey;
      if (groupKey === undefined || groupKey === this.extendAnimParam?.skipGroupKey) {
        continue;
      }
      let delay = (i - startIndex) * ITEM_ANIM_DELAY + clockDelay;
      this.addEndCfg(ImmComPtConfig.wrap(this.getCfgAlphaName(i))
        .buildAnimParam(ImmAnimParam.wrap()
          .buildAnimParam({delay: delay, duration: 100, curve: Curve.Linear})));
      // 添加上一次的动效，最后的主动效循环结束后添加
      if (lastEndCfg) {
        this.addEndCfg(lastEndCfg);
      }
      lastEndCfg = ImmComPtConfig.wrap(this.getCfgMainName(i))
        .buildAnimParam(ImmAnimParam.wrap()
          .buildAnimParam({delay: delay, curve: curves.interpolatingSpring(vel, 1, 228, 24.5)}));
    }
    // 标识主动效
    let lastAnimParam = lastEndCfg?.getAnimParam();
    lastAnimParam?.buildMainAnim(true);
    // 动效结束处理
    lastAnimParam?.addDynamicFinish(() => this.getClockAnimVm()?.resetClockVel());
    // 最后添加主动效
    if (lastEndCfg) {
      this.addEndCfg(lastEndCfg);
    }
    super.onHybridAnim();
  }

  protected createChildAnim(): IChildHybridAnim[] {
    return [
      new ChildListInCapToList(this.vmInjector),
      new ChildCapInCapToList(this.vmInjector),
      new ChildClockInCapToList(this.vmInjector)
    ];
  }

  /**
   * 打断动效
   */
  public interruptAnim(): void {
    // 打断列表到胶囊动效、大卡到胶囊动效、胶囊上滑回退动效
    this.getAnimMgr()?.interruptAnim(ImmComAnimScene.ANIM_LIST_CAP_FIX)
      .interruptAnim(ImmComAnimScene.ANIM_CARD_CAP)
      .interruptAnim(ImmComAnimScene.ANIM_CAP_LIST_TOUCH_BACK);
  }

  protected getCfgAlphaPrefix(): string {
    return CfgNameCapList.CFG_END_ALPHA;
  }

  protected getCfgMainPrefix(): string {
    return CfgNameCapList.CFG_END_MAIN;
  }
}
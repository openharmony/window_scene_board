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
import { CardShowType } from '../../../../common/constants/ImmCardConst';
import { CfgNameCardList, ImmComAnimScene } from '../../../../common/constants/ImmComConst';
import { ImmAnimParam } from '../../../../model/data/config/ImmAnimParam';
import { ImmComPtConfig } from '../../../../model/data/config/ImmComPtConfig';
import { ChildCapInCapToList } from './ChildCapInCapToList';
import { ChildCardInCardToList } from './ChildCardInCardToList';
import { ChildListInCapToList } from './ChildListInCapToList';
import { ChildListInCardToList } from './ChildListInCardToList';
import { IChildHybridAnim } from './IChildHybridAnim';
import { ImmBaseHybridAnim } from './ImmBaseHybridAnim';

// alpha动效时长
const DURATION_ALPHA = 200;
// 条目动效时延间隔
const ITEM_ANIM_DELAY = 50;

/**
 * 大卡过渡列表动效
 * 同步需要胶囊过渡到列表
 */
export class HybridCardToListAnim extends ImmBaseHybridAnim {
  public getAnimScene(): ImmComAnimScene {
    return ImmComAnimScene.ANIM_CARD_LIST;
  }

  protected initCfg(): void {
    super.initCfg();
    this.buildInitCfg(ImmComPtConfig.wrap(CfgNameCardList.CFG_INIT));
    this.buildFinishCfg(ImmComPtConfig.wrap(CfgNameCardList.CFG_FINISH));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgAlphaPrefix())
      .buildAnimParam(ImmAnimParam.wrap()
        .buildAnimParam({ duration: DURATION_ALPHA, curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1) })));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgMainPrefix())
      .buildAnimParam(ImmAnimParam.wrap().buildMainAnim(true)
        .buildAnimParam({ curve: curves.interpolatingSpring(0, 1, 228, 24.5) })));
  }

  public onHybridAnim(): void {
    // 开启动效前，重置end动效配置
    this.resetEndCfg();
    // 播控过渡时，透明度直接切换，无动效过渡
    let cardData = this.getCardCheckData()?.get(CardShowType.CARD_LIST);
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
      new ChildListInCardToList(this.vmInjector),
      new ChildCardInCardToList(this.vmInjector),
      // 同步胶囊过渡列表动效
      new ChildCapInCapToList(this.vmInjector),
      new ChildListInCapToList(this.vmInjector),
    ];
  }

  /**
   * 打断动效
   */
  public interruptAnim(): void {
    // 打断列表过渡胶囊动效、列表到大卡动效、胶囊到大卡动效
    this.getAnimMgr()?.interruptAnim(ImmComAnimScene.ANIM_LIST_CAP_FIX)
      .interruptAnim(ImmComAnimScene.ANIM_LIST_CARD)
      .interruptAnim(ImmComAnimScene.ANIM_CAP_CARD);
  }

  protected getCfgAlphaPrefix(): string {
    return CfgNameCardList.CFG_END_ALPHA;
  }

  protected getCfgMainPrefix(): string {
    return CfgNameCardList.CFG_END_MAIN;
  }

  private resetEndCfg(): void {
    // 提前清除end动效，重新添加
    this.animCfg?.clearEndCfg();
    // 初始化、finish配置
    this.buildInitCfg(ImmComPtConfig.wrap(CfgNameCardList.CFG_INIT));
    this.buildFinishCfg(ImmComPtConfig.wrap(CfgNameCardList.CFG_FINISH));
    // 胶囊过渡列表相关动效
    let startIndex = this.getListStaticSt()?.getStartIndex() ?? 0;
    let endIndex = this.getListStaticSt()?.getEndIndex() ?? 0;
    let clockDelay = this.getClockAnimVm()?.getClockAnimDelay() ?? 0;
    let listData = this.getListData();
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
          .buildAnimParam({delay: delay, curve: curves.interpolatingSpring(0, 1, 228, 24.5)}));
    }
    // 标识主动效
    let lastAnimParam = lastEndCfg?.getAnimParam();
    lastAnimParam?.buildMainAnim(true);
    // 最后添加主动效
    if (lastEndCfg) {
      this.addEndCfg(lastEndCfg);
    }

    // 大卡相关动效，列表过渡无主动效则大卡动效为主动效
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgAlphaPrefix())
      .buildAnimParam(ImmAnimParam.wrap()
        .buildAnimParam({ duration: DURATION_ALPHA, curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1) })));
    this.addEndCfg(ImmComPtConfig.wrap(this.getCfgMainPrefix())
      .buildAnimParam(ImmAnimParam.wrap().buildMainAnim(lastEndCfg === undefined)
        .buildAnimParam({ curve: curves.interpolatingSpring(0, 1, 228, 24.5) })));
  }
}
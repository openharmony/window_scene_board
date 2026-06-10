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
import { WAnimProperty, WBaseProperty } from '@ohos/screenlockcommon';
import { WidgetPropertyConfig } from '@ohos/screenlockcommon/Index';
import { CardAnimScene, CardShowType } from '../../../../common/constants/ImmCardConst';
import { ImmCardPtConfig } from '../../../../model/data/config/ImmCardPtConfig';
import { CardBaseLifeCycleAnim } from './CardBaseLifeCycleAnim';

// 动效配置名称
enum CfgName {
  REMOVE_INIT = 'anim_remove_init',
  REMOVE_FINISH = 'anim_remove_finish',
  REMOVE_END_ALPHA = 'anim_remove_end_alpha',
  REMOVE_END_MAIN = 'anim_remove_end_main',
}

/**
 * 沉浸大卡删除动效
 */
export class CardRemoveAnim extends CardBaseLifeCycleAnim {
  protected initCfg(): void {
    // 沉浸大卡删除动效，删除大卡替代做动效
    this.animCfg.bindInitCfg(ImmCardPtConfig.wrap(CfgName.REMOVE_INIT)
      // 删除大卡初始化配置
      .bindConfig(this.getItemComKey(CardShowType.CARD_DELETE), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 1)
        .bindConfig(WBaseProperty.SCALE_X, 1)
        .bindConfig(WBaseProperty.SCALE_Y, 1)
        .addPtState(this.getItemComAnim(CardShowType.CARD_DELETE)))
      // 根布局初始化配置，保持可见
      .bindConfig(this.getRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .addPtState(this.getRootAnim()))
    ).bindFinishCfg(ImmCardPtConfig.wrap(CfgName.REMOVE_FINISH)
      // 删除大卡finish配置
      .bindConfig(this.getItemComKey(CardShowType.CARD_DELETE), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        .addPtState(this.getItemComAnim(CardShowType.CARD_DELETE)))
      // 根布局finish配置
      .bindConfig(this.getRootKey(), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        .addPtState(this.getRootAnim()))
      // 透明度动效
    ).addEndCfg(ImmCardPtConfig.wrap(CfgName.REMOVE_END_ALPHA)
      // 删除大卡透明度终值
      .bindConfig(this.getItemComKey(CardShowType.CARD_DELETE), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 0)
        .addPtState(this.getItemComAnim(CardShowType.CARD_DELETE)))
      // 同步动效曲线
    ).addAnimParam(
      { delay: 50, duration: 150, curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1) }
      // 主动效，缩放
    ).addEndCfg(ImmCardPtConfig.wrap(CfgName.REMOVE_END_MAIN)
      // 删除大卡缩放终值
      .bindConfig(this.getItemComKey(CardShowType.CARD_DELETE), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, 0.85)
        .bindConfig(WBaseProperty.SCALE_Y, 0.85)
        .addPtState(this.getItemComAnim(CardShowType.CARD_DELETE)))
      // 同步动效曲线，主动效
    ).addAnimParam({
      duration: 400,
      curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      // 动效结束时，清除删除条目
      onFinish: () => this.getCardData()?.remove(CardShowType.CARD_DELETE)
    }, true);
  }

  public getAnimScene(): CardAnimScene {
    // 动效场景，大卡删除动效
    return CardAnimScene.ANIM_DELETE;
  }

  public onLifeCycleAnim(): void {
    // 开启动效前，保持删除条目可见
    let delData = this.getCheckCardData()?.get(CardShowType.CARD_DELETE);
    if (delData) {
      this.getCardData()?.setCardData(CardShowType.CARD_DELETE, delData);
      // 开启动效
      super.onLifeCycleAnim();
    }
  }
}
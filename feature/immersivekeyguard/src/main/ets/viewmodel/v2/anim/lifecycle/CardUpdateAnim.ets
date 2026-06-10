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
  // 动效状态初始化
  UPDATE_INIT = 'anim_update_init',
  // 动效结束
  UPDATE_FINISH = 'anim_top_update_finish',
  // 旧数据动效透明度终值
  UPDATE_END_ALPHA_OLD = 'anim_update_end_alpha_old',
  // 新数据动效透明度终值，主动效
  UPDATE_END_ALPHA_NEW = 'anim_update_end_alpha_new',
}

/**
 * 沉浸大卡更新动效
 */
export class CardUpdateAnim extends CardBaseLifeCycleAnim {
  protected initCfg(): void {
    // 沉浸大卡更新动效，旧大卡渐隐，新大卡渐显(内容大卡)
    this.animCfg.bindInitCfg(ImmCardPtConfig.wrap(CfgName.UPDATE_INIT)
      // 内容大卡初始化配置
      .bindConfig(this.getItemComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
        // 标识动效开启
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 0)
        .addPtState(this.getItemComAnim(CardShowType.CARD_CONTENT)))
      // 更新旧大卡初始化配置
      .bindConfig(this.getItemComKey(CardShowType.CARD_UPDATE_OLD), WidgetPropertyConfig.wrap()
        // 标识动效开启
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 1)
        .addPtState(this.getItemComAnim(CardShowType.CARD_UPDATE_OLD)))
    ).bindFinishCfg(ImmCardPtConfig.wrap(CfgName.UPDATE_FINISH)
      // 内容大卡finish配置
      .bindConfig(this.getItemComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        .addPtState(this.getItemComAnim(CardShowType.CARD_CONTENT)))
      // 更新旧大卡finish配置
      .bindConfig(this.getItemComKey(CardShowType.CARD_UPDATE_OLD), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        .addPtState(this.getItemComAnim(CardShowType.CARD_UPDATE_OLD)))
      // 渐隐透明度动效
    ).addEndCfg(ImmCardPtConfig.wrap(CfgName.UPDATE_END_ALPHA_OLD)
      // 更新旧大卡透明度终值
      .bindConfig(this.getItemComKey(CardShowType.CARD_UPDATE_OLD), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 0)
        .addPtState(this.getItemComAnim(CardShowType.CARD_UPDATE_OLD)))
      // 同步动效曲线，渐隐透明度动效
    ).addAnimParam(
      { delay: 100, curve: curves.interpolatingSpring(0, 1, 228, 30) }
      // 渐显透明度动效
    ).addEndCfg(ImmCardPtConfig.wrap(CfgName.UPDATE_END_ALPHA_NEW)
      // 内容大卡透明度终值
      .bindConfig(this.getItemComKey(CardShowType.CARD_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 1)
        .addPtState(this.getItemComAnim(CardShowType.CARD_CONTENT)))
      // 同步动效曲线
    ).addAnimParam({ curve: curves.interpolatingSpring(0, 1, 228, 30) }, true);
  }

  public getAnimScene(): CardAnimScene {
    // 动效场景，沉浸大卡更新动效
    return CardAnimScene.ANIM_UPDATE;
  }

  public onLifeCycleAnim(): void {
    let oldData = this.getCheckCardData()?.get(CardShowType.CARD_UPDATE_OLD);
    if (oldData) {
      this.getCardData()?.setCardData(CardShowType.CARD_UPDATE_OLD, oldData);
      // 开启动效
      super.onLifeCycleAnim();
    }
  }
}
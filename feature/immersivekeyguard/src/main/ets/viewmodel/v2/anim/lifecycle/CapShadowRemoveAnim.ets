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
import { CapAnimScene, CapShowType } from '../../../../common/constants/ImmCapConst';
import { ImmCapPtConfig } from '../../../../model/data/config/ImmCapPtConfig';
import { CapBaseLifeCycleAnim } from './CapBaseLifeCycleAnim';

// 动效配置名称
enum CfgName {
  // 动效状态初始化
  SHADOW_REMOVE_INIT = 'anim_shadow_remove_init',
  // 动效结束
  SHADOW_REMOVE_FINISH = 'anim_shadow_remove_finish',
  // 动效透明度终值
  SHADOW_REMOVE_END_ALPHA = 'anim_shadow_remove_end_alpha',
}

/**
 * 阴影胶囊删除动效
 */
export class CapShadowRemoveAnim extends CapBaseLifeCycleAnim {
  protected initCfg(): void {
    // 阴影胶囊移除动效，移除数据替代阴影胶囊
    this.animCfg.bindInitCfg(ImmCapPtConfig.wrap(CfgName.SHADOW_REMOVE_INIT)
      // 移除胶囊初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMOVE), WidgetPropertyConfig.wrap()
        // 标识动效开启
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 1)
        // 同步绑定移除胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMOVE)))
    ).bindFinishCfg(ImmCapPtConfig.wrap(CfgName.SHADOW_REMOVE_FINISH)
      // 移除胶囊结束动效配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMOVE), WidgetPropertyConfig.wrap()
        // 标识动效结束
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定移除胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMOVE)))
      // 透明度动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.SHADOW_REMOVE_END_ALPHA)
      // 移除胶囊透明度终值
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_REMOVE), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 0)
        // 同步绑定移除胶囊动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_REMOVE)))
      // 同步动效曲线，透明度动效
    ).addAnimParam({
      duration: 150, curve: Curve.Linear,
      onFinish: () => this.getCapData()?.remove(CapShowType.CAP_REMOVE)
    }, true);
  }

  public getAnimScene(): CapAnimScene {
    // 动效场景，阴影胶囊移除动效
    return CapAnimScene.ANIM_SHADOW_REMOVE;
  }

  public onLifeCycleAnim(): void {
    // 使用移除数据替代阴影胶囊
    let delData = this.getCheckCapData()?.get(CapShowType.CAP_REMOVE);
    if (delData) {
      this.getCapData()?.setCapData(CapShowType.CAP_REMOVE, delData);
      let shadowStyle = this.getItemComStyle(CapShowType.CAP_SHADOW);
      let initRemove = this.animCfg?.getInitCfg()?.getConfig(this.getItemComKey(CapShowType.CAP_REMOVE));
      initRemove?.bindConfig(WBaseProperty.MARGIN_T, shadowStyle?.getMarginT())
        .bindConfig(WBaseProperty.MARGIN_L, shadowStyle?.getMarginL())
        .bindConfig(WBaseProperty.MARGIN_R, shadowStyle?.getMarginR())
        .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, shadowStyle?.getBgBrightnessInner());
      // 开启动效
      super.onLifeCycleAnim();
    }
  }
}
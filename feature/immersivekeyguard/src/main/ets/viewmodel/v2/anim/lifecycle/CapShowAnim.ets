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
import { CapAnimScene } from '../../../../common/constants/ImmCapConst';
import { ImmCapPtConfig } from '../../../../model/data/config/ImmCapPtConfig';
import { CapBaseLifeCycleAnim } from './CapBaseLifeCycleAnim';

// 动效配置名称
enum CfgName {
  // 动效状态初始化
  ROOT_SHOW_INIT = 'anim_root_show_init',
  // 动效结束
  ROOT_SHOW_FINISH = 'anim_root_show_finish',
  // 动效透明度终值
  ROOT_SHOW_END_ALPHA = 'anim_root_show_end_alpha',
  // 动效缩放、模糊终值主场景
  ROOT_SHOW_END_MAIN = 'anim_root_show_end_main',
}

/**
 * 胶囊出现动效
 */
export class CapShowAnim extends CapBaseLifeCycleAnim {
  protected initCfg(): void {
    // 胶囊出现动效，根布局直接控制
    this.animCfg.bindInitCfg(ImmCapPtConfig.wrap(CfgName.ROOT_SHOW_INIT)
      // 根布局初始化配置
      .bindConfig(this.getRootKey(),
        WidgetPropertyConfig.wrap()
          // 标识动效开启
          .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
          .bindConfig(WBaseProperty.ALPHA, 0)
          .bindConfig(WBaseProperty.SCALE_X, 0.6)
          .bindConfig(WBaseProperty.SCALE_Y, 0.6)
          .bindConfig(WBaseProperty.BLUR, 50)
          .bindConfig(WBaseProperty.CLIP_ENABLE, true)
          // 同步绑定根布局动效State
          .addPtState(this.getRootAnim()))
    ).bindFinishCfg(ImmCapPtConfig.wrap(CfgName.ROOT_SHOW_FINISH)
      // 根布局结束动效配置
      .bindConfig(this.getRootKey(),
        WidgetPropertyConfig.wrap()
          // 标识动效结束
          .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
          // 同步绑定根布局动效State
          .addPtState(this.getRootAnim()))
      // 透明度动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.ROOT_SHOW_END_ALPHA)
      // 根布局透明度终值配置
      .bindConfig(this.getRootKey(),
        WidgetPropertyConfig.wrap()
          .bindConfig(WBaseProperty.ALPHA, 1)
          // 同步绑定根布局动效State
          .addPtState(this.getRootAnim()))
      // 同步动效曲线
    ).addAnimParam(
      { duration: 150, curve: Curve.Linear }
      // 主动效，缩放、模糊
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.ROOT_SHOW_END_MAIN)
      // 根布局主动效终值配置
      .bindConfig(this.getRootKey(),
        WidgetPropertyConfig.wrap()
          .bindConfig(WBaseProperty.SCALE_X, 1)
          .bindConfig(WBaseProperty.SCALE_Y, 1)
          .bindConfig(WBaseProperty.BLUR, 0)
          // 同步绑定根布局动效State
          .addPtState(this.getRootAnim()))
      // 同步动效曲线，主动效
    ).addAnimParam({ curve: curves.interpolatingSpring(0, 1, 228, 21) }, true);
  }

  public getAnimScene(): CapAnimScene {
    // 动效场景，胶囊出现动效
    return CapAnimScene.ANIM_SHOW;
  }

  public onLifeCycleAnim(): void {
    // 开启出现动效时，需要打断隐藏动效
    this.getAnimMgr()?.interruptAnim(CapAnimScene.ANIM_HIDE);
    // 开启动效
    super.onLifeCycleAnim();
  }
}
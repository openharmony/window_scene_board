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
  TOP_ADD_INIT = 'anim_top_add_init',
  TOP_ADD_FINISH = 'anim_top_add_finish',
  TOP_ADD_END_ALPHA = 'anim_top_add_end_alpha',
  TOP_ADD_END_MAIN = 'anim_top_add_end_main',
}

/**
 * 胶囊顶部新增动效
 */
export class CapTopAddAnim extends CapBaseLifeCycleAnim {
  protected initCfg(): void {
    // 胶囊顶部新增动效，内容胶囊+阴影胶囊协同控制
    this.animCfg.bindInitCfg(ImmCapPtConfig.wrap(CfgName.TOP_ADD_INIT)
      // 内容胶囊初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        // 标识动效开启
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 0)
        .bindConfig(WBaseProperty.SCALE_X, 1.2)
        .bindConfig(WBaseProperty.SCALE_Y, 1.2)
        .bindConfig(WBaseProperty.BLUR, 50)
        // 同步绑定内容胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        // 标识动效开启
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.SCALE_X, 1.06)
        .bindConfig(WBaseProperty.SCALE_Y, 1.06)
        .bindConfig(WBaseProperty.TRAN_Y, -6)
        // 同步绑定阴影胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_SHADOW)))
    ).bindFinishCfg(ImmCapPtConfig.wrap(CfgName.TOP_ADD_FINISH)
      // 内容胶囊结束动效配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        // 标识动效结束
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定内容胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊结束动效配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        // 标识动效结束
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定阴影胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_SHADOW)))
      // 透明度动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.TOP_ADD_END_ALPHA)
      // 内容胶囊透明度终值配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 1)
        // 同步绑定内容胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 同步动效曲线
    ).addAnimParam(
      { duration: 150, curve: Curve.Linear }
      // 主动效，缩放、模糊
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.TOP_ADD_END_MAIN)
      // 内容胶囊主动效终值配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, 1)
        .bindConfig(WBaseProperty.SCALE_Y, 1)
        .bindConfig(WBaseProperty.BLUR, 0)
        // 同步绑定内容胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊主动效终值配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, 1)
        .bindConfig(WBaseProperty.SCALE_Y, 1)
        .bindConfig(WBaseProperty.TRAN_Y, 0)
        // 同步绑定阴影胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_SHADOW)))
      // 同步动效曲线，主动效
    ).addAnimParam({ curve: curves.interpolatingSpring(0, 1, 228, 21) }, true);
  }

  public getAnimScene(): CapAnimScene {
    // 动效场景，胶囊顶部新增动效
    return CapAnimScene.ANIM_TOP_ADD;
  }

  public onLifeCycleAnim(): void {
    // 开启顶部新增动效时，需要打断顶部移除、更新动效
    this.getAnimMgr()?.interruptAnim(CapAnimScene.ANIM_TOP_REMOVE).interruptAnim(CapAnimScene.ANIM_TOP_UPDATE);
    // 开启动效前，阴影胶囊初始化偏移以Style为准
    let shadowStyle = this.getItemComStyle(CapShowType.CAP_SHADOW);
    let initShadowCfg = this.animCfg?.getInitCfg()?.getConfig(this.getItemComKey(CapShowType.CAP_SHADOW));
    initShadowCfg?.bindConfig(WBaseProperty.TRAN_Y, -(shadowStyle?.getMarginT() ?? 0));
    // 开启动效
    super.onLifeCycleAnim();
  }
}
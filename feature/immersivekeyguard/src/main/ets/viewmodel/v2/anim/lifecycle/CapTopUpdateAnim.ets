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
  TOP_UPDATE_INIT = 'anim_top_update_init',
  // 动效结束
  TOP_UPDATE_FINISH = 'anim_top_update_finish',
  // 第一段动效透明度终值
  TOP_UPDATE_END_ALPHA_IN = 'anim_top_update_end_alpha_in',
  // 第一段动效缩放终值
  TOP_UPDATE_END_SCALE_IN = 'anim_top_update_end_scale_in',
  // 第二段动效透明度终值
  TOP_UPDATE_END_ALPHA_OUT = 'anim_top_update_end_alpha_out',
  // 第二段动效缩放终值，主动效
  TOP_UPDATE_END_SCALE_OUT = 'anim_top_update_end_scale_out',
}

/**
 * 胶囊顶部更新动效
 */
export class CapTopUpdateAnim extends CapBaseLifeCycleAnim {
  protected initCfg(): void {
    // 胶囊顶部更新动效，两段动效：第一段缩小，第二段还原
    this.animCfg.bindInitCfg(ImmCapPtConfig.wrap(CfgName.TOP_UPDATE_INIT)
      // 内容胶囊初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        // 标识动效开启
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.SCALE_X, 1)
        .bindConfig(WBaseProperty.SCALE_Y, 1)
        .bindConfig(WBaseProperty.CLIP_ENABLE, true)
        .bindConfig(WBaseProperty.ALIGN_CONTENT, Alignment.Start)
        // 同步绑定内容胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 内容胶囊inner初始化配置
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        // 标识动效开启
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 1)
        // 同步绑定内容胶囊inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        // 标识动效开启
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.TRAN_Y, 0)
        .bindConfig(WBaseProperty.CLIP_ENABLE, true)
        .bindConfig(WBaseProperty.ALIGN_CONTENT, Alignment.Start)
        // 同步绑定阴影胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_SHADOW)))
      // 阴影胶囊inner初始化配置
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        // 标识动效开启
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        // 同步绑定阴影胶囊inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_SHADOW)))
    ).bindFinishCfg(ImmCapPtConfig.wrap(CfgName.TOP_UPDATE_FINISH)
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
      // 内容胶囊inner结束动效配置
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        // 标识动效结束
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定内容胶囊inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊inner结束动效配置
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        // 标识动效结束
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定阴影胶囊inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_SHADOW)))
      // 第一段透明度动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.TOP_UPDATE_END_ALPHA_IN)
      // 内容胶囊inner透明度终值
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 0)
        // 同步绑定内容胶囊inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_CONTENT)))
      // 同步动效曲线，第一段透明度动效
    ).addAnimParam(
      { duration: 100, curve: Curve.Linear }
      // 第一段缩放动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.TOP_UPDATE_END_SCALE_IN)
      // 内容胶囊缩放动效终值配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, 0.95)
        .bindConfig(WBaseProperty.SCALE_Y, 0.95)
        // 同步绑定内容胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊缩放动效终值配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.TRAN_Y, -6)
        // 同步绑定胶囊胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_SHADOW)))
      // 同步动效曲线，第一段缩放动效
    ).addAnimParam(
      { duration: 300, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1) }
      // 第二段透明度动效，顺序靠后
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.TOP_UPDATE_END_ALPHA_OUT)
      // 内容胶囊inner透明度终值配置
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 1)
        // 同步绑定内容胶囊inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_CONTENT)))
      // 同步动效曲线
    ).addAnimParam(
      { delay: 300, duration: 200, curve: Curve.Linear }
      // 第二段缩放动效，顺序靠后，主动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.TOP_UPDATE_END_SCALE_OUT)
      // 内容胶囊主动效终值配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, 1)
        .bindConfig(WBaseProperty.SCALE_Y, 1)
        // 同步绑定内容胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊主动效终值配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.TRAN_Y, 0)
        // 同步绑定胶囊胶囊动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_SHADOW)))
      // 同步动效曲线，主动效
    ).addAnimParam({ delay: 300, curve: curves.interpolatingSpring(0, 1, 228, 22) }, true);
  }

  public getAnimScene(): CapAnimScene {
    // 动效场景，胶囊顶部更新动效
    return CapAnimScene.ANIM_TOP_UPDATE;
  }

  public onLifeCycleAnim(): void {
    let shadowStyle = this.getItemComStyle(CapShowType.CAP_SHADOW);
    // 第一段动效胶囊裁切宽度大到小，第二段动效胶囊裁切宽度小到大
    let contentPos = this.getItemPos(CapShowType.CAP_CONTENT);
    let shadowPos = this.getItemPos(CapShowType.CAP_SHADOW);
    let contentMaxWidth = contentPos?.width ?? 0;
    let shadowMaxWidth = shadowPos?.width ?? 0;
    let contentMinWidth = (shadowStyle?.getHeight() as number) ?? 0;
    let shadowMinWidth = contentMinWidth - (shadowStyle?.getMarginL() ?? 0) - (shadowStyle?.getMarginR() ?? 0);
    // 初始保持大宽度
    let initCfg = this.animCfg?.getInitCfg();
    let initContentCfg = initCfg?.getConfig(this.getItemComKey(CapShowType.CAP_CONTENT));
    let initConInnerCfg = initCfg?.getConfig(this.getItemInnerKey(CapShowType.CAP_CONTENT));
    let initShadowCfg = initCfg?.getConfig(this.getItemComKey(CapShowType.CAP_SHADOW));
    let initShaInnerCfg = initCfg?.getConfig(this.getItemInnerKey(CapShowType.CAP_SHADOW));
    initContentCfg?.bindConfig(WBaseProperty.CLIP_W, contentMaxWidth);
    initConInnerCfg?.bindConfig(WBaseProperty.WIDTH, contentMaxWidth);
    initShadowCfg?.bindConfig(WBaseProperty.CLIP_W, shadowMaxWidth);
    initShaInnerCfg?.bindConfig(WBaseProperty.WIDTH, shadowMaxWidth);
    // 第一段动效end保持小宽度，阴影胶囊偏移以Style为准
    let inEndCfg = this.animCfg?.getEndCfg(CfgName.TOP_UPDATE_END_SCALE_IN);
    let inContentCfg = inEndCfg?.getConfig(this.getItemComKey(CapShowType.CAP_CONTENT));
    let inShadowCfg = inEndCfg?.getConfig(this.getItemComKey(CapShowType.CAP_SHADOW));
    inContentCfg?.bindConfig(WBaseProperty.CLIP_W, contentMinWidth);
    inShadowCfg?.bindConfig(WBaseProperty.CLIP_W, shadowMinWidth)
      .bindConfig(WBaseProperty.TRAN_Y, -(shadowStyle?.getMarginT() ?? 0));
    // 第二段动效end保持大宽度
    let outEndCfg = this.animCfg?.getEndCfg(CfgName.TOP_UPDATE_END_SCALE_OUT);
    let outContentCfg = outEndCfg?.getConfig(this.getItemComKey(CapShowType.CAP_CONTENT));
    let outShadowCfg = outEndCfg?.getConfig(this.getItemComKey(CapShowType.CAP_SHADOW));
    outContentCfg?.bindConfig(WBaseProperty.CLIP_W, contentMaxWidth);
    outShadowCfg?.bindConfig(WBaseProperty.CLIP_W, shadowMaxWidth);
    // 开启顶部更新动效时，需要打断顶部新增、删除动效
    this.getAnimMgr()?.interruptAnim(CapAnimScene.ANIM_TOP_ADD).interruptAnim(CapAnimScene.ANIM_TOP_REMOVE);
    // 开启动效
    super.onLifeCycleAnim();
  }
}
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
import { ImmCapDataArray } from '../../../../model/data/v2/ImmCapDataArray';
import { CapBaseLifeCycleAnim } from './CapBaseLifeCycleAnim';

// 动效配置名称
enum CfgName {
  REMIND_EXIT_INIT = 'anim_remind_exit_init',
  REMIND_EXIT_FINISH = 'anim_remind_exit_finish',
  REMIND_EXIT_END_OUT_ALPHA = 'anim_remind_exit_end_out_alpha',
  REMIND_EXIT_END_OUT = 'anim_remind_exit_end_out',
  REMIND_EXIT_END_BACK_ALPHA = 'anim_remind_exit_end_back_alpha',
  REMIND_EXIT_END_BACK = 'anim_remind_exit_end_back',
}

// 超出胶囊区域偏移量
const OUT_TRAN_Y: number = 2;

/**
 * 胶囊强提醒退出动效
 */
export class CapRemindExitAnim extends CapBaseLifeCycleAnim {
  protected initCfg(): void {
    // 强提醒退出两段动效，第一段内容胶囊从底部翻转漏出，第二段内容胶囊从底部远处回到顶部显示
    this.animCfg.bindInitCfg(ImmCapPtConfig.wrap(CfgName.REMIND_EXIT_INIT)
      // 内容胶囊com初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 0.51)
        .bindConfig(WBaseProperty.SCALE_X, 1)
        .bindConfig(WBaseProperty.SCALE_Y, 1)
        .bindConfig(WBaseProperty.Z_INDEX, -1)
        .bindConfig(WBaseProperty.TRAN_Y, 0)
        // 同步绑定内容com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 内容胶囊inner初始化配置
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 0)
        // 同步绑定内容inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_CONTENT)))
      // 强提醒胶囊com初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 1)
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMIND)))
      // 阴影胶囊com初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 0)
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_SHADOW)))
    ).bindFinishCfg(ImmCapPtConfig.wrap(CfgName.REMIND_EXIT_FINISH)
      // 强提醒胶囊com结束动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMIND)))
      // 内容胶囊inner结束动效
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定内容inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_CONTENT)))
      // 内容胶囊com结束动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 阴影胶囊com结束动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定阴影com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_SHADOW)))
      // 透明度动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.REMIND_EXIT_END_OUT_ALPHA)
      // 内容胶囊com透明度动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 1)
        // 同步绑定内容com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 内容胶囊inner透明度动效
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 1)
        // 同步绑定内容inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_CONTENT)))
      // 同步动效曲线
    ).addAnimParam(
      { duration: 100, curve: Curve.Linear }
      // 翻转漏出动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.REMIND_EXIT_END_OUT)
      // 内容胶囊com翻转动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, 1.05)
        .bindConfig(WBaseProperty.SCALE_Y, 1.05)
        .bindConfig(WBaseProperty.TRAN_Y, 50)
        // 同步绑定内容com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 同步动效曲线
    ).addAnimParam({
      duration: 300, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        // 第一段动效结束时，内容胶囊用强提醒层级，强提醒胶囊用内容层级
        let contentIndex = ImmCapDataArray.getZIndex(CapShowType.CAP_CONTENT);
        let remindIndex = ImmCapDataArray.getZIndex(CapShowType.CAP_REMIND);
        this.getItemComAnim(CapShowType.CAP_CONTENT)?.setZIndex(remindIndex);
        this.getItemComAnim(CapShowType.CAP_REMIND)?.setZIndex(contentIndex);
      }
      // 回顶部动效-透明度动效
    }).addEndCfg(ImmCapPtConfig.wrap(CfgName.REMIND_EXIT_END_OUT_ALPHA)
      // 强提醒胶囊透明度动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 0)
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMIND)))
      // 阴影胶囊透明度动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_SHADOW), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 1)
        .addPtState(this.getItemComAnim(CapShowType.CAP_SHADOW)))
      // 同步动效曲线
    ).addAnimParam(
      { delay: 300, duration: 150, curve: Curve.Linear }
      // 回顶部动效，按序保持最后执行
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.REMIND_EXIT_END_BACK)
      // 内容胶囊com回顶部动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, 1)
        .bindConfig(WBaseProperty.SCALE_Y, 1)
        .bindConfig(WBaseProperty.TRAN_Y, 0)
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 强提醒胶囊com回顶部动效，过渡成阴影胶囊样式
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMIND)))
      // 同步动效曲线，主动效，动效结束，移除强提醒数据
    ).addAnimParam({
      delay: 300, curve: curves.interpolatingSpring(0, 1, 228, 22),
      onFinish: () => this.getCapData()?.remove(CapShowType.CAP_REMIND)
    }, true);
  }

  public getAnimScene(): CapAnimScene {
    // 动效场景，强提醒退出动效
    return CapAnimScene.ANIM_REMIND_EXIT;
  }

  public onLifeCycleAnim(): void {
    // 初始场景，内容胶囊按阴影胶囊样式，强提醒胶囊按强提醒胶囊样式
    let shadowComStyle = this.getItemComStyle(CapShowType.CAP_SHADOW);
    let contentInitCfg = this.animCfg.getInitCfg()?.getConfig(this.getItemComKey(CapShowType.CAP_CONTENT));
    contentInitCfg?.bindConfig(WBaseProperty.MARGIN_T, shadowComStyle?.getMarginT())
      .bindConfig(WBaseProperty.MARGIN_L, shadowComStyle?.getMarginL())
      .bindConfig(WBaseProperty.MARGIN_R, shadowComStyle?.getMarginR())
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, shadowComStyle?.getBgBrightnessInner());
    let contentComStyle = this.getItemComStyle(CapShowType.CAP_CONTENT);
    // 翻转out场景，内容胶囊按移出胶囊区域2vp动效
    let endOutCfg = this.animCfg.getEndCfg(CfgName.REMIND_EXIT_END_OUT);
    let contentOutCfg = endOutCfg?.getConfig(this.getItemComKey(CapShowType.CAP_CONTENT));
    let endTranY = (contentComStyle?.getHeight() as number ?? 0) + OUT_TRAN_Y;
    contentOutCfg?.bindConfig(WBaseProperty.TRAN_Y, endTranY)
      .bindConfig(WBaseProperty.MARGIN_T, contentComStyle?.getMarginT())
      .bindConfig(WBaseProperty.MARGIN_L, contentComStyle?.getMarginL())
      .bindConfig(WBaseProperty.MARGIN_R, contentComStyle?.getMarginR())
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, contentComStyle?.getBgBrightnessInner());
    // 回顶部场景，强提醒胶囊切换为阴影胶囊样式
    let endBackCfg = this.animCfg.getEndCfg(CfgName.REMIND_EXIT_END_BACK);
    let remindBackCfg = endBackCfg?.getConfig(this.getItemComKey(CapShowType.CAP_REMIND));
    remindBackCfg?.bindConfig(WBaseProperty.MARGIN_T, shadowComStyle?.getMarginT())
      .bindConfig(WBaseProperty.MARGIN_L, shadowComStyle?.getMarginL())
      .bindConfig(WBaseProperty.MARGIN_R, shadowComStyle?.getMarginR())
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, shadowComStyle?.getBgBrightnessInner());
    // 配置准备就绪，开启动效
    super.onLifeCycleAnim();
  }
}
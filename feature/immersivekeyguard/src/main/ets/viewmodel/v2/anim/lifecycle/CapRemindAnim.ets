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
import { IImmCapRemindVm } from '../../../../common/interface/IImmCapRemindVm';
import { ImmCapPtConfig } from '../../../../model/data/config/ImmCapPtConfig';
import { ImmCapDataArray } from '../../../../model/data/v2/ImmCapDataArray';
import { CapBaseLifeCycleAnim } from './CapBaseLifeCycleAnim';

// 动效配置名称
enum CfgName {
  REMIND_INIT = 'anim_remind_init',
  REMIND_FINISH = 'anim_remind_finish',
  REMIND_END_ALPHA = 'anim_remind_end_alpha',
  REMIND_END_OUT = 'anim_remind_end_out',
  REMIND_END_BACK = 'anim_remind_end_back',
}

// 超出胶囊区域偏移量
const OUT_TRAN_Y: number = 2;

/**
 * 胶囊强提醒动效
 */
export class CapRemindAnim extends CapBaseLifeCycleAnim {
  protected initCfg(): void {
    // 强提醒两段动效，第一段从底部翻转漏出，第二段从底部远处回到顶部显示
    this.animCfg.bindInitCfg(ImmCapPtConfig.wrap(CfgName.REMIND_INIT)
      // 强提醒胶囊com初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 0.51)
        .bindConfig(WBaseProperty.SCALE_X, 1)
        .bindConfig(WBaseProperty.SCALE_Y, 1)
        .bindConfig(WBaseProperty.Z_INDEX, -1)
        .bindConfig(WBaseProperty.TRAN_Y, 0)
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMIND)))
      // 强提醒胶囊inner初始化配置
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        .bindConfig(WBaseProperty.ALPHA, 0)
        // 同步绑定强提醒inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_REMIND)))
      // 内容胶囊com初始化配置
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimStartScene())
        // 同步绑定内容com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
    ).bindFinishCfg(ImmCapPtConfig.wrap(CfgName.REMIND_FINISH)
      // 强提醒胶囊com结束动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMIND)))
      // 强提醒胶囊inner结束动效
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定强提醒inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_REMIND)))
      // 内容胶囊com结束动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        .bindConfig(WAnimProperty.ANIM_SCENE, this.getAnimFinishScene())
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 透明度动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.REMIND_END_ALPHA)
      // 强提醒胶囊com透明度动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 1)
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMIND)))
      // 强提醒胶囊inner透明度动效
      .bindConfig(this.getItemInnerKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.ALPHA, 1)
        // 同步绑定强提醒inner动效State
        .addPtState(this.getItemInnerAnim(CapShowType.CAP_REMIND)))
      // 同步动效曲线
    ).addAnimParam(
      { duration: 100, curve: Curve.Linear }
      // 翻转漏出动效
    ).addEndCfg(ImmCapPtConfig.wrap(CfgName.REMIND_END_OUT)
      // 强提醒胶囊com翻转动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, 1.05)
        .bindConfig(WBaseProperty.SCALE_Y, 1.05)
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMIND)))
      // 同步动效曲线，第一段动效结束时，提升强提醒胶囊的层级
    ).addAnimParam({
      duration: 300, curve: curves.cubicBezierCurve(0.2, 0, 0.2, 1),
      onFinish: () => {
        let remindIndex = ImmCapDataArray.getZIndex(CapShowType.CAP_REMIND);
        this.getItemComAnim(CapShowType.CAP_REMIND)?.setZIndex(remindIndex);
      }
      // 回顶部动效，按序保持最后执行
    }).addEndCfg(ImmCapPtConfig.wrap(CfgName.REMIND_END_BACK)
      // 强提醒胶囊com回顶部动效
      .bindConfig(this.getItemComKey(CapShowType.CAP_REMIND), WidgetPropertyConfig.wrap()
        .bindConfig(WBaseProperty.SCALE_X, 1)
        .bindConfig(WBaseProperty.SCALE_Y, 1)
        .bindConfig(WBaseProperty.TRAN_Y, 0)
        // 同步绑定强提醒com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_REMIND)))
      // 内容胶囊com回顶部动效，过渡成阴影胶囊样式
      .bindConfig(this.getItemComKey(CapShowType.CAP_CONTENT), WidgetPropertyConfig.wrap()
        // 同步绑定内容com动效State
        .addPtState(this.getItemComAnim(CapShowType.CAP_CONTENT)))
      // 同步动效曲线，主动效
    ).addAnimParam({ delay: 300, curve: curves.interpolatingSpring(0, 1, 228, 22) }, true);
  }

  public getAnimScene(): CapAnimScene {
    // 动效场景，强提醒动效
    return CapAnimScene.ANIM_REMIND;
  }

  public onLifeCycleAnim(): void {
    let remindData = this.getCheckCapData()?.get(CapShowType.CAP_REMIND);
    if (!remindData) {
      return;
    }
    // 打断强提醒退出动效，填充强提醒数据，通知强提醒状态切换，阴影胶囊则复制出强提醒胶囊，标识强提醒状态
    this.getAnimMgr()?.interruptAnim(CapAnimScene.ANIM_REMIND_EXIT);
    if (remindData.getCapShowType() === CapShowType.CAP_SHADOW) {
      remindData = remindData.copy();
    }
    this.getCapData()?.setCapData(CapShowType.CAP_REMIND, remindData);
    this.getCapRemindVm()?.onRemindAnimStart();
    // 初始场景，强提醒胶囊按阴影胶囊样式，内容胶囊按强提醒胶囊样式
    let shadowComStyle = this.getItemComStyle(CapShowType.CAP_SHADOW);
    let remindInitCfg = this.animCfg.getInitCfg()?.getConfig(this.getItemComKey(CapShowType.CAP_REMIND));
    remindInitCfg?.bindConfig(WBaseProperty.MARGIN_T, shadowComStyle?.getMarginT())
      .bindConfig(WBaseProperty.MARGIN_L, shadowComStyle?.getMarginL())
      .bindConfig(WBaseProperty.MARGIN_R, shadowComStyle?.getMarginR())
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, shadowComStyle?.getBgBrightnessInner());
    let remindComStyle = this.getItemComStyle(CapShowType.CAP_REMIND);
    let contentInitCfg = this.animCfg.getInitCfg()?.getConfig(this.getItemComKey(CapShowType.CAP_CONTENT));
    contentInitCfg?.bindConfig(WBaseProperty.MARGIN_T, remindComStyle?.getMarginT() ?? 0)
      .bindConfig(WBaseProperty.MARGIN_L, remindComStyle?.getMarginL() ?? 0)
      .bindConfig(WBaseProperty.MARGIN_R, remindComStyle?.getMarginR() ?? 0)
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, remindComStyle?.getBgBrightnessInner());
    // 翻转out场景，强提醒胶囊按移出胶囊区域2vp动效
    let endOutCfg = this.animCfg.getEndCfg(CfgName.REMIND_END_OUT);
    let remindOutCfg = endOutCfg?.getConfig(this.getItemComKey(CapShowType.CAP_REMIND));
    let endTranY = (remindComStyle?.getHeight() as number ?? 0) + OUT_TRAN_Y;
    remindOutCfg?.bindConfig(WBaseProperty.TRAN_Y, endTranY)
      .bindConfig(WBaseProperty.MARGIN_T, remindComStyle?.getMarginT())
      .bindConfig(WBaseProperty.MARGIN_L, remindComStyle?.getMarginL())
      .bindConfig(WBaseProperty.MARGIN_R, remindComStyle?.getMarginR())
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, remindComStyle?.getBgBrightnessInner());
    // 回顶部场景，内容胶囊切换为当前自身样式
    let contentComStyle = this.getItemComStyle(CapShowType.CAP_CONTENT);
    let endBackCfg = this.animCfg.getEndCfg(CfgName.REMIND_END_BACK);
    let contentBackCfg = endBackCfg?.getConfig(this.getItemComKey(CapShowType.CAP_CONTENT));
    contentBackCfg?.bindConfig(WBaseProperty.MARGIN_T, contentComStyle?.getMarginT())
      .bindConfig(WBaseProperty.MARGIN_L, contentComStyle?.getMarginL())
      .bindConfig(WBaseProperty.MARGIN_R, contentComStyle?.getMarginR())
      .bindConfig(WBaseProperty.BG_BRIGHTNESS_INNER, contentComStyle?.getBgBrightnessInner());
    // 配置准备就绪，开启动效
    super.onLifeCycleAnim();
  }

  private getCapRemindVm(): IImmCapRemindVm | undefined {
    return this.vmInjector?.getImmCapRemindVm();
  }
}
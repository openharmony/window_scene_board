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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { ResUtils } from '@ohos/windowscene';
import { LiveViewCapsuleStyle } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ListCardAnimExecutor } from './executor/ListCardAnimExecutor';
import { CardCapsuleAnimExecutor } from './executor/CardCapsuleAnimExecutor';
import { ImmersiveLiveAnimSceneEnum as AnimScene, immeLiveStateShareMgr } from '@ohos/screenlockcommon/Index';
import { curves } from '@kit.ArkUI';
import { BaseAnimExecutor } from './executor/BaseAnimExecutor';
import { ImmersiveCardConst } from '../../common/constants/ImmersiveCardConst';

const TAG = 'ImmersiveLiveAnimManager';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// 透明度动效参数
export const ALPHA_PARAM: AnimateParam = { curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1), duration: 150 };
// 胶囊渐隐动效参数
export const FADE_PARAM: AnimateParam = { curve: curves.cubicBezierCurve(0.4, 0, 0.4, 1), duration: 350 };

// 组件圆角值
export const LIST_RADIUS = ResUtils.getNumber($r('app.float.live_view_card_border_radius'));
export const CAPSULE_RADIUS = LiveViewCapsuleStyle.CAPSULE_RADIUS;
export const CARD_RADIUS = ImmersiveCardConst.CARD_RADIUS_SMALL_FOLD;

// 实况列表缩放倍率
export const LIVE_LIST_SCALE_RATIO = 0.9;

// 胶囊margin值
export const CAPSULE_MARGIN = LiveViewCapsuleStyle.CAPSULE_SHADOW_LEFT_MARGIN;

/**
 * 沉浸式状态动效管理
 */
export class ImmersiveLiveAnimManager {
  private animStrategyMap = new Map<AnimScene, BaseAnimExecutor>();

  constructor() {
    immeLiveStateShareMgr.setInterruptedExecutor(this.interruptedExecutor);
    this.initAnimSceneExecutor();
  }

  /**
   * 打断动效
   *
   * @param scene 动效场景
   */
  public interruptedExecutor: (scene: AnimScene) => void = (scene: AnimScene) => {
    this.animStrategyMap.get(scene)?.afterAnim();
  }

  /**
   * 触发动效
   * @param scene 动效场景
   * @param isForward 是否正向动效
   * @param keyCode 沉浸数据标识
   */
  public triggerExecutor(scene: AnimScene, isForward: boolean, keyCode?: string): void {
    let executor = this.animStrategyMap.get(scene);
    executor?.setKeyCode(keyCode);
    executor?.exec(isForward);
  }

  /**
   * 设置动效外部前置动效和后置动作
   *
   * @param scene 动效场景
   * @param preAction 动效前动作
   * @param afterAction  动效后动作
   */
  public setAnimAction(scene: AnimScene, preAction?: () => void, afterAction?: () => void): void {
    let executor = this.animStrategyMap.get(scene);
    executor?.setPreAction(preAction);
    executor?.setAfterAction(afterAction);
  }

  private initAnimSceneExecutor(): void {
    this.animStrategyMap.set(AnimScene.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM,
      new ListCardAnimExecutor(AnimScene.SCENE_LIVE_LIST_IMME_CARD_TRANSFORM));
    this.animStrategyMap.set(AnimScene.SCENE_LIVE_CAPSULE_IMME_CARD_TRANSFORM,
      new CardCapsuleAnimExecutor(AnimScene.SCENE_LIVE_CAPSULE_IMME_CARD_TRANSFORM));
  }
}
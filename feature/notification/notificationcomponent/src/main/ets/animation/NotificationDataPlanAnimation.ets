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
import { AnimateParams, AnimationBase, AnimationNames, INotificationDataPlanVm } from '@ohos/systemuicommon/newIndex';
import { curves } from '@kit.ArkUI';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { AnimateToScheduleUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NotificationDataPlanAnimation');
const DATA_SPRING_ANIM: ICurve = curves.interpolatingSpring(1.2, 1, 350, 30);
const OPACITY_DISAPPEAR_ANIM_DURATION: number = 117;
const OPACITY_ANIM_DURATION: number = 217;
const DATA_OPACITY_ANIM_DELAY: number = 50;
const TEXT_TRANS_Y: number = ArkUIAdapter.px2vp(-65);
const DATA_HIDE_SCALE: number = 0.8;

export class NotificationDataPlanAnimation extends AnimationBase {
  /**
   * 流量数据展示时的缩放大小
   */
  public static readonly dataShowScale: number = 1;
  /**
   * show动效计数，控制最后一次动效执行完后执行GC提升
   */
  private animCount: number = 0;

  constructor() {
    super(AnimationNames.NTF_DATA_PLAN_ANIMATION, true);
  }

  /**
   * 执行流量数据出现动效
   * @param params 属性信息
   */
  public doShowAnim(params: INotificationDataPlanVm): void {
    this.clearAnimations();
    this.addAnimation(this.getShowAnimations(params));
    this.hideTitleText(params);
    params.followAnim = undefined;
    this.startAnimation().then(() => params.followAnim = { duration: 500, curve: Curve.Friction, });
  }

  /**
   * 执行流量数据消失动效
   * @param params 属性信息
   */
  public doHideAnim(params: INotificationDataPlanVm): void {
    this.clearAnimations();
    this.addAnimation(this.getHideAnimations(params));
    params.followAnim = undefined;
    this.startAnimation().then(() => {
      params.dataTextOpacity = 1;
      params.dataTextScale = NotificationDataPlanAnimation.dataShowScale;
      params.dataTextTranslateY = 0;
    });
  }

  private getShowAnimations(params: INotificationDataPlanVm): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        delay: DATA_OPACITY_ANIM_DELAY,
        curve: DATA_SPRING_ANIM,
        onFinish: () => this.onShowAnimFinish(),
        event: () => {
          this.animCount++;
          params.dataTextScale = NotificationDataPlanAnimation.dataShowScale;
          params.dataTextTranslateY = 0;
        },
      },
      {
        delay: DATA_OPACITY_ANIM_DELAY,
        duration: OPACITY_ANIM_DURATION,
        curve: Curve.Linear,
        onFinish: () => this.onShowAnimFinish(),
        event: () => {
          this.animCount++;
          params.dataTextOpacity = 1;
        },
      },
    );
    return animateParams;
  }

  private hideTitleText(params: INotificationDataPlanVm): void {
    params.dataTextOpacity = 0;
    params.dataTextScale = DATA_HIDE_SCALE;
    params.dataTextTranslateY = TEXT_TRANS_Y;
  }

  private onShowAnimFinish(): void {
    this.animCount--;
    if (this.animCount === 0) {
      log.showInfo(`raiseAnimateToGCPriority end`);
      // 结束GC避让，使用ApiUtil中的方法，可以处理跨线程调用场景
      NotificationApiUtil.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
    }
  }

  private getHideAnimations(params: INotificationDataPlanVm): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        curve: DATA_SPRING_ANIM,
        event: () => {
          params.dataTextTranslateY = TEXT_TRANS_Y;
          if (params.dataTextScale > DATA_HIDE_SCALE) {
            params.dataTextScale = DATA_HIDE_SCALE;
          }
        },
      },
      {
        duration: OPACITY_DISAPPEAR_ANIM_DURATION,
        curve: Curve.Linear,
        event: () => {
          params.dataTextOpacity = 0;
        },
      },
    );
    return animateParams;
  }
}


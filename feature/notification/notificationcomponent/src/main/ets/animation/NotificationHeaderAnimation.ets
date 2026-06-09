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
import { AnimateToScheduleUtils, LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { NotificationApiUtil } from '../utils/NotificationApiUtil';
import { AnimateParams, AnimationBase, AnimationNames, INotificationHeaderVm } from '@ohos/systemuicommon/newIndex';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const log = LogHelper.getLogHelper(LogDomain.NC, 'NtfHeaderAnimation');

const TITLE_SPRING_ANIM: ICurve = curves.interpolatingSpring(1.2, 1, 350, 30);
const OPACITY_DISAPPEAR_ANIM_DURATION: number = 117;
const OPACITY_ANIM_DURATION: number = 217;
const DATE_OPACITY_ANIM_DELAY: number = 50;
const TEXT_TRANS_Y: number = ArkUIAdapter.px2vp(-65);
const TIME_HIDE_SCALE: number = 1;
const DATE_HIDE_SCALE: number = 0.8;

/**
 * 通知面板头部动效
 *
 * @since 2024-11-08
 */
export class NotificationHeaderAnimation extends AnimationBase {
  /**
   * 时间展示时的缩放大小
   */
  public static readonly timeShowScale: number = 1.25;
  /**
   * 日期展示时的缩放大小
   */
  public static readonly dateShowScale: number = 1;
  /**
   * show动效计数，控制最后一次动效执行完后执行GC提升
   */
  private animCount: number = 0;

  constructor() {
    super(AnimationNames.NTF_HEADER_ANIMATION, true);
  }

  /**
   * 执行通知时间、日期出现动效
   * @param params 属性信息
   */
  public doShowAnim(params: INotificationHeaderVm): void {
    this.clearAnimations();
    this.addAnimation(this.getShowAnimations(params));
    this.hideTitleText(params);
    params.followAnim = undefined;
    this.startAnimation().then(() => params.followAnim = { duration: 500, curve: Curve.Friction, });
  }

  /**
   * 执行通知时间、日期消失动效
   * @param params 属性信息
   */
  public doHideAnim(params: INotificationHeaderVm): void {
    this.clearAnimations();
    this.addAnimation(this.getHideAnimations(params));
    params.followAnim = undefined;
    this.startAnimation().then(() => {
      params.timeTextOpacity = 1;
      params.timeTextScale = NotificationHeaderAnimation.timeShowScale;
      params.timeTextTranslateY = 0;
      params.dateTextOpacity = 1;
      params.dateTextScale = NotificationHeaderAnimation.dateShowScale;
      params.dateTextTranslateY = 0;
    });
  }

  private getShowAnimations(params: INotificationHeaderVm): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        curve: TITLE_SPRING_ANIM,
        onFinish: () => this.onShowAnimFinish(),
        event: () => {
          this.animCount++;
          params.timeTextScale = NotificationHeaderAnimation.timeShowScale;
          params.timeTextTranslateY = 0;
        },
      },
      {
        duration: OPACITY_ANIM_DURATION,
        curve: Curve.Linear,
        onFinish: () => this.onShowAnimFinish(),
        event: () => {
          this.animCount++;
          params.timeTextOpacity = 1;
        },
      },
      {
        delay: DATE_OPACITY_ANIM_DELAY,
        curve: TITLE_SPRING_ANIM,
        onFinish: () => this.onShowAnimFinish(),
        event: () => {
          this.animCount++;
          params.dateTextScale = NotificationHeaderAnimation.dateShowScale;
          params.dateTextTranslateY = 0;
        },
      },
      {
        delay: DATE_OPACITY_ANIM_DELAY,
        duration: OPACITY_ANIM_DURATION,
        curve: Curve.Linear,
        onFinish: () => this.onShowAnimFinish(),
        event: () => {
          this.animCount++;
          params.dateTextOpacity = 1;
        },
      },
    );
    return animateParams;
  }

  private hideTitleText(params: INotificationHeaderVm): void {
    params.timeTextOpacity = 0;
    params.timeTextScale = TIME_HIDE_SCALE;
    params.timeTextTranslateY = TEXT_TRANS_Y;
    params.dateTextOpacity = 0;
    params.dateTextScale = DATE_HIDE_SCALE;
    params.dateTextTranslateY = TEXT_TRANS_Y;
  }

  private onShowAnimFinish(): void {
    if (--this.animCount === 0) {
      log.showInfo(`raiseAnimateToGCPriority end`);
      // 结束GC避让，使用ApiUtil中的方法，可以处理跨线程调用场景
      NotificationApiUtil.raiseAnimateToGCPriority(AnimateToScheduleUtils.VALUE_END);
    }
  }

  private getHideAnimations(params: INotificationHeaderVm): AnimateParams[] {
    let animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        curve: TITLE_SPRING_ANIM,
        event: () => {
          params.timeTextTranslateY = TEXT_TRANS_Y;
          params.dateTextTranslateY = TEXT_TRANS_Y;
          if (params.timeTextScale > TIME_HIDE_SCALE) {
            params.timeTextScale = TIME_HIDE_SCALE;
          }
          if (params.dateTextScale > DATE_HIDE_SCALE) {
            params.dateTextScale = DATE_HIDE_SCALE;
          }
        },
      },
      {
        duration: OPACITY_DISAPPEAR_ANIM_DURATION,
        curve: Curve.Linear,
        event: () => {
          params.timeTextOpacity = 0;
          params.dateTextOpacity = 0;
        },
      },
    );
    return animateParams;
  }
}
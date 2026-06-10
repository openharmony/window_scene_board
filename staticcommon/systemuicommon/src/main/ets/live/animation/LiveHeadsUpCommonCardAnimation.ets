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
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { AnimationBase } from '../../animation/AnimationBase';
import { StatusBarCapsulePosition } from '../../statusbar/model/StatusBarCapsulePosition';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { ILiveHeadsUpCommonCardVm } from '../interface/ILiveHeadsUpCommonCardVm';
import { curves, display } from '@kit.ArkUI';
import { LiveStyle } from '../constants/LiveStyle';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { LiveCardShowAnimationEventUtil } from '../../utils/LiveCardShowAnimationEventUtil';
import { ArkUIAdapter, ViewName } from '../../utils/ArkUIAdapter';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveHeadsUpCommonCardAnimation');

interface AnchorPosition {
  x: number;
  y: number;
}

export class LiveHeadsUpCommonCardAnimation extends AnimationBase {
  /**
   * 展开卡片的尺寸动画曲线
   */
  private readonly EXPAND_SIZE_CURVE = curves.springCurve(0, 1, 200, 21);

  private readonly EXPAND_CURVE_COMPLETE_TIME = 700;
  /**
   * 吐出延迟时间，需要在融球缩小后，在做出场动画
   */
  private readonly EXPAND_DELAY: number = 350;
  /**
   * 出场透明度变化延时
   */
  private readonly EXPAND_OPACITY_DURATION: number = 100;

  private readonly VISUAL_EFFECT_DELAY: number = 750;

  private readonly VISUAL_EFFECT_LAND_DELAY: number = 500;

  private cardVm: ILiveHeadsUpCommonCardVm;
  private position: StatusBarCapsulePosition;
  private cardRect: RectResult = { x: 0, y: 0, width: 0, height: 0 };

  constructor(cardVm: ILiveHeadsUpCommonCardVm, position: StatusBarCapsulePosition) {
    super(AnimationBase.NAMES.LIVE_HEADS_UP_COMMON_CARD_ANIMATION, true);
    this.cardVm = cardVm;
    this.position = position;
  }

  /**
   * 展开卡片
   * @param cardVm
   * @param preemption 实况横幅之间是否为抢占出场，抢占出场不需要等融球动效
   * @returns
   */
  public async expandCard(preemption?: boolean): Promise<void> {
    // 清理上一次动画的数据
    this.clearAnimations();
    // 初始化卡片尺寸
    this.initCardRect();
    // 设置展开初始态
    this.setExpandInitialState();
    // 设置动画结束状态
    this.setExpandFinalState(preemption);
    // 启动动画
    await this.startAnimation(`ExpandCard`);
  }

  /**
   * 收起卡片动画
   * @returns
   */
  public async collapseCard(): Promise<void> {
    // 清理上一次动画的数据
    this.clearAnimations();
    // 初始化卡片尺寸
    this.initCardRect();
    // 设置动画初始状态
    this.setCollapseInitialState();
    // 设置动画终态
    this.setCollapseFinalState();
    // 启动动画
    await this.startAnimation(`CollapseCard`);
  }

  private getAnchorPosition(): AnchorPosition {
    const position = this.position;
    if (DeviceInfoVm.instance.isXTLandscapeInvertedStatus() && !ResourceVm.instance.isRTL) {
      return {
        x: CutoutVm.instance.left + CutoutVm.instance.width / 2,
        y: CutoutVm.instance.top + CutoutVm.instance.height / 2,
      }
    }
    if (CutoutVm.instance.isMiddleCutout()) {
      log.showInfo(`position height is ${position.height}`);
      return { x: position.left + (position.width / 2), y: position.top + (position.height) / 2 + 8 }
    }
    // 竖屏的锚点需要以胶囊左侧为锚点
    return { x: position.left + (position.width / 2) + 18, y: position.top + (position.height / 2) };
  }

  private setExpandInitialState(): void {
    const live = this.cardVm.live;
    if (!live) {
      return;
    }

    const anchor = this.getAnchorPosition();
    const contentScale: ScaleOptions = { x: 0.025, y: 0.05 };
    const cardVm = this.cardVm;

    log.info('setExpandInitialState, anchorPosition: ', anchor);
    cardVm.containerOpacity = 1;
    cardVm.containerBorderRadius = this.cardRect.height / 2;
    cardVm.containerSize = {
      width: this.cardRect.width * 0.025,
      height: this.cardRect.height * 0.05,
    };

    log.showInfo(`width: ${cardVm.containerSize.width}, height: ${cardVm.containerSize.height},
      cardRect.x: ${this.cardRect.x}, cardRect.y: ${this.cardRect.y}`)
    this.calcEndOffsetX(anchor);
    cardVm.containerOffsetY = anchor.y - this.cardRect.y - (cardVm.containerSize.height as number) / 2;

    cardVm.contentScale = contentScale;
    cardVm.contentSize = this.cardRect;
    cardVm.contentOpacity = 0;
    cardVm.backCardOpacity = CutoutVm.instance.isMiddleCutout() ? 1 : 0; //仅竖屏存在黑色面板动效
    cardVm.cardGradientOpacity = 1;
    log.info(`setExpandInitialState for ${live.hashCode}, cardRect :`, this.cardRect);
    log.showInfo(`Expand, left: ${cardVm.containerOffsetX}, top: ${cardVm.containerOffsetY}`);
  }

  private setExpandFinalState(preemption?: boolean): void {
    const live = this.cardVm.live;
    if (!live) {
      return;
    }
    const cardVm = this.cardVm;
    const offsetDelay = (CutoutVm.instance.isMiddleCutout() && !preemption) ? this.EXPAND_DELAY : 0;
    const opacityDelay = offsetDelay;
    const containerSize: SizeOptions = { width: '100%', height: 'auto' };
    const contentScale: ScaleOptions = { x: 1, y: 1 };

    log.showInfo(`Expand offsetDelay: ${offsetDelay}, opacityDelay: ${opacityDelay}`);

    // 设置动画结束后状态
    this.addAnimation([
      {
        curve: this.EXPAND_SIZE_CURVE,
        delay: offsetDelay,
        event: () => {
          cardVm.containerOffsetX = 0;
          cardVm.containerOffsetY = 0;
        }
      },
      {
        curve: this.EXPAND_SIZE_CURVE,
        delay: opacityDelay,
        event: () => {
          cardVm.containerBorderRadius = LiveStyle.CARD_RADIUS;
          cardVm.containerSize = containerSize;
          cardVm.contentScale = contentScale;
        }
      },
      {
        curve: Curve.Linear,
        duration: this.EXPAND_OPACITY_DURATION,
        delay: opacityDelay,
        event: () => {
          cardVm.backCardOpacity = 0;
          cardVm.contentOpacity = 1;
        }
      },
      {
        delay: this.EXPAND_CURVE_COMPLETE_TIME,
        duration: 1,
        event: () => {
          cardVm.contentSize = undefined;
        }
      }
    ]);
    LiveCardShowAnimationEventUtil.setLiveCardAnimation(CutoutVm.instance.isMiddleCutout() ? this.VISUAL_EFFECT_DELAY :
      this.VISUAL_EFFECT_LAND_DELAY);
  }

  private setCollapseInitialState(): void {
    this.cardVm.contentSize = this.cardRect;
  }

  private setCollapseFinalState(): void {
    const live = this.cardVm.live;
    if (!live) {
      return;
    }
    const cardVm = this.cardVm;
    const cardRect = this.cardRect;
    const anchorPosition = this.getAnchorPosition();
    const containerSize: SizeOptions = { width: 6, height: 6 };

    this.addAnimation([{
      curve: this.EXPAND_SIZE_CURVE,
      duration: this.EXPAND_CURVE_COMPLETE_TIME,
      event: () => {
        cardVm.containerBorderRadius = cardRect.height / 2;
        cardVm.containerSize = containerSize;
        cardVm.contentScale = {
          x: containerSize.width as number / cardRect.width,
          y: containerSize.height as number / cardRect.height,
        };
        this.calcEndOffsetX(anchorPosition);
      }
    }, {
      curve: this.EXPAND_SIZE_CURVE,
      duration: this.EXPAND_CURVE_COMPLETE_TIME,
      delay: 14,
      event: () => {
        cardVm.containerOffsetY = anchorPosition.y - cardRect.y - (containerSize.height as number) / 2;
      }
    }, {
      curve: Curve.Linear,
      duration: this.EXPAND_CURVE_COMPLETE_TIME,
      event: () => {
        cardVm.cardGradientOpacity = 0;
      }
    }, {
      curve: Curve.Linear,
      duration: 100,
      delay: 200,
      event: () => {
        cardVm.contentOpacity = 0;
        cardVm.backCardOpacity = CutoutVm.instance.isMiddleCutout() ? 1 : 0;
      }
    }, {
      delay: 190,
      duration: 1,
      event: () => {
        cardVm.containerOpacity = 0;
        cardVm.containerSize = { width: '100%', height: 'auto' };
        cardVm.contentSize = undefined;
      }
    }]);

    log.showInfo(`Collapse ${live.hashCode}, left: ${cardVm.containerOffsetX}, top:${cardVm.containerOffsetY}`);
  }

  private initCardRect(): void {
    this.cardRect =
      SystemUICommonUtil.getRect(this.cardVm.componentId, ArkUIAdapter.getUiContextByViewName(ViewName.BANNER_VIEW));
  }

  private calcEndOffsetX(anchor: AnchorPosition): void {
    this.cardVm.containerOffsetX = anchor.x - this.cardRect.x - (this.cardVm.containerSize.width as number) / 2;
    if (ResourceVm.instance.isRTL) {
      if (DeviceInfoVm.instance.orientation !== display.Orientation.PORTRAIT || DeviceInfoVm.instance.isExpand) {
        //镜像语言且非挖孔竖屏下，横幅卡片的出场offsetX = 时间左侧坐标 - 时间右侧距离手机边缘的padding + 容器宽度/2
        this.cardVm.containerOffsetX =
          this.position.left - this.position.statusBarClockLeftSpace +
            (this.cardVm.containerSize.width as number) / 2 + 14;
      }
    }
  }
}
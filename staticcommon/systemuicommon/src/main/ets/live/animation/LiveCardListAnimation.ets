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
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SystemUICommonUtil } from '../../utils/SystemUICommonUtil';
import { ILiveCardListItemVm } from '../interface/ILiveCardListItemVm';
import { ILiveVmInjector } from '../interface/ILiveVmInjector';
import { LiveStyle } from '../constants/LiveStyle';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { ResourceVm } from '../../vm/ResourceVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { display } from '@kit.ArkUI';
import { LiveCardShowAnimationEventUtil } from '../../utils/LiveCardShowAnimationEventUtil';
import { ArkUIAdapter, ViewName } from '../../utils/ArkUIAdapter';


const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'LiveCardListAnimation');

export interface AnchorPosition {
  x: number;
  y: number;
}

/**
 * 实况卡片列表动画
 */
export class LiveCardListAnimation extends AnimationBase {
  /**
   * 展开卡片的动画曲线
   */
  private readonly EXPAND_CURVES = curves.springMotion(0.43, 0.752);
  /**
   * 收起卡片的动画曲线
   */
  private readonly COLLAPSE_CURVE: curves.ICurve = curves.cubicBezierCurve(0.26, 0, 0.39, 0.95);
  /**
   * 收起卡片时位置和尺寸动画持续时间
   */
  private readonly COLLAPSE_SIZE_DURATION = 250;
  /**
   * 收起时卡片间的延迟时间
   */
  private readonly COLLAPSE_ITEM_DELAY = 17;
  /**
   * 展开时卡片间的延迟时间
   */
  private readonly EXPAND_ITEM_DELAY = 17;
  /**
   * 弹簧曲线最大近似完成时间，取SCALE_CURVE的时间
   */
  private readonly EXPAND_CURVE_COMPLETE_TIME = 650;
  /**
   * 无孔卡片背板透明度渐变时间间隔
   */
  private readonly CARD_BACK_OPACITY_DELAY = 25;
  /**
   * 卡片渐变持续时间
   */
  private readonly SINGLE_HOLE_CARD_GRADIENT_TIME: number = 183;
  /**
   * 卡片渐变持续时间
   */
  private readonly MULTIPLE_HOLE_CARD_GRADIENT_TIME: number = 117;
  /**
   * 卡片辅助区透明度动效时延
   */
  private readonly CARD_EXTEND_OPACITY_DELAY = 250;
  /**
   * 进度类卡片动效时延
   */
  private readonly PROGRESS_CARD_ANIM_DELAY = 250;
  /**
   * 无孔卡片背板透明度渐变时间
   */
  private readonly CARD_BACK_OPACITY_TIME = 50;
  /**
   * 卡片流光时间间隔
   */
  private readonly VISUAL_EFFECT_DELAY: number = 300;
  /**
   * 卡片流光相比卡片offset动效开始时的时延
   */
  private readonly VISUAL_EFFECT_START_DELAY: number = 30;

  private vmInjector: ILiveVmInjector;

  constructor(vmInjector: ILiveVmInjector) {
    super(AnimationBase.NAMES.LIVE_CARD_LIST_ANIMATION, true);
    this.vmInjector = vmInjector;
  }

  private getAnchorPosition(): AnchorPosition {
    const position = this.vmInjector.getCapsuleListVm().position;
    if (DeviceInfoVm.instance.isXTLandscapeInvertedStatus() && !ResourceVm.instance.isRTL) {
      return {
        x: CutoutVm.instance.left + CutoutVm.instance.width / 2,
        y: CutoutVm.instance.top + CutoutVm.instance.height / 2,
      }
    }
    return { x: position.left + (position.width / 2) +
      (CutoutVm.instance.isMiddleCutout() ? 0 : LiveStyle.CAPSULE_LEFT_STATUS_BAR_GAP_WITHOUT_HOLE),
      y: position.top + (position.height / 2) };
  }

  private setExpandInitialState(cardRectList: RectResult[]): void {
    const cardListVm = this.vmInjector.getCardListVm();
    const anchorPosition = this.getAnchorPosition();
    const containerWidthScale = 0.025;
    const containerHeightScale = 0.05;
    const contentScale: ScaleOptions = CutoutVm.instance.isMiddleCutout() ? { x: 0.025, y: 0.05 } : { x: 0.1, y: 0.1 };
    log.info('setExpandInitialState, anchorPosition: ', anchorPosition);
    for (let i = 0; i < cardRectList.length; i++) {
      const live = cardListVm.liveList[i];
      const cardVm = this.vmInjector.getCardListItemVm(live);
      const cardRect = cardRectList[i];

      cardVm.containerBorderRadius = cardRect.height / 2;
      cardVm.contentBorderRadius = cardRect.height / 2;
      cardVm.containerSize = {
        width: cardRect.width * containerWidthScale,
        height: cardRect.height * containerHeightScale,
      };
      cardVm.containerOffsetX = anchorPosition.x - cardRect.x - (cardVm.containerSize.width as number) / 2;
      cardVm.containerOffsetX = this.calcEndOffsetX(cardVm, cardVm.containerOffsetX);
      cardVm.containerOffsetY = this.getExpandOffsetY(anchorPosition, cardRect, cardVm);
      cardVm.contentScale = contentScale;
      cardVm.contentAlign = Alignment.TopStart;
      cardVm.contentSize = cardRect;
      cardVm.contentOpacity = 0;
      cardVm.cardBackOpacity = CutoutVm.instance.isMiddleCutout() ? 1 : 0.1;
      cardVm.cardGradientOpacity = 0;
      cardVm.containerOpacity = 1;
      if (!CutoutVm.instance.isMiddleCutout()) {
        cardVm.containerSize = live.card.isOtherCard() ? {
          width: 16,
          height: 16,
        } : {
          width: cardRect.width * containerWidthScale,
          height: cardRect.height * containerHeightScale,
        };
        cardVm.containerOpacity = 0;
      }
      log.showInfo(`Expand ${live.hashCode}, left: ${cardVm.containerOffsetX}, top: ${cardVm.containerOffsetY}`);
    }
  }

  private setExpandFinalState(cardRectList: RectResult[]): void {
    // 在卡片展开前需要列表显示出来
    this.vmInjector.getCardListVm().listOpacity = 1;

    // 设置动画过程中的值
    for (let i = 0; i < cardRectList.length; i++) {
      this.addAnimation(this.getExpandCardAnimation(cardRectList, i));
    }
    LiveCardShowAnimationEventUtil.setLiveCardAnimation(this.VISUAL_EFFECT_DELAY + this.VISUAL_EFFECT_START_DELAY);

    // 设置动画结束后状态
    this.addAnimation([{
      delay: this.EXPAND_CURVE_COMPLETE_TIME + this.EXPAND_ITEM_DELAY * cardRectList.length,
      duration: 1,
      event: () => this.resetCard(false)
    }]);
  }

  /**
   * 获取卡片展开动效
   * @param cardRectList
   * @param i
   * @returns
   */
  private getExpandCardAnimation(cardRectList: RectResult[], i: number): AnimateParams[] {
    const cardVm = this.vmInjector.getCardListItemVm(this.vmInjector.getCardListVm().liveList[i]);
    const cardDelay = this.EXPAND_ITEM_DELAY * (cardRectList.length - i - 1);
    const containerSize: SizeOptions = { width: '100%', height: 'auto' };
    const contentScale: ScaleOptions = { x: 1, y: 1 };
    const opacityDelay = this.getExpandOpacityDelay(cardDelay);
    const backOpacityExpandDelay = cardDelay + this.CARD_BACK_OPACITY_DELAY * (cardRectList.length - i) - 17;

    log.showInfo(`Expand ${i}, offsetDelay: ${cardDelay}, opacityDelay: ${opacityDelay}, backOpacityExpandDelay: ${backOpacityExpandDelay}`);

    const animateParam : AnimateParams[] = [
      {
        curve: this.EXPAND_CURVES,
        delay: cardDelay,
        event: () => {
          cardVm.containerOffsetX = 0;
          cardVm.containerOffsetY = 0;

          cardVm.contentBorderRadius = LiveStyle.CARD_RADIUS;
          cardVm.containerBorderRadius = LiveStyle.CARD_RADIUS;
          cardVm.containerSize = containerSize;
          cardVm.contentScale = contentScale;
        }
      },
      {
        curve: Curve.Linear,
        duration: 183,
        delay: opacityDelay,
        event: () => {
          cardVm.contentOpacity = 1;
          cardVm.cardGradientOpacity = 1
        }
      },
      {
        curve: Curve.Linear,
        duration: 1,
        delay: 280,
        event: () => {
          // 解决expand动效未做完时左滑卡片，菜单显示延时且动效缺失
          cardVm.contentAlign = Alignment.End;
        }
      }
    ];
    if (!CutoutVm.instance.isMiddleCutout()) {
      animateParam.push(
        {
          curve: Curve.Linear,
          duration: this.CARD_BACK_OPACITY_TIME,
          delay: backOpacityExpandDelay,
          event: () => {
            cardVm.cardBackOpacity = 1;
            cardVm.containerOpacity = 1;
          }
        }
      )
    }
    return animateParam;
  }

  /**
   * 展开卡片动画
   * @returns
   */
  public async expandCard(): Promise<void> {
    const cardRectList: RectResult[] = this.getCardRectList();
    // 清理上一次动画的数据
    this.clearAnimations();
    // 设置展开初始态
    this.setExpandInitialState(cardRectList);
    // 设置动画结束状态
    this.setExpandFinalState(cardRectList);
    // 重置列表回弹状态
    this.vmInjector.getCardListVm().isListRebound = false;
    // 启动动画
    await this.startAnimation(`ExpandCard, count:${cardRectList.length}`);
  }

  private setCollapseInitialState(cardRectList: RectResult[]): void {
    const cardListVm = this.vmInjector.getCardListVm();

    for (let i = 0; i < cardRectList.length; i++) {
      const live = cardListVm.liveList[i];
      const cardVm = this.vmInjector.getCardListItemVm(live);

      cardVm.contentAlign = Alignment.TopStart;
      cardVm.contentSize = cardRectList[i];
    }
  }

  private setCollapseFinalState(cardRectList: RectResult[]): void {
    const cardListVm = this.vmInjector.getCardListVm();
    const anchorPosition = this.getAnchorPosition();
    const containerSize: SizeOptions = CutoutVm.instance.isMiddleCutout() ?
      { width: 8, height: 16 } : { width: 16, height: 16 };

    log.info('setCollapseFinalState, anchorPosition: ', anchorPosition);
    for (let i = 0; i < cardRectList.length; i++) {
      const live = cardListVm.liveList[i];
      const cardVm = this.vmInjector.getCardListItemVm(live);
      const cardRect = cardRectList[i];
      const delay = this.COLLAPSE_ITEM_DELAY * i;
      const backOpacityCollapseDelay = delay * 2 + this.COLLAPSE_SIZE_DURATION - 3 * this.CARD_BACK_OPACITY_TIME;

      this.addAnimation([{
        curve: this.EXPAND_CURVES,
        duration: this.COLLAPSE_SIZE_DURATION,
        delay: delay,
        event: () => {
          cardVm.containerBorderRadius = cardRect.height / 2;
          cardVm.contentBorderRadius = cardRect.height / 2;
          cardVm.containerSize = containerSize;
          cardVm.contentScale = {
            x: containerSize.height as number / cardRect.height,
            y: containerSize.height as number / cardRect.height,
          };
          cardVm.containerOffsetX = anchorPosition.x - cardRect.x - (containerSize.width as number) / 2;
          cardVm.containerOffsetX = this.calcEndOffsetX(cardVm, cardVm.containerOffsetX);
          cardVm.containerOffsetY =
            anchorPosition.y - cardRect.y - (containerSize.height as number) / 2 + this.getExtraOffsetY();
          log.showInfo(`Collapse ${live.hashCode}, left: ${cardVm.containerOffsetX}, top: ${cardVm.containerOffsetY}`);
        }
      }, {
        curve: Curve.Linear,
        duration: this.isMultipleMiddleCutout() ? this.MULTIPLE_HOLE_CARD_GRADIENT_TIME :
          this.SINGLE_HOLE_CARD_GRADIENT_TIME,
        delay: delay,
        event: () => {
          cardVm.contentOpacity = 0;
          cardVm.cardGradientOpacity = 0;
        }
      }]);

      if (!CutoutVm.instance.isMiddleCutout()) {
        this.addAnimation([{
          curve: Curve.Linear,
          duration: this.CARD_BACK_OPACITY_TIME,
          delay: backOpacityCollapseDelay,
          event: () => {
            cardVm.cardBackOpacity = 0;
            cardVm.containerOpacity = 0;
          }
        }]);
      }
    }
  }

  public getCollapseCardDuration(): number {
    const cardRectList: RectResult[] = this.getCardRectList();
    const resetDelay = this.COLLAPSE_SIZE_DURATION + this.COLLAPSE_ITEM_DELAY * cardRectList.length;
    log.showInfo(`collapse card duration is ${resetDelay}`);
    return resetDelay;
  }

  /**
   * 收起卡片动画
   * @returns
   */
  public async collapseCard(): Promise<void> {
    const cardRectList: RectResult[] = this.getCardRectList();
    const resetDelay = this.COLLAPSE_SIZE_DURATION + this.COLLAPSE_ITEM_DELAY * cardRectList.length;

    // 清理上一次动画的数据
    this.clearAnimations();
    // 设置动画初始状态
    this.setCollapseInitialState(cardRectList);
    // 设置动画终态
    this.setCollapseFinalState(cardRectList);
    // 动画过程中列表不能滑动
    this.vmInjector.getCardListVm().enableScroll = false;
    // 启动动画
    await Promise.all([
      SystemUICommonUtil.sleep(resetDelay).then(() => this.resetCard(true)),
      this.startAnimation(`CollapseCard, count:${cardRectList.length}`),
    ]);
    this.vmInjector.getCardListVm().enableScroll = true;
  }

  private resetCard(isCollapse: boolean): void {
    const cardListVm = this.vmInjector.getCardListVm();
    const containerSize: SizeOptions = { width: '100%', height: 'auto' };

    log.showInfo(`Reset card, isCollapse: ${isCollapse}`);
    if (isCollapse) {
      cardListVm.listOpacity = 0;
    }
    for (let i = 0; i < cardListVm.liveList.length; i++) {
      const live = cardListVm.liveList[i];
      const cardVm = this.vmInjector.getCardListItemVm(live);

      cardVm.containerSize = containerSize;
      cardVm.contentSize = undefined;
      cardVm.contentScale = undefined;
      cardVm.containerOffsetY = 0;
      cardVm.containerOffsetX = 0;
      cardVm.contentOpacity = isCollapse ? 0 : 1;
      cardVm.containerBorderRadius = LiveStyle.CARD_RADIUS;
      cardVm.contentBorderRadius = LiveStyle.CARD_RADIUS;
      cardVm.cardBackOpacity = isCollapse ? 0 : 1;
      cardVm.contentAlign = Alignment.End;
      cardVm.containerOpacity = 1;
      cardVm.cardGradientOpacity = 1;
      log.showInfo(`Reset card for ${live.hashCode}`);
    }
  }

  private getCardRectList(): RectResult[] {
    const cardListVm = this.vmInjector.getCardListVm();
    const cardRectList: RectResult[] = [];
    for (let i = 0; i < cardListVm.liveList.length; i++) {
      const live = cardListVm.liveList[i];
      const cardVm = this.vmInjector.getCardListItemVm(live);
      const cardRect =
        SystemUICommonUtil.getRect(cardVm.componentId, ArkUIAdapter.getUiContextByViewName(ViewName.BANNER_VIEW));
      log.info(`CardRect ${live.hashCode}:`, cardRect);
      if (cardRect.height) {
        cardRectList.push(cardRect);
      }
    }
    return cardRectList;
  }

  private calcEndOffsetX(cardVm: ILiveCardListItemVm, offsetX: number): number {
    if (ResourceVm.instance.isRTL) {
      if (DeviceInfoVm.instance.orientation !== display.Orientation.PORTRAIT || !CutoutVm.instance.isMiddleCutout()) {
        //镜像语言且非竖屏中挖孔，横幅卡片的出场offsetX = 时间左侧坐标 - 时间右侧距离手机边缘的padding + 容器宽度/2
        cardVm.containerOffsetX = this.vmInjector.getCapsuleListVm().position.left -
        this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace +
          (cardVm.containerSize.width as number) / 2;
        return cardVm.containerOffsetX;
      }
    }
    return offsetX;
  }

  private isMultipleMiddleCutout(): boolean {
    return CutoutVm.instance.isMiddleCutout() && CutoutVm.instance.holeNum > 1;
  }

  protected getExpandOffsetY(anchorPosition: AnchorPosition, cardRect: RectResult, cardVm: ILiveCardListItemVm) {
    // 卡片展开时以融球底部为起始锚点
    return anchorPosition.y * 1.5 - cardRect.y - (cardVm.containerSize.height as number) / 2;
  }

  protected getExtraOffsetY() {
    // 弹簧曲线会导致卡片收回的时候弹出孔，将终点下移5vp
    return 5;
  }

  protected getExpandOpacityDelay(cardDelay: number): number {
    return this.isMultipleMiddleCutout() ? cardDelay + 50 : cardDelay + 17;
  }
}
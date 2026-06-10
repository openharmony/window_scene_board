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

import { Animator, AnimatorResult } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { AnimateParams, AnimationBase } from '../../animation/AnimationBase';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { BannerVm } from '../../vm/BannerVm';
import { DropdownVm } from '../../vm/DropdownVm';
import { ILiveCardOtherProgressVm } from '../interface/ILiveCardOtherProgressVm';
import { LiveCardProgressModel } from '../model/LiveCardProgressModel';
import { LiveIndicatorType, LiveLineType } from '../model/LiveCommonModel';
import { LiveNotification } from '../model/LiveNotification';
import { LiveCardOtherLayoutVm } from './LiveBaseVm';

const TAG = 'LiveCardOtherProgressVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const DOTTED_LINE_SIZE = 4;
const LINE_PADDING = 8;
const INDICATOR_UP_IMAGE_WIDTH = 36;
const HEADS_UP_EXPAND_DELAY = 350; //在竖屏下吐出横幅的延时

interface ProgressDot {
  offset: number;
  isInProgress: boolean;
}

@ObservedV2
export class LiveCardOtherProgressVm extends LiveCardOtherLayoutVm<LiveCardProgressModel>
implements ILiveCardOtherProgressVm {
  @Trace public translateX: number = 0;
  @Trace public dots: ProgressDot[] = [];
  @Trace public dotProgressWidth: number = 0;
  @Trace public lineProgress: number = 0;
  @Trace public indicatorOpacity: number = 1;
  @Trace public isIndicatorShow: boolean = false;
  @Trace public layoutIndicatorType: number = 0;

  /*
   * 获取进度条高度
   */
  @Computed get lineHeight(): number {
    return this.card.layoutLineType === LiveLineType.THICK_SOLID_LINE ? 8 : 4;
  }

  /*
   * 获取进度条颜色
   */
  @Computed get lineColor(): string {
    if (this.card.layoutColor) {
      return this.card.layoutColor;
    }
    return '#317AF7';
  }

  /*
   * 获取进度条背景颜色
   */
  @Computed get lineBackgroundColor(): string {
    if (this.card.layoutBackgroundColor) {
      return this.card.layoutBackgroundColor;
    }
    return '#19FFFFFF';
  }

  protected progressWidth: number = 0;
  protected indicatorOverlayWidth: number = 0;
  private animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.PROGRESS_CARD_ANIMATION);

  public handleLineSizeChange(newSize: SizeOptions): void {
    this.progressWidth = newSize.width as number - LINE_PADDING * 2;
    this.updateProgressWidth();
  }

  public handleIndicatorOverlaySizeChange(newSize: SizeOptions): void {
    this.indicatorOverlayWidth = newSize.width as number;
    this.updateProgressWidth();
  }

  public checkAnimalDelay(): number {
    if (BannerVm.instance.isLiveHeadsUp() && CutoutVm.instance.isMiddleCutout()) {
      return HEADS_UP_EXPAND_DELAY;
    }
    return 0;
  }

  public checkStartAnim(): boolean {
    return BannerVm.instance.isLivePanel() || BannerVm.instance.isLiveHeadsUp();
  }

  public onUpdate(live: LiveNotification): void {
    const oldValue = this.live.card as LiveCardProgressModel;
    const nowValue = live.card as LiveCardProgressModel;
    super.onUpdate(live);
    this.layoutIndicatorType = nowValue?.layoutIndicatorType;

    if (oldValue.isProgressCard() && nowValue.isProgressCard()) {
      if (oldValue?.layoutLineType !== nowValue?.layoutLineType ||
        oldValue?.layoutIndicatorType !== nowValue?.layoutIndicatorType) {
        this.updateProgressWidth();
      }
      if (oldValue?.layoutProgress !== nowValue?.layoutProgress && this.checkStartAnim()) {
        setTimeout(() => {
          this.startProgressAnim(0, 0);
        });
      }
    }
    if (!nowValue.isProgressCard()) {
      this.isIndicatorShow = false;
      this.layoutIndicatorType = 0;
      this.translateX = 0;
      this.dotProgressWidth = 0;
    }
  }

  /**
   * @param delay
   * @param resetType: 0-更新场景，不回归原点，1-下拉场景/卡片展开场景，指示器初始值为上一节点，2-初次创建场景，初始值为0
   * @returns
   */
  public async startProgressAnim(delay: number = 0, resetType: 0 | 1 | 2 = 1): Promise<void> {
    log.info(`startProgressAnim. delay:${delay}, resetType:${resetType}`);
    this.isIndicatorShow = true;
    if (resetType > 0) {
      const progress = resetType === 1 ? this.getInitialProgress() : 0;

      this.layoutIndicatorType = this.card.layoutIndicatorType;
      this.animation.setInitialState(() => {
        this.indicatorOpacity = 0;
        this.translateX = this.getTranslateX(progress);
        this.dotProgressWidth = this.getDotProgressWidth(progress);
        this.lineProgress = progress;
      });
    }

    const animations: AnimateParams[] = [
      {
        duration: 200,
        curve: Curve.Friction,
        delay: delay,
        event: () => {
          this.indicatorOpacity = 1;
        }
      },
      {
        duration: 667,
        curve: Curve.Friction,
        delay: delay,
        event: () => {
          this.translateX = this.getTranslateX();
        }
      },
    ];
    const cmds: Promise<void>[] = [];
    if (this.card.layoutLineType === LiveLineType.DOTTED_LINE) {
      animations.push({
        duration: 667,
        curve: Curve.Friction,
        delay: delay,
        event: () => {
          this.dotProgressWidth = this.getDotProgressWidth();
        }
      });
    } else {
      animations.push({
        duration: 667,
        curve: Curve.Friction,
        delay: delay,
        event: () => {
          this.lineProgress = this.card.layoutProgress;
        }
      })
    }

    cmds.push(this.animation.executeAnimation(animations));

    await Promise.all(cmds);
  }

  protected updateProgressWidth(): void {
    this.translateX = this.getTranslateX();
    this.lineProgress = this.card.layoutProgress;
    this.calcDots();
    this.dotProgressWidth = this.getDotProgressWidth();
  }

  protected getTranslateX(progress?: number): number {
    let offsetLeft = (progress ?? this.card.layoutProgress) / 100 * this.progressWidth + LINE_PADDING;
    if (this.card.layoutIndicatorType === LiveIndicatorType.UP) {
      offsetLeft -= INDICATOR_UP_IMAGE_WIDTH / 2;
      // 最左边不能超过线条的LINE_PADDING
      const minOffsetLeft = -LINE_PADDING;
      // 最右边不能大于右侧线条的位置
      const maxOffsetLeft = this.progressWidth + LINE_PADDING * 3 - INDICATOR_UP_IMAGE_WIDTH;
      offsetLeft = Math.min(Math.max(offsetLeft, minOffsetLeft), maxOffsetLeft);
    } else if (this.card.layoutIndicatorType === LiveIndicatorType.OVERLAY) {
      offsetLeft -= this.indicatorOverlayWidth / 2;
      // 最左边不能超过线条的LINE_PADDING
      const minOffsetLeft = -LINE_PADDING;
      // 最右边不能大于右侧线条的位置
      const maxOffsetLeft = this.progressWidth + LINE_PADDING * 3 - this.indicatorOverlayWidth;
      offsetLeft = Math.min(Math.max(offsetLeft, minOffsetLeft), maxOffsetLeft);
    }
    log.showInfo(`TranslateX: ${offsetLeft}, progressWidth: ${this.progressWidth}, ` +
      `progress: ${progress ?? this.card?.layoutProgress}`);
    return offsetLeft;
  }

  protected getDotProgressWidth(progress?: number): number {
    let offsetLeft = (progress ?? this.card.layoutProgress) / 100 * this.progressWidth;

    for (const dot of this.dots) {
      const offsetWidth = dot.offset + DOTTED_LINE_SIZE;
      if (offsetLeft > dot.offset && offsetLeft < offsetWidth) {
        offsetLeft = offsetWidth;
        break;
      }
    }

    return offsetLeft;
  }

  protected calcDots(): void {
    if (this.card.layoutLineType !== LiveLineType.DOTTED_LINE) {
      return;
    }
    // 中间节点的数量
    const middleNodeCount = Math.max(0, (this.card.layoutNodeIcons?.length ?? 0) - 2);
    // 每个节点占用点数量
    const dotCountOfNode = 3;
    // 空隙和点的总数量
    const totalCount = this.progressWidth / DOTTED_LINE_SIZE;
    // 预计点数量，先按照均分的方式计算，然后再修正
    let dotCount = Math.ceil((totalCount + 1) / 2);
    // 间隔距离
    let space = 0;

    // 逐步增加节点的数量直到满足上述条件
    while (dotCount < totalCount) {
      space = (this.progressWidth - dotCount * DOTTED_LINE_SIZE) / (dotCount - 1);
      // 判断是否满足条件2和3，满足则退出
      if (space <= DOTTED_LINE_SIZE &&
        (dotCount - dotCountOfNode * 2 - middleNodeCount * dotCountOfNode) % (middleNodeCount + 1) === 0) {
        break;
      }
      dotCount++;
    }
    const processOffset = this.card.layoutProgress / 100 * this.progressWidth;
    this.dots = [];

    for (let i = 0; i < dotCount; i++) {
      const offset = i * (DOTTED_LINE_SIZE + space);
      const isInProgress = offset <= processOffset;
      this.dots.push({
        offset,
        isInProgress
      });
    }

    log.showInfo(`calcDots. dotCount:${dotCount}`);
  }

  protected getInitialProgress(): number {
    const progress = this.card.layoutProgress;
    const middleNodeCount = Math.max(0, (this.card.layoutNodeIcons?.length ?? 0) - 2);
    const interval = 100 / (middleNodeCount + 1);
    let result = 0;

    while (result < progress) {
      if ((result + interval) >= progress) {
        break;
      }
      result += interval;
    }

    return result;
  }

  public isLayoutIndicatorTypeUp(): boolean {
    const data = this.live.card as LiveCardProgressModel;
    return data.layoutIndicatorType === LiveIndicatorType.UP || this.layoutIndicatorType === LiveIndicatorType.UP;
  }

  public isLayoutIndicatorTypeOverlay(): boolean {
    const data = this.live.card as LiveCardProgressModel;
    return data.layoutIndicatorType === LiveIndicatorType.OVERLAY ||
      this.layoutIndicatorType === LiveIndicatorType.OVERLAY;
  }
}
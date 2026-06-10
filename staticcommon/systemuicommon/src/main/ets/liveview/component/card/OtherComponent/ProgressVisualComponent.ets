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

import { LiveProgressTemplate } from '../../../data/template/LiveProgressTemplate';
import { CardUtils } from '../LiveViewCardData';
import { IndicatorType, LineType, LiveUseScene } from '../../../common/LiveConstants';
import { LiveButtonData } from '../../../data/extend/LiveButtonData';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { RTLUtil } from '@ohos/componenthelper';
import { DarkModeState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { immersiveKgMgr } from '../../../../immersivekeyguardcommon/manager/ImmersiveKeyguardStateManager';
import { NotificationType } from '../../../../constants/NotificationType';
import { LengthMetrics } from '@ohos.arkui.node';
import { ProgressCardAnimVm } from '../../vm/ProgressCardAnimVm';
import { SystemUICommonUtil } from '../../../../utils/SystemUICommonUtil';

const log = LogHelper.getLogHelper(LogDomain.SYS_UI, 'ProgressVisualComponent');
const INDICATOR_COVERAGE_IMAGE_WIDTH = 64;
const INDICATOR_COVERAGE_IMAGE_HEIGHT = 56;
const INDICATOR_UP_IMAGE_WIDTH = 36;
const SMALL_FOLD_OUTER_SCREEN_INDICATOR_UP_IMAGE_WIDTH = 22;
const DOTTED_LINE_SIZE = 4;
const SMALL_FOLD_OUTER_SCREEN_DOTTED_LINE_SIZE = 3.2;
// 进度线条向内缩进的距离，解决无节点图标时指示器对不准线条开始和结束点的问题
const LINE_PADDING = 8;
const SMALL_FOLD_OUTER_SCREEN_INDICATOR_PADDING = 16;
const DARK_BGCOLOR = '#19FFFFFF';
const LIGHT_BGCOLOR = '#19000000';
const SMALL_FOLD_OUTER_SCREEN_BTN_ICON_WIDTH = 17;

interface ProgressDot {
  offset: number;
  isInProgress: boolean;
}

/**
 * 扩展区为进度可视化模板：比如即时配送
 */
@Component
export struct ProgressVisualComponent {
  @ObjectLink @Watch('updateProgressData') data: LiveProgressTemplate;
  private isDarkMode?: boolean;
  @State darkModeState: DarkModeState = baseStateMgr.getBaseState(StateType.TYPE_DARK_MODE) as DarkModeState;
  /**
   * 通知面板类型
   */
  @Consume notificationType: number;

  /**
   * 进度条总宽度
   */
  public progressWidth: number = 0;
  /**
   * 虚线坐标点横坐标集合
   */
  @State public dots: ProgressDot[] = [];

  @State public dotsColors: string[] = [];
  /**
   * 覆盖型指标图片的宽度
   */
  @State private coverageImageWidth: number = 0;

  @State private progressCardAnimVm: ProgressCardAnimVm = new ProgressCardAnimVm();
  @Prop isSmallFoldOuterScreen: boolean = false;

  private stackPadding: Length = 12;

  private currentProgress: number = 0;

  private hashcode: string = '';

  private useScene: LiveUseScene = LiveUseScene.SCENE_LIVE_LIST;

  private debounceUpdateFn?: () => void;

  aboutToAppear(): void {
    this.currentProgress = this.getProgress();
    this.progressCardAnimVm.init(this.hashcode, this.useScene, this);

    // 注册更新防抖函数
    this.debounceUpdateFn = SystemUICommonUtil.debouncePromise(async () => {
      if (this.currentProgress !== this.getProgress() && this.useScene !== LiveUseScene.SCENE_IMMERSIVE_CARD) {
        this.progressCardAnimVm.setAnimation(this.currentProgress, 0, false);
        this.currentProgress = this.getProgress();
        if (this.isSmallFoldOuterScreen) {
          this.smallFoldOuterScreenCalcDots();
        } else {
          this.calcDots();
        }
        this.progressCardAnimVm.startAnimation();
      } else {
        if (this.progressCardAnimVm.progressTranXAnimPromise) {
          await this.progressCardAnimVm.progressTranXAnimPromise;
        }
        this.updateProgressWidth();
      }
    });
  }

  aboutToDisappear(): void {
    this.progressCardAnimVm.destroy();
  }

  build() {
    if (this.data) {
      Stack({ alignContent: Alignment.BottomStart }) {
        this.constructProgress()
        if (this.data.indicatorType === IndicatorType.UP_PROGRESS_LINE) {
          this.constructIndicatorUp()
        } else if (this.data.indicatorType === IndicatorType.COVERAGE_PROGRESS) {
          this.constructIndicatorCoverage()
        }
      }
      .height(this.isSmallFoldOuterScreen ? 46 : 72)
      .width('100%')
      .opacity(undefined)
      .padding(this.isSmallFoldOuterScreen ? undefined : {
        left: this.stackPadding,
        right: this.stackPadding,
        bottom: this.data.indicatorType === IndicatorType.UP_PROGRESS_LINE ? 12 : 20
      })
    }
  }

  @Builder
  constructIndicatorUp() {
    Stack({ alignContent: Alignment.Top }) {
      Image($r('app.media.bubble_tips'))
        .draggable(false)
        .width('100%')
      Image(this.data?.indicatorIcon)
        .width(this.isSmallFoldOuterScreen ? 20 : 32)
        .height(this.isSmallFoldOuterScreen ? 20 : 32)
        .margin(this.isSmallFoldOuterScreen ? { top: 1 } : { top: 2 })
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .borderRadius(this.isSmallFoldOuterScreen ? 10 : 16)
        .visibility(this.data?.indicatorIcon ? Visibility.Visible : Visibility.Hidden)
    }
    .width(this.isSmallFoldOuterScreen ? SMALL_FOLD_OUTER_SCREEN_INDICATOR_UP_IMAGE_WIDTH : INDICATOR_UP_IMAGE_WIDTH)
    .height(this.isSmallFoldOuterScreen ? 25 : 40)
    .margin({ bottom: LengthMetrics.vp(this.isSmallFoldOuterScreen ? 16 : 20) })
    .offset({ start: LengthMetrics.vp(this.progressCardAnimVm.translateX) })
    .opacity(this.progressCardAnimVm.opacity)
  }

  @Builder
  constructIndicatorCoverage() {
    Image(this.data?.indicatorIcon)
      .width(INDICATOR_COVERAGE_IMAGE_WIDTH)
      .height(INDICATOR_COVERAGE_IMAGE_HEIGHT)
      .objectFit(ImageFit.Contain)
      .draggable(false)
      .interpolation(ImageInterpolation.Medium)
      .offset({ start: LengthMetrics.vp(this.progressCardAnimVm.translateX) })
      .opacity(this.progressCardAnimVm.opacity)
      .onSizeChange((_, newSize) => {
        if (newSize.width) {
          this.coverageImageWidth = newSize.width as number;
          this.updateProgressWidth();
        }
      })
      .visibility(this.data?.indicatorIcon ? Visibility.Visible : Visibility.Hidden)
  }

  @Builder
  constructProgress() {
    Stack({ alignContent: Alignment.Center }) {
      this.constructLine()
      this.constructNodes()
    }
    .width('100%')
    .height(this.isSmallFoldOuterScreen ? 16 : 20)
  }

  @Builder
  constructLine() {
    Stack({ alignContent: Alignment.Start }) {
      if (this.data.lineType === LineType.DOTTED_PROGRESS) {
        ForEach(this.dots, (dot: ProgressDot, index: number) => {
          Row()
            .width(this.isSmallFoldOuterScreen ? SMALL_FOLD_OUTER_SCREEN_DOTTED_LINE_SIZE : DOTTED_LINE_SIZE)
            .height(this.isSmallFoldOuterScreen ? SMALL_FOLD_OUTER_SCREEN_DOTTED_LINE_SIZE : DOTTED_LINE_SIZE)
            .borderRadius(this.isSmallFoldOuterScreen ? SMALL_FOLD_OUTER_SCREEN_DOTTED_LINE_SIZE / 2 :
              DOTTED_LINE_SIZE / 2)
            .backgroundColor(this.dotsColors[index])
            .offset({ x: dot.offset * (RTLUtil.isRTL() ? -1 : 1) })
        })
      } else {
        Line()
          .width('100%')
          .height(this.getLineHeight())
          .backgroundColor(this.getLineBackgroundColor())
          .borderRadius(this.getLineHeight() / 2)
        Line()
          .width(`${this.progressCardAnimVm.lineWidth}%`)
          .height(this.getLineHeight())
          .backgroundColor(this.getLineColor())
          .borderRadius(this.getLineHeight() / 2)
      }
    }
    .width('100%')
    // 进度条内缩一点点，避免指示器中心点对准问题
    .padding({ left: LINE_PADDING, right: LINE_PADDING })
    .onSizeChange((_, newSize) => {
      if (newSize.width) {
        if (this.useScene === LiveUseScene.SCENE_IMMERSIVE_CARD) {
          setTimeout(() => {
            this.handleSizeChange(newSize);
          }, 0);
        } else {
          this.handleSizeChange(newSize);
        }
      }
    })
  }

  private handleSizeChange(newSize: SizeOptions): void {
    this.progressWidth = newSize.width as number - LINE_PADDING * 2;
    this.updateProgressWidth();
  }

  @Builder
  constructNodes() {
    Row() {
      ForEach((this.data.nodeIcons), (nodeIcon: LiveButtonData) => {
        Image(nodeIcon.getButtonIcon())
          .width(this.isSmallFoldOuterScreen ? SMALL_FOLD_OUTER_SCREEN_BTN_ICON_WIDTH : 20)
          .height(this.isSmallFoldOuterScreen ? SMALL_FOLD_OUTER_SCREEN_BTN_ICON_WIDTH : 20)
          .objectFit(ImageFit.Contain)
          .syncLoad(true)
          .draggable(false)
          .borderRadius(this.isSmallFoldOuterScreen ? SMALL_FOLD_OUTER_SCREEN_BTN_ICON_WIDTH / 2 : 10)
          .interpolation(ImageInterpolation.Medium)
      }, (nodeIcon: LiveButtonData) => nodeIcon.hashCode + '_' + nodeIcon.iconKey)
    }
    .zIndex(1)
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  public getIndicatorLeft(progress?: number): number {
    let paddingWidth = this.isSmallFoldOuterScreen ? SMALL_FOLD_OUTER_SCREEN_INDICATOR_PADDING : LINE_PADDING;
    let offsetLeft = (progress ?? this.getProgress()) / 100 * this.progressWidth + paddingWidth;
    if (this.data.indicatorType === IndicatorType.UP_PROGRESS_LINE) {
      offsetLeft -= INDICATOR_UP_IMAGE_WIDTH / 2;
      // 最左边不能超过线条的LINE_PADDING
      const minOffsetLeft = -paddingWidth;
      // 最右边不能大于右侧线条的位置
      const maxOffsetLeft = this.progressWidth + paddingWidth * 3 - INDICATOR_UP_IMAGE_WIDTH;
      offsetLeft = Math.min(Math.max(offsetLeft, minOffsetLeft), maxOffsetLeft);
    } else if (this.data.indicatorType === IndicatorType.COVERAGE_PROGRESS) {
      offsetLeft -= this.coverageImageWidth / 2;
      // 最左边不能超过线条的LINE_PADDING
      const minOffsetLeft = -paddingWidth;
      // 最右边不能大于右侧线条的位置
      const maxOffsetLeft = this.progressWidth + paddingWidth * 3 - this.coverageImageWidth;
      offsetLeft = Math.min(Math.max(offsetLeft, minOffsetLeft), maxOffsetLeft);
    }
    return offsetLeft;
  }

  public getLineBackgroundColor(): string {
    if (this.data.backgroundColor) {
      return this.data.backgroundColor;
    }
    return this.darkModeState.isDarkMode ? DARK_BGCOLOR : LIGHT_BGCOLOR;
  }

  public getLineColor(): string {
    if (this.data.color) {
      return this.data.color;
    }
    return '#317AF7';
  }

  private getLineHeight(): number {
    return this.data.lineType === LineType.THICK_SOLID_LINE_PROGRESS ? 8 : 4;
  }

  public getProgress(): number {
    return Math.min(this.data.progress ?? 0, CardUtils.MAX_PROGRESS);
  }

  /**
   * 计算进度点的分布，条件如下：
   * 1、要求将其拆分为N个长度为4的点
   * 2、点与点之间的间隙越接近4越好，但不能大于4，数量为N-1
   * 3、点的数量要满足正好被图标节点占满三个点（图标是均匀分布的）
   */
  private calcDots(progress?: number): void {
    if (this.data?.lineType !== LineType.DOTTED_PROGRESS) {
      return;
    }
    // 中间节点的数量
    const middleNodeCount = Math.max(0, (this.data?.nodeIcons?.length ?? 0) - 2);
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
    const processOffset = (progress ?? this.getProgress()) / 100 * this.progressWidth;
    const color = this.getLineColor();
    const backgroundColor = this.getLineBackgroundColor();
    this.dots = [];
    this.dotsColors = [];
    for (let i = 0; i < dotCount; i++) {
      const offset = i * (DOTTED_LINE_SIZE + space);
      const isInProgress = offset <= processOffset;
      this.dots.push({
        offset,
        isInProgress
      });
      this.dotsColors.push(isInProgress ? color : backgroundColor)
    }
  }

  /**
   * 计算小外屏进度点的分布，条件如下：
   * 1、要求将其拆分为N个长度为3.2的点
   * 2、点与点之间的间隙为3.2
   * 3、点的数量要满足正好被图标节点占满三个点（图标是均匀分布的）
   */
  private smallFoldOuterScreenCalcDots(progress?: number): void {
    if (this.data?.lineType !== LineType.DOTTED_PROGRESS) {
      return;
    }
    // 预计点数量，先按照均分的方式计算，然后再修正
    let dotCount = Math.ceil((this.progressWidth + SMALL_FOLD_OUTER_SCREEN_DOTTED_LINE_SIZE) /
      (SMALL_FOLD_OUTER_SCREEN_DOTTED_LINE_SIZE * 2));
    // 小外屏点间隔距离
    let smallFoldOuterScreenSpace = SMALL_FOLD_OUTER_SCREEN_DOTTED_LINE_SIZE;
    // 小外屏点固定偏移距离
    let fixedOffset = -SMALL_FOLD_OUTER_SCREEN_DOTTED_LINE_SIZE / 2;
    const processOffset = (progress ?? this.getProgress()) / 100 * this.progressWidth;
    const color = this.getLineColor();
    const backgroundColor = this.getLineBackgroundColor();
    this.dots = [];
    this.dotsColors = [];
    for (let i = 0; i < dotCount; i++) {
      const offset = i * (SMALL_FOLD_OUTER_SCREEN_DOTTED_LINE_SIZE + smallFoldOuterScreenSpace) + fixedOffset;
      const isInProgress = offset <= processOffset;
      this.dots.push({
        offset,
        isInProgress
      });
      this.dotsColors.push(isInProgress ? color : backgroundColor)
    }
  }

  private updateProgressWidth() {
    const xValue = this.getIndicatorLeft();
    if (this.progressCardAnimVm.translateX !== xValue) {
      this.progressCardAnimVm.translateX = xValue;
    }
    this.progressCardAnimVm.lineWidth = Math.min(this.data.progress ?? 0, 100).toString();
    this.calDotsLayout()
  }

  private updateProgressData() {
    this.debounceUpdateFn?.();
  }

  private calDotsLayout() {
    if (this.isSmallFoldOuterScreen) {
      this.smallFoldOuterScreenCalcDots();
    } else {
      this.calcDots();
    }
  }
}
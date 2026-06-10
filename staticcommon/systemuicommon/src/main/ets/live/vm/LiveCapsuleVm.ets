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

import { LiveItemBaseVm } from './LiveBaseVm';
import { ILiveCapsuleVm } from '../interface/ILiveCapsuleVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveStyle } from '../constants/LiveStyle';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { CapsuleShowType, LiveType } from '../model/LiveCommonModel';
import { EnvVm } from '../../vm/EnvVm';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { ClickNotificationMaintenance } from '../../maintenance/ClickNotificationMaintenance';
import { ClickRegion } from '../../maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../sysEvent/LiveHiSysEvent';
import { StackIconStyle } from './LiveCapsuleListLayoutBaseVm';
import { LiveCardScoreModel } from '../model/LiveCardScoreModel';
import { LiveNotification } from '../model/LiveNotification';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { ShowStage } from '../interface/ILiveCapsuleFaceLockVm';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';
import { LottieCapsuleViewNode } from '../view/LottieCapsuleView';

const TAG = 'LiveCapsuleVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

@ObservedV2
export class LiveCapsuleVm extends LiveItemBaseVm implements ILiveCapsuleVm {
  public readonly componentId: string = this.vmInjector.getId(`${TAG}_${this.live.hashCode}`);
  public readonly appearPromise = new CustomPromise<void>();
  public fixedShowType: CapsuleShowType = CapsuleShowType.NONE;
  @Trace public showType: CapsuleShowType = CapsuleShowType.NONE;
  @Trace public width: number = LiveStyle.CAPSULE_CIRCLE_WIDTH;
  @Trace public height: number = LiveStyle.CAPSULE_HEIGHT;
  @Trace public capsuleCircleWidth: number = LiveStyle.CAPSULE_CIRCLE_WIDTH;
  @Trace public capsuleIconWidth: number = LiveStyle.CAPSULE_ICON_WIDTH;
  @Trace public capsuleShadowHeight: number = LiveStyle.CAPSULE_SHADOW_HEIGHT;
  @Trace public shadowBorderRadius: number = LiveStyle.CAPSULE_SHADOW_HEIGHT / 2;
  @Trace public shadowClipBorderRadius: number = LiveStyle.CAPSULE_HEIGHT / 2;
  @Trace public distanceBetweenShadowAndOutside: number = LiveStyle.SHADOW_CAPSULE_WIDTH;
  @Trace public opacity = 0;
  @Trace public offsetX = 0;
  @Trace public offsetY = 0;
  @Trace public backgroundColor?: ResourceColor | undefined;
  @Trace public blur = 0;
  @Trace public scaleX = 1;
  @Trace public scaleY = 1;
  @Trace public zIndex = LiveStyle.CAPSULE_LOW_INDEX;
  @Trace public disableOutline = false;
  @Trace public buttonOpacity = 1;
  /**
   * 非挂孔的圆饼胶囊要显示底板色
   */
  @Trace public isCakeShow = false;
  /**
   * 胶囊是否超时未更新
   */
  @Trace public isTimeout: boolean = false;
  @Trace public isShowCapsuleIcon: boolean = true;
  @Trace public fixedWidth: number = 0;
  public isOutOfTime = false;
  public fixedOffsetX: number = 0;
  public isShow: boolean = false;
  public isVisible: boolean = false;
  public isToDelete: boolean = false;
  @Trace public iconWidth = LiveStyle.CAPSULE_ICON_SIZE;
  public iconMarginLeft = LiveStyle.CAPSULE_ICON_MARGIN;
  public iconMarginRight = 0;
  public isShowed = false;
  public isRemindShow = false;
  @Trace public isLayoutSupportExtendShow: boolean = false;
  @Trace public isImmersive: boolean = false;
  @Trace public contentOpacity = 1;
  @Trace public contentScaleX = 1;
  @Trace public contentScaleY = 1;
  @Trace public isShowRightIcon = false;
  @Trace public stackIconMargin: number = StackIconStyle.STACK_ICON_MAX_MARGIN;
  @Trace public fixedIsShowRightIcon: boolean = false;
  @Trace public separatorWidth: number = 6;
  public shouldRunnMarquee: boolean = false;
  public fixedIsLayoutSupportExtendShow: boolean = false;
  public isFirstShowed: boolean = false;
  public faceLockLottieNode?: LottieCapsuleViewNode;

  @Trace public linearGradientSingleEndWidth: number = 0;
  @Trace public linearGradientSingleEndColors: Array<[ResourceColor, number]> = [
    ['rgba(0, 0, 0, 1)', 0],
    ['rgba(0, 0, 0, 1)', 1]
  ];
  @Trace public linearGradientDoubleEndWidth: number = 0;
  @Trace public linearGradientDoubleEndColors: Array<[ResourceColor, number]> = [
    ['rgba(0, 0, 0, 1)', 0],
    ['rgba(0, 0, 0, 1)', 1]
  ];

  /**
   * 判断是否是即时任务类、临时抢占态布局
   * @returns
   */
  public get isTempDisplay(): boolean {
    return this.live.type === LiveType.INSTANT;
  }

  @Computed
  public get contentColor(): ResourceColor | undefined {
    if (this.isTempDisplay) {
      return undefined;
    }
    return this.live.capsule?.backgroundColor ?? LiveStyle.CAPSULE_CONTENT_COLOR;
  }

  @Computed
  public get containerColor(): ResourceColor | undefined {
    if (this.isTempDisplay) {
      return undefined;
    }
    if (this.showType === CapsuleShowType.SHADOW) {
      return LiveStyle.CAPSULE_SHADOW_COLOR;
    }
    // 展开态的胶囊，主题色和容器的颜色一致
    // 圆饼，容器颜色是12%的透明黑色
    if (!this.isCakeShow) {
      return this.live.capsule?.backgroundColor ? this.live.capsule?.backgroundColor : LiveStyle.CAPSULE_CONTENT_COLOR;
    }
    return LiveStyle.CAPSULE_CONTAINER_COLOR;
  }

  @Computed
  public get icon() {
    if (this.isScoreScene()) {
      return (this.live.card as LiveCardScoreModel).layoutHostIcon;
    }
    return this.live.capsule?.icon ?? this.live.appIcon;
  }

  @Computed
  public get button() {
    return this.live.capsule?.button;
  }

  @Computed
  public get rightIcon() {
    if (this.isScoreScene()) {
      return (this.live.card as LiveCardScoreModel).layoutGuestIcon;
    } else if (this.live.capsule?.isTailIconDisplayed) {
      return this.live.capsule.tailIcon;
    }
    return undefined;
  }

  @Computed
  public get isNeedSeparator(): boolean {
    if (this.isScoreScene() &&
      (this.showType === CapsuleShowType.HANGING_HOLE || this.showType === CapsuleShowType.TOP ||
        this.showType === CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE)) {
      return true;
    }
    return false;
  }

  @Computed
  public get isStackIcons(): boolean {
    if (this.isScoreScene() && this.showType === CapsuleShowType.HANGING_HOLE) {
      return true;
    }
    return false;
  }

  @Computed
  public get buttonIcon() {
    return EnvVm.instance.isDarkMode ? this.button?.darkIcon : this.button?.lightIcon;
  }

  @Computed
  public get isShowProgress(): boolean {
    if (this.live.isCharge() && this.live.capsule?.isProgress()) {
      return true;
    }
    return false;
  }

  @Computed
  public get capsuleMarqueeSpace(): number {
    if (this.showType === CapsuleShowType.HANGING_HOLE) {
      // 赛事比分场景主副文本间隔用组件替代
      if (this.isScoreScene()) {
        return 0;
      }
      return LiveStyle.HANGING_CAPSULE_TEXT_MARGIN;
    } else if (this.showType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      // 两端挂孔胶囊跑马灯space等于融球宽度+左右各4vp冗余(定制设备为左右各1vp冗余)
      return this.vmInjector.getCapsuleListVm().position.width + (DeviceInfoVm.instance.isCustomDevice ? 2 : 8);
    } else {
      // 赛事比分场景主副文本间隔用组件替代
      if (this.isScoreScene()) {
        return 0;
      }
      return LiveStyle.CAPSULE_TEXT_MARGIN;
    }
  }

  public get totalTextWidth(): number {
    const marqueeVm = this.vmInjector.getCapsuleMarqueeVm(this.live);
    if (marqueeVm.isExtendShow && marqueeVm.extendTextWidth !== 0) {
      return marqueeVm.textWidth + marqueeVm.extendTextWidth +
        (this.capsuleMarqueeSpace === 0 ? this.separatorWidth : this.capsuleMarqueeSpace)
    }
    return marqueeVm.textWidth;
  }

  @Computed
  public get capsuleTextMarginStart(): number {
    if (!this.isShowCapsuleIcon && this.showType !== CapsuleShowType.HANGING_HOLE) {
      return LiveStyle.CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING;
    }

    return LiveStyle.CAPSULE_ICON_TEXT_MARGIN_START + this.vmInjector.getCapsuleMarqueeVm(this.live).offsetX;
  }

  @Computed
  public get capsuleTextMarginEnd(): number {
    if (!this.isShowCapsuleIcon && this.showType !== CapsuleShowType.HANGING_HOLE) {
      return LiveStyle.CAPSULE_ICON_TEXT_MARGIN_START;
    }

    let capsuleTextMarginEnd: number = LiveStyle.CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING;
    switch (this.showType) {
      case CapsuleShowType.HANGING_HOLE:
        if (this.isShowCapsuleIcon) {
          capsuleTextMarginEnd = this.button ? LiveStyle.HANGING_CAPSULE_TEXT_MARGIN :
            (LiveStyle.HANGING_CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING);
          if (this.live.card?.isScoreCard() && this.live.capsule?.isText()) {
            capsuleTextMarginEnd = LiveStyle.HANGING_CAPSULE_TEXT_MARGIN;
          }
        } else {
          capsuleTextMarginEnd = LiveStyle.HANGING_CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING;
        }
        break;

      default:
        capsuleTextMarginEnd = LiveStyle.CAPSULE_TEXT_MARGIN - LiveStyle.CAPSULE_ICON_PADDING;
        break;
    }
    return capsuleTextMarginEnd;
  }

  @Computed
  public get capsuleHeight(): number {
    return this.showType === CapsuleShowType.SHADOW ? this.capsuleShadowHeight :
      (this.showType !== CapsuleShowType.HANGING_HOLE &&
        this.showType !== CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) ? this.capsuleCircleWidth : this.height;
  }

  @Computed
  public get capsuleIconWidthPx(): number {
    const capsuleIconWidthPx = Math.round(ArkUIAdapter.vp2px(this.capsuleIconWidth));
    log.showInfo(`capsuleHeight = ${this.capsuleHeight}, capsuleIconWidthPx = ${capsuleIconWidthPx}`);
    if ((Math.round(ArkUIAdapter.vp2px(this.capsuleHeight)) - capsuleIconWidthPx) % 2 !== 0) {
      return capsuleIconWidthPx - 1;
    }
    return  capsuleIconWidthPx;
  }

  @Computed
  public get capsulePadding(): number {
    if (this.showType === CapsuleShowType.ROUND_CAKE) {
      return (Math.round(ArkUIAdapter.vp2px(this.capsuleHeight)) - this.capsuleIconWidthPx) / 2;
    }
    return Math.round(ArkUIAdapter.vp2px(LiveStyle.CAPSULE_ICON_PADDING));
  }

  public getButtonAccessibilityText(): string {
    return this.button?.accessibilityText ?? '';
  }

  public onClick = (): void => {
    if (!this.isShow) {
      log.showWarn(`Capsule ${this.live.hashCode} is not show for click`);
      return;
    }
    if (EnvVm.instance.isScreenOff) {
      log.showInfo('screen is off, click return');
      return;
    }
    if (this.live.isInstant()) {
      log.showWarn(`Capsule ${this.live.hashCode} is instant, could not click`);
      return;
    }
    if(this.vmInjector.getLiveHeadsUpVm().isHiding){
      log.showWarn(`Capsule ${this.live.hashCode} is hidding, could not click`);
      return;
    }
    log.showWarn(`Click for ${this.live.hashCode},` +
      ` live list num = ${this.vmInjector.getCapsuleListVm().liveList.length}`);
    this.vmInjector.getSwitchVm().expandCapsuleToCard();
  };
  public onClickButton = (): void => {
    if (!this.button) {
      log.showError(`No capsule button for ${this.live.hashCode}`);
      return;
    }
    if (!this.isShow) {
      log.showWarn(`Capsule ${this.live.hashCode} is not show for click button`);
      return;
    }
    ClickNotificationMaintenance.saveInfo({
      data: this.live,
      clickRegion: ClickRegion.CAPSULE_BUTTON,
      buttonName: this.button.name,
    });
    this.vmInjector.getStarterVm().triggerButton(this.live, this.button);
    if (this.live.isScreenRecorder()) {
      log.showWarn(`click botton for screenRecord capsule`);
      LiveHiSysEvent.reportRecordCapsuleClickEvent(this.live);
    }
  };

  public getRect(): RectResult {
    const left = this.vmInjector.getCapsuleListVm().position?.left ?? 0;
    const top = this.vmInjector.getCapsuleListVm().position?.top ?? 0;
    return {
      x: left + this.offsetX,
      y: top,
      width: this.width || this.capsuleCircleWidth,
      height: this.height,
    };
  }

  public setCakeShowVal(): void {
    this.isCakeShow = false;
    if (this.showType === CapsuleShowType.ROUND_CAKE || this.showType === CapsuleShowType.RIGHT_HOLE ||
      this.showType === CapsuleShowType.LEFT_HOLE) {
      this.isCakeShow = true;
    }
  }

  public updateLinearGradient(): void {
    const capsulePositionWidth = this.vmInjector.getCapsuleListVm().position.width;
    if (this.fixedShowType === CapsuleShowType.HANGING_HOLE) {
      const holeLeft = 1 - capsulePositionWidth / this.fixedWidth;

      // 单侧宽度>104边缘透明度为75%，否则为70%
      const edgeColor = this.fixedWidth - capsulePositionWidth > 104 ?
        'rgba(0, 0, 0, 0.75)' : 'rgba(0, 0, 0, 0.7)';
      this.linearGradientSingleEndColors = [
        [edgeColor, 0],
        ['rgba(0, 0, 0, 1)', holeLeft],
        ['rgba(0, 0, 0, 1)', 1],
      ];
      this.linearGradientSingleEndWidth = this.fixedWidth;
      return;
    }

    if (this.fixedShowType === CapsuleShowType.HANGING_HOLE_DOUBLE_ENDED) {
      const holeLeft = 1 - (this.fixedWidth + this.fixedOffsetX) / this.fixedWidth;
      const holeRight =
        1 - (this.fixedWidth + this.fixedOffsetX - capsulePositionWidth) / this.fixedWidth;

      const edgeColor = this.fixedWidth + this.fixedOffsetX - capsulePositionWidth > 104 ?
        'rgba(0, 0, 0, 0.75)' : 'rgba(0, 0, 0, 0.7)';
      this.linearGradientDoubleEndColors = [
        [edgeColor, 0],
        ['rgba(0, 0, 0, 1)', holeLeft],
        ['rgba(0, 0, 0, 1)', holeRight],
        [edgeColor, 1],
      ];
      this.linearGradientDoubleEndWidth = this.fixedWidth;
    }
  }

  public isScoreScene(live?: LiveNotification): boolean {
    const currentLive = live ?? this.live;
    if (currentLive.card?.isScoreCard() && currentLive.capsule?.isText() &&
    /^\d+:\d+$/.test(currentLive.capsule?.title)) {
      return true;
    }
    return false;
  }

  public setCapsuleOpacity(needShow?: boolean): void {
    if (!this.isFirstShowed && this.live.isFaceLock() &&
      this.vmInjector.getLiveCapsuleFaceLockVm(this.live).showStage === ShowStage.SHOW &&
      !CutoutVm.instance.isMiddleCutout()) {
      log.showInfo(`set capsule opactiy to zero`)
      this.opacity = 0;
    }
    if (needShow) {
      this.opacity = 1;
    }
    this.isFirstShowed = true;
  }
}
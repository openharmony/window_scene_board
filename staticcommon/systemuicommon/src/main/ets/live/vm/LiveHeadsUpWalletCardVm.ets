/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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
import { ILiveHeadsUpWalletCardVm } from '../interface/ILiveHeadsUpWalletCardVm';
import { LiveBaseVm } from './LiveBaseVm';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveNotification } from '../model/LiveNotification';
import {
  ImageInfo,
  NoAnchorPointOverallPageLayOutInfo,
  OverlayBoxInfo,
  RadioInfo,
  TextInfo
} from '../model/LiveCardWalletStatusInfoVm';
import { LiveCardSystemModel } from '../model/LiveCardSystemModel';
import { LiveHeadsUpWalletAnimation } from '../animation/LiveHeadsUpWalletAnimation';
import { AnimatorResult } from '@kit.ArkUI';
import { DeviceInfoVm } from '../../vm/DeviceInfoVm';
import { CutoutVm } from '../../statusbar/vm/CutoutVm';
import { LiveVmInjector } from '../LiveVmInjector';
import { ResourceVm } from '../../vm/ResourceVm';
import { LiveHeadsUpWalletHoleAnimation } from '../animation/LiveHeadsUpWalletHoleAnimation';
import { LiveHeadsUpWalletNoHoleAnimation } from '../animation/LiveHeadsUpWalletNoHoleAnimation';
import { bannerMgr } from '../../banner/phone/BannerManager';
import { BannerPanelType } from '../../banner/common/info/BannerState';
import { LiveStyle } from '../constants/LiveStyle';
import { ArkUIAdapter } from '../../utils/ArkUIAdapter';

const TAG = 'LiveHeadsUpWalletCardVm';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

export enum WalletStageValue {
  DEFAULT = 0,
  SWIPE_INIT = -1,
  SELECT_CARD = 1,
  SWIPE_DOING = 2,
  SWIPE_SUCCEED = 3,
  SWIPE_FAILED = 4,
  SWIPE_FINISHED = 5,
}

export enum AnimationStage {
  INIT = 0,
  ENTER = 1,
  ROTATING = 2,
  EXIT_START = 3,
  EXIT_END = 4,
}

export const enum SweepStage {
  NOT_DO = 0,
  CAN_DO = 1,
  DONE = 2
}

export enum ShowStage {
  SHOW = 0,
  UPDATE = 1,
  HIDE = 2
}

@ObservedV2
export class LiveHeadsUpWalletCardVm extends LiveBaseVm implements ILiveHeadsUpWalletCardVm {
  @Trace public live?: LiveNotification | undefined;
  @Trace public imageInfo: ImageInfo = new ImageInfo();
  @Trace public textInfo: TextInfo = new TextInfo();
  @Trace public radioInfo: RadioInfo = new RadioInfo();
  @Trace public overlayBoxInfo: OverlayBoxInfo = new OverlayBoxInfo();
  @Trace public noAnchorPointOverallPageLayOutInfo: NoAnchorPointOverallPageLayOutInfo =
    new NoAnchorPointOverallPageLayOutInfo();
  public componentId = this.vmInjector.getId(TAG);
  public animationStage: AnimationStage = AnimationStage.INIT;
  public exitStartTime: number = 0;
  public sweepingStage: SweepStage = SweepStage.NOT_DO;
  public swipeExitAnimatorResult?: AnimatorResult;
  public isPlayingRotation: boolean = false;
  public bannerWidthConstant: number = 104
  public bannerLengthConstant: number = 66
  public showStage: ShowStage = ShowStage.SHOW;
  public headsUpVm = this.vmInjector.getLiveHeadsUpVm();
  private lastHashCode: string | undefined = undefined;
  // 横幅宽度根据屏幕计算，屏幕宽度 - 16 -16  388 -32
  public bannerWidthConstantFinalState: number = 356;
  // 文字相对位移固定值
  public textOffsetDisplacement: number = 88;
  // 图标相对位移是 屏幕宽度 - 16 * 2 横幅宽度/2 + (固定值) 38 - (固定值) 12 - (固定值) 40
  public iconOffsetDisplacement: number = ((this.bannerWidthConstantFinalState / 2) + 38 - 12 - 40);
  /*圆角的改变值*/
  public borderRadiusChanges: number = 20;
  protected animation?: LiveHeadsUpWalletAnimation;
  public largeFontAdaptationHeight: number = 0;
  // 字符串宽度， 如果是无孔bannerWidth为固定值328， 12是边距， 76是宽度， 40是Icon宽度
  public textWidth: number = this.bannerWidthConstantFinalState - 12 - 12 - 12 - 76 - 40 - 12;
  //是否为旋转过
  public isRotated: boolean = false;

  constructor(vmInjector: LiveVmInjector) {
    super(vmInjector);
  }

  public async show(live: LiveNotification, preemption?: boolean): Promise<void> {
    // 重置
    this.animationStage = AnimationStage.INIT;
    this.sweepingStage = SweepStage.NOT_DO;
    this.imageInfo.CleanStatus()
    this.textInfo.CleanStatus()
    this.radioInfo.CleanStatus()
    this.overlayBoxInfo.cleanStatus()
    this.swipeExitAnimatorResult = undefined;
    // 初始化
    this.showStage = ShowStage.SHOW;
    this.live = live;
    this.lastHashCode = live.hashCode;
      this.bannerWidthConstantFinalState = CutoutVm.instance.isMiddleCutout() ?
        ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) - 32 : 328;
      log.info(`bannerWidthConstantFinalState is ${this.bannerWidthConstantFinalState}`);
      this.iconOffsetDisplacement = CutoutVm.instance.isMiddleCutout() || DeviceInfoVm.instance.isXTSpecialState() ?
        ((this.bannerWidthConstantFinalState / 2) + 38 - 12 - 40) : 264;
    this.largeFontAdaptationHeight = this.getLargeFontAdaptationHeight();
    this.animation = CutoutVm.instance.isMiddleCutout() || DeviceInfoVm.instance.isXTSpecialState() ?
      new LiveHeadsUpWalletHoleAnimation(this) : new LiveHeadsUpWalletNoHoleAnimation(this);
    log.info(TAG, `[show()] begins stage is ${live.stage}`)

    if (live.stage === WalletStageValue.SELECT_CARD) {
      this.imageInfo.cardimagePixelMap = live.smallIcon;
      this.animation?.swipeEnterAnimation();
      return;
    }
    if (live.stage === WalletStageValue.SWIPE_DOING) {
      this.sweepingStage = SweepStage.CAN_DO;
      this.imageInfo.cardimagePixelMap = live.smallIcon;
      this.animation?.swipeEnterAnimation();
    }
  }

  public async update(live: LiveNotification): Promise<void> {
    log.info(TAG, `[update()] begins stage is ${live.stage}, last stage is ${this.live?.stage}`);
    let isDoingRefresh =
      this.live?.stage === WalletStageValue.SWIPE_DOING && live.stage === WalletStageValue.SWIPE_DOING;
    this.live = live;
    this.showStage = ShowStage.UPDATE;
    let card = live.card as LiveCardSystemModel;
    if (this.sweepingStage === SweepStage.NOT_DO) {
      this.sweepingStage = SweepStage.CAN_DO;
    }

    if (live.stage === WalletStageValue.SWIPE_DOING) {
      this.imageInfo.updateCardimagePixelMap = live.smallIcon;
      this.setCardResponseRegion(false);
      if (!isDoingRefresh) {
        await this.animation?.swipeEnterRefreshImageAnimation();
      }
      return;
    }
    if (live.stage === WalletStageValue.SWIPE_SUCCEED) {
      this.imageInfo.updateCardimagePixelMap = live.smallIcon;
      this.setCardResponseRegion(false);
      if (this.imageInfo.nextInstruction === -1) {
        this.imageInfo.nextInstruction = WalletStageValue.SWIPE_SUCCEED;
        this.textInfo.textMainTitle = card.title;
        this.textInfo.textSubTitle = card.content;
      }
      return;
    }
    if (live.stage === WalletStageValue.SWIPE_FAILED) {
      this.imageInfo.updateCardimagePixelMap = live.smallIcon;
      this.setCardResponseRegion(false);
      if (this.imageInfo.nextInstruction === -1) {
        this.imageInfo.nextInstruction = WalletStageValue.SWIPE_FAILED;
        this.textInfo.textMainTitle = card.title;
        this.textInfo.textSubTitle = card.content;
        this.radioInfo.isSwipeFailureIcon = true;
        if (card.buttons) {
          this.radioInfo.cardImageFailPixelMap = card.buttons[0].lightIcon;
        }
      }
      return;
    }
    if (live.stage === WalletStageValue.SWIPE_FINISHED) {
      this.imageInfo.nextInstruction = WalletStageValue.SWIPE_FINISHED;
    }
  }

  public async hide(): Promise<void> {
    log.info(`[hide()] begins animationStage is ${this.animationStage},
    nextInstruction is ${this.imageInfo.nextInstruction}`);
    this.showStage = ShowStage.HIDE;
    if (this.imageInfo.nextInstruction === -1) {
      this.imageInfo.nextInstruction = WalletStageValue.SWIPE_FINISHED;
    }
    await this.animation?.swipeExitEndAnimation();
    this.isRotated = false;
  }

  public isNeedShow(live: LiveNotification): boolean {
    log.info(`previous hashCode is ${this.lastHashCode}, present hasCode is ${live.hashCode},
      showStage is ${this.showStage}`)
    return this.showStage === ShowStage.HIDE && this.lastHashCode === live.hashCode ? false : true;
  }

  public setCardResponseRegion(isRotate: boolean = false): void {
    if (!this.live) {
      return;
    }
    if (!bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)) {
      return;
    }
    if (isRotate) {
      this.isRotated = true;
    }
    //横转竖，卡片沿用横屏位置，设置竖屏热区
    if (CutoutVm.instance.isMiddleCutout() || DeviceInfoVm.instance.isXTSpecialState()) {
      this.setMiddleCoutResponseArea();
    } else {
      //竖转横，卡片沿用竖屏位置，设置横屏热区
      this.setLandscapeResponseArea();
    }
  }

  private setMiddleCoutResponseArea(): void {
    if (!this.live) {
      return;
    }
    const stage = this.live.stage;
    if (!this.isRotated) {
      if (stage === WalletStageValue.SWIPE_DOING) {
        bannerMgr.setResponseRegion(this.getMidCoutResponseArea(true), BannerPanelType.TYPE_LIVE_HEADS_UP);
      } else {
        bannerMgr.setResponseRegion(this.getMidCoutResponseArea(false), BannerPanelType.TYPE_LIVE_HEADS_UP);
      }
      return;
    }

    let leftMargin = 0;
    if (stage === WalletStageValue.SWIPE_DOING) {
      if (ResourceVm.instance.isRTL) {
        leftMargin = ArkUIAdapter.px2vp(DeviceInfoVm.instance.verticalScreenWidth) -
        this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace - LiveStyle.WALLET_SMALL_CARD_WIDTH;
      } else {
        leftMargin = this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace;
      }
    } else {
      leftMargin = this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace;
    }

    const responseArea: Area = {
      height: LiveStyle.WALLET_CARD_HEIGHT,
      width: stage === WalletStageValue.SWIPE_DOING ? LiveStyle.WALLET_SMALL_CARD_WIDTH : LiveStyle.CARD_WIDTH,
      position: { x: leftMargin, y: 0 },
      globalPosition: { x: leftMargin, y: 61 }
    }
    log.showInfo(`set middleCout response area, width: ${responseArea.width} globalPosition.x ${responseArea.globalPosition.x}`);
    bannerMgr.setResponseRegion(responseArea, BannerPanelType.TYPE_LIVE_HEADS_UP);
  }

  private setLandscapeResponseArea(): void {
    if (!this.live) {
      return;
    }
    const stage = this.live.stage;
    if (!this.isRotated) {
      if (stage === WalletStageValue.SWIPE_DOING) {
        bannerMgr.setResponseRegion(this.getLandScapeResponseArea(true), BannerPanelType.TYPE_LIVE_HEADS_UP);
      } else {
        bannerMgr.setResponseRegion(this.getLandScapeResponseArea(false), BannerPanelType.TYPE_LIVE_HEADS_UP);
      }
      return;
    }
    let leftMargin = 0;
    if (this.live.stage === WalletStageValue.SWIPE_DOING) {
      if (ResourceVm.instance.isRTL) {
        leftMargin = ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) -
        this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace -
          ((LiveStyle.CARD_WIDTH + LiveStyle.WALLET_SMALL_CARD_WIDTH) / 2);
      } else {
        leftMargin = this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace +
          ((LiveStyle.CARD_WIDTH - LiveStyle.WALLET_SMALL_CARD_WIDTH) / 2);
      }
    } else {
      if (ResourceVm.instance.isRTL) {
        leftMargin = ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) -
        this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace - LiveStyle.CARD_WIDTH;
      } else {
        leftMargin = this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace;
      }
    }
    const responseArea: Area = {
      height: LiveStyle.WALLET_CARD_HEIGHT,
      width: stage === WalletStageValue.SWIPE_DOING ? LiveStyle.WALLET_SMALL_CARD_WIDTH : LiveStyle.CARD_WIDTH,
      position: { x: leftMargin, y: 0 },
      globalPosition: { x: leftMargin, y: 61 }
    }
    log.showInfo(`set landscape response area, width: ${responseArea.width} globalPosition.x ${responseArea.globalPosition.x}`);
    bannerMgr.setResponseRegion(responseArea, BannerPanelType.TYPE_LIVE_HEADS_UP);
  }

  private getMidCoutResponseArea(isSwipeDoing: boolean): Area {
    let leftMargin = 0;
    const leftSpace = this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace;
    if (isSwipeDoing) {
      leftMargin = leftSpace + ((LiveStyle.CARD_WIDTH - LiveStyle.WALLET_SMALL_CARD_WIDTH) / 2);
    } else {
      leftMargin = leftSpace;
    }
    const responseArea: Area = {
      height: LiveStyle.WALLET_CARD_HEIGHT,
      width: isSwipeDoing ? LiveStyle.WALLET_SMALL_CARD_WIDTH : LiveStyle.CARD_WIDTH,
      position: { x: leftMargin, y: 0 },
      globalPosition: { x: leftMargin, y: 61 }
    }
    log.showInfo(`get middleCout response area, width: ${responseArea.width} globalPosition.x ${responseArea.globalPosition.x}`);
    return responseArea;
  }

  private getLandScapeResponseArea(isSwipeDoing: boolean): Area {
    let leftMargin = 0;
    const leftSpace = this.vmInjector.getCapsuleListVm().position.statusBarClockLeftSpace;
    if (isSwipeDoing) {
      leftMargin = ResourceVm.instance.isRTL ? ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) - leftSpace -
      LiveStyle.WALLET_SMALL_CARD_WIDTH : leftSpace;
    } else {
      leftMargin = ResourceVm.instance.isRTL ?
        ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) - leftSpace - LiveStyle.CARD_WIDTH : leftSpace;
    }
    const responseArea: Area = {
      height: LiveStyle.WALLET_CARD_HEIGHT,
      width: isSwipeDoing ? LiveStyle.WALLET_SMALL_CARD_WIDTH : LiveStyle.CARD_WIDTH,
      position: { x: leftMargin, y: 0 },
      globalPosition: { x: leftMargin, y: 61 }
    }
    log.showInfo(`get landscape response area, width: ${responseArea.width} globalPosition.x ${responseArea.globalPosition.x}`);
    return responseArea;
  }

  public getBigFontOffsetY(): number {
    if (ResourceVm.instance.fontScale <= 1) {
      return 3;
    } else if (ResourceVm.instance.fontScale < 1.3) {
      return 0.5;
    } else if (ResourceVm.instance.fontScale < 1.45) {
      return -2.7;
    } else {
      return -5.55;
    }
  }

  public getLargeFontAdaptationHeight(): number {
    if (ResourceVm.instance.fontScale <= 1) {
      return 66;
    } else if (ResourceVm.instance.fontScale < 1.3) {
      return 71.4;
    } else if (ResourceVm.instance.fontScale < 1.45) {
      return 77.4;
    } else {
      return 83.1;
    }
  }
}

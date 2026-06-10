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

import { LogDomain, Logger } from '@ohos/basicutils';
import { Singleton } from '../utils/Singleton';
import { BannerPanelType } from '../banner/common/info/BannerState';
import { EventEmitter } from '../utils/EventEmitter';
import { DeviceHelper, EvtBus, ViewArea, WindowEvent } from '@ohos/frameworkwrapper';
import { WindowConstants } from '@ohos/commonconstants';
import { DeviceInfoVm } from './DeviceInfoVm';
import { ResUtils,
  SCBPropertyChangeReason, SCBScreenProperty, SCBSystemBarProperty } from '@ohos/windowscene';
import { BaseConstants } from '../base/common/BaseConstants';
import { LiveStyle } from '../live/constants/LiveStyle';
import { CutoutVm } from '../statusbar/vm/CutoutVm';
import { ArkUIAdapter } from '../utils/ArkUIAdapter';
import { BannerViewControllerAdapter } from '../adapter/BannerViewControllerAdapter';
import { BannerStyle } from '../banner/phone/style/BannerStyle';
import { ScreenSessionAdapter } from '../adapter/ScreenSessionAdapter';
import { SceneSessionAdapter } from '../adapter/SceneSessionAdapter';
import { sharedData } from '../model/SendableData';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuiutils/src/main/ets/base/LayoutUtils';
import { InnerEventUtil } from '../utils/InnerEventUtil';
import { LogWithHa } from '../maintenance/CommonExceptionMaintenance';
import { DisplayAdapter, IDisplayAdapterInfo } from '../adapter/DisplayAdapter';
import { DeviceRotateVm } from './DeviceRotateVm';
import { bannerMgr } from '../banner/phone/BannerManager';

interface BannerVmEvent {
  bannerTypeChange: undefined;
}

/**
 * PAD、折叠屏宽度固定值vp
 */
const PAD_OR_FOLD_NTF_WIDTH: number = 532;
const CARD_WIDTH = 328;
const TAG = 'SystemUI_BannerVm';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

/**
 * Banner面板ViewModel
 */
@ObservedV2
export class BannerVm {
  @Singleton.decorate()
  public static get instance(): BannerVm {
    return new BannerVm();
  }

  private cutoutVm = CutoutVm.instance;
  /**
   * Banner类型
   */
  @Trace public bannerType: BannerPanelType = BannerPanelType.TYPE_NONE;
  @Trace public secondaryType: BannerPanelType = BannerPanelType.TYPE_NONE;
  /**
   * 横幅通知的HashCode
   */
  @Trace public headsUpNtfHashCode?: string;
  @Trace public cardListWidth: number = CARD_WIDTH;
  @Trace public itemWidth: number = 0;
  @Trace public containerWidth: number = 0;
  @Trace public containerMarginTop: number = LiveStyle.MARGIN_TOP_IN_IMMERSIVE;
  @Trace public instantBannerContainerMarginTop: number = LiveStyle.MARGIN_TOP_IN_IMMERSIVE;
  @Trace public containerMarginLeft: number = LiveStyle.MARGIN_LEFT_RIGHT;
  @Trace public containerMarginRight: number = LiveStyle.MARGIN_LEFT_RIGHT;
  @Trace public containerMarginBottom: number = 0;
  public isInImmersive: boolean = false;
  private isBreak: boolean = false;
  /**
   * 屏幕宽度
   */
  private displayWidth: number = 0;
  /**
   * 屏幕高度
   */
  private displayHeight: number = 0;
  /**
   * 状态栏可见
   */
  private statusBarIsVisible: boolean = true;
  /**
   * 是否中挖孔
   */
  private isMiddleCutout: boolean = true;
  /**
   * 当前方向是否有刘海
   */
  private isNotchedScreen: boolean = false;
  /**
   * 状态栏高度
   */
  private statusBarHeight: number = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
  /**
   * 沉浸式场景避让孔高度/刘海高度
   */
  private midCutOutHeight: number = 0;
  public emitter = new EventEmitter<BannerVmEvent>();
  /**
   * banner窗口控制器
   */
  private bannerController = BannerViewControllerAdapter.instance;
  private defaultStyle: BannerStyle = BannerStyle.createStyle();
  private deviceInfoVm = DeviceInfoVm.instance;

  private constructor() {
  }

  /**
   * 初始化
   * @returns
   */
  public init(): void {
    try {
      ScreenSessionAdapter.registerScreenPropertyChangeCallbacks({
        callback: this.onScreenPropertyChange,
        screenId: undefined,
        isRotatable: true,
        persistentId: sharedData.bannerPersistentId
      }, `${TAG}_registerScreenPropertyChangeCallbacks`)
      // 注册状态栏沉浸式状态切换监听
      SceneSessionAdapter.registerSystemBarPropertyCallbacks({
        callback: this.onSystemBarProperty,
        screenId: undefined
      }, `${TAG}_registerSystemBarPropertyCallbacks`);
    } catch (err) {
      log.showError(TAG, `BannerVm init , err message is ${err?.message}`);
    }
  }

  private onScreenPropertyChange = (screenProperty: SCBScreenProperty, reason: SCBPropertyChangeReason): void => {
    log.showInfo(TAG, `onScreenPropertyChange. width: ${screenProperty.width}, height: ${screenProperty.height}, curWidth:${this.displayWidth}, curHeight:${this.displayHeight}`);
    let bannerSize: ViewArea = {
      left: 0,
      top: 0,
      width: ArkUIAdapter.px2vp(screenProperty.width),
      height: ArkUIAdapter.px2vp(screenProperty.height) - this.defaultStyle.bannerMarginBottom
    };

    ArkUIAdapter.runWithScope(() => {
      // 更新banner窗口大小
      this.bannerController.updateArea(bannerSize);
      this.bannerController.updateRect(bannerSize);
      // 刷新banner样式
      this.refreshBannerStyle(screenProperty.width, screenProperty.height);
    })
  }
  /**
   * 状态栏沉浸式状态监听
   */
  private onSystemBarProperty = (property: SCBSystemBarProperty): void => {
    log.showInfo(TAG, `onSystemBarProperty`);
    if (!property || this.isInImmersive === !property?.enable) {
      return;
    }
    this.isInImmersive = !property?.enable;
    this.refreshBannerStyle();
  };

  /**
   * 设置状态栏是否临时打破沉浸式
   */
  public updateImmersiveStateBreak(isBreak: boolean): void {
    log.showInfo(TAG, `updateImmersiveStateBreak. isBreak: ${isBreak}`);
    if (this.isBreak === isBreak) {
      return;
    }
    this.isBreak = isBreak;
    this.refreshBannerStyle();
  }

  private postStatusBarHideEvent() {
    if (BannerPanelType.TYPE_NONE === this.bannerType) {
      log.showInfo(TAG, `postStatusBarHideEvent ${this.bannerType}`)
      let event = new WindowEvent();
      event.windowName = WindowConstants.WINDOW_NAME_LIVEVIEW;
      event.eventType = WindowEvent.EVENT_TYPE_HIDE;
      event.eventState = WindowEvent.EVENT_STATE_START;
      EvtBus.post(WindowEvent, event);
    }
  }

  /**
   * 设置Banner类型
   * @param bannerType
   */
  public setBannerType(bannerType: BannerPanelType, secondaryType: BannerPanelType): void {
    if (this.bannerType !== bannerType) {
      log.showInfo(TAG, `Set banner type, old: ${this.bannerType}, new: ${bannerType}`);
      this.bannerType = bannerType;
      this.postStatusBarHideEvent();
    }
    if (this.secondaryType !== secondaryType) {
      log.showInfo(TAG, `Set secondaryType type, old: ${this.secondaryType}, new: ${secondaryType}`);
      this.secondaryType = secondaryType;
    }
    this.emitter.emit('bannerTypeChange', undefined);
  }

  /**
   * 是否为不显示Banner
   * @returns
   */
  public isNone(): boolean {
    return this.bannerType === BannerPanelType.TYPE_NONE;
  }

  /**
   * 是否显示为横幅
   * @returns
   */
  public isHeadsUp(): boolean {
    return this.bannerType === BannerPanelType.TYPE_HEADS_UP;
  }

  /**
   * 是否显示为实况横幅
   * @returns
   */
  public isLiveHeadsUp(): boolean {
    return this.bannerType === BannerPanelType.TYPE_LIVE_HEADS_UP;
  }

  /**
   * 是否为实况卡片列表
   * @returns
   */
  public isLivePanel(): boolean {
    return this.bannerType === BannerPanelType.TYPE_LIVE_LIST ||
      this.secondaryType === BannerPanelType.TYPE_CAPSULE_LIST;
  }

  /**
   * 是否隐藏胶囊
   * @returns
   */
  public isHideCapsule(): boolean {
    return this.bannerType === BannerPanelType.TYPE_LIVE_LIST;
  }

  /**
   * 横幅场景获取屏幕宽度，计算悬浮窗尺寸和位置
   * @returns
   */
  public getDisplayWidth(): number {
    return this.displayWidth > 0 ? this.displayWidth : bannerMgr.getBannerState().displaySizeState.displayWidth;
  }

  /**
   * 横幅场景获取屏幕高度，计算悬浮窗尺寸和位置
   * @returns
   */
  public getDisplayHeight(): number {
    return this.displayHeight > 0 ? this.displayHeight : bannerMgr.getBannerState().displaySizeState.displayHeight;
  }

  /**
   * 刷新banner面板样式
   */
  private refreshBannerStyle(width?: number, height?: number): void {
    let deviceWidth: number;

    if (DeviceRotateVm.instance.isInRotateAnim) {
      // 旋转过程中会触发多次，过程中每次计算width不一致，会打断旋转宽度变化的衔接动效。 统一使用屏幕宽度。
      deviceWidth = width ?? sharedData.bannerScreenWidth;
    } else {
      deviceWidth = width ?? (this.cutoutVm.displayWidth !== 0 ? this.cutoutVm.displayWidth : 0);
    }

    if (deviceWidth === 0) {
      return;
    }
    if (width && height && (this.displayWidth !== width || this.displayHeight !== height)) {
      this.displayWidth = width;
      this.displayHeight = height;
    }
    let cardIWidth = 0;
    if (this.isCardCenterLayout()) {
      cardIWidth =
        ArkUIAdapter.px2vp(this.cutoutVm.displayWidth) - (LiveStyle.MARGIN_LEFT_RIGHT * BaseConstants.DOUBLE);
    } else {
      cardIWidth = CARD_WIDTH;
    }
    let itemWidth = 0;
    let marginLeftRight = 0;
    let displayWidth = ArkUIAdapter.px2vp(deviceWidth);
    if (displayWidth > LiveStyle.WIDTH_THRESHOLD_SMALL) {
      itemWidth = this.getWidestScreenWidth(deviceWidth);
      marginLeftRight = (displayWidth - itemWidth) / BaseConstants.DIVIDE;
    } else {
      marginLeftRight = this.defaultStyle.marginLeftRight;
      itemWidth = displayWidth - (marginLeftRight * BaseConstants.DOUBLE);
    }

    let marginStatusBarTop =  LiveStyle.MARGIN_STATUS_BAR_TOP;
    let marginTop =
      ((this.isInImmersive && !this.isBreak) || !this.statusBarIsVisible) ?
        (LiveStyle.MARGIN_TOP_IN_IMMERSIVE + this.midCutOutHeight) : (marginStatusBarTop + this.statusBarHeight);
    log.showInfo(TAG, `refreshBannerStyle, marginTop:${marginTop}, cardIWidth ${cardIWidth}, itemWidth: ${itemWidth}, marginLeftRight: ${marginLeftRight}, marginStatusBarTop ${marginStatusBarTop}`);
    this.cardListWidth = cardIWidth;
    this.itemWidth = itemWidth;
    this.containerWidth = itemWidth;
    this.containerMarginTop = marginTop;
    this.instantBannerContainerMarginTop = marginStatusBarTop + this.statusBarHeight;
    this.containerMarginLeft = marginLeftRight;
    this.containerMarginRight = marginLeftRight;
    // 底部固定间距
    this.containerMarginBottom = this.defaultStyle.marginBottom;
  }

  private getWidestScreenWidth(displayWidth: number): number {
    if (LayoutUtils.isPadLayout() || DeviceHelper.isFoldExpanded() || LayoutUtils.isMatchXTFoldMode(XTLayoutType.M)) {
      // 小折叠按比例取值
      if (DeviceHelper.isSmallFoldProduct()) {
        return ArkUIAdapter.px2vp(ResUtils.getTimeStartWidthByLandScreenWidth(displayWidth));
      }
      return PAD_OR_FOLD_NTF_WIDTH;
    }
    return ArkUIAdapter.px2vp(ResUtils.getTimeStartWidthByLandScreenWidth(displayWidth));
  }

  // marginTop 实况宽度 headsup宽度
  @Monitor('cutoutVm.top', 'cutoutVm.position', 'cutoutVm.left', 'cutoutVm.right', 'cutoutVm.orientation', 'cutoutVm.displayWidth')
  public onCutoutChange(): void {
    log.showInfo(TAG, `onCutoutChange`);
    this.isMiddleCutout = this.cutoutVm.isMiddleCutout();
    this.isNotchedScreen = this.cutoutVm.isNotchedScreen();
    this.midCutOutHeight = this.getMidCutOutHeight();
    this.refreshBannerStyle();
  }

  /**
   * 沉浸式没有状态栏场景需要加上孔高度/刘海高度
   * @returns
   */
  private getMidCutOutHeight(): number {
    if (this.isMiddleCutout || this.isNotchedScreen) {
      // 位置比状态栏高，下挖孔  VERDE外屏无孔
      if (this.cutoutVm.top > this.statusBarHeight && !DeviceHelper.isFoldExpandedOrHalf()) {
        return 0;
      }
      return (this.cutoutVm.top ?? 0) + (this.cutoutVm.height ?? 0);
    }
    return 0;
  }

  public checkDeviceStatus(): void {
    try {
      const disPlay = DisplayAdapter.getDefaultDisplaySync();
      if (disPlay.width !== this.deviceInfoVm.width || disPlay.height !== this.deviceInfoVm.height ||
        this.deviceInfoVm.orientation !== disPlay.rotation) {
        this.reportDeviceInfoLog(disPlay);
        this.onCutoutChange();
        return;
      }
      log.showInfo(TAG, 'device status is matched displayManager');
    } catch (e) {
      log.showError(TAG, `checkDeviceStatus error ${e}`);
    }
  }

  private reportDeviceInfoLog(disPlay: IDisplayAdapterInfo): void {
    LogWithHa.showError(log, TAG,
      `display info:[width: ${disPlay.width}-${this.deviceInfoVm.width}, height:${disPlay.height}-${this.deviceInfoVm.height},
      orientation:${this.deviceInfoVm.orientation}-${disPlay.rotation}, lastOrientation:${this.deviceInfoVm.lastOrientation}, isMidCutOut: ${this.isMiddleCutout}`);
  }

  /**
   * 设置状态栏是否可见
   *
   * @param statusBarIsVisible 状态栏可见
   */
  setStatusBarIsVisible(statusBarIsVisible: boolean): void {
    if (statusBarIsVisible === this.statusBarIsVisible) {
      return;
    }
    this.statusBarIsVisible = statusBarIsVisible;
    log.showInfo(TAG, `statusBarIsVisible: ${statusBarIsVisible}`);
    this.refreshBannerStyle();
  }

  // 是否为卡片居中布局场景。 1. 中挖孔
  public isCardCenterLayout(): boolean {
    return this.cutoutVm.isMiddleCutout();
  }
}
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

import { LogDomain, CommonUtils, SingletonHelper, Logger, } from '@ohos/basicutils';
import {
  HiDfxEventUtil,
  CutoutEvent,
  EvtBus,
  DeviceHelper,
  ViewType,
  sEventManager,
  ViewManagerPolicy,
  HiSysEventUtil
} from '@ohos/frameworkwrapper';
import { DisplayEvent } from '@ohos/windowscene';
import {
  OTA_OOBE_CHANGE_EVENT,
  sSCBOtaManager,
  SCBOobeManager,
  SCBSceneSessionManager,
  OOBE_CHANGE_EVENT,
  DisplayMgr
} from '@ohos/windowscene';
import { RotationConstants } from '@ohos/commonconstants';
import VolumePanelService from '../model/VolumePanelService';
import { VolumeWindowStateListener } from './Interfaces';
import type { EventManager, ViewArea } from '@ohos/frameworkwrapper';
import Constants, { VolumeAnimType, VolumeInfo } from './Constants';
import screenSessionManager from '@ohos.screenSessionManager';
import display from '@ohos.display';
import type { SCBSystemSceneSession } from '@ohos/windowscene';
import { LocalWindowManager } from '@ohos/systemuicommon';
import { LayoutUtils, XTLayoutType } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';

const TAG = 'VolumeWindowController';
const SINGLE_STANCE_KEY = 'VolumeWindowController';
const WINDOW_DISMISS_DELAY = 1400;
const HIDE_WINDOW_DELAY = 300;
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);

export default class VolumeWindowController {
  public mInterval: number = Constants.VOLUME_BAR_TIMEOUT;
  public mLastActionTime?: number;
  public mIsWindowShown?: boolean;
  public mVolumeWindowStateListenerSet = new Set<VolumeWindowStateListener>();
  private previousAutoDismissTimer: number = 0;
  private previousDismissAnimTimer: number = 0;
  private oobeEnable: boolean = false;
  private oobeOtaEnable: boolean = false;
  private cutOutLeft: number = 0;
  private sysSceneSession: SCBSystemSceneSession | null = null;

  /**
   * 记录屏幕尺寸
   */
  private lastBounds: screenSessionManager.RRect | null = null;

  private rotateAngle: number = 0;

  /**
   * 是否是折叠屏展开状态
   */
  private isExpandStatus: boolean = false;

  /**
   * 是否是半折叠状态
   */
  private foldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  private isHalfFoldStatus: boolean = false;
  /**
   * 多事件管理器
   */
  private eventManager?: EventManager;
  private isPhone: boolean = true;
  private isVolumeWindowShowing: boolean = false;
  private isTimerPaused: boolean = false;
  private curVolumeInfo: VolumeInfo | null = null;


  private isConfigDialogWidth: boolean = false;

  private curVolumeRect?: ViewArea;

  private curDisplay?: display.Display;

  static getInstance(): VolumeWindowController {
    return SingletonHelper.getInstance(VolumeWindowController, SINGLE_STANCE_KEY);
  }

  constructor() {
    VolumePanelService.startService();
    VolumePanelService.registerListener(this);
    log.showInfo(TAG, 'constructor done');
  }

  init(): void {
    this.isPhone = DeviceHelper.isPhone() || DeviceHelper.isPad();
    this.rotateAngle = DisplayMgr.getCacheDisplay()?.scbScreenProperty?.rotation ?? 0;
    this.isExpandStatus = (DisplayMgr.getCacheDisplay()?.isFoldablePhoneExpandStatus() ?? false) &&
      !LayoutUtils.isMatchXTFoldMode(XTLayoutType.F);
    this.eventManager = EvtBus.createEventManager();
    // 横竖屏不同窗口尺寸，初始设置
    const screenBounds: screenSessionManager.RRect = DisplayMgr.getCacheDisplay()?.bounds;
    this.resetVolumeWindowSize(screenBounds);
    // 监听窗口变化，切换窗口尺寸
    this.eventManager.on(DisplayEvent, this.onDisplayEvent.bind(this)).on(CutoutEvent, this.handleCutoutEvent);
    this.oobeEnable = SCBOobeManager.isEnable();
    this.oobeOtaEnable = sSCBOtaManager.isOtaEnable();
    sEventManager.subscribe(OOBE_CHANGE_EVENT, (enable: boolean) => {
      log.showInfo(TAG, `Oobe state change ${enable}`);
      this.oobeEnable = enable;
      AppStorage.set<boolean>('VolumeOobeState', this.oobeEnable || this.oobeOtaEnable);
    });
    sEventManager.subscribe(OTA_OOBE_CHANGE_EVENT, (enable: boolean) => {
      log.showInfo(TAG, `Ota oobe state change ${enable}`);
      this.oobeOtaEnable = enable;
      AppStorage.set<boolean>('VolumeOobeState', this.oobeEnable || this.oobeOtaEnable);
    });
    AppStorage.setOrCreate<boolean>('VolumeOobeState', this.oobeEnable || this.oobeOtaEnable);

    try {
      display.on('foldStatusChange', this.volumeFolderStatusChangeCallback);
    } catch (error) {
      log.error(TAG, 'monitorDisplayModeChange on error', error);
    }

    let persistentId = ViewManagerPolicy.getViewController(ViewType.VOLUME)?.getId();
    this.sysSceneSession = SCBSceneSessionManager.getInstance().getSystemSceneSessionWithId(persistentId);
    if (!CommonUtils.isInvalid(this.sysSceneSession)) {
      this.sysSceneSession?.session?.on('touchOutside', () => {
        this.mVolumeWindowStateListenerSet?.forEach((listener: VolumeWindowStateListener) => {
          listener?.onTouchVolumeOutSide();
        });
        log.showWarn(TAG, 'Volume touch outside callback');
      });
    } else {
      log.showInfo(TAG, `${persistentId} sysSceneSession is invalid`);
    }
    log.showInfo(TAG, `Volume controller init ${this.oobeEnable} ${this.oobeOtaEnable}
      ${this.sysSceneSession?.session?.persistentId} ${this.sysSceneSession?.session?.type}`);
  }

  destroy(): void {
    this.eventManager?.offAll();
    try {
      display.off('foldStatusChange', this.volumeFolderStatusChangeCallback);
    } catch (error) {
      log.error(TAG, 'monitor off DisplayModeChange on error', error);
    }
  }

  private volumeFolderStatusChangeCallback = (newFoldStatus: display.FoldStatus): void => {
    this.foldStatus = newFoldStatus;
    let tmpHalfFoldStatus = this.isHalfFoldStatus;
    this.checkHalfFolded();
    if (tmpHalfFoldStatus !== this.isHalfFoldStatus) {
      if (this.isShowVolumeWindow()) {
        log.showInfo(TAG, 'Volume window foldStatusChange is showing');
        this.dismissVolumeWindowImmediately();
      }
      this.mVolumeWindowStateListenerSet?.forEach((listener: VolumeWindowStateListener) => {
        listener?.onVolumeDisplayChanged(true);
      });
    }
  };

  setInterval(interval: number): void {
    this.mInterval = interval;
  }

  updateVolumeInfo(volumeInfo: VolumeInfo | null): void {
    if (volumeInfo && !volumeInfo.updateUi) {
      return;
    }
    if (this.previousDismissAnimTimer > 0) {
      // 上一次动效还未退出
      return;
    }
    this.curVolumeInfo = volumeInfo;
    // 设置音量条自动关闭时长
    this.setInterval(Constants.VOLUME_BAR_TIMEOUT);
    this.showVolumeWindow();
  }

  registerWindowStateListener(listener: VolumeWindowStateListener): void {
    if (listener == null) {
      return;
    }
    this.mVolumeWindowStateListenerSet?.add(listener);
    this.deviceConfigChange();
  }

  unRegisterWindowStateListener(listener: VolumeWindowStateListener): void {
    if (listener == null) {
      return;
    }
    this.mVolumeWindowStateListenerSet?.delete(listener);
  }

  pauseAutoDismissTimer(): void {
    this.isTimerPaused = true;
    this.showVolumeWindow();
  }

  startAutoDismissTimer(): void {
    this.isTimerPaused = false;
    this.showVolumeWindow();
  }

  handleAccessibilityAutoDismissTimer(isFocus: boolean, volumeAnimType: VolumeAnimType): void {
    if (volumeAnimType === VolumeAnimType.TYPE_OUT || volumeAnimType === VolumeAnimType.TYPE_ALL_CONTROL_OUT ||
      volumeAnimType === VolumeAnimType.TYPE_NONE) {
      return;
    }

    if (isFocus) {
      this.pauseAutoDismissTimer();
    } else {
      this.startAutoDismissTimer();
    }
  }

  dismissVolumeWindowImmediately(): void {
    log.showInfo(TAG, 'dismissVolumeWindowImmediately.');
    this.isTimerPaused = false;
    this.isVolumeWindowShowing = false;
    this.clearWindowTimer();
    this.mVolumeWindowStateListenerSet?.forEach((listener: VolumeWindowStateListener) => {
      listener?.onVolumeWindowStateChanged(false);
    });
    if (this.curVolumeInfo) {
      HiDfxEventUtil.reportHideSingleVolBar(this.curVolumeInfo.volumeType, this.curVolumeInfo.volume);
    }
    ViewManagerPolicy.hideView(ViewType.VOLUME);
    log.showInfo(TAG, 'dismissVolumeWindowImmediately success.');
  }

  /**
   * 是否是折叠屏展开态
   *
   * @returns true，折叠屏展开状态
   */
  public isFoldExpand(): boolean {
    return this.isExpandStatus;
  }

  /**
   * 是否是折叠屏展开态
   *
   * @returns true，折叠屏展开状态
   */
  public isHalfFoldedStatus(): boolean {
    return this.isHalfFoldStatus;
  }

  /**
   * 是否横屏
   *
   * @return true横屏
   */
  public isDisplayLand(): boolean {
    return this.rotateAngle === RotationConstants.ROTATION_90 || this.rotateAngle === RotationConstants.ROTATION_270;
  }

  /**
   * 屏幕方向是否倒置
   * rotateAngle为180°时为竖屏下倒置
   * rotateAngle为270°时为横屏下倒置
   *
   * @return true倒置
   */
  public isDisplayReverse(): boolean {
    return this.rotateAngle === RotationConstants.ROTATION_180 || this.rotateAngle === RotationConstants.ROTATION_270;
  }

  /**
   * 根据屏幕是否横屏/倒置对窗口坐标进行自适应调整
   * @param x 屏幕rotateAngle为0°时，左上角为起点，水平向右方向的坐标
   * @param y 屏幕rotateAngle为0°时，左上角为起点，竖直向下方向的坐标
   * @returns 旋转后的屏幕坐标
   */
  rotateCoordinate(x: number, y: number): number[] {
    // arkui已修改横屏状态下报点，无需转换
    return [x, y];
  };

  /**
   * 重置音量条自动消失定时器
   */
  public resetWindowTimer(isTimerPaused?: boolean): void {
    if (isTimerPaused !== undefined) {
      this.isTimerPaused = isTimerPaused;
    }
    this.clearWindowTimer();
    if (!this.isTimerPaused) {
      this.previousAutoDismissTimer = setTimeout(() => {
        this.autoDismissVolumeWindow();
      }, this.mInterval);
    }
  }

  private showVolumeWindow(): void {
    this.resetWindowTimer();
    if (this.isShowVolumeWindow()) {
      log.showInfo(TAG, 'showVolumeWindow isVolumeWindowShowing: true');
      return;
    }
    this.forceResetWindowSize();
    if (this.curVolumeInfo) {
      HiDfxEventUtil.reportShowSingleVolBar(this.curVolumeInfo.volumeType, this.curVolumeInfo.volume);
    }
    this.mVolumeWindowStateListenerSet?.forEach((listener: VolumeWindowStateListener) => {
      listener?.onOoberStateChanged(this.oobeEnable || this.oobeOtaEnable);
      listener?.beforeVolumeWindowShow(this.curVolumeInfo);
    });
    ViewManagerPolicy.showView(ViewType.VOLUME);
    this.isVolumeWindowShowing = true;
    if (DeviceHelper.isPC()) {
      ViewManagerPolicy.hideView(ViewType.BRIGHTNESS_PANEL);
    };
    this.mVolumeWindowStateListenerSet?.forEach((listener: VolumeWindowStateListener) => {
      listener?.onVolumeWindowStateChanged(true, this.curVolumeInfo);
    });
    log.showInfo(TAG, 'showVolumeWindow success.');
  }

  private autoDismissVolumeWindow(): void {
    if (!this.isVolumeWindowShowing || this.previousDismissAnimTimer > 0) {
      log.showInfo(TAG, 'showVolumeWindow isVolumeWindowShowing: false');
      return;
    }
    log.showInfo(TAG, 'autoDismissVolumeWindow.');
    this.clearWindowTimer();
    this.isVolumeWindowShowing = false;
    let isEmpty = (this.mVolumeWindowStateListenerSet?.size ?? 0) <= 0;
    let dismissFunc = (): void => {
      ViewManagerPolicy.hideView(ViewType.VOLUME);
      this.isVolumeWindowShowing = false;
      log.showInfo(TAG, 'dismissVolumeWindow success.');
      this.clearWindowTimer();
    };
    if (!isEmpty) {
      // 延迟隐藏，用于执行退出动画
      this.mVolumeWindowStateListenerSet.forEach((listener: VolumeWindowStateListener) => {
        listener?.onVolumeWindowStateChanged(false);
      });
      this.previousDismissAnimTimer = setTimeout(dismissFunc, WINDOW_DISMISS_DELAY);
    } else {
      dismissFunc();
    }
  }

  public clearWindowTimer(): void {
    if (this.previousAutoDismissTimer > 0) {
      clearTimeout(this.previousAutoDismissTimer);
      this.previousAutoDismissTimer = 0;
    }
    if (this.previousDismissAnimTimer > 0) {
      clearTimeout(this.previousDismissAnimTimer);
      this.previousDismissAnimTimer = 0;
    }
  }

  /**
   * 屏幕切换事件
   *
   * @param event 事件
   */
  private onDisplayEvent(event: DisplayEvent): void {
    if (this.isShowVolumeWindow()) {
      log.showInfo(TAG, 'Volume window is showing');
      this.dismissVolumeWindowImmediately();
    }
    this.isExpandStatus = (event.display?.isFoldablePhoneExpandStatus() ?? this.isExpandStatus) &&
      !LayoutUtils.isMatchXTFoldMode(XTLayoutType.F);
    this.rotateAngle = event.display?.scbScreenProperty?.rotation ?? this.rotateAngle;
    this.checkHalfFolded();
    this.mVolumeWindowStateListenerSet?.forEach((listener: VolumeWindowStateListener) => {
      listener?.onVolumeDisplayChanged(true);
    });
    this.deviceConfigChange();
  }

  private deviceConfigChange(): void {

  }

  /**
   * 挖空事件
   *
   * @param event 事件
   */
  private handleCutoutEvent = (event: CutoutEvent): void => {
    if (this.rotateAngle === RotationConstants.ROTATION_90 && event.cutoutPosition === CutoutEvent.CUTOUT_RIGHT) {
      this.cutOutLeft = event.cutoutRect?.left;
      log.showInfo(TAG, `Volume cutOutLeft ${this.cutOutLeft}`);
    }
  };

  private forceResetWindowSize(): void {
    if (!this.isPhone) {
      return;
    }
    const screenBounds: screenSessionManager.RRect = DisplayMgr.getCacheDisplay()?.bounds;
    this.resetVolumeWindowSize(screenBounds, true);
  }

  /**
   * 设置窗口尺寸
   *
   * @param dis display
   */
  private resetVolumeWindowSize(dis: screenSessionManager.RRect, isForceResize?: boolean): void {
    let cutOutLeft: number = ArkUIAdapter.px2vp(dis?.width);
    log.showWarn(TAG, `resetVolumeWindowSize w:${dis?.width} h:${dis?.height} ${isForceResize} ${cutOutLeft}`);
    if (DeviceHelper.isPhone() && !this.isExpandStatus && this.rotateAngle === RotationConstants.ROTATION_90 &&
    this.cutOutLeft) {
      cutOutLeft = this.cutOutLeft;
    }
    this.mVolumeWindowStateListenerSet?.forEach((listener: VolumeWindowStateListener) => {
      listener?.onVolumeWindowSizeChanged(dis?.width, dis?.height, cutOutLeft);
    });

    // 屏幕无变化，不做处理
    if ((dis?.width === this.lastBounds?.width && dis?.height === this.lastBounds?.height)) {
      log.showWarn(TAG, `resetVolumeWindowSize no change`);
      return;
    }
    this.lastBounds = dis;

    ArkUIAdapter.runWithScope(() => {
      let volumeRect = this.isPhone ? this.getPhoneVolumeWindowRect(dis) : this.getVolumeWindowRect(dis);
      ViewManagerPolicy.getViewController(ViewType.VOLUME)?.updateArea(volumeRect);
      ViewManagerPolicy.getViewController(ViewType.VOLUME)?.updateRect(volumeRect);
    });
  }

  /**
   * 获取音量面板窗口位置
   *
   * @param dis display
   * @return 窗口位置
   */
  private getVolumeWindowRect(dis: screenSessionManager.RRect): ViewArea {
    log.showInfo(TAG, 'getVolumeWindowRect begin');
    const realWidth = LocalWindowManager.PC_BRIGHTNESS_PANEL_WIDTH;
    const realHeight = LocalWindowManager.PC_BRIGHTNESS_PANEL_HEIGHT;
    let defaultDisplay: display.Display | undefined;
    try {
      defaultDisplay = display.getDefaultDisplaySync();
    } catch (error) {
      log.error(TAG, '[aboutToAppear] display.getDefaultDisplaySync error', error);
    }
    const rectLeft = (px2vp(defaultDisplay?.width ?? dis.width) - realWidth) / 2;
    const rectTop = px2vp(defaultDisplay?.height ?? dis.height) * LocalWindowManager.PC_BRIGHTNESS_RATIO - realHeight;
    const volumeRect: ViewArea = {
      left: rectLeft,
      top: rectTop,
      width: realWidth,
      height: realHeight
    };
    this.curVolumeRect = volumeRect;
    this.curDisplay = defaultDisplay;
    log.showInfo(TAG, `getVolumeWindowRect top ${volumeRect.top}, left ${volumeRect.left}, width ${volumeRect.width}, height ${volumeRect.height}`);
    log.showInfo(TAG, `curDisplay width:${this.curDisplay?.width} toVpWidth:${px2vp(this.curDisplay?.width)}
    height:${this.curDisplay?.height} toVpHeight:${px2vp(this.curDisplay?.height)}`);
    return volumeRect;
  }

  /**
   * 获取音量面板窗口位置
   *
   * @param dis display
   * @return 窗口位置
   */
  private getPhoneVolumeWindowRect(dis: screenSessionManager.RRect): ViewArea {
    let volumeRect: ViewArea = {
      left: 0,
      top: 0,
      width: ArkUIAdapter.px2vp(dis?.width),
      height: ArkUIAdapter.px2vp(dis?.height)
    };
    log.showInfo(TAG, `getPhoneVolumeWindowRect w:${volumeRect.width}, h:${volumeRect.height}`);
    return volumeRect;
  }

  private checkHalfFolded(): void {
    if (this.foldStatus === display.FoldStatus.FOLD_STATUS_HALF_FOLDED && this.isDisplayLand()) {
      this.isHalfFoldStatus = true;
    } else {
      this.isHalfFoldStatus = false;
    }
    log.showInfo(TAG, `foldStatusChange = ${this.isHalfFoldStatus} ${this.foldStatus} ${this.rotateAngle}`);
  }

  /**
   * 设置热区区域, 单位:px
   * @param x left 热区水平方向起始点
   * @param y top 热区垂直方向起始点
   * @param width 热区宽度
   * @param height 热区高度
   */
  public updateVolumeResponseRegin(x: number, y: number, width: number, height: number): void {
    if (this.sysSceneSession) {
      this.sysSceneSession.setResponseRegion([{ x: x, y: y, width: width, height: height}]);
      log.showInfo(TAG, `updateVolumeResponseRegin ${x} ${y} ${width} ${height}`);
    }
  }

  public updateVolumeResponseReginWithUiContext(x: number, y: number, width: number, height: number): void {
    ArkUIAdapter.runWithScope(() => {
      this.updateVolumeResponseRegin(x, y, width, height);
    })
  }

  /**
   * 是否展示音量条窗口
   * @returns
   */
  public isShowVolumeWindow(): boolean {
    return this.isVolumeWindowShowing && ViewManagerPolicy.isViewShowing(ViewType.VOLUME);
  }

}
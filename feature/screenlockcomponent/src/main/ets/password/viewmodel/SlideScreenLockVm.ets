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

import {
  LogDomain,
  LogHelper,
} from '@ohos/basicutils';
import {
  DeviceHelper,
  HiDfxEventUtil,
  sEventManager,
  obtainLocalEvent,
  ScreenStateMonitor,
  ScreenOrientation,
  ViewManagerPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import {
  KeyguardStatusService,
  PowerUtils,
  ScreenLockToDesktopConsts,
  slClockOneShotToDesktopService,
  GlobalStatusCache,
  SlUnlockReportHelper,
  ScreenLockStateManager,
  OccludedStateManager,
  LockState,
  KeyGuardMode,
  ClockOneShortConsts
} from '@ohos/screenlockcommon';
import Constants from '../../common/Constants';
import display from '@ohos.display';
import { DeviceState } from '@ohos/launchercommon';
import type { Callback } from '@ohos.base';
import { BlurFreezeScene, ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { slUiStateMgr } from '@ohos/screenlockcommon/src/main/ets/manager/ScreenLockUiStateManager';
import { SlBindStateType, SlMainStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { SlAnimScene } from '../../common/anim/SlAnimConstants';
import { ScreenLockFsmProxy } from '@ohos/screenlockcommon/src/main/ets/fsm/ScreenLockFsmProxy';
import { AodSlideAdapter } from '../../adapter/AodSlideAdapter';
import ScreenLockKeyboardTipUtil from '../../common/ScreenLockKeyboardUtil';

const TAG = 'SlideScreenLockVM';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.KG, TAG);

// min unlock sliding distance
const SLIDING_LENGTH = 10;

const FIRST_SLIDING_DISTANCE = 180;

const SECOND_SLIDING_DISTANCE = 300;

const ZOOM_RATE_OF_CHANGE: number = 3000;

const DOWN_SHIFT_CHANGE_RATE = 10;

const WALLPAPER_SCALE_CHANGE_RATE: number = 3000;

const BLUR_RADIUS_FIRST_CHANGE_RATE = 4;

const BLUR_RADIUS_COMPENSATION_COEFFICIENT = 45;

const BLUR_RADIUS_SECOND_CHANGE_RATE = 2;

const VIEW_OPACITY_CHANGE_RATE = 2;

const ZOOM_RATIO = 1.1;

const DOWN_SHIFT = 30;

const BLUR_RADIUS = 103;

const VIEW_OPACITY: number = 150;

const TWO_FINGERS = 2;
// 捏合手势的捏合距离需要大于72vp
const VALID_PINCH_GESTURE_DISTANCE = 72;

const FINGER_SQRT_2: number = 2;
// 屏幕中线位置比例
const SCREEN_MIDDLE_PERCENT: number = 0.5;
// 大折叠密码宽度比例
const BIG_FOLD_GRID_PERCENT = 0.5;
// 三折叠G态横屏, 锁屏滑动宫格比例
const THREE_FOLD_G_LANDSCAPE_GRID_PERCENT = 1 / 3;

const DEFALUT_ANIMATION_DURING: number = 1000;

/**
 * touch type
 */
export enum SlideTouchType {
  TOUCH_UNLOCK = 0,
  TOUCH_AOD_UNLOCK = 1,
  TOUCH_USER = 2,
  TOUCH_TOOLS = 3,
  TOUCH_NOTIFICATION = 4,
  TOUCH_RESPONSE = 5,
  TOUCH_CAMERA = 6
}

export enum PinchGestureActionType {
  ACTION_START,
  ACTION_UPDATE,
  ACTION_END
}

/**
 * ViewModel
 *
 * @since 2022-05-25
 */
export default class SlideScreenLockVm {
  private resetAnimation: Function = () => {};
  private slideAnimation: Function = () => {};
  private slideToPwdInput: Function = () => {};

  private pinchOutward: boolean = false;
  private pinchGesStartFingerDistance: number = 0;
  private hasShowedThemeEditor: boolean = false;

  private hasTouchDown: boolean = false;

  private slBindState?: ISlState; // 锁屏主页面状态

  private isSliding: boolean = false; // 滑动中标记

  private isOneShotAvaiOnMove: boolean = false; // 滑动时，是否支持时钟一镜到底动效
  private slideDistance: number = 0;
  private unlockStartX: number = 0;
  private unlockStartY: number = 0;
  private firstTouchId: number = 0;
  private clearFreezeTimerId: number = -1;
  private readonly _fsmProxy: ScreenLockFsmProxy;
  private readonly _aodSlideAdapter: AodSlideAdapter;

  constructor(persisId: number) {
    this._fsmProxy = ScreenLockFsmProxy.getInstance(persisId);
    this._aodSlideAdapter = new AodSlideAdapter(this._fsmProxy);
  }

  viewModelInit(
    resetAnimation: Function,
    slideAnimation: Function,
    slideToPwdInput: Function
  ): void {
    log.showInfo('ViewModelInit');
    this.serviceInit();
    this.resetAnimation = resetAnimation;
    this.slideAnimation = slideAnimation;
    this.slideToPwdInput = slideToPwdInput;
  }

  serviceInit(): void {
    log.showInfo('monitorEvents serviceInit');
    slClockOneShotToDesktopService.init();
  }

  viewModelDestroy(): void {
    log.showInfo('viewModelDestroy');
    slClockOneShotToDesktopService.destroy();
  }

  /**
   * deal with touch event
   *
   * @param event touch event
   * @param type touch type
   */
  public handleTouchEvent(event: TouchEvent, type: SlideTouchType): void {
    this.handleTouchEventStart(event);

    switch (type) {
      case SlideTouchType.TOUCH_UNLOCK:
        this.unlockEvent(event);
        break;
      case SlideTouchType.TOUCH_AOD_UNLOCK:
        this.unlockAodEvent(event);
        break;
      default:
        break;
    }

    this.handleTouchEventEnd(event, type);
  }

  private handleTouchEventStart(event: TouchEvent): void {
    if (event.type === TouchType.Down) {
      // 处理Touch事件开始，如果是Down事件，则设置标识
      this.handleTouchEventStartDetail(event);
    }
    if (this.hasTouchDown === false && event.type === TouchType.Move) {
      // Move事件的前提是有Down事件，如果缺失Down事件，则把第一次的Move事件模拟为Down事件
      event.type = TouchType.Down;
      this.handleTouchEventStartDetail(event);
    }
  }

  private handleTouchEventStartDetail(event: TouchEvent): void {
    this.hasTouchDown = true;
    this.unlockStartX = event.touches[0]?.screenX;
    this.unlockStartY = event.touches[0]?.screenY;
    let isOneShotAvaiOnMove = slClockOneShotToDesktopService.isClockOneShotAnimAvailable();
    if (isOneShotAvaiOnMove !== this.isOneShotAvaiOnMove || event.type === TouchType.Down) {
      log.showInfo(`isOneShotAvaiOnMove: ${isOneShotAvaiOnMove}`);
    }
    this.isOneShotAvaiOnMove = isOneShotAvaiOnMove;
  }

  private handleTouchEventEnd(event: TouchEvent, type: SlideTouchType): void {
    if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      this.resetTouchStatus();
      if (type === SlideTouchType.TOUCH_UNLOCK) {
        this.clearBgBlurFreeze();
      }
    }
  }

  /**
   * Touch事件结束，重置标识
   */
  resetTouchStatus(): void {
    log.showDebug(`resetTouchStatus`);
    this.hasTouchDown = false;
    this.isOneShotAvaiOnMove = false;
  }

  /**
   * 滑动事件中move事件是否需要打印日志
   */
  protected showInfo(message: string, event: TouchEvent): void {
    if (event?.type !== TouchType.Move) {
      log.showInfo(message);
    }
  }
  protected handleEventMove(event: TouchEvent): void {
    // 多指过滤
    if (this.firstTouchId !== event.touches[0]?.id) {
      log.showInfo('invalid unlockEvent by move');
      return;
    }
    let moveX = event.touches[0]?.screenX - this.unlockStartX;
    let moveY = event.touches[0]?.screenY - this.unlockStartY;
    this.slideDistance = Math.sqrt(moveX * moveX + moveY * moveY);
    log.showDebug(`unlockEvent, the slideDistance is ${this.slideDistance}`);

    if (this.isSupportSlide()) {
      // 根据滑动距离设置缩放比例、下移幅度、模糊半径、透明度
      let scale: number;
      let offset: number;
      let blur: number;
      let opacity: number;
      let wallpaperScale: number;
      let progress: number = 1.0;
      if (this.slideDistance < FIRST_SLIDING_DISTANCE) {
        scale = Constants.DEFAULT_ZOOM_RATIO + this.slideDistance / ZOOM_RATE_OF_CHANGE;
        offset = this.slideDistance / DOWN_SHIFT_CHANGE_RATE;
        blur = this.isUnlockWithoutPwd() ? 0 : this.slideDistance / BLUR_RADIUS_FIRST_CHANGE_RATE;
        opacity = this.slideDistance / VIEW_OPACITY_CHANGE_RATE;
        wallpaperScale = Constants.DEFAULT_WALLPAPER_SCALE - this.slideDistance / WALLPAPER_SCALE_CHANGE_RATE;
        progress = this.slideDistance / SECOND_SLIDING_DISTANCE;
      } else if (FIRST_SLIDING_DISTANCE < this.slideDistance && this.slideDistance < SECOND_SLIDING_DISTANCE) {
        scale = Constants.DEFAULT_ZOOM_RATIO + this.slideDistance / ZOOM_RATE_OF_CHANGE;
        offset = this.slideDistance / DOWN_SHIFT_CHANGE_RATE;
        let tmp = this.slideDistance / BLUR_RADIUS_SECOND_CHANGE_RATE - BLUR_RADIUS_COMPENSATION_COEFFICIENT;
        blur = this.isUnlockWithoutPwd() ? 0 : tmp;
        opacity = this.slideDistance / VIEW_OPACITY_CHANGE_RATE;
        wallpaperScale = Constants.DEFAULT_WALLPAPER_SCALE - this.slideDistance / WALLPAPER_SCALE_CHANGE_RATE;
        progress = this.slideDistance / SECOND_SLIDING_DISTANCE;
      } else {
        scale = ZOOM_RATIO;
        offset = DOWN_SHIFT;
        blur = this.isUnlockWithoutPwd() ? 0 : BLUR_RADIUS;
        opacity = VIEW_OPACITY;
        wallpaperScale = Constants.MIN_SCENE_SCALE;
      }
      this.handSlideAnimation(scale, offset, blur, opacity, wallpaperScale, progress);
    }
  }

  private handSlideAnimation(scale: number, offset: number, blur: number, opacity: number, wallpaperScale: number,
    progress: number): void {
    // 通过slideDistance最小距离屏蔽误触和长按
    if (this.slideDistance < SLIDING_LENGTH) {
      return;
    }
    // 前面已经有过滤多指的逻辑，但是没有完全过滤掉，会有move事件下来，测试发现，此时slideDistance距离基本为0，暂时通过设置条件slideDistance大于0，满足条件
    if (this.isUnlockWithoutPwd() && this.isOneShotAvaiOnMove && this.slideDistance > 0) {
      slClockOneShotToDesktopService.notifyPrepareForOneShotAnimOnFirstMove();
      this.slideAnimation(scale, offset, blur, opacity, wallpaperScale, this.slideDistance, true, progress);
    } else {
      this.slideAnimation(scale, offset, blur, opacity, wallpaperScale, 0, false, progress);
    }
    if (this.clearFreezeTimerId != -1) {
      clearTimeout(this.clearFreezeTimerId);
    }
  }

  /**
   * 是否处于跟手滑动动效中
   *
   * @returns 是否处于跟手滑动动效中
   */
  public isSlideAnimating(): boolean {
    return this.isSliding;
  }

  private handleEventDown(event: TouchEvent): void {
    this.firstTouchId = event.touches[0]?.id;
  }

  private handleEventUp(event: TouchEvent): void {
    // 多指过滤
    if (event.touches[0]?.id !== this.firstTouchId) {
      log.showInfo('invalid unlockEvent by up or cancel');
      this.resetSlide();
      return;
    }
    if (!this.hasTouchDown) {
      log.showInfo('invalid unlockEvent by without down event');
      return;
    }

    let deltaX = event.touches[0]?.screenX - this.unlockStartX;
    let deltaY = event.touches[0]?.screenY - this.unlockStartY;
    let distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);
    this.setSlideDistance(distance);
    // 若滑动距离达到要求 或者本次滑动是双指捏合手势
    if (distance > 0) {
      log.showInfo(`SlideEnd eventType: ${event.type}, distance: ${distance}, dx: ${deltaX}, dy: ${deltaY}`);
    }
    if (distance > Constants.SLIDING_LENGTH && !this.isDropDownAbovekeyguard() && !this.isUnknownLockState()) {
      SlUnlockReportHelper.getInstance().recordUnlockStartTime();
      HiDfxEventUtil.reportStartUnlockEvent();
      if (this.isUnlockWithoutPwd()) {
        log.showInfo('UNLOCK_DIRECT');
        slClockOneShotToDesktopService
          .requestDirectUnlock(ScreenLockToDesktopConsts.SLIDE_UP_TO_DESKTOP_CLOCK_ANIMATION);
      } else {
        let keyboardPosition: number = this.calculateKeyboardPosition(this.unlockStartX, event.touches[0]?.screenX);
        this.slideToPwdInput(keyboardPosition);
      }
    } else {
      log.showDebug('reset');
      this.resetSlide();
    }
  }


  private isDropDownAbovekeyguard(): boolean {
    if (OccludedStateManager.getInstance().isDropdownOccluded) {
      let dropDownIndex = ViewManagerPolicy.getZIndex(ViewType.DROPDOWN);
      let keyguardIndex = ViewManagerPolicy.getZIndex(ViewType.KEYGUARD);
      if (dropDownIndex && keyguardIndex && dropDownIndex > keyguardIndex) {
        return true;
      }
    }
    return false;
  }

  unlockEvent(event: TouchEvent): void {
    if (!this.checkSlideTouchState(event)) {
      return;
    }
    if (event.type === TouchType.Move) {
      log.showDebug(`Touch Event ${event.type} at Point ${event.touches[0]?.x}, ${event.touches[0]?.y}`);
    } else {
      log.showInfo(`Touch Event ${event.type}`);
    }
    if (event.type === TouchType.Move) {
      this.handleEventMove(event);
    } else if (event.type === TouchType.Down) {
      this.handleEventDown(event);
    } else if (event.type === TouchType.Up) {
      this.handleEventUp(event);
    } else {
      this.resetSlide();
    }
    event.stopPropagation();
  }

  private clearBgBlurFreeze(): void {
    if (this.clearFreezeTimerId != -1) {
      clearTimeout(this.clearFreezeTimerId);
    }
    if (this.isSliding) {
      this.clearFreezeTimerId = setTimeout(() => {
        clearTimeout(this.clearFreezeTimerId);
        this.clearFreezeTimerId = -1;
        this.setSlidState(false, true);
      }, DEFALUT_ANIMATION_DURING);
    }
  }

  unlockAodEvent(event: TouchEvent): void {
    if (!this.checkSlideTouchState(event)) {
      return;
    }
    if (!this.hasTouchDown) {
      return;
    }
    log.showDebug(`unlockAodEvent Aod Touch Event ${event.type} at Point ${event.touches[0]?.x}, ${event.touches[0]?.y}`);
    if (event.type === TouchType.Up) {
      let deltaX = event.touches[0]?.screenX - this.unlockStartX;
      let deltaY = event.touches[0]?.screenY - this.unlockStartY;
      let distance = Math.sqrt(deltaX * deltaX + deltaY * deltaY);

      log.showInfo(`unlockAodEvent distance: ${distance}`);
      if (distance > Constants.SLIDING_LENGTH && Math.abs(deltaY) > Math.abs(deltaX)) {
        PowerUtils.wakeupDeviceInFakeAod(PowerUtils.WAKEUP_DETAIL_AOD_SLIDE_UNLOCK);
        if (this.isUnlockWithoutPwd() && slClockOneShotToDesktopService.isClockAodToDesktopAnimAvailable()) {
          slClockOneShotToDesktopService
            .requestDirectUnlock(ClockOneShortConsts.AOD_TO_DESKTOP_CLOCK_ANIMATION);
        } else {
          this._aodSlideAdapter.handleAodSlide();
        }
      }
    }
    event.stopPropagation();
  }

  protected checkSlideTouchState(event: TouchEvent): boolean {
    if (!this.isSupportSlide()) {
      log.showInfo('not support slide');
      return false;
    }
    // 多指过滤(双指捏合不限制)
    if (event.touches.length > 1) {
      this.showInfo('checkSlideTouchState, invalid unlockEvent with polyfinger', event);
      this.resetSlide();
      return false;
    }
    let isQuickToolsUsing = GlobalStatusCache.getInstance().getStatus('quickToolsIsToolsUsing', false) as boolean;
    if (isQuickToolsUsing) {
      this.showInfo('quick tools using', event);
      return false;
    }
    return true;
  }

  private resetSlide(): void {
    this.setSlideDistance(0);
    this.resetAnimation();
    this.resetOneShotAnimation();
  }

  private resetOneShotAnimation(): void {
    if (this.isUnlockWithoutPwd() && this.isOneShotAvaiOnMove) {
      sEventManager.publish(obtainLocalEvent(ScreenLockToDesktopConsts.SLIDE_UP_TO_RESET_CLOCK_ANIMATION, false));
    }
  }
  protected calculateKeyboardPosition(touchStartPositionX: number, touchEndPositionX: number): number {
    // 若是直板机或者是折叠主屏显示,或特殊模式场景,默认返回SCREEN_MIDDLE
    if ((!AppStorage.has('folderStatus') || AppStorage.get<number>('folderStatus') === DeviceState.FOLDED_STATE) &&
      !DeviceHelper.isSmallFoldProduct() || KeyguardStatusService.isSpecialMode()) {
      return Constants.NO_TOUCH_OR_SCREEN_MIDDLE;
    }
    let displayWidth: number = 0;
    try {
      displayWidth = px2vp(display.getDefaultDisplaySync().width);
    } catch (error) {
      log.showError('calculateKeyboardPosition getDefaultDisplaySync fail');
    }
    let gridLeftPosPercent: number;
    if (DeviceHelper.isThreeFoldProduct() && DeviceHelper.isGState()) {
      if (ScreenStateMonitor.getInstance().getCurrentScreenStateModel().orientation === ScreenOrientation.LANDSCAPE) {
        gridLeftPosPercent = THREE_FOLD_G_LANDSCAPE_GRID_PERCENT;
      } else {
        const keyboardWidthPercent: number = ScreenLockKeyboardTipUtil.getGStateKeyboardWidthPercent(displayWidth,
          false);
        gridLeftPosPercent = this.getGridPosByKeyboardWidth(keyboardWidthPercent);
      }
    } else {
      gridLeftPosPercent = this.getGridPosByKeyboardWidth(BIG_FOLD_GRID_PERCENT);
    }
    log.showInfo(`calculate keyboard position, the startX = ${touchStartPositionX}, the endX = ${touchEndPositionX}, ` +
      `displayWidth = ${displayWidth} gridLeftPosPercent = ${gridLeftPosPercent}`);
    return this.getKeyboardPosByGrid(touchStartPositionX, touchEndPositionX, displayWidth * gridLeftPosPercent,
      displayWidth * (1 - gridLeftPosPercent));
  }

  /**
   * 根据滑动位置和宫格左右位置, 计算出密码盘位置
   *
   * @param touchStartPositionX 滑动起始坐标
   * @param touchEndPositionX 滑动结束坐标
   * @param gridLeftPos 宫格左侧位置
   * @param gridRightPos 宫格右侧位置
   * @returns 密码盘位置
   */
  private getKeyboardPosByGrid(touchStartPositionX: number, touchEndPositionX: number, gridLeftPos: number,
    gridRightPos: number): number {
    // 起点和终点都小于宫格左侧,返回SCREEN_LEFT
    if (touchStartPositionX < gridLeftPos && touchEndPositionX < gridLeftPos) {
      return Constants.SCREEN_LEFT;
    }
    // 起点和终点都大于宫格右侧,返回SCREEN_RIGHT
    if (touchStartPositionX > gridRightPos && touchEndPositionX > gridRightPos) {
      return Constants.SCREEN_RIGHT;
    }
    // 其他的返回NO_TOUCH_OR_SCREEN_MIDDLE
    return Constants.NO_TOUCH_OR_SCREEN_MIDDLE;
  }

  /**
   * 计算锁屏滑动宫格尺寸
   *
   * @param keyboardWidthPercent 密码盘宽度占比
   * @returns 宫格左边的X坐标
   */
  private getGridPosByKeyboardWidth(keyboardWidthPercent: number): number {
    // 三折叠G态竖屏、M态，以及双折叠展开态下, 在锁屏滑动时, 如果滑动起点、终点都位于宫格内，则密码盘显示在中间
    // 宫格计算方法：分别取左、中、右密码盘中心点，左中心点和中中心点连线的中点为宫格左侧坐标， 宫格右侧坐标与左坐标基于中线对称
    // 根据密码盘宽度的比例，计算出宫格左侧的X坐标
    return SCREEN_MIDDLE_PERCENT - (SCREEN_MIDDLE_PERCENT - keyboardWidthPercent / 2) / 2;
  }

  private isSupportSlide(): boolean {
    // todo根据状态机状态返回是否支持滑动，主要锁屏态和解锁态才支持滑动
    return true;
  }

  pinchGestureEvent(event: GestureEvent, type: PinchGestureActionType, callback: Callback<void>): void {
    if (event.fingerList.length !== TWO_FINGERS) {
      log.showInfo('onPinchGesture, finger more than 2');
      return;
    }
    const fingerDistance = this.pinchFingerDistance(event.fingerList[0], event.fingerList[1]);
    if (type !== PinchGestureActionType.ACTION_UPDATE) {
      log.showInfo(`pinchGestureEvent, type = ${type}, fingerDistance = ${fingerDistance}`);
    }
    switch (type) {
      case PinchGestureActionType.ACTION_START:
        this.pinchOutward = false;
        this.hasShowedThemeEditor = false;
        this.pinchGesStartFingerDistance = fingerDistance;
        break;
      case PinchGestureActionType.ACTION_UPDATE:
        if (fingerDistance > this.pinchGesStartFingerDistance) {
          if (!this.pinchOutward) {
            log.showInfo(`pinchGestureEvent, pinchOutward = true type = ${type}, fingerDistance = ${fingerDistance}`);
          }
          this.pinchOutward = true;
          break;
        }
        if (!this.pinchOutward && !this.hasShowedThemeEditor) {
          this.hasShowedThemeEditor = true;
        }
        let distanceDiff: number = this.pinchGesStartFingerDistance - fingerDistance;
        if (!this.pinchOutward && (distanceDiff > VALID_PINCH_GESTURE_DISTANCE)) {
          log.showInfo(`pinchGestureEvent, callback type = ${type}, fingerDistance = ${fingerDistance}`);
          callback();
        }
        break;
      case PinchGestureActionType.ACTION_END:
        this.pinchOutward = false;
        this.pinchGesStartFingerDistance = 0;
        this.hasShowedThemeEditor = false;
        break;
      default:
        break;
    }
  }

  protected pinchFingerDistance(fingerLeft: FingerInfo, fingerRight: FingerInfo): number {
    if (!fingerLeft || !fingerRight) {
      return 0;
    }
    return Math.sqrt(Math.pow(fingerLeft.globalX - fingerRight.globalX, FINGER_SQRT_2) +
    Math.pow(fingerLeft.globalY - fingerRight.globalY, FINGER_SQRT_2));
  }

  public setSlidState(isSliding: boolean, isTimeOut: boolean = false): void { // 滑动解锁状态
    if (this.isSliding === isSliding) {
      return;
    }
    if (isTimeOut) {
      log.showWarn(`setSlidState reset isSliding time out`);
    }
    // 滑动过程中冻结模糊
    this.isSliding = isSliding;
    let freeze: BlurFreezeScene = { isFreeze: isSliding, scene: SlAnimScene.SCENE_SLID_TOUCHING };
    this.getSlBindState()?.setSlState(SlBindStateType.BG_BLUR_FREEZE, freeze);
  }

  protected getSlBindState(): ISlState | undefined { // 锁屏主页面状态
    if (!this.slBindState) {
      this.slBindState = slUiStateMgr.getSlState(SlMainStateType.SL_BIND_STATE);
    }
    return this.slBindState;
  }

  private setSlideDistance(distance: number): void {
    this.slideDistance = distance;
    AppStorage.setOrCreate('slidingDistance', distance);
  }

  private isUnknownLockState(): boolean {
    return ScreenLockStateManager.getInstance().lockStateInfo.lockState === LockState.NONE;
  }

  private isUnlockWithoutPwd(): boolean {
    return !ScreenLockStateManager.getInstance().isLocked;
  }
}
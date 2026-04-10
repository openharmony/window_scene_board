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

import { ActionType, FourFingersSwipe } from '@kit.InputKit';
import { LogDomain, LogHelper, SingleBase, SingleContext, singleManager } from '@ohos/basicutils';
import { PageDesktopViewModelForPC } from '@ohos/launchercommon';
import { DeviceHelper, viewMgrPolicy, ViewType, HiSysEventUtil } from '@ohos/frameworkwrapper';
import { SwipeGestureDirection } from '@ohos/pcmode';
import { DesktopModifier } from '../ui/modifier/DesktopModifier';
import { curves } from '@kit.ArkUI';
import { multiInputManager } from '@ohos/multiinput';
import { PageDesktopGridStyleConfig, PageDesktopViewModel } from '@ohos/pagedesktop';
import FeatureConstants from '@ohos/pagedesktop/src/main/ets/default/common/constants/FeatureConstants';
import PcPresetStyleConstants from './constants/PcPresentConstants';
import { FourFingerSwipeEvent } from '../SceneBoard/virtualmachine/FourFingerSwipeEvent';

const TAG: string = 'FoldSwiperController';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const MIN_MOVE_SPEED: number = 0.95;
// super fold切换桌面需滑动最小距离
const SWIPER_DISTANCE = 52;
const REPORT_SHORTCUT_KEY: number = 1;
const REPORT_PAN_GESTURE: number = 2;

/**
 * 折叠PC桌面滑动管理
 */
export class FoldSwiperController extends SingleBase {
  public static singleName: string = 'FoldSwiperController';
  private moveState: SwipeMoveState;
  private mPageState: SwiperPageState;
  private mDesktopModifier: DesktopModifier;
  private mPageIndicatorModifier: DesktopModifier;
  private isLock: boolean = false;
  // 移动开始前页面状态
  private mPrePageState: SwiperPageState;
  // 滑动一次需要移动的距离
  private swiperOnceDistance: number;
  private curMoveY: number = 0;
  private indicatorCurMoveY: number = 0;
  private startFingerTouch: boolean = false;
  // 是否多模注册组合按键
  private hasRegisteredCombKey: boolean = false;

  public constructor(ctx?: SingleContext) {
    super(ctx);
    this.moveState = new SwipeMoveState();
    this.mPageState = SwiperPageState.FULL_EXPAND;
    this.mPrePageState = SwiperPageState.FULL_EXPAND;
    this.swiperOnceDistance = 0;
    this.mDesktopModifier = new DesktopModifier();
    this.mPageIndicatorModifier = new DesktopModifier();
  }

  public static getInstance(ctx?: SingleContext): FoldSwiperController {
    return singleManager.get<FoldSwiperController>(FoldSwiperController, ctx);
  }

  public getMoveState(): SwipeMoveState {
    return this.moveState;
  }

  public isVerticalMove(): boolean {
    return this.moveState.isVerticalMove();
  }

  public setDesktopModifier(modifier: DesktopModifier): void {
    this.mDesktopModifier = modifier;
  }

  public setSwitchPageModifier(modifier: DesktopModifier): void {
    this.mPageIndicatorModifier = modifier;
  }

  public setSwiperOnceDistance(distance: number): void {
    this.swiperOnceDistance = distance;
  }

  public updateLockState(isLock: boolean): void {
    this.isLock = isLock;
  }

  public registerSwitchPageEvent(): void {
    log.showWarn(`registerSwitchPageEvent hasRegistered: ${this.hasRegisteredCombKey}`);
    if (this.hasRegisteredCombKey) {
      return;
    }
    multiInputManager.registerSwitchPageEvent((isUp: boolean) => {
      log.showInfo(`switch page event come, isUp: ${isUp}`);
      HiSysEventUtil.reportSwipePage(REPORT_SHORTCUT_KEY);
      this.switchDesktop(isUp);
    });
    this.hasRegisteredCombKey = true;
  }

  public unRegisterSwitchPageEvent(): void {
    log.showInfo(`unRegisterSwitchPageEvent hasRegistered: ${this.hasRegisteredCombKey}`);
    if (this.hasRegisteredCombKey) {
      multiInputManager.unRegisterSwitchPageEvent();
      this.hasRegisteredCombKey = false;
    }
  }

  public canSwipeChange(): boolean {
    // 是否锁屏
    if (this.isLock) {
      log.showWarn('can not SwipeChange , Locked');
      return false;
    }
    // 是否应用中心/任务中心显示
    if (viewMgrPolicy.isViewShowing(ViewType.APP_CENTER) || (AppStorage.get('showRecent'))) {
      log.showWarn('can not SwipeChange , in appCenter or recent');
      return false;
    }
    // 是否为键盘态
    if (this.mPageState === SwiperPageState.FULL_EXPAND || this.mPageState === SwiperPageState.HALF_FOLDED) {
      log.showInfo('can not SwipeChange, is no keyboard');
      return false;
    }
    return true;
  }

  public switchPages(type: ActionType, event?: GestureEvent) {
    if (!this.canSwipeChange()) {
      return;
    }
    if (!event) {
      return;
    }
    if ((type === ActionType.BEGIN || type === ActionType.UPDATE) && event.fingerList.length !== 1) {
      log.showInfo(`finger count ${event.fingerList.length}, can not start switch page`);
      return;
    }
    if (this.isLeftMousePress(event)) {
      log.showDebug('can not swipe page by left mouse press');
      return;
    }
    if (event.axisVertical !== undefined && this.isMouseScroll(event)) {
      log.showDebug(`swipe page by Scroll axisVertical ${event?.axisVertical},axisHorizontal ${event?.axisHorizontal}`);
      this.switchDesktop(event.axisVertical > 0)
      return;
    }
    const gesture: FourFingersSwipe = {
      x: event.offsetX,
      y: event.offsetY,
      type: type
    }
    this.updateMoveState(gesture);
  }

  private isLeftMousePress(event: GestureEvent): boolean {
    return event.source === SourceType.Mouse && event.sourceTool == SourceTool.MOUSE &&
      event?.axisVertical === 0 && event?.axisHorizontal === 0;
  }

  private isMouseScroll(event: GestureEvent): boolean {
    return event.source === SourceType.Mouse && event.sourceTool == SourceTool.MOUSE &&
      (event?.axisVertical !== 0 || event?.axisHorizontal !== 0);
  }

  public updateMoveState(gesture: FourFingersSwipe): void {
    log.showDebug(`updateMoveState: ${gesture.type}`);
    switch (gesture.type) {
      case ActionType.BEGIN:
        this.startFingerTouch = true;
        this.moveState.reset();
        break;
      case ActionType.UPDATE:
        this.moveState.updateMoveState(gesture);
        const direction: SwipeGestureDirection = this.moveState.getFinalDirection();
        if ((this.startFingerTouch) && ((this.mPageState === SwiperPageState.PAGE_SHOW_UPPER && direction ===
        SwipeGestureDirection.DOWN) || (this.mPageState === SwiperPageState.PAGE_SHOW_LOWER && direction ===
        SwipeGestureDirection.UP))) {
          // 跟手移动
          this.mDesktopModifier?.attribute?.offset({
            x: 0,
            y: this.curMoveY + this.moveState.getFinalVerticalDistance()
          });
          this.mPageIndicatorModifier?.attribute?.offset({
            x: 0,
            y: this.indicatorCurMoveY - this.moveState.getIndicatorFinalVerticalDistance()
          });
        }
        break;
      case ActionType.END:
        log.showInfo(`updateMoveState END: ${this.moveState.getFinalVerticalLength()}, this.mPrePageState: ${this.mPrePageState}`);
        // 移动超过距离预置，判定翻页成功或返回
        if (this.startFingerTouch && (this.moveState.getFinalVerticalLength() > SWIPER_DISTANCE ||
          this.moveState.isSpeedValid())) {
          // 合理移动区间，翻页
          HiSysEventUtil.reportSwipePage(REPORT_PAN_GESTURE);
          this.switchDesktop(this.moveState.getFinalDirection() === SwipeGestureDirection.UP);
        } else {
          this.swiperAnimation();
        }
        log.showInfo(`updateMoveState mPageState: ${this.mPageState}`);
        this.startFingerTouch = false;
        break;
      case ActionType.CANCEL:
        this.mPageState = this.mPrePageState;
        this.swiperAnimation();
        this.startFingerTouch = false;
        break;
      default:
        break;
    }
  }

  /**
   * 切换桌面
   * @param isUp 是否向上翻到B面
   */
  public switchDesktop(isUp: boolean): void {
    log.showInfo(`switchDesktop: ${isUp}`);
    if (!this.canSwipeChange()) {
      log.showWarn('can not swipe');
      return;
    }
    // 合理移动区间，翻页
    if (this.mPrePageState === SwiperPageState.PAGE_SHOW_UPPER && !isUp) {
      this.mPageState = SwiperPageState.PAGE_SHOW_LOWER;
      PageDesktopViewModelForPC.getInstance().setKeyBoardStatus(FeatureConstants.KEYBOARD_PAGE_C, TAG);
    }
    if (this.mPrePageState === SwiperPageState.PAGE_SHOW_LOWER && isUp) {
      this.mPageState = SwiperPageState.PAGE_SHOW_UPPER;
      PageDesktopViewModelForPC.getInstance().setKeyBoardStatus(FeatureConstants.KEYBOARD_PAGE_B, TAG);
    }
    this.mPrePageState = this.mPageState;
    log.showInfo(`updateMoveState mPageState: ${this.mPageState}`);
    this.swiperAnimation();
  }

  private swiperAnimation(): void {
    const offsetY: number = (this.mPageState === SwiperPageState.PAGE_SHOW_LOWER) ? -this.swiperOnceDistance : 0;
    const swiperIndicatorOnceDistance: number = (this.mPageState === SwiperPageState.PAGE_SHOW_LOWER) ?
      PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT - PcPresetStyleConstants.DEFAULT_INDICATOR_MARGIN * 2 -
      PcPresetStyleConstants.DEFAULT_INDICATOR_SWIPER_HEIGHT : 0;
    log.showInfo(`updateMoveState offsetY: ${offsetY}`);
    animateTo({
      duration: 200,
      curve: curves.interpolatingSpring(0.5, 1, 228, 30)
    }, () => {
      this.mDesktopModifier?.attribute?.offset({ x: 0, y: offsetY });
      this.curMoveY = offsetY;
      this.mPageIndicatorModifier?.attribute?.offset({ x: 0, y: swiperIndicatorOnceDistance });
      this.indicatorCurMoveY = swiperIndicatorOnceDistance;
    });
  }
}

class SwipeMoveState {
  private startEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private preEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private curEvent: FourFingerSwipeEvent = new FourFingerSwipeEvent();
  private curDirection: SwipeGestureDirection = SwipeGestureDirection.NONE;
  private initDirection: SwipeGestureDirection = SwipeGestureDirection.NONE;
  private curSpeed: number = 0;

  public updateMoveState(gesture: FourFingersSwipe): void {
    const curX: number = gesture.x;
    const curY: number = gesture.y;
    if (this.startEvent.x === -1) {
      this.startEvent.set(curX, curY, Date.now());
      this.preEvent.set(curX, curY, Date.now());
      this.curEvent.set(curX, curY, Date.now());
      this.curSpeed = 0;
      return;
    }

    if (Math.abs(curY - this.preEvent.y) >= Math.abs(curX - this.preEvent.x)) {
      this.curDirection = curY < this.preEvent.y ? SwipeGestureDirection.UP : SwipeGestureDirection.DOWN;
      const speed: number = (Math.abs(curY - this.preEvent.y)) / (Date.now() - this.preEvent.timestamp);
      if (typeof speed === 'number') {
        this.curSpeed = speed;
      }
    } else {
      this.curDirection = curX < this.preEvent.x ? SwipeGestureDirection.LEFT : SwipeGestureDirection.RIGHT;
    }
    if (this.initDirection === SwipeGestureDirection.NONE) {
      this.initDirection = this.curDirection;
    }

    this.preEvent.clone(this.curEvent);
    this.curEvent.set(curX, curY, Date.now());
  }

  public getDirection(): SwipeGestureDirection {
    return this.curDirection;
  }

  public getFinalDirection(): SwipeGestureDirection {
    const curY: number = this.curEvent.y;
    return curY > this.startEvent.y ? SwipeGestureDirection.UP : SwipeGestureDirection.DOWN;
  }

  public getInitDirection(): SwipeGestureDirection {
    return this.initDirection;
  }

  /**
   * 竖直方向，移动的长度
   *
   * @returns 正数代表与目标方向相同，负数代表与目标方向相反
   */
  public getFinalVerticalLength(): number {
    return Math.abs(this.curEvent.y - this.startEvent.y);
  }

  /**
   * 在竖直方向，自然位移
   *
   * @returns 正数代表向右，负数代表向左
   */
  public getFinalVerticalDistance(): number {
    return this.curEvent.y - this.startEvent.y;
  }

  /**
   * 导航器对应移动的距离
   */
  public getIndicatorFinalVerticalDistance(): number {
    const pageDesktopStyleConfig: PageDesktopGridStyleConfig =
      PageDesktopViewModel.getInstance().getPageDesktopStyleConfig();
    const swiperIndicatorMaxDistance: number = PcPresetStyleConstants.DEFAULT_INDICATOR_BACKGROUND_HEIGHT -
      PcPresetStyleConstants.DEFAULT_INDICATOR_MARGIN * 2 - PcPresetStyleConstants.DEFAULT_INDICATOR_SWIPER_HEIGHT;
    return this.getFinalVerticalDistance() * swiperIndicatorMaxDistance /
      (pageDesktopStyleConfig.mGridHeight + pageDesktopStyleConfig.mFoldCreaseRegionHeight);
  }

  /**
   * 是否发生移动方向翻转
   *
   * @returns
   */
  public directionFlipped(): boolean {
    return (this.curEvent.x - this.startEvent.x) * (this.preEvent.x - this.startEvent.x) < 0;
  }

  public isSpeedValid(): boolean {
    return this.curSpeed > MIN_MOVE_SPEED;
  }

  public isVerticalMove(): boolean {
    return this.curDirection === SwipeGestureDirection.UP || this.curDirection === SwipeGestureDirection.DOWN;
  }

  public reset(): void {
    this.startEvent.reset();
    this.preEvent.reset();
    this.curEvent.reset();
    this.curDirection = SwipeGestureDirection.NONE;
    this.initDirection = SwipeGestureDirection.NONE;
  }
}

/**
 * 折叠页面的状态
 */
export enum SwiperPageState {
  // 完全展开态
  FULL_EXPAND = 0,
  // 折叠态
  HALF_FOLDED,
  // 折叠且B显示
  PAGE_SHOW_UPPER,
  // 折叠且C显示
  PAGE_SHOW_LOWER
}
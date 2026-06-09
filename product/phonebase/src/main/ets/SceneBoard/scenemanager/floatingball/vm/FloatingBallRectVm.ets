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

import { DomainName, LogDomain, Logger, TraceUtil } from '@ohos/basicutils';
import { curves, display, PersistenceV2 } from '@kit.ArkUI';
import { AnimationBase, DeviceInfoVm } from '@ohos/systemuicommon/newIndex';
import { SCBSceneSessionManager, SCBSpecificSession, windowMgr } from '@ohos/windowscene';
import { WindowConstants } from '@ohos/commonconstants';
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { DefaultPanelZIndex } from '@ohos/systemuicommon';
import { Constants, RemoveType } from '../constants/FloatingConstants';
import { IFloatingBallPanelVm } from '../interface/IFloatingBallPanelVm';
import { IFloatingBallRectVm } from '../interface/IFloatingBallRectVm';
import { FloatingBallBaseVm } from './FloatingBallBaseVm';
import { FloatingBallPosition } from '../model/FloatingBallModel';
import { CustomPromise, DeviceHelper } from '@ohos/frameworkwrapper';
import { FloatingBallStyle } from '../constants/FloatingBallStyle';
import { IFloatingBallListVm } from '../interface/IFloatingBallListVm';
import {
  DUMPSTER_PANEL,
  FloatingBallClearAnimation,
  PANEL_CURVE,
  TO_SIDE_CURVE
} from '../animation/FloatingBallAnimation';
import { IFloatingBallInjector } from '../interface/IFloatingBallInjector';

const TAG = 'FloatingBallRectVm';
const log = Logger.getLogHelper(LogDomain.WINDOW);

@ObservedV2
export class FloatingBallRectVm extends FloatingBallBaseVm implements IFloatingBallRectVm {
  public readonly position: FloatingBallPosition = PersistenceV2.connect(FloatingBallPosition,
    () => new FloatingBallPosition())!;

  // 离手速度阈值
  private static readonly X_SPEED_THRESHOLD: number = 1200;
  // 跟手弹簧曲线
  private static readonly MOVE_CURVE: ICurve = curves.responsiveSpringMotion(0.15, 0.86, 0.25);
  private static readonly BOTTOM_AVOID_HEIGHT: number = 12; // 底部导航条避让高度
  private static readonly INPUT_METHOD_AVOID_HEIGHT: number = 16; // 输入法避让高度

  @Trace public containerWidth: number = 0;
  @Trace public containerHeight: number = 0;
  @Trace public inputHeight: number = 0;
  @Trace public screenWidth: number = 0;
  @Trace public screenHeight: number = 0;
  @Trace public scale = 0.25;
  @Trace public scaleCenterX: number | string = '100%';
  @Trace public scaleCenterY: number | string = '50%';
  @Trace public translateX: number = 0;
  @Trace public translateY: number = 0;
  @Trace public blurRadius: number = 0;
  @Trace public isRight: boolean = true;
  @Trace public outerPadding: number = 0;
  @Trace private topAvoidHeight: number = 34;

  public isShowing: boolean = false;
  public isRemoving: boolean = false;
  public isInDelArea: boolean = false;

  private animateMoveCnt: number = 0;
  private moveDisplayX: number = 0;
  private moveDisplayY: number = 0;
  // 挖孔区域信息
  private cutoutRect: display.Rect = { left: 0, top: 0, width: 0, height: 0 };

  constructor(vmInjector: IFloatingBallInjector) {
    log.showInfo(TAG, 'rect vm constructor');
    super(vmInjector);
  }

  public init(): void {
    this.blurRadius = 0;
    this.updateStatusBarHeight();
    this.updateIsRight();
    this.updateCutoutArea();
  }

  @Computed
  public get panelVm(): IFloatingBallPanelVm {
    return this.vmInjector.getPanelVm();
  }

  @Computed
  public get listVm(): IFloatingBallListVm {
    return this.vmInjector.getListVm();
  }

  // 垃圾桶需传入一个specificSession
  private getSpecificSession(): SCBSpecificSession | null {
    // 取列表的第一个specificSession即可
    return this.listVm.floatingBallList[0]?.specificSession;
  }

  public updateStatusBarHeight() {
    const statusBarHeight = windowMgr.getWindowPosition(WindowConstants.WINDOW_NAME_STATUS_BAR).height;
    const topAvoidHeight = ArkUIAdapter.px2vp(statusBarHeight);
    if (topAvoidHeight > 0) {
      this.topAvoidHeight = topAvoidHeight;
    }
  }

  /**
   * 更新位置 vp
   * @param x
   * @param y
   */
  public updatePosition(x: number, y: number, needAvoidTopBottom: boolean = true): void {
    if (!needAvoidTopBottom) {
      this.position.x = x;
      this.position.y = y;
      this.updateIsRight();
      return;
    }
    let newY = y;
    // y轴异常处理
    if (y < 0) {
      log.showInfo(TAG, `updatePosition y < 0`);
      newY = this.topAvoidHeight;
    }
    if (y > this.screenHeight) {
      log.showInfo(TAG, `updatePosition y > screenHeight:${this.screenHeight}`);
      newY = this.screenHeight - FloatingBallRectVm.BOTTOM_AVOID_HEIGHT;
    }
    this.position.x = x;
    this.position.y = newY;
    this.updateIsRight();
    log.showDebug(TAG, `update position, x ${this.position.x}, y ${this.position.y}, cantainer ${this.containerWidth}, right ${this.isRight}`);
  }

  private updateIsRight(): void {
    if (this.position.x + this.containerWidth / 2 > Math.floor(this.screenWidth / 2)) {
      this.isRight = true;
    } else {
      this.isRight = false;
    }
  }

  public updateScreenProperty(screenWidth: number, screenHeight: number): void {
    this.screenWidth = ArkUIAdapter.px2vp(screenWidth);
    this.screenHeight = ArkUIAdapter.px2vp(screenHeight);
    log.showInfo(TAG, `updateScreenProperty ${this.screenWidth} ${this.screenHeight}`);
  }

  public updateInputMethodHeight(inputRealHeight: number): void {
    const isLandscape = DeviceHelper.isLandscape();
    // 仅在竖屏更新，小外屏返回是横屏，但是需要避让
    const height = 0;
    log.showInfo(TAG, `updateInputMethodHeight ${isLandscape} realHeight:${inputRealHeight} h:${height}`);
    this.inputHeight = ArkUIAdapter.px2vp(height);
  }

  /**
   * 悬浮球位置是否覆盖输入法
   * @returns
   */
  public isOverlayInputMethod(): boolean {
    // 组件Y坐标 + 组件高度 > 屏幕高度 - 输入法高度
    return this.position.y + this.containerHeight > this.screenHeight - this.inputHeight;
  }

  /**
   * 组件左下角Y坐标距离底部的高度 vp
   */
  public getDistanceFromLeftBottom(): number {
    // 屏幕高度 - 组件Y坐标 - 组件高度 - 默认避让距离
    return this.screenHeight - this.position.y - this.containerHeight - FloatingBallRectVm.BOTTOM_AVOID_HEIGHT;
  }

  /**
   * 恢复默认位置
   */
  public defaultPosition(posX: number, updatePreviousPosition?: boolean): void {
    let posY = FloatingBallStyle.DEFAULT_POSTION_Y; // 默认80vp
    let edgePosY = posY;
    let edgeHeight = 0;
    posY = edgePosY + edgeHeight + FloatingBallStyle.LENGTH16;
    log.showInfo(TAG, `defaultPosition ${posX} ${posY}`);
    this.updatePosition(posX, posY, false);
    this.avoidCutoutArea();
    if (updatePreviousPosition) {
      this.position.positionX = this.position.x;
      this.position.positionY = this.position.y;
    }
  }

  /**
   * 通过手势事件检查是否显示垃圾箱
   * @param type 手指 0:按下 1:抬起 2:移动 3:取消
   * @param event
   */
  private onDumpsterGestureChange(type: TouchType, event?: GestureEvent): void {
    if (SCBSceneSessionManager.getInstance().isScreenLocked()) {
      log.showWarn(TAG, 'onDumpsterGestureChange is screen locked');
      return;
    }

    const specificSession = this.getSpecificSession();
    if (!specificSession) {
      log.showWarn(TAG, 'onDumpsterGestureChange invalid specificSession');
      return;
    }

    if (!event || !event.fingerList || !event.fingerList[0]) {
      log.showWarn(TAG, 'onDumpsterGestureChange invalid event or dumpsterHolderId');
      return;
    }
  }

  /**
   * 移动到删除区域
   */
  private onActionMovePreDeleteToDelete(): void {
    log.showInfo(TAG, 'onActionMovePreDeleteToDelete');
    animateTo({
      curve: DUMPSTER_PANEL
    }, () => {
      this.scale = 0.75;
    })
  }

  /**
   * 移动到预删除区域
   */
  private onActionMoveDeleteToPreDelete(): void {
    log.showInfo(TAG, 'onActionMoveDeleteToPreDelete');
    this.doScaleAnimation(1, false);
  }

  private async doScaleAnimation(scale: number, centerScale: boolean = true): Promise<void> {
    if (centerScale) {
      this.updateScaleCenter('50%', '50%');
    }
    const scaleAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.FLOATING_BALL_PANEL_SCALE_ANIMATION,
      true);
    await scaleAnimation.executeAnimation([{
      curve: curves.responsiveSpringMotion(0.4, 1),
      event: () => {
        this.scale = scale;
      },
    }]);
  }

  /**
   * 滑动手势识别成功,即手指按下
   * @param event
   */
  public onPanStart(event: GestureEvent): void {
    if (!event || !event.fingerList || !event.fingerList[0]) {
      log.showWarn(TAG, 'onPanStart invalid event');
      return;
    }
    log.showInfo(TAG, 'onPanStart');
    TraceUtil.startTrace(DomainName.SYS_UI, TraceUtil.FLOATING_BALL_PAN_MOVE);
    this.animateMoveCnt++;
    // 拖拽开始记录当前位置
    this.position.positionX = this.position.x;
    this.position.positionY = this.position.y;
    this.moveDisplayX = event.fingerList[0].displayX;
    this.moveDisplayY = event.fingerList[0].displayY;
    // 默认中心缩放
    this.updateScaleCenter('50%', '50%');
    this.doScaleAnimation(1.05);
    this.panelVm.zIndex = Constants.INDEX_ABOVE_DUMPSTER; // 拖动时层级在垃圾桶之上
    this.onDumpsterGestureChange(TouchType.Down, event);
  }

  /**
   * 滑动手势移动过程中,即手指滑动过程中
   * @param event
   */
  public onPanMove(event: GestureEvent): void {
    if (!event || !event.fingerList || !event.fingerList[0]) {
      log.showWarn(TAG, 'onPanMove invalid event');
      return;
    }
    const displayX = event.fingerList[0].displayX;
    const displayY = event.fingerList[0].displayY;
    const offsetX = displayX - this.moveDisplayX;
    const offsetY = displayY - this.moveDisplayY;
    // 计算拖拽后的坐标
    const newX = this.position.positionX + offsetX;
    const newY = this.position.positionY + offsetY;
    animateTo({
      curve: FloatingBallRectVm.MOVE_CURVE
    }, () => {
      this.updatePosition(newX, newY, false);
    });
    this.onDumpsterGestureChange(TouchType.Move, event);
  }

  /**
   * 滑动手势结束,即手指抬起后
   * @param event
   */
  public onPanEnd(event?: GestureEvent): void {
    this.onDumpsterGestureChange(TouchType.Up, event);
    this.animateMoveCnt--;
    this.moveDisplayX = 0;
    this.moveDisplayY = 0;
    log.showInfo(TAG, `panel moving end, current time ${this.animateMoveCnt}`);
    if (this.isRemoving) {
      log.showInfo(TAG, 'panel removing, no need deal pan end');
      return;
    }
    animateTo({
      curve: TO_SIDE_CURVE, // 动画曲线
      onFinish: () => {
        if (this.animateMoveCnt === 0) {
          // 未删除时，松手恢复层级，避免在预删除区域松手层级未恢复
          this.panelVm.zIndex = DefaultPanelZIndex.PANEL_FLOATING_BALL;
        }
      },
    }, () => {
      // 拖拽结束执行
      this.avoidTopStatusBar();
      this.avoidInputMethod();
      this.avoidBottomNavBar();
      // 当前手势的x轴方向速度,从左往右为正,反之为负 单位为vp/s
      log.showInfo(TAG, `velocityX ${event?.velocityX}`);
      this.toSides(event?.velocityX);
      this.avoidCutoutArea();
      this.position.positionX = this.position.x;
      this.position.positionY = this.position.y;
    })
    this.doScaleAnimation(1);
    TraceUtil.endTrace(DomainName.SYS_UI, TraceUtil.FLOATING_BALL_PAN_MOVE);
  }

  public updateScaleCenter(centerX: number | string,  centerY: number | string): void {
    log.showInfo(TAG, `updateScaleCenter, centerX: ${centerX}, centerY: ${centerY}`);
    this.scaleCenterX = centerX;
    this.scaleCenterY = centerY;
  }

  private needAvoidTopStatusBar(): boolean {
    return this.position.y < this.topAvoidHeight;
  }

  /**
   * 避让状态栏
   */
  private avoidTopStatusBar(): void {
    if (!this.needAvoidTopStatusBar()) {
      return;
    }
    log.showInfo(TAG, `avoidTopStatusBar ${this.topAvoidHeight}`);
    this.updatePosition(this.position.x, this.topAvoidHeight);
  }

  private needAvoidBottomNavBar(): boolean {
    return this.position.y + this.containerHeight > this.screenHeight - FloatingBallRectVm.BOTTOM_AVOID_HEIGHT;
  }

  /**
   * 避让导航条
   */
  private avoidBottomNavBar(): void {
    if (!this.needAvoidBottomNavBar()) {
      return;
    }
    let newY = this.position.y;
    const diffHeight = this.screenHeight - FloatingBallRectVm.BOTTOM_AVOID_HEIGHT;
    log.showInfo(TAG, `avoidBottomNavBar, diffHeight: ${diffHeight}`);
    // y坐标+自身高度
    newY = diffHeight - this.containerHeight;
    this.updatePosition(this.position.x, newY);
  }

  private needAvoidInputMethod(): boolean {
    return this.inputHeight > 0 && this.isOverlayInputMethod();
  }

  /**
   * 避让输入法
   */
  public avoidInputMethod(): void {
    // 判断y坐标是否在输入法面板上
    if (!this.needAvoidInputMethod()) {
      return;
    }
    let newY = this.position.y;
    log.showInfo(TAG, `avoidInputMethod, input: ${this.inputHeight} screenHeight: ${this.screenHeight}`);
    newY = this.screenHeight - this.inputHeight - this.panelVm.outerPanelHeight -
    FloatingBallRectVm.INPUT_METHOD_AVOID_HEIGHT;
    this.updatePosition(this.position.x, newY);
  }

  /**
   * 松手后吸附到两侧
   */
  public toSides(xSpeed?: number): void {
    let newX = this.position.x;
    let isRightSpeed = false;
    let isLeftSpeed = false;
    if (xSpeed !== undefined) {
      isRightSpeed = xSpeed >= FloatingBallRectVm.X_SPEED_THRESHOLD;
      isLeftSpeed = xSpeed <= -FloatingBallRectVm.X_SPEED_THRESHOLD;
    }

    // 速度优先级更高
    if (isRightSpeed) {
      newX = this.screenWidth - this.containerWidth;
    } else if (isLeftSpeed) {
      newX = 0;
    } else if (newX + this.containerWidth / 2 > Math.floor(this.screenWidth / 2)) {
      newX = this.screenWidth - this.containerWidth;
    } else {
      newX = 0;
    }
    this.updatePosition(newX, this.position.y);
  }

  private needAvoid(): boolean {
    return this.needAvoidTopStatusBar() || this.needAvoidBottomNavBar() || this.needAvoidInputMethod();
  }

  /**
   * 设置挖孔区域信息
   */
  public async updateCutoutArea(): Promise<void> {
    try {
      const cutoutInfo = await display.getDefaultDisplaySync().getCutoutInfo();
      if (cutoutInfo && cutoutInfo.boundingRects.length && cutoutInfo.boundingRects[0]) {
        const rect = cutoutInfo.boundingRects[0];
        // 统一转换为vp
        const cutoutRect: display.Rect = {
          left: ArkUIAdapter.px2vp(rect.left),
          top: ArkUIAdapter.px2vp(rect.top),
          width: ArkUIAdapter.px2vp(rect.width),
          height: ArkUIAdapter.px2vp(rect.height)
        }
        this.cutoutRect = cutoutRect;
        log.showInfo(TAG, `cutoutRect left:${cutoutRect.left} top:${cutoutRect.top}`);
      }
    } catch (err) {
      log.showError(TAG, `getCutoutInfo failed ${err}`);
    }
  }

  /**
   * 是否与挖孔屏幕区域重叠
   * @returns boolean
   */
  private isOverlayCutOutArea(): boolean {
    const maxLeft = Math.max(this.cutoutRect.left, this.position.x);
    const maxTop = Math.max(this.cutoutRect.top, this.position.y);
    const minRight = Math.min(this.cutoutRect.left + this.cutoutRect.width, this.position.x + this.containerWidth);
    const minBottom = Math.min(this.cutoutRect.top + this.cutoutRect.height, this.position.y + this.containerHeight);
    // 无重叠则为false
    return !(minRight < maxLeft || minBottom < maxTop);
  }

  /**
   * 横屏下避让挖孔区域
   */
  private avoidCutoutArea(): void {
    // 竖屏并且排除超大屏G态
    if (!DeviceHelper.isLandscape() && !DeviceHelper.isUltraScreenGPortrait()) {
      log.showInfo(TAG, 'device is not landscape or is not G');
      return;
    }
    const isOverlay = this.isOverlayCutOutArea();
    log.showInfo(TAG, `avoidCutoutArea isOverlay ${isOverlay}`);
    if (isOverlay) {
      const newY = this.cutoutRect.top - this.containerHeight - FloatingBallRectVm.BOTTOM_AVOID_HEIGHT;
      // 重新设置y坐标
      this.updatePosition(this.position.x, newY);
    }
  }

  /**
   * 组件大小变化回调
   * @param size
   */
  public onPanelSizeChange(size: SizeOptions): void {
    const width = size.width as number;
    const height = size.height as number;
    log.showInfo(TAG, `removing ${this.isRemoving}, showing ${this.isShowing}`);
    let widthChange: boolean = true;
    if (width > 0 && height > 0) {
      widthChange = this.containerWidth !== width;
      this.containerWidth = width;
      this.containerHeight = height;
    }
    if (!this.isRemoving && !this.isShowing) {
      if (!widthChange && !this.needAvoid()) {
        log.showInfo(TAG, `widthChange is false and no need avoid`);
        return;
      }
      const sizeChangeAnimation: AnimationBase =
        new AnimationBase(AnimationBase.NAMES.FLOATING_BALL_PANEL_SIZE_CHANGE_ANIMATION, true);
      sizeChangeAnimation.executeAnimation([{
        curve: PANEL_CURVE,
        event: () => {
          log.showInfo(TAG, 'on panel size change avoid');
          this.avoidTopStatusBar();
          this.avoidInputMethod();
          this.avoidBottomNavBar();
          this.toSides();
          this.avoidCutoutArea();
        },
        delay: this.listVm.isRemovingBall ? 100 : 0, // 删除悬浮球时需要和面板动效一致，延迟100ms
      }]);
    }
  }

  public destroy(): void {
    log.showInfo(TAG, 'rect vm destroy');
  }
}
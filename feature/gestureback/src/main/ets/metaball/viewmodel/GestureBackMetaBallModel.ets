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

import animator, { AnimatorOptions, AnimatorResult } from '@ohos.animator';
import { SingletonHelper, LogDomain, LogHelper, OutdoorConfig } from '@ohos/basicutils';
import { SCBConstants } from '@ohos/commonconstants';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceHelper, SCBWindowSceneConfig } from '@ohos/frameworkwrapper';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { gestureBackSettings } from '../../common/GestureBackSettings';
import { MetaBallParams } from '../view/GestureBackMetaBall';
import { GestureBackMetaBallCallBack } from './GestureBackMetaBallCallBack';

const NS_COUNT_PER_MS: number = 1000000;
const MAX_COLOR_ALPHA: number = 255;
const HEXADECIMAL_VALUE: number = 16;
const WHITE_COLOR: string = 'FFFFFF';

// 虚拟圆初始、中间、结束位置 x坐标
const VIRTUAL_UP_INIT_X: number = -45;
const VIRTUAL_MIDDLE_INIT_X: number = 15;
const VIRTUAL_END_INIT_X: number = -75;

// 显示圆初始、中间、结束位置 x坐标
const REAL_UP_INIT_X: number = -15;
const REAL_MIDDLE_INIT_X: number = 20.75;
const REAL_END_INIT_X: number = 90;

// 箭头尺寸常量信息
const ARROW_WIDTH_RATIO: number = 9 / 40;
const ARROW_HEIGHT_RATIO: number = 3 / 5;
const ARROW_LINE_WIDTH: number = 1.5;
const ARROW_RELATIVE_START: number = 2.5;
const ARROW_RELATIVE_END: number = 3.5;
const ARROW_RELATIVE_CONTROL = 4.5;

// 侧边dock圆圈绘制常亮
const DOCK_CIRCLE_LINE_WIDTH = 3;
const DOCK_CIRCLE_RADIUS = 10;

// 真实圆结束半径
const REAL_CIRCLE_END_RADIUS = 15;

// 箭头鸿蒙环动画时长
const SLIDEOUT_ANIMATE_DURATION = 500;
// 箭头消失时长
const ARROW_DISAPPEAR_ANIMATE_DURATION = 300;
// 鸿蒙环动画延时
const DOCK_IMG_DELAY: number = 200;
const HALF_PI: number = Math.PI / 2;
const TAG = 'GestureBackMetaBall';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.GESTURE, TAG);

/**
 * back融球绘制
 */
export class GestureBackMetaBallModel {
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D();
  // 融球视图组件的相关参数viewData
  public metaBallParams = new MetaBallParams();
  private drawBezierProcess: number = 0;
  private drawMetaBallProcess: number = 0;
  // 跟手贝塞尔曲线初始的一半高度
  private bezierStartHeight: number = 80;
  // 跟手贝塞尔曲线最终的一半高度
  private bezierEndHeight: number = 60;
  // 跟手贝塞尔曲线控制点坐标比例
  private bezierControlRatio: number = 0.6;
  // 跟手贝塞尔曲线最终宽度
  private bezierEndWidth: number = 35.75;
  // 本塞尔曲线完全滑出时滑动距离阈值
  private bezierThreshold = gestureBackSettings.getBackBezierThreshold();
  // 呼出融球条件：最小速度阈值
  private minSpeed: number = 1;
  // 呼出融球条件：速度小于阈值的停留时间
  private timeLimit: number = 100;
  private startTime: number = 0;
  // 挤出圆球动效是否正在过程中
  public isExtrudeBallsAnimRunning: boolean = false;
  private isExtrudeBallsFinished: boolean = false;
  private extrudeBallsAnimDuration: number = 300;
  private handleUpAnimDuration: number = 300;
  private isHandleUpAnimRunning: boolean = false;
  private downPoint: Point = new Point(0, 0);
  // 跟手贝塞尔曲线属性动效起止点
  private arcStartUpPoint: Point = new Point(0, 0);
  private arcStartMiddlePoint: Point = new Point(0, 0);
  private arcStartDownPoint: Point = new Point(0, 0);
  private arcStartUpContPoint1: Point = new Point(0, 0);
  private arcStartUpContPoint2: Point = new Point(0, 0);
  private arcStartDownContPoint1: Point = new Point(0, 0);
  private arcStartDownContPoint2: Point = new Point(0, 0);
  private arcEndUpPoint: Point = new Point(0, 0);
  private arcEndMiddlePoint: Point = new Point(this.bezierEndWidth, 0);
  private arcEndDownPoint: Point = new Point(0, 0);
  private arcEndUpContPoint1: Point = new Point(0, 0);
  private arcEndUpContPoint2: Point = new Point(this.bezierEndWidth, 0);
  private arcEndDownContPoint1: Point = new Point(0, 0);
  private arcEndDownContPoint2: Point = new Point(this.bezierEndWidth, 0);
  // 滑动过程中挤出圆球动效
  private extrudeBalls: AnimatorResult | undefined = undefined;
  // 松手融球回退动效
  private handleUpBackAnim: AnimatorResult | undefined = undefined;
  // 回滑过程中融球以及贝塞尔收起动效
  private moveBackAnim: AnimatorResult | undefined = undefined;
  // 箭头与鸿蒙环切换动效
  private changeImgAnim?: AnimatorResult;
  private frameAnimEasing: string = 'spring(0, 1, 246.7, 31.4)';
  // 虚拟圆初始、中间、结束位置 x坐标
  private virtualStartX: number = VIRTUAL_UP_INIT_X;
  private virtualMiddleX: number = VIRTUAL_MIDDLE_INIT_X;
  private virtualEndX: number = VIRTUAL_END_INIT_X;
  // 虚拟圆起止半径
  private virtualCircleStartRadius: number = 20.5;
  private virtualCircleEndRadius: number = 75;
  // 小圆初始、中间、结束位置 x坐标
  private realCircleStartX: number = REAL_UP_INIT_X;
  private realCircleMiddleX: number = REAL_MIDDLE_INIT_X;
  private realCircleEndX: number = REAL_END_INIT_X;
  // 小圆起止半径
  private realCircleStartRadius: number = 15;
  private realCircleEndRadius: number = 20;
  // 两圆之间的最大距离参数：限制两圆之间的切线绘制，超过一定距离后不再绘制切线
  private distanceRatio: number = 3.2;
  // 两圆之间公切点移动比例
  private commonTangentRatio: number = 1.1;
  // 虚拟圆用于绘制融球曲线
  public virtualCircle = new Circle(this.virtualStartX, 0, this.virtualCircleStartRadius);
  // 真实待显示圆
  private realCircle = new Circle(this.realCircleStartX, 0, this.realCircleStartRadius);
  private isLeftGesture: boolean = true;
  private screenSize: Point = new Point(0, 0);
  // 箭头完整显示时的滑动阈值
  private arrowCompleteShowProcess: number = 0;
  // 箭头开始显示时的滑动阈值
  private arrowStartShowProcess: number = 0;
  private callBack?: GestureBackMetaBallCallBack;
  private isMoveBackAnimRunning: boolean = false;
  // 上一次手势事件
  private preEvent?: GestureEvent = undefined;
  private initExtrudeTouchPointX: number = -1;
  // 圆球在滑动过程中，叠加的跟手位移
  private extraMoveDistance: number = 0;
  private changeDockImgProcess: number = 0;
  private changeArrowProcess: number = 1;
  // 是否是pad触控板触发的侧边返回动效
  private isPadTouchPad: boolean = false;
  private fingerIndex: number = 0;

  public static getInstance(): GestureBackMetaBallModel {
    return SingletonHelper.getInstance(GestureBackMetaBallModel, TAG);
  }

  /**
   * 开始触发back手势时的信息初始化
   *
   * @param event 开始back手势触屏事件
   * @param isLeftGesture 是否左侧手势
   * @param screenWidth 屏宽
   * @param screenHeight 屏高
   * @param finishCallBack 松手动效结束回调
   */
  public initPoint(event: GestureEvent, isLeftGesture: boolean,
    screenWidth: number, screenHeight: number, callBack: GestureBackMetaBallCallBack): void {
    this.isLeftGesture = isLeftGesture;
    this.screenSize = new Point(screenWidth, screenHeight);
    this.callBack = callBack;
    this.startTime = 0;
    this.initFingerIndex(event);
    this.downPoint = new Point(event.fingerList[this.fingerIndex]?.globalX, event.fingerList[this.fingerIndex]?.localY);
    this.preEvent = event;
    this.initPointParams(px2vp(StyleConstants.GESTURE_NAVIGATION_BACK_CANVAS_WIDTH));
    this.setCanvasParams(false);
    this.isExtrudeBallsAnimRunning = false;
    this.extrudeBalls?.finish();
    this.drawMetaBallProcess = 0;
    this.isHandleUpAnimRunning = false;
    this.isMoveBackAnimRunning = false;
    this.extrudeBalls = this.buildExtrudeAnim();
    this.initExtrudeTouchPointX = -1;
    this.extraMoveDistance = 0;
    this.resetDockImgProcess();
    this.isPadTouchPad = event.sourceTool === SourceTool.TOUCHPAD &&
      SCBWindowSceneConfig.getInstance().windowSceneConfig?.uiType === SCBConstants.UITYPE_PAD;
  }

  /**
   * 初始化绘制back融球的手指id
   *
   * @param event
   * @returns
   */
  private initFingerIndex(event: GestureEvent): void {
    for (const fingerInfo of event.fingerList) {
      if (fingerInfo) {
        this.fingerIndex = event.fingerList.indexOf(fingerInfo);
        log.showInfo(`initFingerIndex:${this.fingerIndex}`);
        return;
      }
    }
    this.fingerIndex = 0;
  }

  /**
   * 初始化真实圆和虚拟圆的坐标数据
   *
   * @param screenWidth
   */
  private initPointParams(screenWidth: number) {
    this.virtualStartX = this.isLeftGesture ? VIRTUAL_UP_INIT_X : screenWidth - VIRTUAL_UP_INIT_X;
    this.virtualMiddleX =
      this.isLeftGesture ? VIRTUAL_MIDDLE_INIT_X : screenWidth - VIRTUAL_MIDDLE_INIT_X;
    this.virtualEndX = this.isLeftGesture ? VIRTUAL_END_INIT_X : screenWidth - VIRTUAL_END_INIT_X;
    // 小圆初始、中间、结束位置 x坐标
    this.realCircleStartX = this.isLeftGesture ? REAL_UP_INIT_X : screenWidth - REAL_UP_INIT_X;
    this.realCircleMiddleX =
      this.isLeftGesture ? REAL_MIDDLE_INIT_X : screenWidth - REAL_MIDDLE_INIT_X;
    this.realCircleEndX = this.isLeftGesture ? REAL_END_INIT_X : screenWidth - REAL_END_INIT_X;
    this.realCircle.isLeftGesture = this.isLeftGesture;
    this.arrowStartShowProcess = Math.abs(this.realCircleStartRadius * (1 - ARROW_WIDTH_RATIO) /
      (this.realCircleMiddleX - this.realCircleStartX));
    if (this.isLeftGesture) {
      this.arrowCompleteShowProcess =
        (this.realCircleStartRadius * ARROW_WIDTH_RATIO - this.realCircleStartX) /
          (this.realCircleMiddleX - this.realCircleStartX);
    } else {
      this.arrowCompleteShowProcess =
        (screenWidth - this.realCircleStartRadius * ARROW_WIDTH_RATIO - this.realCircleStartX) /
          (this.realCircleMiddleX - this.realCircleStartX);
    }
  }

  // 设置绘制canvas画布
  public setDrawContext(context: CanvasRenderingContext2D): void {
    this.context = context;
  }

  /**
   * move事件处理
   *
   * @param event 滑动触屏事件
   */
  public handleActionMove(event: GestureEvent): void {
    if (!event) {
      return;
    }
    let dampingPointY =
      this.downPoint.y + (event.fingerList[this.fingerIndex]?.localY - this.downPoint.y) /
      gestureBackSettings.getBackMetaBallFollowingDampY();
    let curTouchPointX = event.fingerList[this.fingerIndex]?.globalX;
    let totalOffsetX = Math.abs(curTouchPointX - this.downPoint.x);
    let moveProcess = Math.min(totalOffsetX / this.bezierThreshold, 1);
    this.drawBezierProcess = moveProcess;
    // pad 触控板报点频率高, 有概率context.width的值与metaBallParams.width不一致情况
    let rightStartPointX = this.isPadTouchPad ? this.metaBallParams.width : this.context.width;
    let isNeedPlayExtrudeAnim = this.isNeedPlayExtrudeAnim(event, this.drawBezierProcess);
    if (isNeedPlayExtrudeAnim) {
      this.callBack?.onExtrudeBallsBegin();
      // 要开始做挤出融球动效，重置canvas组件的宽度，真实圆和虚拟圆参数的初始化
      this.setCanvasParams(true);
      this.initPointParams(this.screenSize.x);
      rightStartPointX = this.screenSize.x;
    }
    this.updatePoint(rightStartPointX, dampingPointY);
    // 设置球内箭头出现进度，用以控制箭头透明度
    let circleMoveProcess = Math.max(0, moveProcess - this.arrowStartShowProcess);
    this.realCircle.setMoveProcess(circleMoveProcess,
      (this.arrowCompleteShowProcess - this.arrowStartShowProcess));
    // 贝塞尔曲线跟手动效
    if (!this.isExtrudeBallsAnimRunning) {
      this.handleMoveBezier(this.drawBezierProcess);
    }
    // 开始挤出圆球动效
    if (isNeedPlayExtrudeAnim) {
      this.isExtrudeBallsAnimRunning = true;
      this.startTime = 0;
      this.initExtrudeTouchPointX = curTouchPointX;
      this.isExtrudeBallsFinished = false;
      this.extrudeBalls?.play();
    }

    // 挤出圆球时，圆球开始叠加跟手位移，1/8阻尼横向跟手
    if (this.initExtrudeTouchPointX >= 0) {
      this.extraMoveDistance = (curTouchPointX - this.initExtrudeTouchPointX) /
      gestureBackSettings.getBackMetaBallFollowingDampX();
    }

    // 挤出圆球后，圆球跟手动效
    if (this.isExtrudeBallsAnimRunning && this.drawMetaBallProcess === 1 && !this.isMoveBackAnimRunning) {
      this.context.clearRect(0, 0, this.context.width, this.context.height);
      this.realCircle.cx = this.realCircleEndX + this.extraMoveDistance;
      this.realCircle.move(this.realCircle.cx, this.realCircle.cy,
        this.realCircle.radius);
      this.realCircle.draw(this.context);
      if (DeviceHelper.isPC()) {
        log.showInfo('device is pc, not pullout dock.');
        return;
      }
    }

    if (this.isExtrudeBallsAnimRunning && !this.isMoveBackAnimRunning &&
      this.drawBezierProcess < this.arrowCompleteShowProcess) {
      this.extraMoveDistance = 0;
      this.initExtrudeTouchPointX = -1;
      this.handleMoveBackAnim();
    }
    if (this.preEvent?.timestamp !== event.timestamp) {
      this.preEvent = event;
    }
  }

  /**
   * 侧边手势抬手后动效
   */
  public handleUpAnimation(): void {
    try {
      this.isHandleUpAnimRunning = true;
      this.extrudeBalls?.finish();
      this.moveBackAnim?.finish();
      this.changeImgAnim?.finish();
      this.isPadTouchPad = false;
      let startValue = this.drawBezierProcess;
      if (this.isExtrudeBallsAnimRunning) {
        startValue = this.drawMetaBallProcess + 1;
      }
      this.backAnimation(startValue);
    } catch (error) {
      this.upAnimFinish();
    }
  }

  private backAnimation(startValue: number) {
    let animOption: AnimatorOptions =
      this.getFrameAnimOption(this.handleUpAnimDuration, this.frameAnimEasing, startValue, 0);
    this.handleUpBackAnim = animator.create(animOption);
    this.handleUpBackAnim.onFinish = () => {
      this.upAnimFinish();
      log.showInfo('handleUpAnimation finish.');
    };
    let expectedFrameRate: ExpectedFrameRateRange = {
      expected: startValue <= 1 ? 60 : 120,
      min: 0,
      max: 120
    };
    this.handleUpBackAnim.setExpectedFrameRateRange(expectedFrameRate);
    this.handleUpBackAnim.onFrame = (value: number) => {
      if (value >= 1) {
        // 前半段做融球收起动效
        this.drawMetaBallProcess = value - 1;
        this.handleMoveMetaBall(this.drawMetaBallProcess, 1 - this.drawMetaBallProcess);
      } else {
        // 后半段做贝塞尔曲线收起动效
        if (this.isExtrudeBallsAnimRunning) {
          this.isExtrudeBallsAnimRunning = false;
          this.drawMetaBallProcess = 0;
          this.handleMoveMetaBall(this.drawMetaBallProcess, 1 - this.drawMetaBallProcess);
        }
        this.drawBezierProcess = value;
        this.handleMoveBezier(this.drawBezierProcess);
      }
    };
    log.showInfo('handleUpAnimation start.');
    this.handleUpBackAnim.play();
  }

  /**
   * 抬手动效结束
   */
  private upAnimFinish(): void {
    this.isExtrudeBallsAnimRunning = false;
    this.isHandleUpAnimRunning = false;
    this.setCanvasParams(false);
    if (this.callBack) {
      this.callBack.onHandUpAnimFinish();
      this.callBack = undefined;
    }
    this.handleUpBackAnim = undefined;
    this.extrudeBalls = undefined;
    this.changeImgAnim = undefined;
  }

  /**
   * 绘制融球
   * @param cx1
   * @param cy1
   * @param radius1
   * @param cx2
   * @param cy2
   * @param radius2
   */
  private drawMetaBall(cx1: number, cy1: number, radius1: number, cx2: number, cy2: number,
    radius2: number) {
    this.virtualCircle.move(cx1, cy1, radius1);
    this.realCircle.move(cx2, cy2, radius2);

    const maxDist =
      this.virtualCircle.radius + this.realCircle.radius * this.distanceRatio;
    const distanceBetweenCenter = Math.abs(this.virtualCircle.cx - this.realCircle.cx);
    if (distanceBetweenCenter >= maxDist ||
      distanceBetweenCenter <= Math.abs(this.virtualCircle.radius - this.realCircle.radius)) {
      this.realCircle.draw(this.context);
      return;
    }
    const totalRadius = this.virtualCircle.radius + this.realCircle.radius;
    const spreadRatio = this.commonTangentRatio * (1.0 - this.drawMetaBallProcess);

    let u1 = 0;
    let u2 = 0;
    if (distanceBetweenCenter < totalRadius) {
      //余弦定理
      u1 =
        Math.acos((radius1 * radius1 + distanceBetweenCenter * distanceBetweenCenter -
          radius2 * radius2) / (2 * radius1 * distanceBetweenCenter));
      u2 =
        Math.acos((radius2 * radius2 + distanceBetweenCenter * distanceBetweenCenter -
          radius1 * radius1) / (2 * radius2 * distanceBetweenCenter));
    } else {
      u1 = 0;
      u2 = 0;
    }
    const angleBetweenCenters = Math.atan2(0, cx2 - cx1);
    const spread =
      Math.acos((this.virtualCircle.radius - this.realCircle.radius) / distanceBetweenCenter);
    let angle1 = angleBetweenCenters + u1 + (spread - u1) * spreadRatio;
    let angle2 = angleBetweenCenters - (u1 + (spread - u1) * spreadRatio);
    let angle3 = angleBetweenCenters + Math.PI - u2 - (Math.PI - u2 - spread) * spreadRatio;
    let angle4 = angleBetweenCenters - (Math.PI - u2 - (Math.PI - u2 - spread) * spreadRatio);

    this.drawCircle(angle1, angle2, angle3, angle4, totalRadius);
  }

  private drawCircle(angle1: number, angle2: number, angle3: number, angle4: number, totalRadius: number) {
    const p1 = this.getVector(this.virtualCircle.cx, this.virtualCircle.cy, angle1,
      this.virtualCircle.radius);
    const p2 = this.getVector(this.virtualCircle.cx, this.virtualCircle.cy, angle2,
      this.virtualCircle.radius);
    const p3 = this.getVector(this.realCircle.cx, this.realCircle.cy, angle3, this.realCircle.radius);
    const p4 = this.getVector(this.realCircle.cx, this.realCircle.cy, angle4, this.realCircle.radius);
    const d2 = (this.dist(p1.x, p1.y, p3.x, p3.y) / totalRadius);
    const r1 = this.virtualCircle.radius * d2;
    const r2 = this.realCircle.radius * d2;

    const h1 = this.getVector(p1.x, p1.y, angle1 - HALF_PI, r1);
    const h2 = this.getVector(p2.x, p2.y, angle2 + HALF_PI, r1);
    const h3 = this.getVector(p3.x, p3.y, angle3 + HALF_PI, r2);
    const h4 = this.getVector(p4.x, p4.y, angle4 - HALF_PI, r2);

    // 绘曲线
    this.context.beginPath();
    this.context.moveTo(p1.x, p1.y);
    this.context.arc(this.virtualCircle.cx, this.virtualCircle.cy, this.virtualCircle.radius,
      angle1, angle2, false);
    this.context.bezierCurveTo(h2.x, h2.y, h4.x, h4.y, p4.x, p4.y);
    this.context.arc(this.realCircle.cx, this.realCircle.cy, this.realCircle.radius, angle4, angle3,
      false);
    this.context.bezierCurveTo(h3.x, h3.y, h1.x, h1.y, p1.x, p1.y);
    this.context.fill();

    this.realCircle.draw(this.context);
  }

  // 获取切点
  private getVector(pointX: number, pointY: number, angle: number, radius: number): Point {
    return new Point(pointX + radius * Math.cos(angle), pointY + radius * Math.sin(angle));
  }

  // 两点间的距离
  private dist(x1: number, y1: number, x2: number, y2: number) {
    return Math.sqrt(Math.pow(x1 - x2, 2) + Math.pow(y1 - y2, 2));
  }

  /**
   * 跟手绘制贝塞尔曲线
   * @param moveProcess
   */
  private handleMoveBezier(moveProcess: number): void {
    this.context.clearRect(0, 0, this.context.width, this.context.height);
    // 小圆偏移
    let cx = this.realCircleStartX +
      (this.realCircleMiddleX - this.realCircleStartX) * moveProcess;
    this.drawBezierCurve(moveProcess);
    this.realCircle.move(cx, this.realCircle.cy, this.realCircle.radius);
    this.realCircle.drawArrow(this.context);
  }

  /**
   * 根据进度绘制贝塞尔曲线与融球效果
   * @param metaBallProcess
   * @param bezierProcess
   */
  private handleMoveMetaBall(metaBallProcess: number, bezierProcess: number): void {
    this.context.clearRect(0, 0, this.context.width, this.context.height);
    // 大圆偏移
    let virtualX =
      this.virtualMiddleX + (this.virtualEndX - this.virtualMiddleX) * metaBallProcess;
    let virtualRadius = this.virtualCircleStartRadius +
      (this.virtualCircleEndRadius - this.virtualCircleStartRadius) * metaBallProcess;
    // 小圆偏移
    let realX = this.realCircleMiddleX +
      (this.realCircleEndX - this.realCircleMiddleX) * metaBallProcess + this.extraMoveDistance;
    let realRadius = this.realCircleStartRadius +
      (this.realCircleEndRadius - this.realCircleStartRadius) * metaBallProcess;
    this.drawBezierCurve(bezierProcess);
    this.drawMetaBall(virtualX, this.virtualCircle.cy, virtualRadius, realX, this.realCircle.cy,
      realRadius);
  }

  /**
   * 绘制贝塞尔
   * @param animProcess
   */
  private drawBezierCurve(animProcess: number): void {
    this.context.beginPath();
    let startPoint: Point = new Point(this.arcStartUpPoint.x,
      this.arcStartUpPoint.y + (this.arcEndUpPoint.y - this.arcStartUpPoint.y) * animProcess);
    let endPoint: Point = new Point(this.arcStartMiddlePoint.x +
      (this.arcEndMiddlePoint.x - this.arcStartMiddlePoint.x) * animProcess,
      this.arcEndMiddlePoint.y);
    let controlPoint1: Point = new Point(this.arcEndUpContPoint1.x,
      this.arcStartUpContPoint1.y +
        (this.arcEndUpContPoint1.y - this.arcStartUpContPoint1.y) * animProcess);
    let controlPoint2: Point =
      new Point(this.arcStartUpContPoint2.x +
        (this.arcEndUpContPoint2.x - this.arcStartUpContPoint2.x) * animProcess,
        this.arcEndUpContPoint2.y);
    this.context.moveTo(startPoint.x, startPoint.y);
    // 上半部分贝塞尔
    this.context.bezierCurveTo(controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y,
      endPoint.x, endPoint.y);

    endPoint = new Point(this.arcEndDownPoint.x,
      this.arcStartDownPoint.y + (this.arcEndDownPoint.y - this.arcStartDownPoint.y) * animProcess);
    controlPoint1 = new Point(this.arcStartDownContPoint2.x +
      (this.arcEndDownContPoint2.x - this.arcStartDownContPoint2.x) * animProcess,
      this.arcEndDownContPoint2.y);
    controlPoint2 = new Point(this.arcEndDownContPoint1.x, this.arcStartDownContPoint1.y +
      (this.arcEndDownContPoint1.y - this.arcStartDownContPoint1.y) * animProcess);
    // 下半部分贝塞尔
    this.context.bezierCurveTo(controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y,
      endPoint.x, endPoint.y);
    this.context.fill();
  }

  private getCurrentOffsetX(event: GestureEvent, curPointX: number): number {
    if (this.isPadTouchPad) {
      // pad 触控板返回数值适配
      return Math.abs(event.offsetX - this.preEvent!.offsetX);
    }
    return Math.abs(curPointX - this.preEvent!.fingerList[this.fingerIndex]?.globalX);
  }

  /**
   * 判断是否需要执行圆球挤出动效
   *
   * @param event 跟手触屏事件
   * @param moveProcess 滑动进度
   * @returns true 开始执行圆球挤出动效 false 不执行动效
   */
  private isNeedPlayExtrudeAnim(event: GestureEvent, moveProcess: number): boolean {
    if (!gestureBackSettings.needBackExtrudeAnim()) {
      return false;
    }
    if (this.isExtrudeBallsAnimRunning) {
      return false;
    }
    if (OutdoorConfig.getInstance().isInOutdoorMode()) {
      return false;
    }
    // 检查箭头是否完全露出
    if (moveProcess <= this.arrowCompleteShowProcess) {
      return false;
    }
    let speed = this.minSpeed;
    let curPointX = event.fingerList[this.fingerIndex]?.globalX;
    if (this.preEvent) {
      let curOffsetX = this.getCurrentOffsetX(event, curPointX);
      let time = (event.timestamp - this.preEvent?.timestamp) / NS_COUNT_PER_MS;
      if (time <= 0) {
        return false;
      }
      speed = curOffsetX / time;
    }
    // 速度低于阈值后，开始计时停留时间
    let stayTime = 0;
    if (speed < this.minSpeed) {
      if (this.startTime === 0) {
        this.startTime = event.timestamp / NS_COUNT_PER_MS;
      }
      stayTime = (event.timestamp / NS_COUNT_PER_MS) - this.startTime;
    } else {
      this.startTime = 0;
    }
    return stayTime >= this.timeLimit;
  }

  // 挤出圆球动效
  private buildExtrudeAnim(): AnimatorResult {
    let animOption: AnimatorOptions =
      this.getFrameAnimOption(this.extrudeBallsAnimDuration, this.frameAnimEasing, 0, 1);
    let anim: AnimatorResult = animator.create(animOption);
    anim.onFinish = () => {
      this.drawMetaBallProcess = 1;
      this.isExtrudeBallsFinished = true;
      log.showInfo(`ExtrudeAnimFinish params:{${this.isMoveBackAnimRunning}, ${this.isHandleUpAnimRunning}.`);
      if (!this.isMoveBackAnimRunning && !this.isHandleUpAnimRunning) {
        this.callBack?.onExtrudeBallsFinish();
      }
    }
    anim.onFrame = (value: number) => {
      if (!this.isHandleUpAnimRunning) {
        this.drawMetaBallProcess = value;
        this.handleMoveMetaBall(this.drawMetaBallProcess, 1 - this.drawMetaBallProcess);
      }
    }
    return anim;
  }

  /**
   * 回滑过程中融球以及贝塞尔收起动效
   */
  private handleMoveBackAnim(): void {
    try {
      this.isMoveBackAnimRunning = true;
      let bezierStart = 1 - this.drawBezierProcess;
      let metaBallStartProcess = Math.abs((this.realCircle.cx - this.realCircleMiddleX) /
        (this.realCircleEndX - this.realCircleMiddleX));
      let startValue = metaBallStartProcess + bezierStart;
      this.metaBallMoveAnimation(startValue, bezierStart);
    } catch (error) {
      this.isExtrudeBallsAnimRunning = false;
      this.isMoveBackAnimRunning = false;
      this.moveBackAnim = undefined;
      log.error('handleMoveBackAnim error.');
    }
  }

  private metaBallMoveAnimation(startValue: number, bezierStart: number) {
    let animOption: AnimatorOptions =
      this.getFrameAnimOption(this.extrudeBallsAnimDuration, this.frameAnimEasing, startValue, 0);
    this.moveBackAnim = animator.create(animOption);
    this.moveBackAnim.onFinish = () => {
      this.isExtrudeBallsAnimRunning = false;
      this.isMoveBackAnimRunning = false;
      this.moveBackAnim = undefined;
      if (DeviceHelper.isPC()) {
        log.showInfo('device is pc, not pullout dock.');
        return;
      }
      this.callBack?.onMoveBackBallsFinish();
    };
    this.moveBackAnim.onFrame = (value: number) => {
      if (value >= bezierStart) {
        this.drawMetaBallProcess = value - bezierStart;
        this.handleMoveMetaBall(this.drawMetaBallProcess, 1 - this.drawMetaBallProcess);
      } else {
        if (this.drawMetaBallProcess !== 0) {
          this.handleMoveMetaBall(0, 1);
          this.drawMetaBallProcess = 0;
        }
        let bezierProcess = value + this.drawBezierProcess;
        this.handleMoveBezier(bezierProcess);
      }
    };
    if (DeviceHelper.isPC()) {
      log.showInfo('device is pc, not pullout dock.');
      return;
    }
    this.callBack?.onMoveBackBallsBegin();
    this.moveBackAnim.play();
  }

  /**
   * 侧边Dock呼出场景下箭头与鸿蒙环切换动效
   *
   * @param isShowDockImg true:满足呼出侧边Dock条件，箭头切换为圆圈  false：圆圈恢复为箭头
   */
  public changeDockImgAnim(isShowDockImg: boolean, onFinish?: (isLeft: boolean) => void): void {
    if ((isShowDockImg && this.changeDockImgProcess >= 1) || (!isShowDockImg && this.changeDockImgProcess <= 0)) {
      log.showInfo(`changeDockImgAnim , changeDockImgProcess:${this.changeDockImgProcess} changeArrowProcess:${this.changeArrowProcess} isShowDockImg:${isShowDockImg}}`);
      return;
    }
    let start = isShowDockImg ? 0 : 1;
    let animOption: AnimatorOptions =
      this.getFrameAnimOption(SLIDEOUT_ANIMATE_DURATION, this.frameAnimEasing, start,
        1 - start);
    this.changeImgAnim = animator.create(animOption);
    this.changeImgAnim.onFrame = (value: number) => {
      if (value === 0) {
        return;
      }
      if (value <= ARROW_DISAPPEAR_ANIMATE_DURATION / SLIDEOUT_ANIMATE_DURATION) {
        this.changeArrowProcess = 1 - value / (ARROW_DISAPPEAR_ANIMATE_DURATION / SLIDEOUT_ANIMATE_DURATION);
        this.realCircle.setArrowProcess(this.changeArrowProcess);
      } else {
        this.realCircle.setArrowProcess(0);
      }
      if (value > DOCK_IMG_DELAY / SLIDEOUT_ANIMATE_DURATION) {
        this.changeDockImgProcess = (value - DOCK_IMG_DELAY / SLIDEOUT_ANIMATE_DURATION) /
          (ARROW_DISAPPEAR_ANIMATE_DURATION / SLIDEOUT_ANIMATE_DURATION);
        this.realCircle.setDockImgProcess(this.changeDockImgProcess);
      }
      this.realCircle.draw(this.context);
    }
    this.changeImgAnim.onFinish = () => {
      onFinish?.(this.isLeftGesture);
    }
    this.changeImgAnim.onCancel = () => {
      onFinish?.(this.isLeftGesture);
    }
    try {
      this.changeImgAnim?.play();
    } catch (error) {
      log.error(`changeImgAnim error. code is ${error?.code}, message is ${error?.message}`);
      onFinish?.(this.isLeftGesture);
    }
  }

  /**
   * 结束箭头与鸿蒙环切换动效
   */
  public finishChangeDockImgAnim(): void {
    this.changeImgAnim?.finish();
  }

  /**
   * 设置动效状态变量为1 没有动效 防止快速滑动dock中间态
   */
  public setDockImgProcess(): void {
    this.changeDockImgProcess = 1;
    this.changeArrowProcess = 0;
    this.realCircle.setDockImgProcess(this.changeDockImgProcess);
    this.realCircle.setArrowProcess(this.changeArrowProcess);
    this.realCircle.draw(this.context);
  }

  public resetDockImgProcess(): void {
    this.changeDockImgProcess = 0;
    this.changeArrowProcess = 1;
    this.realCircle.resetProcessParams();
    this.virtualCircle.resetProcessParams();
  }

  private getFrameAnimOption(duration: number, eas: string, begin: number,
    end: number, delay?: number): AnimatorOptions {
    return {
      duration: duration,
      easing: eas,
      fill: 'forwards',
      direction: 'normal',
      iterations: 1,
      begin: begin,
      end: end,
      delay: delay ?? 0
    };
  }

  private updatePoint(rightStartPointX: number, touchPointY: number): void {
    // 防止手指贴顶部或底部，导致融球显示不全
    touchPointY = Math.min(this.context.height - this.bezierStartHeight,
      Math.max(touchPointY, this.bezierStartHeight));
    let startPointX = this.isLeftGesture ? 0 : rightStartPointX;

    // 初始曲线上、中、下三个点
    this.arcStartUpPoint.setValue(startPointX, touchPointY - this.bezierStartHeight);
    this.arcStartMiddlePoint.setValue(startPointX, touchPointY);
    this.arcStartDownPoint.setValue(startPointX, touchPointY + this.bezierStartHeight);

    // 初始上曲线两个控制点
    let upContPointY = touchPointY - (this.bezierStartHeight * (1 - this.bezierControlRatio));
    this.arcStartUpContPoint1.setValue(startPointX, upContPointY);
    this.arcStartUpContPoint2.setValue(startPointX, upContPointY);
    // 初始下曲线两个控制点
    let downContPointY = upContPointY + this.bezierStartHeight * this.bezierControlRatio;
    this.arcStartDownContPoint1.setValue(startPointX, downContPointY);
    this.arcStartDownContPoint2.setValue(startPointX, downContPointY);
    // 结束曲线上、中、下三个点
    this.arcEndUpPoint.setValue(startPointX, touchPointY - this.bezierEndHeight);
    let endMiddlePointX =
      this.isLeftGesture ? this.bezierEndWidth : rightStartPointX - this.bezierEndWidth;
    this.arcEndMiddlePoint.setValue(endMiddlePointX, touchPointY);
    this.arcEndDownPoint.setValue(startPointX, touchPointY + this.bezierEndHeight);
    // 结束上曲线两个控制点
    let endUpControlPointY = touchPointY - (1 - this.bezierControlRatio) * this.bezierEndHeight;
    this.arcEndUpContPoint1.setValue(startPointX, endUpControlPointY);
    this.arcEndUpContPoint2.setValue(endMiddlePointX, endUpControlPointY);
    // 结束下曲线两个控制点
    let endDownControlPointY = touchPointY + (1 - this.bezierControlRatio) * this.bezierEndHeight;
    this.arcEndDownContPoint1.setValue(startPointX, endDownControlPointY);
    this.arcEndDownContPoint2.setValue(endMiddlePointX, endDownControlPointY);

    this.virtualCircle.cy = touchPointY;
    this.realCircle.cy = touchPointY;
  }

  /**
   * 设置Canvas组件的属性
   *
   * @returns
   */
  private setCanvasParams(isExtrudeBalls: boolean): void {
    if (isExtrudeBalls) {
      this.metaBallParams.positionX = 0;
      this.metaBallParams.width = this.screenSize.x;
      return;
    }
    if (this.isLeftGesture) {
      this.metaBallParams.positionX = 0;
    } else {
      this.metaBallParams.positionX = this.screenSize.x - px2vp(StyleConstants.GESTURE_NAVIGATION_BACK_CANVAS_WIDTH);
    }
    this.metaBallParams.width = px2vp(StyleConstants.GESTURE_NAVIGATION_BACK_CANVAS_WIDTH);
  }

  public finishUpAnim(): void {
    this.handleUpBackAnim?.finish();
  }
}

/**
 * 坐标点工具类
 */
class Point {
  public x: number;
  public y: number;

  constructor(pointX: number, pointY: number) {
    this.x = pointX;
    this.y = pointY;
  }

  setValue(pointX: number, pointY: number): void {
    this.x = pointX;
    this.y = pointY;
  }
}

/**
 * 圆形工具类
 */
class Circle {
  public cx: number;
  public cy: number;
  public radius: number;
  public isLeftGesture: boolean = true;
  public moveProcess: number = 0;
  public thresholdProcess: number = 0;
  public dockImgProcess: number = 0;
  public arrowProcess: number = 1;

  constructor(cx: number, cy: number, radius: number) {
    this.cx = cx;
    this.cy = cy;
    this.radius = radius;
  }

  setMoveProcess(moveProcess: number, threshold: number): void {
    this.moveProcess = moveProcess;
    this.thresholdProcess = threshold;
  }

  setDockImgProcess(process: number): void {
    this.dockImgProcess = process;
  }

  setArrowProcess(process: number): void {
    this.arrowProcess = process;
  }

  resetProcessParams(): void {
    this.setMoveProcess(0, 0);
    this.setDockImgProcess(0);
    this.setArrowProcess(1);
  }

  draw(ctx: CanvasRenderingContext2D): void {
    this.drawCircle(ctx);
    this.drawArrow(ctx);
    this.drawDockImg(ctx);
  }

  drawCircle(ctx: CanvasRenderingContext2D): void {
    ctx.beginPath();
    ctx.arc(this.cx, this.cy, this.radius, 0, 2 * Math.PI);
    ctx.fill();
  }

  drawArrow(ctx: CanvasRenderingContext2D): void {
    if (this.arrowProcess > 1) {
      return;
    }
    ctx.beginPath();
    if (this.thresholdProcess > 0 && this.moveProcess <= this.thresholdProcess) {
      let alpha = Math.floor((this.moveProcess / this.thresholdProcess) * MAX_COLOR_ALPHA)
        .toString(HEXADECIMAL_VALUE).padStart(2, '0');
      ctx.strokeStyle = '#' + alpha + WHITE_COLOR;
    } else {
      let alpha = Math.floor(this.arrowProcess * MAX_COLOR_ALPHA)
        .toString(HEXADECIMAL_VALUE)
        .padStart(2, '0');
      ctx.strokeStyle = '#' + alpha + WHITE_COLOR;
    }
    let isRTL = RTLUtil.isRTL();
    ctx.lineWidth = ARROW_LINE_WIDTH;
    let startX = isRTL ? this.cx - ARROW_RELATIVE_END : this.cx + ARROW_RELATIVE_START;
    let endX = isRTL ? this.cx + ARROW_RELATIVE_START : this.cx - ARROW_RELATIVE_END;
    let arcControlX = isRTL ? this.cx + ARROW_RELATIVE_CONTROL : this.cx - ARROW_RELATIVE_CONTROL;
    let arrowHeight = REAL_CIRCLE_END_RADIUS * ARROW_HEIGHT_RATIO;
    ctx.moveTo(startX, this.cy - arrowHeight);
    ctx.lineTo(endX, this.cy - 2);
    ctx.arcTo(arcControlX, this.cy, endX, this.cy + 2, 2);
    ctx.lineTo(startX, this.cy + arrowHeight);
    ctx.stroke();
  }

  drawDockImg(ctx: CanvasRenderingContext2D): void {
    if (this.dockImgProcess <= 0) {
      return;
    }
    ctx.beginPath();
    ctx.lineWidth = DOCK_CIRCLE_LINE_WIDTH;
    let alpha = Math.floor(this.dockImgProcess * MAX_COLOR_ALPHA)
      .toString(HEXADECIMAL_VALUE)
      .padStart(2, '0');
    ctx.strokeStyle = '#' + alpha + WHITE_COLOR;
    ctx.arc(this.cx, this.cy, DOCK_CIRCLE_RADIUS, 0, 2 * Math.PI);
    ctx.stroke();
  }

  move(centerX: number, centerY: number, ra: number) {
    this.cx = centerX;
    this.cy = centerY;
    this.radius = ra;
  }
}
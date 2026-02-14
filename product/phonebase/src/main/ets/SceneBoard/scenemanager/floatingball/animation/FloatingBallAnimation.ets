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

import { LogDomain, Logger } from '@ohos/basicutils';
import { AnimateParams, AnimationBase, AnimationNames } from '@ohos/systemuicommon/newIndex';
import { IFloatingBallPanelVm } from '../interface/IFloatingBallPanelVm';
import { IFloatingBallRectVm } from '../interface/IFloatingBallRectVm';
import { FloatingBall } from '../model/FloatingBallModel';
import { curves } from '@kit.ArkUI';
import { FloatingBallStyle } from '../constants/FloatingBallStyle';
import { IFloatingBallListVm } from '../interface/IFloatingBallListVm';
import { RemoveType } from '../constants/FloatingConstants';
import { IFloatingBallInjector } from '../interface/IFloatingBallInjector';
import { SCBFloatingBallPanelVm } from '../vm/SCBFloatingBallPanelVm';
import { IFloatingBallMenuVm } from '../interface/IFloatingBallMenuVm';

const TAG = 'FloatingBallAnimation';
const log = Logger.getLogHelper(LogDomain.WINDOW);

export enum TranslateType {
  /**
   * 添加
   */
  ADD = 1,
  /**
   * 删除
   */
  REMOVE,
  /**
   * 挤占
   */
  SQUEEZE,
};

// 底板位移
const PANEL_TRANSLATE_CURVE: ICurve = curves.interpolatingSpring(0, 1, 160, 18);
// 底板缩放
const PANEL_SCALE_CURVE: ICurve = curves.interpolatingSpring(0, 1, 322, 25);
// 底板形变
export const PANEL_CURVE: ICurve = curves.interpolatingSpring(0, 1, 247, 25);
// 悬浮球缩放
const BALL_SCALE_CURVE: ICurve = curves.interpolatingSpring(0, 1, 439, 36);
// 垃圾桶删除面板
export const DUMPSTER_PANEL: ICurve = curves.springMotion(0.55, 1);
// 悬浮球全部删除时面板变化
const PAN_CLEAR: ICurve = curves.springMotion(0.304, 0.97);
// 悬浮球全部删除时透明度变化
const PAN_CLEAR_OPACITY: ICurve = curves.cubicBezierCurve(0.2,0,0.2,1);
// 松手吸附动效参数
export const TO_SIDE_CURVE: ICurve = curves.springMotion(0.4, 0.8);
// 长按动效参数
export const LONG_PRESS_CURVE: ICurve = curves.cubicBezierCurve(0.33, 0, 0.67, 1);

/**
 * 悬浮球动效基类
 */
export class FloatingBallBaseAnimation extends AnimationBase {
  // 动效终值差异，用于动效打断
  protected static readonly ANIMATION_VALUE_DIFF = 0.01;

  // 限制帧率
  protected static readonly SIXTY_FPS_ANIMATION: ExpectedFrameRateRange = { min: 60, max: 60, expected: 60 };

  protected rectVm: IFloatingBallRectVm;
  protected listVm: IFloatingBallListVm;
  protected panelVm: IFloatingBallPanelVm;
  protected menuVm: IFloatingBallMenuVm;

  constructor(name: AnimationNames, vmInjector: IFloatingBallInjector) {
    super(name, true);
    this.rectVm = vmInjector.getRectVm();
    this.listVm = vmInjector.getListVm();
    this.panelVm = vmInjector.getPanelVm();
    this.menuVm = vmInjector.getMenuVm();
  }

  protected updatePanelSize(floatingBallList?: FloatingBall[]): void {
    this.panelVm.rowWidth = this.listVm.calcMaxRowWidth(floatingBallList);
    this.panelVm.outerPanelHeight = this.getOuterPanelHeight(floatingBallList);
    this.panelVm.outerPanelWidth = this.getOuterPanelWidth(this.panelVm.rowWidth);
  }

  protected updateTranslateY(index: number, type: TranslateType): void {
    const oneFloatingBallHeight = FloatingBallStyle.ROW_HEIGHT + FloatingBallStyle.PADDING4;
    for (let i = 0; i < this.listVm.floatingBallList.length; i++) {
      const diff = i - index;
      if (diff <= 0) {
        continue;
      }
      const ball = this.listVm.floatingBallList[i];
      if (type === TranslateType.SQUEEZE) {
        // 挤占时，先加列表，再做动效，再删除多余悬浮球
        // 中间的悬浮球固定到原始位置，再动画位移为0
        // 被挤占的悬浮球固定到原始位置，动画消失
        ball.translateY = -oneFloatingBallHeight;
      } else {
        // 增加时，先加列表再做动效，先把后面的悬浮球位置上移，再动画平移回去
        // 删除时，先做动效再删列表，先把后面的悬浮球动画上移，列表删除后再固定位移为0
        ball.translateY = -diff * oneFloatingBallHeight;
      }
      log.showInfo(TAG, `ball ${ball.specificSession.session.persistentId} Y ${ball.translateY}, transType ${type}`);
    }
  }

  protected resetTranslateY(exceptBall?: FloatingBall): void {
    log.showInfo(TAG, 'resetTranslateY');
    this.listVm.floatingBallList.forEach(ball => {
      if (exceptBall && ball.isSameBall(exceptBall)) {
        return;
      }
      ball.translateY = 0;
    });
  }

  /**
   * 外底板高度
   */
  protected getOuterPanelHeight(floatingBallList?: FloatingBall[]): number {
    // 悬浮球个数 * 悬浮球高度(32 + 4) + 底边距(4)
    const number = floatingBallList === undefined ? this.listVm.floatingBallList.length : floatingBallList.length;
    const height = number * (FloatingBallStyle.ROW_HEIGHT + FloatingBallStyle.PADDING4) + FloatingBallStyle.PADDING4;
    log.showInfo(TAG, `outer panel height is ${height}`);
    return height;
  }

  /**
   * 外底板宽度
   * @returns
   */
  protected getOuterPanelWidth(rowWidth: number): number {
    return rowWidth + FloatingBallStyle.LENGTH8;
  }
}

/**
 * 悬浮球出场动效
 */
export class FloatingBallShowAnimation extends FloatingBallBaseAnimation {
  constructor(vmInjector: IFloatingBallInjector) {
    super(AnimationBase.NAMES.FLOATING_BALL_SHOW_ANIMATION, vmInjector);
  }

  public async animation(ball: FloatingBall): Promise<void> {
    log.showInfo(TAG, 'doShowAnimation');
    this.rectVm.isShowing = true;
    ball.opacity = 1;
    ball.scale = 1;
    this.updatePanelSize();
    this.panelVm.tryAvoidKeyboard(); // 尝试避让输入法
    let targetX: number = 0; // 目标坐标X
    if (this.rectVm.isRight) {
      // 右边时由于缩放中心为右边，需要调整位置贴到屏幕外
      const defaultX = this.rectVm.screenWidth - (1 - this.rectVm.scale) * this.panelVm.outerPanelWidth;
      this.rectVm.updatePosition(defaultX, this.rectVm.position.y);
      targetX = this.rectVm.screenWidth - this.panelVm.outerPanelWidth;
    } else {
      this.rectVm.updateScaleCenter('0%', '50%');
      this.rectVm.updatePosition(-this.panelVm.outerPanelWidth * this.rectVm.scale, this.rectVm.position.y);
    }
    const animateParam = this.getShowAnimation(targetX);
    log.showInfo(TAG, `do show animation, scale ${this.rectVm.scale},screenWidth ${this.rectVm.screenWidth},` +
      `containerWidth ${this.panelVm.outerPanelWidth}, current x ${this.rectVm.position.x}, targetX ${targetX},` +
      `tranX:${this.rectVm.translateX}`);
    await this.executeAnimation(animateParam);
  }

  private getShowAnimation(targetX: number): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const oldPositionY = this.rectVm.position.y;
    const tempTargetX = targetX - FloatingBallBaseAnimation.ANIMATION_VALUE_DIFF;
    const tempTargetY = oldPositionY - FloatingBallBaseAnimation.ANIMATION_VALUE_DIFF;
    animateParams.push(
      {
        curve: PANEL_TRANSLATE_CURVE,
        event: () => {
          this.rectVm.updatePosition(tempTargetX, tempTargetY);
        },
        finishCallbackFast: true,
        onFinish: () => {
          log.showInfo(TAG, 'translate logic finish');
          if (tempTargetX !==  this.rectVm.position.x || tempTargetY !== this.rectVm.position.y) {
            log.showInfo(TAG, 'position changed when show animation');
            return;
          }
          // 打断动效
          this.stopAnimation(() => {
            this.rectVm.updatePosition(targetX, oldPositionY);
          }, FloatingBallBaseAnimation.SIXTY_FPS_ANIMATION);
        },
        expectedFrameRateRange: FloatingBallBaseAnimation.SIXTY_FPS_ANIMATION,
      },
      {
        curve: PANEL_SCALE_CURVE,
        event: () => {
          this.rectVm.scale = 1;
        },
        expectedFrameRateRange: FloatingBallBaseAnimation.SIXTY_FPS_ANIMATION,
      },
      {
        duration: 150,
        curve: Curve.Sharp,
        event: () => {
          this.panelVm.opacity = 1;
        },
        onFinish: () => {
          this.rectVm.isShowing = false;
          this.listVm.freezePromise?.resolve();
          this.listVm.freezePromise = undefined;
        },
        expectedFrameRateRange: FloatingBallBaseAnimation.SIXTY_FPS_ANIMATION,
      },
    );
    return animateParams;
  }
}

/**
 * 悬浮球添加动效
 */
export class FloatingBallAddAnimation extends FloatingBallBaseAnimation {
  constructor(vmInjector: IFloatingBallInjector) {
    super(AnimationBase.NAMES.FLOATING_BALL_ADD_ANIMATION, vmInjector);
  }

  public async animation(ball: FloatingBall): Promise<void> {
    log.showInfo(TAG, 'doAddAnimation');
    const index = this.listVm.floatingBallList.indexOf(ball);
    if (index !== -1) {
      this.updateTranslateY(index, TranslateType.ADD);
    }
    const animateParam = this.getAddAnimation(ball);
    await this.executeAnimation(animateParam);
  }

  private getAddAnimation(ball: FloatingBall): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        curve: PANEL_CURVE,
        event: () => {
          this.updatePanelSize();
          this.resetTranslateY();
        },
        expectedFrameRateRange: FloatingBallBaseAnimation.SIXTY_FPS_ANIMATION,
      },
      {
        curve: BALL_SCALE_CURVE,
        event: () => {
          ball.scale = 1;
        },
        delay: 100,
        expectedFrameRateRange: FloatingBallBaseAnimation.SIXTY_FPS_ANIMATION,
      },
      {
        duration: 150,
        curve: Curve.Sharp,
        event: () => {
          ball.opacity = 1;
        },
        onFinish: () => {
          log.showInfo(TAG, 'finish update opacity');
          this.listVm.freezePromise?.resolve();
          this.listVm.freezePromise = undefined;
        },
        delay: 100,
        expectedFrameRateRange: FloatingBallBaseAnimation.SIXTY_FPS_ANIMATION,
      },
    );
    return animateParams;
  }
}

/**
 * 悬浮球更新动效
 */
export class FloatingBallUpdateAnimation extends FloatingBallBaseAnimation {
  constructor(vmInjector: IFloatingBallInjector) {
    super(AnimationBase.NAMES.FLOATING_BALL_UPDATE_ANIMATION, vmInjector);
  }

  public async animation(newBall: FloatingBall): Promise<void> {
    log.showInfo(TAG, 'doUpdateAnimation');
    const animateParam = this.getUpdateAnimation(newBall);
    await this.executeAnimation(animateParam);
  }

  private getUpdateAnimation(newBall: FloatingBall): AnimateParams[] {
    const persistentId = newBall.specificSession.session.persistentId;
    const fbTemplate = newBall.specificSession.session.fbTemplateInfo;
    let tempList = this.listVm.floatingBallList.slice();
    tempList = tempList.map((item) => {
      if (item.specificSession.session.persistentId === newBall.specificSession.session.persistentId) {
        return newBall;
      }
      return item;
    });
    const newRowWidth = this.listVm.calcMaxRowWidth(tempList);
    const newOuterPanelHeight = this.getOuterPanelHeight();
    const newOuterPanelWidth = this.getOuterPanelWidth(newRowWidth);

    const ball = this.listVm.getFloatingBall(persistentId) as FloatingBall;
    if (!ball) {
      log.showWarn(TAG, `not found ball by ${persistentId} when update`);
      return [];
    }
    if (this.panelVm.rowWidth === newRowWidth && this.panelVm.outerPanelHeight === newOuterPanelHeight &&
      this.panelVm.outerPanelWidth === newOuterPanelWidth) {
      log.showInfo(TAG, 'size not change, no need update animation');
      this.panelVm.fillTemplateToBall(ball, fbTemplate);
      return [];
    }
    const animateParams: AnimateParams[] = [];
    animateParams.push(
      {
        curve: PANEL_CURVE,
        event: () => {
          this.panelVm.rowWidth = newRowWidth;
          this.panelVm.outerPanelHeight = newOuterPanelHeight;
          this.panelVm.outerPanelWidth = newOuterPanelWidth;
        },
        onFinish: () => {
          log.showInfo(TAG, 'finish update opacity');
        },
      },
      {
        duration: 0,
        curve: Curve.Linear,
        event: () => {
          this.panelVm.fillTemplateToBall(ball, fbTemplate);
        }
      }
    );
    return animateParams;
  }
}

/**
 * 悬浮球删除动效
 */
export class FloatingBallRemoveAnimation extends FloatingBallBaseAnimation {
  constructor(vmInjector: IFloatingBallInjector) {
    super(AnimationBase.NAMES.FLOATING_BALL_REMOVE_ANIMATION, vmInjector);
  }

  public async animation(ball: FloatingBall): Promise<void> {
    log.showInfo(TAG, 'doRemoveAnimation');
    const animateParam = this.getRemoveAnimation(ball);
    await this.executeAnimation(animateParam);
  }

  private getRemoveAnimation(ball: FloatingBall): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const tempBallList = this.listVm.floatingBallList.slice();
    animateParams.push(
      {
        curve: BALL_SCALE_CURVE,
        event: () => {
          ball.scale = 0.25;
        },
        onFinish: () => {
          const index = this.listVm.floatingBallList.indexOf(ball);
          if (index !== -1) {
            log.showInfo(TAG, `remove animation finish, length ${this.listVm.floatingBallList.length}, index ${index}`);
            this.listVm.floatingBallList.splice(index, 1);
            this.resetTranslateY();
          }
          this.listVm.isRemovingBall = false;
          this.listVm.freezePromise?.resolve();
          this.listVm.freezePromise = undefined;
          SCBFloatingBallPanelVm.instance.removeSession([ball.specificSession.session.persistentId]);
        }
      },
      {
        duration: 150,
        curve: Curve.Sharp,
        event: () => {
          ball.opacity = 0;
        },
      },
      {
        curve: PANEL_CURVE,
        event: () => {
          const index = tempBallList.indexOf(ball);
          if (index !== -1) {
            tempBallList.splice(index, 1);
            this.updatePanelSize(tempBallList);
          }
          this.updateTranslateY(index, TranslateType.REMOVE);
        },
        delay: 100,
      },
    );
    return animateParams;
  }
}

/**
 * 悬浮球挤占动效
 */
export class FloatingBallSqueezeAnimation extends FloatingBallBaseAnimation {
  constructor(vmInjector: IFloatingBallInjector) {
    super(AnimationBase.NAMES.FLOATING_BALL_SQUEEZE_ANIMATION, vmInjector);
  }
  public async animation(ball: FloatingBall, deleteBall: FloatingBall): Promise<void> {
    log.showInfo(TAG, 'doSqueezeAnimation');
    const animateParam = this.getSqueezeAnimation(ball, deleteBall);
    await this.executeAnimation(animateParam);
  }
  private getSqueezeAnimation(ball: FloatingBall, deleteBall: FloatingBall): AnimateParams[] {
    const animateParams: AnimateParams[] = [];
    const tempBallList = this.listVm.floatingBallList.slice(0,-1);
    this.updateTranslateY(0, TranslateType.SQUEEZE);
    deleteBall.zIndex = 0; // 被删除的球zIndex降低
    animateParams.push(
      {
        curve: PANEL_CURVE,
        event: () => {
          this.updatePanelSize(tempBallList);
        },
      },
      {
        curve: BALL_SCALE_CURVE,
        event: () => {
          deleteBall.scale = 0.25;
          this.resetTranslateY(deleteBall); // 被删除的球不位移
        },
      },
      {
        duration: 150,
        curve: Curve.Sharp,
        event: () => {
          deleteBall.opacity = 0;
        },
      },
      {
        curve: BALL_SCALE_CURVE,
        event: () => {
          ball.scale = 1;
        },
        onFinish: () => {
          log.showInfo(TAG, 'squeeze animation finish');
          this.listVm.floatingBallList.pop();
          this.listVm.freezePromise?.resolve();
          this.listVm.freezePromise = undefined;
          SCBFloatingBallPanelVm.instance.removeSession([deleteBall.specificSession.session.persistentId]);
        },
        delay: 100,
      },
      {
        duration: 150,
        curve: Curve.Sharp,
        event: () => {
          ball.opacity = 1;
        },
        delay: 100,
      },
    );
    return animateParams;
  }
}

/**
 * 悬浮球面板消失动效
 */
export class FloatingBallClearAnimation extends FloatingBallBaseAnimation {
  constructor(vmInjector: IFloatingBallInjector) {
    super(AnimationBase.NAMES.FLOATING_BALL_CLEAR_ANIMATION, vmInjector);
  }

  public async animation(type: RemoveType, persistentIds: number[], tranX?: number, tranY?: number): Promise<void> {
    this.rectVm.isRemoving = true;
    if (type === RemoveType.DUMPSTER) {
      await this.doDumpsterClearAnimation(persistentIds, tranX, tranY);
    } else {
      await this.doPanClearAnimation(type, persistentIds);
    }
  }

  private async doDumpsterClearAnimation(persistentIds: number[], tranX?: number, tranY?: number): Promise<void> {
    log.showInfo(TAG, 'doDumpsterClearAnimation');
    this.panelVm.shadowRadius = 0; // 去除阴影
    await this.executeAnimation([
      {
        curve: Curve.Friction,
        duration: 100,
        event: () => {
          this.rectVm.outerPadding = FloatingBallStyle.PADDING4; // 撑大WindowScene面板，模糊闪控球边界
        },
      },
      {
        curve: DUMPSTER_PANEL,
        event: () => {
          this.rectVm.blurRadius = 35;
          this.panelVm.opacity = 0;
          this.rectVm.scale = 0.125;
          this.rectVm.translateX = tranX;
          this.rectVm.translateY = tranY;
        },
        onFinish: () => {
          log.showInfo(TAG, 'doDumpsterClearAnimation finish');
          // 还原开始拖拽时的位置
          this.rectVm.updatePosition(this.rectVm.position.positionX, this.rectVm.position.positionY);
          this.listVm.clearAll(RemoveType.DUMPSTER);
          this.rectVm.isRemoving = false;
          this.listVm.freezePromise?.resolve();
          this.listVm.freezePromise = undefined;
          SCBFloatingBallPanelVm.instance.removeSession(persistentIds);
        },
      }
    ]);
  }

  private async doPanClearAnimation(type: RemoveType, persistentIds: number[]): Promise<void> {
    log.showInfo(TAG, 'doPanClearAnimation');
    // 删除时以中心点缩放
    this.rectVm.updateScaleCenter('50%', '50%');
    const animateParam = this.getPanClearAnimation(type, persistentIds);
    await this.executeAnimation(animateParam);
  }

  private getPanClearAnimation(type: RemoveType, persistentIds: number[]): AnimateParams[] {
    return [
      {
        duration: 250,
        curve: PAN_CLEAR_OPACITY,
        event: () => {
          this.panelVm.opacity = 0;
          this.menuVm.opacity = 0;
        },
        onFinish: () => {
          log.showInfo(TAG, 'pan clear opacity finish');
        },
        expectedFrameRateRange: FloatingBallBaseAnimation.SIXTY_FPS_ANIMATION,
      },
      {
        duration: 250,
        curve: Curve.EaseInOut,
        event: () => {
          this.rectVm.scale = 0.25;
          this.menuVm.scale = 0.25;
        },
        onFinish: () => {
          log.showInfo(TAG, 'pan clear scale finish');
          this.listVm.clearAll(type);
          this.rectVm.isRemoving = false;
          this.listVm.freezePromise?.resolve();
          this.listVm.freezePromise = undefined;
          SCBFloatingBallPanelVm.instance.removeSession(persistentIds);
        },
        expectedFrameRateRange: FloatingBallBaseAnimation.SIXTY_FPS_ANIMATION,
      }];
  }
}
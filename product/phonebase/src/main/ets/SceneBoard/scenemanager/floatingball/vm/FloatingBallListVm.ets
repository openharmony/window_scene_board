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
import { ArkUIAdapter } from '@ohos/systemuicommon/src/main/ets/utils/ArkUIAdapter';
import { FloatingBallStyle } from '../constants/FloatingBallStyle';
import { ActionEvent, Constants, FBTemplate, RemoveType } from '../constants/FloatingConstants';
import { IFloatingBallListVm } from '../interface/IFloatingBallListVm';
import { FloatingBall } from '../model/FloatingBallModel';
import { FloatingBallBaseVm } from './FloatingBallBaseVm';
import { FloatingBallAddAnimation,
  FloatingBallClearAnimation,
  FloatingBallRemoveAnimation,
  FloatingBallShowAnimation,
  FloatingBallUpdateAnimation,
  FloatingBallSqueezeAnimation,
  LONG_PRESS_CURVE } from '../animation/FloatingBallAnimation';
import { CustomPromise } from '@ohos/frameworkwrapper';
import { MeasureUtils } from '@kit.ArkUI';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import { VibratorUtil } from '@ohos/systemuicommon';
import { AnimationBase } from '@ohos/systemuicommon/newIndex';
import { ClickFloatingBallParams, FloatingBallSysEventReporter,
  RemoveFloatingBallParams } from '../reporter/FloatingBallSysEventReporter';
import { RTLUtil } from '@ohos/componenthelper';
import { IFloatingBallInjector } from '../interface/IFloatingBallInjector';

const TAG = 'FloatingBallListVm';
const log = Logger.getLogHelper(LogDomain.WINDOW);

@ObservedV2
class FloatingBallArray extends Array<FloatingBall> {
}

@ObservedV2
export class FloatingBallListVm extends FloatingBallBaseVm implements IFloatingBallListVm {
  @Trace public floatingBallList = new FloatingBallArray();
  @Trace public isRtl: boolean = RTLUtil.getSystemRTL();

  @Trace public selectId: number = -1;

  public isRemovingBall: boolean = false;

  public freezePromise?: CustomPromise<void>;

  constructor(vmInjector: IFloatingBallInjector) {
    log.showInfo(TAG, 'list vm constructor');
    super(vmInjector);
  }

  public init(): void {
    RTLUtil.registerRtlChangeCallback(this.onRTLChangeEvent);
  }

  private onRTLChangeEvent = (isRTL: boolean): void => {
    log.showInfo(TAG, `rtl change to ${isRTL}`);
    this.isRtl = isRTL;
  };

  public getFloatingBall(persistentId: number): FloatingBall | undefined {
    return this.floatingBallList.find((ball) => ball.specificSession.session.persistentId === persistentId);
  }

  public isExist(persistentId: number) {
    return this.floatingBallList.some(item => item.specificSession.session.persistentId === persistentId);
  }

  public async addFloatingBall(ball: FloatingBall): Promise<void> {
    if (this.freezePromise) {
      log.showInfo(TAG, 'await addFloatingBall');
      await this.freezePromise;
    }
    this.freezePromise = new CustomPromise();
    const floatingBallLength = this.floatingBallList.length;
    log.showInfo(TAG, `add floating ball, current length ${floatingBallLength}`);
    // 检查悬浮球的个数,最多2个
    if (floatingBallLength >= Constants.MAX_NUMBER) {
      await this.squeezeFloatingBall(ball, this.floatingBallList[floatingBallLength - 1]);
      return;
    }
    this.floatingBallList.unshift(ball);
    // 第一个悬浮球
    if (floatingBallLength === 0) {
      new FloatingBallShowAnimation(this.vmInjector).animation(ball);
    } else {
      new FloatingBallAddAnimation(this.vmInjector).animation(ball);
    }
  }

  private async squeezeFloatingBall(ball: FloatingBall, deleteBall: FloatingBall): Promise<void> {
    log.showInfo(TAG, `start squeezeFloatingBall`);
    this.floatingBallList.unshift(ball);
    deleteBall.isRemoving = true;
    new FloatingBallSqueezeAnimation(this.vmInjector).animation(ball, deleteBall);
    const errorReason = this.sendFbActionEvent(deleteBall, ActionEvent.CLOSE) ? undefined : 'squeeze close event failed';
    this.reportRemove(deleteBall, RemoveType.SQUEEZE, errorReason);
  }

  public async updateFloatingBall(newBall: FloatingBall): Promise<void> {
    log.showInfo(TAG, `start updateFloatingBall ${newBall.specificSession.session.persistentId}`);
    if (this.freezePromise) {
      log.showInfo(TAG, 'await updateFloatingBall');
      await this.freezePromise;
    }
    new FloatingBallUpdateAnimation(this.vmInjector).animation(newBall);
  }

  public async removeFloatingBall(persistentId: number, type: RemoveType) {
    const ball = this.getFloatingBall(persistentId);
    if (!ball) {
      log.showInfo(TAG, `Cannot find floating ball for ${persistentId}`);
      return;
    }
    log.showInfo(TAG, `start delete ball, is removing ${ball.isRemoving}`);
    if (ball.isRemoving) {
      log.showInfo(TAG, `${persistentId} is removing`);
      return;
    }
    ball.isRemoving = true;
    log.showInfo(TAG, `current floating ball size: ${this.floatingBallList.length} del:${persistentId}`);
    if (this.freezePromise) {
      await this.freezePromise;
    }
    this.freezePromise = new CustomPromise();
    // 删除最后一个球，面板消失
    if (this.floatingBallList.length === 1) {
      new FloatingBallClearAnimation(this.vmInjector).animation(type, [ball.specificSession?.session.persistentId]);
    } else {
      this.isRemovingBall = true;
      new FloatingBallRemoveAnimation(this.vmInjector).animation(ball);
      const errorReason = this.sendFbActionEvent(ball, ActionEvent.CLOSE) ? undefined : 'send close event failed';
      this.reportRemove(ball, type, errorReason);
    }
    // 刷新层级
    SCBSceneSessionManager.getInstance().refreshZOrder();
  }

  public async clearAll(type: RemoveType, withAnim?: boolean): Promise<void> {
    try {
      const length = this.floatingBallList.length;
      log.showInfo(TAG, `clear all, len:${length}, withAnim ${withAnim}, type ${type}`);
      if (withAnim) {
        if (this.freezePromise) {
          await this.freezePromise;
        }
        this.freezePromise = new CustomPromise();
        new FloatingBallClearAnimation(this.vmInjector).animation(type,
          this.floatingBallList.map(ball => ball.specificSession?.session.persistentId));
      } else {
        // 发送close事件
        if (length) {
          this.floatingBallList.forEach((ball: FloatingBall) => {
            const persistentId: number = ball.specificSession.session.persistentId;
            log.showInfo(TAG, `clear each one ${persistentId}`);
            const isSuccess = this.sendFbActionEvent(ball, ActionEvent.CLOSE);
            this.reportRemove(ball, type, isSuccess ? undefined : 'send close event failed');
          })
        }
        // 清空列表
        this.floatingBallList = [];
      }
    } catch (err) {
      log.showError(TAG, `clearAll err, ${err}`);
    }
  }

  public onClick(ball: FloatingBall): void {
    log.showInfo(TAG, `float ball ${ball.specificSession?.session.persistentId} send click, bundle ${ball.specificSession?.session.bundleName}`);
    const isSuccess = this.sendFbActionEvent(ball, ActionEvent.CLICK);
    const errorReason = isSuccess ? '' : 'send click event failed';
    const param = new ClickFloatingBallParams();
    param.PACKAGE_NAME = ball.specificSession?.session.bundleName as string;
    param.TEMPLATE_TYPE = ball.template;
    param.BALL_NUM = this.floatingBallList.length;
    param.CLICK_INDEX = this.floatingBallList.indexOf(ball);
    param.ERROR_REASON = errorReason;
    FloatingBallSysEventReporter.reportClickFloatingBall(param);
  }

  public calcMaxRowWidth(floatingBallList?: FloatingBall[]): number {
    const calFloatingBallList = floatingBallList === undefined ? this.floatingBallList : floatingBallList;
    let maxWidth = 0;
    for (const item of calFloatingBallList) {
      let currentMax = 0;
      let titleWidth = 0;
      let contentWidth = 0;
      let iconWidth = 0;
      const template = item.template;
      const title = item.title;
      const content = item.content || '';
      switch (template) {
        case FBTemplate.STATIC:
          titleWidth = this.getWidthBySize(title, FloatingBallStyle.FONT_BODY_S);
          iconWidth = FloatingBallStyle.ICON_WIDTH + FloatingBallStyle.LENGTH4 * 2;
          // 文本长度 + 图标宽度+间距4*2 + 右边距6
          currentMax = titleWidth + iconWidth + FloatingBallStyle.LENGTH6;
          break;
        case FBTemplate.NORMAL:
          // 主文本
          titleWidth = this.getWidthBySize(title, FloatingBallStyle.FONT_CAPTION_L);
          // 辅助文本
          contentWidth = this.getWidthBySize(content, FloatingBallStyle.FONT_CAPTION_M);
          // 文本长度 + 两侧边距8*2
          currentMax = Math.max(titleWidth, contentWidth) + FloatingBallStyle.LENGTH8 * 2;
          break;
        case FBTemplate.EMPHATIC:
          // 强调文本
          titleWidth = this.getWidthBySize(title, FloatingBallStyle.FONT_BODY_M, FontWeight.Bold);
          // 辅助文本
          contentWidth = this.getWidthBySize(content, FloatingBallStyle.FONT_CAPTION_S, FontWeight.Bold);
          // 图标宽度
          iconWidth = FloatingBallStyle.ICON_WIDTH + FloatingBallStyle.LENGTH4 * 2;
          // 文本长度 + 图标宽度 + 右边距8
          currentMax = Math.max(titleWidth, contentWidth) + FloatingBallStyle.LENGTH8 + iconWidth;
          break;
        case FBTemplate.SIMPLE:
          // 纯文本
          titleWidth = this.getWidthBySize(title, FloatingBallStyle.FONT_CAPTION_M);
          // 文本长度 + 两侧边距8*2
          currentMax = titleWidth + FloatingBallStyle.LENGTH8 * 2;
          break;
        default:
          log.showInfo(TAG, `calcMaxRowWidth default`);
          break;
      }
      if (currentMax > maxWidth) {
        maxWidth = currentMax;
      }
    }
    const innerMinWidth = FloatingBallStyle.INNER_ROW_MIN_WIDTH;
    const innerMaxWidth = FloatingBallStyle.INNER_ROW_MAX_WIDTH;
    const rowWidth = Math.max(innerMinWidth, Math.min(maxWidth, innerMaxWidth));
    log.showInfo(TAG, `maxWidth: ${maxWidth}, rowWidth: ${rowWidth}`);
    return rowWidth;
  }

  private getWidthBySize(text: string, fontSize: Length, fontWeight: FontWeight = FontWeight.Medium): number {
    return Math.ceil(ArkUIAdapter.px2vp(this.measureTextWidth(text, fontSize, fontWeight)));
  }

  private measureTextWidth(textContent: string, fontSize: Length, fontWeight: FontWeight): number {
    let textWidth = 0;
    try {
      const uiContextMeasure = ArkUIAdapter?.uiContext?.getMeasureUtils() as MeasureUtils;
      // 单位(px)
      textWidth = uiContextMeasure.measureText({
        textContent: textContent,
        fontSize: fontSize,
        fontWeight: fontWeight
      });
    } catch (err) {
      log.showError(TAG, `measureTextWidth err ${err}`);
    }
    return textWidth;
  }

  /**
   * 通知底层事件
   * @param persistentId
   * @param action
   */
  private sendFbActionEvent(ball: FloatingBall, action: ActionEvent): boolean {
    try {
      if (!ball.specificSession?.session) {
        log.showInfo(TAG, `float ball session is not valid`);
        return false;
      }
      log.showInfo(TAG, `sendFbActionEvent ${ball.specificSession.session.persistentId} ${action}`);
      ball.specificSession.session.sendFbActionEvent(action);
      return true;
    } catch (err) {
      log.showError(TAG, `sendFbActionEvent ${action} err, ${err}`);
    }
    return false;
  }

  public onLongPressShowMenu(event: GestureEvent, persistentId: number): void {
    if (event?.source === SourceType.Mouse) {
      log.showWarn(TAG, 'onLongPressVibrator, not response for Mouse');
      return;
    }
    const panelVm = this.vmInjector.getPanelVm();
    const menuVm = this.vmInjector.getMenuVm();
    const rectVm = this.vmInjector.getRectVm();
    menuVm.init(panelVm.outerPanelWidth, panelVm.outerPanelHeight);
    rectVm.updateScaleCenter('50%', '50%');
    log.showInfo(TAG, `onLongPressShowMenu ${persistentId}`);
    TraceUtil.startTrace(DomainName.SYS_UI, TraceUtil.MENU_SHOW_AND_HIDE);
    const longPressAnimation: AnimationBase = new AnimationBase(AnimationBase.NAMES.FLOATING_BALL_LONG_PRESS_ANIMATION,
      true);
    longPressAnimation.executeAnimation([{
      curve: LONG_PRESS_CURVE,
      duration: 300,
      event: () => {
        this.setOtherBallsOpacity(persistentId, FloatingBallStyle.UN_SELECTED_OPACITY);
        panelVm.overlayOpacity = 0.5;
      },
      onFinish: () => {
        this.selectId = persistentId;
      }
    }]);
    menuVm.isShow = true;
    VibratorUtil.startVibration('haptic.long_press_medium', 'touch');
  }

  private setOtherBallsOpacity(persistentId: number, opacity: number): void {
    this.floatingBallList.forEach((ball) => {
      if (ball.specificSession?.session.persistentId === persistentId) {
        return;
      }
      ball.opacity = opacity;
    });
  }

  public restoreAllFloatingBallsOpacity(): void {
    this.floatingBallList.forEach(ball => ball.opacity = 1);
  }

  private reportRemove(ball: FloatingBall, type: RemoveType, errorReason?: string): void {
    const removeType = type < 0 ? 0 : 1; // 0 应用删除， 1 用户删除
    const userRemoveType = type < 0 ? undefined : type;
    const param = new RemoveFloatingBallParams();
    param.PACKAGE_NAME = ball.specificSession?.session.bundleName as string;
    param.TEMPLATE_TYPE = ball.template;
    param.REMOVE_TYPE = removeType;
    param.USER_REMOVE_TYPE = userRemoveType;
    param.ERROR_REASON = errorReason;
    FloatingBallSysEventReporter.reportRemoveFloatingBall(param);
  }

  public destroy() {
    this.freezePromise = undefined;
    RTLUtil.unregisterRtlChangeCallback(this.onRTLChangeEvent);
    log.showInfo(TAG, 'listVm destroy');
  }
}
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

import curves from '@ohos.curves';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { OverlayCardTransition, SCBTransitionManager } from '@ohos/windowscene';
import { DeviceHelper, CustomPromise } from '@ohos/frameworkwrapper';
import type { OverlayTransitionParam } from '../overlay/OverlayStartAnimHelper';
import { Singleton } from '../utils/Singleton';
import { AnimationBase } from './AnimationBase';
import { OverlayAnimType, OverlayCardInfo } from '../overlay/OverlayCardInfo';
import { CutoutVm } from '../statusbar/vm/CutoutVm';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { DisplayRotationState, DisplaySizeState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { DeviceModeEnum } from '@ohos/commonconstants/src/main/ets/TsIndex';
import { DeviceInfoVm } from '../vm/DeviceInfoVm';
import { LiveApsUtils } from '../utils/LiveApsUtils';
import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { SysTypeCode } from '../liveview/common/LiveConstants';
import { StatusBarCapsulePosition } from '../statusbar/model/StatusBarCapsulePosition';
import { LiveStyle } from '../live/constants/LiveStyle';
import { ResourceVm } from '../vm/ResourceVm';
import { ArkUIAdapter } from '../utils/ArkUIAdapter';

const TAG = 'SwipeAppToCapsuleAnimation';
const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

const ANIM_CURVE = curves.springMotion(0.475, 0.875);

export interface CapsuleAppInfo {
  bundleName: string;
  appIndex: number;
  typeCode: SysTypeCode;
  hashCode: string;
}

export enum CheckStage {
  START_CHECK = 0,
  END_CHECK = 1,
  PHONE_CHECK = 2,
}

export class SwipeAppToCapsuleAnimation {
  @Singleton.decorate()
  public static get instance(): SwipeAppToCapsuleAnimation { return new SwipeAppToCapsuleAnimation(); }
  public exeDelayPromise?: CustomPromise<void>;
  public isExecuting: boolean = false;

  private animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.SWIPE_APP_TO_CAPSULE);
  private animationNums: number[] = [];
  private checker?: (bundleName: string, appIndex: number) => boolean;
  private checkStageCallback?: (checkStage: CheckStage, hashCode?: string) => void;

  private capsuleAppArray: CapsuleAppInfo[] = [];

  private capsulePosition: StatusBarCapsulePosition = new StatusBarCapsulePosition();

  private constructor() {}

  public setCapsuleAppArray(capsuleAppArray: CapsuleAppInfo[]) {
    this.capsuleAppArray = capsuleAppArray;
  }

  public setCapsulePosition(statusBarCapsulePosition: StatusBarCapsulePosition) {
    this.capsulePosition = statusBarCapsulePosition;
  }

  private checkIsApp2Capsule(bundleName: string, appIndex: number, needRemoveSession?: boolean): boolean {
    log.showInfo(`checkIsApp2Capsule bundleName ${bundleName} appIndex ${appIndex}`);
    const capsuleAppInfo = this.capsuleAppArray.find((capsuleAppInfo: CapsuleAppInfo) => {
      return (capsuleAppInfo.bundleName === bundleName) && (capsuleAppInfo.appIndex === appIndex);
    });

    if (!capsuleAppInfo) {
      log.showInfo('not capsule app.');
      return false;
    }

    if (needRemoveSession) {
      if (capsuleAppInfo.typeCode === SysTypeCode.PHONE) {
        log.showWarn('capsule is phone, need to delete.');
        this.checkStageCallback?.(CheckStage.PHONE_CHECK, capsuleAppInfo.hashCode);
      }

      log.showInfo('app is remove.');
      return false;
    }

    return true;
  }

  /**
   * 检查并执行应用回胶囊动效，由窗口回调
   *
   * @param overlayTransitionParam
   * @returns
   */
  public checkAndExecute(overlayTransitionParam: OverlayTransitionParam): boolean {
    const bundleName = overlayTransitionParam.containerSession.primarySession?.sceneInfo?.bundleName ?? '';
    const appIndex = overlayTransitionParam.containerSession.primarySession?.sceneInfo?.appIndex ?? 0;

    if (!this.checkDeviceSupport()) {
      this.checkIsApp2Capsule(bundleName, appIndex, overlayTransitionParam.needRemoveSession);
      return false;
    }

    try {
      let result = false;
      if (this.checker !== undefined) {
        result = this.checker(bundleName, appIndex);
      } else {
        result = this.checkIsApp2Capsule(bundleName, appIndex, overlayTransitionParam.needRemoveSession);
      }
      log.showInfo(`Check SwipeAppToCapsule, bundleName: ${bundleName}, appIndex: ${appIndex}, result: ${result}`);
      if (!result) {
        return false;
      }
      this.checkStageCallback?.(CheckStage.START_CHECK);
      this.exeDelayPromise = new CustomPromise();
      this.initContainerSession(overlayTransitionParam);
      this.setSessionInitState(overlayTransitionParam);
      this.setSessionFinalState(overlayTransitionParam);
    } catch (e) {
      log.error(`Check SwipeAppToCapsule, bundleName: ${bundleName}, appIndex: ${appIndex} error:`, e);
    }
    return true;
  }

  /**
   * 注册检查是否需要应用回胶囊的检查器
   * @param checker
   */
  public registerChecker(checker: (bundleName: string, appIndex: number) => boolean): void {
    this.checker = checker;
  }


  /**
   * 注册检查是否需要应用回胶囊的检查器
   * @param checker
   */
  public registerCheckerStageCallback(callback: (checkStage: CheckStage, hashCode?: string) => void): void {
    this.checkStageCallback = callback;
  }

  /**
   * 检查设备是否支持调用回胶囊动效
   */
  private checkDeviceSupport(): boolean {
    // 手机非折叠屏展开态，横屏时不支持回胶囊动效
    if (DeviceHelper.isPhone()) {
      // 宽度大于高度的1.5/2倍，认为此时窄屏横屏
      const sizeState = baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState;
      const ratio = 2;
      if (sizeState.displayWidth >= sizeState.displayHeight * ratio) {
        log.showInfo('checkSupportCapsuleAnim not support by landscape.');
        return false;
      }

      // 手机窄屏，180度旋转不支持回胶囊动效
      const rotationState = baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_ROTATION) as DisplayRotationState;
      if (rotationState?.isPortraitNegative()) {
        log.showInfo('checkSupportCapsuleAnim not support by rotation.');
        return false;
      }
    }

    if (AppStorage.get('deviceModeState') === DeviceModeEnum.EMERGENCY_MODE) {
      return false;
    }

    return true;
  }

  /**
   * 初始化应用窗口容器
   * @param overlayTransitionParam
   */
  private initContainerSession(overlayTransitionParam: OverlayTransitionParam): void {
    const containerSession = overlayTransitionParam.containerSession;
    const panelManager = overlayTransitionParam.scenePanelManager;
    const blurTransitionCount = panelManager.addBlurTransitionCountAndReturnValue();
    const controller = overlayTransitionParam.containerSession.transitionController;

    // 开启退出动效
    if (controller) {
      SCBTransitionManager.getInstance().notifySceneTransitionOut(controller, false)
    };
    // 应用回胶囊，不回桌面
    containerSession.overlayCardTransition = null;
    // 桌面存在动效，直接复位
    SCBTransitionManager.getInstance().getCurrentTransitionController()?.onInactive?.();
    // 存在跳转应用则重置
    overlayTransitionParam.toContainerSession?.init();
    overlayTransitionParam.toContainerSession?.needRenderBorderRadius.setBorderRadiusWithDfx(0,
      TAG, 'initCapsuleTransition', overlayTransitionParam.toContainerSession?.getName());
    // 窗口动效计数
    containerSession.addTransitionCount();
    this.animationNums.push(containerSession.getTransitionCount());
  }

  /**
   * 设置应用窗口动画开始状态
   * @param overlayTransitionParam
   */
  private setSessionInitState(overlayTransitionParam: OverlayTransitionParam): void {
    const containerSession = overlayTransitionParam.containerSession;
    const sessionName = containerSession.getName();
    const deviceRadius = DeviceHelper.getDeviceRadius();

    // 面板起始状态
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'init', sessionName);
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(deviceRadius, TAG, 'init', sessionName);
  }

  /**
   * 设置应用窗口动画结束状态
   * @param overlayTransitionParam
   */
  private async setSessionFinalState(overlayTransitionParam: OverlayTransitionParam): Promise<void> {
    const containerSession = overlayTransitionParam.containerSession;
    const sessionName = containerSession.getName();

    try {
      const anchor = this.getAnchor();
      const screedWidth = px2vp(containerSession.screenProperty.width);
      const screenHeight = px2vp(containerSession.screenProperty.height);
      this.checkStageCallback?.(CheckStage.END_CHECK);
      this.isExecuting = true;
      setTimeout(() => {
        this.exeDelayPromise?.resolve();
        this.exeDelayPromise = undefined;
      }, 100);
      LiveApsUtils.setLiveApsScene(StyleConstants.DEFAULT_1);
      await this.animation.executeAnimation([
        {
          curve: ANIM_CURVE,
          event: () => {
            // 面板移动到挖孔位置
            containerSession.needRenderTranslate.setTranslateXWithDfx(anchor.x as number - screedWidth / 2, TAG,
              'startCapsuleTransition', sessionName);
            containerSession.needRenderTranslate.setTranslateYWithDfx(anchor.y as number - screenHeight / 2, TAG,
              'startCapsuleTransition', sessionName);

            // 面板缩放
            containerSession.needRenderScale.setScaleXWithDfx(1 / screenHeight,
              TAG, 'startCapsuleTransition', sessionName);
            containerSession.needRenderScale.setScaleYWithDfx(1 / screenHeight,
              TAG, 'startCapsuleTransition', sessionName);

            // 面板模糊
            containerSession.needRenderBlurRadius.setBlurRadiusWithDfx(120, TAG, 'startCapsuleTransition', sessionName);
          },
          finishCallbackFast: true
        },
      ]);
      LiveApsUtils.setLiveApsScene(StyleConstants.DEFAULT_0);
      this.isExecuting = false;
      this.reset(overlayTransitionParam);
      log.showInfo(`Start for Swipe App Animation complete`);
    } catch (e) {
      log.error(`setSessionFinalState Swipe App Animation error:`, e);
    }
  }

  /**
   * 动画完成后重置状态
   * @param overlayTransitionParam
   */
  private reset(overlayTransitionParam: OverlayTransitionParam): void {
    const containerSession = overlayTransitionParam.containerSession;
    const panelManager = overlayTransitionParam.scenePanelManager;
    const topContainerSession = panelManager.getSceneContainerSessionList().getTopActiveSession();

    // 通话退回胶囊后，如果上级页面为应用，需要把背景蒙层置顶
    if (topContainerSession) {
      panelManager.enableBlurComponent('setBlurComponent topContainerSession');
    }

    // 移除session
    const needRemoved =
      containerSession.transitionOutFinishIfNeed(this.animationNums[0] ?? containerSession.getTransitionCount());
    if (needRemoved && overlayTransitionParam.needRemoveSession) {
      containerSession.clearContainerSessionData();
    }

    if (containerSession.pendingRemove && overlayTransitionParam.needRemoveSession) {
      panelManager.removeSceneContainerSession(containerSession);
    }

    containerSession.overlayCardTransition = null;
    this.animationNums.shift();
  }

  /**
   * 创建动效卡片信息
   *
   * @param bundleName 应用包名
   * @param checkResult 胶囊检测值
   * @returns 卡片信息
   */
  private buildOverlayTransition(): OverlayCardTransition {
    const transition = new OverlayCardTransition();
    const cardInfo = new OverlayCardInfo(OverlayAnimType.TYPE_EXIT_CAPSULE);

    transition.overlayCardInfo = cardInfo;

    return transition;
  }

  /**
   * 获取应用上滑锚点位置
   */
  private getAnchor(): Position {
    // 三折叠适配
    if (DeviceInfoVm.instance.isXTSpecialState()) {
      const position: Position = {
        x: CutoutVm.instance.left + CutoutVm.instance.holeRadius + LiveStyle.CAPSULE_HEIGHT / 2 +
        LiveStyle.CAPSULE_LEFT_STATUS_BAR_GAP_WITHOUT_HOLE + LiveStyle.CAPSULE_CIRCLE_WIDTH / 2,
        y: CutoutVm.instance.top + CutoutVm.instance.height / 2
      }
      log.info('getAnchor for XTSpecialState: ', position);
      return position;
    }

    if (!CutoutVm.instance.isMiddleCutout()) {
      const translate = this.capsulePosition.left + LiveStyle.CAPSULE_LEFT_STATUS_BAR_GAP_WITHOUT_HOLE +
        LiveStyle.CAPSULE_CIRCLE_WIDTH / 2;
      const position: Position = {
        x: ResourceVm.instance.isRTL ? ArkUIAdapter.px2vp(DeviceInfoVm.instance.width) - translate : translate,
        y: this.capsulePosition.top + this.capsulePosition.height / 2
      };
      log.info('getAnchor: ', position);

      return position;
    }

    const holeNum = CutoutVm.instance.holeNum;
    if (holeNum === 3) {
      const hole = CutoutVm.instance.holes[1];
      return {
        x: hole.centerX,
        y: hole.centerY,
      };
    }

    if (holeNum === 2) {
      const hole = CutoutVm.instance.holes[0];
      return {
        x: CutoutVm.instance.left + CutoutVm.instance.width / 2,
        y: hole.centerY,
      };
    }

    if (holeNum === 1) {
      const hole = CutoutVm.instance.holes[0];
      return {
        x: hole.centerX,
        y: hole.centerY,
      };
    }

    return { x: 0, y: 0 };
  }
}
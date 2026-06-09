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
  CommonUtils,
  LogDomain,
  LogHelper,
  TraceUtil,
  DomainName,
  RectInfo,
  StartType,
} from '@ohos/basicutils';
import { DeviceHelper, SCBDesktopCacheManager, CustomPromise, ApsUtils, } from '@ohos/frameworkwrapper';
import { RTLUtil } from '@ohos/componenthelper';
import { DeviceModeEnum } from '@ohos/commonconstants';
import {
  SCBSceneSessionManager,
  OverlayCardTransition,
  SCBScenePanelManager,
  SCBScreenSessionManager,
  SCBTransitionManager,
  SCBTransitionController,
  SCBSceneContainerSession,
  SCBSceneSession,
  SCBScenePanelSession,
} from '@ohos/windowscene';
import { IOverlayCard, OverlayCardInfo, OverlayCardState, OverlayAnimType, OverlayAnimScene, } from './OverlayCardInfo';
import HiTrace from '@ohos.hiTraceMeter';
import SceneSessionManager from '@ohos.sceneSessionManager';
import curves from '@ohos.curves';
import { LiveViewCapsuleStyle } from '../liveview/common/LiveViewCapsuleStyle';
import { baseStateMgr } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseStateManager';
import { DisplayRotationState, StateType } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import type { DisplaySizeState } from '@ohos/systemuiutils/src/main/ets/sysdialog/BaseState';
import { LiveCapsuleData } from '../liveview/data/capsule/LiveCapsuleData';
import { capsuleStateMgr } from '../liveview/CapsuleManager';
import { CapsuleAnimStyle } from '../liveview/info/capsule/CapsuleAnimStyle';
import { DefaultPanelZIndex } from '../base/common/info/DefaultPanelZIndex';
import { CapsuleShowType } from '../liveview/common/LiveConstants';
import { LiveViewData } from '../liveview/data/LiveViewData';
import DropDownPanelManager from '../manager/DropDownPanelManager';
import OverlayAnimGuarantee from './OverlayAnimGuarantee'
import { OverlayAnimation } from '../animation/OverlayAnimation';
import { StartAppOneMirrorAnimation } from '../animation/StartAppOneMirrorAnimation';
import { SwipeAppToCapsuleAnimation } from '../animation/SwipeAppToCapsuleAnimation';
import { FloatingBallOneMirrorAnimation } from '../animation/FloatingBallOneMirrorAnimation';
import { CapsuleListState } from '../liveview/info/capsule/CapsuleListState';
import { LiveApp2CapsuleEvent } from '../event/LiveViewEvent';
import { InnerEventUtil } from '../utils/InnerEventUtil';
// import apsManager from '@hms.graphic.apsManager';
import { APSSceneState } from '../constants/SystemuiConstants';

const TAG = 'OverlayStartAnimHelper';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * 动效trace标签
 */
const TRACE_TAG = 'START_SCENE_PHASE';
const CAPSULE_CURVES = curves.springMotion(0.55, 0.925, 0);
const OUTER_CAPSULE_CURVES = curves.springMotion(0.475, 0.85, 0);

/**
 * overlay动效参数
 */
export interface OverlayTransitionParam {
  /**
   * 应用页面容器session
   */
  containerSession: SCBSceneContainerSession;

  /**
   * 跳转页面容器session
   */
  toContainerSession?: SCBSceneContainerSession | null;

  /**
   * 动效控制器
   */
  transitionController?: SCBTransitionController;

  /**
   * 页面面板管理器
   */
  scenePanelManager: SCBScenePanelManager;

  /**
   * 页面面板session
   */
  scenePanelSession?: SCBScenePanelSession;

  /**
   * 页面session
   */
  sceneSession?: SCBSceneSession;

  /**
   * 动效完成是否移除session
   */
  needRemoveSession?: boolean;

  /**
   * overlay动效场景类型，用于维测打点区分触发场景
   */
  triggerType: string;

  /**
   * 启动应用是否位于前台
   */
  isActive?: boolean;
}

/**
 * 胶囊应用检测结果
 */
export interface CapsuleCheckResult {
  /**
   * 胶囊数据，存在数据则表示为胶囊应用
   */
  capsuleData?: LiveViewData;

  /**
   * 应用胶囊是否为top胶囊
   */
  isTopCapsule?: boolean;

  /**
   * 当前是否多胶囊状态
   */
  isMultiCapsule?: boolean;

  /**
   * 当前胶囊组件是否显示
   */
  isCapsuleCurrentShow?: boolean;

  /**
   * 顶部胶囊数据
   */
  topCapsule?: LiveViewData;
}

/**
 * 应用退出到胶囊动效状态
 */
export interface ExitCapsuleAnimState {
  /**
   * 是否动效中，感知动效开始、结束
   */
  isAnimating: boolean;

  /**
   * 动效胶囊是否为上层胶囊
   */
  isOverCapsule: boolean;

  /**
   * 动效胶囊数据
   */
  animCapsuleData?: LiveViewData;

  /**
   * 是否动效被取消
   */
  isCancel?: boolean;
}

/**
 * 应用退出到胶囊，数据检测参数
 */
export interface ExitCapsuleCheckParam {
  /**
   * 目标应用包名
   */
  bundleName?: string;

  /**
   * 应用分身id
   */
  appIndex?: number;

  /**
   * 是否结束窗口session
   */
  isRemoveSession?: boolean;
}

/**
 * 检测APP是否为胶囊应用
 */
export type OnCheckCapsuleAppListener = (param: ExitCapsuleCheckParam) => CapsuleCheckResult;

/**
 * 应用退出到胶囊动效监听
 */
export type OnExitCapsuleAnimListener = (state: ExitCapsuleAnimState) => void;

/**
 * 取消应用退出胶囊动效监听
 */
type OnCancelExitCapsuleAnimListener = () => void;

/**
 * 胶囊动效相关参数缓存
 */
class CapsuleAnimParam {

  /**
   * 实况胶囊状态
   */
  private capsuleListState: CapsuleListState = capsuleStateMgr.getCapsuleState();
  /**
   * 胶囊位置信息
   */
  public capsulePosition: RectInfo = new RectInfo().setWidth(0).setHeight(this.capsuleListState.capsuleHeight);

  /**
   * 动效胶囊样式
   */
  public capsuleStyle: CapsuleAnimStyle = new CapsuleAnimStyle();
  /**
   * 胶囊圆角
   */
  public capsuleRadius: number = LiveViewCapsuleStyle.CAPSULE_RADIUS;
  /**
   * 胶囊应用检测器
   */
  public checkCapsuleListener?: OnCheckCapsuleAppListener;
  /**
   * 胶囊退出动效监听器
   */
  public exitCapsuleListener: Set<OnExitCapsuleAnimListener> = new Set();

  /**
   * 标记是否动效中
   */
  public isAnimating: boolean = false;

  /**
   * 取消退出胶囊动效
   */
  private cancelExitAnimListener?: OnCancelExitCapsuleAnimListener;


  constructor() {
    // 动效胶囊无背景
    this.capsuleStyle.backgroundColor = '#00000000';
    this.capsuleStyle.capsuleShowType = CapsuleShowType.SHOW;
  }

  /**
   * 设置中断退出胶囊动效监听器
   *
   * @param listener 监听器
   */
  setOnCancelExitAnimListener(listener?: OnCancelExitCapsuleAnimListener): void {
    this.cancelExitAnimListener = listener;
  }

  /**
   * 请求中断退出胶囊动效
   */
  requestCancelExitCapsuleAnim(): void {
    this.cancelExitAnimListener?.();
  }

  /**
   * 设置检测胶囊应用监听器
   *
   * @param listener 监听器
   */
  setOnCheckCapsuleAppListener(listener: OnCheckCapsuleAppListener): void {
    this.checkCapsuleListener = listener;
  }

  /**
   * 注册退出胶囊动效监听器
   *
   * @param listener 监听器
   */
  registerExitCapsuleAnimListener(listener: OnExitCapsuleAnimListener): void {
    this.exitCapsuleListener.add(listener);
  }

  /**
   * 注销退出胶囊动效监听器
   *
   * @param listener 监听器
   */
  unregisterExitCapsuleAnimListener(listener: OnExitCapsuleAnimListener): void {
    this.exitCapsuleListener.delete(listener);
  }

  /**
   * 胶囊全局位置
   *
   * @param position 位置
   */
  setCapsuleGlobalPosition(position: Area): void {
    this.capsulePosition.height = this.capsuleListState.capsuleHeight;
    // 当没高度时折算top，有高度时以global为准
    let halfHeight = (position.height as number) === 0 ? (this.capsulePosition.height!) / 2 : 0;
    let global = position.globalPosition;
    this.capsulePosition.top = (global.y as number) - halfHeight;
    if (RTLUtil.isRTL()) {
      const x = global.x as number;
      const width = position.width as number;
      this.capsulePosition.right = x + width;
    } else {
      this.capsulePosition.left = global.x as number;
    }
    this.refreshCapsulePosition();
  }

  /**
   * 设置胶囊宽度
   *
   * @param width 宽度
   */
  setCapsuleWidth(width: number): void {
    this.capsulePosition.width = width;
    this.refreshCapsulePosition();
  }

  /**
   * 刷新胶囊位置
   */
  private refreshCapsulePosition(): void {
    // 计算胶囊位置
    this.capsulePosition.bottom = this.capsulePosition.top + this.capsulePosition.height!;
    if (RTLUtil.isRTL()) {
      this.capsulePosition.left = this.capsulePosition.right - this.capsulePosition.width!;
    } else {
      this.capsulePosition.right = this.capsulePosition.left + this.capsulePosition.width!;
    }
  }
}

/**
 * 卡片启动动效相关数据缓存
 */
class StartAnimFromCardInfo {
  public onFinish?: () => void;
}

/**
 * overlay卡片启动动效工具
 * 用于通知卡片、胶囊卡片动效场景
 */
export class OverlayStartAnimHelper {
  /**
   * 缓存胶囊动效参数
   */
  private static capsuleParam: CapsuleAnimParam = new CapsuleAnimParam();
  /**
   * 卡片启动动效相关数据
   */
  private static startAnimFromCardInfo: StartAnimFromCardInfo = new StartAnimFromCardInfo();

  // TransitionIn
  public static readonly TRIGGER_TYPE_TRANSITION_IN: string = 'TransitionIn';
  // 对应 TraceUtil.CORE_METHOD_APP_SWIPE_UP_TO_CAPSULE
  public static readonly TRIGGER_TYPE_APP_SWIPE_UP_TO_CAPSULE: string = 'AppSwipeUpToCapsule';
  // 对应 TraceUtil.CORE_METHOD_APP_BACK_TO_CAPSULE
  public static readonly TRIGGER_TYPE_APP_BACK_TO_CAPSULE: string = 'AppBackToCapsule';
  // 对应 TraceUtil.CORE_METHOD_UN_LOCK_TO_CAPSULE
  public static readonly TRIGGER_TYPE_UN_LOCK_TO_CAPSULE: string = 'UnLockToCapsule';

  /**
   * 正在做动效的Promise
   */
  public static animPromise?: CustomPromise<void>

  /**
   * 设置胶囊全局位置
   *
   * @param position 位置
   */
  static setCapsuleGlobalPosition(position: Area): void {
    OverlayStartAnimHelper.capsuleParam.setCapsuleGlobalPosition(position);
  }

  /**
   * 请求中断退出胶囊动效
   */
  static requestCancelExitCapsuleAnim(): void {
    OverlayStartAnimHelper.capsuleParam.requestCancelExitCapsuleAnim();
  }

  /**
   * 设置胶囊应用检测器
   *
   * @param listener 检测器
   */
  static setOnCheckCapsuleAppListener(listener: OnCheckCapsuleAppListener): void {
    OverlayStartAnimHelper.capsuleParam.setOnCheckCapsuleAppListener(listener);
  }

  /**
   * 注册应用退出胶囊动效监听器
   *
   * @param listener 监听器
   */
  static registerExitCapsuleAnimListener(listener: OnExitCapsuleAnimListener): void {
    OverlayStartAnimHelper.capsuleParam.registerExitCapsuleAnimListener(listener);
  }

  /**
   * 注销应用退出胶囊动效监听器
   *
   * @param listener 监听器
   */
  static unregisterExitCapsuleAnimListener(listener: OnExitCapsuleAnimListener): void {
    OverlayStartAnimHelper.capsuleParam.unregisterExitCapsuleAnimListener(listener);
  }

  private static notifyExitCapsuleListener(param: ExitCapsuleAnimState): void {
    InnerEventUtil.post(LiveApp2CapsuleEvent, new LiveApp2CapsuleEvent(param.isAnimating));
    OverlayStartAnimHelper.capsuleParam.exitCapsuleListener.forEach((listener) => {
      listener?.(param);
    });
  }

  /**
   * overlay卡片启动前，动效准备
   *
   * @param card 卡片数据
   */
  static startAnimPre(card: IOverlayCard, scene?: number): SCBTransitionController | undefined {
    if (CommonUtils.isInvalid(card)) {
      log.showWarn('startAnimPre card is invalid.');
      return undefined;
    }

    // overlay卡片信息
    let overlayInfo = new OverlayCardInfo(card?.animType, card.cardBgId, card.cardContentId);
    if (card.cardPosition) {
      // 使用指定的位置更新卡片信息
      overlayInfo.setCardBgPosition(card.cardPosition);
      overlayInfo.setCardContentPosition(card.cardPosition);
    }
    if (card?.cardContentPosition) {
      // 使用指定的位置更新卡片信息
      overlayInfo.setCardContentPosition(card?.cardContentPosition);
    }
    if (card?.cardResource) {
      overlayInfo.setCardResource(card?.cardResource);
    }
    overlayInfo.castFromCard(card);

    if (scene === OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN) {
      overlayInfo.overlayComponentZIndex = -1;
    }

    // 动效启动回调
    let active = (): void => {
      if (!CommonUtils.isInvalid(card.onAnimActive)) {
        let onActive = card.onAnimActive as (() => void);
        onActive();
      }
    };

    // 动效结束回调
    let inactive = (controller: SCBTransitionController): void => {
      if (!CommonUtils.isInvalid(card.onAnimInactive)) {
        let onInactive = card.onAnimInactive as (() => void);
        onInactive();
        SCBTransitionManager.getInstance().cleanTransition(controller);
      }
    };

    // 动效控制器
    let controller: SCBTransitionController = {
      appData: {
        bundleName: '',
        abilityName: '',
        appIconId: '',
        iconRadius: 0,
        appIconNumber: 0,
      },
      overlayCardInfo: overlayInfo,
      onActive: active,
      onInactive: () => inactive(controller)
    };
    SCBTransitionManager.getInstance().setOverlayCardTransitionController(controller);
    log.showWarn('SetOverlayCardTransitionController on startAnimPre for %{public}s,', overlayInfo.startBundleName);
    return controller;
  }

  /**
   * 重置动效控制器
   */
  static resetOverlayTransition(reason?: string): void {
    log.showWarn('ResetOverlayTransition for %{public}s', reason);
    SCBTransitionManager.getInstance().setOverlayCardTransitionController(null);
  }

  /**
   * 注册通话页面动效控制器
   *
   * @param bundleName 包名
   * @param abilityName 页面名
   * @returns 动效控制器
   */
  static registerPhoneCallController(bundleName?: string, abilityName?: string): SCBTransitionController {
    // 注册通话类型页面动效控制器
    let controller: SCBTransitionController = {
      appData: {
        bundleName: bundleName ?? '',
        abilityName: abilityName ?? '',
        appIconId: '',
        iconRadius: 0,
        appIconNumber: 0,
        startAppType: StartType.APP
      },
      onActive: (): void => {},
      onInactive: (): void => {}
    };
    SCBTransitionManager.getInstance().registerTransitionController(controller);
    return controller;
  }

  /**
   * 检测是否overlay卡片退出动效
   * 退出到胶囊
   *
   * @param param overlay动效参数
   * @returns true overlay卡片动效
   */
  static checkStartOverlayTransitionOut(param: OverlayTransitionParam): boolean {
    if (SwipeAppToCapsuleAnimation.instance.checkAndExecute(param)) {
      return true;
    }

    let bundleName = param.containerSession?.primarySession?.sceneInfo?.bundleName;
    let appIndex = param.containerSession?.primarySession?.sceneInfo?.appIndex ?? 0;
    let needRemoveSession = param.needRemoveSession ?? false;
    let checkResult = OverlayStartAnimHelper.checkSupportCapsuleAnim({
      bundleName: bundleName,
      appIndex: appIndex,
      isRemoveSession: needRemoveSession
    });
    if (!OverlayStartAnimHelper.refreshCapsuleWidth(checkResult)) {
      return false;
    }
    let cardInfo = OverlayStartAnimHelper.createCapsuleCardInfo(bundleName!, checkResult!);
    let containerSession = param.containerSession;
    let panelMgr = param.scenePanelManager;
    let controller = param.transitionController;

    // 打断卡片进入动效, 需要在下一个动效计数开始前进行
    OverlayStartAnimHelper.startAnimFromCardInfo.onFinish?.();
    OverlayStartAnimHelper.startAnimFromCardInfo.onFinish = undefined;

    // 动效值初始化
    if (!CommonUtils.isInvalid(controller)) {
      // 开启退出动效
      SCBTransitionManager.getInstance().notifySceneTransitionOut(controller, false);
      containerSession.transitionController = controller!;
    }
    OverlayStartAnimHelper.initCapsuleTransition(containerSession, cardInfo, param.toContainerSession);
    containerSession.addTransitionCount();
    let animationNum = containerSession.getTransitionCount();
    const isOverCapsule = checkResult?.isCapsuleCurrentShow && checkResult?.isTopCapsule;

    // 动效前修改窗口层级
    OverlayStartAnimHelper.changeIndexBeforeAnim(panelMgr, checkResult);

    // 动效开始
    log.showInfo(`checkStartOverlayTransitionOut, ${param.triggerType} start, ${animationNum}, ${containerSession.pendingRemove}, ${bundleName}`);
    TraceUtil.startTrace(DomainName.SYS_UI, param.triggerType + bundleName!);
    OverlayStartAnimHelper.capsuleParam.isAnimating = true;
    OverlayStartAnimHelper.animPromise = new CustomPromise();
    // 动效开始回调
    OverlayStartAnimHelper.notifyExitCapsuleListener({ isAnimating: true, isOverCapsule: isOverCapsule ?? false,
      animCapsuleData: checkResult?.capsuleData });
    OverlayStartAnimHelper.startCapsuleTransition(containerSession, panelMgr, (isCancel?: boolean) => {
      // 动效已结束
      if (!OverlayStartAnimHelper.capsuleParam.isAnimating) {
        return;
      }
      OverlayStartAnimHelper.setBlurComponent(panelMgr);
      OverlayStartAnimHelper.capsuleParam.isAnimating = false;
      OverlayStartAnimHelper.animPromise?.resolve();
      OverlayStartAnimHelper.animPromise = undefined;
      TraceUtil.endTrace(DomainName.SYS_UI, param.triggerType + bundleName!);
      log.showInfo(`${param.triggerType} end, ${bundleName}`);

      // 恢复面板层级
      panelMgr.setPanelZIndex(DefaultPanelZIndex.PANEL_SCENE_PANEL);
      // 移除session
      let needRemoved = containerSession.transitionOutFinishIfNeed(animationNum);
      if (needRemoved && needRemoveSession) {
        containerSession.clearContainerSessionData();
      }
      if (containerSession.pendingRemove && needRemoveSession) {
        panelMgr.removeSceneContainerSession(containerSession);
      }

      // 动效结束
      OverlayStartAnimHelper.capsuleParam.setOnCancelExitAnimListener();
      containerSession.overlayCardTransition = null;
      // 动效结束回调
      OverlayStartAnimHelper.notifyExitCapsuleListener({ isAnimating: false, isOverCapsule: isOverCapsule ?? false,
        animCapsuleData: checkResult?.capsuleData, isCancel: isCancel });
    });
    return true;
  }

  static setBlurComponent(panelMgr: SCBScenePanelManager) {
    // 通话退回胶囊后，如果上级页面为应用，需要把背景蒙层置顶
    let topContainerSession = panelMgr.getSceneContainerSessionList().getTopActiveSession();
    if (topContainerSession) {
      log.showInfo(`checkStartOverlayTransitionOut should enableBlurComponent`)
      panelMgr.enableBlurComponent('setBlurComponent topContainerSession');
    }
  }

  static changeIndexBeforeAnim(panelManger?: SCBScenePanelManager, checkResult?: CapsuleCheckResult) {
    // 状态栏存在胶囊且应用胶囊需要回到顶层
    if (checkResult?.isCapsuleCurrentShow && checkResult?.isTopCapsule) {
      panelManger?.setPanelZIndex(DefaultPanelZIndex.PANEL_STATUS_BAR + 1);
      return;
    }

    // 状态栏不存在胶囊
    if (!checkResult?.isCapsuleCurrentShow) {
      panelManger?.setPanelZIndex(DefaultPanelZIndex.PANEL_STATUS_BAR + 1);
    }
  }

  /**
   * 检测是否overlay卡片启动动效
   *
   * @param param overlay动效参数
   * @returns true overlay卡片动效
   */
  static checkStartOverlayTransitionIn(param: OverlayTransitionParam): boolean {
    log.showInfo('checkStartOverlayTransitionIn');

    if (!OverlayStartAnimHelper.checkBeforeAnim(param)) {
      return false;
    }

    let controller = param.transitionController;
    let cardInfo = controller?.overlayCardInfo as OverlayCardInfo;

    param.scenePanelManager.restoreNotshowToContainerList(param.containerSession);

    if (StartAppOneMirrorAnimation.instance.checkAndExecute(param)) {
      return true;
    }

    if (FloatingBallOneMirrorAnimation.instance.checkAndExecute(param)) {
      return true;
    }

    if (cardInfo?.isStartFromIcon()) {
      OverlayStartAnimHelper.startAnimFromIcon(param);
      return true;
    }

    if (cardInfo?.isStartFromNtfCenter()) {
      OverlayAnimGuarantee.cancel(`Start anim for ${cardInfo.startBundleName}`);
      OverlayStartAnimHelper.resetOverlayTransition('OverlayHelperStartAnim' + cardInfo.startBundleName);
      new OverlayAnimation(param, cardInfo).startAnimation();
      return true;
    }

    OverlayStartAnimHelper.startAnimFromCard(param, cardInfo, cardInfo?.isStartFromLockScreen());

    // 正常overlay动效
    return true;
  }

  private static startAnimFromCard(param: OverlayTransitionParam, cardInfo: OverlayCardInfo,
    isFromLockScreen?: boolean) {
    let controller = param.transitionController;
    let containerSession = param.containerSession;
    let panelSession = param.scenePanelSession;
    let panelMgr = param.scenePanelManager;

    let animationNum = OverlayStartAnimHelper.prepareForAnim(containerSession, panelMgr, controller, panelSession,
      isFromLockScreen);

    // 等待初始值刷新
    OverlayStartAnimHelper.StartAnimFromCardPanelPart(containerSession, cardInfo, animationNum, panelMgr, panelSession);

    // overlay卡片隐藏动效
    let cardParam = isFromLockScreen ? OverlayCardInfo.cardAlphaAnimParamFromLockScreen :
      OverlayCardInfo.cardAlphaAnimParam;
    let cardState = containerSession.overlayCardTransition?.overlayCardState as OverlayCardState;
    if (!CommonUtils.isInvalid(cardParam) && !CommonUtils.isInvalid(cardState)) {
      if (isFromLockScreen) {
        animateTo({
          duration: cardParam.duration,
          curve: cardParam.curve,
          delay: 0,
        }, () => {
          cardState.overlayCardAlpha = 0;
        });
      } else {
        animateTo({
          duration: cardParam.duration,
          curve: cardParam.curve,
          delay: cardParam.delay
        }, () => {
          cardState.overlayCardBgAlpha = 0;
          cardState.overlayCardAlpha = 0;
        });
      }
    }
  }

  private static StartAnimFromCardPanelPart(containerSession: SCBSceneContainerSession, cardInfo: OverlayCardInfo,
                                            animationNum: number, panelMgr: SCBScenePanelManager,
                                            panelSession?: SCBScenePanelSession) {
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, APSSceneState.START_SCENE);

    // 状态栏层级没有页面层级高时，状态栏层级需提升
    let sysSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(SceneSessionManager.SessionType.TYPE_STATUS_BAR);
    let statusBarParam = OverlayCardInfo.statusBarAnimParam;
    let defaultPanelZIndex = panelSession?.defaultPanelZIndex ?? DefaultPanelZIndex.PANEL_SCENE_PANEL;
    let targetIndex = panelSession?.panelZIndex ?? defaultPanelZIndex;
    if (!CommonUtils.isInvalid(statusBarParam) &&
      !CommonUtils.isInvalid(sysSession) &&
      sysSession.zIndex <= targetIndex) {
      // ApsUtils.setApsScene(apsManager.SceneAnimation.START_APP_ANIMATION, APSSceneState.END_SCENE);
      animateTo({
        duration: statusBarParam.duration,
        curve: statusBarParam.curve
      }, () => {
        sysSession.zIndex = targetIndex + 1;
      });
    }

    // 页面面板整体显示动效
    let sceneParam = OverlayCardInfo.sceneAnimParam;
    if (!CommonUtils.isInvalid(sceneParam)) {
      // 注册onFinish函数，调用后清理，用于处理动效冲突
      OverlayStartAnimHelper.startAnimFromCardInfo.onFinish = () => {
        TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
        log.showInfo(`${TraceUtil.CORE_METHOD_START_APP_ANI}: overlay end`);

        // overlay动效参数复位
        containerSession.transitionInFinishIfNeed(animationNum);
        containerSession.overlayCardTransition = null;
        DropDownPanelManager.hideWindowDirectly();

        // 通过setTimeout确保面板收起后再恢复应用的层级，避免闪面板的问题
        setTimeout(() => {
          panelSession?.setBgBlurEnable(true, 'StartAnimFromCardPanelPart');
          // 面板层级、状态栏层级复位
          panelSession?.setPanelZIndex(defaultPanelZIndex);
          if (sysSession) {
            sysSession.zIndex = DefaultPanelZIndex.PANEL_STATUS_BAR;
          }
        }, 0);
      }

      OverlayStartAnimHelper.raisePanelAboveByCard(cardInfo, panelSession);
      OverlayStartAnimHelper.showSceneAlphaAnim(containerSession, cardInfo.isStartFromLockScreen());
      animateTo({
        duration: sceneParam.duration,
        curve: sceneParam.curve,
        onFinish: () => {
          OverlayStartAnimHelper.startAnimFromCardInfo.onFinish?.();
          OverlayStartAnimHelper.startAnimFromCardInfo.onFinish = undefined;
        },
      }, () => {
        HiTrace.startTrace(TRACE_TAG, 3);
        OverlayStartAnimHelper.onOverlayTransitionInactive(containerSession);
        panelMgr.onBlurTransitionActive(1.0, 'OverlayStartAnimHelper > StartAnimFromCardPanelPart');
        HiTrace.finishTrace(TRACE_TAG, 3);
      });
    } else {
      log.showWarn('SceneParam is null.');
      DropDownPanelManager.hideWindowDirectly();
    }
  }

  private static showSceneAlphaAnim(containerSession: SCBSceneContainerSession, isFromLockScreen?: boolean) {
    if (isFromLockScreen) {
      let sceneAlphaAnimParam = OverlayCardInfo.sceneAlphaAnimParam;
      animateTo({
        duration: sceneAlphaAnimParam.duration,
        curve: sceneAlphaAnimParam.curve,
        delay: sceneAlphaAnimParam.delay
      }, () => {
        containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'initOverlayTransition');
      });
    }
  }

  private static prepareForAnim(containerSession: SCBSceneContainerSession, panelMgr: SCBScenePanelManager,
    controller?: SCBTransitionController, panelSession?: SCBScenePanelSession, isFromLockScreen?: boolean) {
    let sController = controller as SCBTransitionController;
    panelSession?.setBgBlurEnable(false, 'prepareForAnim');
    // 清空controller缓存
    OverlayStartAnimHelper.resetOverlayTransition('OverlayHelperPrepareForAnim');

    // 初始化动效起始状态
    OverlayStartAnimHelper.initOverlayTransition(containerSession, sController, isFromLockScreen);

    HiTrace.finishTrace(TRACE_TAG, 0);

    // 启动动效开始回调
    HiTrace.startTrace(TRACE_TAG, 1);
    if (isFromLockScreen) {
      SCBTransitionManager.getInstance().notifySceneTransitionIn(sController, false, false, true);
    } else {
      SCBTransitionManager.getInstance().notifySceneTransitionIn(sController, false, true);
    }
    HiTrace.finishTrace(TRACE_TAG, 1);

    // 动画计数器
    HiTrace.startTrace(TRACE_TAG, 2);
    containerSession.addTransitionCount();
    panelMgr.addSceneContainerSession(containerSession);
    panelMgr.raiseSceneToTop(containerSession);
    let animationNum = containerSession.getTransitionCount();
    HiTrace.finishTrace(TRACE_TAG, 2);
    return animationNum;
  }

  private static raisePanelAboveByCard(cardInfo: OverlayCardInfo, panelSession?: SCBScenePanelSession) {
    let oriPanelZIndex = cardInfo.oriPanelZIndex as number;
    if (!CommonUtils.isInvalid(oriPanelZIndex)) {
      panelSession?.setPanelZIndex(oriPanelZIndex + 1);
    }
  }

  private static checkBeforeAnim(param: OverlayTransitionParam): boolean {
    if (CommonUtils.isInvalid(param)) {
      log.showError('param is invalid');
      return false;
    }
    if (CommonUtils.isInvalid(param?.transitionController)) {
      log.showError('transitionController is invalid');
      return false;
    }
    if (CommonUtils.isInvalid(param?.transitionController?.overlayCardInfo)) {
      log.showError('overlayCardInfo is invalid');
      return false;
    }
    return true;
  }

  private static startAnimFromIcon(param: OverlayTransitionParam) {
    let containerSession = param.containerSession;
    let controller = param.transitionController as SCBTransitionController;
    let panelSession = param.scenePanelSession;
    let cardInfo = controller?.overlayCardInfo as OverlayCardInfo;
    let panelManager = param.scenePanelManager;

    // 如果应用已经位于前台，则不需要触发应用打开动效
    if (param?.isActive) {
      OverlayStartAnimHelper.cancelStartAnimFromIcon(cardInfo, containerSession);
      return;
    }

    // 取消应用窗口模糊，避免二次全屏模糊，动效结束恢复
    panelSession?.setBgBlurEnable(false, 'startAnimFromIcon');

    // 取消overlay动效拦截
    OverlayStartAnimHelper.resetOverlayTransition('OverlayHelperStartAnimFromIcon');

    // 动效一阶段：初始化应用窗口参数并抬高层级、初始化overlay卡片参数
    OverlayStartAnimHelper.initFromIconTransition(containerSession, controller);
    let oriPanelZIndex = cardInfo.oriPanelZIndex as number;
    if (!CommonUtils.isInvalid(oriPanelZIndex)) {
      panelSession?.setPanelZIndex(oriPanelZIndex + 1);
    }
    // 状态栏层级没有页面层级高时，状态栏层级需提升
    let sysSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(SceneSessionManager.SessionType.TYPE_STATUS_BAR);
    let statusBarParam = OverlayCardInfo.statusBarAnimParam;
    let defaultPanelZIndex = panelSession?.defaultPanelZIndex ?? DefaultPanelZIndex.PANEL_SCENE_PANEL;
    let targetIndex = panelSession?.panelZIndex ?? defaultPanelZIndex;
    if (!CommonUtils.isInvalid(statusBarParam) &&
      !CommonUtils.isInvalid(sysSession) &&
      sysSession.zIndex <= targetIndex) {
      sysSession.zIndex = targetIndex + 1;
    }

    // 动效二阶段：发送应用启动动效开始通知
    // 在桌面启动动效开始前生效节点组标记和freeze
    SCBTransitionManager.getInstance().addStartExitAnimationCount();
    let expandStatus = SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus();
    SCBDesktopCacheManager.getInstance().setDesktopCacheWithDfx(true, 'sceneContainerTransitionIn', true, expandStatus);
    SCBTransitionManager.getInstance().notifySceneTransitionIn(controller, false, false);

    // 动效三阶段：开始窗口和overlay卡片动效
    setTimeout(() => {
      log.showInfo('StartFromIconAnim begin');
      OverlayStartAnimHelper.StartFromIconPanelAnim(containerSession, cardInfo, panelManager, panelSession);
      OverlayStartAnimHelper.StartFromIconCardAnim(containerSession, cardInfo);
    }, 1);
  }

  private static StartFromIconCardAnim(containerSession: SCBSceneContainerSession, cardInfo: OverlayCardInfo) {
    let cardState = containerSession.overlayCardTransition?.overlayCardState as OverlayCardState;
    if (!CommonUtils.isInvalid(cardState)) {
      // 蒙层透明度变化
      animateTo({
        curve: cardInfo?.sceneMaskColorAnimParam?.curve,
        duration: cardInfo?.sceneMaskColorAnimParam?.duration,
      }, () => {
        cardState.overlayCardBgAlpha = 0;
      });
      // 卡片内容(icon)透明度变化
      animateTo({
        curve: cardInfo?.iconAlphaAnimParam?.curve,
        duration: cardInfo?.iconAlphaAnimParam?.duration
      }, () => {
        cardState.overlayCardAlpha = 0;
      });
    }
  }

  private static StartFromIconPanelAnim(containerSession: SCBSceneContainerSession,
                                        cardInfo: OverlayCardInfo, panelMgr: SCBScenePanelManager,
                                        panelSession?: SCBScenePanelSession) {
    containerSession.addTransitionCount();
    let animationNum = containerSession.getTransitionCount();
    let sysSession = SCBSceneSessionManager.getInstance()
      .getSystemSceneSessionWithSystemType(SceneSessionManager.SessionType.TYPE_STATUS_BAR);
    TraceUtil.startAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
    // 应用窗口位置大小变化动效
    animateTo({
      curve: cardInfo?.sceneSizeAndPositionAnimParam?.curve,
      onFinish: () => {
        TraceUtil.endAnimTrace(DomainName.HOME, TraceUtil.CORE_METHOD_START_APP_ANI, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
        log.showInfo('StartFromIconAnim finish');
        // 动效结束后恢复应用窗口的模糊层
        panelSession?.setBgBlurEnable(true, 'StartFromIconPanelAnim');
        // 恢复启动应用动效计数
        SCBTransitionManager.getInstance().reduceStartExitAnimationCount();
        // overlay动效参数复位，解冻桌面及停止标记节点组
        containerSession.transitionInFinishIfNeed(animationNum);
        containerSession.overlayCardTransition = null;
        // 面板层级复位
        panelSession?.setPanelZIndex(panelSession?.defaultPanelZIndex ?? DefaultPanelZIndex.PANEL_SCENE_PANEL);
        if (sysSession) {
          sysSession.zIndex = DefaultPanelZIndex.PANEL_STATUS_BAR;
        }
      },
    }, () => {
      OverlayStartAnimHelper.setFromIconAnimPanelEndpoint(containerSession);
    });

    // 应用窗口圆角变化动效
    animateTo({
      curve: cardInfo?.sceneBorderRadiusAnimParam?.curve,
      duration: cardInfo?.sceneBorderRadiusAnimParam?.duration
    }, () => {
      let deviceRadius =
        DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus());
      containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(deviceRadius, TAG, 'onOverlayTransitionActive',
        containerSession.getName());
    });

    // 应用页面透明度变化
    animateTo({
      curve: cardInfo?.sceneAlphaAnimParam?.curve,
      duration: cardInfo?.sceneAlphaAnimParam?.duration
    }, () => {
      containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1, TAG, 'onOverlayTransitionActive', containerSession.getName());
    })
  }

  private static cancelStartAnimFromIcon(cardInfo: OverlayCardInfo, containerSession: SCBSceneContainerSession) {
    if (!CommonUtils.isInvalid(cardInfo.onAnimCanceled)) {
      let onAnimCanceled = cardInfo.onAnimCanceled as (() => void);
      onAnimCanceled();
    }
    // 清空应用session中有关overlay卡片的信息
    containerSession.overlayCardTransition = null;
    // 清空拦截器
    OverlayStartAnimHelper.resetOverlayTransition('OverlayHelperCancelFromIcon');
    // 将圆角恢复为0，面板缩放时不会漏出四角
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(0, TAG,
      'cancelStartAnimFromIcon', containerSession.getName());
  }

  /**
   * 初始化从Icon启动应用overlay动效属性参数
   *
   * @param session 容器session
   * @param controller 动效管理
   */
  private static initFromIconTransition(session: SCBSceneContainerSession, controller: SCBTransitionController): void {
    session.overlayCardTransition = new OverlayCardTransition();
    let cardInfo = controller.overlayCardInfo as OverlayCardInfo;
    let cardState = new OverlayCardState();
    session.overlayCardTransition.overlayCardInfo = cardInfo;
    session.overlayCardTransition.overlayCardState = cardState;
    session.initTransitionAnimationCount();
    session.transitionController = controller;
    session.init();

    session.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'initFromIconTransition', session.getName());

    // 应用窗口初始裁剪大小
    let shortPxSize = Math.min(session.screenProperty.width, session.screenProperty.height);
    let shortWidth = px2vp(shortPxSize);
    session.needRenderClip.setClipHeight(shortPxSize);
    let width = session.needRenderClip.clipHeight.copy();
    session.needRenderClip.setClipWidth(width);
    // 赋值给卡片内容（icon）大小
    cardState.iconWidth = shortWidth;

    let cardBgWidth: number = cardInfo.getBgWidth();
    // 应用窗口初始缩放比例
    session.needRenderScale.setScaleXWithDfx(cardBgWidth / shortWidth, TAG, 'startApp', session.getName());
    session.needRenderScale.setScaleYWithDfx(cardBgWidth / shortWidth, TAG, 'startApp', session.getName());

    //  应用窗口初始圆角值
    if (!CommonUtils.isInvalid(cardInfo.cardRadius)) {
      let cardRadius:number = cardInfo.cardRadius.topLeft;
      // 页面初始圆角与卡片圆角保持一致，将缩放比例考虑进去重新计算
      session.needRenderBorderRadius.setBorderRadiusWithDfx(cardRadius / (cardBgWidth / shortWidth), TAG, 'initFromIconTransition',
        session.getName());
    }
    // 应用窗口初始位移位置
    if (!CommonUtils.isInvalid(cardInfo.cardBgPosition)) {
      let cardBgPosition = cardInfo.cardBgPosition;
      session.needRenderTranslate.setTranslateXWithDfx(cardBgPosition.left + (cardBgWidth - shortWidth) / 2, TAG, 'startApp', session.getName());
      session.needRenderTranslate.setTranslateYWithDfx(cardBgPosition.top + (cardBgWidth - shortWidth) / 2, TAG, 'startApp', session.getName());
    }
  }

  /**
   * 初始化overlay动效属性参数
   *
   * @param session 容器session
   * @param controller 动效管理
   */
  private static initOverlayTransition(session: SCBSceneContainerSession, controller: SCBTransitionController,
                                       isFromLockScreen?: boolean): void {
    session.overlayCardTransition = new OverlayCardTransition();
    let cardInfo = controller.overlayCardInfo as OverlayCardInfo;
    let cardState = new OverlayCardState();
    session.overlayCardTransition.overlayCardInfo = cardInfo;
    session.overlayCardTransition.overlayCardState = cardState;
    session.initTransitionAnimationCount();
    session.transitionController = controller;
    session.init();

    // 页面scene属性
    session.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'initOverlayTransition', session.getName());
    session.needRenderScale.setScaleXWithDfx(1.0, TAG, 'initOverlayTransition', session.getName());
    session.needRenderScale.setScaleYWithDfx(1.0, TAG, 'initOverlayTransition', session.getName());

    // overlay卡片属性
    if (!isFromLockScreen) {
      cardState.overlayCardBgAlpha = 1.0;
    }
    cardState.overlayCardAlpha = 1.0;
    cardState.overlayCardScaleX = cardInfo.cardScaleX;
    cardState.overlayCardScaleY = cardInfo.cardScaleY;

    // 圆角初始值
    if (!CommonUtils.isInvalid(cardInfo.cardRadius)) {
      let cardRadius = cardInfo.cardRadius;

      // 页面初始圆角与卡片圆角保持一致
      session.needRenderBorderRadius.setDiffBorderRadiusWithDfx(
        cardRadius?.topLeft,
        cardRadius?.topRight,
        cardRadius?.bottomLeft,
        cardRadius?.bottomRight);
      log.showInfo(`[${TAG}]set NeedRenderBorderRadius different border Radius. reason: initOverlayTransition, extra info:${session.getName()}`);
    }

    // 裁剪大小、位置初始值
    let cardBgPosition = cardInfo.cardBgPosition;
    if (CommonUtils.isInvalid(cardBgPosition)) {
      log.showWarn('CardBgPosition is invalid.');
      return;
    }

    const cardBgWidth = vp2px(cardInfo.getBgWidth());
    const cardBgHeight = vp2px(cardInfo.getBgHeight());
    const bgTranX = cardBgPosition.left;
    const bgTranY = cardBgPosition.top;

    // 页面初始大小与卡片大小保持一致
    session.needRenderClip.clipWidth.setNumber(cardBgWidth);
    session.needRenderClip.clipHeight.setNumber(cardBgHeight);
    session.needRenderTranslate.setTranslateXWithDfx(bgTranX, TAG, 'initOverlayTransition', session.getName());
    session.needRenderTranslate.setTranslateYWithDfx(bgTranY, TAG, 'initOverlayTransition', session.getName());

    cardState.containerTranX = bgTranX;
    cardState.containerTranY = bgTranY;
    cardState.overlayCardEndTranX = bgTranX;
    cardState.overlayCardEndTranY = bgTranY;
  }

  /**
   * start from icon场景
   * 设置overlay动效终点属性参数
   *
   * @param session 容器session
   */
  private static setFromIconAnimPanelEndpoint(session: SCBSceneContainerSession): void {
    // 应用窗口宽高终值
    session.needRenderClip.setClipWidth(session.screenProperty.width);
    session.needRenderClip.setClipHeight(session.screenProperty.height);
    // 应用窗口位移终值
    session.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'onOverlayTransitionInactive', session.getName());
    session.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'onOverlayTransitionInactive', session.getName());
    // 应用窗口缩放终值
    session.needRenderScale.setScaleXWithDfx(1, TAG, 'startApp', session.getName());
    session.needRenderScale.setScaleYWithDfx(1, TAG, 'startApp', session.getName());
  }

  /**
   * 设置overlay动效终点属性参数
   *
   * @param session 容器session
   */
  private static onOverlayTransitionInactive(session: SCBSceneContainerSession, isFromLockScreen?: boolean): void {
    // 页面面板最终全屏宽高
    session.needRenderClip.setClipWidth(session.screenProperty.width);
    session.needRenderClip.setClipHeight(session.screenProperty.height);
    session.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'initOverlayTransition', session.getName());

    // 圆角终值
    let deviceRadius =
      DeviceHelper.getDeviceRadius(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus());
    session.needRenderBorderRadius.setBorderRadiusWithDfx(deviceRadius, TAG, 'onOverlayTransitionInactive',
      session.getName());

    // 位移终值
    session.needRenderTranslate.setTranslateXWithDfx(0, TAG, 'onOverlayTransitionInactive', session.getName());
    session.needRenderTranslate.setTranslateYWithDfx(0, TAG, 'onOverlayTransitionInactive', session.getName());

    // 卡片感知容器位移
    let cardState = session.overlayCardTransition?.overlayCardState as OverlayCardState;
    if (!CommonUtils.isInvalid(cardState)) {
      cardState.containerTranX = 0;
      cardState.containerTranY = 0;
      if (isFromLockScreen) {
        cardState.overlayCardEndTranX = 0;
        cardState.overlayCardEndTranY = 0;
      }
    }
  }

  /**
   * 检测目标应用是否为胶囊应用
   *
   * @param param 检测参数
   * @returns 检测结果
   */
  private static checkSupportCapsuleAnim(param: ExitCapsuleCheckParam): CapsuleCheckResult | undefined {
    let bundleName = param?.bundleName;
    if (CommonUtils.isInvalid(bundleName)) {
      return undefined;
    }

    // 检测是否胶囊应用
    let capsuleParam = OverlayStartAnimHelper.capsuleParam;
    let result = capsuleParam.checkCapsuleListener?.(param);

    // 手机非折叠屏展开态，横屏时不支持回胶囊动效
    if (DeviceHelper.isPhone()) {
      // 宽度大于高度的2倍，认为此时窄屏横屏
      let sizeState = baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_SIZE) as DisplaySizeState;
      if (sizeState.displayWidth / 2 >= sizeState.displayHeight) {
        log.showInfo('checkSupportCapsuleAnim not support by landscape: ' + bundleName);
        return undefined;
      }

      // 手机窄屏，180度旋转不支持回胶囊动效
      let rotationState = baseStateMgr.getBaseState(StateType.TYPE_DISPLAY_ROTATION) as DisplayRotationState;
      if (rotationState?.isPortraitNegative()) {
        log.showInfo('checkSupportCapsuleAnim not support by rotation: ' + bundleName);
        return undefined;
      }
    }

    if (AppStorage.get('deviceModeState') === DeviceModeEnum.EMERGENCY_MODE) {
      return undefined;
    }
    return result;
  }

  /**
   * 刷新动效胶囊宽度
   *
   * @param checkResult 检测胶囊时结果
   * @returns true刷新成功
   */
  private static refreshCapsuleWidth(checkResult?: CapsuleCheckResult): boolean {
    let capsule = checkResult?.capsuleData?.capsule;
    if (CommonUtils.isInvalid(capsule)) {
      return false;
    }

    // 当动效胶囊不在顶层且顶层存在胶囊时，宽度使用顶层胶囊计算结果
    if (!checkResult?.isTopCapsule && checkResult?.isCapsuleCurrentShow && checkResult.topCapsule) {
      capsule = checkResult.topCapsule?.capsule;
    }

    let capsuleState = capsuleStateMgr.getCapsuleState();
    let width = capsuleState.getCapsuleWidth(capsule, checkResult?.isMultiCapsule);
    OverlayStartAnimHelper.capsuleParam.setCapsuleWidth(width);
    return true;
  }

  /**
   * 创建动效卡片信息
   *
   * @param bundleName 应用包名
   * @param checkResult 胶囊检测值
   * @returns 卡片信息
   */
  private static createCapsuleCardInfo(bundleName: string, checkResult: CapsuleCheckResult): OverlayCardInfo {
    let capsule = checkResult.capsuleData?.capsule as LiveCapsuleData;
    let param = OverlayStartAnimHelper.capsuleParam;
    let cardInfo = new OverlayCardInfo(OverlayAnimType.TYPE_EXIT_CAPSULE);
    cardInfo.startBundleName = bundleName;
    cardInfo.cardBgColor = capsule.backgroundColor!;
    cardInfo.setCardRadius(param.capsuleRadius);
    cardInfo.capsuleData = capsule;
    cardInfo.capsuleStyle = param.capsuleStyle;
    cardInfo.setCardBgPosition(param.capsulePosition);
    cardInfo.setCardContentPosition(param.capsulePosition);
    cardInfo.overlayComponentZIndex = -1;
    return cardInfo;
  }

  /**
   * 初始化胶囊动效参数
   *
   * @param containerSession 面板信息
   * @param cardInfo 卡片信息
   */
  private static initCapsuleTransition(containerSession: SCBSceneContainerSession,
    cardInfo: OverlayCardInfo, toContainerSession?: SCBSceneContainerSession | null): void {
    let transition = new OverlayCardTransition();
    transition.overlayCardInfo = cardInfo;
    let state = new OverlayCardState();
    transition.overlayCardState = state;

    // 应用回胶囊，不回桌面
    containerSession.overlayCardTransition = transition;

    // 桌面存在动效，直接复位
    SCBTransitionManager.getInstance().getCurrentTransitionController()?.onInactive?.();

    // 面板起始状态
    containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(1.0, TAG, 'initCapsuleTransition',
      containerSession.getName());
    containerSession.needRenderBorderRadius.setBorderRadiusWithDfx(DeviceHelper.getDeviceRadius(), TAG,
      'initCapsuleTransition', containerSession.getName());
    state.containerWidth = containerSession.needRenderClip.clipWidth.getPx();
    state.containerHeight = containerSession.needRenderClip.clipHeight.getPx();

    if (!toContainerSession?.isFloat) {
      // 存在跳转应用则重置
      toContainerSession?.init();
      toContainerSession?.needRenderBorderRadius.setBorderRadiusWithDfx(0,
        TAG, 'initCapsuleTransition', toContainerSession?.getName());
    }

    // overlay卡片scale从1.05到1
    state.overlayCardScaleX = 1.05;
    state.overlayCardScaleY = 1.05;
  }

  /**
   * 开启应用回胶囊动效
   *
   * @param containerSession 面板信息
   * @param onFinish 动效结束回调
   */
  private static startCapsuleTransition(containerSession: SCBSceneContainerSession, panelMgr: SCBScenePanelManager,
                                        onFinish: (isCancel?: boolean) => void): void {
    // 设置中断监听
    OverlayStartAnimHelper.setOnCancelExitCapsuleAnim(onFinish);

    // 面板裁切动效
    animateTo({
      // 动效曲线
      curve: CAPSULE_CURVES,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      onFinish: onFinish
    }, () => {
      let cardInfo = containerSession.overlayCardTransition?.overlayCardInfo as OverlayCardInfo;
      let cardPosition = cardInfo.cardBgPosition as RectInfo;
      // 面板移动到卡片位置
      containerSession.needRenderTranslate.setTranslateXWithDfx(cardPosition.left, TAG, 'startCapsuleTransition', containerSession.getName());
      containerSession.needRenderTranslate.setTranslateYWithDfx(cardPosition.top, TAG, 'startCapsuleTransition', containerSession.getName());
      let cardWidth = vp2px(cardInfo.getBgWidth());
      let cardHeight = vp2px(cardInfo.getBgHeight());
      containerSession.needRenderClip.setClipWidth(cardWidth);
      containerSession.needRenderClip.setClipHeight(cardHeight);
      // 面板保持不缩放
      containerSession.needRenderScale.setScaleXWithDfx(1.0, TAG, 'startCapsuleTransition', containerSession.getName());
      containerSession.needRenderScale.setScaleYWithDfx(1.0, TAG, 'startCapsuleTransition', containerSession.getName());

      // 卡片内容缩放
      let state = containerSession.overlayCardTransition?.overlayCardState as OverlayCardState;
      state.overlayCardScaleX = 1.0;
      state.overlayCardScaleY = 1.0;

      // 卡片容器宽高
      state.containerWidth = cardWidth;
      state.containerHeight = cardHeight;
    });

    // 胶囊显示、面板淡出动效
    animateTo({
      delay: 250, duration: 90,
      curve: Curve.Linear,
      onFinish: () => {
        panelMgr.onBlurTransitionInactive();
        panelMgr.onBlurTransitionFinish(panelMgr.addBlurTransitionCountAndReturnValue());
      }
    }, () => {
      containerSession.needRenderAlpha.setNeedRenderAlphaWithDfx(0, TAG, 'startCapsuleTransition',
        containerSession.getName());
    });
  }

  /**
   * 设置中断退出动效监听
   *
   * @param onFinish 结束动效
   */
  private static setOnCancelExitCapsuleAnim(onFinish?: (isCancel?: boolean) => void): void {
    OverlayStartAnimHelper.capsuleParam.setOnCancelExitAnimListener(() => {
      // 中断退出胶囊动效时，直接结束动效
      log.showInfo('setOnCancelExitCapsuleAnim cancel exit capsule anim.');
      onFinish?.(true);
    });
  }
}
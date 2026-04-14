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

import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { HiSysEventUtil, HiSysGestureQuickSwitchData } from '@ohos/frameworkwrapper';
import {
  SCBSceneContainerSessionArray,
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBScreenSessionManager,
  ScenePanelState,
} from '@ohos/windowscene';
import { AnimateExArgsType } from '@ohos/windowscene/Index';
import { SCBScenePanelViewModel } from '../../../scenemanager/viewmodel/SCBScenePanelViewModel';
import { RecentGestureEventManager } from '../../common/RecentGestureEventManager';
import { RecentGestureEvent } from '../../common/constants/RecentGestureConstants';
import { RecentRotationUtil } from '../../common/RecentRotationUtil';
import { QuickSwitchAnimations } from './QuickSwitchAnimations';
import { recentRuntimeInstance, RecentRuntimeModel } from '../recentpanel/RecentRuntimeModel';
import { performanceMonitor } from '@kit.ArkUI';
import { quickSwitchRequestActiveAlarm } from './QuickSwitchRequestActiveAlarm';
import { DomainName, TraceUtil } from '@ohos/basicutils';

const TAG = 'QuickSwitchViewModel';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class QuickSwitchViewModel {
  private currentState_ = QuickSwitchStates.STATE_INIT;
  private scenePanelViewModel?: SCBScenePanelViewModel;
  private quickSwitchAnimations?: QuickSwitchAnimations;

    /**
   * 手势快切打点
   *
   * @param isFromApp  是否应用内切换
   * @param offsetX  切换的X抽偏移量
   */
  public reportGestureQuickSwitch(isFromApp: boolean, offsetX: number) {
    let containerSessionList = SCBScenePanelManager.getInstance().getSceneContainerSessionList();
    let fromContainerSession = this.getTopSession(containerSessionList);
    let toContainerSession = isFromApp ? this.getQuickSwitchToContainer(offsetX) : containerSessionList.getTopSession();
    let screenProperty = SCBScenePanelManager.getInstance().getScreenProperty();
    if (toContainerSession) {
      HiSysEventUtil.reportGestureQuickSwitch(
        isFromApp ? HiSysGestureQuickSwitchData.FROM_APP : HiSysGestureQuickSwitchData.FROM_DESKTOP,
        recentRuntimeInstance.navigationStartPos, recentRuntimeInstance.navigationEndPos,
        RecentRotationUtil.getRotateStatus(RecentRotationUtil.getScreenRotation(screenProperty)),
        isFromApp ? fromContainerSession?.getBundleName() : '-1', toContainerSession.getBundleName(),
        fromContainerSession?.isMidScene, toContainerSession?.isMidScene,
        SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus());
    }
  }

  /**
   * 离手手进入快切逻辑处理
   *
   * @param isFromApp 是:应用手势触发 否:卓面手势触发
   * @param offsetX 离手时的x轴位移
   */
  public enterQuickSwitchIdle(isFromApp: boolean, offsetX: number, offsetY: number) {
    if (isFromApp) {
      let fromContainerSession = this.getTopSession(SCBScenePanelManager.getInstance().getSceneContainerSessionList());
      if (fromContainerSession) {
        this.reportGestureQuickSwitch(isFromApp, offsetX);
        this.scenePanelViewModel?.deleteCallerChainForContainerSession(fromContainerSession);
        this.scenePanelViewModel?.deleteToChainForContainerSession(fromContainerSession);
        let toContainerSession = this.getQuickSwitchToContainer(offsetX);
        this.scenePanelViewModel?.updateScenePanelState(ScenePanelState.FULLSCENE, false);
        this.quickSwitchAnimations?.enterSwitchView(true, offsetX, offsetY, this.enterSwitchAnimationFinishCallback);
        RecentGestureEventManager.getInstance()
          .deliverGestureEvent(RecentGestureEvent.ENTER_QUICK_SWITCH_IDLE_FROM_APP, toContainerSession,
            fromContainerSession);
      }
    }
  }

  /**
   * 初始化相关依赖
   *
   * @param panelViewModel SCBScenePanel视效交互逻辑
   * @param quickSwitchAnimations 快切动效处理逻辑
   */
  public initQuickSwitchViewModel(panelViewModel: SCBScenePanelViewModel,
    quickSwitchAnimations: QuickSwitchAnimations): void {
    this.scenePanelViewModel = panelViewModel;
    this.quickSwitchAnimations = quickSwitchAnimations;
  }

  private enterSwitchAnimationFinishCallback = (...args: AnimateExArgsType[]) => {
    // 动效结束时如果应用还未拉起，则立即拉起应用
    quickSwitchRequestActiveAlarm.onAlarm();
    let toContainerSession = args[1] as SCBSceneContainerSession | null;
    if (toContainerSession) {
      if (toContainerSession.isActive) {
        this.scenePanelViewModel?.startSceneWithRotationIfNeed(toContainerSession, true, true);
      } else {
        this.scenePanelViewModel?.startSceneWithRotationIfNeed(toContainerSession);
      }
    }
    performanceMonitor.end('GESTURE_ENTER_TO_SWITCH');
    TraceUtil.endTrace(DomainName.RECENT, HiSysEventUtil.GESTURE_ENTER_TO_SWITCH, TraceUtil.CUSTOM_ANIMATOR_PREFIX);
  }

  /**
   * 获取快切应用的containerSession
   * @param offsetX
   * @returns next containerSession
   */
  public getQuickSwitchToContainer(offsetX: number): SCBSceneContainerSession | null {
    let containerSessionList = SCBScenePanelManager.getInstance().getSceneContainerSessionList();
    let activeSessionIndex = this.getCurrentIdx();
    if (activeSessionIndex === -1) {
      return null;
    }
    let toContainer: SCBSceneContainerSession | null = null;
    // 向右滑动
    if (offsetX > 0) {
      let leftIndex = activeSessionIndex - 1;
      if (containerSessionList.isInRange(leftIndex) &&
        leftIndex >= containerSessionList.length - RecentRuntimeModel.getMaxCountsShowInRecent()) {
        toContainer = containerSessionList[leftIndex];
      }
      return toContainer;
    }
    let rightIndex = activeSessionIndex + 1;
    if (containerSessionList.isInRange(rightIndex)) {
      toContainer = containerSessionList[rightIndex];
    }
    return toContainer;
  }

  /**
   * 获取当前的containerSession
   * @param containerSessionList
   * @returns
   */
  public getTopSession(containerSessionList: SCBSceneContainerSessionArray): SCBSceneContainerSession | null {
    let toContainerSession = quickSwitchRequestActiveAlarm.getToContainerSession();
    // 如果待拉起的应用是空的，则取最近active的应用。否则取待拉起的应用
    if (toContainerSession === null || toContainerSession === undefined) {
      return containerSessionList.getTopActiveSession();
    }
    return toContainerSession;
  }

  /**
   * 获取当前的containerSession索引
   * @returns
   */
  public getCurrentIdx(): number {
    let containerSessionList = SCBScenePanelManager.getInstance().getSceneContainerSessionListForView();
    let currRequestActiveIdx = quickSwitchRequestActiveAlarm.getCurrentSessionIndex(containerSessionList);
    let currentIdx =
      currRequestActiveIdx !== -1 ? currRequestActiveIdx : containerSessionList.getTopActiveSessionIndex();
    return currentIdx;
  }

  /**
   * containerSession是否是active或者是待拉起的应用
   * @param containerSession
   * @returns
   */
  public isActiveOrRequestActive(containerSession: SCBSceneContainerSession): boolean {
    if (!containerSession) {
      return false;
    }
    return containerSession.isActive ||
      containerSession.containerId === quickSwitchRequestActiveAlarm.getToContainerSession()?.containerId;
  }

  public static getInstance(): QuickSwitchViewModel {
    return SingletonHelper.getInstance(QuickSwitchViewModel, TAG);
  }

  /**
   * 返回是否在快切动效状态
   *
   * @returns 是否快切动效状态
   */
  public isAnimatingState(): boolean {
    return this.currentState_ === QuickSwitchStates.STATE_ANIMATING;
  }

  /**
   * 快切动效状态初始化
   */
  public onInit() {
    if (this.currentState_ === QuickSwitchStates.STATE_INIT) {
      log.showDebug(`currentState is init return`);
      return;
    }
    log.showInfo(`set currentState from ${this.currentState_} to STATE_INIT }`);
    this.currentState_ = QuickSwitchStates.STATE_INIT;
  }

  /**
   * 进入快切动效
   */
  public onAnimating() {
    if (this.isAnimatingState()) {
      log.showDebug(`currentState is ANIMATING return`);
      return;
    }
    log.showInfo(`set currentState from ${this.currentState_} to STATE_ANIMATING }`);
    this.currentState_ = QuickSwitchStates.STATE_ANIMATING;
  }
}

export enum QuickSwitchStates {
  STATE_INIT,
  STATE_ANIMATING,
}

export const quickSwitchViewModel = QuickSwitchViewModel.getInstance();
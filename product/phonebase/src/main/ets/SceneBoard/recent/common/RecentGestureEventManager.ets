/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { commonEventManager } from '@kit.BasicServicesKit';
import { LogDomain, LogHelper, SingletonHelper, AnimateToScheduleUtils, CommonUtils } from '@ohos/basicutils';
import {
  SCBSceneContainerSession,
  SCBScenePanelManager,
  SCBScreenSessionManager
} from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  SCBSceneSessionManager,
  SceneStateChangeCallback } from '@ohos/windowscene/src/main/ets/scene/session/SCBSceneSessionManager';
import { RecentGestureEvent, RSSGestureEvent, CommonGestureEvent } from '../common/constants/RecentGestureConstants';
import { SCBVisualEffectMgr } from '@ohos/componenthelper';
import { VisualEffectConstants } from '@ohos/commonconstants';
import { quickSwitchViewModel } from '../scenepanel/quickswitchpanel/QuickSwitchViewModel';
import { EventConstants } from '@ohos/launchercommon';
import { localEventManager } from '@ohos/frameworkwrapper';
import { recentStateManagerInstance } from '../innerstate/RecentStates';

const TAG = 'RecentGestureEventManager';
const log = LogHelper.getLogHelper(LogDomain.RECENT, TAG);

export class RecentGestureEventManager {
  private customGestureEvent = 'CUSTOM_GESTURE_EVENT'; // 窗口相关场景广播
  // 跟手persistentId
  private gesturePersistentId: number | undefined = -1;

  private scbGestureCallbackMap: Map<RecentGestureEvent, RecentGestureCallback[]> = new Map();

  private isForceCloseHdr: boolean =
    SCBVisualEffectMgr.isFeatureParamTrue(VisualEffectConstants.GESTURE_FORCE_CLOSE_HDR_ENABLE);

  /**
   * set gesturePersistentId
   *
   * @param persistentId
   */
  public setGesturePersistentId(persistentId: number | undefined): void {
    if (CommonUtils.equals(this.gesturePersistentId, persistentId)) {
      return;
    }
    log.showInfo(`setGesturePersistentId from:${this.gesturePersistentId} to:${persistentId}`);
    this.gesturePersistentId = persistentId;
  }

  /**
   * init persistentId
   */
  public initGesturePersistentId(): void {
    this.gesturePersistentId = -1;
  }

  private sceneStateChange: SceneStateChangeCallback = (sceneInfo, isForeground) => {
    log.showInfo(`onSceneStateChange,isForegroud:${isForeground},bundleName:${sceneInfo.bundleName} abilityName:${sceneInfo.abilityName}`);
    if (this.gesturePersistentId === sceneInfo.persistentId) {
      return;
    }
    if (isForeground &&
      (quickSwitchViewModel.isAnimatingState() || recentStateManagerInstance.isEnterFollowingState())) {
      localEventManager.sendLocalEvent(EventConstants.EVENT_NAV_BAR_GESTURE_CANCEL);
    }
  }

  public static getInstance(): RecentGestureEventManager {
    let recentEventManager: RecentGestureEventManager = SingletonHelper.getInstance(RecentGestureEventManager, TAG);
    return recentEventManager;
  }

  /**
   * 手势或多任务事件统一入口
   *
   * @param event 手势事件
   * @param args 可变参数
   */
  public deliverGestureEvent(event: RecentGestureEvent, ...args: RecentCallbackArgsType[]): void {
    if (this.isForceCloseHdr) {
      this.handleHdrSwitchIfNeed(event);
    }
    this.publishCommonEventIfNeed(event);
    this.reportEventForRSSIfNeed(event, ...args);
    let scbGestureCallbackList = this.scbGestureCallbackMap.get(event);
    if (!scbGestureCallbackList) {
      return;
    }
    scbGestureCallbackList.forEach((item: RecentGestureCallback) => {
      item.onGestureEvent(...args);
    });
  }

  /**
   * SceneBoard进程内通过监听回调的方式感知手势状态 注册监听
   *
   * @param gestureEvent 手势事件
   * @param gestureEventCallback 手势事件回调
   */
  public subscribeGestureEvent(gestureEvent: RecentGestureEvent, gestureEventCallback: RecentGestureCallback): void {
    if (gestureEventCallback === undefined || gestureEventCallback === null) {
      log.showError('registerSCBGestureTransitionController, controller null');
      return;
    }
    if (this.scbGestureCallbackMap.has(gestureEvent)) {
      let eventCallbackList = this.scbGestureCallbackMap.get(gestureEvent);
      let index = eventCallbackList?.indexOf(gestureEventCallback);
      if (index === -1) {
        eventCallbackList?.push(gestureEventCallback);
      }
    } else {
      let eventCallbackList: RecentGestureCallback[] = [];
      eventCallbackList.push(gestureEventCallback);
      this.scbGestureCallbackMap.set(gestureEvent, eventCallbackList);
    }
  }

  /**
   * SceneBoard进程内通过监听回调的方式感知手势状态 取消注册监听
   *
   * @param gestureEvent 手势事件
   * @param gestureEventCallback 手势事件回调函数
   */
  public unSubScribeGestureEvent(gestureEvent: RecentGestureEvent, gestureEventCallback: RecentGestureCallback): void {
    if (gestureEventCallback === undefined || gestureEventCallback === null) {
      log.showError('unSubScribeGestureEvent, gestureEventCallback is null');
      return;
    }
    if (this.scbGestureCallbackMap.has(gestureEvent)) {
      let eventCallbackList = this.scbGestureCallbackMap.get(gestureEvent);
      if (eventCallbackList) {
        let index: number = eventCallbackList.indexOf(gestureEventCallback);
        if (index != -1) {
          eventCallbackList.splice(index, 1);
        } else {
          log.showWarn('unSubScribeGestureEvent failed, gestureEventCallback was not SubScribe');
        }
      }
    }
  }

  /**
   * 上报手势事件给RSS
   * @param event 事件类型
   * @param args  前台应用
   */
  private reportEventForRSSIfNeed(event: RecentGestureEvent, ...args: RecentCallbackArgsType[]): void {
    if (!RSS_EVENT_MAP.has(event)) {
      return;
    }
    let rssEvent = RSS_EVENT_MAP.get(event);
    let sceneContainerSession = args[0] as SCBSceneContainerSession;
    let bundleName: string = '';
    if (sceneContainerSession) {
      bundleName = this.getSessionBundleName(sceneContainerSession);
    } else {
      let otherSceneContainerSession = args[1] as SCBSceneContainerSession;
      bundleName = this.getSessionBundleName(otherSceneContainerSession);
    }
    log.showInfo(`reportEventForRSSIfNeed event:${rssEvent} args:${bundleName}`);
    AnimateToScheduleUtils.reportGestureEvent(rssEvent, bundleName);
  }

  private getSessionBundleName(sceneContainerSession: SCBSceneContainerSession): string {
    if (!sceneContainerSession) {
      return '';
    }
    let bundleNameArray: string[] = [];
    let primaryBundleName = sceneContainerSession?.primarySession?.sceneInfo?.bundleName;
    if (primaryBundleName) {
      bundleNameArray.push(primaryBundleName);
    }
    let secondBundleName = sceneContainerSession?.secondarySession?.sceneInfo?.bundleName;
    if (secondBundleName) {
      bundleNameArray.push(secondBundleName);
    }
    return bundleNameArray.toString();
  }

  private publishCommonEventIfNeed(event: RecentGestureEvent): void {
    if (!COMMON_EVENT_MAP.has(event)) {
      return;
    }
    let commonEvent: CommonGestureEvent | undefined = COMMON_EVENT_MAP.get(event);
    let options: commonEventManager.CommonEventPublishData = {};
    if (commonEvent) {
      let parameters: Record<string, Object> = {
        'gestureEvent': commonEvent
      };
      options.parameters = parameters;
    }
    try {
      commonEventManager.publish(this.customGestureEvent, options, () => {
        log.showDebug('publish CUSTOM_GESTURE_EVENT RecentGestureEvent.ENTER_ZOOM_FOLLOWING success');
      });
    } catch (error) {
      log.error(`[RecentGestureEventManager]publishCommonEventIfNeed fail error: ${error}`);
    }
  }

  private handleHdrSwitchIfNeed(event: RecentGestureEvent): void {
    if (HDR_EVENT_CLOSE_ARRAY.includes(event)) {
      SCBScreenSessionManager.getInstance().setForceCloseHdr(true);
    } else if (HDR_EVENT_OPEN_ARRAY.includes(event)) {
      SCBScreenSessionManager.getInstance().setForceCloseHdr(false);
    }
  }

  /**
   * 注册scene state变化监听
   */
  public registerSceneStateChangeCallback(): void {
    let sessionManager = SCBSceneSessionManager.getInstance();
    sessionManager.registerSceneStateChangeCallback(sessionManager.mainScreenId, this.sceneStateChange);
  }

  /**
   * 反注册scene state变化监听
   */
  public unregisterSceneStateChangeCallback(): void {
    let sessionManager = SCBSceneSessionManager.getInstance();
    sessionManager.unregisterSceneStateChangeCallback(sessionManager.mainScreenId, this.sceneStateChange);
  }
}

const RSS_EVENT_MAP: Map<RecentGestureEvent, RSSGestureEvent> = new Map([
  [RecentGestureEvent.GESTURE_ACTION_START, RSSGestureEvent.GESTURE_ACTION_START],
  [RecentGestureEvent.GESTURE_ACTION_END, RSSGestureEvent.GESTURE_ACTION_END],
  [RecentGestureEvent.ENTER_APP_IDLE_FROM_RECENT_FOLLOWING, RSSGestureEvent.ENTER_APP_START],
  [RecentGestureEvent.ENTER_APP_IDLE_FROM_RECENT_FOLLOWING_END, RSSGestureEvent.ENTER_APP_END],
  [RecentGestureEvent.ENTER_APP_IDLE_FROM_QUICK_SWITCH_FOLLOWING, RSSGestureEvent.ENTER_APP_START],
  [RecentGestureEvent.ENTER_APP_IDLE_FROM_QUICK_SWITCH_FOLLOWING_END, RSSGestureEvent.ENTER_APP_END],
  [RecentGestureEvent.ENTER_APP_IDLE_FROM_ZOOM_FOLLOWING, RSSGestureEvent.ENTER_APP_START],
  [RecentGestureEvent.ENTER_APP_IDLE_FROM_ZOOM_FOLLOWING_END, RSSGestureEvent.ENTER_APP_END],
  [RecentGestureEvent.ENTER_RECENT_IDLE_FROM_APP, RSSGestureEvent.ENTER_RECENT_START],
  [RecentGestureEvent.ENTER_RECENT_IDLE_FROM_APP_END, RSSGestureEvent.ENTER_RECENT_END],
  [RecentGestureEvent.ENTER_QUICK_SWITCH_IDLE_FROM_APP, RSSGestureEvent.ENTER_APP_START],
  [RecentGestureEvent.ENTER_QUICK_SWITCH_IDLE_FROM_APP_END, RSSGestureEvent.ENTER_APP_END],
  [RecentGestureEvent.START_SCENE_FROM_RECENT, RSSGestureEvent.ENTER_APP_START],
  [RecentGestureEvent.START_SCENE_FROM_RECENT_END, RSSGestureEvent.ENTER_APP_END],
  [RecentGestureEvent.CLEAR_ALL_MISSIONS_START, RSSGestureEvent.ENTER_HOME_START],
  [RecentGestureEvent.CLEAR_ALL_MISSIONS_END, RSSGestureEvent.ENTER_HOME_END],
  [RecentGestureEvent.ENTER_HOME_IDLE_START, RSSGestureEvent.ENTER_HOME_START],
  [RecentGestureEvent.ENTER_HOME_IDLE_END, RSSGestureEvent.ENTER_HOME_END],
  [RecentGestureEvent.ENTER_APP_MID, RSSGestureEvent.ENTER_APP_MID],
  [RecentGestureEvent.ENTER_APP_MID_END, RSSGestureEvent.ENTER_APP_MID_END],
  [RecentGestureEvent.ENTER_APP_SPLIT, RSSGestureEvent.ENTER_APP_SPLIT],
  [RecentGestureEvent.ENTER_APP_SPLIT_END, RSSGestureEvent.ENTER_APP_SPLIT_END],
  [RecentGestureEvent.ENTER_APP_FLOAT, RSSGestureEvent.ENTER_APP_FLOAT],
  [RecentGestureEvent.ENTER_APP_FLOAT_END, RSSGestureEvent.ENTER_APP_FLOAT_END]
]);

const COMMON_EVENT_MAP: Map<RecentGestureEvent, CommonGestureEvent> = new Map([
  [RecentGestureEvent.ENTER_ZOOM_FOLLOWING, CommonGestureEvent.ENTER_ZOOM_FOLLOWING],
  [RecentGestureEvent.CLEAR_ALL_MISSIONS_START, CommonGestureEvent.CLEAR_ALL_MISSIONS_START],
  [RecentGestureEvent.ENTER_RECENT_FOLLOWING_FROM_HOME, CommonGestureEvent.ENTER_RECENT_FOLLOWING_FROM_HOME]
]);

const HDR_EVENT_CLOSE_ARRAY: Array<RecentGestureEvent> =
  [RecentGestureEvent.ENTER_ZOOM_FOLLOWING, RecentGestureEvent.ENTER_QUICK_SWITCH_FOLLOWING_FROM_APP];

const HDR_EVENT_OPEN_ARRAY: Array<RecentGestureEvent> = [
  RecentGestureEvent.ENTER_APP_IDLE_FROM_RECENT_FOLLOWING_END,
  RecentGestureEvent.ENTER_APP_IDLE_FROM_QUICK_SWITCH_FOLLOWING_END,
  RecentGestureEvent.ENTER_HOME_IDLE_END,
  RecentGestureEvent.START_SCENE_FROM_RECENT_END,
  RecentGestureEvent.ENTER_APP_IDLE_FROM_ZOOM_FOLLOWING_END,
  RecentGestureEvent.ON_LOCK_RECEIVED,
  RecentGestureEvent.ENTER_QUICK_SWITCH_IDLE_FROM_APP_END,
  RecentGestureEvent.CLEAR_ALL_MISSIONS_END,
  RecentGestureEvent.ENTER_APP_MID_END,
  RecentGestureEvent.ENTER_APP_SPLIT_END,
  RecentGestureEvent.ENTER_APP_FLOAT_END
];

export interface RecentGestureCallback {
  onGestureEvent: (...args: RecentCallbackArgsType[]) => void;
}

export type RecentCallbackArgsType = boolean | number | string | object | null;
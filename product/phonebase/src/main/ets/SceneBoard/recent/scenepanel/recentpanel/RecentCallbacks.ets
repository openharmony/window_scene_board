/**
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { SCBSceneContainerSession } from '@ohos/windowscene';
import { GestureCallbackBase } from '../common/GestureCallback';

export interface RecentIdleCallback extends GestureCallbackBase {
  toHomeIdle: () => void;
  doTouchDown: (event: TouchEvent) => void;
  doTouchUp: (event: TouchEvent) => void;
  toScrollFollowing?: (deltaOffset: number, currentOffset: number) => void;
  toScrollFling?: (deltaOffset: number, currentOffset: number) => void;
  toAppIdle: (sceneContainerSession: SCBSceneContainerSession) => void;
  clearAllMission: () => void;
}

export interface RecentScrollFollowingCallback extends GestureCallbackBase {
  doScroll: (deltaOffset: number, currentOffset: number) => void;
  doTouchUp: (event: TouchEvent) => void;
  toScrollFling?: (deltaOffset: number, currentOffset: number) => void;
}

export interface RecentScrollFlingCallback extends GestureCallbackBase {
  doScroll: (deltaOffset: number, currentOffset: number) => void;
  doTouchDown: (event: TouchEvent) => void;
  doTouchUp: (event: TouchEvent) => void;
  scrollStopToRecentIdle?: () => void;
  touchDownToRecentIdle?: () => void;
  touchDownToScrollFollowing?: () => void;
  toHomeIdle: () => void;
  toAppIdle: (sceneContainerSession: SCBSceneContainerSession) => void;
  clearAllMission: () => void;
}

export interface RecentDeleteFollowingCallback extends GestureCallbackBase {
  update: (containerId: number, event: GestureEvent) => void;
  restore: (containerId: number, event: GestureEvent) => void;
  cancel: (containerId: number, event: GestureEvent) => void;
  delete: (containerId: number, event: GestureEvent) => void;
}

export interface RecentExitCallback {
  exitRecentWithoutAnimationFinish: () => void;
  exitRecentWithAnimationFinish: (sceneContainerSession: SCBSceneContainerSession, animationNum: number,
    exitRecentAnimCnt: number) => void;
}

export interface RecentEnterCallback {
  onFinish: (animationNum: number, isFromNavigationCallback: boolean) => void;
}

export interface RecentStartSceneCallback {
  onFinish: (containerSession: SCBSceneContainerSession, animationNum: number) => void;
}

export interface RecentClearAllCallback {
  initFloatingWhenClearAll: (container: SCBSceneContainerSession) => void;
}
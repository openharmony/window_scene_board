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
import { GestureCallbackBase, GestureCallbackType } from '../common/GestureCallback';

export interface AppIdleCallback extends GestureCallbackBase {
  enterZoomFollowing: GestureCallbackType;
  enterQuickSwitchFollowing: GestureCallbackType;
}

export interface FollowingFromAppCallbackBase extends GestureCallbackBase {
  update: (gestureEvent: GestureEvent) => void;
  enterHomeIdle: GestureCallbackType;
  enterHomeIdleByOneStep: GestureCallbackType;
}

export interface FarAwayFollowingFromAppCallback extends FollowingFromAppCallbackBase {
  enterRecentFollowing: GestureCallbackType;
}

export interface QuickSwitchFollowingFromAppCallback extends FollowingFromAppCallbackBase {
  enterFarAwayFollowing: GestureCallbackType;
  enterRecentFollowing: GestureCallbackType;
  enterAppIdle: GestureCallbackType;
  enterQuickSwitchIdle: GestureCallbackType;
}

export interface RecentFollowingFromAppCallback extends FollowingFromAppCallbackBase {
  prepareToFarAwayUpdate: (gestureEvent: GestureEvent, prepareFarAwayPercent: number) => void;
  enterQuickSwitchFollowing: GestureCallbackType;
  enterFarAwayFollowing: GestureCallbackType;
  enterAppIdle: GestureCallbackType;
  enterRecentIdle: (offsetX: number, offsetY: number, isFromNavigationCallback: boolean) => void;
}

export interface ZoomFollowingFromAppCallback extends FollowingFromAppCallbackBase {
  enterRecentFollowing: (gestureEvent: GestureEvent) => void;
  enterQuickSwitchFollowing: GestureCallbackType;
  enterFarAwayFollowing: GestureCallbackType;
  enterAppIdle: GestureCallbackType;
}
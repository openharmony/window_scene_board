/*
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
export enum ScenePanelStates {
  STATE_HOME_IDLE = 'HomeIdle',
  STATE_OVER_VIEW_FROM_HOME = 'OverViewFollowingFromHome',
  STATE_RECENT_IDLE = 'RecentIdle',
  STATE_RECENT_FOLLOWING_FROM_APP = 'RecentFollowingFromApp',
  STATE_RECENT_FOLLOWING_FROM_HOME = 'RecentFollowingFromHome',
  STATE_QUICK_SWITCH_FOLLOWING_FROM_HOME = 'QuickSwitchFollowingFromHome',
  STATE_RECENT_DELETE_FOLLOWING = 'RecentDeleteFollowing',
  STATE_RECENT_SCROLL_FOLLOWING = 'RecentScrollFollowing',
  STATE_RECENT_SCROLL_FLING = 'RecentScrollFling',

  STATE_APP_IDLE = 'AppIdle',
  STATE_ZOOM_FOLLOWING_FROM_APP = 'ZoomFollowingFromApp',
  STATE_FAR_AWAY_FOLLOWING_FROM_APP = 'FarAwayFollowingFromApp',
  STATE_QUICK_SWITCH_FOLLOWING_FROM_APP = 'QuickSwitchFollowingFromApp',

  STATE_QUICK_SWITCH_IDLE = 'QuickSwitchIdle',

  STATE_SPLIT_IDLE = 'SplitIdle',

  STATE_EMERGENCY_HOME_IDLE = 'EmergencyHomeIdle',

  STATE_SCREEN_LOCK = 'ScreenLockState',

  STATE_OUTDOOR_IDLE = 'OutdoorIdle',
}

export enum RecentClickReason {
  START_APP = 0,
  EXIT_RECENT = 1,
  CLEAR_ALL_MISSION = 2
}
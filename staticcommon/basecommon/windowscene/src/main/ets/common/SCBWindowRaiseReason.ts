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
export enum SCBWindowRaiseReason {
  DEFAULT = 0,
  /**
   * raise up for subsession point down
   */
  SUBSESSION_POINT_DOWN,
  /**
   * raise up for subsession
   */
  SUBSESSION_RAISE_UP,
  /**
   * raise up for lock
   */
  SCREEN_LOCK,
  /**
   * raise up for unlock
   */
  SCREEN_UNLOCK,
  /**
   * raise up for click event
   */
  ON_CLICK,
  /**
   * raise up for topmost change
   */
  SET_TOPMOST,
  /**
   * raise up for pending session
   */
  PENDING_SESSION,
  /**
   * raise up for start scene.
   */
  SCENE_START,
  /**
   * raise up for show.
   */
  SHOW_APP_WINDOW,
}
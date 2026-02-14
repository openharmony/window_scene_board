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
export enum FocusChangeReason {
  /**
   * default focus change reason.
   */
  DEFAULT = 0,
  /**
   * focus change for move up.
   */
  MOVE_UP,
  /**
   * focus change for click.
   */
  CLICK,
  /**
   * focus change for foreground.
   */
  FOREGROUND,
  /**
   * focus change for background.
   */
  BACKGROUND,
  /**
   * focus change for split screen. 5
   */
  SPLIT_SCREEN,
  /**
   * focus change for full screen.
   */
  FULL_SCREEN,
  /**
   * focus change for global search.
   */
  SCB_SESSION_REQUEST,
  /**
   * focus change for floating scene.
   */
  FLOATING_SCENE,
  /**
   * focus change for losing focus.
   */
  SCB_SESSION_REQUEST_UNFOCUS,
  /**
   * focus change for client request. 10
   */
  CLIENT_REQUEST,
  /**
   * focus change for WIND.
   */
  WIND,
  /**
   * focus change for app foreground.
   */
  APP_FOREGROUND,
  /**
   * focus change for app background.
   */
  APP_BACKGROUND,
  /**
   * focus change for recent. Multitasking.
   */
  RECENT,
  /**
   * focus change for inner app.
   */
  SCB_START_APP,
  /**
   * focus for setting focusable.
   */
  FOCUSABLE,
  /**
   * focus change maz.
   */
  MAX,
  /**
   * focus change for midScene
   */
  MID_SCENE,
  /*
   * focus change for opening action menu
   */
  CLICK_MENU,

  /**
   * focus change when pressing alt+tab or dock click
   */
  REQUEST_WITH_CHECK_SUB_WINDOW = 21,
}
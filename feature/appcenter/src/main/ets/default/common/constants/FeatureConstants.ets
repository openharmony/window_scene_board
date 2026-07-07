/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
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

export default class FeatureConstants {
  public static readonly FEATURE_NAME = 'featureAppCenter';
  public static readonly EVENT_UPDATE_CURRENT_PAGE: string = 'event.EVENT_UPDATE_CURRENT_PAGE';
  public static readonly EVENT_UPDATE_GRID_OPTIONS: string = 'event.EVENT_UPDATE_GRID_OPTIONS';
  /**
   *  触发Grid刷新的各个APP生命周期等不同的场景定义
   */
  public static readonly AC_SCENE_DFT: number = 0;
  public static readonly AC_SCENE_APP_LIFE_PKG_ADD_INIT: number = 1;
  public static readonly AC_SCENE_APP_LIFE_PKG_ADD_INSTALLED: number = 2;
  public static readonly AC_SCENE_APP_LIFE_PKG_REMOVED: number = 3;
  public static readonly AC_SCENE_APP_LIFE_PKG_CHANGED: number = 4;
  public static readonly AC_SCENE_APP_DRAG_SUCCESS_END: number = 5;
  public static readonly AC_SCENE_APP_DRAG_INTERRUPT_RESET: number = 6;
  public static readonly AC_SCENE_AC_APP_INIT_LIST_FINISH: number = 7;
  public static readonly AC_SCENE_APPS_REORDER: number = 8;
  public static readonly AC_SCENE_ENV_CHANGED: number = 9;
  public static readonly AC_SCENE_LANDSCAPE_PORTRAIT_SWITCH: number = 10;
  public static readonly AC_SCENE_UNKNOWN: number = 99;

  /**
   *  更新页面事件的原因定义
   */
  public static readonly AC_UPDATE_PAGE_REASON_UNKNOWN: number = 0;
  public static readonly AC_UPDATE_PAGE_REASON_NEW_BLANK_PAGE: number = 1;
}
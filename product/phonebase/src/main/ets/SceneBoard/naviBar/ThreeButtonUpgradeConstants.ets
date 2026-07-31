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

import { SwiperItem } from './settings/model/SwiperItem';

/**
 * 三键导航升级向导变量
 */
export class ThreeButtonUpgradeConstants {
  public static readonly TEXT_TITLE_FONT_SIZE = 36;
  public static readonly TEXT_TITLE_TOP_MARGIN = 72;
  public static readonly TEXT_DETAIL_FONT_SIZE = 16;
  public static readonly TEXT_DETAIL_TOP_MARGIN = 48;
  public static readonly CANVAS_TOP_MARGIN = 12;
  public static readonly TEXT_HEIGHT = 201;
  public static readonly SWIPER_TOP_PADDING = 0;
  public static readonly SWIPER_LEFT_PADDING = 16;
  public static readonly SWIPER_RIGHT_PADDING = 16;
  public static readonly SWIPER_BOTTOM_PADDING = 0;
  public static readonly SWIPER_RADIUS = 32;
  public static readonly SWIPER_BLUR_RADIUS = 90;
  public static readonly SWIPER_SHADOW_RADIUS = 40;
  public static readonly SWIPER_SHADOW_COLOR = '#19000000';
  public static readonly SWIPER_TOP_MARGIN = 56;
  public static readonly SWIPER_LEFT_MARGIN = 16;
  public static readonly SWIPER_RIGHT_MARGIN = 16;
  public static readonly SWIPER_BOTTOM_MARGIN = 24;
  public static readonly SWIPER_MAX_WIDTH = 400;
  public static readonly SWIPER_COLOR = '#4CFFFFFF';
  public static readonly BUTTON_COLOR = '#0A59F7';
  public static readonly BUTTON_HEIGHT = 40;
  public static readonly BUTTON_BOTTOM_MARGIN = 68;

  public static readonly SINK_WIDTH = 16;
  public static readonly THREE_BUTTON_UPGRADE_PHONE_PARAM: ThreeButtonUpgradeParam = {
    jsonPrefix: 'phone_',
    canvasSize: 296,
    horizontal: 16,
    gridNumber: 4,
    sinkNumber: 5,
    lottieMoveUpScale: 0,
    swiperOccupyGridNumber: 4,
    swiperOccupySinkNumber: 3,
    buttonOccupyGridNumber: 2,
    buttonOccupySinkNumber: 3,
    lottieOccupyGridNumber: 4,
    lottieOccupySinkNumber: 1,
  };
  public static readonly THREE_BUTTON_UPGRADE_FOLD_PARAM: ThreeButtonUpgradeParam = {
    jsonPrefix: 'fold_',
    canvasSize: 296,
    horizontal: 16,
    gridNumber: 8,
    sinkNumber: 9,
    lottieMoveUpScale: 0,
    swiperOccupyGridNumber: 6,
    swiperOccupySinkNumber: 5,
    buttonOccupyGridNumber: 3,
    buttonOccupySinkNumber: 2,
    lottieOccupyGridNumber: 4,
    lottieOccupySinkNumber: 1,
  };
  public static readonly THREE_BUTTON_UPGRADE_PAD_PARAM: ThreeButtonUpgradeParam = {
    jsonPrefix: 'tablet_',
    canvasSize: 436,
    horizontal: 72,
    gridNumber: 12,
    sinkNumber: 13,
    lottieMoveUpScale: -0.15,
    swiperOccupyGridNumber: 6,
    swiperOccupySinkNumber: 5,
    buttonOccupyGridNumber: 3,
    buttonOccupySinkNumber: 2,
    lottieOccupyGridNumber: 4,
    lottieOccupySinkNumber: 1,
  };
  public static readonly SWIPER_ITEM_NAME: Array<string> = [
    'gesture_navigation_back.json',
    'gesture_navigation_desk.json',
    'gesture_navigation_open_muti_tasks.json'
  ];
  public static readonly THREE_BUTTON_UPGRADE_SWIPER_ITEM: Array<SwiperItem> = [
    {
      loadCount: 1,
      index: 0,
      function: $r('app.string.gesture_return'),
      detail: $r('app.string.Navi_bar_gesture_back_detail'),
      name: 'gesture_navigation_back.json',
      isPlaying: false,
    },
    {
      loadCount: 1,
      index: 1,
      function: $r('app.string.gesture_return_desktop'),
      detail: $r('app.string.Navi_bar_return_home_detail'),
      name: 'gesture_navigation_desk.json',
      isPlaying: false,
    },
    {
      loadCount: 1,
      index: 2,
      function: $r('app.string.gesture_enter_recent_task'),
      detail: $r('app.string.Navi_bar_recent_detail'),
      name: 'gesture_navigation_open_muti_tasks.json',
      isPlaying: false,
    }
  ];

  public static readonly THREE_BUTTON_UPGRADE_WANT = 'THREE_BUTTON_UPGRADE_WANT';

  public static readonly TBL_NAME = 'three_button_upgrade';
  public static readonly UI_ABILITY = 'ThreeButtonUpgradeUIExtAbility';
  public static readonly BUNDLE_NAME = 'com.ohos.sceneboard';
  public static readonly THREE_BUTTON = 'ThreeButton.db';
  public static readonly CREATE_TBL_SQL = 'CREATE TABLE IF NOT EXISTS three_button_upgrade (id INTEGER PRIMARY KEY ' +
    'AUTOINCREMENT, bundleName TEXT, abilityName TEXT, isVisible TEXT)';
  public static readonly MIGRATE_CLIENT_QUERY_URI =
    'datashare:///com.ohos.migrateclient/migrate_client_base/migrate_client/oobe_info?Proxy=true';
  public static readonly MIGRATE_CLIENT_BUNDLE_NAME = 'com.ohos.migrateclient';
  // 升级前的导航类型
  public static readonly OLD_NAVIGATION_TYPE_KEY = 'secure_gesture_navigation';
  public static readonly UPGRADE_VIEW_PATH = 'SceneBoard/naviBar/view/ThreeButtonUpgradeView';
  public static readonly WINDOW_COLOR = '#00000000';
  public static readonly CONTEXT_KEY = 'desktopContext';
  /**
   * settingdata中保存系统迁移信息1为是系统迁移场景  0表示非
   */
  public static readonly UPGRADE_FROM_DUAL: string = 'upgrade_from_dual';
}

export interface ThreeButtonUpgradeParam {
  jsonPrefix: string;
  canvasSize: number;
  horizontal: number;
  gridNumber: number;
  sinkNumber: number;
  lottieMoveUpScale: number;
  swiperOccupyGridNumber: number;
  buttonOccupyGridNumber: number;
  lottieOccupyGridNumber: number;
  swiperOccupySinkNumber: number;
  buttonOccupySinkNumber: number;
  lottieOccupySinkNumber: number;
}
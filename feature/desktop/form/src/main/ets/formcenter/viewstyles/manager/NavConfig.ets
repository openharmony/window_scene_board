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

import { DeviceHelper } from '@ohos/frameworkwrapper';

export enum NavDestinationLayout {
  // 手机推荐卡平铺布局
  TILE = 0,

  SWIPER = 1,

  // PC grid布局
  GRID = 2,
}

export enum NavItemType {
  // 普通app的item
  NORMAL_APP = 0,

  // 推荐卡
  SUGGESTION = 1,
}

export class NavConfig {
  private static instance?: NavConfig;

  public static getInstance(): NavConfig {
    if (!NavConfig.instance) {
      NavConfig.instance = new NavConfig();
    }
    return NavConfig.instance;
  }

  public typeMap: Map<NavItemType, NavDestinationLayout> = new Map();

  constructor() {
    if (DeviceHelper.isPC()) {
      this.adaptPC();
      return;
    }

    this.typeMap.set(NavItemType.NORMAL_APP, NavDestinationLayout.SWIPER);
    this.typeMap.set(NavItemType.SUGGESTION, NavDestinationLayout.TILE);
  }

  adaptPC() {
    this.typeMap.set(NavItemType.NORMAL_APP, NavDestinationLayout.GRID);
    this.typeMap.set(NavItemType.SUGGESTION, NavDestinationLayout.GRID);
  }
}
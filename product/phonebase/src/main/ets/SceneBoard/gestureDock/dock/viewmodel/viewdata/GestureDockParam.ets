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

import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { GestureDockMode } from '../../../common/GestureDockConstants';
import { GestureDockItemInfo } from '../../../dockbar/model/GestureDockItemInfo';

/**
 * 对内使用的GestureDockParam
 */
@Observed
export class GestureDockViewParam {
  public recentApps: GestureDockItemInfo[] = [];

  public dockApps: GestureDockItemInfo[] = [];

  public appList: AppItemInfo[] = [];

  public gestureDockDirection: number = 0;

  public isShowAllApps: boolean = false;

  public gestureDockShowMode: number = GestureDockMode.APPEAR;

  public isEditDrag: boolean = false;

  public visible: Visibility = Visibility.Visible;

  public allAppsTranslation: number = 0;

  public isDisappearing: boolean = false;
}

/**
 * 对外暴露的SCBGestureDockParam
 */
@Observed
export class SCBGestureDockParam {
  private static mInstance: SCBGestureDockParam | null = null;

  public isGestureDockShow: boolean = false;

  public static getInstance(): SCBGestureDockParam {
    if (!SCBGestureDockParam.mInstance) {
      SCBGestureDockParam.mInstance = new SCBGestureDockParam();
    }
    return SCBGestureDockParam.mInstance;
  }

  private constructor() {
  }
}
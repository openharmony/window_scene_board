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
import { SpecificPanelZOrder } from '@ohos/windowscene';

export enum SCBZIndexOnGeneralScreen {
  BOTTOM = -1, // start, not use

  SYSTEM_SCENE_PANEL = 99,
  SCENE_PANEL = 100,  // app window
  SPECIFIC_ABOVE_SCENE_PANEL = 950,
  PIP_SCENE_PANEL = 990, // pip window
  PIP_SCENE_PANEL_OVERLAY = PIP_SCENE_PANEL + 1, // pip window overlay
  SPECIFIC_ABOVE_SYSTEMUI = 1000,  // system app window
  SYS_DIALOG_DEFAULT = 1902,
  INPUT_METHOD_BELOW_KEYGUARD = 1903,
  SPECIAL_SCENE_PANEL = 2100, // app window above keyguard
  STATUS_BAR = 2202,
  SPECIFIC_ABOVE_KEYGUARD = 3000, // system app window above keyguard
  SYS_DIALOG_UPPER = 3901,
  INPUT_METHOD_ABOVE_KEYGUARD = 3903,
  SYSTEM_TOAST = 7000,

  TOP = 9999, // end, not use
}

export const GENERAL_SCREEN_ZORDER_TO_ZINDEX = new Map<SpecificPanelZOrder, SCBZIndexOnGeneralScreen>([
    [SpecificPanelZOrder.ABOVE_SCENE_PANEL, SCBZIndexOnGeneralScreen.SPECIFIC_ABOVE_SCENE_PANEL],
    [SpecificPanelZOrder.ABOVE_SYSTEMUI, SCBZIndexOnGeneralScreen.SPECIFIC_ABOVE_SYSTEMUI],
    [SpecificPanelZOrder.ABOVE_KEYGUARD, SCBZIndexOnGeneralScreen.SPECIFIC_ABOVE_KEYGUARD],
    [SpecificPanelZOrder.SYSTEM_TOAST, SCBZIndexOnGeneralScreen.SYSTEM_TOAST],
  ]);
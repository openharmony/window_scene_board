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

export class SceneZOrderManager {
  public static readonly INVALID_Z_ORDER: number = -1;
  public static readonly APP_CENTER: number = 1001;
  public static readonly APP_SCENE: number = 2000;
  public static readonly STATUS_BAR: number = 3000;
  public static readonly VOLUME_PANEL: number = 3005;
  public static readonly GLASS_SCREENSHOT_PREVIEW: number = 3006;
  public static readonly BANNER: number = 3007;
  public static readonly STATUS_BAR_HOVER: number = 3008;
  public static readonly CONTROL_CENTER: number = 4000;
  public static readonly NOTIFICATION_CENTER: number = 4001;
  public static readonly CONTROL_CENTER_SUB_WINDOW: number = 4100;
  public static readonly TOAST: number = 5000;
}
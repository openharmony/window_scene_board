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

import { GlassLayoutSize } from '../../common/constants/GlassLayoutConstants'

export class GlassVolumePanelStyle extends GlassLayoutSize {
  public static readonly SHADOW_OFFSET_X: number = 0
  public static readonly SHADOW_OFFSET_Y: number = 1.5
  public static readonly SHADOW_OFFSET_RADIUS: number = 4
  public static readonly VOLUME_PANEL_HEIGHT: string = '320px'
  public static readonly VOLUME_PANEL_TRACK_COLOR: string = 'rgba(26, 26, 26, 0.4)';
  public static readonly VOLUME_PANEL_SELECTED_COLOR: string = 'rgba(255, 255, 255, 0.8)';
  public static readonly VOLUME_PANEL_SHADOW_COLOR: string = 'rgba(0, 0, 0, 0.2)';
  public static readonly VOLUME_PANEL_BACKGROUND_COLOR: string = 'rgba(240, 240, 240, 0.2)';
  public static readonly VOLUME_PANEL_WIDTH_SCALE: number = 0.074;
  public static readonly VOLUME_ICON_SIZE:string = '48px';
}
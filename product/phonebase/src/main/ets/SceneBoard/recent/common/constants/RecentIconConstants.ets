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

import { LengthMetrics } from '@kit.ArkUI';

export class RecentIconConstants {
  /**
   * 应用分身角标资源Map
   */
  public static readonly APP_INDEX_RESOURCE_MAP: Map<number, Resource> = new Map([
    [1, $r('app.media.app_icon_clone_index_1')],
    [2, $r('app.media.app_icon_clone_index_2')],
    [3, $r('app.media.app_icon_clone_index_3')],
    [4, $r('app.media.app_icon_clone_index_4')],
    [5, $r('app.media.app_icon_clone_index_5')],
  ]);

  /**
   * 应用分身角标size
   */
  public static readonly SUB_ICON_SIZE: Length = 12;

  /**
   * 应用分身最大有效数量
   */
  public static readonly MAX_APP_INDEX: number = 5;

  /**
   * 应用分身角标Offset
   */
  public static readonly SUB_ICON_OFFSET: Position | Edges | LocalizedEdges = {
    start: LengthMetrics.vp(3),
    top: LengthMetrics.vp(3),
  };

  /**
   * 中景窗口最大数量
   */
  public static readonly MAX_MID_SCENE_COUNT: number = 3;
}
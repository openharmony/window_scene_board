/**
 * Copyright (c) Huawei Technologies Co., Ltd. 2025-2025. All rights reserved.
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
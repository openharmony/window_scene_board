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

import type { CardItemInfo } from '@ohos/launchercommon';

/**
 * 堆叠事件捐赠信息
 *
 * @since 2025-05-13
 */
export class FormStackEventDonateInfo {
  /**
   * 事件名称
   */
  public actionName: string = '';

  /**
   * 堆叠Id
   */
  public stackId: string = '';

  /**
   * 上个状态，堆叠顶部卡片信息
   */
  public preCardItemInfo?: CardItemInfo;

  /**
   * 当前状态，堆叠顶部卡片信息
   */
  public cardItemInfo?: CardItemInfo;

  /**
   * 堆叠卡片数量
   */
  public itemCount: number = 0;

  /**
   * 在第几屏
   */
  public page: number | undefined = 0;

  /**
   * 卡片左上角在屏幕的位置，第几列
   */
  public column: number | undefined = 0;

  /**
   * 卡片左上角在屏幕的位置，第几行
   */
  public row: number | undefined = 0;
}
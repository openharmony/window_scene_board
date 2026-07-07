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

import { AiSuggestionConstants } from './AiSuggestionConstants';
import type { LauncherRecItem } from './LauncherRecItem';

/**
 * 语音助手建议卡片展示数据
 *
 * @since 2023-10-08
 */
export class LauncherDisplayCardInfo {
  public recItems: LauncherRecItem[] = [];

  public rowsTemplate: string = '';

  public columnsTemplate: string = '';

  public sceneSpanX: number = AiSuggestionConstants.DEFAULT_SCENE_SPAN;

  public sceneSpanY: number = AiSuggestionConstants.DEFAULT_SCENE_SPAN;

  public row: number = AiSuggestionConstants.DEFAULT_SCENE_SPAN;

  public column: number = AiSuggestionConstants.DEFAULT_SCENE_SPAN;

  public patternId: string = '';

  public headerHeight: number = 28;

  public columnGap: number = 8;

  public rowGap: number = 8;

  public gridPadding: number = 8;
}
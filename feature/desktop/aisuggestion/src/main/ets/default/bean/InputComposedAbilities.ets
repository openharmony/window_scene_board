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

import { InputRecItem } from '@ohos/launchercommon/src/main/ets/aisuggestion/InputRecItem';

/**
 * 语音助手建议推荐的内容
 *
 * @since 2023-10-08
 */
export class InputComposedAbilities {
  // 将对应的展示宫格分为几部分，对应的行
  public row: number = 0;

  // 将对应的展示宫格分为几部分，对应的列
  public column: number = 0;

  // 对应的服务推荐结果
  public recItems: Array<InputRecItem> = [];

  // 场景信息占据X坐标的宫格数
  public sceneSpanX: number = 0;

  // 场景信息占据Y坐标的宫格数
  public sceneSpanY: number = 0;

  public patternId: string = '';

  public headerHeight: number = 0;

  public columnGap: number = 0;

  public rowGap: number = 0;

  public gridPadding: number = 0;
} 
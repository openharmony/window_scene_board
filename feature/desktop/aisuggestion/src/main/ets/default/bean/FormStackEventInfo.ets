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

import { FormStackItemInfo } from '@ohos/formstack/src/main/ets/common/FormStackItemInfo';
import type { CardItemInfo } from '@ohos/launchercommon';

/**
 * 堆叠事件信息
 *
 * @since 2024-03-08
 */
export class FormStackEventInfo {
  public actionName: string = '';

  public stackId: string = '';

  public formStackItem: FormStackItemInfo = new FormStackItemInfo();

  public preCardItemInfo?: CardItemInfo;

  public cardItemInfo?: CardItemInfo;

  public cardItemInfoArr: CardItemInfo[] = [];
}
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

import { LiveTimerData } from '@ohos/systemuicommon';

/**
 * 来电接听/挂断事件
 */
export class GlassCallEvent {
  /*
   * 来电消息计时数据
   * */
  public liveTimerData: LiveTimerData | undefined;
  public static eventTypeName: string = 'GlassCallEvent';

  constructor(liveTimerData?: LiveTimerData) {
    this.liveTimerData = liveTimerData;
  }
}

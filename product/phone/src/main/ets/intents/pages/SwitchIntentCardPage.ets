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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import BaseIntentCardInfo from '@ohos/phonebase/src/main/ets/intents//beans/BaseIntentCardInfo';
import SwitchIntentCardInfo from '@ohos/phonebase/src/main/ets/intents//beans/SwitchIntentCardInfo';
import SwitchIntentCard from '@ohos/phonebase/src/main/ets/intents/components/SwitchIntentCard';

const TAG = 'SwitchIntentCardPage';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Entry
@Component
struct SwitchIntentCardPage {
  @StorageLink('cardInfo') cardInfo: BaseIntentCardInfo | undefined = undefined;

  aboutToAppear(): void {
    log.showInfo(`cardInfo = ${JSON.stringify(this.cardInfo)}`);
  }

  build() {
    Stack() {
      SwitchIntentCard({ cardInfo: this.cardInfo as SwitchIntentCardInfo })
    }
  }

  onPageShow():void {
    log.showInfo(`onPageShow`);
  }
}
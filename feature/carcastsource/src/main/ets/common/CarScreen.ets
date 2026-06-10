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

import { Logger, LogDomain } from '@ohos/basicutils';
import { SCBScreenSession } from '@ohos/windowscene';
import lazy { PadWithCarScreen } from '../padwithcar/screen/PadWithCarScreen';

const TAG = 'CarScreen';
const log: Logger = Logger.getLogHelper(LogDomain.HOME);

@Component
export struct CarScreen {
  @ObjectLink screenSession: SCBScreenSession

  aboutToAppear() {
    log.info(TAG, `aboutToAppear, screen.name: ${this.screenSession?.session?.name}`);
  }

  aboutToDisappear() {
    log.info(TAG, 'aboutToDisappear');
  }

  build() {
    if (this.screenSession?.session?.name === 'PadWithCar') {
      PadWithCarScreen({ screenSession: this.screenSession })
    }
  }
}

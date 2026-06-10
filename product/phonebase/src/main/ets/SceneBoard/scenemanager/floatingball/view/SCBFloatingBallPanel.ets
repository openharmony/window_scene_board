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

import { LogDomain, Logger } from '@ohos/basicutils';
import { ScreenProperty } from '../model/ScreenProperty';
import { SCBFloatingBallPanelVm } from '../vm/SCBFloatingBallPanelVm';
import lazy { FloatingBallPanelView } from './FloatingBallPanelView';

const TAG = 'SCBFloatingBallPanel';
const log: Logger = Logger.getLogHelper(LogDomain.WINDOW);

@ComponentV2
export struct SCBFloatingBallPanel {
  @Param @Require screenProperty: ScreenProperty;

  aboutToAppear(): void {
    log.showInfo(TAG, 'aboutToAppear');
    SCBFloatingBallPanelVm.instance.init();
  }

  aboutToDisappear() {
    log.showInfo(TAG, 'aboutToDisappear');
  }

  build() {
    if (SCBFloatingBallPanelVm.instance.sessionList.length) {
      FloatingBallPanelView({ screenProperty: this.screenProperty })
    }
  }
}
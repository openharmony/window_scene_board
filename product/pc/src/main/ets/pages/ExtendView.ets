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

import { LogDomain, LogHelper, } from '@ohos/basicutils';
import {
  SCBSceneSessionManager,
  SCBScreenSessionManager,
  SCBScreenSession,
  SCBKeyboardManager,
} from '@ohos/windowscene';


import { SCBExtendScreen } from '@ohos/pcbase/src/main/ets/SceneBoard/scenemanager/SCBExtendScreen';
import { EsDockEventManager } from '@ohos/pcsmartdock';

const TAG = 'SCBExtendView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
let storage = LocalStorage.getShared();

let that: ExtendView;
const TOUCHPAD_EVENT_INTERVAL = 7;
const REFRESH_DESKTOP_INTERVAL = 200;

@Entry(storage)
@Component
struct ExtendView {
  @State screenSession:SCBScreenSession = SCBScreenSessionManager.getInstance().getExtendScreenSession();

  aboutToAppear(): void {
    log.showInfo(TAG, 'Extend screen id:%{public}s aboutToAppear', JSON.stringify(this.screenSession?.session));

    if (this.screenSession) {    
      EsDockEventManager.getInstance().handleScreenConnect(this.screenSession);
      SCBKeyboardManager.getInstance().keyboardStateChangeForPCScreenConnect(this.screenSession);
    }

  }

  aboutToDisappear(): void {
    log.showInfo(TAG, 'Extend screen id:%{public}d aboutToDisappear', this.screenSession?.session?.screenId);
  }

  onPageShow() {
    log.showInfo('ExtendView onPageShow');
    if (this.screenSession) {
      SCBSceneSessionManager.getInstance().setStartRecovery(true, this.screenSession.session.screenId);
    }
  }

  build() {
    Stack({ alignContent: Alignment.BottomStart }) {
      SCBExtendScreen({ screenSession: this.screenSession })
    }
    .height('100%')
    .width('100%')
    .position({ x: 0, y: 0 })
  }
}
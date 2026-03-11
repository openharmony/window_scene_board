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
import {
  SCBRootSceneSession,
  SCBSceneSessionManager,
  SCBScreenSession,
  SCBScreenSessionManager
} from '@ohos/windowscene';
import { DevScreen } from '@ohos/devecoviewer';

const TAG = 'SCBCDevEcoViewer';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HOME, TAG);
const DEFAULT_VIRTUAL_SCREEN_ID = 1000;
let storage = LocalStorage.getShared();

@Entry(storage)
@Component
struct DevView {
  @LocalStorageLink('screenSession') screenSession: SCBScreenSession =
    SCBScreenSessionManager.getInstance().getScreenSession(DEFAULT_VIRTUAL_SCREEN_ID);
  private rootSceneSession: SCBRootSceneSession = SCBSceneSessionManager.getInstance().getRootSceneSession()

  aboutToAppear(): void {
    log.info(TAG, `SCBCarView aboutToAppear`);
  }

  aboutToDisappear(): void {
    if (this.screenSession.session.name === 'DevEcoViewer') {
      SCBSceneSessionManager.getInstance().unregisterPopSceneSession(this.screenSession.session.screenId);
      SCBSceneSessionManager.getInstance().unregisterVirtualScreenStartScene(this.screenSession.session.screenId);
    } else {
      log.showInfo('removeScreenSession success, no need to destroyInstance');
    }
  }

  build() {
    RootScene(this.rootSceneSession.session) {
      DevScreen({ screenSession: this.screenSession })
    }
  }
}
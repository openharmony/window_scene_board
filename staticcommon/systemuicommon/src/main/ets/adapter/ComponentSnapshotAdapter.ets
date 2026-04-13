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

import { image } from '@kit.ImageKit';
import lazy sceneSessionManager from '@ohos.sceneSessionManager';
// import lazy { getWithRange } from '@ohos/windowsceneinterfaces/src/main/ets/interfaces/stub/StubGetWithRange';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { threadCall, ThreadCallType } from '../messageChannel/ThreadCall';

const TAG = 'ComponentSnapshotAdapter';
const log = LogHelper.getLogHelper(LogDomain.CC, TAG);

// 组件截图起终点
const SNAPSHOT_START_NODE: string = 'OneHandModeBox';
const SNAPSHOT_END_NODE: string = 'StatusBarBox';

interface ComponentSnapshotCallback {
  callback: Callback<SnapshotPixMap>;
}

export interface SnapshotPixMap {
  pixMap: image.PixelMap;
}

export class ComponentSnapshotAdapter {
  @threadCall(ThreadCallType.RegisterOnce)
  public static getWithRange(callback: ComponentSnapshotCallback, tag: string): void {
    log.showInfo(`getWithRange tag ${tag}`);
    try {
      /*getWithRange(sceneSessionManager.getRootSceneUIContext().getComponentSnapshot(),
        SNAPSHOT_START_NODE, SNAPSHOT_END_NODE, true, { scale: 0.5 }).then((pixMap: image.PixelMap) => {
          callback.callback({pixMap: pixMap});
        }).catch((err: Error) => {
        log.showError(`getComponentSnapshot error: ${err}`);
      })*/
    } catch (error) {
      log.error('getWithRange error', error);
    }
  }
}
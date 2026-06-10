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

import { image } from '@kit.ImageKit';
import { curves } from '@kit.ArkUI';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { StyleConstants } from '@ohos/launchercommon';
import { EvtBus } from '@ohos/frameworkwrapper/src/main/ets/eventbus/EventBus';
import {
  UltraScreenExpandAnimUtils,
  SCBTripleStateChange
} from '@ohos/launchercommon/src/main/ets/utils/UltraScreenExpandAnimUtils';

const TAG = 'FolderExpandSnapshotView';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct FolderExpandSnapshotView {
  @Require foldExpandSnapShotSessionId: number = -1;
  @Require foldExpandStateChange: SCBTripleStateChange = SCBTripleStateChange.INVALID;
  private foldExpandSnapShot: image.PixelMap | null = null;
  @State foldExpandSnapShotEnable: boolean = false;
  @State imageAlignment: Alignment = Alignment.TopStart;

  aboutToAppear(): void {
    if (this.foldExpandSnapShotSessionId === -1) {
      return;
    }
    log.showDebug(`foldExpandSnapShot aboutToAppear`);
    this.getSnapshot();
  }

  aboutToDisappear(): void {
    log.showInfo(`foldExpandSnapShot aboutToDisappear`);
    this.foldExpandSnapShot?.release();
    this.foldExpandSnapShot = null;
  }

  private snapshotEventListener = () => {
    this.imageAlignment = Alignment.TopStart;
    this.getSnapshot();
  }

  getSnapshot(): void {
    this.foldExpandSnapShot?.release();
    try {
      this.foldExpandSnapShot =
        sceneSessionManager.getSessionSnapshotPixelMapSync(this.foldExpandSnapShotSessionId, 1);
      log.showInfo(`foldExpandSnapShot get snapShot`);
      this.foldExpandSnapShotEnable = true;
      animateTo({
        curve: UltraScreenExpandAnimUtils.getScenePanelSnapshotAlphaCurve(this.foldExpandStateChange)
      }, () => {
        this.foldExpandSnapShotEnable = false;
        this.foldExpandSnapShot?.release();
        this.foldExpandSnapShot = null;
      })
    } catch (error) {
      log.showError(`foldExpandSnapShot getSnapShot error ${error}`);
    }
  }

  build() {
    Stack({ alignContent: this.imageAlignment }) {
      if (this.foldExpandSnapShotEnable) {
        Image(this.foldExpandSnapShot)
          .hitTestBehavior(HitTestMode.None)
          .objectFit(ImageFit.TOP_START)
          .syncLoad(true)
          .transition(TransitionEffect.asymmetric(TransitionEffect.IDENTITY, TransitionEffect.OPACITY))
          .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
      }
    }
    .hitTestBehavior(HitTestMode.None)
    .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
  }
}
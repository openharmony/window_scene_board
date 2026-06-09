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

import { StyleConstants } from '@ohos/launchercommon/src/main/ets/constants/StyleConstants';
import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBSceneSession } from '@ohos/windowscene';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, 'CastScene');

@Component
export struct CastScene {
  @ObjectLink sceneSession: SCBSceneSession | undefined;

  aboutToAppear(): void {
    log.info('aboutToAppear');
  }

  aboutToDisappear(): void {
    log.info('aboutToDisappear');
  }

  build() {
    Stack() {
      WindowScene(this.sceneSession?.session.persistentId)
        .size({
          width: StyleConstants.PERCENTAGE_100,
          height: StyleConstants.PERCENTAGE_100,
        })
        .id(`session${this.sceneSession?.session.persistentId}`)
        .visibility(this.sceneSession?.visibility ? Visibility.Visible : Visibility.Hidden)
        .focusable(this.sceneSession && this.sceneSession.isFocusable || false)
        .hitTestBehavior(this.sceneSession?.isTouchable ? HitTestMode.Default : HitTestMode.None)
        .clip(this.sceneSession && this.sceneSession?.floatBorderRadius > 0 ? true : false)
    }
    .size({
      width: StyleConstants.PERCENTAGE_100,
      height: StyleConstants.PERCENTAGE_100
    })
    .translate({ x: this.sceneSession?.translateX })
    .position({ x: 0, y: 0 })
    .hitTestBehavior(HitTestMode.None)
  }
}

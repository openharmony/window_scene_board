/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { StyleConstants } from '@ohos/launchercommon';
import { SCBSceneSession, SCBScreenProperty, SCBSpecificSceneSessionList, SCBSpecificSession } from '@ohos/windowscene';
import { SCBGeneralSceneViewModel } from '../viewmodel/SCBGeneralSceneViewModel'
import { SCBGeneralSpecificScene } from './SCBGeneralSpecificScene';

const TAG: string = 'SCBGeneralScene';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct SCBGeneralScene {
  @ObjectLink screenProperty: SCBScreenProperty;
  @ObjectLink sceneSession: SCBSceneSession;
  @State subSessionList: SCBSpecificSceneSessionList = this.sceneSession.subSessionList;
  private sceneViewModel = new SCBGeneralSceneViewModel(this.screenProperty, this.sceneSession);

  aboutToAppear(): void {
    log.showInfo(` id: ${this.sceneSession?.persistentId} on screen:${this.screenProperty.screenId} aboutToAppear`);
    this.sceneViewModel.init();
  }

  aboutToDisappear(): void {
    log.showInfo(` id: ${this.sceneSession?.persistentId}` +
      ` on screen:${this.screenProperty.screenId}`);
    this.sceneViewModel.release();
  }

  build() {
    Stack() {
      WindowScene(this.sceneSession?.persistentId) {
        ForEach(this.subSessionList, (item: SCBSpecificSession) => {
          if (item != null) {
            SCBGeneralSpecificScene({
              screenProperty: this.screenProperty,
              specificSession: item
            })
          }
        }, (item: SCBSpecificSession) => item.persistentId.toString())
      }
      .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100, })
      .id(`session${this.sceneSession?.persistentId}`)
      .visibility(this.sceneSession?.visibility ? Visibility.Visible : Visibility.Hidden)
      .focusable(this.sceneSession && this.sceneSession.isFocusable || false)
      .hitTestBehavior(this.sceneSession?.isTouchable ? HitTestMode.Default : HitTestMode.None)
      .clip(this.sceneSession && this.sceneSession?.floatBorderRadius > 0 ? true : false)
    }
    .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
    .translate({ x: this.sceneSession?.translateX })
    .position({ x: 0, y: 0 })
  }
}
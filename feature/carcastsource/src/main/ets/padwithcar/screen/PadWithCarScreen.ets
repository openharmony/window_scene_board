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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBScreenProperty, SCBScreenSession } from '@ohos/windowscene';
import { SceneConstants } from '@ohos/commonconstants';
import { PadWithCarScenePanel } from '../view/PadWithCarScenePanel';
import { PadWithCarInputMethod } from '../keyboard/PadWithCarInputMethod';

const TAG = 'PadWithCarScreen';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, TAG);
const TRANSFORM_SCENE_INDEX: number = 2002;

@Component
export struct PadWithCarScreen {
  @ObjectLink screenSession: SCBScreenSession
  @State scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();

  initScreenProperty(): void {
    this.scbScreenProperty.left = this.screenSession.physicalBounds.left;
    this.scbScreenProperty.top = this.screenSession.physicalBounds.top;
    this.scbScreenProperty.width = this.screenSession.physicalBounds.width;
    this.scbScreenProperty.height = this.screenSession.physicalBounds.height;
    log.showInfo(`initScreenProperty sensor, width:${this.scbScreenProperty.width},` +
      `height:${this.scbScreenProperty.height},` +
      `left:${this.scbScreenProperty.left},` +
      `top:${this.scbScreenProperty.top}`);
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.scbScreenProperty.screenId = this.screenSession?.session?.screenId;
    this.initScreenProperty();
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.screenSession.registerPropertyChange(null);
  }

  build() {
    Screen(this.screenSession?.session?.screenId) {
      WindowScene(SceneConstants.TRANSFORM_SCENE) {
        PadWithCarScenePanel({ screenProperty: $scbScreenProperty })
        PadWithCarInputMethod({ screenProperty: $scbScreenProperty })
      }
      .width(`${this.scbScreenProperty.width}px`)
      .height(`${this.scbScreenProperty.height}px`)
      .hitTestBehavior(HitTestMode.None)
      .zIndex(TRANSFORM_SCENE_INDEX)
    }
    .position({ x: `${this.scbScreenProperty.left}px`, y: `${this.scbScreenProperty.top}px` })
    .width(`${this.scbScreenProperty.width}px`)
    .height(`${this.scbScreenProperty.height}px`)
  }
}
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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { SCBScreenSession, SCBScreenProperty } from '@ohos/windowscene';
import { DevScenePanel } from './devengineview/DevScenePanel';
import screenSessionManager from '@ohos.screenSessionManager';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, 'DevScreen');

@Component
export struct DevScreen {
  @ObjectLink screenSession: SCBScreenSession
  @State scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();

  initScreenProperty(): void {
    this.scbScreenProperty.left = this.screenSession.physicalBounds.left;
    this.scbScreenProperty.top = this.screenSession.physicalBounds.top;
    this.scbScreenProperty.width = this.screenSession.physicalBounds.width;
    this.scbScreenProperty.height = this.screenSession.physicalBounds.height;
    // 屏幕更新可用区域
    screenSessionManager.updateAvailableArea(this.scbScreenProperty.screenId, {
      posX: this.scbScreenProperty.left,
      posY: this.scbScreenProperty.top,
      width: this.scbScreenProperty.width,
      height: this.scbScreenProperty.height
    });
  }

  onScreenPropertyChange(screenProperty: SCBScreenProperty): void {
    log.showInfo(`onScreenPropertyChange: width: ${screenProperty.width}; height: ${screenProperty.height}`);
    this.scbScreenProperty.copy(screenProperty);
  }

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.scbScreenProperty.screenId = this.screenSession.session.screenId;
    this.initScreenProperty();
    this.screenSession.registerPropertyChange(
      (screenProperty: SCBScreenProperty) => {
        this.onScreenPropertyChange(screenProperty);
      });
  }

  aboutToDisappear() {
  }

  build() {
    Screen(this.screenSession.session.screenId) {
      DevScenePanel({ screenProperty: $scbScreenProperty })
    }
    .position({ x: `${this.scbScreenProperty.left}px`, y: `${this.scbScreenProperty.top}px` })
    .width(`${this.scbScreenProperty.width}px`)
    .height(`${this.scbScreenProperty.height}px`)
  }
}
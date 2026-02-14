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

import {
  SCBScreenSession,
  SCBScreenProperty,
  SCBSceneSessionManager,
  SCBScreenSessionManager,
} from '@ohos/windowscene';
import screenSessionManager from '@ohos.screenSessionManager';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SCBScreenStateHolder } from '../viewstates/SCBScreenStateHolder';

const TAG: string = 'SCBGeneralScreenViewModel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

export class SCBGeneralScreenViewModel {
  public screenSession: SCBScreenSession;
  public scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
  public stateHolder: SCBScreenStateHolder = new SCBScreenStateHolder();

  private screenPropertyChangeListener = (screenProperty: SCBScreenProperty,
    reason: screenSessionManager.ScreenPropertyChangeReason) => {
    this.onScreenPropertyChange(screenProperty, reason);
  };

  constructor(screenSession: SCBScreenSession) {
    this.screenSession = screenSession;
  }

  /**
   * init when view aboutToAppear
   */
  public init(): void {
    this.initScreenProperty();
    this.screenSession.registerPropertyChange(this.screenPropertyChangeListener);
    SCBSceneSessionManager.getInstance().setPanelLists(this.scbScreenProperty.screenId);
  }

  /**
   * release when view aboutToDisappear
   */
  public release(): void {
    this.screenSession.registerPropertyChange(null);
  }

  private initScreenProperty(): void {
    this.scbScreenProperty.screenId = this.screenSession.session.screenId;
    this.scbScreenProperty.copyBounds(this.screenSession.physicalBounds);
    log.showInfo('initScreenProperty, width:%{public}d, height:%{public}d, screenId:%{public}d',
      this.scbScreenProperty.width, this.scbScreenProperty.height, this.scbScreenProperty.screenId);
  }

  private onScreenPropertyChange(screenProperty: SCBScreenProperty,
    reason: screenSessionManager.ScreenPropertyChangeReason): void {
    let tmpProperty = new SCBScreenProperty();
    tmpProperty.copy(screenProperty);
    tmpProperty.screenId = this.screenSession.session.screenId;
    this.scbScreenProperty.copy(tmpProperty);
    log.showInfo('onScreenPropertyChange, width:%{public}d, height:%{public}d, screenId:%{public}d, reason:%{public}d',
      this.scbScreenProperty.width, this.scbScreenProperty.height, this.scbScreenProperty.screenId, reason);
    SCBScreenSessionManager.getInstance().notifyScenePanelRotationChange(tmpProperty, this.scbScreenProperty);
  }
}
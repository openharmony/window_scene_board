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
import {
  SCBSceneContainerSession,
  SCBSceneSession, SCBScreenProperty,
} from '@ohos/windowscene';
import { StyleConstants } from '@ohos/launchercommon';
import { SCBGeneralScene } from './SCBGeneralScene'
import { SCBGeneralContainerViewModel } from '../viewmodel/SCBGeneralContainerViewModel'

const TAG: string = 'SCBGeneralContainer';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

interface SCBSceneBuilderParam {
  screenProperty: SCBScreenProperty;
  sceneSession: SCBSceneSession;
}

@Component
export struct SCBGeneralSceneContainer {
  @ObjectLink screenProperty: SCBScreenProperty;
  @ObjectLink sceneContainerSession: SCBSceneContainerSession;
  private containerViewModel = new SCBGeneralContainerViewModel(this.sceneContainerSession);

  aboutToAppear(): void {
    log.showInfo('aboutToAppear with containerId: %{public}d', this.sceneContainerSession?.containerId);
  }

  aboutToDisappear(): void {
    log.showInfo('aboutToDisappear with containerId: %{public}d', this.sceneContainerSession?.containerId);
  }

  @Builder
  sceneBuilder($$: SCBSceneBuilderParam) {
    SCBGeneralScene({
      screenProperty: $$.screenProperty,
      sceneSession: $$.sceneSession,
    })
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.sceneContainerSession?.primarySession && this.sceneContainerSession.enableShow()) {
        this.sceneBuilder({
          screenProperty: this.screenProperty,
          sceneSession: this.sceneContainerSession.primarySession
        })
      }
    }
    .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
  }
}
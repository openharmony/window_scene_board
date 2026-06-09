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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SceneConstants } from '@ohos/commonconstants';
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBScreenProperty,
  SCBSystemSceneSession,
} from '@ohos/windowscene';
import { SCBGeneralPanelViewModel } from '../viewmodel/SCBGeneralPanelViewModel';
import { SCBGeneralSceneContainer } from './SCBGeneralSceneContainer';

const TAG: string = 'SCBGeneralFreeWindowScenePanel';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct SCBGeneralFreeWindowScenePanel {
  @Link screenProperty: SCBScreenProperty;
  private panelViewModel: SCBGeneralPanelViewModel = new SCBGeneralPanelViewModel(this.screenProperty);
  private sysSceneSession: SCBSystemSceneSession = this.panelViewModel.sysSceneSession;
  @State containerSessionList: SCBSceneContainerSessionArray =
    this.panelViewModel.missionHandler.getContainerSessionList();

  aboutToAppear() {
    log.showInfo(`${this.panelViewModel.logTag}aboutToAppear`);
    this.panelViewModel.init();
  }

  aboutToDisappear(): void {
    log.showInfo(`${this.panelViewModel.logTag}aboutToDisappear`);
    this.panelViewModel.release();
  }

  @Styles
  transformSceneStyles() {
    .id(`${this.panelViewModel.panelName}_TransformScene`)
    .position({ x: 0, y: 0 })
    .size({
      width: this.screenProperty.width + 'px',
      height: this.screenProperty.height + 'px'
    })
    .hitTestBehavior(HitTestMode.None)
  }

  @Styles
  scenePanelCanvasStyles() {
    .id(`${this.panelViewModel.panelName}_Canvas`)
    .direction(Direction.Ltr)
    .focusable(false)
    .position({ x: 0, y: 0 })
    .size({
      width: this.screenProperty.width + 'px',
      height: this.screenProperty.height + 'px'
    })
    .hitTestBehavior(HitTestMode.None)
  }

  @Builder
  containerViewsBuilder() {
    Stack({ alignContent: Alignment.TopStart }) {
      ForEach(this.containerSessionList, (containerSessionItem: SCBSceneContainerSession, index: number) => {
        if (containerSessionItem.enableShow()) {
          SCBGeneralSceneContainer({
            screenProperty: this.screenProperty,
            sceneContainerSession:containerSessionItem,
          })
        }
      })
    }
    .id(`${this.panelViewModel.panelName}_ContainerCanvas`)
    .direction(Direction.Ltr)
    .accessibilityLevel('no')
    .size({
      width: this.screenProperty.width + 'px',
      height: this.screenProperty.height + 'px'
    })
    .hitTestBehavior(HitTestMode.None)
  }

  build() {
    WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
      WindowScene(this.sysSceneSession?.session.persistentId) { // for input event in recent
        Stack({ alignContent: Alignment.TopStart }) {
          // main windows
          this.containerViewsBuilder()
        }
        .id(`${this.panelViewModel.panelName}_Stack`)
        .direction(Direction.Ltr)
      }
      .scenePanelCanvasStyles()
    }
    .transformSceneStyles()
  }
}
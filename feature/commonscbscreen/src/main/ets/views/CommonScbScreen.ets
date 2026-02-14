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

import { LogHelper, LogDomain, } from '@ohos/basicutils';
import {
  SCBScreenSession,
  SCBScreenProperty, SpecificPanelZOrder,
} from '@ohos/windowscene';
import {
  SCBSystemScene,
  SystemSceneBuilderParam,
  SystemSceneOptions
} from '@ohos/windowscene/Index';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { SCBGeneralScenePanel } from './SCBGeneralScenePanel'
import { SCBGeneralScreenViewModel } from '../viewmodel/SCBGeneralScreenViewModel';
import { SCBGeneralStatusBar } from './SCBGeneralStatusBar';
import { SCBZIndexOnGeneralScreen } from '../config/SCBZIndexOnGeneralScreen';
import { SCBGeneralFreeWindowScenePanel } from './SCBGeneralFreeWindowScenePanel';
import { SCBScreenStateHolder } from '../viewstates/SCBScreenStateHolder';
import { SCBGeneralSpecificScenePanel } from './SCBGeneralSpecificScenePanel';

const TAG: string = 'CommonScbScreen';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct CommonScbScreen {
  @ObjectLink screenSession: SCBScreenSession;
  private screenViewModel: SCBGeneralScreenViewModel = new SCBGeneralScreenViewModel(this.screenSession);

  @State scbScreenProperty: SCBScreenProperty = this.screenViewModel.scbScreenProperty;
  @State screenStates: SCBScreenStateHolder = this.screenViewModel.stateHolder;

  aboutToAppear() {
    log.showInfo('aboutToAppear');
    this.screenViewModel.init();
  }

  aboutToDisappear() {
    log.showInfo('aboutToDisappear');
    this.screenViewModel.release();
  }

  @Builder systemSceneBuilder(contextBuilder: ($$: SystemSceneBuilderParam) => void,
    systemType: sceneSessionManager.SessionType, sceneName: string, sceneZIndex: number, options: SystemSceneOptions,
    windowInputType?: number) {
    if (contextBuilder) {
      SCBSystemScene({
        contextBuilder: contextBuilder,
        systemSessionInfo: {
          systemType: systemType,
          sceneName: sceneName,
          sceneZIndex: sceneZIndex,
          isFocusable: options.focusable,
          isBlockingFocus: options.blockingFocus,
          isTouchable: options.touchable,
          privacyMode: options.privacyMode,
          hitTestMode: options.hitTestMode,
          isRotatable: options.rotatable,
          visibility: options.visibility,
          opacity: options.opacity,
          scbKeepKeyboardFlag: options.scbKeepKeyboardFlag,
          responseRegion: options.responseRegion,
          systemBarType: options.systemBarType,
          windowInputType: windowInputType,
          isLandscapeStartRotatable: options.landscapeStartRotatable,
          sceneType: options.sceneType,
          isFollowDeskTop: options.followDeskTop,
          alwaysNeedAnimateWhenRotation: options.alwaysNeedAnimateWhenRotation
        },
        screenProperty: this.scbScreenProperty
      })
    }
  }

  @Builder statusBarBuilder($$: SystemSceneBuilderParam) {
    SCBGeneralStatusBar({persistentId: $$.persistentId, screenProp: $$.screenProp})
  }

  build() {
    Screen(this.screenSession?.session?.screenId) {
      if (!this.screenStates.freeWindowModeEnabled) {
        // general virtual status bar, disabled in free window mode
        this.systemSceneBuilder(this.statusBarBuilder, sceneSessionManager.SessionType.TYPE_STATUS_BAR, 'SCBStatusBar',
          SCBZIndexOnGeneralScreen.STATUS_BAR, new SystemSceneOptions({ touchable: true, rotatable: true }));
      }

      // general app panel
      if (!this.screenStates.freeWindowModeEnabled) {
        SCBGeneralScenePanel({ screenProperty: this.scbScreenProperty });

        // System Float window zorder ABOVE_SCENE_PANEL
        SCBGeneralSpecificScenePanel({
          screenProperty: this.scbScreenProperty,
          zorder: SpecificPanelZOrder.ABOVE_SCENE_PANEL
        });

        // system app above systemui zorder
        SCBGeneralSpecificScenePanel({
          screenProperty: this.scbScreenProperty,
          zorder: SpecificPanelZOrder.ABOVE_SYSTEMUI
        });

        // system app volume overlay type zorder SYSTEM_TOAST
        SCBGeneralSpecificScenePanel({
          screenProperty: this.scbScreenProperty,
          zorder: SpecificPanelZOrder.SYSTEM_TOAST
        });
      } else {
        SCBGeneralFreeWindowScenePanel({ screenProperty: this.scbScreenProperty });
      }
    }
    .id(`CommonScreen_${this.screenSession?.session?.name}`)
    .position({ x: `${this.scbScreenProperty.left}px`, y: `${this.scbScreenProperty.top}px` })
    .width(`${this.scbScreenProperty.width}px`)
    .height(`${this.scbScreenProperty.height}px`)
    .backgroundColor(Color.White)
  }
} 
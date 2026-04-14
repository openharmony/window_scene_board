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
import {
  SCBScreenProperty,
  SCBSceneSession,
  SCBSceneSessionManager,
} from '@ohos/windowscene';
import { PadWithCarScene } from './PadWithCarScene';
import { PadWithCarSceneManager } from '../manager/PadWithCarSceneManager';
import PanelModel from '../model/PanelModel';
import { PadWithCarPanelViewModel } from '../viewModel/PadWithCarPanelViewModel';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, 'PadWithCarScenePanel');

@Component
export struct PadWithCarScenePanel {
  @State panelModel: PanelModel | undefined = undefined;
  @Link screenProperty: SCBScreenProperty; // current screen property;
  @State panelViewModel: PadWithCarPanelViewModel = new PadWithCarPanelViewModel();
  private panelModelChangeCallBack = (panelModel: PanelModel) => {
    log.showInfo('panelModelChangeCallBack');
    this.panelModel = panelModel;
  }

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear screenId: ${this.screenProperty.screenId}`);
    PadWithCarSceneManager.getInstance().init(this.screenProperty);
    SCBSceneSessionManager.getInstance().runCastTaskIfNeed();
    this.panelViewModel.init(this.screenProperty);
    this.panelViewModel.registerPanelModelChange(this.panelModelChangeCallBack);
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.panelViewModel.unregisterPanelModelChange();
    this.panelViewModel.deInit();
    PadWithCarSceneManager.getInstance().deInit();
  }

  build() {
    Stack({ alignContent: Alignment.TopStart }) {
      if (this.panelModel && this.panelModel?.scbSceneSessionArray.length !== 0) {
        ForEach(this.panelModel?.scbSceneSessionArray, (scbSceneSession: SCBSceneSession) => {
          PadWithCarScene({
            sceneSession: scbSceneSession,
            screenProperty: this.screenProperty,
            appZOrder: this.panelModel?.appZOrder
          })
        }, (scbSceneSession: SCBSceneSession) => `cast_engine_session_${scbSceneSession.session.persistentId}`)
      }
    }
    .backgroundColor('sys.color.ohos_id_color_background')
    .width(`${this.screenProperty.width}px`)
    .height(`${this.screenProperty.height}px`)
    .hitTestBehavior(HitTestMode.None)
  }
}
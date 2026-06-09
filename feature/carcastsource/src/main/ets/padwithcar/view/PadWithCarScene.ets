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
import {
  SCBSceneSession,
  SCBScreenProperty,
  SCBSpecificSceneSessionList,
  SCBSpecificSession
} from '@ohos/windowscene';
import { PadWithCarSpecificScene } from './PadWithCarSpecificScene';
import MainSceneModel from '../model/MainSceneModel';
import { PadWithCarSceneViewModel } from '../viewModel/PadWithCarSceneViewModel';

const log: LogHelper = LogHelper.getLogHelper(LogDomain.HICAR, 'PadWithCarScene');

@Component
export struct PadWithCarScene {
  appZOrder: number = 0;
  @ObjectLink sceneSession: SCBSceneSession | undefined;
  @Link screenProperty: SCBScreenProperty; // current screen property;
  @State subSessionList: SCBSpecificSceneSessionList = new SCBSpecificSceneSessionList();
  private sceneViewModel: PadWithCarSceneViewModel = new PadWithCarSceneViewModel();
  private modelChangeCallback = (sceneModel: MainSceneModel) => {
    log.info(`modelChangeCallback subSessionList size =  ${sceneModel.subSessionList.length}`);
    this.subSessionList = sceneModel.subSessionList;
  }

  aboutToAppear(): void {
    log.info(`aboutToAppear sceneSession ${this.sceneSession?.session?.bundleName}`);
    let sceneModel: MainSceneModel = new MainSceneModel();
    sceneModel.appZOrder = this.appZOrder;
    sceneModel.screenProperty = this.screenProperty;
    sceneModel.sceneSession = this.sceneSession;
    this.sceneViewModel.init(sceneModel, this.modelChangeCallback);
  }

  aboutToDisappear(): void {
    log.info('aboutToDisappear');
    this.sceneViewModel.deInit();
  }

  build() {
    Stack() {
      WindowScene(this.sceneSession?.session.persistentId)
        .size({
          width: `${this.screenProperty.width}px`,
          height: `${this.screenProperty.height}px`,
        })
        .id(`session${this.sceneSession?.session.persistentId}`)
        .focusable(this.sceneSession && this.sceneSession.isFocusable || false)
        .hitTestBehavior(this.sceneSession?.isTouchable ? HitTestMode.Default : HitTestMode.None)
        .clip(this.sceneSession && this.sceneSession?.floatBorderRadius > 0 ? true : false)
      if (this.subSessionList && this.subSessionList.length > 0) {
        ForEach(this.subSessionList, (item: SCBSpecificSession) => {
          PadWithCarSpecificScene({
            specificSession: item,
            screenProperty: this.screenProperty,
            appZOrder: this.appZOrder
          })
        })
      }
    }
    .size({
      width: `${this.screenProperty.width}px`,
      height: `${this.screenProperty.height}px`
    })
    .translate({ x: this.sceneSession?.translateX })
    .position({ x: 0, y: 0 })
    .hitTestBehavior(HitTestMode.None)
  }
}

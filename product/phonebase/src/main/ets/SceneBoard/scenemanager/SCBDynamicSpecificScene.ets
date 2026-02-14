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
  SCBScreenProperty,
  SCBSpecificSceneSessionList,
  SCBSpecificSession,
} from '@ohos/windowscene';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { SceneConstants } from '@ohos/commonconstants';
import { SCBSpecificScene } from './SCBSpecificScene';

const TAG = 'SCBDynamicSpecificScene'
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct SCBDynamicSpecificScene {
  @Link screenProperty: SCBScreenProperty;
  @ObjectLink systemSceneList: SCBSpecificSceneSessionList;
  zIndexValue: number = 0;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear SCBDynamicSpecificSceneItemPanel zIndexValue: ${this.zIndexValue}`);
  }

  private getScenePanelTranslateOptions() : TranslateOptions {
    let option: TranslateOptions = {
      x: this.screenProperty?.getTranslateX() + 'px',
      y: this.screenProperty?.getTranslateY() + 'px'
    };
    log.showDebug('getScenePanelTranslateOptions: ' + JSON.stringify(option));
    return option;
  }

  private getScenePanelRotateOptions() : RotateOptions {
    let option: RotateOptions = {
      x: 0,
      y: 0,
      z: 1,
      angle: -this.screenProperty?.rotation,
      centerX: '50%',
      centerY: '50%'
    };
    log.showDebug('getScenePanelRotateOptions: ' + JSON.stringify(option));
    return option;
  }

  @Styles
  transformSceneStyles() {
    .id('SCBSpecificPanelTransformScene')
    .direction(Direction.Ltr)
    .position({ x: this.screenProperty.left + 'px', y: this.screenProperty.top + 'px' })
    .translate(this.getScenePanelTranslateOptions())
    .size({ width: this.screenProperty.width + 'px', height: this.screenProperty.height + 'px' })
    .rotate(this.getScenePanelRotateOptions())
    .hitTestBehavior(HitTestMode.None)
  }

  build() {
    WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
      ForEach(this.systemSceneList, (item: SCBSpecificSession) => {
        SCBSpecificScene({
          specificSession: item,
          screenProperty: $screenProperty,
          rect: item.currRect,
          parentRect: item.currRect,
          subSessionList: item.subSessionList,
        })
      }, (item: SCBSpecificSession) => item.session?.persistentId.toString())
    }
    .transformSceneStyles()
    .zIndex(this.zIndexValue)
    .visibility(this.systemSceneList.length > 0 ? Visibility.Visible : Visibility.Hidden)
  }
}
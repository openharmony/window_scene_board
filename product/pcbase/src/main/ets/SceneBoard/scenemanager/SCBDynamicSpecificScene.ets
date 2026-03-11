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
import { SceneConstants } from '@ohos/commonconstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { StyleConstants } from '@ohos/launchercommon';
import { SCBSpecificSession, SCBSpecificSceneSessionList, SCBScreenProperty, } from '@ohos/windowscene';
import { SCBSpecificScene } from './SCBSpecificScene';

const TAG = 'SCBDynamicSpecificScene';
const log = LogHelper.getLogHelper(LogDomain.WINDOW, TAG);

@Component
export struct SCBDynamicSpecificScene {
  @Link screenProperty: SCBScreenProperty;
  @ObjectLink systemSceneList: SCBSpecificSceneSessionList;
  zIndexValue: number = 0;

  build() {
    WindowScene(SceneConstants.TRANSFORM_SCENE) { // transform scene, always full screen
      ForEach(this.systemSceneList, (item: SCBSpecificSession) => {
        SCBSpecificScene({
          specificSession: item,
          screenProperty: $screenProperty,
          rect: item.currRect,
          parentRect: item.currRect,
          parentSceneSession: item.getParentSession(),
          subWindowAnchorInfo:item.subWindowAnchorInfo
        })
      }, (item: SCBSpecificSession) => item.session?.persistentId.toString())
    }
    .id('SCBSpecificPanelTransformScene')
    .direction(Direction.Ltr)
    .zIndex(this.zIndexValue)
    .size({ width: StyleConstants.PERCENTAGE_100, height: StyleConstants.PERCENTAGE_100 })
    .hitTestBehavior(HitTestMode.None)
  }
}
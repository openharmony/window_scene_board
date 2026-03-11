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
import { beforeAll, describe, expect, it } from '@ohos/hypium';
import sceneSessionManager from '@ohos.sceneSessionManager';
import { ReflectionUtils } from './ReflectionUtils';
import {
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  ScenePanelState} from '@ohos/windowscene';

let sceneInfo: SCBSceneInfo;
let sceneSession: SCBSceneSession;
let containerSession: SCBSceneContainerSession;
let sessionManager = SCBSceneSessionManager.getInstance();
let  screenProperty: SCBScreenProperty = new SCBScreenProperty();
let assertFlag: boolean = true;

let initAll = () => {
  sceneInfo = new SCBSceneInfo('testSessionManagerBundle_Bundle', 'testSessionManagerMoudle_Moudle',
    'testSessionManagerAbility_Ability');
  sceneSession = new SCBSceneSession(sceneSessionManager.requestSceneSession(sceneInfo), sceneInfo);
  containerSession = new SCBSceneContainerSession(sceneSession, screenProperty);
}


export function SCBSceneSessionManagerTest() {
  beforeAll(initAll);
  multiwindow_SCBSceneSessionManagerTest_01_func();
  multiwindow_SCBSceneSessionManagerTest_02_func();
}

function multiwindow_SCBSceneSessionManagerTest_01_func() {
  describe('multiwindow_SCBSceneSessionManagerTest_01_describe', () => {
    it('traverseMidSceneFromBottomToTop_it', 0, () => {
      let func: Function = (scbSession: SCBSceneSession): boolean => {
        if (scbSession && (scbSession.getVisibility() || scbSession.isActive)) {
          return true;
        }
        return false;
      };
      ReflectionUtils.useFunc(sessionManager, 'traverseMidSceneFromBottomToTop', containerSession, func);
      expect(assertFlag).assertTrue();
    })

    it('traverseMidSceneFromTopToBottom_it', 0, () => {
      let func = (scbSession: SCBSceneSession): boolean => {
        if (scbSession && (scbSession.getVisibility() || scbSession.isActive)) {
          return true;
        }
        return false;
      };
      ReflectionUtils.useFunc(sessionManager, 'traverseMidSceneFromTopToBottom', containerSession, func);
      expect(assertFlag).assertTrue();
    })
  })
}

function multiwindow_SCBSceneSessionManagerTest_02_func() {
  describe('multiwindow_SCBSceneSessionManagerTest_02_describe', () => {
    it('triggerScenePanelStateChange_it', 0, () => {
      sessionManager.triggerScenePanelStateChange(ScenePanelState.SPLIT);
      expect(assertFlag).assertTrue();
    })
  })
}


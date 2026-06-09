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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium'
import {
  ScbNumber,
  SCBSceneContainerSession,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty,
  SCBSessionRect
} from '@ohos/windowscene';
import { StyleConstants } from '@ohos/launchercommon';
import sceneSessionManager from '@ohos.sceneSessionManager';

import { sPcModeUtils } from
  '../../../../../main/ets/utils/SCBPcModeUtils';

let scene: SCBSceneSession;
let container: SCBSceneContainerSession;
let nullContainer: SCBSceneContainerSession;
let nullScene: SCBSceneSession;

export function SCBPcModeUtilsTest() {
  describe('SCBPcModeUtilsTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      initTestContainerAndScene();
    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    });
    getTransitionsContextTest();
  });
}

function initTestContainerAndScene() {
  let screenProperty: SCBScreenProperty = new SCBScreenProperty();
  screenProperty.screenId = 100;
  screenProperty.width = 1920;
  screenProperty.height = 1080;
  let sceneManager = SCBSceneSessionManager.getInstance();
  let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundle1', 'module1', 'ability1');
  let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
  scene = new SCBSceneSession(testSession, testSCBSceneInfo);
  scene.currRect.setRectNum(0, 0, 1600, 900);
  container = new SCBSceneContainerSession(scene, screenProperty);
}

function getTransitionsContextTest() {
  it('getTransitionsContextTest_01', Level.LEVEL0, (): void => {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let testTransitionsContext = sPcModeUtils.getTransitionsContext(testSCBSceneInfo);
    expect(testTransitionsContext[0]).assertEqual('testBundleName');
    expect(testTransitionsContext[1]).assertEqual('testAbilityName');
  });
  it('getTransitionsContextTest_02', Level.LEVEL0, (): void => {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('CommonConstants.FILE_MANAGER_BUNDLE', 'testModuleName', 'testAbilityName');
    let testTransitionsContext = sPcModeUtils.getTransitionsContext(testSCBSceneInfo);
    expect(testTransitionsContext[0]).assertEqual('CommonConstants.FILE_MANAGER_BUNDLE');
    expect(testTransitionsContext[1]).assertEqual('testAbilityName');
  });
}

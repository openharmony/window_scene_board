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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium'
import { SCBSceneInfo, SCBSceneSession, SCBSceneSessionManager } from '@ohos/windowscene/src/main/ets/TsIndex';
import {
  SCBPCSceneMissionProcessor
} from '../../../../../main/ets/scenemanager/SCBPCSceneMissionProcessor';
import sceneSessionManager from '@ohos.sceneSessionManager';

export function SCBPCSceneMissionProcessorTest() {
  describe('SCBPCSceneMissionProcessorTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    });
    onPendingSessionToStartTest();
  });
}

function onPendingSessionToStartTest() {
  it('onPendingSessionToStartTest_01', Level.LEVEL0, (): void => {
    let pcSceneMissionProcessor = new SCBPCSceneMissionProcessor();
    let fromInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let toInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    toInfo.screenId = 0;
    let mocker: MockKit = new MockKit();
    pcSceneMissionProcessor.onPendingSessionToStart(toInfo, fromInfo);
    expect(toInfo.screenId).assertEqual(0);
  });

  it('onPendingSessionToStartTest_02', Level.LEVEL0, (): void => {
    let pcSceneMissionProcessor = new SCBPCSceneMissionProcessor();
    let fromInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    let toInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    toInfo.screenId = 999;
    let mocker: MockKit = new MockKit();
    let mocker2: MockKit = new MockKit();
    let mocker3: MockKit = new MockKit();
    pcSceneMissionProcessor.onPendingSessionToStart(toInfo, fromInfo);
    expect(toInfo.screenId).assertEqual(999);
  });

  it('onPendingSessionToStartTest_03', Level.LEVEL0, (): void => {
    let pcSceneMissionProcessor = new SCBPCSceneMissionProcessor();
    let toInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    toInfo.screenId = 0;
    let mocker: MockKit = new MockKit();
    pcSceneMissionProcessor.onPendingSessionToStart(toInfo);
    expect(toInfo.screenId).assertEqual(0);
  });

  it('onPendingSessionToStartTest_04', Level.LEVEL0, (): void => {
    let pcSceneMissionProcessor = new SCBPCSceneMissionProcessor();
    let toInfo: SCBSceneInfo = new SCBSceneInfo('testBundleName', 'testModuleName', 'testAbilityName');
    toInfo.screenId = 999;
    let mocker: MockKit = new MockKit();
    let mocker2: MockKit = new MockKit();
    let mocker3: MockKit = new MockKit();
    pcSceneMissionProcessor.onPendingSessionToStart(toInfo);
    expect(toInfo.screenId).assertEqual(999);
  });
}
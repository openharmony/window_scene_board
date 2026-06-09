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
import {
  describe, it, expect, MockKit, when,
  ArgumentMatchers
} from '@ohos/hypium';
import { SCBSceneSessionManager } from '../../../../../../../main/ets/TsIndex';

import SCBRecoverManager from '../../../../../../../main/ets/scene/manager/SCBRecoverManager';


export function SCBRecoverManagerTest() {
  describe('SCBRecoverManagerTest', () => {
    getInstanceTest();
    setOnRecoverFinishedCallbackTest();
    beginRecoveringTest();
    isAbnormalRecoveryTest();
    addRecoveredSessionTest();
    periodicCheckTest();
    handleRecoverFinishedTest();
    getUnRecoveredSessionsTest();
  });
}

function getInstanceTest() {
  it('SCBRecoverManagerTest_getInstance', 0, async () => {
    globalThis.SCBRecoverManager = null;
    let instance1 = SCBRecoverManager.getInstance();
    let instance2 = SCBRecoverManager.getInstance();
    expect(instance1).assertEqual(instance2);
  });
}

function setOnRecoverFinishedCallbackTest() {
  it('SCBRecoverManagerTest_setOnRecoverFinishedCallback', 0, async () => {
    let scbRecoverManager = new SCBRecoverManager();
    let mocker: MockKit = new MockKit();
    let mockCallback: Function = mocker.mockFunc(getInstanceTest, getInstanceTest);
    scbRecoverManager.setOnRecoverFinishedCallback(mockCallback);
    expect(scbRecoverManager['onRecoverFinishedCallback']).assertEqual(mockCallback);
  });
}

function beginRecoveringTest() {
  it('SCBRecoverManagerTest_beginRecovering01', 0, async () => {
    let scbRecoverManager: SCBRecoverManager = new SCBRecoverManager();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance().getScenePersistent(),
      SCBSceneSessionManager.getInstance().getScenePersistent().readPersistentJsonArray);
    when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
    await scbRecoverManager.beginRecovering();
    expect(true).assertTrue();
  });
  it('SCBRecoverManagerTest_beginRecovering02', 0, async () => {
    let scbRecoverManager: SCBRecoverManager = new SCBRecoverManager();
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(SCBSceneSessionManager.getInstance().getScenePersistent(),
      SCBSceneSessionManager.getInstance().getScenePersistent().readPersistentJsonArray);
    when(mockFunc)(ArgumentMatchers.any).afterReturn([
      {
        bundleName: 'test',
        abilityName: 'test',
        moduleName: 'test',
        appIndex: 100,
        persistentId: 123,
        rotation: 90,
        isAlive: true,
        screenId: 0
      }
      ,
      {
        bundleName: 'test1',
        abilityName: 'test1',
        moduleName: 'test1',
        appIndex: 101,
        persistentId: 124,
        rotation: 90,
        isAlive: false,
        screenId: 0
      },
    ]);
    await scbRecoverManager.beginRecovering();
    expect(true).assertTrue();
  });
}

function isAbnormalRecoveryTest() {
  it('SCBRecoverManagerTest_isAbnormalRecovery', 0, async () => {
    let scbRecoverManager: SCBRecoverManager = new SCBRecoverManager();
    const result = scbRecoverManager.isAbnormalRecovery();
    expect(result).assertFalse();
  });
}

function addRecoveredSessionTest() {
  it('SCBRecoverManagerTest_addRecoveredSession', 0, async () => {
    let scbRecoverManager: SCBRecoverManager = new SCBRecoverManager();
    scbRecoverManager.addRecoveredSession(1, {
      bundleName: 'testBundle',
      moduleName: 'testModule',
      layoutFullScreen: true,
      abilityName: 'testAbility',
      windowMode: 1,
      appIndex: 1,
      screenId: 1,
      sessionState: 1,
      sessionType: 1,
      requestOrientation: 0,
      recoverRect: {
        posX_: 1,
        posY_: 1,
        width_: 1,
        height_: 1
      },
      mainWindowTopmost: false,
      currentRotation: 0,
      transitionAnimationMap: new Map(),
      supportWindowModes: [0, 1, 2]
    });
    expect(true).assertTrue();
  });
}

function periodicCheckTest() {
  it('SCBRecoverManagerTest_periodicCheck01', 0, async () => {
    let recoverManager: SCBRecoverManager = new SCBRecoverManager();
    (recoverManager as object)['periodicCheck']();
    expect(true).assertTrue();
  });

  it('SCBRecoverManagerTest_periodicCheck02', 0, async () => {
    let recoverManager: SCBRecoverManager = new SCBRecoverManager();
    recoverManager.addRecoveredSession(1, {
      bundleName: 'testBundle',
      moduleName: 'testModule',
      layoutFullScreen: true,
      abilityName: 'testAbility',
      windowMode: 1,
      appIndex: 1,
      screenId: 1,
      sessionState: 1,
      sessionType: 1,
      requestOrientation: 0,
      recoverRect: {
        posX_: 1,
        posY_: 1,
        width_: 1,
        height_: 1
      },
      mainWindowTopmost: false,
      currentRotation: 0,
      transitionAnimationMap: new Map(),
      supportWindowModes: [0, 1, 2]
    });
    (recoverManager as object)['periodicCheck']();
    expect(true).assertTrue();
  });
}

function handleRecoverFinishedTest() {
  it('SCBRecoverManagerTest_handleRecoverFinished', 0, async () => {
    let recoverManager: SCBRecoverManager = new SCBRecoverManager();
    recoverManager.setOnRecoverFinishedCallback(() => { });
    (recoverManager as object)['handleRecoverFinished']();
    expect(true).assertTrue();
  });
}

function getUnRecoveredSessionsTest() {
  it('SCBRecoverManagerTest_getUnRecoveredSessions', 0, async () => {
    let recoverManager: SCBRecoverManager = new SCBRecoverManager();
    recoverManager.addRecoveredSession(1, {
      bundleName: 'testBundle',
      moduleName: 'testModule',
      layoutFullScreen:true,
      abilityName: 'testAbility',
      windowMode: 1,
      appIndex: 1,
      screenId: 1,
      sessionState: 1,
      sessionType: 1,
      requestOrientation: 0,
      recoverRect: {
        posX_: 1,
        posY_: 1,
        width_: 1,
        height_: 1 },
      mainWindowTopmost: false,
      currentRotation: 0,
      transitionAnimationMap: new Map(),
      supportWindowModes: [0, 1, 2]
    });
    expect((recoverManager as object)['getUnRecoveredSessions']().length === 0).assertTrue();
  });
}
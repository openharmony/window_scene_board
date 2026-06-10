/**
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

import { ArgumentMatchers, beforeAll, describe, it, Level, MockKit, when } from "@ohos/hypium";
import {
  SCBSceneContainerSession,
  SCBSceneContainerSessionArray,
  SCBSceneInfo,
  SCBSceneSession,
  SCBSceneSessionManager,
  SCBScreenProperty
} from "@ohos/windowscene";
import { SCBFreeWindowsAdaptor } from "../../../../../../main/ets/SceneBoard/scenemanager/pcmode/SCBFreeWindowsAdaptor";

let containerList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
let notShowContainerList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
let sceneManager: SCBSceneSessionManager;
let screenProperty: SCBScreenProperty;
let adaptorInstance: SCBFreeWindowsAdaptor;

export function SCBFreeWindowsAdaptorTest() {
  describe('SCBFreeformSceneUtilsTest', () => {
    beforeAll(() => {
      sceneManager = SCBSceneSessionManager.getInstance();
      screenProperty = new SCBScreenProperty();
      adaptorInstance = SCBFreeWindowsAdaptor.getInstance();
      initTestContainerList();
    });
    quitFreeWindowsModeOneShotTest();
    handleScreenLockActiveSessionListTest();
  })
}

function initTestContainerList() {
  {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundle1', 'module1', 'ability1');
    let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
    let scene = new SCBSceneSession(testSession, testSCBSceneInfo);
    let container = new SCBSceneContainerSession(scene, screenProperty);
    containerList.push(container);
  }
  {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('bundle2', 'module2', 'ability2');
    let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
    let scene = new SCBSceneSession(testSession, testSCBSceneInfo);
    let container = new SCBSceneContainerSession(scene, screenProperty);
    containerList.push(container);
  }
  {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('notShowBundle1', 'notShowModule1', 'notShowAbility1');
    let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
    let scene = new SCBSceneSession(testSession, testSCBSceneInfo);
    let container = new SCBSceneContainerSession(scene, screenProperty);
    notShowContainerList.push(container);
  }
  {
    let testSCBSceneInfo: SCBSceneInfo = new SCBSceneInfo('notShowBundle2', 'notShowModule2', 'notShowAbility2');
    let testSession = sceneManager.requestSceneSession(testSCBSceneInfo);
    let scene = new SCBSceneSession(testSession, testSCBSceneInfo);
    let container = new SCBSceneContainerSession(scene, screenProperty);
    notShowContainerList.push(container);
  }
}

function quitFreeWindowsModeOneShotTest() {
  it('quitFreeWindowsModeOneShotTest_01', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let callbackMap: Map<number, Function> = Reflect.get(sceneManager, 'getContainerSessionListCallback');
    let oldCallback: Function | undefined = undefined;
    if (callbackMap.has(0)) {
      oldCallback = callbackMap.get(0);
    }
    callbackMap.set(0, (): SCBSceneContainerSessionArray => {
      return containerList;
    });
    let notShowCallbackMap: Map<number, Function> = Reflect.get(sceneManager, 'getContainerSessionListNotShowRecentCallback');
    let oldNotShowCallback: Function | undefined = undefined;
    if (notShowCallbackMap.has(0)) {
      oldNotShowCallback = notShowCallbackMap.get(0);
    }
    notShowCallbackMap.set(0, (): SCBSceneContainerSessionArray => {
      return notShowContainerList;
    });
    let oneShotHandleAnimate: Function = Reflect.get(adaptorInstance, 'oneShotHandleAnimate');
    let mockAnimate =  mocker.mockFunc(adaptorInstance, oneShotHandleAnimate);
    when(mockAnimate)(ArgumentMatchers.any).afterReturn(undefined);
    let oneShotHandleWindowMode: Function = Reflect.get(adaptorInstance, 'oneShotHandleWindowMode');
    let mockHandleWindowMode = mocker.mockFunc(adaptorInstance, oneShotHandleWindowMode);
    when(mockHandleWindowMode)(ArgumentMatchers.any).afterReturn(undefined);
    adaptorInstance.quitFreeWindowsModeOneShot();
    mocker.verify('oneShotHandleAnimate',[ArgumentMatchers.any]).times(2);
    mocker.verify('oneShotHandleWindowMode',[ArgumentMatchers.any]).times(4);
    if (oldCallback) {
      callbackMap.set(0, oldCallback);
    } else {
      callbackMap.delete(0);
    }
    if (oldNotShowCallback) {
      notShowCallbackMap.set(0, oldNotShowCallback);
    } else {
      notShowCallbackMap.delete(0);
    }
    mocker.clear(adaptorInstance);
  });
}

function handleScreenLockActiveSessionListTest() {
  it('handleScreenLockActiveSessionListTest_01', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let isScreenLocked = mocker.mockFunc(sceneManager, sceneManager.isScreenLocked);
    when(isScreenLocked)(ArgumentMatchers.any).afterReturn(false);
    mocker.mockFunc(sceneManager, sceneManager.removeActiveSessionList);
    adaptorInstance.handleScreenLockActiveSessionList(containerList);
    mocker.verify('removeActiveSessionList',[]).never();
    mocker.clear(sceneManager);
  });
  it('handleScreenLockActiveSessionListTest_02', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let isScreenLocked = mocker.mockFunc(sceneManager, sceneManager.isScreenLocked);
    when(isScreenLocked)(ArgumentMatchers.any).afterReturn(true);
    let removeActiveSessionList = mocker.mockFunc(sceneManager, sceneManager.removeActiveSessionList);
    when(removeActiveSessionList)(ArgumentMatchers.any).afterReturn(undefined);
    adaptorInstance.handleScreenLockActiveSessionList(containerList);
    mocker.verify('removeActiveSessionList',[ArgumentMatchers.any]).once();
    mocker.clear(sceneManager);
  });
  it('handleScreenLockActiveSessionListTest_03', Level.LEVEL0, () => {
    let mocker: MockKit = new MockKit();
    let isScreenLocked = mocker.mockFunc(sceneManager, sceneManager.isScreenLocked);
    when(isScreenLocked)(ArgumentMatchers.any).afterReturn(true);
    let removeActiveSessionList = mocker.mockFunc(sceneManager, sceneManager.removeActiveSessionList);
    when(removeActiveSessionList)(ArgumentMatchers.any).afterReturn(undefined);
    let emptyList: SCBSceneContainerSessionArray = new SCBSceneContainerSessionArray();
    adaptorInstance.handleScreenLockActiveSessionList(emptyList);
    mocker.verify('removeActiveSessionList',[]).never();
    mocker.clear(sceneManager);
  });
}
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

import { ArgumentMatchers, beforeAll, beforeEach, describe, expect, it, MockKit, when } from '@ohos/hypium'
import {
  MultiWindowMode,
  SCBSceneSessionManager,
  SCBSwitchMultiWindowManager,
  SwitchMultiWindowModeCallback
} from '../../../../../../../main/ets/TsIndex';

let testSwitchMultiWindowModeCallback: SwitchMultiWindowModeCallback;
let sceneManager: SCBSceneSessionManager;
let manager: SCBSwitchMultiWindowManager;
let callbacks: Array<SwitchMultiWindowModeCallback>;

export function SCBSwitchMultiWindowManagerTest() {
  describe('SCBSwitchMultiWindowManagerTest', () => {
    beforeAll(() => {
      sceneManager = SCBSceneSessionManager.getInstance();
      testSwitchMultiWindowModeCallback = {
        onEnterMode: (mode: MultiWindowMode) => {},
        onQuitMode: (mode: MultiWindowMode) => {}
      };
    })

    beforeEach(() => {
      manager = new SCBSwitchMultiWindowManager();
      callbacks = Reflect.get(manager, 'switchMultiWindowModeCallbacks');
    })

    registerSwitchMultiWindowModeCallbackTest();
    unregisterSwitchMultiWindowModeCallbackTest();
    togglePcModeTest();
    saveCacheDensityTest();
    getCacheDensityTest();
    getDefaultDensityDpiTest();
    updatePersistentDpiTest();
    resetPcModeStateIfNeedTest();
  });
}


function registerSwitchMultiWindowModeCallbackTest() {
  it('registerSwitchMultiWindowModeCallbackTest_01', 0, () => {
    let len1: number = callbacks.length;
    manager.registerSwitchMultiWindowModeCallback(testSwitchMultiWindowModeCallback);
    let len2: number = callbacks.length;
    expect(len2).assertEqual(len1 + 1);
  });

  it('registerSwitchMultiWindowModeCallbackTest_02', 0, () => {
    callbacks.push(testSwitchMultiWindowModeCallback);
    let len1: number = callbacks.length;
    manager.registerSwitchMultiWindowModeCallback(testSwitchMultiWindowModeCallback);
    let len2: number = callbacks.length;
    expect(len2).assertEqual(len1);
  });

  it('registerSwitchMultiWindowModeCallbackTest_03', 0, () => {
    let len1: number = callbacks.length;
    manager.registerSwitchMultiWindowModeCallback(null);
    let len2: number = callbacks.length;
    expect(len2).assertEqual(len1);
  });
}

function unregisterSwitchMultiWindowModeCallbackTest() {
  it('unregisterSwitchMultiWindowModeCallbackTest_01', 0, () => {
    let len1: number = callbacks.length;
    manager.unregisterSwitchMultiWindowModeCallback(testSwitchMultiWindowModeCallback);
    let len2: number = callbacks.length;
    expect(len2).assertEqual(len1);
  });

  it('unregisterSwitchMultiWindowModeCallbackTest_02', 0, () => {
    callbacks.push(testSwitchMultiWindowModeCallback);
    let len1: number = callbacks.length;
    manager.unregisterSwitchMultiWindowModeCallback(testSwitchMultiWindowModeCallback);
    let len2: number = callbacks.length;
    expect(len2).assertEqual(len1 - 1);
  });

  it('unregisterSwitchMultiWindowModeCallbackTest_03', 0, () => {
    let len1: number = callbacks.length;
    manager.unregisterSwitchMultiWindowModeCallback(null);
    let len2: number = callbacks.length;
    expect(len2).assertEqual(len1);
  });
}

function togglePcModeTest() {
  it('togglePcModeTest_01', 0, () => {
    let mocker: MockKit = new MockKit();
    let funIsSupportPcMode = mocker.mockFunc(sceneManager, sceneManager.isSupportPcMode);
    when(funIsSupportPcMode)().afterReturn(false);
    manager.togglePcMode(true);
    let multiWindowMode: MultiWindowMode = Reflect.get(manager, 'multiWindowMode');
    expect(multiWindowMode).assertEqual(MultiWindowMode.FULL_SCENE);
    mocker.clear(sceneManager);
  });

  it('togglePcModeTest_02', 0, () => {
    let mocker: MockKit = new MockKit();
    let funIsSupportPcMode = mocker.mockFunc(sceneManager, sceneManager.isSupportPcMode);
    when(funIsSupportPcMode)().afterReturn(true);
    manager.togglePcMode(true);
    let multiWindowMode: MultiWindowMode = Reflect.get(manager, 'multiWindowMode');
    expect(multiWindowMode).assertEqual(MultiWindowMode.FREEFORM_SCENE);
    mocker.clear(sceneManager);
  });

  it('togglePcModeTest_03', 0, () => {
    let mocker: MockKit = new MockKit();
    let funIsSupportPcMode = mocker.mockFunc(sceneManager, sceneManager.isSupportPcMode);
    when(funIsSupportPcMode)().afterReturn(true);
    manager.togglePcMode(false);
    let multiWindowMode: MultiWindowMode = Reflect.get(manager, 'multiWindowMode');
    expect(multiWindowMode).assertEqual(MultiWindowMode.FULL_SCENE);
    mocker.clear(sceneManager);
  });

  it('togglePcModeTest_04', 0, () => {
    let mocker: MockKit = new MockKit();
    let funIsSupportPcMode = mocker.mockFunc(sceneManager, sceneManager.isSupportPcMode);
    when(funIsSupportPcMode)().afterReturn(true);
    Reflect.set(sceneManager, 'multiWindowMode', MultiWindowMode.FREEFORM_SCENE);
    manager.togglePcMode(false);
    let multiWindowMode: MultiWindowMode = Reflect.get(manager, 'multiWindowMode');
    expect(multiWindowMode).assertEqual(MultiWindowMode.FULL_SCENE);
    mocker.clear(sceneManager);
  });
}

function saveCacheDensityTest() {
  it('saveCacheDensityTest_01', 0, () => {
    manager.saveCacheDensity(20);
    let cacheDensity: number = Reflect.get(manager, 'cacheDensity');
    expect(cacheDensity).assertEqual(20);
  });
  it('saveCacheDensityTest_02', 0, () => {
    Reflect.set(manager, 'cacheDensity', 20);
    manager.saveCacheDensity(20);
    let cacheDensity: number = Reflect.get(manager, 'cacheDensity');
    expect(cacheDensity).assertEqual(20);
  });
}

function getCacheDensityTest() {
  it('getCacheDensityTest', 0, () => {
    Reflect.set(manager, 'cacheDensity', 20);
    let cacheDensity = manager.getCacheDensity();
    expect(cacheDensity).assertEqual(20);
  });
}

function getDefaultDensityDpiTest() {
  it('getDefaultDensityDpiTest_01', 0, () => {
    Reflect.set(manager, 'defaultDensityDpi', 20);
    let defaultDensityDpi = manager.getDefaultDensityDpi();
    expect(defaultDensityDpi).assertEqual(20);
  });

  it('getDefaultDensityDpiTest_02', 0, () => {
    Reflect.set(manager, 'defaultDensityDpi', -1);
    Reflect.set(manager, 'cacheDensity', 20);
    let defaultDensityDpi = manager.getDefaultDensityDpi();
    expect(defaultDensityDpi !== -1).assertTrue();
  });
}

function updatePersistentDpiTest() {
  it('updatePersistentDpiTest_01', 0, () => {
    let mocker: MockKit = new MockKit();
    Reflect.set(manager, 'defaultDensityDpi', -1);
    Reflect.set(manager, 'cacheDensity', 20);
    let isPcMode: Function = mocker.mockFunc(sceneManager, sceneManager.isPcMode);
    when(isPcMode)(ArgumentMatchers.any).afterReturn(true);
    manager.updatePersistentDpi(30);
    let pcModeDensity = manager.getCacheDensity();
    expect(pcModeDensity !== -1).assertTrue();

    when(isPcMode)(ArgumentMatchers.any).afterReturn(false);
    manager.updatePersistentDpi(50);
    let padModeDensity = manager.getCacheDensity();
    expect(padModeDensity !== -1).assertTrue();
    mocker.clear(sceneManager);
  });
}

function resetPcModeStateIfNeedTest() {
  it('resetPcModeStateIfNeedTest_01', 0, () => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(manager, 'getWinPcModeSwitchStatus');
    let mockerFunc = mocker.mockFunc(manager, func);
    when(mockerFunc)(ArgumentMatchers.any).afterReturn(false);
    manager.resetPcModeStateIfNeed();
    mocker.verify('setWinPcModeSwitchStatusSync', [false]).never();
    mocker.clear(manager);
  });

  it('resetPcModeStateIfNeedTest_02', 0, () => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(manager, 'getWinPcModeSwitchStatus');
    let mockerFunc = mocker.mockFunc(manager, func);
    when(mockerFunc)(ArgumentMatchers.any).afterReturn(true);
    let setFunc: Function = Reflect.get(manager, 'setWinPcModeSwitchStatusSync');
    mocker.mockFunc(manager, setFunc);
    manager.resetPcModeStateIfNeed();
    mocker.verify('setWinPcModeSwitchStatusSync', [false]).once();
    mocker.clear(manager);
  });
}
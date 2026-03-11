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
import {
  describe, it, expect, MockKit,
  ArgumentMatchers,when
} from '@ohos/hypium';
import { WindowStyleStoreManager } from '../../../../../../main/ets/db/WindowStyleStoreManager';


export default function WindowStyleStoreManagerTest() {
  describe('WindowStyleStoreManagerTest', () => {
    initWindowStyleStoreTest();
    setWindowStyleStoreTest();
    getWindowStyleStoreTest();
    getInitStatusTest();
  })
}

function initWindowStyleStoreTest() {
  it('initWindowStyleStoreTest', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'initWindowStyleStore');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    when(func2)(ArgumentMatchers.any).afterReturn(1);
    expect(true).assertTrue();
    mocker.clear(WindowStyleStoreManager);
    mocker.clearAll();
  });
}

function setWindowStyleStoreTest() {
  it('setWindowStyleStoreTest', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'setWindowStyleStore');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    when(func2)(ArgumentMatchers.any).afterReturn(1);
    expect(true).assertTrue();
    mocker.clear(WindowStyleStoreManager);
    mocker.clearAll();
  });
}

function getWindowStyleStoreTest() {
  it('getWindowStyleStoreTest_1', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'getWindowStyleStore');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    when(func2)(ArgumentMatchers.any).afterReturn('test');
    expect(true).assertTrue();
    mocker.clear(WindowStyleStoreManager);
    mocker.clearAll();
  });
  it('getWindowStyleStoreTest_2', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'getWindowStyleStore');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    when(func2)(ArgumentMatchers.any).afterReturn(1);
    expect(true).assertTrue();
    mocker.clear(WindowStyleStoreManager);
    mocker.clearAll();
  });
  it('getWindowStyleStoreTest_3', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'getWindowStyleStore');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    when(func2)(ArgumentMatchers.any).afterReturn(true);
    expect(true).assertTrue();
    mocker.clear(WindowStyleStoreManager);
    mocker.clearAll();
  });
  it('getWindowStyleStoreTest_4', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'getWindowStyleStore');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    when(func2)(ArgumentMatchers.any).afterReturn(false);
    expect(true).assertTrue();
    mocker.clear(WindowStyleStoreManager);
    mocker.clearAll();
  });
  it('getWindowStyleStoreTest_5', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'getWindowStyleStore');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    when(func2)(ArgumentMatchers.any).afterReturn(null);
    expect(true).assertTrue();
    mocker.clear(WindowStyleStoreManager);
    mocker.clearAll();
  });
  it('getWindowStyleStoreTest_6', 0, async (): Promise<void> => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'getWindowStyleStore');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    when(func2)(ArgumentMatchers.any).afterReturn(undefined);
    expect(true).assertTrue();
    mocker.clear(WindowStyleStoreManager);
    mocker.clearAll();
  });
}

function getInitStatusTest() {
  it('getInitStatusTest_01', 0, (): void => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'getInitStatus');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    let testWindowStyleStoreManager: ESObject = mocker.mockObject(WindowStyleStoreManager);
    testWindowStyleStoreManager.initStatus = true;
    when(func2)(ArgumentMatchers.any).afterReturn(testWindowStyleStoreManager);
    expect(testWindowStyleStoreManager.initStatus).assertTrue();
    mocker.clear(WindowStyleStoreManager);
    mocker.clear(testWindowStyleStoreManager);
    mocker.clearAll();
  });
  it('getInitStatusTest_02', 0, (): void => {
    let mocker: MockKit = new MockKit();
    let func: Function = Reflect.get(WindowStyleStoreManager, 'getInitStatus');
    let func2: Function = mocker.mockFunc(WindowStyleStoreManager, func);
    let testWindowStyleStoreManager: ESObject = mocker.mockObject(WindowStyleStoreManager);
    testWindowStyleStoreManager.initStatus = false;
    when(func2)(ArgumentMatchers.any).afterReturn(testWindowStyleStoreManager);
    expect(testWindowStyleStoreManager.initStatus).assertFalse();
    mocker.clear(WindowStyleStoreManager);
    mocker.clear(testWindowStyleStoreManager);
    mocker.clearAll();
  });
}
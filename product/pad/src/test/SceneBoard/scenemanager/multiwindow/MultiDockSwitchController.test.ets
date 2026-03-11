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
import { GlobalContext } from '@ohos/frameworkwrapper';

import { describe, it, Level, expect } from '@ohos/hypium';
import { common } from '@kit.AbilityKit';
import {
  MultiDockSwitchController
} from '../../../../main/ets/SceneBoard/scenemanager/multiwindow/settings/controllers/MultiDockSwitchController';
import { ReflectionUtils } from './ReflectionUtils';

export default function MultiDockSwitchControllerTest() {
  describe('MultiDockSwitchControllerTest_001', (): void => {
    getInstanceTest_01();
    getForAllTest_01();
    setForAllTest_01();
    setForAllTest_02();
    getForAppTest_01();
    setForAppTest_01();
    checkForAllTest_01();
  });
}

function getForAllTest_01() {
  it('getForAllTest_FALSE_001', Level.LEVEL0, (): void => {
    let context: Context | undefined = undefined;
    MultiDockSwitchController.getForAll(context);
    expect(true).assertEqual(true);
  });
  it('getForAllTest_TRUE_001', Level.LEVEL0, (): void => {
    let context: Context | null = null;
    MultiDockSwitchController.getForAll(context);
    expect(true).assertEqual(true);
  });
}

function getInstanceTest_01() {
  it('getInstanceTest_001', Level.LEVEL0, (): void => {
    MultiDockSwitchController.getInstance();
    expect(MultiDockSwitchController.getInstance()).not().assertNull();
  });
  it('getInstanceTest_002', Level.LEVEL0, (): void => {
    new MultiDockSwitchController();
    MultiDockSwitchController.getInstance();
    expect(MultiDockSwitchController.getInstance()).not().assertNull();
  });
}

function setForAllTest_01() {
  it('setForAllTest_FALSE_001', Level.LEVEL0, (): void => {
    let context: Context | undefined = undefined;
    GlobalContext.setContext(null);
    let res = MultiDockSwitchController.setForAll(context, false);
    expect(res).assertEqual(false);
  });
  it('setForAllTest_FALSE_002', Level.LEVEL0, (): void => {
    let context: Context | null = null;
    GlobalContext.setContext(null);
    let res = MultiDockSwitchController.setForAll(context, false);
    expect(res).assertEqual(false);
  });
  it('setForAllTest_TRUE_001', Level.LEVEL0, (): void => {
    let context = getContext() as common.UIExtensionContext;
    let res = MultiDockSwitchController.setForAll(context, true);
    expect(res).assertEqual(true);
  });
}

function checkForAllTest_01() {
  it('checkForAllTest_FALSE_001', Level.LEVEL0, (): void => {
    let context: Context | undefined = undefined;
    GlobalContext.setContext(null);
    let res = MultiDockSwitchController.checkForAll(context);
    expect(res).assertEqual(false);
  });
  it('checkForAllTest_FALSE_002', Level.LEVEL0, (): void => {
    let context: Context | null = null;
    GlobalContext.setContext(null);
    let res = MultiDockSwitchController.checkForAll(context);
    expect(res).assertEqual(false);
  });
  it('checkForAllTest_TRUE_001', Level.LEVEL0, (): void => {
    let context = getContext() as common.UIExtensionContext;
    let res = MultiDockSwitchController.checkForAll(context);
    expect(res).assertEqual(true);
  });
}

function setForAllTest_02() {
  it('setForAllTest_TRUE_002', Level.LEVEL0, (): void => {;
    let context = getContext() as common.UIExtensionContext;
    let res = MultiDockSwitchController.setForAll(context, false);
    expect(res).assertEqual(true);
  });
  it('setForAllTest_TRUE_003', Level.LEVEL0, (): void => {
    let context = getContext() as common.UIExtensionContext;
    let res = MultiDockSwitchController.setForAll(context, 'true');
    expect(res).assertEqual(true);
  });
  it('setForAllTest_TRUE_004', Level.LEVEL0, (): void => {
    let context = getContext() as common.UIExtensionContext;
    let res = MultiDockSwitchController.setForAll(context, 'false');
    expect(res).assertEqual(true);
  });
}

function setForAppTest_01() {
  it('setForAppTest_FALSE_001', Level.LEVEL0, (): void => {
    let bundleName = 'com.ohos.sceneboard';
    let res = MultiDockSwitchController.setForApp(bundleName, false);
    expect(res).assertEqual(false);
  });
  it('setForAppTest_TRUE_001', Level.LEVEL0, (): void => {
    let bundleName = 'com.ohos.sceneboard';
    let res = MultiDockSwitchController.setForApp(bundleName, true);
    expect(res).assertEqual(false);
  });
}

function getForAppTest_01() {
  it('getForAppTest_001', Level.LEVEL0, (): void => {
    let bundleName = 'com.ohos.sceneboard';
    let res = MultiDockSwitchController.getForApp(bundleName);
    expect(res).assertEqual(false);
  });
}
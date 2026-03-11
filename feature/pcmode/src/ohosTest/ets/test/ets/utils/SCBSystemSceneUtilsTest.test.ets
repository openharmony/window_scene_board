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

import { ArgumentMatchers, beforeAll, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { ResUtils, SCBSceneSessionManager, SCBSessionRect } from '@ohos/windowscene';
import { SCBSystemSceneUtils } from '../../../../../main/ets/utils/SCBSystemSceneUtils';
import { UIContext } from '@kit.ArkUI';
import { LayoutViewModel } from '@ohos/launchercommon';

let systemSceneUtils: SCBSystemSceneUtils;
let sceneManager: SCBSceneSessionManager;
let layoutViewModel: LayoutViewModel;

class TestSystemSceneSession {
  currRect: SCBSessionRect = new SCBSessionRect(0, 0, 0, 0);
};
let testSystemBar: TestSystemSceneSession;
let uiContext: UIContext;

export function SCBSystemSceneUtilsTest() {
  describe('SCBSystemSceneUtilsTest', () => {
    beforeAll(() => {
      systemSceneUtils = SCBSystemSceneUtils.getInstance();
      sceneManager = SCBSceneSessionManager.getInstance();
      layoutViewModel = LayoutViewModel.getInstance();
      testSystemBar = new TestSystemSceneSession();
      testSystemBar.currRect.height.setNumber(200);
      uiContext = new UIContext();
    });
    getStatusBarHeightPxTest();
    getStatusBarHeightVpTest();
    getDockHeightPxTest();
    getDockHeightVPTest();
  });
}

function getStatusBarHeightPxTest() {
  it('getStatusBarHeightPxTest_01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let fun = mocker.mockFunc(sceneManager, sceneManager.getSystemSceneSessionWithSystemType);
    when(fun)(ArgumentMatchers.any).afterReturn(undefined);
    let statusBarHeightPx = systemSceneUtils.getStatusBarHeightPx();
    expect(statusBarHeightPx).assertEqual(0);
    mocker.clear(sceneManager);
  });
  it('getStatusBarHeightPxTest_02', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let fun = mocker.mockFunc(sceneManager, sceneManager.getSystemSceneSessionWithSystemType);
    when(fun)(ArgumentMatchers.any).afterReturn(testSystemBar);
    let statusBarHeightPx = systemSceneUtils.getStatusBarHeightPx();
    expect(statusBarHeightPx).assertEqual(200);
    mocker.clear(sceneManager);
  });
  it('getStatusBarHeightPxTest_03', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let expectResult = Math.floor(vp2px(ResUtils.getNumber($r('app.float.status_bar_phone_height'))));
    let statusBarHeightPx = systemSceneUtils.getStatusBarHeightPx();
    expect(statusBarHeightPx).assertEqual(expectResult);
    mocker.clear(sceneManager);
  });
}

function getStatusBarHeightVpTest() {
  it('getStatusBarHeightVpTest_01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let fun = mocker.mockFunc(sceneManager, sceneManager.getSystemSceneSessionWithSystemType);
    when(fun)(ArgumentMatchers.any).afterReturn(undefined);
    let statusBarHeightPx = systemSceneUtils.getStatusBarHeightVP(uiContext);
    expect(statusBarHeightPx).assertEqual(0);
    mocker.clear(sceneManager);
  });
  it('getStatusBarHeightVpTest_02', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let fun = mocker.mockFunc(sceneManager, sceneManager.getSystemSceneSessionWithSystemType);
    when(fun)(ArgumentMatchers.any).afterReturn(testSystemBar);
    let statusBarHeightPx = systemSceneUtils.getStatusBarHeightVP(uiContext);
    let testHeight = uiContext.px2vp(200);
    expect(statusBarHeightPx).assertEqual(testHeight);
    mocker.clear(sceneManager);
  });
  it('getStatusBarHeightVpTest_03', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let expectResult = ResUtils.getNumber($r('app.float.status_bar_phone_height'));
    let statusBarHeightPx = systemSceneUtils.getStatusBarHeightVP(uiContext);
    expect(statusBarHeightPx).assertEqual(expectResult);
    mocker.clear(sceneManager);
  });
}

function getDockHeightPxTest() {
  it('getDockHeightPxTest_01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockDockHeight = mocker.mockFunc(layoutViewModel, layoutViewModel.getDockHeight);
    when(mockDockHeight)(ArgumentMatchers.any).afterReturn(100);
    let dockHeight = systemSceneUtils.getDockHeightPx(0);
    let testDockHeight = vp2px(100);
    expect(dockHeight).assertEqual(testDockHeight);
    mocker.clear(sceneManager);
    mocker.clear(layoutViewModel);
  });
  it('getDockHeightPxTest_02', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockDockHeight = mocker.mockFunc(layoutViewModel, layoutViewModel.getDockHeight);
    when(mockDockHeight)(ArgumentMatchers.any).afterReturn(100);
    let dockHeight = systemSceneUtils.getDockHeightPx(0, uiContext);
    let testDockHeight = uiContext.vp2px(100);
    expect(dockHeight).assertEqual(testDockHeight);
    mocker.clear(sceneManager);
    mocker.clear(layoutViewModel);
  });
  it('getDockHeightPxTest_03', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let fun = mocker.mockFunc(sceneManager, sceneManager.getSystemSceneSessionWithSystemBarType);
    when(fun)(ArgumentMatchers.any).afterReturn(undefined);
    let dockHeight = systemSceneUtils.getDockHeightPx(0);
    expect(dockHeight).assertEqual(0);
    mocker.clear(sceneManager);
  });
  it('getDockHeightPxTest_04', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let fun = mocker.mockFunc(sceneManager, sceneManager.getSystemSceneSessionWithSystemBarType);
    when(fun)(ArgumentMatchers.any).afterReturn(testSystemBar);
    let dockHeight = systemSceneUtils.getDockHeightPx(0);
    expect(dockHeight).assertEqual(200);
    mocker.clear(sceneManager);
  });
}

function getDockHeightVPTest() {
  it('getDockHeightVPTest_01', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let mockDockHeight = mocker.mockFunc(layoutViewModel, layoutViewModel.getDockHeight);
    when(mockDockHeight)(ArgumentMatchers.any).afterReturn(100);
    let dockHeight = systemSceneUtils.getDockHeightVP(uiContext);
    expect(dockHeight).assertEqual(100);
    mocker.clear(sceneManager);
    mocker.clear(layoutViewModel);
  });
  it('getDockHeightVPTest_02', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let fun = mocker.mockFunc(sceneManager, sceneManager.getSystemSceneSessionWithSystemBarType);
    when(fun)(ArgumentMatchers.any).afterReturn(undefined);
    let dockHeight = systemSceneUtils.getDockHeightVP(uiContext);
    expect(dockHeight).assertEqual(0);
    mocker.clear(sceneManager);
  });
  it('getDockHeightVPTest_03', Level.LEVEL0, (): void => {
    let mocker: MockKit = new MockKit();
    let fun = mocker.mockFunc(sceneManager, sceneManager.getSystemSceneSessionWithSystemBarType);
    when(fun)(ArgumentMatchers.any).afterReturn(testSystemBar);
    let dockHeight = systemSceneUtils.getDockHeightVP(uiContext);
    let testHeight = uiContext.px2vp(200);
    expect(dockHeight).assertEqual(testHeight);
    mocker.clear(sceneManager);
  });
}
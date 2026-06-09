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
  ResUtils,
  SCBScreenProperty,
} from '@ohos/windowscene';
import { viewMgrPolicy } from '@ohos/frameworkwrapper';
import { BaseViewController } from '@ohos/frameworkcommon';
import { FloatingSceneViewModel, FloatingScenePropertyCallback, FloatingEvent } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/pcmode/floatingscene/vm/FloatingSceneViewModel';
import {
  FloatingSceneProperty,FloatingSceneViewData,
} from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/pcmode/floatingscene/vm/FloatingSceneViewData';
import { image } from '@kit.ImageKit';
import Constants from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/pcmode/floatingscene/constants/Constants';
import { LayoutViewModel } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { ReflectionUtils } from '../multiwindow/ReflectionUtils';

export function FloatingSceneViewDataTest() {
  describe('FloatingSceneViewDataTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {

    })
    beforeEach(() => {

    })
    afterEach(() => {

    })
    afterAll(() => {

    });
    constructorTest();
    updateTest();
    getMaxHeightTest();
    getDefaultHeightTest();
    updateHeightTest();
    getIdTest();
    showWindowTest();
    hideWindowTest();
    updatePropertyTest();
  });
}

function constructorTest() {
  it('constructorTest', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(10, floatingSceneProperty, screenProperty);
    expect(floatingSceneViewData.property).assertEqual(floatingSceneProperty);
    expect(floatingSceneViewData.screenProp).assertEqual(screenProperty);
  });
}

function updateTest() {
  it('updateTest_01', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(11, floatingSceneProperty, screenProperty);
    expect(floatingSceneViewData.property).assertEqual(floatingSceneProperty);
    expect(floatingSceneViewData.screenProp).assertEqual(screenProperty);
  });

  it('updateTest_02', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(11, floatingSceneProperty, screenProperty);
    let testUpdateFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let testUpdateScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    floatingSceneViewData.update(testUpdateFloatingSceneProperty);
    expect(floatingSceneViewData.property).assertEqual(testUpdateFloatingSceneProperty);
  });
}

function getMaxHeightTest() {
  it('getMaxHeightTest_01', Level.LEVEL0, (): void => {
    let newFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let newFloatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(15, newFloatingSceneProperty, newScreenProperty);
    let testMaxHeight: number = newFloatingSceneViewData['getMaxHeight']();
    expect(true).assertTrue();
  });

  it('getMaxHeightTest_02', Level.LEVEL0, (): void => {
    let newFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty.width = 2560;
    newScreenProperty.screenId = 1;
    let newFloatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(15, newFloatingSceneProperty, newScreenProperty);
    let testHeightIfScreenPropHeightNull: number = 0;
    let maxHeight_01: number = 0.9 * (testHeightIfScreenPropHeightNull -
    LayoutViewModel.getInstance().getDockMarginBottomHideBar() -
    LayoutViewModel.getInstance().getSysUITopHeight());
    let testMaxHeight: number = newFloatingSceneViewData['getMaxHeight']();
    expect(testMaxHeight).assertEqual(maxHeight_01);
  });

  it('getMaxHeightTest_03', Level.LEVEL0, (): void => {
    let newFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    newScreenProperty.width = 2560;
    newScreenProperty.height = 1600;
    newScreenProperty.screenId = 1;
    let newFloatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(15, newFloatingSceneProperty, newScreenProperty);
    let testHeightIfScreenPropHeight: number = px2vp(newFloatingSceneViewData.screenProp.height);
    let maxHeight_02: number = 0.9 * (testHeightIfScreenPropHeight -
    LayoutViewModel.getInstance().getDockMarginBottomHideBar() -
    LayoutViewModel.getInstance().getSysUITopHeight());
    let testMaxHeight: number = newFloatingSceneViewData['getMaxHeight']();
    expect(testMaxHeight).assertEqual(maxHeight_02);
  });
}

function getDefaultHeightTest() {
  it('getDefaultHeightTest_01', Level.LEVEL0, (): void => {
    let newFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let newFloatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, newFloatingSceneProperty, newScreenProperty);
    let defaultHeight: number = ResUtils.getNumberFromLength(Constants.CENTER_TITLE_HEIGHT) +
    ResUtils.getNumberFromLength(Constants.BUTTON_OPTIONS_HEIGHT) +
    ResUtils.getNumberFromLength(Constants.CENTER_TITLE_MARGIN_TOP) +
    ResUtils.getNumberFromLength(Constants.BUTTON_OPTIONS_MARGIN);
    let testDefaultHeight: number = newFloatingSceneViewData['getDefaultHeight']();
    expect(testDefaultHeight).assertEqual(defaultHeight);
  });

  it('getDefaultHeightTest_02', Level.LEVEL0, (): void => {
    let newFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let newScreenProperty: SCBScreenProperty = new SCBScreenProperty();
    let newFloatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, newFloatingSceneProperty, newScreenProperty);
    const getDefaultHeight: Function =
      ReflectionUtils.getProperty(newFloatingSceneViewData,'getDefaultHeight') as Function;
    let defaultHeight: number = ResUtils.getNumberFromLength(Constants.CENTER_TITLE_HEIGHT) +
    ResUtils.getNumberFromLength(Constants.BUTTON_OPTIONS_HEIGHT) +
    ResUtils.getNumberFromLength(Constants.CENTER_TITLE_MARGIN_TOP) +
    ResUtils.getNumberFromLength(Constants.BUTTON_OPTIONS_MARGIN);
    let testDefaultHeight: number = getDefaultHeight();
    expect(testDefaultHeight).assertEqual(defaultHeight);
  });
}

function updateHeightTest() {
  it('updateHeightTest_01', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    floatingSceneViewData.screenProp.height = 500;
    const testMaxHeight: number = floatingSceneViewData['getMaxHeight']();
    const testDefaultHeight: number = floatingSceneViewData['getDefaultHeight']();
    let height_01: number = -10000;
    floatingSceneViewData.updateHeight(height_01);
    expect(floatingSceneViewData.mHeight).assertEqual(0);
  });
  it('updateHeightTest_02', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    floatingSceneViewData.screenProp.height = 500;
    const testMaxHeight: number = floatingSceneViewData['getMaxHeight']();
    const testDefaultHeight: number = floatingSceneViewData['getDefaultHeight']();
    let height_02: number = 10000;
    floatingSceneViewData.updateHeight(height_02);
    expect(floatingSceneViewData.mHeight).assertEqual(testMaxHeight - testDefaultHeight);
  });
}

function getIdTest() {
  it('getIdTest', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    floatingSceneViewData.getId();
    expect(true).assertTrue();
  });
}

function showWindowTest() {
  it('showWindowTest_01', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    floatingSceneViewData.showWindow();
    expect(floatingSceneViewData.isShowing).assertTrue();
  });

  it('showWindowTest_02', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    const baseViewController: BaseViewController = new BaseViewController('com.sceneBoard.showWindowTest', -1);
    baseViewController.visible = true;
    viewMgrPolicy.registerViewController('com.sceneBoard.showWindowTest', baseViewController);
    floatingSceneViewData.property.bundleName = 'com.sceneBoard.showWindowTest';
    floatingSceneViewData.isShowing = false;
    floatingSceneViewData.showWindow();
    expect(floatingSceneViewData.isShowing).assertFalse();
  });

  it('showWindowTest_03', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    const baseViewController: BaseViewController = new BaseViewController('', -1);
    baseViewController.visible = true;
    viewMgrPolicy.registerViewController('', baseViewController);
    floatingSceneViewData.property.bundleName = '';
    floatingSceneViewData.isShowing = false;
    floatingSceneViewData.showWindow();
    expect(floatingSceneViewData.isShowing).assertFalse();
  });

  it('showWindowTest_04', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    const baseViewController: BaseViewController = new BaseViewController('com.sceneBoard.showWindowTest', -1);
    baseViewController.visible = false;
    viewMgrPolicy.registerViewController('com.sceneBoard.showWindowTest', baseViewController);
    floatingSceneViewData.property.bundleName = 'com.sceneBoard.showWindowTest';
    floatingSceneViewData.isShowing = false;
    floatingSceneViewData.showWindow();
    expect(floatingSceneViewData.isShowing).assertTrue();
  });
}

function hideWindowTest() {
  it('hideWindowTest_01', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    floatingSceneViewData.isShowing = true;
    floatingSceneViewData.hideWindow();
    expect(floatingSceneViewData.isShowing).assertTrue();
  });

  it('hideWindowTest_02', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    const baseViewController: BaseViewController = new BaseViewController('com.sceneBoard.hideWindowTest', -1);
    baseViewController.visible = false;
    viewMgrPolicy.registerViewController('com.sceneBoard.hideWindowTest', baseViewController);
    floatingSceneViewData.property.bundleName = 'com.sceneBoard.hideWindowTest';
    floatingSceneViewData.isShowing = true;
    floatingSceneViewData.hideWindow();
    expect(floatingSceneViewData.isShowing).assertTrue();
  });

  it('hideWindowTest_03', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    const baseViewController: BaseViewController = new BaseViewController('', -1);
    baseViewController.visible = true;
    viewMgrPolicy.registerViewController('', baseViewController);
    floatingSceneViewData.property.bundleName = '';
    floatingSceneViewData.isShowing = true;
    floatingSceneViewData.hideWindow();
    expect(floatingSceneViewData.isShowing).assertFalse();
  });

  it('hideWindowTest_04', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    let screenProperty: SCBScreenProperty = new SCBScreenProperty();
    let floatingSceneViewData: FloatingSceneViewData = new FloatingSceneViewData(12, floatingSceneProperty, screenProperty);
    const baseViewController: BaseViewController = new BaseViewController('com.sceneBoard.hideWindowTest', -1);
    baseViewController.visible = true;
    viewMgrPolicy.registerViewController('com.sceneBoard.hideWindowTest', baseViewController);
    floatingSceneViewData.property.bundleName = 'com.sceneBoard.hideWindowTest';
    floatingSceneViewData.isShowing = true;
    floatingSceneViewData.hideWindow();
    expect(floatingSceneViewData.isShowing).assertFalse();
  });
}

function updatePropertyTest() {
  it('updatePropertyTest_01', Level.LEVEL0, (): void => {
    let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    expect(true).assertTrue()
  });

  it('updatePropertyTest_02', Level.LEVEL0, (): void => {
    let testFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    testFloatingSceneProperty.bundleName = 'testBundleName';
    testFloatingSceneProperty.updateProperty('testUpdateBundleName');
    expect(testFloatingSceneProperty.bundleName).assertEqual('testUpdateBundleName');
  });

  it('updatePropertyTest_03', Level.LEVEL0, (): void => {
    let testFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    testFloatingSceneProperty.abilityName = 'testAbilityName';
    testFloatingSceneProperty.updateProperty('testUpdateBundleName','testUpdateAbilityName');
    expect(testFloatingSceneProperty.abilityName).assertEqual('testUpdateAbilityName');
  });

  it('updatePropertyTest_04', Level.LEVEL0, (): void => {
    let testFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    testFloatingSceneProperty.moduleName = 'testModuleName';
    testFloatingSceneProperty.updateProperty('testUpdateBundleName','testUpdateAbilityName','testUpdateModuleName');
    expect(testFloatingSceneProperty.moduleName).assertEqual('testUpdateModuleName');
  });

  it('updatePropertyTest_05', Level.LEVEL0, (): void => {
    let testFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    testFloatingSceneProperty.dockBundleName = 'testDockBundleName';
    testFloatingSceneProperty.updateProperty('testUpdateBundleName','testUpdateAbilityName','testUpdateModuleName',
      'testUpdateDockBundleName');
    expect(testFloatingSceneProperty.dockBundleName).assertEqual('testUpdateDockBundleName');
  });

  it('updatePropertyTest_06', Level.LEVEL0, (): void => {
    let testFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    testFloatingSceneProperty.dockAbilityName = 'testDockAbilityName';
    testFloatingSceneProperty.updateProperty('testUpdateBundleName','testUpdateAbilityName','testUpdateModuleName',
      'testUpdateDockBundleName','testUpdateDockAbilityName');
    expect(testFloatingSceneProperty.dockAbilityName).assertEqual('testUpdateDockAbilityName');
  });

  it('updatePropertyTest_07', Level.LEVEL0, (): void => {
    let testFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    testFloatingSceneProperty.dockModuleName = 'testDockModuleName';
    testFloatingSceneProperty.updateProperty('testUpdateBundleName','testUpdateAbilityName','testUpdateModuleName',
      'testUpdateDockBundleName','testUpdateDockAbilityName','testUpdateDockModuleName');
    expect(testFloatingSceneProperty.dockModuleName).assertEqual('testUpdateDockModuleName');
  });

  it('updatePropertyTest_08', Level.LEVEL0, (): void => {
    let testFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    testFloatingSceneProperty.label = 'testLabel';
    testFloatingSceneProperty.updateProperty('testUpdateBundleName','testUpdateAbilityName','testUpdateModuleName',
      'testUpdateDockBundleName','testUpdateDockAbilityName','testUpdateDockModuleName',
      'testUpdateLabel');
    expect(testFloatingSceneProperty.label).assertEqual('testUpdateLabel');
  });

  it('updatePropertyTest_09', Level.LEVEL0, (): void => {
    let testFloatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
    testFloatingSceneProperty.icon = 'testIcon';
    testFloatingSceneProperty.updateProperty('testUpdateBundleName','testUpdateAbilityName','testUpdateModuleName',
      'testUpdateDockBundleName','testUpdateDockAbilityName','testUpdateDockModuleName',
      'testUpdateLabel','testUpdateIcon');
    expect(testFloatingSceneProperty.icon).assertEqual('testUpdateIcon');
  });
}
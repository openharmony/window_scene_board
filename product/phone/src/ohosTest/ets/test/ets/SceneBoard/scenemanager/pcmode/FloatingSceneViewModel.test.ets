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

import { describe, it, expect, beforeItSpecified, afterItSpecified, beforeAll, beforeEach } from '@ohos/hypium';
import { RectInfo } from '@ohos/basicutils';
import { SCBScreenProperty } from '@ohos/windowscene';
import { BaseViewController } from '@ohos/frameworkcommon';
import { viewMgrPolicy, WindowEvent } from '@ohos/frameworkwrapper';
import { DockItemPosition } from '@ohos/smartdock/src/main/ets/default/common/DockItemPosition';
import { FloatingSceneViewModel, FloatingScenePropertyCallback, FloatingEvent } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/pcmode/floatingscene/vm/FloatingSceneViewModel';
import { FloatingSceneViewData, FloatingSceneProperty } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/pcmode/floatingscene/vm/FloatingSceneViewData';
import { ReflectionUtils } from '../multiwindow/ReflectionUtils';
import image from '@ohos.multimedia.image';

export default function FloatingSceneViewModelTest() {
  describe('FloatingSceneViewModelTest', () => {
    getInstanceTest();
    initTest();
    destoryTest();
    updateViewDataTest();
    registerPropertyCallbackTest();
    unregisterPropertyCallbackTest();
    updateHeightTest();
    closeWindowTest();
    startAbilityTest();
    closeAbilityTest();
    onWindowEventCallbackTest();
    onFloatingEventCallbackTest();
  })
}

function getInstanceTest() {
  it('getInstanceTest', 0, (): void => {
    const firstFloatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const SecondFloatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    expect(SecondFloatingSceneViewModel).assertEqual(firstFloatingSceneViewModel);
  });
}

function initTest() {
  it('initTest', 0, (): void => {
    FloatingSceneViewModel.getInstance().init();
    expect(true).assertTrue();
  });
}

function destoryTest() {
  it('destoryTest', 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
    floatingSceneViewModel.registerPropertyCallback(new FloatingScenePropertyCallbackTest());
    const viewData: FloatingSceneViewData = new FloatingSceneViewData(10,
      new FloatingSceneProperty(), new SCBScreenProperty());
    floatingSceneViewModel.updateViewData(viewData)
    floatingSceneViewModel.destory();
    expect(ReflectionUtils.getProperty(floatingSceneViewModel,'callback')).assertNull();
    expect(ReflectionUtils.getProperty(floatingSceneViewModel,'viewData')).assertNull();
  })
}

function updateViewDataTest() {
  beforeAll(() => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
  });

  it('updateViewDataTestForViewData', 0, () => {
    const viewData: FloatingSceneViewData = new FloatingSceneViewData(10,
      new FloatingSceneProperty(), new SCBScreenProperty());
    FloatingSceneViewModel.getInstance().updateViewData(viewData);
    expect(ReflectionUtils.getProperty(FloatingSceneViewModel.getInstance(),'viewData')).assertEqual(viewData);
  });
}

function registerPropertyCallbackTest() {
  beforeAll(() => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
  });

  it('registerPropertyCallbackTest_01', 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.destory();
    const first: object = ReflectionUtils.getProperty(floatingSceneViewModel,'callback');
    const floatingScenePropertyCallbackTest: FloatingScenePropertyCallbackTest =
      new FloatingScenePropertyCallbackTest();
    floatingSceneViewModel.registerPropertyCallback(floatingScenePropertyCallbackTest);
    const second: object = ReflectionUtils.getProperty(floatingSceneViewModel,'callback');
    expect(first).not().assertEqual(second);
  });

  it('registerPropertyCallbackTest_02', 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const first: object = ReflectionUtils.getProperty(floatingSceneViewModel,'callback');
    floatingSceneViewModel.registerPropertyCallback(new FloatingScenePropertyCallbackTest());
    const second: object = ReflectionUtils.getProperty(floatingSceneViewModel,'callback');
    expect(first).assertEqual(second);
  });
}

function unregisterPropertyCallbackTest() {
  beforeAll(() => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
    floatingSceneViewModel.registerPropertyCallback(new FloatingScenePropertyCallbackTest());
  });

  it('unregisterPropertyCallbackTest', 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.unregisterPropertyCallback();
    expect(ReflectionUtils.getProperty(floatingSceneViewModel,'callback')).assertNull();
  });
}

function updateHeightTest() {
  beforeAll(() => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
  });

  it("updateHeightTest_viewData_undefined", 0, () => {
    FloatingSceneViewModel.getInstance().destory();
    FloatingSceneViewModel.getInstance().updateHeight(10);
    expect(ReflectionUtils.getProperty(FloatingSceneViewModel.getInstance(),'viewData')).assertNull();
  })

  it("updateHeightTest_Height_undefined", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const viewData: FloatingSceneViewData = new FloatingSceneViewData(10,
      new FloatingSceneProperty(), new SCBScreenProperty());
    floatingSceneViewModel.updateViewData(viewData);
    FloatingSceneViewModel.getInstance().updateHeight();
    expect(viewData.mHeight).assertEqual(0);
  })

  it("updateHeightTest_viewData_defined", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const viewData: FloatingSceneViewData = new FloatingSceneViewData(10,
      new FloatingSceneProperty(), new SCBScreenProperty());
    floatingSceneViewModel.updateViewData(viewData);
    floatingSceneViewModel.updateHeight(10);
    expect(viewData.mHeight).not().assertEqual(0);
  })
}

function closeWindowTest() {
  beforeAll(() => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
    const baseViewController: BaseViewController = new BaseViewController('com.sceneBoard.closeWindowTest', -1);
    baseViewController.visible = true;
    viewMgrPolicy.registerViewController('com.sceneBoard.closeWindowTest', baseViewController);
  });

  it("closeWindowTest_notFound", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const viewData: FloatingSceneViewData = new FloatingSceneViewData(10,
      new FloatingSceneProperty(), new SCBScreenProperty());
    viewData.isShowing = true;
    viewData.property.updateProperty('com.sceneBoard.closeWindowTest');
    floatingSceneViewModel.updateViewData(viewData);
    floatingSceneViewModel.closeWindow('com.sceneBoard.closeWindow');
    expect(viewData.isShowing ).assertTrue();
  })

  it("closeWindowTest_canFind", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const viewData: FloatingSceneViewData = new FloatingSceneViewData(10,
      new FloatingSceneProperty(), new SCBScreenProperty());
    viewData.isShowing = true;
    viewData.property.updateProperty('com.sceneBoard.closeWindowTest');
    floatingSceneViewModel.updateViewData(viewData);
    floatingSceneViewModel.closeWindow('com.sceneBoard.closeWindowTest');
    expect(viewData.isShowing ).assertFalse();
  })
}

function startAbilityTest() {
  it("startAbilityTest", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
    const baseViewController: BaseViewController = new BaseViewController('com.sceneBoard.closeWindowTest', -1);
    baseViewController.visible = true;
    viewMgrPolicy.registerViewController('com.sceneBoard.closeWindowTest', baseViewController);
    const viewData: FloatingSceneViewData = new FloatingSceneViewData(10,
      new FloatingSceneProperty(), new SCBScreenProperty());
    viewData.isShowing = true;
    viewData.property.updateProperty('com.sceneBoard.closeWindowTest');
    floatingSceneViewModel.updateViewData(viewData);
    DockItemPosition.getInstance().setIconRect(new RectInfo());
    floatingSceneViewModel.startAbility();
    expect(viewData.isShowing ).assertFalse();
  });
}

function closeAbilityTest() {
  it("closeAbilityTest", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
    const baseViewController: BaseViewController = new BaseViewController('com.sceneBoard.closeWindowTest', -1);
    baseViewController.visible = true;
    viewMgrPolicy.registerViewController('com.sceneBoard.closeWindowTest', baseViewController);
    const viewData: FloatingSceneViewData = new FloatingSceneViewData(10,
      new FloatingSceneProperty(), new SCBScreenProperty());
    viewData.property.updateProperty('com.sceneBoard.closeWindowTest');
    floatingSceneViewModel.updateViewData(viewData);
    floatingSceneViewModel.closeAbility();
    expect(viewData.isShowing ).assertFalse();
  });
}

function onWindowEventCallbackTest() {
  it("onWindowEventCallbackTest_01", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
    const onWindowEventCallback: Function =
      ReflectionUtils.getProperty(floatingSceneViewModel,'onWindowEventCallback') as Function;
    onWindowEventCallback(null);
    expect(true).assertTrue();
  });

  it("onWindowEventCallbackTest_02", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const onWindowEventCallback: Function =
      ReflectionUtils.getProperty(floatingSceneViewModel,'onWindowEventCallback') as Function;
    const viewData: FloatingSceneViewData = getViewData();
    floatingSceneViewModel.updateViewData(viewData);
    let windowEvent: WindowEvent = new WindowEvent();
    windowEvent.windowName = 'notWindowEventCallbackTest';
    onWindowEventCallback(windowEvent);
    expect(true).assertTrue();
  });

  it("onWindowEventCallbackTest_03", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const onWindowEventCallback: Function =
      ReflectionUtils.getProperty(floatingSceneViewModel,'onWindowEventCallback') as Function;
    const viewData: FloatingSceneViewData = getViewData();
    floatingSceneViewModel.updateViewData(viewData);
    let windowEvent: WindowEvent = new WindowEvent();
    windowEvent.eventType = WindowEvent.EVENT_TYPE_HIDE;
    windowEvent.eventState = WindowEvent.EVENT_STATE_START;
    windowEvent.windowName = 'onWindowEventCallbackTest';
    onWindowEventCallback(windowEvent);
    expect(true).assertTrue();
  });

  it("onWindowEventCallbackTest_04", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const onWindowEventCallback: Function =
      ReflectionUtils.getProperty(floatingSceneViewModel,'onWindowEventCallback') as Function;
    const viewData: FloatingSceneViewData = getViewData();
    floatingSceneViewModel.updateViewData(viewData);
    let windowEvent: WindowEvent = new WindowEvent();
    windowEvent.eventType = WindowEvent.EVENT_TYPE_SHOW;
    windowEvent.eventState = WindowEvent.EVENT_STATE_START;
    windowEvent.windowName = 'onWindowEventCallbackTest';
    onWindowEventCallback(windowEvent);
    expect(true).assertTrue();
  });

  it("onWindowEventCallbackTest_05", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const onWindowEventCallback: Function =
      ReflectionUtils.getProperty(floatingSceneViewModel,'onWindowEventCallback') as Function;
    const viewData: FloatingSceneViewData = getViewData();
    floatingSceneViewModel.updateViewData(viewData);
    let windowEvent: WindowEvent = new WindowEvent();
    windowEvent.eventType = WindowEvent.EVENT_TYPE_SHOW;
    windowEvent.eventState = WindowEvent.EVENT_STATE_END;
    windowEvent.windowName = 'onWindowEventCallbackTest';
    onWindowEventCallback(windowEvent);
    expect(true).assertTrue();
  });

  it("onWindowEventCallbackTest_06", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    const onWindowEventCallback: Function =
      ReflectionUtils.getProperty(floatingSceneViewModel,'onWindowEventCallback') as Function;
    floatingSceneViewModel.destory();
    let windowEvent: WindowEvent = new WindowEvent();
    windowEvent.eventType = WindowEvent.EVENT_TYPE_SHOW;
    windowEvent.eventState = WindowEvent.EVENT_STATE_END;
    onWindowEventCallback(windowEvent);
    expect(true).assertTrue();
  });
}

function getViewData(): FloatingSceneViewData{
  let floatingSceneProperty: FloatingSceneProperty = new FloatingSceneProperty();
  floatingSceneProperty.bundleName = 'onWindowEventCallbackTest';
  const viewData: FloatingSceneViewData = new FloatingSceneViewData(10,
    floatingSceneProperty, new SCBScreenProperty());
  return viewData;
}

function onFloatingEventCallbackTest() {
  it("onFloatingEventCallbackTest_01", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.unregisterPropertyCallback();
    const onFloatingEventCallback: Function =
      ReflectionUtils.getProperty(floatingSceneViewModel,'onFloatingEventCallback') as Function;
    onFloatingEventCallback(new FloatingEventTest());
    expect(true).assertTrue();
  });

  it("onFloatingEventCallbackTest_02", 0, () => {
    const floatingSceneViewModel: FloatingSceneViewModel = FloatingSceneViewModel.getInstance();
    floatingSceneViewModel.init();
    const onFloatingEventCallback: Function =
      ReflectionUtils.getProperty(floatingSceneViewModel, 'onFloatingEventCallback') as Function;
    floatingSceneViewModel.registerPropertyCallback(new FloatingScenePropertyCallbackTest());
    onFloatingEventCallback(new FloatingEventTest());
    expect(true).assertTrue();
  });
}

class FloatingScenePropertyCallbackTest implements FloatingScenePropertyCallback {
  propertyCallback(floatingSceneProperty: FloatingEvent): void {

  }
}

class FloatingEventTest implements FloatingEvent {
  bundleName: string = '';
  abilityName: string = '';
  moduleName: string = '';
  dockBundleName: string = '';
  dockAbilityName: string = '';
  dockModuleName: string = '';
  label: string = '';
  icon: string | image.PixelMap = '';
  height: number | undefined = 0;
  state: string = '';
}
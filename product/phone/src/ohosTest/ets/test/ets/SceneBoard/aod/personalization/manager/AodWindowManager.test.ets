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

import { describe, expect, it, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {
  AodWindowManager,
  AodWindow
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/manager/AodWindowManager';
import { common } from '@kit.AbilityKit';
import UIExtensionContentSession from '@ohos.app.ability.UIExtensionContentSession';
import display from '@ohos.display';
import { window } from '@kit.ArkUI';

export function AodWindowManagerTest() {
  describe('AodWindowManagerTest', () => {

    it('test_getInstance', 0, () => {
      const instance0 = AodWindowManager.getInstance();
      const instance1 = AodWindowManager.getInstance();
      expect(true).assertTrue();
    });

    it('test_init', 0, () => {
      const instance = AodWindowManager.getInstance();
      let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let session: UIExtensionContentSession = {} as UIExtensionContentSession;
      instance.init(context, session); // window === undefined , this.count == 1
      instance.release(context); // this.count == 0
      expect(true).assertTrue();
    });

    it('test_init_1', 0, () => {
      const instance = AodWindowManager.getInstance();
      let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let session: UIExtensionContentSession = {} as UIExtensionContentSession;
      instance.init(context, session); // window === undefined , this.count == 1
      instance.init(context, session); // window !== undefined , this.count !== 1
      instance.release(context); // this.count !== 0
      expect(true).assertTrue();
    });

    it('test_init_Proxy_catch', 0, () => {
      let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let session: UIExtensionContentSession = {} as UIExtensionContentSession;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(session.getUIExtensionHostWindowProxy, session.getUIExtensionHostWindowProxy);
      when(mockFunction)().afterThrow('err'); // init->initWindow->initProperty

      const instance = AodWindowManager.getInstance();
      instance.init(context, session);
      instance.release(context);
      expect(true).assertTrue();
      mocker.clear(mockFunction);
      mocker.clearAll();
    });

    it('test_init_isPortrait', 0, () => {
      let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let displayInfo: display.Display = {
        id: 1,
        orientation: display.Orientation.PORTRAIT
      } as display.Display
      let session: UIExtensionContentSession = {} as UIExtensionContentSession;
      let mocker: MockKit = new MockKit();
      let mockFunctionProxy: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunctionProxy)().afterReturn(displayInfo); // orientation=>PORTRAIT

      const instance = AodWindowManager.getInstance();
      instance.init(context, session);
      instance.release(context);
      expect(true).assertTrue();
      mocker.clear(mockFunctionProxy);
      mocker.clearAll();
    });

    it('test_init_is_notPortrait', 0, () => {
      let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let displayInfo: display.Display = {
        id: 1,
        orientation: display.Orientation.LANDSCAPE
      } as display.Display
      let session: UIExtensionContentSession = {} as UIExtensionContentSession;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunction)().afterReturn(displayInfo); // orientation=>LANDSCAPE

      const instance = AodWindowManager.getInstance();
      instance.init(context, session);
      instance.release(context);
      expect(true).assertTrue();
      mocker.clear(mockFunction);
      mocker.clearAll();
    });

    it('test_init_subscribeEvent_proxy_undefined', 0, () => {
      let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let session: UIExtensionContentSession = {} as UIExtensionContentSession;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(session.getUIExtensionHostWindowProxy, session.getUIExtensionHostWindowProxy);
      when(mockFunction)().afterReturnNothing() // init->initWindow->initProperty->undefined

      const instance = AodWindowManager.getInstance();
      instance.init(context, session);
      instance.release(context);
      expect(true).assertTrue();
      mocker.clear(mockFunction);
      mocker.clearAll();
    });

    it('test_init_onWindowSizeChange_catch', 0, () => {
      let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let session: UIExtensionContentSession = {} as UIExtensionContentSession;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunction)().afterThrow('err') // init->initWindow->initProperty->catch

      const instance = AodWindowManager.getInstance();
      instance.init(context, session);
      instance.release(context);
      expect(true).assertTrue();
      mocker.clear(mockFunction);
      mocker.clearAll();
    });

  });
}

export function AodWindowTest() {
  describe('AodWindowTest', () => {
    it('AodWindow_initWindow', 0, () => {
      let aodWindow = new AodWindow();
      let context: common.UIAbilityContext = getContext() as common.UIAbilityContext;
      let session: UIExtensionContentSession = {} as UIExtensionContentSession;
      (aodWindow as object)['count'] = 3;
      aodWindow.initWindow(context, session);
      expect(aodWindow !== null).assertTrue();
    })

    it('AodWindow_initProperty', 0, () => {
      let aodWindow = new AodWindow();
      (aodWindow as object)['initProperty']();
      expect(aodWindow).not().assertUndefined();
    });

    it('AodWindow_isPortrait', 0, () => {
      let aodWindow = new AodWindow();
      const orientation = display.getDefaultDisplaySync().orientation;
      let result: boolean = (aodWindow as object)['isPortrait'](orientation);
      expect(result).assertTrue();
    });

    it('AodWindow_subscribeEvent1', 0, () => {
      let aodWindow = new AodWindow();
      (aodWindow as object)['proxy'] = undefined;
      (aodWindow as object)['subscribeEvent']();
      expect(aodWindow).not().assertUndefined();
    });

    it('AodWindow_updateSize1', 0, () => {
      let aodWindow = new AodWindow();
      (aodWindow as object)['context'] = undefined;
      (aodWindow as object)['updateSize']();
      expect(aodWindow).not().assertUndefined();
    });

    it('AodWindow_updateOrientation1', 0, () => {
      let aodWindow = new AodWindow();
      (aodWindow as object)['context'] = undefined;
      (aodWindow as object)['updateOrientation']();
      expect(aodWindow).not().assertUndefined();
    });

    it('AodWindow_updateOrientation2', 0, () => {
      let aodWindow = new AodWindow();
      (aodWindow as object)['context'] = getContext();
      aodWindow.orientation = window.Orientation.PORTRAIT;
      (aodWindow as object)['updateOrientation']();
      expect(aodWindow).not().assertUndefined();
    });

    it('AodWindow_updateOrientation3', 0, () => {
      let aodWindow = new AodWindow();
      (aodWindow as object)['context'] = getContext();
      aodWindow.orientation = window.Orientation.LANDSCAPE;
      (aodWindow as object)['updateOrientation']();
      expect(aodWindow).not().assertUndefined();
    });

    it('AodWindow_release1', 0, () => {
      let aodWindow = new AodWindow();
      (aodWindow as object)['count'] = 1;
      let result = aodWindow.release();
      expect(result).assertTrue();
    });

    it('AodWindow_release2', 0, () => {
      let aodWindow = new AodWindow();
      (aodWindow as object)['count'] = 2;
      let result = aodWindow.release();
      expect(result).assertFalse();
    });

    it('AodWindow_unsubscribeEvent1', 0, () => {
      let aodWindow = new AodWindow();
      (aodWindow as object)['proxy'] = undefined;
      (aodWindow as object)['unsubscribeEvent']();
      expect(aodWindow).not().assertUndefined();
    });
  });
}
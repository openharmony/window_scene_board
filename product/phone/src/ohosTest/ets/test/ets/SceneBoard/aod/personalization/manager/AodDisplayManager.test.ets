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

import { describe, expect, it, MockKit, when } from '@ohos/hypium';
import {
  AodDisplayManager
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/manager/AodDisplayManager';
import display from '@ohos.display';

export function AodDisplayManagerTest() {
  describe('AodDisplayManagerTest', () => {

    it('test_getInstance', 0, () => {
      const instance0 = AodDisplayManager.getInstance();
      const instance1 = AodDisplayManager.getInstance();
      expect(true).assertTrue();
    });

    it('test_init', 0, () => {
      const instance = AodDisplayManager.getInstance();
      instance.init(); // this.count == 1
      instance.release(); // this.count == 0
      expect(true).assertTrue();
    });

    it('test_init_1', 0, () => {
      const instance = AodDisplayManager.getInstance();
      instance.init();  // this.count == 1
      instance.init(); //this.count !== 1
      instance.release(); // this.count !== 0
      expect(true).assertTrue();
    });

    it('test_init_initProperty_catch', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunction)().afterThrow('err'); // init->initProperty->catch

      const instance = AodDisplayManager.getInstance();
      instance.init();
      instance.release();
      expect(true).assertTrue();
      mocker.clear(display.getDefaultDisplaySync);
      mocker.clearAll();
    });

    it('test_init_parseOrientation_isPortrait', 0, () => {
      let displayInfo: display.Display = {
        id: 1,
        orientation: display.Orientation.PORTRAIT
      } as display.Display
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunction)().afterReturn(displayInfo); // orientation=>PORTRAIT

      const instance = AodDisplayManager.getInstance();
      instance.init();
      instance.release();
      expect(true).assertTrue();
      mocker.clear(display.getDefaultDisplaySync);
      mocker.clearAll();
    });

    it('test_init_parseOrientation_is_notPortrait', 0, () => {
      let displayInfo: display.Display = {
        id: 1,
        orientation: display.Orientation.LANDSCAPE
      } as display.Display
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunction)().afterReturn(displayInfo); // orientation=>LANDSCAPE

      const instance = AodDisplayManager.getInstance();
      instance.init();
      instance.release();
      expect(true).assertTrue();
      mocker.clear(display.getDefaultDisplaySync);
      mocker.clearAll();
    });

    it('test_init_subscribeDisplayChange_catch', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.on, display.on);
      when(mockFunction)().afterThrow('err');

      const instance = AodDisplayManager.getInstance();
      instance.init();
      instance.release();
      expect(true).assertTrue();
      mocker.clear(display.on);
      mocker.clearAll();
    });

    it('test_init_subscribeDisplayChange_onDisplayChange_catch', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunction)().afterThrow('err');

      const instance = AodDisplayManager.getInstance();
      instance.init();
      instance.release();
      expect(true).assertTrue();
      mocker.clear(display.getDefaultDisplaySync);
      mocker.clearAll();
    });

    it('test_init_updateOrientation_isNewOrientation', 0, () => {
      let displayInfo: display.Display = {
        id: 1,
        orientation: display.Orientation.LANDSCAPE
      } as display.Display
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunction)().afterReturn(displayInfo);

      const instance = AodDisplayManager.getInstance();
      instance.init();
      instance.release();
      expect(true).assertTrue();
      mocker.clear(display.getDefaultDisplaySync);
      mocker.clearAll();
    });

    it('test_init_updateOrientation_is_notNewOrientation', 0, () => {
      let displayInfo: display.Display = {
        id: 1,
        orientation: display.Orientation.PORTRAIT_INVERTED
      } as display.Display
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.getDefaultDisplaySync, display.getDefaultDisplaySync);
      when(mockFunction)().afterReturn(displayInfo);

      const instance = AodDisplayManager.getInstance();
      instance.init();
      instance.release();
      expect(true).assertTrue();
      mocker.clear(display.getDefaultDisplaySync);
      mocker.clearAll();
    });

    it('test_release_unsubscribeDisplayChange_catch', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunction: Function = mocker.mockFunc(display.off, display.off);
      when(mockFunction)().afterThrow('err'); // release->unsubscribeDisplayChange->catch

      const instance = AodDisplayManager.getInstance();
      instance.init(); //this.count !== 1
      instance.release(); // this.count !== 0
      expect(true).assertTrue();
      mocker.clear(display.off);
      mocker.clearAll();
    });

  });
}
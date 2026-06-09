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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium'
import { DisplayUtils } from '../../../../../main/ets/TsIndex';
import { display } from '@kit.ArkUI';
import {
  ChangeParams,
  DisplayStateListener,
  DisplayStateManager
} from '../../../../../main/ets/manager/DisplayStateManager';
import { SCBScreenProperty } from '@ohos/windowscene';

export default function DisplayStateManagerTest() {
  let displayStateManager: DisplayStateManager = new DisplayStateManager();
  describe('DisplayStateManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('DisplayStateManager_updateWidth1', 0, () => {
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      (displayStateManager as object)['_screenProperty'] = null;
      let result: boolean = (displayStateManager as object)['updateWidth'](testSCBScreenProperty);
      expect(result).assertTrue();
    });

    it('DisplayStateManager_updateWidth2', 0, () => {
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      testSCBScreenProperty.width = 100;
      (displayStateManager as object)['_screenWidth'] = 10;
      let result: boolean = (displayStateManager as object)['updateWidth'](testSCBScreenProperty);
      expect(result).assertTrue();
    });

    it('DisplayStateManager_updateWidth3', 0, () => {
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      (displayStateManager as object)['_screenProperty'] = testSCBScreenProperty;
      testSCBScreenProperty.width = 100;
      (displayStateManager as object)['_screenWidth'] = 100;
      let result: boolean = (displayStateManager as object)['updateWidth'](testSCBScreenProperty);
      expect(result).assertFalse();
    });

    it('DisplayStateManager_updateHeight1', 0, () => {
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      (displayStateManager as object)['_screenProperty'] = null;
      let result: boolean = (displayStateManager as object)['updateHeight'](testSCBScreenProperty);
      expect(result).assertTrue();
    });

    it('DisplayStateManager_updateHeight2', 0, () => {
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      testSCBScreenProperty.height = 100;
      (displayStateManager as object)['_screenHeight'] = 10;
      let result: boolean = (displayStateManager as object)['updateHeight'](testSCBScreenProperty);
      expect(result).assertTrue();
    });

    it('DisplayStateManager_updateHeight3', 0, () => {
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      (displayStateManager as object)['_screenProperty'] = testSCBScreenProperty;
      testSCBScreenProperty.height = 100;
      (displayStateManager as object)['_screenHeight'] = 100;
      let result: boolean = (displayStateManager as object)['updateHeight'](testSCBScreenProperty);
      expect(result).assertFalse();
    });

    it('DisplayStateManager_updateOrientation', 0, () => {
      (displayStateManager as object)['_screenRotation'] = 100;
      let result: boolean = (displayStateManager as object)['updateOrientation']();
      expect(result).assertTrue();
    });

    it('DisplayStateManager_updateFoldExpandState1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.isFoldAble);
      when(mockFunc)().afterReturn(false);
      let result: boolean = (displayStateManager as object)['updateFoldExpandState']();
      expect(result).assertFalse();
      mocker.clear(DisplayUtils);
      mocker.clearAll();
    });

    it('DisplayStateManager_updateFoldExpandState2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.isFoldAble);
      when(mockFunc)().afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.getFoldStatus);
      when(mockFunc1)().afterReturn(display.FoldStatus.FOLD_STATUS_EXPANDED);
      let result: boolean = (displayStateManager as object)['updateFoldExpandState']();
      expect(result).assertTrue();
      mocker.clear(DisplayUtils);
      mocker.clearAll();
    });

    it('DisplayStateManager_updateFoldExpandState3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.isFoldAble);
      when(mockFunc)().afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.getFoldStatus);
      when(mockFunc1)().afterReturn(display.FoldStatus.FOLD_STATUS_HALF_FOLDED);
      let result: boolean = (displayStateManager as object)['updateFoldExpandState']();
      expect(result).assertFalse();
      mocker.clear(DisplayUtils);
      mocker.clearAll();
    });

    it('DisplayStateManager_updateFoldExpandState4', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.isFoldAble);
      when(mockFunc)().afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.getFoldStatus);
      when(mockFunc1)().afterReturn(display.FoldStatus.FOLD_STATUS_FOLDED);
      let result: boolean = (displayStateManager as object)['updateFoldExpandState']();
      expect(result).assertTrue();
      mocker.clear(DisplayUtils);
      mocker.clearAll();
    });

    it('DisplayStateManager_updateFoldStatusState1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.isFoldAble);
      when(mockFunc)().afterReturn(false);
      let result: boolean = (displayStateManager as object)['updateFoldStatusState']();
      expect(result).assertFalse();
      mocker.clear(DisplayUtils);
      mocker.clearAll();
    });

    it('DisplayStateManager_updateFoldStatusState2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.isFoldAble);
      when(mockFunc)().afterReturn(true);
      let mockFunc1: Function = mocker.mockFunc(DisplayUtils, DisplayUtils.getFoldStatus);
      when(mockFunc1)().afterReturn(display.FoldStatus.FOLD_STATUS_FOLDED);
      (displayStateManager as object)['_foldStatus'] = display.FoldStatus.FOLD_STATUS_FOLDED;
      let result: boolean = (displayStateManager as object)['updateFoldStatusState']();
      expect(result).assertFalse();
      mocker.clear(DisplayUtils);
      mocker.clearAll();
    });

    it('DisplayStateManager_broadcastStateChange1', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc((displayStateManager as object), (displayStateManager as object)['hasObserver']);
      when(mockFunc)().afterReturn(false);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
      (displayStateManager as object)['broadcastStateChange']();
      mocker.clear((displayStateManager as object));
      mocker.clearAll();
    });

    it('DisplayStateManager_broadcastStateChange2', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let changeParams: ChangeParams = {
        isPropertyChange: true,
        isWidthChange: true,
        isHeightChange: true,
        isOrientationChange: true,
        isFoldChange: true,
        isFoldStatusChange: true
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc((displayStateManager as object), (displayStateManager as object)['hasObserver']);
      when(mockFunc)().afterReturn(true);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
      (displayStateManager as object)['broadcastStateChange'](changeParams);
      mocker.clear((displayStateManager as object));
      mocker.clearAll();
    });

    it('DisplayStateManager_broadcastStateChange3', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let changeParams: ChangeParams = {
        isPropertyChange: true,
        isWidthChange: false,
        isHeightChange: true,
        isOrientationChange: true,
        isFoldChange: true,
        isFoldStatusChange: true
      };
      let mocker: MockKit = new MockKit();
      let mockFunc: Function =
        mocker.mockFunc((displayStateManager as object), (displayStateManager as object)['hasObserver']);
      when(mockFunc)().afterReturn(true);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
      (displayStateManager as object)['broadcastStateChange'](changeParams);
      mocker.clear((displayStateManager as object));
      mocker.clearAll();
    });

    it('DisplayStateManager_notifyScreenDisplayState1', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      (displayStateManager as object)['_screenProperty'] = testSCBScreenProperty;
      let listener: DisplayStateListener = {
        onOrientationChange: (orientation: number) => {
        },
        onScreenSizeChange: (width: number, height: number) => {
        }
      };
      let changeParams: ChangeParams = {
        isPropertyChange: true,
        isWidthChange: true,
        isHeightChange: true,
        isOrientationChange: true,
        isFoldChange: true,
        isFoldStatusChange: true
      };
      (displayStateManager as object)['notifyScreenDisplayState'](listener, changeParams);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

    it('DisplayStateManager_notifyScreenDisplayState2', 0, () => {
      let execute: string = '';
      const callback: Callback<void> = () => {
        execute = 'success';
      };
      let testSCBScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      (displayStateManager as object)['_screenProperty'] = testSCBScreenProperty;
      let listener: DisplayStateListener = {
        onOrientationChange: (orientation: number) => {
        },
        onScreenSizeChange: (width: number, height: number) => {
        }
      };
      let changeParams: ChangeParams = {
        isPropertyChange: true,
        isWidthChange: false,
        isHeightChange: true,
        isOrientationChange: true,
        isFoldChange: true,
        isFoldStatusChange: true
      };
      (displayStateManager as object)['notifyScreenDisplayState'](listener, changeParams);
      callback();
      expect(execute == 'success' ? true : false).not().assertNull();
    });

  })
}
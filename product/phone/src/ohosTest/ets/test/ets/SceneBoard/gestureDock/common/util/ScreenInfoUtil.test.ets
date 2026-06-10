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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, MockKit, when } from '@ohos/hypium';
import { SCBScreenProperty } from '@ohos/windowscene';
import display from '@ohos.display';
import Display from '@ohos.display';
import { ScreenInfoUtil } from '@ohos/phonebase/src/main/ets/SceneBoard/gestureDock/common/util/ScreenInfoUtil';

export default function ScreenInfoUtilTest() {
  describe('ScreenInfoUtilTest', () => {
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

    it('ScreenInfoUtilTest_isVertical_1', Level.LEVEL0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      scbScreenProperty.rotation = 0;
      ScreenInfoUtil.isVertical(scbScreenProperty);
      expect(ScreenInfoUtil.isVertical(scbScreenProperty)).assertTrue();
    })

    it('ScreenInfoUtilTest_isVertical_2', Level.LEVEL0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      scbScreenProperty.rotation = 360;
      ScreenInfoUtil.isVertical(scbScreenProperty);
      expect(ScreenInfoUtil.isVertical(scbScreenProperty)).assertTrue();
    })

    it('ScreenInfoUtilTest_isVertical_3', Level.LEVEL0, (): void => {
      let scbScreenProperty: SCBScreenProperty = new SCBScreenProperty();
      scbScreenProperty.rotation = 90;
      ScreenInfoUtil.isVertical(scbScreenProperty);
      expect(ScreenInfoUtil.isVertical(scbScreenProperty)).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutLeft_1', 0, (): void => {
      let rect: display.Rect = {
        left: 10,
        top: 0,
        width: 8,
        height: 100,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 8;
      display.height = 100;
      let isCutOutLeft: boolean = ScreenInfoUtil.isCutOutLeft(rect, display);
      expect(isCutOutLeft).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutLeft_2', 0, (): void => {
      let rect: display.Rect = {
        left: 1,
        top: 5,
        width: 8,
        height: 40,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 8;
      display.height = 40;
      let isCutOutLeft: boolean = ScreenInfoUtil.isCutOutLeft(rect, display);
      expect(isCutOutLeft).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutLeft_3', 0, (): void => {
      let rect: display.Rect = {
        left: 1,
        top: 40,
        width: 8,
        height: 40,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 8;
      display.height = 40;
      let isCutOutLeft: boolean = ScreenInfoUtil.isCutOutLeft(rect, display);
      expect(isCutOutLeft).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutLeft_4', 0, (): void => {
      let rect: display.Rect = {
        left: 5,
        top: 20,
        width: 20,
        height: 40,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 20;
      display.height = 40;
      let isCutOutLeft: boolean = ScreenInfoUtil.isCutOutLeft(rect, display);
      expect(isCutOutLeft).assertTrue();
    })

    it('ScreenInfoUtilTest_isCutOutBottom_1', 0, (): void => {
      let rect: display.Rect = {
        left: 1,
        top: 3,
        width: 20,
        height: 5,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 20;
      display.height = 5;
      let isCutOutBottom: boolean = ScreenInfoUtil.isCutOutBottom(rect, display);
      expect(isCutOutBottom).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutBottom_2', 0, (): void => {
      let rect: display.Rect = {
        left: 40,
        top: 5,
        width: 40,
        height: 5,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 40;
      display.height = 5;
      let isCutOutBottom: boolean = ScreenInfoUtil.isCutOutBottom(rect, display);
      expect(isCutOutBottom).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutBottom_3', 0, (): void => {
      let rect: display.Rect = {
        left: 5,
        top: 5,
        width: 40,
        height: 5,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 40;
      display.height = 5;
      let isCutOutBottom: boolean = ScreenInfoUtil.isCutOutBottom(rect, display);
      expect(isCutOutBottom).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutBottom_4', 0, (): void => {
      let rect: display.Rect = {
        left: 20,
        top: 5,
        width: 40,
        height: 5,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 40;
      display.height = 5;
      let isCutOutBottom: boolean = ScreenInfoUtil.isCutOutBottom(rect, display);
      expect(isCutOutBottom).assertTrue();
    })

    it('ScreenInfoUtilTest_isCutOutRight_1', 0, (): void => {
      let rect: display.Rect = {
        left: 3,
        top: 3,
        width: 5,
        height: 5,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 5;
      display.height = 5;
      let isCutOutRight: boolean = ScreenInfoUtil.isCutOutRight(rect, display);
      expect(isCutOutRight).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutRight_2', 0, (): void => {
      let rect: display.Rect = {
        left: 10,
        top: 5,
        width: 5,
        height: 40,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 5;
      display.height = 40;
      let isCutOutRight: boolean = ScreenInfoUtil.isCutOutRight(rect, display);
      expect(isCutOutRight).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutRight_3', 0, (): void => {
      let rect: display.Rect = {
        left: 10,
        top: 40,
        width: 5,
        height: 40,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 5;
      display.height = 40;
      let isCutOutRight: boolean = ScreenInfoUtil.isCutOutRight(rect, display);
      expect(isCutOutRight).assertFalse();
    })

    it('ScreenInfoUtilTest_isCutOutRight_4', 0, (): void => {
      let rect: display.Rect = {
        left: 10,
        top: 20,
        width: 5,
        height: 40,
      }
      let display = Display.getDefaultDisplaySync();
      display.width = 5;
      display.height = 40;
      let isCutOutRight: boolean = ScreenInfoUtil.isCutOutRight(rect, display);
      expect(isCutOutRight).assertTrue();
    })

  })
}
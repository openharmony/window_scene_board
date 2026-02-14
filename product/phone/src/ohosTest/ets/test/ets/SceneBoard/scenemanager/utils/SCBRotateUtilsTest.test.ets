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
  SCBScreenProperty
} from '@ohos/windowscene';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import { SCBRotateUtils } from '@ohos/phonebase/src/main/ets/SceneBoard/scenemanager/utils/SCBRotateUtils';

export default function SCBRotateUtilsTest() {
  describe('SCBRotateUtilsTest', () => {
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

    it('getScenePanelTranslateOptionsTest01', 0, () => {
      let enableRotate: boolean = false;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let option: TranslateOptions = {
        x: screenProperty.getTranslateX() + 'px',
        y: screenProperty.getTranslateY() + 'px'
      };
      expect(SCBRotateUtils.getScenePanelTranslateOptions(screenProperty, enableRotate).x).assertEqual(option.x);
      expect(SCBRotateUtils.getScenePanelTranslateOptions(screenProperty, enableRotate).y).assertEqual(option.y);
    })

    it('getScenePanelTranslateOptionsTest02', 0, () => {
      let enableRotate: boolean = true;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let option: TranslateOptions = {
        x: 0 + 'px',
        y: 0 + 'px'
      };
      expect(SCBRotateUtils.getScenePanelTranslateOptions(screenProperty, enableRotate).x).assertEqual(option.x);
      expect(SCBRotateUtils.getScenePanelTranslateOptions(screenProperty, enableRotate).y).assertEqual(option.y);
    })

    it('getScenePanelRotateOptionsTest01', 0, () => {
      let enableRotate: boolean = false;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let option: RotateOptions = {
        x: 0,
        y: 0,
        z: 1,
        angle: 0,
        centerX: '50%',
        centerY: '50%'
      };
      option.angle = -screenProperty.rotation;
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).x).assertEqual(option.x);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).y).assertEqual(option.y);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).z).assertEqual(option.z);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).angle).assertEqual(option.angle);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).centerX).assertEqual('50%');
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).centerY).assertEqual('50%');
    })

    it('getScenePanelRotateOptionsTest02', 0, () => {
      let enableRotate: boolean = true;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let option: RotateOptions = {
        x: 0,
        y: 0,
        z: 1,
        angle: 0,
        centerX: '50%',
        centerY: '50%'
      };
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).x).assertEqual(option.x);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).y).assertEqual(option.y);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).z).assertEqual(option.z);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).angle).assertEqual(option.angle);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).centerX).assertEqual('50%');
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).centerY).assertEqual('50%');
    })

    it('getScenePanelRotateOptionsTest03', 0, () => {
      let enableRotate: boolean = true;
      let screenProperty: SCBScreenProperty = new SCBScreenProperty();
      let option: RotateOptions = {
        x: 0,
        y: 0,
        z: 1,
        angle: 0,
        centerX: '50%',
        centerY: '50%'
      };
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).x).assertEqual(option.x);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).y).assertEqual(option.y);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).z).assertEqual(option.z);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).angle).assertEqual(option.angle);
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).centerX).assertEqual('50%');
      expect(SCBRotateUtils.getScenePanelRotateOptions(screenProperty, enableRotate).centerY).assertEqual('50%');
    })

    it('getPortraitStateTest', 0, () => {
      let rotation: number = 0;
      expect(SCBRotateUtils.getPortraitState(rotation)).assertEqual('Port');
      rotation = 90;
      expect(SCBRotateUtils.getPortraitState(rotation)).assertEqual('Land');
      rotation = 180;
      expect(SCBRotateUtils.getPortraitState(rotation)).assertEqual('Port');
      rotation = 270;
      expect(SCBRotateUtils.getPortraitState(rotation)).assertEqual('Land');
      rotation = 360;
      expect(SCBRotateUtils.getPortraitState(rotation)).assertEqual('Port');
    })

    it('isVerticalTest', 0, () => {
      let rotation: number = 0;
      expect(SCBRotateUtils.isVertical(rotation)).assertEqual(true);
      rotation = 90;
      expect(SCBRotateUtils.isVertical(rotation)).assertEqual(false);
      rotation = 180;
      expect(SCBRotateUtils.isVertical(rotation)).assertEqual(true);
      rotation = 270;
      expect(SCBRotateUtils.isVertical(rotation)).assertEqual(false);
      rotation = 360;
      expect(SCBRotateUtils.isVertical(rotation)).assertEqual(true);
    })
  })
}
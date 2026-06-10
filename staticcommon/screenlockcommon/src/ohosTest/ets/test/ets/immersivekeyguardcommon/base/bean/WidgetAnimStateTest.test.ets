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

import { it, describe, expect } from '@ohos/hypium';
import { BaseState } from '../../../../../../../main/ets/immersivekgcommon/base/bean/BaseState';
import { WidgetAnimState } from '../../../../../../../main/ets/immersivekgcommon/base/bean/WidgetAnimState';
import { WAnimScene } from '../../../../../../../main/ets/immersivekgcommon/base/constants/WidgetPropertyConst';

export function WidgetAnimStateTest() {
  describe('WidgetAnimStateTest', (): void => {
    it('test_initWidgetAnimState', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap(WidgetAnimState, 'WidgetAnimStateTest');
      testInstance.getStateType();
      expect(testInstance instanceof WidgetAnimState).assertTrue();
    });
    it('test_getStateType', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res = testInstance.getStateType();
      expect(res !==undefined).assertTrue();
    });
    it('test_addChildState', 0, (): void => {
      let childState: WidgetAnimState =  BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'childState');
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res=testInstance.addChildState(childState);
      expect(res instanceof WidgetAnimState).assertTrue();
    });
    it('test_removeChildState', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res = testInstance.removeChildState('111');
      expect(res instanceof WidgetAnimState).assertTrue();
    });
    it('test_getChildState', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res = testInstance.getChildState('111');
      expect(res instanceof WidgetAnimState).assertTrue();
    });
    it('test_setAnimScene', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res = testInstance.setAnimScene();
      expect(res instanceof WidgetAnimState).assertTrue();
    });
    it('test_isSceneAnimating', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res = testInstance.isSceneAnimating();
      expect(res !== undefined).assertTrue();
    });
    it('test_setAnimScene', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res = testInstance.isWidgetAnimating();
      expect(res !== undefined).assertTrue();
    });
    it('test_isSceneAnimating', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res = testInstance.isSceneAnimating('10');
      expect(res !== undefined).assertTrue();
    });
    it('test_isWidgetAnimating', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res = testInstance.isWidgetAnimating();
      expect(res !== undefined).assertTrue();
    });
    it('test_getSceneValues', 0, (): void => {
      let testInstance: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      let res = testInstance.getSceneValues();
      expect(res !== undefined).assertTrue();
    });
    it("WidgetAnimStateTest_setAnimScene_001", 0, () => {
      let widgetAnimS: WidgetAnimState = BaseState.wrap<WidgetAnimState>(WidgetAnimState, 'WidgetAnimStateTest');
      widgetAnimS.setAnimScene();
      let value: WAnimScene = {
        isAnimating: true
      };
      widgetAnimS.setAnimScene(value);
      value.isForceRemove = false;
      widgetAnimS.setAnimScene(value);
      widgetAnimS.setAnimScene();
      expect(widgetAnimS != null).assertTrue();
    })
  });
}
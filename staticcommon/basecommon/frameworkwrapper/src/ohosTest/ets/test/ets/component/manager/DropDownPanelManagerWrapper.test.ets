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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  ArgumentMatchers,
  when
} from '@ohos/hypium'
import { DropDownPanelManagerWrapper } from '../../../../../../main/ets/manager/DropDownPanelManagerWrapper'
import { TargetPanel } from '../../../../../../main/ets/eventbus/events/Events'
import ViewManagerPolicy from '../../../../../../main/ets/manager/view/ViewManagerPolicy'

export default function DropDownPanelManagerWrapperTest() {
  describe('DropDownPanelManagerWrapperTest', () => {
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
    it('DropDownPanelManagerWrapper_getInstance_test01', 0, () => {
      let instance1: DropDownPanelManagerWrapper = DropDownPanelManagerWrapper.getInstance();
      expect(instance1).not().assertUndefined();
      let instance2: DropDownPanelManagerWrapper = DropDownPanelManagerWrapper.getInstance();
      expect(instance2).assertEqual(instance1);
    })

    it('DropDownPanelManagerWrapper_hideWindowDirectly_test01', 0, () => {
      let instance1: DropDownPanelManagerWrapper = DropDownPanelManagerWrapper.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFun)(ArgumentMatchers.any).afterReturn(false);
      instance1.hideWindowDirectly();
      expect(instance1).not().assertUndefined();
      mock.ignoreMock(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      mock.clearAll();
    })

    it('DropDownPanelManagerWrapper_hideWindowDirectly_test02', 0, () => {
      let instance1: DropDownPanelManagerWrapper = DropDownPanelManagerWrapper.getInstance();
      let mock: MockKit = new MockKit();
      let mockFun: Function = mock.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);
      instance1.hideWindowDirectly();
      expect(instance1).not().assertUndefined();
      mock.ignoreMock(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      mock.clearAll();
    })

    it('DropDownPanelManagerWrapper_showWindowDirectly_test01', 0, () => {
      let instance1: DropDownPanelManagerWrapper = DropDownPanelManagerWrapper.getInstance();
      let target: TargetPanel = TargetPanel.NONE;
      instance1.showWindowDirectly(target);
      expect(instance1).not().assertUndefined();
    })

    it('DropDownPanelManagerWrapper_showWindowDirectly_test02', 0, () => {
      let instance1: DropDownPanelManagerWrapper = DropDownPanelManagerWrapper.getInstance();
      let target: TargetPanel = TargetPanel.NOTIFICATION_PANEL;
      instance1.showWindowDirectly(target);
      expect(instance1).not().assertUndefined();
    })

    it('DropDownPanelManagerWrapper_setTargetPanel_test01', 0, () => {
      let instance1: DropDownPanelManagerWrapper = DropDownPanelManagerWrapper.getInstance();
      let target: TargetPanel = TargetPanel.NOTIFICATION_PANEL;
      instance1.setTargetPanel(target);
      expect(instance1).not().assertUndefined();
    })

    it('DropDownPanelManagerWrapper_setTargetPanel_test02', 0, () => {
      let instance1: DropDownPanelManagerWrapper = DropDownPanelManagerWrapper.getInstance();
      let target: TargetPanel = TargetPanel.CONTROL_CENTER_PANEL;
      instance1.setTargetPanel(target);
      expect(instance1).not().assertUndefined();
    });

    it('should_return_immediately_when_target_is_NONE', 0, () => {
      let dropdownpanelmanagerwrapper:DropDownPanelManagerWrapper = new DropDownPanelManagerWrapper();
      dropdownpanelmanagerwrapper.showWindowDirectly(TargetPanel.NONE);
    });
  })
}
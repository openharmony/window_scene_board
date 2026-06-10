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

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  DEFAULT,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { DropDownPanelManagerWrapper } from '../../../../../../main/ets/manager/DropDownPanelManagerWrapper';
import { TargetPanel } from '../../../../../../main/ets/eventbus/events/Events';
import { default as ViewManagerPolicy } from '../../../../../../main/ets/manager/view/ViewManagerPolicy';

export function DropDownPanelManagerWrappersTest() {
  describe('DropDownPanelManagerWrappersTest', () => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })


    it('test_getInstance_01', DEFAULT, (): void => {
      (DropDownPanelManagerWrapper as object)['instance'] = null;
      expect(DropDownPanelManagerWrapper.getInstance()).not().assertNull();
    })

    it('test_hideWindowDirectly_01', DEFAULT, (): void => {
      expect(DropDownPanelManagerWrapper.getInstance().dropDownEventProxy).not().assertUndefined();
      DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
      expect(DropDownPanelManagerWrapper.getInstance()).not().assertNull();
    })

    it('test_hideWindowDirectly_02', DEFAULT, (): void => {
      let mocker: MockKit = new MockKit();
      let mockFun: Function = mocker.mockFunc(ViewManagerPolicy, ViewManagerPolicy.isViewShowing);
      when(mockFun)(ArgumentMatchers.any).afterReturn(true);

      DropDownPanelManagerWrapper.getInstance().hideWindowDirectly();
      expect(DropDownPanelManagerWrapper.getInstance()).not().assertNull();
      mocker.clear(mockFun);
      mocker.ignoreMock(ViewManagerPolicy, mockFun);
      mocker.clearAll();
    })

    it('test_postWindowEvent_01', DEFAULT, (): void => {
      DropDownPanelManagerWrapper.getInstance().postWindowEvent('windowName', 1, 1);
      expect(DropDownPanelManagerWrapper.getInstance()).not().assertNull();
    })

    it('test_showWindowDirectly_01', DEFAULT, (): void => {
      DropDownPanelManagerWrapper.getInstance().showWindowDirectly(TargetPanel.NONE);
      DropDownPanelManagerWrapper.getInstance().showWindowDirectly(TargetPanel.CONTROL_CENTER_PANEL);
      expect(DropDownPanelManagerWrapper.getInstance().getDropDownEvent().target === TargetPanel.CONTROL_CENTER_PANEL)
        .assertTrue();
      DropDownPanelManagerWrapper.getInstance().setTargetPanel(TargetPanel.CONTROL_CENTER_PANEL);
    })

    it('test_setTargetPanel_01', DEFAULT, (): void => {
      DropDownPanelManagerWrapper.getInstance().setTargetPanel(TargetPanel.NONE);
      DropDownPanelManagerWrapper.getInstance().setTargetPanel(TargetPanel.CONTROL_CENTER_PANEL);
      expect(DropDownPanelManagerWrapper.getInstance().getDropDownEvent().target === TargetPanel.CONTROL_CENTER_PANEL)
        .assertTrue();
      DropDownPanelManagerWrapper.getInstance().setTargetPanel(TargetPanel.NONE);
      DropDownPanelManagerWrapper.getInstance().setTargetPanel(TargetPanel.NOTIFICATION_PANEL);
      expect(DropDownPanelManagerWrapper.getInstance().getDropDownEvent().target === TargetPanel.NOTIFICATION_PANEL)
        .assertTrue();
    })
  })
}

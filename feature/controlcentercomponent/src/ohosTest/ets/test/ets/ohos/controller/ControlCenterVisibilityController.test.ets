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
import { afterAll, afterEach, beforeEach, it, describe, expect, beforeAll, MockKit, when } from '@ohos/hypium';
import { DesktopModeEnum } from '@ohos/launchercommon/src/main/ets/desktopmode/statemanager/DesktopMode';
import ControlCenterVisibilityController
  from '../../../../../../main/ets/com/ohos/controller/ControlCenterVisibilityController';
import { EmergencyManager } from '../../../../../../main/ets/com/ohos/viewModel/EmergencyManager';

export function ControlCenterVisibilityControllerTest() {

  describe('ControlCenterVisibilityControllerTest', (): void => {
    let mocker: MockKit;
    beforeAll((): void => {
      mocker = new MockKit();
    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {
      mocker.clearAll();
    })

    it('ControlCenterVisibilityControllerTest_001', 0, (): void => {
      EmergencyManager.getInstance().getData().desktopMode = DesktopModeEnum.EMERGENCY_MODE;
      ControlCenterVisibilityController.getVisibility(0, EmergencyManager.getInstance().getData());
      ControlCenterVisibilityController.getVisibility(1, EmergencyManager.getInstance().getData());
      EmergencyManager.getInstance().getData().desktopMode = DesktopModeEnum.BASE_MODE;
      let vis: Visibility = ControlCenterVisibilityController.getVisibility(1, EmergencyManager.getInstance().getData());
      expect(vis === Visibility.Visible).assertTrue();
    })

    it('ControlCenterVisibilityControllerTest_002', 0, (): void => {
      let vis1: Visibility = ControlCenterVisibilityController.getMediaCardVisibility(false, 0);
      expect(vis1 === Visibility.Hidden).assertTrue();
      let vis2: Visibility = ControlCenterVisibilityController.getMediaCardVisibility(false, 1);
      expect(vis2 === Visibility.Hidden).assertTrue();
      let vis3: Visibility = ControlCenterVisibilityController.getMediaCardVisibility(true, 1);
      expect(vis3 === Visibility.Visible).assertTrue();
      let vis4: Visibility = ControlCenterVisibilityController.getToggleRowVisibility(0);
      expect(vis4 === Visibility.Hidden).assertTrue();
      let vis5: Visibility = ControlCenterVisibilityController.getToggleRowVisibility(1);
      expect(vis5 === Visibility.Visible).assertTrue();
    })

  })
}


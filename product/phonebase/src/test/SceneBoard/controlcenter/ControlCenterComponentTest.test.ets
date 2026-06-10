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
  sToggleSubWindowController
} from '@ohos/systemuicommon/Index'
import { ControlCenterState } from '@ohos/controlcentercommon/Index';
import sControlCenterController
  from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/ControlCenterController'
import {
  sIOTSubPageLayoutController
} from '@ohos/controlcentercomponent/src/main/ets/com/ohos/controller/IOTSubPageLayoutController'
import { DropDownPanelManager } from '@ohos/systemuicommon/Index';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Size, Level } from '@ohos/hypium'

export function ControlCenterComponentTest() {
  describe('ControlCenterComponentTest', (): void => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {

    })

    it('sideClick', Level.LEVEL0, (): void => {
      let currentState: ControlCenterState = sControlCenterController.getData()?.state ?? ControlCenterState.MAIN_LAYOUT;
      if (currentState === ControlCenterState.IOT_SUB_PAGE) {
        sIOTSubPageLayoutController.onBackPress();
      } else if (currentState === ControlCenterState.SUB_PANEL) {
        sToggleSubWindowController.onBackPress();
      } else {
        DropDownPanelManager.animToDismiss();
      }

      expect(currentState).assertEquals(currentState);
    })

    it('verticalSlide', Level.LEVEL0, (): void => {
      if ((this.progress <= 1 && this.dropDownEvent.progress === 1)) {
        log.showInfo(`handleVerticalDropdown show panel: ${this.currentPanel}`);
        if (this.dropDownEvent.targetChanged !== TargetChangeState.HORIZONTAL) {
          this.animatePanelOpacity(true); // 到达展开阈值，面板出现动效
          performanceMonitor.begin('INTO_NC_ANI', performanceMonitor.ActionType.FIRST_MOVE);
        }
      }

      if (this.progress === 1 && this.dropDownEvent.progress < 1) {
        log.showInfo(`handleVerticalDropdown hide panel: ${this.currentPanel}`);
        if (this.currentPanel === TargetPanel.NOTIFICATION_PANEL) {
          this.animatePanelOpacity(false); // 到达收起阈值，面板消失动效
          performanceMonitor.begin('EXIT_NC_ANI', performanceMonitor.ActionType.FIRST_MOVE);
        }
      }
    })

    it('sideSlide', Level.LEVEL0, (): void => {
      let currentState: ControlCenterState = sControlCenterController.getData()?.state ?? ControlCenterState.MAIN_LAYOUT;
      log.showInfo(`currentState: ${currentState}`);
      if (currentState === ControlCenterState.IOT_SUB_PAGE) {
        sIOTSubPageLayoutController.onBackPress();
      } else if (currentState === ControlCenterState.SUB_PANEL) {
        sToggleSubWindowController.onBackPress();
      } else {
        DropDownPanelManager.animToDismiss();
      }
      expect(currentState).assertEquals(currentState);
    })
  })
}
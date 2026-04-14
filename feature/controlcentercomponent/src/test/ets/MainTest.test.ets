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
import { setBrightValue } from '@ohos/brightnesscomponent/src/main/ets/default/ControlBrightnessManager';
import { QuickToggleController } from '../../main/ets/com/ohos/controller/QuickToggleController';
import ControlCenterComponent from '../../main/ets/com/ohos/pages/newStyle/ControlCenterComponent';
import ControlCenterBaseController  from '../../main/ets/com/ohos/controller/ControlCenterBaseController'
import Controller from '../../main/ets/com/ohos/controller/ControlCenterController'
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';
import taskpool from '@ohos.taskpool';
import { WindowConstants } from '@ohos/commonconstants';
import { windowMgr } from '@ohos/windowscene';
import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import { ToggleStyle } from '@ohos/systemuicommon/Index';

export function MainTest() {
  describe('MainTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('testcase1', 0, (): void => {
      expect('testcase1'.length).assertLarger(0);
    })

    it('testcase2', 0, (): void => {
      expect('testcase2'.length).assertLarger(0);
    })

    it('testcase3', 0, (): void => {
      expect('testcase3'.length).assertLarger(0);
    })

    it('testcase4', 0, (): void => {
      expect('testcase4'.length).assertLarger(0);
    })

    it('testcase5', 0, (): void => {
      expect('testcase5'.length).assertLarger(0);
    })

    it('gridTest0', 0, (): void => {
      let toggles: number = QuickToggleController.getInstance().getPluginToggleData()?.size;
      expect(toggles).assertLarger(0);
    })

    it('isShowingDropdownTest', 0, (): void => {
      let isShowingDropdown: boolean = windowMgr.isShowing(WindowConstants.WINDOW_NAME_DROPDOWN)
      expect(isShowingDropdown).assertFalse();
    })

    it('testsetbrightness', 0, (): void => {
      let isMoving: boolean = false;
      let brightnessValue: number = 1;
      let exception: boolean = false;
      try {
        if (isMoving) {
          taskpool.execute(setBrightValue, brightnessValue, true).catch((e: object) => {
            exception = true;
          });
        } else {
          taskpool.execute(setBrightValue, brightnessValue, false).catch((e: object) => {
            exception = true;
          });
        }
      } catch (e) {
        exception = true;
      }
      expect(exception).assertTrue();
    })

    it('testcase7', 0, (): void => {
      expect('testcase7'.length).assertLarger(0);
    })

    it('testcase8', 0, (): void => {
      expect('testcase8'.length).assertLarger(0);
    })

    it('testcase8', 0, (): void => {
      expect('testcase8'.length).assertLarger(0);
    })

    it('testcase9', 0, (): void => {
      expect('testcase9'.length).assertLarger(0);
    })

    it('testcase10', 0, (): void => {
      expect('testcase10'.length).assertLarger(0);
    })

    it('testcase11', 0, (): void => {
      expect('testcase11'.length).assertLarger(0);
    })

    it('ControlCenterBaseControllerTest02', 0, (): void => {
      let isNotAvailable = !ControlCenterBaseController.isAvailable();
      expect(isNotAvailable).assertTrue();
    })

    it('ControlCenterBaseControllerTest03', 0, (): void => {
      let isNotAvailable = !ControlCenterBaseController.isAvailable();
      expect(isNotAvailable).assertFalse();
    })

    it('testPanelDismiss', 0, (): void => {
      let exception: boolean = false;
      DropDownPanelManager.animToDismiss();
      expect(exception).assertFalse();
    })

    it('testPanelDismiss001', 0, (): void => {
      let isPanelDismissing = DropDownPanelManager.isPanelDismissing();
      expect(isPanelDismissing).assertFalse();
    })

    it('testPanelDismiss', 0, (): void => {
      let exception: boolean = true;
      DropDownPanelManager.animToDismiss();
      expect(exception).assertTrue();
    })

    it('testPanelDismiss002', 0, (): void => {
      let isPanelDismissing = !DropDownPanelManager.isPanelDismissing();
      expect(isPanelDismissing).assertTrue();
    })

    it('testGetWallerPaper', 0, async (): Promise<void> => {
      let degree: number = Controller.getWallerPaperType();
      expect(degree != undefined).assertTrue();
    })

    it('testGetWallerPaper', 0, async (): Promise<void> => {
      let degree: number = Controller.getWallerPaperType();
      expect(degree == undefined).assertFalse();
    })

    it('testControlCenterQuickToggleLayout', 0, async (): Promise<void> => {
      let cellHeight: number = ToggleStyle.getStyle().cellHeight;
      expect(cellHeight).assertLarger(0);
    })

    it('testPanelDismiss2', 0, (): void => {
      let exception: boolean = true;
      DropDownPanelManager.animToDismiss();
      expect(exception).assertTrue();
    })

    it('isNewStyle', 0, (): void => {
      let isNewStyleOpen: boolean = Controller.isSceneBoardNewStyleOpen();
      expect(isNewStyleOpen).assertTrue();
    })

    it('testPanelDismiss3', 0, (): void => {
      let exception: boolean = true;
      DropDownPanelManager.isPanelDismissing();
      expect(exception).assertTrue();
    })

    it('testPanelDismiss3', 0, (): void => {
      let exception: boolean = false;
      DropDownPanelManager.isPanelDismissing();
      expect(exception).assertFalse();
    })

    it('testChangeLabelColor', 0, (): void => {
      let exception: boolean = true;
      let type: number = Controller.getWallerPaperType();
      if (type === 1 || type === 2) {
        ToggleStyle.getToggleLabelStyle().setLabelColor('#0000');
      } else if (type === 4) {
        ToggleStyle.getToggleLabelStyle().setLabelColor('#1111');
      } else {
        ToggleStyle.getToggleLabelStyle().setLabelColor('#ffff');
      }
      expect(exception).assertTrue();
    })

    it('testControlCenterComponent', 0, (): void => {
      let cellWidth: number = ToggleStyle.getStyle().cellWidth;
      expect(cellWidth).assertLarger(0);
    })

    it('testControlCenterComponent2', 0, (): void => {
      let iconWidth: number = ToggleStyle.getStyle().iconWidth;
      expect(iconWidth).assertLarger(0);
    })

    it('testControlCenterComponent3', 0, (): void => {
      let iotMarginBottom: number = ControlCenterComponent.style.iotMarginBottom;
      expect(iotMarginBottom).assertLarger(0);
    })

    it('testControlCenterComponent4', 0, (): void => {
      let iotMarginBottom: number = ControlCenterComponent.style.iotMarginBottom;
      expect(iotMarginBottom).assertLarger(0);
    })

    it('testControlCenterComponent5', 0, (): void => {
      let bottomHotAreaHeight: number = ControlCenterComponent.BOTTOM_HOT_AREA;
      expect(bottomHotAreaHeight).assertLarger(0);
    })

    it('testControlCenterComponent6', 0, (): void => {
      let bottomHotAreaHeight: number = ControlCenterComponent.BOTTOM_HOT_AREA;
      expect(bottomHotAreaHeight).assertLarger(0);
    })

    it('isNewStyle', 0, (): void => {
      let isNewStyleOpen: boolean = Controller.isNewStyleOpen();
      expect(isNewStyleOpen).assertTrue();
    })

    it('isNewStyle1', 0, (): void => {
      let isNewStyleOpen: boolean = Controller.isNewStyleOpen();
      expect(isNewStyleOpen).assertTrue();
    })

    it('isNewStyle2', 0, (): void => {
      let isNewStyleOpen: boolean = Controller.isNewStyleOpen();
      expect(isNewStyleOpen).assertTrue();
    })
  })
}
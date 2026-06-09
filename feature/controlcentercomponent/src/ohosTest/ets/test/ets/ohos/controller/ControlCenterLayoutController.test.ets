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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, MockKit, when } from '@ohos/hypium';
import { DeviceHelper, TargetPanel } from '@ohos/frameworkwrapper';
import { SCBScreenProperty, SCBScreenSessionManager } from '@ohos/windowscene';
import {
  ControlCenterLayoutController,
  ControlCenterLayoutIndex
} from '../../../../../../main/ets/com/ohos/controller/ControlCenterLayoutController';
import { default as DropDownPanelManager } from '@ohos/systemuicommon/src/main/ets/manager/DropDownPanelManager';

export function ControlCenterLayoutControllerTest() {
  let screenSessionManager: SCBScreenSessionManager;
  let controller: ControlCenterLayoutController;
  let prop: SCBScreenProperty;
  let layoutIndex: ControlCenterLayoutIndex;
  let mocker: MockKit;

  describe('ControlCenterLayoutControllerTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    })

    afterAll((): void => {
      mocker.clearAll();
    })

    beforeEach((): void => {
      screenSessionManager = SCBScreenSessionManager.getInstance();
      controller = ControlCenterLayoutController.getInstance();
      prop = {} as SCBScreenProperty;
      layoutIndex = controller.getCurrentIndex();
      controller.setLayoutChangeCallback('callbackTag', idx => {
        layoutIndex = idx;
      });


    })

    afterEach((): void => {
    })

    it('getInstanceTest001', 0, (): void => {
      expect(controller !== undefined).assertTrue();
      expect(controller !== null).assertTrue();
    })

    it('getInstanceTest002', 0, (): void => {
      // isFoldablePhoneExpandStatus mock测试
      expect(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()).assertFalse();

      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);
      when(foldStatus)().afterReturn(true);

      expect(SCBScreenSessionManager.getInstance().isFoldablePhoneExpandStatus()).assertTrue();
      mocker.clear(screenSessionManager);
    })

    it('getInstanceTest003', 0, (): void => {
      // isPad mock测试
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);

      when(isPad)().afterReturn(true);
      expect(DeviceHelper.isPad()).assertTrue();

      when(isPad)().afterReturn(false);
      expect(DeviceHelper.isPad()).assertFalse();
      mocker.clear(DeviceHelper);
    })

    it('updateLayoutIndex_FoldScreenExpand_Test001', 0, (): void => {
      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);

      // 展开态
      when(foldStatus)().afterReturn(true);

      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      mocker.clear(screenSessionManager);
    })

    it('updateLayoutIndex_FoldScreenExpand_Test002', 0, (): void => {
      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);

      // 展开态
      when(foldStatus)().afterReturn(true);

      // 旋转90度
      prop.rotation = 90;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);

      // 旋转180度
      prop.rotation = 180;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);

      // 旋转270度
      prop.rotation = 270;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);

      // 旋转360度
      prop.rotation = 360;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.FOLD_EXPANDED);
      mocker.clear(screenSessionManager);
    })

    it('updateLayoutIndex_FoldScreenFolded_Test001', 0, (): void => {
      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);

      // 屏幕折叠
      when(foldStatus)().afterReturn(false);

      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      mocker.clear(screenSessionManager);
    })

    it('updateLayoutIndex_FoldScreenFolded_Test002', 0, (): void => {
      let foldStatus = mocker.mockFunc(screenSessionManager, screenSessionManager.isFoldablePhoneExpandStatus);

      // 屏幕折叠
      when(foldStatus)().afterReturn(false);

      // 旋转90度
      prop.rotation = 90;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_LANDSCAPE);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_LANDSCAPE);

      // 旋转180度
      prop.rotation = 180;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);

      // 旋转270度
      prop.rotation = 270;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_LANDSCAPE);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_LANDSCAPE);

      // 旋转360度
      prop.rotation = 360;
      (controller as object)['updateLayoutIndex'](prop);
      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.NORMAL_PORTRAIT);
      mocker.clear(screenSessionManager);
    })

    it('updateLayoutIndex_Pad_Test001', 0, (): void => {
      // 设备类型置为pad
      let isPad = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(isPad)().afterReturn(true);

      controller = new ControlCenterLayoutController();
      controller.setLayoutChangeCallback('callbackTag', idx => {
        layoutIndex = idx;
      });

      expect(layoutIndex).assertEqual(ControlCenterLayoutIndex.PAD);
      expect(controller.getCurrentIndex()).assertEqual(ControlCenterLayoutIndex.PAD);
      mocker.clear(DeviceHelper);
    })

    it('ControlCenterLayoutControllerTest_showControlCenter', 0, ():void=>{
      DropDownPanelManager.animToShow(TargetPanel.CONTROL_CENTER_PANEL);
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
      DropDownPanelManager.animToDismiss();
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
    })

    it('ControlCenterLayoutControllerTest_showNtf', 0, ():void=>{
      DropDownPanelManager.animToShow(TargetPanel.NOTIFICATION_PANEL);
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
      DropDownPanelManager.animToDismiss();
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
    })

    it('ControlCenterLayoutControllerTest_showControlCenter02', 0, ():void=>{
      DropDownPanelManager.showWindowDirectly(TargetPanel.CONTROL_CENTER_PANEL);
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
      DropDownPanelManager.hideWindowDirectly();
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
    })

    it('ControlCenterLayoutControllerTest_showNtf02', 0, ():void=>{
      DropDownPanelManager.showWindowDirectly(TargetPanel.NOTIFICATION_PANEL);
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
      DropDownPanelManager.hideWindowDirectly();
      expect(DropDownPanelManager.getScreenInfo().width >= 0).assertTrue();
    })
  })
}
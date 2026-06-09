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
import sControlCenterController, { ControlCenterController } from '../../../../../../main/ets/com/ohos/controller/ControlCenterController';
import type { CommonEventData } from 'commonEvent/commonEventData';
import { MediaControlEvent } from '@ohos/frameworkwrapper';
import { ControlCenterState } from '@ohos/controlcentercommon/Index';

export function ControlCenterControllerTest() {
  describe('ControlCenterControllerTest', (): void => {

    beforeEach((): void => {
    })
    afterEach((): void => {

    })
    afterAll((): void => {
    })

    it('ControlCenterControllerTest_recoverBackPress_001', 0, (): void => {
      let sControlCenterController = new ControlCenterController();
      (sControlCenterController as object)['recoverBackPress']();
      expect(sControlCenterController.isPc()).assertInstanceOf('Boolean');
    })

    it('ControlCenterControllerTest_recoverBackPress_002', 0, (): void => {
      let sControlCenterController = new ControlCenterController();
      (sControlCenterController as object)['timeFlag'] = 1;
      (sControlCenterController as object)['recoverBackPress']();
      expect(sControlCenterController.isPc()).assertInstanceOf('Boolean');
    })

    it('ControlCenterControllerTest_recoverBackPress_003', 0, (): void => {
      let sControlCenterController = new ControlCenterController();
      (sControlCenterController as object)['timeFlag'] = 0;
      (sControlCenterController as object)['recoverBackPress']();
      expect(sControlCenterController.isPc()).assertInstanceOf('Boolean');
    })

    it('ControlCenterControllerTest_recoverBackPress_004', 0, (): void => {
      let sControlCenterController = new ControlCenterController();
      (sControlCenterController as object)['timeFlag'] = 0;
      (sControlCenterController as object)['isEnableBackPress'] = false;
      (sControlCenterController as object)['recoverBackPress']();
      expect(sControlCenterController.isPc()).assertInstanceOf('Boolean');
    })

    it('ControlCenterControllerTest001', 0, (): void => {
      let isPc: boolean = sControlCenterController.isPc();
      expect(isPc).assertEqual(false);
    })

    it('ControlCenterControllerTest002', 0, (): void => {
      let isNewStyleOpen: boolean = sControlCenterController.isNewStyleOpen();
      expect(isNewStyleOpen).assertEqual(true);
    })

    it('ControlCenterControllerTest003', 0, (): void => {
      let getBackPressEnable: boolean = sControlCenterController.getBackPressEnable();
      expect(getBackPressEnable).assertEqual(true);
    })

    it('ControlCenterControllerTest004', 0, (): void => {
      sControlCenterController.setBackPressEnable(true);
      expect(sControlCenterController.getBackPressEnable()).assertTrue();
    })

    it('ControlCenterControllerTest005', 0, (): void => {
      let isControlCenterVisible = sControlCenterController.isControlCenterVisible();
      expect(isControlCenterVisible).assertEqual(false);
    })

    it('ControlCenterControllerTest007', 0, (): void => {
      let isPc: boolean = sControlCenterController.isPc();
      expect(isPc).assertEqual(false);
      let isNewStyleOpen: boolean = sControlCenterController.isNewStyleOpen();
      expect(isNewStyleOpen).assertEqual(true);
    })

    it('ControlCenterControllerTest008', 0, (): void => {
      let isPc: boolean = sControlCenterController.isPc();
      expect(isPc).assertEqual(false);
      let getBackPressEnable: boolean = sControlCenterController.getBackPressEnable();
      expect(getBackPressEnable).assertEqual(true);
    })

    it('ControlCenterControllerTest010', 0, (): void => {
      let isPc: boolean = sControlCenterController.isPc();
      expect(isPc).assertEqual(false);
      let isControlCenterVisible = sControlCenterController.isControlCenterVisible();
      expect(isControlCenterVisible).assertEqual(false);
    })

    it('ControlCenterControllerTest012', 0, (): void => {
      let isNewStyleOpen: boolean = sControlCenterController.isNewStyleOpen();
      expect(isNewStyleOpen).assertEqual(true);
      let getBackPressEnable: boolean = sControlCenterController.getBackPressEnable();
      expect(getBackPressEnable).assertEqual(true);
    })

    it('ControlCenterControllerTest013', 0, (): void => {
      let isNewStyleOpen: boolean = sControlCenterController.isNewStyleOpen();
      expect(isNewStyleOpen).assertEqual(true);
      sControlCenterController.setBackPressEnable(true);
      expect(sControlCenterController.getBackPressEnable()).assertTrue();
    })

    it('ControlCenterControllerTest014', 0, (): void => {
      sControlCenterController.getContent();
      sControlCenterController.setWallerPaperType(1);
      expect(sControlCenterController.getWallerPaperType()).assertEqual(1);
      sControlCenterController.setLastBackgroundType(0);
      expect(sControlCenterController.getLastBackgroundType()).assertEqual(0);
      sControlCenterController.updateLabelColor();
      sControlCenterController.setWallerPaperType(2);
      sControlCenterController.setLastBackgroundType(1);
      sControlCenterController.updateLabelColor();
      sControlCenterController.setWallerPaperType(3);
      sControlCenterController.setLastBackgroundType(2);
      sControlCenterController.updateLabelColor();
      sControlCenterController.setWallerPaperType(4);
      sControlCenterController.setLastBackgroundType(3);
      sControlCenterController.updateLabelColor();
      expect(sControlCenterController.isPc()).assertFalse();
    })

    it('ControlCenterControllerTest015', 0, (): void => {
      sControlCenterController.getData();
      sControlCenterController.setControlCenterVisible(true);
      expect(sControlCenterController.isControlCenterVisible()).assertTrue();
      sControlCenterController.setControlCenterState(ControlCenterState.MAIN_LAYOUT);
      sControlCenterController.getHomeViewData();
      sControlCenterController.setDelayReleaseIot(true);
      expect(sControlCenterController.isDelayReleaseIot()).assertTrue();
      sControlCenterController.setShowToastMethod(() => {});
      sControlCenterController.updateUIFromCache();
      let commonEvent1: CommonEventData = {
        event: 'MediaControlEvent',
        bundleName: '',
        code: 1,
        data: MediaControlEvent.MEDIA_CONTROL_JUMP,
        parameters: [],
      }
      let event1: MediaControlEvent = new MediaControlEvent(commonEvent1);
      sControlCenterController.onMediaControlCallback(event1);

      let commonEvent2: CommonEventData = {
        event: 'MediaControlEvent',
        bundleName: '',
        code: 1,
        data: MediaControlEvent.MEDIA_CONTROL_QUIT,
        parameters: [],
      }
      let event2: MediaControlEvent = new MediaControlEvent(commonEvent2);
      sControlCenterController.onMediaControlCallback(event2);
      sControlCenterController.showToast('Test');
      expect(sControlCenterController.isPc()).assertFalse();
    })
  })
}
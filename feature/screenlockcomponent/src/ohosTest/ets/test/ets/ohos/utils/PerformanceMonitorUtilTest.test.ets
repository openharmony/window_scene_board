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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium';
import PerformanceMonitorUtil, {
  LockscreenEditStatusParams
} from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';
import { ReportParams } from '@ohos/frameworkwrapper';
import LockscreenEditWeekParams from '@ohos/screenlockcommon/src/main/ets/record/report/PerformanceMonitorUtil';

import osAccount from '@ohos.account.osAccount';

export default function PerformanceMonitorUtilTest() {

  describe('PerformanceMonitorUtilTest', (): void => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_reportBehaviorEvent_return', 0, (): void => {
      let name: string = 'res';
      let params: LockscreenEditStatusParams = {
        PNAMEID: 'res1',
        PVERSIONID: 'res2'
      };
      PerformanceMonitorUtil.reportBehaviorEvent(name, params);
      expect(params.PNAMEID).assertEqual(ReportParams.PACKAGE_NAME);
    })

    it('test_reportStatisticEvent_return', 0, (): void => {
      let name: string = 'res1';
      let params: LockscreenEditStatusParams = {
        PNAMEID: 'res1',
        PVERSIONID: 'res2'
      };
      PerformanceMonitorUtil.reportStatisticEvent(name, params);
      expect(params.PVERSIONID).assertEqual(ReportParams.PROCESS_NAME);
    })

    it('test_setFrameRateMoStart_return_one', 0, (): void => {
      let isFaceUnlockSwitchOpen: boolean = false;
      PerformanceMonitorUtil.setFrameRateMoStart(0, isFaceUnlockSwitchOpen);
      expect(PerformanceMonitorUtil.COLOR).assertEqual('color');
    })

    it('test_setFrameRateMoStart_return_two', 0, (): void => {
      let authType: osAccount.AuthType = osAccount.AuthType.PIN;
      PerformanceMonitorUtil.setFrameRateMoStart(authType);
      expect(PerformanceMonitorUtil.COLOR).assertEqual('color');
    })

    it('test_setFrameRateMoStart_return_three', 0, (): void => {
      let isFaceUnlockSwitchOpen: boolean = true;
      PerformanceMonitorUtil.setFrameRateMoStart(0, isFaceUnlockSwitchOpen);
      expect(PerformanceMonitorUtil.COLOR).assertEqual('color');
    })

    it('test_setFrameRateMoEnd_return_one', 0, (): void => {
      let authType: osAccount.AuthType = osAccount.AuthType.PIN;
      PerformanceMonitorUtil.setFrameRateMoEnd(authType);
      expect(PerformanceMonitorUtil.COLOR).assertEqual('color');
    })

    it('test_setFrameRateMoEnd_return_two', 0, (): void => {
      let isFaceUnlockSwitchOpen: boolean = true;
      PerformanceMonitorUtil.setFrameRateMoEnd(0, isFaceUnlockSwitchOpen);
      expect(PerformanceMonitorUtil.COLOR).assertEqual('color');
    })

    it('test_setFrameRateMoEnd_return_three', 0, (): void => {
      let isFaceUnlockSwitchOpen: boolean = false;
      PerformanceMonitorUtil.setFrameRateMoEnd(0, isFaceUnlockSwitchOpen);
      expect(PerformanceMonitorUtil.COLOR).assertEqual('color');
    })

    it('test_setScreenSleepMoStart_return', 0, (): void => {
      let editApplyParams: LockscreenEditApplyParams = new LockscreenEditApplyParams();
      let newClockConfig: TimePosition = { positionX: 0, positionY: 0 };
      let formId: string = '1';
      let packageName: string = 'name1';
      let cardDimension: string = 'card1';
      let moduleName: string = 'modulename1';
      let formName: string = 'forname1';
      PerformanceMonitorUtil.setScreenSleepMoStart();
      PerformanceMonitorUtil.setScreenSleepMoEnd();
      PerformanceMonitorUtil.setPinchGestureMoStart();
      PerformanceMonitorUtil.setPinchGestureMoEnd();
      PerformanceMonitorUtil.setOutScreenLockEditorMoStart();
      PerformanceMonitorUtil.setOutScreenLockEditorMoEnd();
      PerformanceMonitorUtil.reportLockscreenEditApply(editApplyParams, newClockConfig);
      PerformanceMonitorUtil.reportLockscreenEditCancel();
      PerformanceMonitorUtil.reportLockscreenEditCardAdd(formId, packageName, cardDimension, moduleName, formName);
      PerformanceMonitorUtil.reportLockscreenEditCardRemove(formId, packageName, cardDimension, moduleName, formName);
      let params: LockscreenEditStatusParams = {
        FORMID: formId,
        PACKAGENAME: packageName,
        CARDDIMENSION: cardDimension,
        MODULENAME: moduleName,
        FORMNAME: formName,
      };
      expect(params.FORMID).assertEqual('1');
    })

    it('test_reportLockscreenEditClearLook_return', 0, (): void => {
      let editorName: string = 'res';
      let quitMethod: string = 'res1';
      PerformanceMonitorUtil.reportLockscreenEditClearLook(editorName, quitMethod);
      let params: LockscreenEditStatusParams = {
        EDITOR_NAME: editorName,
        QUIT_METHOD: quitMethod,
      };
      expect(params.EDITOR_NAME).assertEqual('res');
    })

    it('test_reportLockscreenEditMoreCardAdd_return', 0, (): void => {
      let formId: string = '1';
      let packageName: string = 'name1';
      let cardDimension: string = 'card1';
      let moduleName: string = 'modulename1';
      let formName: string = 'forname1';
      PerformanceMonitorUtil.reportLockscreenEditMoreCardAdd(formId, packageName, cardDimension, moduleName, formName);
      let params: LockscreenEditStatusParams = {
        FORMID: formId,
        PACKAGE_NAME: packageName,
        CARDDIMENSION: cardDimension,
        MODULENAME: moduleName,
        FORMNAME: formName
      };
      expect(params.FORMID).assertEqual('1');
    })

    it('test_reportLockscreenEditMoreCard_return', 0, (): void => {
      let packageName: string = 'res';
      PerformanceMonitorUtil.reportLockscreenEditMoreCard(packageName);
      let params: LockscreenEditStatusParams = {
        PACKAGE_NAME: packageName
      };
      expect(params.PACKAGE_NAME).assertEqual('res');
    })

    it('test_reportLockscreenEditServiceWidgets_return', 0, (): void => {
      PerformanceMonitorUtil.reportLockscreenEditServiceWidgets();
      PerformanceMonitorUtil.reportLockscreenEditTwoFingerPinch();
      let openName: string = 'res';
      let signatureLength: string = '3';
      PerformanceMonitorUtil.reportLockscreenEditSignInputOk(openName, signatureLength);
      let params: LockscreenEditStatusParams = {
        OPER_NAME: openName,
        SIGNATURE_LENGTH: signatureLength
      };
      expect(params.OPER_NAME).assertEqual(openName);
    })

    it('test_reportLockscreenEditStatus_return', 0, (): void => {
      PerformanceMonitorUtil.reportLockscreenEditSignInput();
      let itemName: string = 'res1';
      let layoutName: string = 'res2';
      PerformanceMonitorUtil.reportLockscreenEditStatus(itemName, layoutName);
      let params: LockscreenEditStatusParams = {
        ITEM_NAME: itemName,
        ITEM_INDEX: layoutName,
      };
      expect(params.ITEM_NAME).assertEqual(itemName);
    })
  })
}
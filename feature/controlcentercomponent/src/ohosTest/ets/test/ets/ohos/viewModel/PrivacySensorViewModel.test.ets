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

import { afterAll, afterEach, beforeEach, it, describe, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { PrivacySensorViewData } from '../../../../../../main/ets/com/ohos/model/PrivacySensorViewData';
import { PrivacySensorViewModel } from '../../../../../../main/ets/com/ohos/viewModel/PrivacySensorViewModel';
import privacyIndicatorManager from '@hms.security.privacyIndicatorManager';
import { ConfigurationEvent } from '@ohos/frameworkwrapper';
import { bundleManager } from '@kit.AbilityKit';
import { AccessibilityUtil } from '@ohos/screenlockcommon/src/main/ets/utils/AccessibilityUtil';


export function PrivacySensorViewModelTest() {

  describe('PrivacySensorViewModelTest', (): void => {

    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('PrivacySensorViewModelInitData', 0, (): void => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      viewMode.initData();
      expect(viewData.isApplicationInterview !== undefined).assertTrue();
    })

    it('PrivacySensorViewModelWashData', 0, (): void => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      let PrivacyEventDetail: privacyIndicatorManager.PrivacyEventDetail[] = [];
      viewMode.washData(PrivacyEventDetail);
      let realCameraString =
        '{"bundleName":"com.ohos.camera","uid":20020032,"privacySensorType":0,"startTimestamp":1721965996459,"realEndTimestamp":0,"showEndTimestamp":0,"realAccessState":1,"showAccessState":1}';
      let realCameraDetail: privacyIndicatorManager.PrivacyEventDetail = JSON.parse(realCameraString);
      PrivacyEventDetail.push(realCameraDetail);
      viewMode.washData(PrivacyEventDetail);
      expect(PrivacyEventDetail.length > 0).assertTrue();
    })

    it('PrivacySensorViewModelUpdateData', 0, (): void => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      let PrivacyEventDetailArray: privacyIndicatorManager.PrivacyEventDetail[] = []
      let realCameraString =
        '{"bundleName":"com.ohos.camera","uid":20020032,"privacySensorType":0,"startTimestamp":1721965996459,"realEndTimestamp":0,"showEndTimestamp":0,"realAccessState":1,"showAccessState":1}';
      let justCameraString =
        '{"bundleName":"com.ohos.camera","uid":20020032,"privacySensorType":0,"startTimestamp":1721966436482,"realEndTimestamp":1721966442870,"showEndTimestamp":1721966443071,"realAccessState":2,"showAccessState":2}'
      let realCameraDetail: privacyIndicatorManager.PrivacyEventDetail = JSON.parse(realCameraString);
      let justCameraDetail: privacyIndicatorManager.PrivacyEventDetail = JSON.parse(justCameraString);
      PrivacyEventDetailArray.push(realCameraDetail);
      PrivacyEventDetailArray.push(justCameraDetail);
      viewMode.updateData(PrivacyEventDetailArray);
      expect(viewData.privacySensorTypeArray.length > 0).assertTrue();
    })

    it('PrivacySensorLanguageChangeTest', 0, (): void => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      viewMode.languageChangeListener(new ConfigurationEvent());
      expect(viewData.isRTL != undefined).assertTrue();
    })

    it('PrivacySensorViewModelResetData', 0, (): void => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      viewMode.resetData();
      expect(viewData.isApplicationInterview).assertFalse();
    })

    it('GetPrivacySensorText', 0, (): void => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      let PrivacyEventDetailArray: privacyIndicatorManager.PrivacyEventDetail[] = []
      let realCameraString =
        '{"bundleName":"com.ohos.camera","uid":20020032,"privacySensorType":0,"startTimestamp":1721965996459,"realEndTimestamp":0,"showEndTimestamp":0,"realAccessState":1,"showAccessState":1}';
      let realMicString =
        '{"bundleName":"com.ohos.screenrecorder","uid":20020134,"privacySensorType":1,"startTimestamp":1721974973835,"realEndTimestamp":0,"showEndTimestamp":0,"realAccessState":1,"showAccessState":1}';
      let realLocalString =
        '{"bundleName":"com.ohos.maps.app","uid":20020038,"privacySensorType":2,"startTimestamp":1721975566708,"realEndTimestamp":0,"showEndTimestamp":0,"realAccessState":1,"showAccessState":1}';

      let cameraDetail: privacyIndicatorManager.PrivacyEventDetail = JSON.parse(realCameraString);
      let micDetail: privacyIndicatorManager.PrivacyEventDetail = JSON.parse(realMicString);
      let localDetail: privacyIndicatorManager.PrivacyEventDetail = JSON.parse(realLocalString);
      PrivacyEventDetailArray.push(cameraDetail);
      PrivacyEventDetailArray.push(micDetail);
      PrivacyEventDetailArray.push(localDetail);
      viewMode.updateData(PrivacyEventDetailArray);
      viewMode.getPrivacySensorText('maps');
      expect(PrivacyEventDetailArray.length > 0).assertTrue();
    })

    it("PrivacySensorViewModelTest_getDeliverBundleInfo", 0, async (done: Function) => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      let result: bundleManager.BundleInfo | null = await (viewMode as object)['getDeliverBundleInfo']('catch');
      expect(result).assertNull();
      let result1: bundleManager.BundleInfo | null =
        await (viewMode as object)['getDeliverBundleInfo']('com.deliver.appstore.lite');
      expect(result1).assertNull();
      done();
    })

    it("PrivacySensorViewModelTest_getDeliverApplicationLabel", 0, async (done: Function) => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      let result: string = await (viewMode as object)['getDeliverApplicationLabel'](null ,'');
      expect(result).assertEqual('');
      done();
    })

    it("PrivacySensorViewModelTest_getPrivacySensorText_1", 0, async (done: Function) => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      (viewMode as object)['getDeliverBundleInfoLabel'](null ,'');
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      expect(viewMode.getPrivacySensorText('')).assertEqual('');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      viewMode.getPrivacySensorText('App');
      expect(viewMode.getPrivacySensorText('')).assertEqual('');
      mocker.clear(AccessibilityUtil);
      done();
    })

    it("PrivacySensorViewModelTest_getPrivacySensorText_2", 0, async (done: Function) => {
      let viewData = new PrivacySensorViewData();
      let viewMode = PrivacySensorViewModel.getInstance(viewData);
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(AccessibilityUtil, AccessibilityUtil.isAccessibilityMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      viewMode.getPrivacySensorText('App');
      expect(viewMode.getPrivacySensorText('')).assertEqual('');
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      viewMode.getPrivacySensorText('App');
      expect(viewMode.getPrivacySensorText('')).assertEqual('');
      mocker.clear(AccessibilityUtil);
      done();
    })
  })
}
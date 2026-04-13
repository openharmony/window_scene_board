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
import { CommonUtils } from '@ohos/basicutils';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { ImmersiveNormalCapsuleData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNormalCapsuleData';

export function ImmersiveNormalCapsuleDataTest() {
  describe('ImmersiveNormalCapsuleDataTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('test_construct', Level.LEVEL1, (): void => {
      let normalcapsuledata = new ImmersiveNormalCapsuleData();
      expect(normalcapsuledata).not().assertNull();
    });

    it('test_createAndClearGroup', Level.LEVEL1, (): void => {
      let normalcapsuledata = new ImmersiveNormalCapsuleData();
      let child_data = new ImmersiveNormalCapsuleData();
      normalcapsuledata.createGroup();
      normalcapsuledata.addChildData(child_data);
      normalcapsuledata.deleteGroup();
      expect(normalcapsuledata).not().assertNull();
    });

    it('test_update', Level.LEVEL1, (): void => {
      let normalcapsuledata = new ImmersiveNormalCapsuleData();
      let child_data = new ImmersiveNormalCapsuleData();
      normalcapsuledata.update(child_data, undefined);
      normalcapsuledata.update(child_data, true);
      normalcapsuledata.auxiliaryData = undefined;
      normalcapsuledata.update(child_data, false);
      expect(normalcapsuledata).not().assertNull();
    });

    it('test_setAllContent', Level.LEVEL1, (): void => {
      let normalcapsuledata = new ImmersiveNormalCapsuleData();
      normalcapsuledata.setNtfHide(true);
      normalcapsuledata.setNtfHide(false);
      normalcapsuledata.setHashCode(undefined, true);
      normalcapsuledata.setHashCode('myhashcode', undefined);
      normalcapsuledata.setIcon(undefined, true);
      normalcapsuledata.setMainText(undefined, true);
      normalcapsuledata.setMainText('mymaintext', false);
      normalcapsuledata.setAssistantText(undefined, true);
      normalcapsuledata.setAssistantText('assistanttext', false);
      expect(normalcapsuledata).not().assertNull();
    });

    it('test_getAllContent', Level.LEVEL1, (): void => {
      let normalcapsuledata = new ImmersiveNormalCapsuleData();
      normalcapsuledata.getAppIcon();
      normalcapsuledata.getAppName();
      normalcapsuledata.toString();
      normalcapsuledata.onAppIconChange();
      normalcapsuledata.onUpdateAppName('myappname');
      expect(normalcapsuledata).not().assertNull();
    });

    it('test_setOverlayIcon', Level.LEVEL1, (): void => {
      let normalcapsuledata = new ImmersiveNormalCapsuleData();
      normalcapsuledata.setOverlayIcon(undefined, true);
      expect(normalcapsuledata).not().assertNull();
    });

    it('test_setOverlayIcon', Level.LEVEL1, (): void => {
      let normalcapsuledata = new ImmersiveNormalCapsuleData();
      let child_data = new ImmersiveNormalCapsuleData();
      let mocker: MockKit = new MockKit();
      let mockFun1: Function = mocker.mockFunc(CommonUtils,CommonUtils.isInvalid)
      when(mockFun1)(undefined).afterReturn(false);
      normalcapsuledata.update(child_data, false);
      expect(normalcapsuledata).not().assertNull();
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

  });
}
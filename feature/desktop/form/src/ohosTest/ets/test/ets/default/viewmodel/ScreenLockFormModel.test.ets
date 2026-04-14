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

import { SCBScreenSessionManager } from '@ohos/windowscene';
import image from '@ohos.multimedia.image';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  TestType,
  Level,
  MockKit,
  when,
} from '@ohos/hypium';
import ScreenLockFormModel from '../../../../../../main/ets/default/viewmodel/ScreenLockFormModel';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { CardItemInfo } from '@ohos/launchercommon';

const FORM_LOCATION_KEY = 'ohos.extra.param.key.form_location';
const SCREEN_LOCK_KEY: number = 6;

export function ScreenLockFormModelTest() {
  describe('ScreenLockFormModelTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('getScreenLockWant', TestType.FUNCTION | Level.LEVEL0, () => {
      let screenFormModel: ScreenLockFormModel = new ScreenLockFormModel();
      let want: Want = screenFormModel.getScreenLockWant();
      expect(want.parameters?.[FORM_LOCATION_KEY]).assertEqual(SCREEN_LOCK_KEY);
    });

    it('ScreenLockFormModelTest_001', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(SCBScreenSessionManager, SCBScreenSessionManager.getInstance);
      when(mockFunc)().afterReturn({
        isScreenVertical() {
          throw new Error('mock error');
        }
      });
      let screenFormModel: ScreenLockFormModel = new ScreenLockFormModel();
      expect(screenFormModel.getGridWidth() === 0).assertTrue();
      mocker.clear(SCBScreenSessionManager);
      mocker.clearAll();
    });

    it('ScreenLockFormModelTest_002', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      when(mockFunc)().afterReturn(true);
      let screenFormModel: ScreenLockFormModel = new ScreenLockFormModel();
      expect(screenFormModel.getGridWidth() === undefined).assertFalse();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('ScreenLockFormModelTest_003', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mocker2: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockFunc3: Function = mocker.mockFunc(SCBScreenSessionManager, SCBScreenSessionManager.getInstance);
      when(mockFunc)().afterReturn(false);
      when(mockFunc2)().afterReturn(true);
      when(mockFunc3)().afterReturn({
        isScreenVertical() {
          return true;
        }
      });
      let screenFormModel: ScreenLockFormModel = new ScreenLockFormModel();
      expect(screenFormModel.getGridWidth() === undefined).assertFalse();
      mocker.clear(DeviceHelper);
      mocker2.clear(SCBScreenSessionManager);
      mocker.clearAll();
      mocker2.clearAll();
    });

    it('ScreenLockFormModelTest_004', TestType.FUNCTION | Level.LEVEL0, () => {
      let mocker: MockKit = new MockKit();
      let mocker2: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldExpanded);
      let mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      let mockFunc3: Function = mocker.mockFunc(SCBScreenSessionManager, SCBScreenSessionManager.getInstance);
      when(mockFunc)().afterReturn(false);
      when(mockFunc2)().afterReturn(true);
      when(mockFunc3)().afterReturn({
        isScreenVertical() {
          return false;
        }
      });
      let screenFormModel: ScreenLockFormModel = new ScreenLockFormModel();
      expect(screenFormModel.getGridWidth() === undefined).assertFalse();
      mocker.clear(DeviceHelper);
      mocker2.clear(SCBScreenSessionManager);
      mocker.clearAll();
      mocker2.clearAll();
    });

    it('ScreenLockFormModelTest_005', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let card = new CardItemInfo();
        let screenFormModel: ScreenLockFormModel = new ScreenLockFormModel();
        expect(screenFormModel.onDragStart(card) === undefined).assertFalse();
        let imageSrc: image.PixelMap = image.createPixelMapSync(new ArrayBuffer(4), { pixelFormat: 3, size: { height: 1, width: 1 } });
        expect(screenFormModel.onDragStart(card, imageSrc, {x: 10, y: 10}) === undefined).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('ScreenLockFormModelTest_006', TestType.FUNCTION | Level.LEVEL0, () => {
      let screenFormModel: ScreenLockFormModel = new ScreenLockFormModel();
      expect(screenFormModel.onDragEnd() === undefined).assertTrue();

    });

    it('ScreenLockFormModelTest_007', TestType.FUNCTION | Level.LEVEL0, () => {
      try {
        let card = new CardItemInfo();
        let screenFormModel: ScreenLockFormModel = new ScreenLockFormModel();
        expect(screenFormModel.onClick(card, 1, 'aaa') === undefined).assertFalse();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });
  })
}
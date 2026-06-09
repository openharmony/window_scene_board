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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  TestType,
  Size,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { recentDisplayManager } from '../../../../../../main/ets/default/common/RecentDisplayManager';
import { CommonUtils } from '@ohos/basicutils';
import { CutoutEvent, ViewArea } from '@ohos/frameworkwrapper';

export function RecentDisplayManagerTest() {
  describe('RecentDisplayManagerTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('RecentDisplayManager_test_getInstance', TestType.USER | Size.SMALLTEST | Level.LEVEL0, (): void => {
      expect(recentDisplayManager).not().assertFail();
    })

    it('test_getCutoutHeight_01', 0, (): void => {
      let rect: ViewArea = {
        left: 0,
        top: 0,
        width: 100,
        height: 100
      };
      (recentDisplayManager as object)['cutouts'].set(CutoutEvent.CUTOUT_LEFT, rect);
      expect(recentDisplayManager.getCutoutHeight()).assertLess(34);
    })

    it('test_getCutoutHeight_02', 0, (): void => {
      let rect: ViewArea = {
        left: 0,
        top: 0,
        width: 100,
        height: 0
      };
      (recentDisplayManager as object)['cutouts'].set(CutoutEvent.CUTOUT_LEFT, rect);
      expect(recentDisplayManager.getCutoutHeight()).assertLess(34);
    })

    it('test_getRefreshRate_01', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let isInvalid: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(isInvalid)(ArgumentMatchers.any).afterReturn(true);
      let getRefreshRate = recentDisplayManager.getRefreshRate();
      expect(getRefreshRate).assertEqual(120);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    })

    it('test_getRefreshRate_02', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let isInvalid: Function = mocker.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(isInvalid)(ArgumentMatchers.any).afterReturn(false);
      expect(recentDisplayManager.getRefreshRate()).assertEqual(120);
      mocker.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    })
  })
}
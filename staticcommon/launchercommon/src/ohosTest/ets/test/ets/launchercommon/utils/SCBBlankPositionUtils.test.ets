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

import { DeviceHelper } from '@ohos/frameworkwrapper';
import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import LayoutDescription from '../../../../../../main/ets/bean/LayoutDescription';
import { LaunchLayoutCacheManager } from '../../../../../../main/ets/cache/layout/LaunchLayoutCacheManager';
import { layoutLockUtil } from '../../../../../../main/ets/utils/LayoutLockUtil';
import { DesktopPosition, scbBlankPositionUtils } from '../../../../../../main/ets/utils/SCBBlankPositionUtils';

export default function SCBBlankPositionUtilsTest() {
  describe('SCBBlankPositionUtilsTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })

    it('getFindBlankStartPage', Level.LEVEL0, (): void => {
      let mocker: MockKit = new MockKit();
      let isSuperFoldMachineFun = mocker.mockFunc(DeviceHelper, DeviceHelper.isSuperFoldMachine);
      when(isSuperFoldMachineFun)().afterReturn(false);

      let mockerFun = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldAndSingleDisplay);
      when(mockerFun)().afterReturn(false);

      let isLockedFun = mocker.mockFunc(layoutLockUtil, layoutLockUtil.isLocked);
      when(isLockedFun)().afterReturn(false);

      let isOuter = false;
      let maxPage = 18;
      let startPage = scbBlankPositionUtils.getFindBlankStartPage(maxPage, isOuter);
      expect(startPage).assertEqual(1);

      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('findBlankPosition_true1', Level.LEVEL0, (): void => {
      let isOuter = false;
      let mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(scbBlankPositionUtils,
        scbBlankPositionUtils.getFindBlankStartPage);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(1);

      let desktopPosition: DesktopPosition = scbBlankPositionUtils.findBlankPosition(isOuter);
      expect(desktopPosition.isFind).assertTrue();

      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })
  })
}

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

import { FileUtils } from '@ohos/basicutils';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { AppItemInfo } from '@ohos/launchercommon/src/main/ets/TsIndex';
import { OuterIconCenterViewModel } from '@ohos/launchercommon/src/main/ets/outerdesktop/viewmodel/OutIconCenterViewModel';

/**
 * OutIconCenterViewModel 单元测试用例
 */
export function OutIconCenterViewModelTest() {
  describe('OutIconCenterViewModelTest', (): void => {
    beforeAll(() => {
    })

    beforeEach(() => {
    })

    afterEach(() => {
    })

    afterAll(() => {
    })

    it('test_getAppInfoList', Level.LEVEL0, () => {
      const instance = OuterIconCenterViewModel.getInstance();
      let allAppPkgList: AppItemInfo[] = instance.getAppInfoList();
      expect(allAppPkgList).not().assertNull();
    })

    it('test_getTopQualityPkgList', Level.LEVEL0, () => {
      const instance = OuterIconCenterViewModel.getInstance();
      let topQualityPkgList: AppItemInfo[] = instance.getTopQualityPkgList();
      expect(topQualityPkgList).not().assertNull();
      expect(topQualityPkgList.length).assertEqual(0);
    })

    it('test_getPoorExperimentalPkgList', Level.LEVEL0, () => {
      const instance = OuterIconCenterViewModel.getInstance();
      let poorExperimentalPkgList: AppItemInfo[] = instance.getPoorExperimentalPkgList();
      expect(poorExperimentalPkgList).not().assertNull();
      expect(poorExperimentalPkgList.length).assertEqual(0);
    })

    it('test_updateOuterIconCenterData', Level.LEVEL0, () => {
      const instance = OuterIconCenterViewModel.getInstance();
      instance.updateOuterIconCenterData();
      expect(instance).not().assertNull();
    })

    it('test_parseXmlToAppCategorize_2', Level.LEVEL0, () => {
      const instance = OuterIconCenterViewModel.getInstance();
      const mocker: MockKit = new MockKit();
      const path: string = '/test/path';
      const mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunc)(path).afterReturn(true);
      expect(instance).not().assertNull();
      mocker.clear(FileUtils);
      mocker.clearAll();
    })
  })
}
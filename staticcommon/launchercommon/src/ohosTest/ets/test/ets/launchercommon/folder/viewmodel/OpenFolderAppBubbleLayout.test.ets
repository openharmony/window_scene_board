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
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it } from '@ohos/hypium'
import { openFolderAppBubbleLayout } from '../../../../../../../main/ets/folder/viewmdoel/OpenFolderAppBubbleLayout'
import { AppIconData } from '../../../../../../../main/ets/launchericon/viewmodel/AppIconData'
import { AppNameVm } from '../../../../../../../main/ets/launchericon/viewmodel/AppNameVm'
import { GridLayoutItemInfo } from '../../../../../../../main/ets/TsIndex';

export default function OpenFolderAppBubbleLayoutTest() {
  describe('OpenFolderAppBubbleLayoutTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_getAppLayout', 0, () => {
      let appData: AppIconData = new AppIconData();
      appData.transX = 1;
      openFolderAppBubbleLayout.setIconData('aaa', appData);
      let nameData: AppNameVm = new AppNameVm();
      nameData.isShow = false;
      openFolderAppBubbleLayout.setNameData('aaa', nameData);
      expect(openFolderAppBubbleLayout.getIconData('aaa').transX).assertEqual(1);
      expect(openFolderAppBubbleLayout.getNameData('aaa').isShow).assertFalse();
      expect(openFolderAppBubbleLayout.getIconData('bbb').transX).not().assertEqual(1);
      expect(openFolderAppBubbleLayout.getNameData('bbb').isShow).not().assertFalse();
      let item: GridLayoutItemInfo = new GridLayoutItemInfo();
      item.keyName = 'aaa';
      openFolderAppBubbleLayout.revertAppData(item);
      expect(openFolderAppBubbleLayout.getIconData('aaa').transX).assertEqual(0);

      openFolderAppBubbleLayout.deleteIconData('aaa');
      openFolderAppBubbleLayout.deleteNameData('aaa');
      expect(openFolderAppBubbleLayout.getIconData('aaa').transX).not().assertEqual(1);
      expect(openFolderAppBubbleLayout.getNameData('aaa').isShow).not().assertFalse();
    })
  })
}
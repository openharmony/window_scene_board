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
import { describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when} from '@ohos/hypium';

import { DockArrowViewData } from '../../../../../main/ets/extmode/viewmodel/viewdata/DockArrowViewData';

const TAG = 'DockArrowViewData';

export default function DockArrowViewDataTest() {
  describe('DockArrowViewData', () => {
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

    it('test_DockArrowViewDataTest_instance', Level.LEVEL0, (): void => {
      let arrowViewData = new DockArrowViewData();
      expect(arrowViewData).not().assertNull();
    })

    it('test_DockArrowViewDataTest_instance_1', Level.LEVEL0, (): void => {
      let arrowViewData = new DockArrowViewData();
      arrowViewData.residentLeftArrowOpacity = $r('sys.float.corner_radius_level4');
      expect(arrowViewData).not().assertNull();
    })


    it('test_DockArrowViewDataTest_instance_2', Level.LEVEL0, (): void => {
      let arrowViewData = new DockArrowViewData();
      arrowViewData.residentRightArrowOpacity = $r('sys.float.corner_radius_level4');
      expect(arrowViewData).not().assertNull();
    })


    it('test_DockArrowViewDataTest_instance_3', Level.LEVEL0, (): void => {
      let arrowViewData = new DockArrowViewData();
      arrowViewData.recentLeftArrowOpacity = $r('sys.float.corner_radius_level4');
      expect(arrowViewData).not().assertNull();
    })


    it('test_DockArrowViewDataTest_instance_4', Level.LEVEL0, (): void => {
      let arrowViewData = new DockArrowViewData();
      arrowViewData.recentRightArrowOpacity = $r('sys.float.corner_radius_level4');
      expect(arrowViewData).not().assertNull();
    })


    it('test_DockArrowViewDataTest_instance_5', Level.LEVEL0, (): void => {
      let arrowViewData = new DockArrowViewData();
      arrowViewData.residentLeftArrowBgColor = $r('sys.color.ohos_id_color_text_primary');
      expect(arrowViewData).not().assertNull();
    })


    it('test_DockArrowViewDataTest_instance_6', Level.LEVEL0, (): void => {
      let arrowViewData = new DockArrowViewData();
      arrowViewData.residentRightArrowBgColor = $r('sys.color.ohos_id_color_text_primary');
      expect(arrowViewData).not().assertNull();
    })

    it('test_DockArrowViewDataTest_instance_7', Level.LEVEL0, (): void => {
      let arrowViewData = new DockArrowViewData();
      arrowViewData.recentLeftArrowBgColor = $r('sys.color.ohos_id_color_text_primary');
      expect(arrowViewData).not().assertNull();
    })

    it('test_DockArrowViewDataTest_instance_8', Level.LEVEL0, (): void => {
      let arrowViewData = new DockArrowViewData();
      arrowViewData.recentRightArrowBgColor = $r('sys.color.ohos_id_color_text_primary');
      expect(arrowViewData).not().assertNull();
    })
  })
}
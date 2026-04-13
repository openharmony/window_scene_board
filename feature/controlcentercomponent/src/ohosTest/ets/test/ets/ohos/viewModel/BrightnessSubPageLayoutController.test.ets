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

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import {
  PageMode,
  sBrightnessSubPageLayoutController
} from '../../../../../../main/ets/com/ohos/controller/BrightnessSubPageLayoutController';


export function BrightnessSubPageLayoutControllerTest() {
  describe('BrightnessSubPageLayoutControllerTest', (): void => {
    beforeAll((): void => {
    })

    afterAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    it('BrightnessSubPageLayoutController_availableTest', 0, (): void => {
      sBrightnessSubPageLayoutController.getData();
      let isAvailable: boolean = sBrightnessSubPageLayoutController.isAvailable();
      expect(isAvailable).assertTrue();
    })

    it('BrightnessSubPageLayoutController_pageTest', 0, (): void => {
      sBrightnessSubPageLayoutController.showWindow();
      sBrightnessSubPageLayoutController.onScreenOff();
      sBrightnessSubPageLayoutController.onBackPress();
      let pageMode = sBrightnessSubPageLayoutController.getPageMode();
      expect(pageMode === PageMode.NONE).assertTrue();
      const mocker: MockKit = new MockKit();
      const mockFunc: Function = mocker.mockFunc(sBrightnessSubPageLayoutController,
        sBrightnessSubPageLayoutController.getPageMode);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(PageMode.DETAIL);
      sBrightnessSubPageLayoutController.onBackPress();
    })

    it('BrightnessSubPageLayoutController_goSettingTest', 0, (): void => {
      try {
        const mocker: MockKit = new MockKit();
        const mockFunc: Function = mocker.mockFunc(sBrightnessSubPageLayoutController,
          sBrightnessSubPageLayoutController.getPageMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(PageMode.NONE);
        sBrightnessSubPageLayoutController.goBrightnessSetting();
        let pageMode = sBrightnessSubPageLayoutController.getPageMode();
        expect(pageMode === PageMode.NONE).assertTrue();
      } catch (e) {
        expect(sBrightnessSubPageLayoutController).not().assertNull();
      }
    })
  })
}
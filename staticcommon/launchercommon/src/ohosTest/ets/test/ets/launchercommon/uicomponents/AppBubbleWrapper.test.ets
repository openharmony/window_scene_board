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
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  it,
  describe,
  expect,
} from '@ohos/hypium';
import { AppBubbleWrapper } from '../../../../../../main/ets/TsIndex';

export default function AppBubbleWrapperTest() {
  describe('AppBubbleWrapperTest', () => {
    beforeAll(() => {
    });
    beforeEach(() => {
    });
    afterAll(() => {
    });
    afterEach(() => {
    });

    it('getFormStackMenuOptions', 0, () => {
      expect(AppBubbleWrapper.getFormStackMenuOptions(true,
        () => {}, () => {}).placement).assertEqual(Placement.TopLeft);

      expect(AppBubbleWrapper.getFormStackMenuOptions(false,
        () => {}, () => {}).placement).assertEqual(Placement.BottomLeft);
    });

    it('getContextMenuOptions', 0, () => {
      expect(AppBubbleWrapper.getContextMenuOptions(true, MenuPreviewMode.NONE,
        () => {}, () => {}).placement).assertEqual(Placement.TopLeft);

      expect(AppBubbleWrapper.getContextMenuOptions(false, MenuPreviewMode.NONE,
        () => {}, () => {}).placement).assertEqual(Placement.BottomLeft);
    });

    it('getContextMenuOptions3', 0, () => {
      expect(AppBubbleWrapper.getContextMenuOptions3(true, MenuPreviewMode.NONE,
        () => {}).placement).assertEqual(Placement.TopLeft);

      expect(AppBubbleWrapper.getContextMenuOptions3(false, MenuPreviewMode.NONE,
        () => {}).placement).assertEqual(Placement.BottomLeft);
    });

    it('getContextMenuOptions4', 0, () => {
      expect(AppBubbleWrapper.getContextMenuOptions4(true, () => {}).placement).assertEqual(Placement.TopLeft);

      expect(AppBubbleWrapper.getContextMenuOptions4(false, () => {}).placement).assertEqual(Placement.BottomLeft);
    });

    it('getContextMenuOptions7', 0, () => {
      expect(AppBubbleWrapper.getContextMenuOptions7(true).placement).assertEqual(Placement.TopLeft);

      expect(AppBubbleWrapper.getContextMenuOptions7(false).placement).assertEqual(Placement.BottomLeft);
    });

    it('getContextMenuOptions8', 0, () => {
      expect(AppBubbleWrapper.getContextMenuOptions8(true).placement).assertEqual(Placement.TopLeft);

      expect(AppBubbleWrapper.getContextMenuOptions8(false).placement).assertEqual(Placement.BottomLeft);
    });
  })
}
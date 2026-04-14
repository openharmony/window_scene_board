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
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  when,
  ArgumentMatchers,
  MockKit
} from '@ohos/hypium';
import { folderLayoutUtil, GridLayoutItemInfo } from '@ohos/launchercommon';
import { PageDragViewModel } from '../../../../../main/ets/default/common/viewmodel/PageDragViewModel';

export default function PageDragViewModelTest() {
  describe('PageDragViewModelTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_initDeviceInfo', 0, (): void => {
      const pageDragViewModel = new PageDragViewModel();
      pageDragViewModel.initDeviceInfo(true);
      expect((pageDragViewModel as object)['isOuterDesktop']).assertFalse();
      pageDragViewModel.initDeviceInfo(false);
      expect((pageDragViewModel as object)['isOuterDesktop']).assertFalse();
    })

    it('test_triggerGravityAnimationWithFolder', 0, (): void => {
      const pageDragViewModel = new PageDragViewModel();
      let endLayoutInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      endLayoutInfo.area = [1, 1];

      const mocker: MockKit = new MockKit();
      const mockFunc1: Function = mocker.mockFunc(folderLayoutUtil,
        folderLayoutUtil.getCurrentFolderCenterPosition);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn([1, 1]);

      expect(pageDragViewModel.triggerGravityAnimationWithFolder(1, 1)).assertFalse();
      expect(pageDragViewModel.triggerGravityAnimationWithFolder(1, 1, endLayoutInfo)).assertTrue();
    })
  })
}
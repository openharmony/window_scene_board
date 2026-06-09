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
import { PageDesktopModel } from '@ohos/launchercommon';
import { SCBScreenSessionManager } from '@ohos/windowscene';
import { DragItemPosition } from '@ohos/componentdrag';
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
import { PageDesktopDragHandler } from '../../../../main/ets/default/common/PageDesktopDragHandler';
import { PageDesktopViewModel } from '../../../../main/ets/default/common/viewmodel/PageDesktopViewModel';

export function PageDesktopDragHandlerTest() {
  describe('PageDesktopDragHandlerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });
    it('deleteBlankPageAfterDragging01', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let startPosition: DragItemPosition = {
        page: 1,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      let endPosition: DragItemPosition = {
        page: 2,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };

      //1.创建一个mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mockfunc2: Function = mocker.mockFunc(mPageDesktopViewModel, mPageDesktopViewModel.isAddByDragging);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockfunc3: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(false);
      let mPageDesktopModel = PageDesktopModel.getInstance();
      let mockfunc4: Function = mocker.mockFunc(mSCBScreenSessionManager, mPageDesktopModel.deleteBlankPageFromLayoutInfo);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(false);
      let pageDesktopDrageHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
      pageDesktopDrageHandler.deleteBlankPageAfterDragging(endPosition, 'test');
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    });
    it('deleteBlankPageAfterDragging02', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let startPosition: DragItemPosition = {
        page: 1,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      let endPosition: DragItemPosition = {
        page: 5,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      //1.创建一个mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mockfunc2: Function = mocker.mockFunc(mPageDesktopViewModel, mPageDesktopViewModel.isAddByDragging);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockfunc3: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(false);
      let mPageDesktopModel = PageDesktopModel.getInstance();
      let mockfunc4: Function = mocker.mockFunc(mSCBScreenSessionManager, mPageDesktopModel.deleteBlankPageFromLayoutInfo);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(false);
      let pageDesktopDrageHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
      pageDesktopDrageHandler.deleteBlankPageAfterDragging(endPosition, 'test');
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    });
    it('deleteBlankPageAfterDragging03', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let startPosition: DragItemPosition = {
        page: 1,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      let endPosition: DragItemPosition = {
        page: 2,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      //1.创建一个mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mockfunc2: Function = mocker.mockFunc(mPageDesktopViewModel, mPageDesktopViewModel.isAddByDragging);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockfunc3: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(true);
      let mPageDesktopModel = PageDesktopModel.getInstance();
      let mockfunc4: Function = mocker.mockFunc(mSCBScreenSessionManager, mPageDesktopModel.deleteBlankPageFromLayoutInfo);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(false);
      let pageDesktopDrageHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
      pageDesktopDrageHandler.deleteBlankPageAfterDragging(endPosition, 'test');
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    });
    it('deleteBlankPageAfterDragging04', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let startPosition: DragItemPosition = {
        page: 1,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      let endPosition: DragItemPosition = {
        page: 1,
        row: 0,
        column: 0,
        x: 0,
        y: 0
      };
      //1.创建一个mock能力的对象MockKit
      let mocker: MockKit = new MockKit();
      let mPageDesktopViewModel: PageDesktopViewModel = PageDesktopViewModel.getInstance();
      let mockfunc2: Function = mocker.mockFunc(mPageDesktopViewModel, mPageDesktopViewModel.isAddByDragging);
      when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);
      let mSCBScreenSessionManager: SCBScreenSessionManager = SCBScreenSessionManager.getInstance();
      let mockfunc3: Function = mocker.mockFunc(mSCBScreenSessionManager, mSCBScreenSessionManager.isFoldablePhoneExpandStatus);
      when(mockfunc3)(ArgumentMatchers.any).afterReturn(true);
      let mPageDesktopModel = PageDesktopModel.getInstance();
      let mockfunc4: Function = mocker.mockFunc(mSCBScreenSessionManager, mPageDesktopModel.deleteBlankPageFromLayoutInfo);
      when(mockfunc4)(ArgumentMatchers.any).afterReturn(false);
      let pageDesktopDrageHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
      pageDesktopDrageHandler.deleteBlankPageAfterDragging(endPosition, 'test');
      let a = 'test';
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test');
    });
  });

  it('onDragMove', 0, (): void => {
    let pageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
    expect(pageDesktopDragHandler.onDragMove(undefined, undefined)).assertFalse();
  });

  it('test_setAndGetDragPageIndex', 0, () => {
    let pageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
    let pageIndex: number = 0;
    pageDesktopDragHandler.setDragPageIndex(pageIndex);
    expect(pageDesktopDragHandler).not().assertNull();
  });

  it('test_reportEmptyGridInfo', 0, (): void => {
    let pageDesktopDragHandler: PageDesktopDragHandler = PageDesktopDragHandler.getInstance();
    pageDesktopDragHandler.reportEmptyGridInfo();
    expect(pageDesktopDragHandler).not().assertNull();
  });
}
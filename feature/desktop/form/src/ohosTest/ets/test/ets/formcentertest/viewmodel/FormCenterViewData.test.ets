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

import { RTLUtil } from '@ohos/basiccommon';
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
import { FormModel } from '@ohos/launchercommon';
import { NavDestinationViewData, ViewData } from '../../../../../../main/ets/default/viewmodel/FormCenterObservedData';
import { FormCenterViewData } from '../../../../../../main/ets/default/viewmodel/FormCenterViewData';

/**
 * 卡片中心 view data单元测试
 */
export function FormCenterViewDataTest() {
  describe('FormCenterViewDataTest', () => {
    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterAll(() => {
    });

    afterEach(() => {
    });

    it('test_getInstance', 0, () => {
      let instance = FormCenterViewData.getInstance();
      expect(instance).not().assertNull();
    });

    it('test_getFormDimensionScale', 0, () => {
      let instance = FormCenterViewData.getInstance();
      expect(instance.getFormDimensionScale(1)).not().assertNull();
    });

    it('test_getViewData_1', 0, () => {
      let instance = FormCenterViewData.getInstance();
      expect(instance.getViewData(true)).not().assertNull();
    });

    it('test_getViewData_2', 0, () => {
      let instance = FormCenterViewData.getInstance();
      expect(instance.getViewData(false)).not().assertNull();
    });

    it('test_getViewGridRowManager_1', 0, () => {
      let instance = FormCenterViewData.getInstance();
      expect(instance.getViewGridRowManager()).not().assertNull();
    });

    it('test_getViewGridRowManager_2', 0, () => {
      let instance = FormCenterViewData.getInstance();
      instance.setCurrentViewHeight(10);
      expect(instance.mCurrentHeight).assertEqual(10);
    });

    it('test_getAppFormsCenterPosition', 0, () => {
      let instance = FormCenterViewData.getInstance();
      instance.setCurrentViewHeight(10);
      expect(instance.mCurrentHeight).assertEqual(10);
    });

    it('test_getAppFormsCenterPosition_1', 0, () => {
      let formCenterViewData = new FormCenterViewData();
      let mocker: MockKit = new MockKit();
      let formModel = FormModel.getInstance();

      let isSupportFormCenterSplit: Function = mocker.mockFunc(formModel, formModel.isSupportFormCenterSplit);
      when(isSupportFormCenterSplit)(ArgumentMatchers.any).afterReturn(true);

      let mockRTLUtil = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockRTLUtil)(ArgumentMatchers.any).afterReturn(false);

      formCenterViewData.getViewData().navDestinationViewData = new NavDestinationViewData();
      formCenterViewData.getViewData().navDestinationViewData.viewWidth = 1000;
      formCenterViewData.getViewData().navDestinationViewData.formViewHeight = 800;
      formCenterViewData.getViewData().bindSheetWidth = 500;
      formCenterViewData.getViewData().appListWidth = 300;

      let position = formCenterViewData.getAppFormsCenterPosition();
      expect(position).not().assertNull();
      expect(position.x).assertLarger(100);
      expect(position.y).assertLarger(100);
      mocker.clear(formModel);
      mocker.clear(RTLUtil);
      mocker.clearAll();
    });

    it('test_getAppFormsCenterPosition_2', 0, () => {
      let formCenterViewData = new FormCenterViewData();
      let mocker: MockKit = new MockKit();
      let formModel = FormModel.getInstance();

      let isSupportFormCenterSplit: Function = mocker.mockFunc(formModel, formModel.isSupportFormCenterSplit);
      when(isSupportFormCenterSplit)(ArgumentMatchers.any).afterReturn(true);

      let mockRTLUtil = mocker.mockFunc(RTLUtil, RTLUtil.isRTL);
      when(mockRTLUtil)(ArgumentMatchers.any).afterReturn(true);

      let position = formCenterViewData.getAppFormsCenterPosition();
      expect(position).not().assertNull();
      expect(position.x).assertLargerOrEqual(0);
      expect(position.y).assertLargerOrEqual(0);
      mocker.clear(formModel);
      mocker.clear(RTLUtil);
      mocker.clearAll();
    });

    it('test_getAppFormsCenterPosition_3', 0, () => {
      let formCenterViewData = new FormCenterViewData();
      let mocker: MockKit = new MockKit();
      let formModel = FormModel.getInstance();

      let isSupportFormCenterSplit: Function = mocker.mockFunc(formModel, formModel.isSupportFormCenterSplit);
      when(isSupportFormCenterSplit)(ArgumentMatchers.any).afterReturn(false);

      let position = formCenterViewData.getAppFormsCenterPosition();
      expect(position).not().assertNull();
      expect(position.x).assertLargerOrEqual(0);
      expect(position.y).assertLargerOrEqual(0);
      mocker.clear(formModel);
      mocker.clearAll();
    });
  })
}
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
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { DropdownVm, LiveVmInjector } from '@ohos/systemuicommon/newIndex';
import { StatusBarLayoutVm } from '../../../../../main/ets/vm/StatusBarLayoutVm';
import { StatusBarNotificationIconVm } from '../../../../../main/ets/vm/StatusBarNotificationIconVm';

export default function StatusBarLayoutVmTest() {
  describe('test_getClockOrOperatorWidth_testSuite', () => {
    beforeEach(() => {

    });
    afterEach(() => {

    });
    it('should_return_operator_width_when_status_bar_is_dropdown', 0, () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      let mocker: MockKit = new MockKit();
      let dropdownVm: DropdownVm = DropdownVm.instance;
      let mockfunc: Function = mocker.mockFunc(dropdownVm, dropdownVm.getStatusBarIconVm);
      let iconVm: IStatusBarIconVm = new StatusBarNotificationIconVm();
      iconVm.width = 100;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(iconVm);
      const result = statusbarlayoutvm.getClockOrOperatorWidth();
      expect(result).assertEqual(100);
      mocker.ignoreMock(dropdownVm, dropdownVm.getStatusBarIconVm);
    });

    it('should_return_clock_width_when_status_bar_is_not_dropdown', 0, () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      let mocker: MockKit = new MockKit();
      let dropdownVm: DropdownVm = DropdownVm.instance;
      let mockfunc: Function = mocker.mockFunc(dropdownVm, dropdownVm.getStatusBarIconVm);
      let iconVm: IStatusBarIconVm = new StatusBarClockIconVm();
      iconVm.width = 100;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(iconVm);
      const result = statusbarlayoutvm.getClockOrOperatorWidth();
      expect(result).assertEqual(100 + statusbarlayoutvm.statusBarPaddingLeft);
      mocker.ignoreMock(dropdownVm, dropdownVm.getStatusBarIconVm);
    });

    it('should_return_default_padding_when_clock_width_is_0', 0, () => {
      let statusBarVmInjector: StatusBarVmInjector = new Statusbarlayoutvm();
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      let mocker: MockKit = new MockKit();
      let dropdownVm: DropdownVm = DropdownVm.instance;
      let mockfunc: Function = mocker.mockFunc(dropdownVm, dropdownVm.getStatusBarIconVm);
      let iconVm: IStatusBarIconVm = new StatusBarClockIconVm();
      iconVm.width = 0;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(iconVm);
      const result = statusbarlayoutvm.getClockOrOperatorWidth();
      expect(result).assertEqual(statusbarlayoutvm.DEFAULT_PADDING);
      mocker.ignoreMock(dropdownVm, dropdownVm.getStatusBarIconVm);
    });

    it('should_return_clock_width_with_status_bar_padding_left', 0, () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      statusbarlayoutvm.statusBarPaddingLeft = 10;
      let mocker: MockKit = new MockKit();
      let dropdownVm: DropdownVm = DropdownVm.instance;
      let mockfunc: Function = mocker.mockFunc(dropdownVm, dropdownVm.getStatusBarIconVm);
      let iconVm: IStatusBarIconVm = new StatusBarClockIconVm();
      iconVm.width = 100;
      when(mockfunc)(ArgumentMatchers.any).afterReturn(iconVm);
      const result = statusbarlayoutvm.getClockOrOperatorWidth();
      expect(result).assertEqual(100 + 10);
      mocker.ignoreMock(dropdownVm, dropdownVm.getStatusBarIconVm);
    });
  })

  describe('hideIconForWhile_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_hide_icons_temporarily_when_layout_change', 0, async () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      let mocker: MockKit = new MockKit();

      let locationIconVM: IStatusBarIconVm = new StatusBarClockIconVm();
      let superPrivacyIconVM: IStatusBarIconVm = new StatusBarNotificationIconVm();

      let mockGetStatusBarIconVm: Function = mocker.mockFunc(statusbarlayoutvm.vmInjector, statusbarlayoutvm.vmInjector.getStatusBarIconVm);
      when(mockGetStatusBarIconVm)(ArgumentMatchers.anyString).afterReturn(locationIconVM);
      when(mockGetStatusBarIconVm)(ArgumentMatchers.anyString).afterReturn(superPrivacyIconVM);

      statusbarlayoutvm.hideIconForWhile();

      expect(locationIconVM.iconDelayShowOpacity).assertEqual(0);
      expect(superPrivacyIconVM.iconDelayShowOpacity).assertEqual(0);

      setTimeout(() => {
        expect(locationIconVM.iconDelayShowOpacity).assertEqual(1);
        expect(superPrivacyIconVM.iconDelayShowOpacity).assertEqual(1);
      }, 30);

      mocker.ignoreMock(statusbarlayoutvm.vmInjector, statusbarlayoutvm.vmInjector.getStatusBarIconVm);
    });
  });

  describe('recalculateBaseLayout_testSuite', () => {
    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_call_baseLayoutInfo_clearInfo', 0, () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      let mocker: MockKit = new MockKit();
      let baseLayoutInfo: BaseLayoutCacheInfo = statusbarlayoutvm.baseLayoutInfo;
      let mockfunc: Function = mocker.mockFunc(baseLayoutInfo, baseLayoutInfo.clearInfo);
      when(mockfunc)(ArgumentMatchers.any).afterReturnNothing();
      statusbarlayoutvm.recalculateBaseLayout();
      mocker.ignoreMock(baseLayoutInfo, baseLayoutInfo.clearInfo);
    });

    it('recalculateCapsuleLayout_animate_false_delay_0', 0, () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      let mocker: MockKit = new MockKit();
      let dropdownVm: DropdownVm = DropdownVm.instance;
      let mockfunc: Function = mocker.mockFunc(dropdownVm, dropdownVm.isDropDown);
      when(mockfunc)().afterReturn(false);
      statusbarlayoutvm.recalculateCapsuleLayout(false, 0);
      mocker.ignoreMock(dropdownVm, dropdownVm.isDropDown);
    })

    it('recalculateCapsuleLayout_animate_true_delay_0', 0, () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      let mocker: MockKit = new MockKit();
      let dropdownVm: DropdownVm = DropdownVm.instance;
      let mockfunc: Function = mocker.mockFunc(dropdownVm, dropdownVm.isDropDown);
      when(mockfunc)().afterReturn(false);
      statusbarlayoutvm.recalculateCapsuleLayout(true, 0);
      mocker.ignoreMock(dropdownVm, dropdownVm.isDropDown);
    })

    it('should_refresh_statusbar_layout_correctly', 0, async () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      statusbarlayoutvm.statusbarLayoutRefresh();
      expect(statusbarlayoutvm.statusBarPaddingLeft).assertLarger(0);
      expect(statusbarlayoutvm.statusBarMarginTop).assertLarger(0);
      expect(statusbarlayoutvm.capsuleLeftX).assertLarger(0);
      expect(statusbarlayoutvm.capsuleRightX).assertLarger(0);
      expect(statusbarlayoutvm.isExistCapsule).assertFalse();
    });


    it('should_update_statusBarPaddingLeft_and_statusBarMarginTop_when_onCutoutChange_is_called', 0, async () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      let mocker: MockKit = new MockKit();
      statusbarlayoutvm.onCutoutChange();
      expect(statusbarlayoutvm.statusBarPaddingLeft).assertLarger(0);
      expect(statusbarlayoutvm.statusBarMarginTop).assertLarger(0);
    });

    it('should_call_updateStatusBarPaddingLeft_and_updateStatusBarMarginTop_when_onCutoutChange_is_called', 0, async () => {
      let statusbarlayoutvm: StatusBarLayoutVm = new StatusBarLayoutVm();
      let mocker: MockKit = new MockKit();
      statusbarlayoutvm.onCutoutChange();
    });

  })
}
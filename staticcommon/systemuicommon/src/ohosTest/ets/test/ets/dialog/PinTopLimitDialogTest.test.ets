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
import { display, LengthMetrics } from '@kit.ArkUI';
import osAccount from '@ohos.account.osAccount';
import ctx from '@ohos.app.ability.common';
import { windowManager } from '@ohos/componentdrag/src/main/ets/manager/WindowManager';
import { DeviceHelper } from '@ohos/frameworkwrapper/src/main/ets/base/DeviceHelper';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { AppIconWithIndexSubIcon } from '../../../main/ets/view/AppIconWithIndexSubIcon';
import { NotificationConfigEntity } from '../../../main/ets/model/NotificationConfigEntity';
import { PinTopLimitDialogInterface, PinTopLimitDialogVmManager } from '../../../main/ets/dialog/PinTopLimitDialogInterface';
import measure from '@ohos.measure';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../main/ets/dialog/PinTopLimitDialog';
export default function Test() {
  describe('gridLandHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_correct_itemHeight_when_isContentScroll_is_true_and_itemHeight_is_less_than_SCROLLER_MIN_HEIGHT', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeviceHelper: DeviceHelper = new DeviceHelper();
      let mockWindow: windowManager.Window = new windowManager.Window();
      mockWindow.getWindowAvoidArea = (type: windowManager.AvoidAreaType) => {
        return {
          topRect: { width: 100, height: 100 },
          bottomRect: { width: 100, height: 100 }
        };
      };
      mockDeviceHelper.getDefaultDisplaySync = () => {
        return mockWindow;
      };

      let mockGridLandHeight: gridLandHeight = new gridLandHeight();
      mockGridLandHeight.isContentScroll = true;
      mockGridLandHeight.landHeight = 1000;
      mockGridLandHeight.getTitleHeight = () => {
        return 50;
      };
      mockGridLandHeight.getButtonHeight = () => {
        return 60;
      };
      mockGridLandHeight.getScaleRate = () => {
        return 1.5;
      };
      mockGridLandHeight.deviceHelper = mockDeviceHelper;

      let result = mockGridLandHeight.gridLandHeight();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockDeviceHelper, mockDeviceHelper.getDefaultDisplaySync);
    });

    it('should_return_correct_itemHeight_when_isContentScroll_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeviceHelper: DeviceHelper = new DeviceHelper();
      let mockWindow: windowManager.Window = new windowManager.Window();
      mockWindow.getWindowAvoidArea = (type: windowManager.AvoidAreaType) => {
        return {
          topRect: { width: 100, height: 100 },
          bottomRect: { width: 100, height: 100 }
        };
      };
      mockDeviceHelper.getDefaultDisplaySync = () => {
        return mockWindow;
      };

      let mockGridLandHeight: gridLandHeight = new gridLandHeight();
      mockGridLandHeight.isContentScroll = false;
      mockGridLandHeight.landHeight = 1000;
      mockGridLandHeight.getTitleHeight = () => {
        return 50;
      };
      mockGridLandHeight.getButtonHeight = () => {
        return 60;
      };
      mockGridLandHeight.getScaleRate = () => {
        return 1.5;
      };
      mockGridLandHeight.deviceHelper = mockDeviceHelper;

      let result = mockGridLandHeight.gridLandHeight();
      expect(result).assertEqual(820);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockDeviceHelper, mockDeviceHelper.getDefaultDisplaySync);
    });

    it('should_return_correct_template_when_pinTopConfigList_is_not_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(windowManager, windowManager.getWindowManager);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({
        getWindowWidth: () => 1080,
        getWindowHeight: () => 1920
      });

      let mockfunc2: Function = mocker.mockFunc(display, display.getDefaultDisplaySync);
      when(mockfunc2)().afterReturn({
        width: 1080,
        height: 1920,
        getDefaultDisplaySync: () => ({
          width: 1080,
          height: 1920,
        }),
        getDefaultDisplayRotation: () => 0,
        getSupportedLengthMetrics: () => [LengthMetrics.INCH, LengthMetrics.CM, LengthMetrics.MM, LengthMetrics.PX]
      });

      let mockfunc3: Function = mocker.mockFunc(osAccount, osAccount.getOsAccountManager);
      when(mockfunc3)().afterReturn({
        getOsAccount: () => ({
          isOsAccountValid: () => true
        })
      });

      let mockfunc4: Function = mocker.mockFunc(ctx, ctx.getApplicationContext);
      when(mockfunc4)().afterReturn({
        resourceManager: {
          getStringSync: () => "testString"
        }
      });

      let mockfunc5: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockfunc5)().afterReturn(false);

      let mockfunc6: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockfunc6)().afterReturn(undefined);

      let mockfunc7: Function = mocker.mockFunc(LogDomain, LogDomain.info);
      when(mockfunc7)().afterReturn(undefined);

      let mockfunc8: Function = mocker.mockFunc(PinTopLimitDialogVmManager, PinTopLimitDialogVmManager.getInstance);
      when(mockfunc8)().afterReturn({
        getDialogStatus: () => false
      });

      let mockfunc9: Function = mocker.mockFunc(PinTopLimitDialogInterface, PinTopLimitDialogInterface.showDialog);
      when(mockfunc9)().afterReturn(undefined);

      let mockfunc10: Function = mocker.mockFunc(measure, measure.measureTextSize);
      when(mockfunc10)().afterReturn({
        width: 100,
        height: 100
      });

      let gridRowTemplate_instance = new AppIconWithIndexSubIcon({
        icon: "testIcon",
        index: 1,
        subIcon: "testSubIcon",
        notificationConfig: new NotificationConfigEntity(),
        pinTopConfigList: [1, 2, 3],
        colCount: 3
      });

      const result = gridRowTemplate_instance.gridRowTemplate();
      expect(result).assertEqual("testString");

      mocker.ignoreMock(windowManager, windowManager.getWindowManager);
      mocker.ignoreMock(display, display.getDefaultDisplaySync);
      mocker.ignoreMock(osAccount, osAccount.getOsAccountManager);
      mocker.ignoreMock(ctx, ctx.getApplicationContext);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mocker.ignoreMock(LogHelper, LogHelper.info);
      mocker.ignoreMock(LogDomain, LogDomain.info);
      mocker.ignoreMock(PinTopLimitDialogVmManager, PinTopLimitDialogVmManager.getInstance);
      mocker.ignoreMock(PinTopLimitDialogInterface, PinTopLimitDialogInterface.showDialog);
      mocker.ignoreMock(measure, measure.measureTextSize);
    });

    it('should_return_empty_string_when_pinTopConfigList_is_empty', 0, () => {
      let gridRowTemplate_instance = new AppIconWithIndexSubIcon({
        icon: "testIcon",
        index: 1,
        subIcon: "testSubIcon",
        notificationConfig: new NotificationConfigEntity(),
        pinTopConfigList: [],
        colCount: 3
      });

      const result = gridRowTemplate_instance.gridRowTemplate();
      expect(result).assertEqual("");
    });

    it('should_return_top_list_when_pin_top_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: true, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());

      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });

    it('should_return_empty_list_when_pin_top_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: false, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());

      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });
    it('should_return_correct_itemHeight_when_isContentScroll_is_true_and_itemHeight_is_less_than_SCROLLER_MIN_HEIGHT', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeviceHelper: DeviceHelper = new DeviceHelper();
      let mockWindow: windowManager.Window = new windowManager.Window();
      mockWindow.getWindowAvoidArea = (type: windowManager.AvoidAreaType) => {
        return {
          topRect: { width: 100, height: 100 },
          bottomRect: { width: 100, height: 100 }
        };
      };
      mockDeviceHelper.getDefaultDisplaySync = () => {
        return mockWindow;
      };

      let mockGridLandHeight: gridLandHeight = new gridLandHeight();
      mockGridLandHeight.isContentScroll = true;
      mockGridLandHeight.landHeight = 1000;
      mockGridLandHeight.getTitleHeight = () => {
        return 50;
      };
      mockGridLandHeight.getButtonHeight = () => {
        return 60;
      };
      mockGridLandHeight.getScaleRate = () => {
        return 1.5;
      };
      mockGridLandHeight.deviceHelper = mockDeviceHelper;

      let result = mockGridLandHeight.gridLandHeight();
      expect(result).assertEqual(1000);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockDeviceHelper, mockDeviceHelper.getDefaultDisplaySync);
    });

    it('should_return_correct_itemHeight_when_isContentScroll_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let mockDeviceHelper: DeviceHelper = new DeviceHelper();
      let mockWindow: windowManager.Window = new windowManager.Window();
      mockWindow.getWindowAvoidArea = (type: windowManager.AvoidAreaType) => {
        return {
          topRect: { width: 100, height: 100 },
          bottomRect: { width: 100, height: 100 }
        };
      };
      mockDeviceHelper.getDefaultDisplaySync = () => {
        return mockWindow;
      };

      let mockGridLandHeight: gridLandHeight = new gridLandHeight();
      mockGridLandHeight.isContentScroll = false;
      mockGridLandHeight.landHeight = 1000;
      mockGridLandHeight.getTitleHeight = () => {
        return 50;
      };
      mockGridLandHeight.getButtonHeight = () => {
        return 60;
      };
      mockGridLandHeight.getScaleRate = () => {
        return 1.5;
      };
      mockGridLandHeight.deviceHelper = mockDeviceHelper;

      let result = mockGridLandHeight.gridLandHeight();
      expect(result).assertEqual(820);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
      mocker.ignoreMock(mockDeviceHelper, mockDeviceHelper.getDefaultDisplaySync);
    });

    it('should_return_correct_template_when_pinTopConfigList_is_not_empty', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(windowManager, windowManager.getWindowManager);
      when(mockfunc)(ArgumentMatchers.any).afterReturn({
        getWindowWidth: () => 1080,
        getWindowHeight: () => 1920
      });

      let mockfunc2: Function = mocker.mockFunc(display, display.getDefaultDisplaySync);
      when(mockfunc2)().afterReturn({
        width: 1080,
        height: 1920,
        getDefaultDisplaySync: () => ({
          width: 1080,
          height: 1920,
        }),
        getDefaultDisplayRotation: () => 0,
        getSupportedLengthMetrics: () => [LengthMetrics.INCH, LengthMetrics.CM, LengthMetrics.MM, LengthMetrics.PX]
      });

      let mockfunc3: Function = mocker.mockFunc(osAccount, osAccount.getOsAccountManager);
      when(mockfunc3)().afterReturn({
        getOsAccount: () => ({
          isOsAccountValid: () => true
        })
      });

      let mockfunc4: Function = mocker.mockFunc(ctx, ctx.getApplicationContext);
      when(mockfunc4)().afterReturn({
        resourceManager: {
          getStringSync: () => "testString"
        }
      });

      let mockfunc5: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockfunc5)().afterReturn(false);

      let mockfunc6: Function = mocker.mockFunc(LogHelper, LogHelper.info);
      when(mockfunc6)().afterReturn(undefined);

      let mockfunc7: Function = mocker.mockFunc(LogDomain, LogDomain.info);
      when(mockfunc7)().afterReturn(undefined);

      let mockfunc8: Function = mocker.mockFunc(PinTopLimitDialogVmManager, PinTopLimitDialogVmManager.getInstance);
      when(mockfunc8)().afterReturn({
        getDialogStatus: () => false
      });

      let mockfunc9: Function = mocker.mockFunc(PinTopLimitDialogInterface, PinTopLimitDialogInterface.showDialog);
      when(mockfunc9)().afterReturn(undefined);

      let mockfunc10: Function = mocker.mockFunc(measure, measure.measureTextSize);
      when(mockfunc10)().afterReturn({
        width: 100,
        height: 100
      });

      let gridRowTemplate_instance = new AppIconWithIndexSubIcon({
        icon: "testIcon",
        index: 1,
        subIcon: "testSubIcon",
        notificationConfig: new NotificationConfigEntity(),
        pinTopConfigList: [1, 2, 3],
        colCount: 3
      });

      const result = gridRowTemplate_instance.gridRowTemplate();
      expect(result).assertEqual("testString");

      mocker.ignoreMock(windowManager, windowManager.getWindowManager);
      mocker.ignoreMock(display, display.getDefaultDisplaySync);
      mocker.ignoreMock(osAccount, osAccount.getOsAccountManager);
      mocker.ignoreMock(ctx, ctx.getApplicationContext);
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mocker.ignoreMock(LogHelper, LogHelper.info);
      mocker.ignoreMock(LogDomain, LogDomain.info);
      mocker.ignoreMock(PinTopLimitDialogVmManager, PinTopLimitDialogVmManager.getInstance);
      mocker.ignoreMock(PinTopLimitDialogInterface, PinTopLimitDialogInterface.showDialog);
      mocker.ignoreMock(measure, measure.measureTextSize);
    });

    it('should_return_empty_string_when_pinTopConfigList_is_empty', 0, () => {
      let gridRowTemplate_instance = new AppIconWithIndexSubIcon({
        icon: "testIcon",
        index: 1,
        subIcon: "testSubIcon",
        notificationConfig: new NotificationConfigEntity(),
        pinTopConfigList: [],
        colCount: 3
      });

      const result = gridRowTemplate_instance.gridRowTemplate();
      expect(result).assertEqual("");
    });

    it('should_return_top_list_when_pin_top_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: true, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());

      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });

    it('should_return_empty_list_when_pin_top_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: false, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());

      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });

    it('should_return_empty_string_when_pinTopConfigList_is_empty', 0, () => {
      let gridRowTemplate_instance = new AppIconWithIndexSubIcon({
        icon: "testIcon",
        index: 1,
        subIcon: "testSubIcon",
        notificationConfig: new NotificationConfigEntity(),
        pinTopConfigList: [],
        colCount: 3
      });

      const result = gridRowTemplate_instance.gridRowTemplate();
      expect(result).assertEqual("");
    });

    it('should_return_top_list_when_pin_top_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: true, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());

      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });

    it('should_return_empty_list_when_pin_top_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: false, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());

      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });
    it('should_return_empty_string_when_pinTopConfigList_is_empty', 0, () => {
      let gridRowTemplate_instance = new AppIconWithIndexSubIcon({
        icon: "testIcon",
        index: 1,
        subIcon: "testSubIcon",
        notificationConfig: new NotificationConfigEntity(),
        pinTopConfigList: [],
        colCount: 3
      });

      const result = gridRowTemplate_instance.gridRowTemplate();
      expect(result).assertEqual("");
    });

    it('should_return_top_list_when_pin_top_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: true, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());

      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });

    it('should_return_empty_list_when_pin_top_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: false, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());

      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });
    it('should_return_empty_string_when_pinTopConfigList_is_empty', 0, () => {
      let gridRowTemplate_instance = new AppIconWithIndexSubIcon({
        icon: "testIcon",
        index: 1,
        subIcon: "testSubIcon",
        notificationConfig: new NotificationConfigEntity(),
        pinTopConfigList: [],
        colCount: 3
      });
      const result = gridRowTemplate_instance.gridRowTemplate();
      expect(result).assertEqual("");
    });
    it('should_return_top_list_when_pin_top_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: true, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());
      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });
    it('should_return_empty_list_when_pin_top_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockEqualTo: Function = mocker.mockFunc(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
      when(mockEqualTo)({ pinTop: false, userId: 1 }).afterReturn(NotificationConfigEntity.getPredicates());
      let result = await getPinTopList();
      expect(result).assertInstanceOf(NotificationConfigEntity);
      mocker.ignoreMock(NotificationConfigEntity.getPredicates(), NotificationConfigEntity.getPredicates().equalTo);
    });
  });
}

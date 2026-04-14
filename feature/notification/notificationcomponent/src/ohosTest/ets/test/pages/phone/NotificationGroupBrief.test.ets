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

import { NotificationEntry, NtfDataUpdateListener } from '../../../../main/ets/model/NotificationEntry';
import { NotificationConfig } from '../../../../main/ets/common/NotificationConfig';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { ItemUtils, RTLUtil } from '@ohos/componenthelper';
import { AodStyleType, ImmersiveAodStyle, immersiveKgMgr,
  ObservedItem,
  OverlayIconStyle} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { fontScaleManager, FontScaleState } from '@ohos/systemuicommon';
import { NotificationItemStyle } from '../../../../main/ets/vm/style/NotificationItemStyle';
import { notificationStyle } from '../../../../main/ets/vm/style/NotificationStyle';
import { NtfTimeVM } from '../../../../main/ets/vm/NtfTimeVM';
import { NtfAppIconModifier } from '../../../../main/ets/vm/style/NtfAppIconModifier';
import { AccessibilityAppName, BrightnessOptionUtils, NotificationType } from '@ohos/systemuicommon/Index';
import { NtfColorModeVM } from '../../../../main/ets/vm/NtfColorModeVM';
import { ntfViewConfigManager } from '../../../../main/ets/vm/config/NtfViewConfigManager';
import { NtfListContentConfig } from '../../../../main/ets/vm/config/NtfViewConfig';
import pinTopIcon from '../../../../main/ets/pages/common/PinTopIcon';
import { NtfAnimationConsts } from '../../../../main/ets/common/NtfAnimationConsts';
import { NotificationConstants } from '../../../../main/ets/common/NotificationConstants';
import {
  PromiseInterrupt
} from '@ohos/systemuicommon/src/main/ets/immersivekeyguardcommon/base/manager/PromiseInterruptManager';
import { LengthMetrics } from '@ohos.arkui.node';
import { TextEmojiHelper } from '@ohos/systemuicommon/src/main/ets/utils/TextEmojiHelper';
import { image } from '@kit.ImageKit';
import { NotificationGroupExpandAnimation } from '../../../../main/ets/animation/NotificationGroupExpandAnimation';
import { NtfCloseVM } from '../../../../main/ets/vm/NtfCloseVM';
import { NtfGroupItemModifier } from '../../../../main/ets/model/NtfItemModifier';
import { WDefault } from '@ohos/screenlockcommon';
import { ResUtils } from '@ohos/windowscene';
import { AccessibilityCollapsedState } from '@ohos/systemuicommon/src/main/ets/accessibility/AccessibilityAppName';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/phone/NotificationGroupBrief';
export default function Test() {
  describe('onNtfEntryChange_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_return_immediately_when_ntfEntry_is_null', 0, async () => {
      let ntfEntry: NotificationEntry = null;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      notificationGroupBrief.onNtfEntryChange();
    });

    it('should_execute_all_steps_when_ntfEntry_is_not_null', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.childrenEntry = [];
      ntfEntry.deliveryTime = 123456789;
      ntfEntry.appName = 'testApp';
      ntfEntry.overlayIcon = 'testIcon';
      ntfEntry.isDisplayAtTop = true;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationGroupBrief.onNtfEntryChange();
      mocker.ignoreMock(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
    });

    it('should_update_timeVm_when_deliveryTime_is_different', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.childrenEntry = [];
      ntfEntry.deliveryTime = 123456789;
      ntfEntry.appName = 'testApp';
      ntfEntry.overlayIcon = 'testIcon';
      ntfEntry.isDisplayAtTop = true;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationGroupBrief.onNtfEntryChange();
      mocker.ignoreMock(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
    });

    it('should_return_immediately_when_ntfEntry_is_null', 0, async () => {
      let ntfEntry: NotificationEntry = null;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      notificationGroupBrief.onNtfEntryChange();
    });

    it('should_execute_all_steps_when_ntfEntry_is_not_null', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.childrenEntry = [];
      ntfEntry.deliveryTime = 123456789;
      ntfEntry.appName = 'testApp';
      ntfEntry.overlayIcon = 'testIcon';
      ntfEntry.isDisplayAtTop = true;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationGroupBrief.onNtfEntryChange();
      mocker.ignoreMock(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
    });

    it('should_update_timeVm_when_deliveryTime_is_different', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.childrenEntry = [];
      ntfEntry.deliveryTime = 123456789;
      ntfEntry.appName = 'testApp';
      ntfEntry.overlayIcon = 'testIcon';
      ntfEntry.isDisplayAtTop = true;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationGroupBrief.onNtfEntryChange();
      mocker.ignoreMock(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
    });

    it('should_return_immediately_when_ntfEntry_is_null', 0, async () => {
      let ntfEntry: NotificationEntry = null;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;}
      };
      notificationGroupBrief.onNtfEntryChange();
    });

    it('should_execute_all_steps_when_ntfEntry_is_not_null', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.childrenEntry = [];
      ntfEntry.deliveryTime = 123456789;
      ntfEntry.appName = 'testApp';
      ntfEntry.overlayIcon = 'testIcon';
      ntfEntry.isDisplayAtTop = true;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationGroupBrief.onNtfEntryChange();
      mocker.ignoreMock(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
    });

    it('should_update_timeVm_when_deliveryTime_is_different', 0, async () => {
      let ntfEntry: NotificationEntry = new NotificationEntry();
      ntfEntry.childrenEntry = [];
      ntfEntry.deliveryTime = 123456789;
      ntfEntry.appName = 'testApp';
      ntfEntry.overlayIcon = 'testIcon';
      ntfEntry.isDisplayAtTop = true;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(null);
      notificationGroupBrief.onNtfEntryChange();
      mocker.ignoreMock(notificationGroupBrief, notificationGroupBrief.onNtfEntryChange);
    });

    it('should_return_immediately_when_ntfEntry_is_null', 0, async () => {
      let ntfEntry: NotificationEntry = null;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      notificationGroupBrief.onNtfEntryChange();
    });

    it('should_return_immediately_when_ntfEntry_is_null', 0, async () => {
      let ntfEntry: NotificationEntry = null;
      let config: NotificationConfig = new NotificationConfig();
      let ntfDataUpdateListener: NtfDataUpdateListener = new NtfDataUpdateListener();
      let ntfColorModeVM: NtfColorModeVM = new NtfColorModeVM();
      let ntfTimeVM: NtfTimeVM = new NtfTimeVM();
      let ntfAppIconModifier: NtfAppIconModifier = new NtfAppIconModifier();
      let ntfItemStyle: NotificationItemStyle = new NotificationItemStyle();
      let notificationStyle: notificationStyle = new notificationStyle();
      let ntfCloseVM: NtfCloseVM = new NtfCloseVM();
      let ntfGroupItemModifier: NtfGroupItemModifier = new NtfGroupItemModifier();
      let immersiveAodStyle: ImmersiveAodStyle = new ImmersiveAodStyle();
      let deviceHelper: DeviceHelper = new DeviceHelper();
      let logHelper: LogHelper = new LogHelper(LogDomain.NOTIFICATION, 'test');
      let commonUtils: CommonUtils = new CommonUtils();
      let itemUtils: ItemUtils = new ItemUtils();
      let rTLUtil: RTLUtil = new RTLUtil();
      let fontScaleManager: fontScaleManager = new fontScaleManager();
      let ntfViewConfigManager: ntfViewConfigManager = new ntfViewConfigManager();
      let ntfListContentConfig: NtfListContentConfig = new NtfListContentConfig();
      let pinTopIcon: pinTopIcon = new pinTopIcon();
      let notificationGroupExpandAnimation: NotificationGroupExpandAnimation = new NotificationGroupExpandAnimation();
      let wDefault: WDefault = new WDefault();
      let resUtils: ResUtils = new ResUtils();
      let brightnessOptionUtils: BrightnessOptionUtils = new BrightnessOptionUtils();
      let notificationGroupBrief: {
        onNtfEntryChange: Function
      } = {
        onNtfEntryChange: (anim?: AnimateParam) => {
          return;
        }
      };
      notificationGroupBrief.onNtfEntryChange();
    });
  })
}
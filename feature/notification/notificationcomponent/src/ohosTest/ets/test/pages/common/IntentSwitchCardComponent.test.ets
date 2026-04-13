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

import { LogHelper, LogDomain } from '@ohos/basicutils';
import { bannerMgr, DarkModeState } from '@ohos/systemuicommon';
import { NtfItemName } from '../../../../main/ets/intent/IntentCodeConstant';
import { LengthMetrics } from '@ohos.arkui.node';
import uiAppearance from '@ohos.uiAppearance';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import {  } from '../../../../main/ets/pages/common/IntentSwitchCardComponent';
export default function Test() {
  describe('switchIsOn_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_true_when_itemName_is_APP_NTF_CONFIG_HIDE_CONTENT_and_secureVal_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('true');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_false_when_itemName_is_APP_LIVE_VIEW_CONFIG_HIDE_CONTENT_and_secureVal_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('false');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_APP_LIVE_VIEW_CONFIG_HIDE_CONTENT_and_secureVal_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('true');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_secureVal_is_1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('1');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_false_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_secureVal_is_0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('0');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_false_when_itemName_is_APP_NTF_CONFIG_HIDE_CONTENT_and_secureVal_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('false');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_APP_NTF_CONFIG_HIDE_CONTENT_and_secureVal_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('true');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_false_when_itemName_is_APP_LIVE_VIEW_CONFIG_HIDE_CONTENT_and_secureVal_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('false');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_APP_LIVE_VIEW_CONFIG_HIDE_CONTENT_and_secureVal_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('true');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_secureVal_is_1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('1');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_false_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_secureVal_is_0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('0');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_unknown_and_secureVal_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('true');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = 'unknown';
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });
    it('should_return_false_when_itemName_is_APP_NTF_CONFIG_HIDE_CONTENT_and_secureVal_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('false');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_APP_NTF_CONFIG_HIDE_CONTENT_and_secureVal_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('true');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_false_when_itemName_is_APP_LIVE_VIEW_CONFIG_HIDE_CONTENT_and_secureVal_is_false', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('false');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_APP_LIVE_VIEW_CONFIG_HIDE_CONTENT_and_secureVal_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('true');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_secureVal_is_1', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('1');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_false_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_secureVal_is_0', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('0');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      const result = testClass.switchIsOn();
      expect(result).assertEqual(false);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_true_when_itemName_is_unknown_and_secureVal_is_true', 0, async () => {
      let mocker: MockKit = new MockKit();
      let mockGetSecureValue: Function = mocker.mockFunc(sSettingsUtil, sSettingsUtil.getSecureValue);
      when(mockGetSecureValue)(ArgumentMatchers.anyString, ArgumentMatchers.anyString, ArgumentMatchers.anyObj)
        .afterReturn('true');

      let mockShowInfo: Function = mocker.mockFunc(LogHelper, LogHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString, ArgumentMatchers.any()).afterReturnNothing();

      let testClass: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      testClass.itemName = 'unknown';
      const result = testClass.switchIsOn();
      expect(result).assertEqual(true);

      mocker.ignoreMock(sSettingsUtil, sSettingsUtil.getSecureValue);
      mocker.ignoreMock(LogHelper, LogHelper.showInfo);
    });

    it('should_return_false_when_itemName_is_APP_NTF_CONFIG_HIDE_CONTENT_and_isOn_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = new LogHelper();
      let logDomain: LogDomain = new LogDomain();
      when(mocker.mockFunc(logHelper, logHelper.info))(ArgumentMatchers.any).afterReturn(logDomain);

      let sSettingsUtilInstance: sSettingsUtil = sSettingsUtil.getInstance();
      when(mocker.mockFunc(sSettingsUtilInstance, sSettingsUtilInstance.getValue))(ArgumentMatchers.any).afterReturn('false');

      let bannerMgrInstance: bannerMgr = bannerMgr.getInstance();
      when(mocker.mockFunc(bannerMgrInstance, bannerMgrInstance.getDarkModeState)).afterReturn(DarkModeState.OFF);

      let uiNode: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      uiNode.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_CONTENT;
      expect(uiNode.getSetValFromSwitch(true)).assertEqual('false');

      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(sSettingsUtilInstance, sSettingsUtilInstance.getValue);
      mocker.ignoreMock(bannerMgrInstance, bannerMgrInstance.getDarkModeState);
    });

    it('should_return_true_when_itemName_is_APP_NTF_CONFIG_HIDE_CONTENT_and_isOn_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = new LogHelper();
      let logDomain: LogDomain = new LogDomain();
      when(mocker.mockFunc(logHelper, logHelper.info))(ArgumentMatchers.any).afterReturn(logDomain);

      let sSettingsUtilInstance: sSettingsUtil = sSettingsUtil.getInstance();
      when(mocker.mockFunc(sSettingsUtilInstance, sSettingsUtilInstance.getValue))(ArgumentMatchers.any).afterReturn('false');

      let bannerMgrInstance: bannerMgr = bannerMgr.getInstance();
      when(mocker.mockFunc(bannerMgrInstance, bannerMgrInstance.getDarkModeState)).afterReturn(DarkModeState.OFF);
      let uiNode: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      uiNode.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_CONTENT;
      expect(uiNode.getSetValFromSwitch(false)).assertEqual('true');
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(sSettingsUtilInstance, sSettingsUtilInstance.getValue);
      mocker.ignoreMock(bannerMgrInstance, bannerMgrInstance.getDarkModeState);
    });

    it('should_return_false_when_itemName_is_APP_LIVE_VIEW_CONFIG_HIDE_CONTENT_and_isOn_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = new LogHelper();
      let logDomain: LogDomain = new LogDomain();
      when(mocker.mockFunc(logHelper, logHelper.info))(ArgumentMatchers.any).afterReturn(logDomain);

      let sSettingsUtilInstance: sSettingsUtil = sSettingsUtil.getInstance();
      when(mocker.mockFunc(sSettingsUtilInstance, sSettingsUtilInstance.getValue))(ArgumentMatchers.any).afterReturn('false');

      let bannerMgrInstance: bannerMgr = bannerMgr.getInstance();
      when(mocker.mockFunc(bannerMgrInstance, bannerMgrInstance.getDarkModeState)).afterReturn(DarkModeState.OFF);

      let uiNode: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      uiNode.itemName = NtfItemName.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT;
      expect(uiNode.getSetValFromSwitch(true)).assertEqual('false');

      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(sSettingsUtilInstance, sSettingsUtilInstance.getValue);
      mocker.ignoreMock(bannerMgrInstance, bannerMgrInstance.getDarkModeState);
    });

    it('should_return_true_when_itemName_is_APP_LIVE_VIEW_CONFIG_HIDE_CONTENT_and_isOn_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = new LogHelper();
      let logDomain: LogDomain = new LogDomain();
      when(mocker.mockFunc(logHelper, logHelper.info))(ArgumentMatchers.any).afterReturn(logDomain);
      let sSettingsUtilInstance: sSettingsUtil = sSettingsUtil.getInstance();
      when(mocker.mockFunc(sSettingsUtilInstance, sSettingsUtilInstance.getValue))(ArgumentMatchers.any).afterReturn('false');
      let bannerMgrInstance: bannerMgr = bannerMgr.getInstance();
      when(mocker.mockFunc(bannerMgrInstance, bannerMgrInstance.getDarkModeState)).afterReturn(DarkModeState.OFF);
      let uiNode: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      uiNode.itemName = NtfItemName.APP_LIVE_VIEW_CONFIG_HIDE_CONTENT;
      expect(uiNode.getSetValFromSwitch(false)).assertEqual('true');

      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(sSettingsUtilInstance, sSettingsUtilInstance.getValue);
      mocker.ignoreMock(bannerMgrInstance, bannerMgrInstance.getDarkModeState);
    });

    it('should_return_1_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_isOn_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = new LogHelper();
      let logDomain: LogDomain = new LogDomain();
      when(mocker.mockFunc(logHelper, logHelper.info))(ArgumentMatchers.any).afterReturn(logDomain);

      let sSettingsUtilInstance: sSettingsUtil = sSettingsUtil.getInstance();
      when(mocker.mockFunc(sSettingsUtilInstance, sSettingsUtilInstance.getValue))(ArgumentMatchers.any).afterReturn('false');

      let bannerMgrInstance: bannerMgr = bannerMgr.getInstance();
      when(mocker.mockFunc(bannerMgrInstance, bannerMgrInstance.getDarkModeState)).afterReturn(DarkModeState.OFF);

      let uiNode: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      uiNode.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      expect(uiNode.getSetValFromSwitch(true)).assertEqual('1');

      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(sSettingsUtilInstance, sSettingsUtilInstance.getValue);
      mocker.ignoreMock(bannerMgrInstance, bannerMgrInstance.getDarkModeState);
    });

    it('should_return_false_when_itemName_is_APP_NTF_CONFIG_HIDE_CONTENT_and_isOn_is_true', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = new LogHelper();
      let logDomain: LogDomain = new LogDomain();
      when(mocker.mockFunc(logHelper, logHelper.info))(ArgumentMatchers.any).afterReturn(logDomain);
      let sSettingsUtilInstance: sSettingsUtil = sSettingsUtil.getInstance();
      when(mocker.mockFunc(sSettingsUtilInstance, sSettingsUtilInstance.getValue))(ArgumentMatchers.any).afterReturn('false');
      let bannerMgrInstance: bannerMgr = bannerMgr.getInstance();
      when(mocker.mockFunc(bannerMgrInstance, bannerMgrInstance.getDarkModeState)).afterReturn(DarkModeState.OFF);
      let uiNode: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      uiNode.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_CONTENT;
      expect(uiNode.getSetValFromSwitch(true)).assertEqual('false');
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(sSettingsUtilInstance, sSettingsUtilInstance.getValue);
      mocker.ignoreMock(bannerMgrInstance, bannerMgrInstance.getDarkModeState);
    });
    it('should_return_0_when_itemName_is_APP_NTF_CONFIG_HIDE_BANNER_CONTENT_and_isOn_is_false', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = new LogHelper();
      let logDomain: LogDomain = new LogDomain();
      when(mocker.mockFunc(logHelper, logHelper.info))(ArgumentMatchers.any).afterReturn(logDomain);

      let sSettingsUtilInstance: sSettingsUtil = sSettingsUtil.getInstance();
      when(mocker.mockFunc(sSettingsUtilInstance, sSettingsUtilInstance.getValue))(ArgumentMatchers.any).afterReturn('false');
      let bannerMgrInstance: bannerMgr = bannerMgr.getInstance();
      when(mocker.mockFunc(bannerMgrInstance, bannerMgrInstance.getDarkModeState)).afterReturn(DarkModeState.OFF);
      let uiNode: IntentSwitchCardComponent = new IntentSwitchCardComponent();
      uiNode.itemName = NtfItemName.APP_NTF_CONFIG_HIDE_BANNER_CONTENT;
      expect(uiNode.getSetValFromSwitch(false)).assertEqual('0');
      mocker.ignoreMock(logHelper, logHelper.info);
      mocker.ignoreMock(sSettingsUtilInstance, sSettingsUtilInstance.getValue);
      mocker.ignoreMock(bannerMgrInstance, bannerMgrInstance.getDarkModeState);
    });

  })
}
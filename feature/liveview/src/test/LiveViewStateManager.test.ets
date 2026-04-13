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
  ArrayUtils,
  CommonUtils,
  LogDomain,
  LogHelper,
  SingletonHelper
} from '@ohos/basicutils';
import { CustomPromise, EvtBus, EventManager } from '@ohos/frameworkwrapper';
import {
  HeadsUpChangeEvent,
  ForegroundAppEvent,
  LiveViewData,
  SysTypeCode,
  LiveViewCommonConstants,
  LiveType,
  LiveNavigationTemplate
} from '@ohos/systemuicommon';
import {
  SceneFlag
} from '@ohos/systemuicommon';
import { baseStateMgr } from '@ohos/systemuicommon';
import {
  DisplaySizeState,
  IState
} from '@ohos/systemuicommon';
import { StateType } from '@ohos/systemuicommon';
import { OnStateChangeListener } from '@ohos/systemuicommon';
import { BannerPanelTypeState } from '@ohos/systemuicommon';
import { bannerMgr } from '@ohos/systemuicommon';
import { LiveViewConstants } from '../../../main/ets/common/LiveViewConstants';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveViewStateManager } from '../../../main/ets/common/LiveViewStateManager';
export default function LiveViewStateManagerTest() {
  describe('getContainerDefaultHeight_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_false', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_true', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = true;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_system_height_when_liveType_is_TYPE_SYSTEM', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.TYPE_SYSTEM;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveType_is_NO_LAYOUT', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.NO_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveNavigationTemplate_is_navigationWithoutDirections', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.WITH_LAYOUT;
      data.navigationTemplate = LiveNavigationTemplate.NavigationWithoutDirections;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_third_party_height_when_none_of_the_above_conditions_are_met', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.NORMAL;
      data.liveType = LiveType.WITH_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_false', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_true', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = true;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_system_height_when_liveType_is_TYPE_SYSTEM', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.TYPE_SYSTEM;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveType_is_NO_LAYOUT', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.NO_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveNavigationTemplate_is_navigationWithoutDirections', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.WITH_LAYOUT;
      data.navigationTemplate = LiveNavigationTemplate.NavigationWithoutDirections;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_third_party_height_when_none_of_the_above_conditions_are_met', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.NORMAL;
      data.liveType = LiveType.WITH_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_false', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_true', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = true;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_system_height_when_liveType_is_TYPE_SYSTEM', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.TYPE_SYSTEM;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveType_is_NO_LAYOUT', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.NO_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveNavigationTemplate_is_navigationWithoutDirections', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.WITH_LAYOUT;
      data.navigationTemplate = LiveNavigationTemplate.NavigationWithoutDirections;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_third_party_height_when_none_of_the_above_conditions_are_met', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.NORMAL;
      data.liveType = LiveType.WITH_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_false', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_true', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = true;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_system_height_when_liveType_is_TYPE_SYSTEM', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.TYPE_SYSTEM;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveType_is_NO_LAYOUT', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.NO_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveNavigationTemplate_is_navigationWithoutDirections', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.WITH_LAYOUT;
      data.navigationTemplate = LiveNavigationTemplate.NavigationWithoutDirections;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_third_party_height_when_none_of_the_above_conditions_are_met', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.NORMAL;
      data.liveType = LiveType.WITH_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_false', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_true', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = true;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_system_height_when_liveType_is_TYPE_SYSTEM', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.TYPE_SYSTEM;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveType_is_NO_LAYOUT', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.NO_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveNavigationTemplate_is_navigationWithoutDirections', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.WITH_LAYOUT;
      data.navigationTemplate = LiveNavigationTemplate.NavigationWithoutDirections;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_third_party_height_when_none_of_the_above_conditions_are_met', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.NORMAL;
      data.liveType = LiveType.WITH_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_false', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_true', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = true;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_system_height_when_liveType_is_TYPE_SYSTEM', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.TYPE_SYSTEM;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveType_is_NO_LAYOUT', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.NO_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveNavigationTemplate_is_navigationWithoutDirections', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.WITH_LAYOUT;
      data.navigationTemplate = LiveNavigationTemplate.NavigationWithoutDirections;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_third_party_height_when_none_of_the_above_conditions_are_met', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.NORMAL;
      data.liveType = LiveType.WITH_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_false', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_true', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = true;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_system_height_when_liveType_is_TYPE_SYSTEM', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.TYPE_SYSTEM;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveType_is_NO_LAYOUT', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.NO_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveNavigationTemplate_is_navigationWithoutDirections', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.WITH_LAYOUT;
      data.navigationTemplate = LiveNavigationTemplate.NavigationWithoutDirections;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_third_party_height_when_none_of_the_above_conditions_are_met', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.NORMAL;
      data.liveType = LiveType.WITH_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_false', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_third_party_height_when_sysTypeCode_is_BROADCASTING_CENTER_and_isOuterHomeFolded_is_true', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.BROADCASTING_CENTER;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = true;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
    it('should_return_system_height_when_liveType_is_TYPE_SYSTEM', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.TYPE_SYSTEM;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveType_is_NO_LAYOUT', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.NO_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_system_height_when_liveNavigationTemplate_is_navigationWithoutDirections', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.liveType = LiveType.WITH_LAYOUT;
      data.navigationTemplate = LiveNavigationTemplate.NavigationWithoutDirections;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.SYSTEM_CARD_HEIGHT, fontScale, LiveViewCommonConstants.SYSTEM_CARD_FONT_AREA));
    });
    it('should_return_third_party_height_when_none_of_the_above_conditions_are_met', 0, () => {
      let liveviewstatemanager: LiveViewStateManager = new LiveViewStateManager();
      let data: LiveViewData = new LiveViewData();
      data.sysTypeCode = SysTypeCode.NORMAL;
      data.liveType = LiveType.WITH_LAYOUT;
      let fontScale: number = 1;
      let isOuterHomeFolded: boolean = false;
      const result = liveviewstatemanager.getContainerDefaultHeight(data, fontScale, isOuterHomeFolded);
      expect(result).assertEqual(LiveViewCommonConstants.getCardHeight(LiveViewConstants.THIRD_PARTY_CARD_HEIGHT, fontScale, LiveViewCommonConstants.OTHER_CARD_FONT_FIXED_AREA));
    });
  });
}

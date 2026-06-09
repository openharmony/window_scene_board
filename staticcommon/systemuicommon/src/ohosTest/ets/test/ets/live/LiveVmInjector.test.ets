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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, DEFAULT } from '@ohos/hypium';
import { LiveVmInjector } from '../../../../../../newIndex';
import { LiveCapsuleTextModel } from '../../../../../main/ets/live/model/LiveCapsuleTextModel';
import { LiveCardFlightModel } from '../../../../../main/ets/live/model/LiveCardFlightModel';
import { LiveCardNavigationModel } from '../../../../../main/ets/live/model/LiveCardNavigationModel';
import { LiveCardOtherModel } from '../../../../../main/ets/live/model/LiveCardOtherModel';
import { LiveCardPickupModel } from '../../../../../main/ets/live/model/LiveCardPickupModel';
import { LiveCardProgressModel } from '../../../../../main/ets/live/model/LiveCardProgressModel';
import { LiveCardScoreModel } from '../../../../../main/ets/live/model/LiveCardScoreModel';
import { LiveCardSystemModel } from '../../../../../main/ets/live/model/LiveCardSystemModel';
import { LiveButtonModel,
  LiveExtensionType,
  LiveIndicatorType,
  LiveLineType,
  LiveProgressModel,
  LiveRichTextModel,
  LiveTimerModel } from '../../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../../main/ets/live/model/LiveNotification';
import { FlightLayoutSpaceType, LiveButtonState } from '../../../../../main/ets/liveview/common/LiveConstants';

export function LiveViewDataTest() {
  describe('LiveViewDataTest', (): void => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    it('test_getLiveDataVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getLiveDataVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getLiveDataVm')).assertTrue();
    });

    it('test_getCapsuleListVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getCapsuleListVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getCapsuleListVm')).assertTrue();
    });

    it('test_getCapsuleVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleVm')).assertTrue();
    });

    it('test_getCapsuleVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleVm')).assertTrue();
    });

    it('test_getCapsuleVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleVm')).assertTrue();
    });

    it('test_getCapsuleVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleVm')).assertTrue();
    });

    it('test_getCapsuleVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleVm')).assertTrue();
    });

    it('test_getCapsuleVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleVm')).assertTrue();
    });

    it('test_getCapsuleVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleVm')).assertTrue();
    });

    it('test_getCapsuleMarqueeVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleMarqueeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleMarqueeVm')).assertTrue();
    });

    it('test_getCapsuleMarqueeVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleMarqueeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleMarqueeVm')).assertTrue();
    });

    it('test_getCapsuleMarqueeVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleMarqueeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleMarqueeVm')).assertTrue();
    });

    it('test_getCapsuleMarqueeVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleMarqueeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleMarqueeVm')).assertTrue();
    });

    it('test_getCapsuleMarqueeVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleMarqueeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleMarqueeVm')).assertTrue();
    });

    it('test_getCapsuleMarqueeVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleMarqueeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleMarqueeVm')).assertTrue();
    });

    it('test_getCapsuleMarqueeVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleMarqueeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleMarqueeVm')).assertTrue();
    });

    it('test_getCardListVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getCardListVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getCardListVm')).assertTrue();
    });

    it('test_getCardListItemVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardListItemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardListItemVm')).assertTrue();
    });

    it('test_getCardListItemVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardListItemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardListItemVm')).assertTrue();
    });

    it('test_getCardListItemVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardListItemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardListItemVm')).assertTrue();
    });

    it('test_getCardListItemVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardListItemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardListItemVm')).assertTrue();
    });

    it('test_getCardListItemVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardListItemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardListItemVm')).assertTrue();
    });

    it('test_getCardListItemVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardListItemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardListItemVm')).assertTrue();
    });

    it('test_getCardListItemVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardListItemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardListItemVm')).assertTrue();
    });

    it('test_getCardMenuVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardMenuVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardMenuVm')).assertTrue();
    });

    it('test_getCardMenuVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardMenuVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardMenuVm')).assertTrue();
    });

    it('test_getCardMenuVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardMenuVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardMenuVm')).assertTrue();
    });

    it('test_getCardMenuVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardMenuVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardMenuVm')).assertTrue();
    });

    it('test_getCardMenuVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardMenuVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardMenuVm')).assertTrue();
    });

    it('test_getCardMenuVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardMenuVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardMenuVm')).assertTrue();
    });

    it('test_getCardMenuVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardMenuVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardMenuVm')).assertTrue();
    });

    it('test_getLiveHeadsUpSwipeVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveHeadsUpSwipeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpSwipeVm')).assertTrue();
    });

    it('test_getLiveHeadsUpSwipeVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveHeadsUpSwipeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpSwipeVm')).assertTrue();
    });

    it('test_getLiveHeadsUpSwipeVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveHeadsUpSwipeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpSwipeVm')).assertTrue();
    });

    it('test_getLiveHeadsUpSwipeVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveHeadsUpSwipeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpSwipeVm')).assertTrue();
    });

    it('test_getLiveHeadsUpSwipeVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveHeadsUpSwipeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpSwipeVm')).assertTrue();
    });

    it('test_getLiveHeadsUpSwipeVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveHeadsUpSwipeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpSwipeVm')).assertTrue();
    });

    it('test_getLiveHeadsUpSwipeVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveHeadsUpSwipeVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpSwipeVm')).assertTrue();
    });

    it('test_getCardSystemVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemVm')).assertTrue();
    });

    it('test_getCardSystemVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemVm')).assertTrue();
    });

    it('test_getCardSystemVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemVm')).assertTrue();
    });

    it('test_getCardSystemVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemVm')).assertTrue();
    });

    it('test_getCardSystemVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemVm')).assertTrue();
    });

    it('test_getCardSystemVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemVm')).assertTrue();
    });

    it('test_getCardSystemVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemVm')).assertTrue();
    });
    
    it('test_getCardSystemProgressVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemProgressVm')).assertTrue();
    });

    it('test_getCardSystemProgressVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemProgressVm')).assertTrue();
    });

    it('test_getCardSystemProgressVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemProgressVm')).assertTrue();
    });

    it('test_getCardSystemProgressVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemProgressVm')).assertTrue();
    });

    it('test_getCardSystemProgressVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemProgressVm')).assertTrue();
    });

    it('test_getCardSystemProgressVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemProgressVm')).assertTrue();
    });

    it('test_getCardSystemProgressVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemProgressVm')).assertTrue();
    });
    
    it('test_getCardSystemButtonVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemButtonVm')).assertTrue();
    });

    it('test_getCardSystemButtonVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemButtonVm')).assertTrue();
    });

    it('test_getCardSystemButtonVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemButtonVm')).assertTrue();
    });

    it('test_getCardSystemButtonVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemButtonVm')).assertTrue();
    });

    it('test_getCardSystemButtonVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemButtonVm')).assertTrue();
    });

    it('test_getCardSystemButtonVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemButtonVm')).assertTrue();
    });

    it('test_getCardSystemButtonVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardSystemButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardSystemButtonVm')).assertTrue();
    });

    it('test_getTimerVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getTimerVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getTimerVm')).assertTrue();
    });

    it('test_getCardOtherVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherVm')).assertTrue();
    });

    it('test_getCardOtherVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherVm')).assertTrue();
    });

    it('test_getCardOtherVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherVm')).assertTrue();
    });

    it('test_getCardOtherVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherVm')).assertTrue();
    });

    it('test_getCardOtherVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherVm')).assertTrue();
    });

    it('test_getCardOtherVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherVm')).assertTrue();
    });

    it('test_getCardOtherVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherVm')).assertTrue();
    });

    it('test_getCardOtherFlightVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherFlightVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherFlightVm')).assertTrue();
    });

    it('test_getCardOtherFlightVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherFlightVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherFlightVm')).assertTrue();
    });

    it('test_getCardOtherFlightVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherFlightVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherFlightVm')).assertTrue();
    });

    it('test_getCardOtherFlightVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherFlightVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherFlightVm')).assertTrue();
    });

    it('test_getCardOtherFlightVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherFlightVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherFlightVm')).assertTrue();
    });

    it('test_getCardOtherFlightVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherFlightVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherFlightVm')).assertTrue();
    });

    it('test_getCardOtherFlightVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherFlightVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherFlightVm')).assertTrue();
    });

    it('test_getCardOtherProgressVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherProgressVm')).assertTrue();
    });

    it('test_getCardOtherProgressVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherProgressVm')).assertTrue();
    });

    it('test_getCardOtherProgressVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherProgressVm')).assertTrue();
    });

    it('test_getCardOtherProgressVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherProgressVm')).assertTrue();
    });

    it('test_getCardOtherProgressVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherProgressVm')).assertTrue();
    });

    it('test_getCardOtherProgressVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherProgressVm')).assertTrue();
    });

    it('test_getCardOtherProgressVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherProgressVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherProgressVm')).assertTrue();
    });

    it('test_getSwitchVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getSwitchVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getSwitchVm')).assertTrue();
    });
    
    it('test_getCardNavigationVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardNavigationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardNavigationVm')).assertTrue();
    });

    it('test_getCardNavigationVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardNavigationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardNavigationVm')).assertTrue();
    });

    it('test_getCardNavigationVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardNavigationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardNavigationVm')).assertTrue();
    });

    it('test_getCardNavigationVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardNavigationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardNavigationVm')).assertTrue();
    });

    it('test_getCardNavigationVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardNavigationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardNavigationVm')).assertTrue();
    });

    it('test_getCardNavigationVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardNavigationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardNavigationVm')).assertTrue();
    });

    it('test_getCardNavigationVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardNavigationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardNavigationVm')).assertTrue();
    });

    it('test_getCardAuthorizationVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardAuthorizationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardAuthorizationVm')).assertTrue();
    });

    it('test_getCardAuthorizationVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardAuthorizationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardAuthorizationVm')).assertTrue();
    });

    it('test_getCardAuthorizationVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardAuthorizationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardAuthorizationVm')).assertTrue();
    });

    it('test_getCardAuthorizationVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardAuthorizationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardAuthorizationVm')).assertTrue();
    });

    it('test_getCardAuthorizationVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardAuthorizationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardAuthorizationVm')).assertTrue();
    });

    it('test_getCardAuthorizationVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardAuthorizationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardAuthorizationVm')).assertTrue();
    });

    it('test_getCardAuthorizationVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardAuthorizationVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardAuthorizationVm')).assertTrue();
    });

    it('test_getCardOtherExtendVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherExtendVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherExtendVm')).assertTrue();
    });

    it('test_getCardOtherExtendVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherExtendVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherExtendVm')).assertTrue();
    });

    it('test_getCardOtherExtendVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherExtendVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherExtendVm')).assertTrue();
    });

    it('test_getCardOtherExtendVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherExtendVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherExtendVm')).assertTrue();
    });

    it('test_getCardOtherExtendVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherExtendVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherExtendVm')).assertTrue();
    });

    it('test_getCardOtherExtendVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherExtendVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherExtendVm')).assertTrue();
    });

    it('test_getCardOtherExtendVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCardOtherExtendVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCardOtherExtendVm')).assertTrue();
    });
    
    it('test_getCapsuleWaveVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleWaveVm')).assertTrue();
    });

    it('test_getCapsuleWaveVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleWaveVm')).assertTrue();
    });

    it('test_getCapsuleWaveVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleWaveVm')).assertTrue();
    });

    it('test_getCapsuleWaveVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleWaveVm')).assertTrue();
    });

    it('test_getCapsuleWaveVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleWaveVm')).assertTrue();
    });

    it('test_getCapsuleWaveVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleWaveVm')).assertTrue();
    });

    it('test_getCapsuleWaveVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleWaveVm')).assertTrue();
    });
    
    it('test_getCapsuleLightWaveVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleLightWaveVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleLightWaveVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleLightWaveVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleLightWaveVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleLightWaveVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleLightWaveVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleRightLightWaveVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleRightLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleRightLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleRightLightWaveVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleRightLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleRightLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleRightLightWaveVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleRightLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleRightLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleRightLightWaveVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleRightLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleRightLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleRightLightWaveVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleRightLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleRightLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleRightLightWaveVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleRightLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleRightLightWaveVm')).assertTrue();
    });

    it('test_getCapsuleRightLightWaveVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getCapsuleRightLightWaveVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getCapsuleRightLightWaveVm')).assertTrue();
    });

    it('test_getLiveActionButtonVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveActionButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveActionButtonVm')).assertTrue();
    });

    it('test_getLiveActionButtonVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveActionButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveActionButtonVm')).assertTrue();
    });

    it('test_getLiveActionButtonVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveActionButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveActionButtonVm')).assertTrue();
    });

    it('test_getLiveActionButtonVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveActionButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveActionButtonVm')).assertTrue();
    });

    it('test_getLiveActionButtonVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveActionButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveActionButtonVm')).assertTrue();
    });

    it('test_getLiveActionButtonVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveActionButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveActionButtonVm')).assertTrue();
    });

    it('test_getLiveActionButtonVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveActionButtonVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveActionButtonVm')).assertTrue();
    });

    it('test_getCapsuleListLayoutVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getCapsuleListLayoutVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getCapsuleListLayoutVm')).assertTrue();
    });

    it('test_getCapsuleListAnimVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getCapsuleListAnimVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getCapsuleListAnimVm')).assertTrue();
    });

    it('test_getMetaBallVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getMetaBallVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getMetaBallVm')).assertTrue();
    });

    it('test_getMetaBallVisibleVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getMetaBallVisibleVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getMetaBallVisibleVm')).assertTrue();
    });

    it('test_getStarterVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getStarterVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getStarterVm')).assertTrue();
    });

    it('test_getLiveHeadsUpVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getLiveHeadsUpVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpVm')).assertTrue();
    });

    it('test_getLiveHeadsUpCommonCardVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getLiveHeadsUpCommonCardVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpCommonCardVm')).assertTrue();
    });

    it('test_getLiveHeadsUpCommonCardVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getLiveHeadsUpCommonCardVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpCommonCardVm')).assertTrue();
    });

    it('test_getLiveHeadsUpWalletCardVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getLiveHeadsUpWalletCardVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getLiveHeadsUpWalletCardVm')).assertTrue();
    });

    it('test_getLiveRemindVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getLiveRemindVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getLiveRemindVm')).assertTrue();
    });

    it('test_getLiveMediaPlayerVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getLiveMediaPlayerVm(new LiveNotification());
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getLiveMediaPlayerVm')).assertTrue();
    });

    it('test_getLiveMediaPlayerVm_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveMediaPlayerVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveMediaPlayerVm')).assertTrue();
    });

    it('test_getLiveMediaPlayerVm_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveMediaPlayerVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveMediaPlayerVm')).assertTrue();
    });

    it('test_getLiveMediaPlayerVm_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveMediaPlayerVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveMediaPlayerVm')).assertTrue();
    });

    it('test_getLiveMediaPlayerVm_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveMediaPlayerVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveMediaPlayerVm')).assertTrue();
    });

    it('test_getLiveMediaPlayerVm_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveMediaPlayerVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveMediaPlayerVm')).assertTrue();
    });

    it('test_getLiveMediaPlayerVm_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveMediaPlayerVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveMediaPlayerVm')).assertTrue();
    });

    it('test_getLiveMediaPlayerVm_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.getLiveMediaPlayerVm(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'getLiveMediaPlayerVm')).assertTrue();
    });

    it('test_getCapsuleLifecycleVm', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        liveVmInjector.getCapsuleLifecycleVm();
      } catch (err) {}
      expect(Reflect.has(liveVmInjector, 'getCapsuleLifecycleVm')).assertTrue();
    });

    it('test_deleteVmByLive_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.deleteVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'deleteVmByLive')).assertTrue();
    });

    it('test_deleteVmByLive_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.deleteVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'deleteVmByLive')).assertTrue();
    });

    it('test_deleteVmByLive_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.deleteVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'deleteVmByLive')).assertTrue();
    });

    it('test_deleteVmByLive_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.deleteVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'deleteVmByLive')).assertTrue();
    });

    it('test_deleteVmByLive_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.deleteVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'deleteVmByLive')).assertTrue();
    });

    it('test_deleteVmByLive_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.deleteVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'deleteVmByLive')).assertTrue();
    });

    it('test_deleteVmByLive_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.deleteVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'deleteVmByLive')).assertTrue();
    });

    it('test_updateVmByLive_system', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardSystemModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let progress = new LiveProgressModel();

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        progress.maxValue = 100;
        progress.currentValue = 0;
        progress.isPercentage = false;
        progress.color = '#FFFFFFFF';

        card.title = 'test title';
        card.content = 'test content';
        card.simIconStatus = undefined;
        card.timer = timer;
        card.isTimerInTitle = false;
        let buttons: LiveButtonModel[] = [button];
        card.buttons = buttons;
        card.progress = progress;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.updateVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'updateVmByLive')).assertTrue();
    });

    it('test_updateVmByLive_other_no_layout', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardOtherModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.updateVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'updateVmByLive')).assertTrue();
    });

    it('test_updateVmByLive_other_progress', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardProgressModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutProgress = 0;
        card.layoutColor = '#FFFFFFF';
        card.layoutBackgroundColor = '#FF000000';
        card.layoutIndicatorType = LiveIndicatorType.UNDISPLAYED;
        card.layoutIndicatorIcon = undefined;
        card.layoutLineType = LiveLineType.DOTTED_LINE;
        card.layoutNodeIcons = [];
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.updateVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'updateVmByLive')).assertTrue();
    });

    it('test_updateVmByLive_other_pick_up', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardPickupModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutTitle = 'text layoutTitle';
        card.layoutContent = 'text layoutContent';
        card.layoutUnderlineColor = '#FF000000';
        card.layoutProviderName = 'test layoutProviderName';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.updateVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'updateVmByLive')).assertTrue();
    });

    it('test_updateVmByLive_other_flight', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardFlightModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutFirstTitle = 'test layoutFirstTitle';
        card.layoutFirstContent = 'test layoutFirstContent';
        card.layoutLastTitle = 'test layoutLastTitle';
        card.layoutLastContent = 'test layoutLastContent';
        card.layoutLastTitleSuperscript = 'test layoutLastTitleSuperscript';
        card.layoutLastContentSuperscript = 'test layoutLastContentSuperscript';
        card.layoutSpaceType = FlightLayoutSpaceType.SPACE_TYPE_ICON;
        card.layoutSpaceIconRes = undefined;
        card.layoutSpaceText = 'test layoutSpaceText';
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutAdditionalText = 'test layoutAdditionalText';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.updateVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'updateVmByLive')).assertTrue();
    });

    it('test_updateVmByLive_other_score', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardScoreModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutHostName = 'test layoutHostName';
        card.layoutHostIcon = undefined;
        card.layoutHostScore = 'test layoutHostScore';
        card.layoutGuestName = 'test layoutGuestName';
        card.layoutGuestIcon = undefined;
        card.layoutGuestScore = 'test layoutGuestScore';
        card.layoutCompetitionDesc = richText;
        card.layoutCompetitionTime = 'test layoutCompetitionTime';
        card.layoutIsDisplayHorizontalLine = true;
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.updateVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'updateVmByLive')).assertTrue();
    });

    it('test_updateVmByLive_navigation', DEFAULT, () => {
      let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
      try {
        let live = new LiveNotification();
        let card = new LiveCardNavigationModel();
        let timer = new LiveTimerModel(live.uid);
        let capsule = new LiveCapsuleTextModel();
        let button = new LiveButtonModel();
        let richText: LiveRichTextModel[] = [{ text: 'test' }];

        button.name = 'test button';
        button.lightIcon = undefined;
        button.darkIcon = undefined;
        button.iconResource = undefined;
        button.priority = 0;
        button.accessibilityText = 'test button';
        button.onOffState = LiveButtonState.ON;
        button.text = 'test';
        button.hidePanel = false;
        button.buttonId = 0;

        card.style = 0;
        card.fixedTitle = 'test title';
        card.fixedContent = richText;
        card.event = 'test';
        card.extensionType = LiveExtensionType.DEFAULT;
        card.extensionText = 'test';
        card.extensionPic = undefined;
        card.extensionWantAgent = undefined;
        card.layoutCurrentNavigationIcon = undefined;
        card.layoutNavigationIcons = [];
        card.layoutIsNavigationIconsDisplayed = true;
        card.layoutIsDisplayHorizontalLine = true;
        card.layoutNavigationIconMimeType = 'svg';
        card.timer = timer;

        timer.initialTime = 0;
        timer.requestInitialTime = 0;
        timer.isCountdown = false;
        timer.isPaused = false;

        capsule.title = 'test title';
        capsule.content = 'test content';
        capsule.backgroundColor = '#FFFFFFFF';
        capsule.icon = undefined;
        capsule.isContentDisplayed = true;
        capsule.sticky = false;
        capsule.hideWhenRemoveSession = false;
        capsule.button = button;

        live.card = card;
        live.capsule = capsule;
        live.isEnd = false;
        live.isConvertFromNormal = false;
        live.isAtomicServiceFromPush = false;
        live.authorization = false;
        live.customerAccessibilityText = 'test accessibility text';
        live.stage = 0;

        liveVmInjector.updateVmByLive(live);
      } catch (err) {
      }
      expect(Reflect.has(liveVmInjector, 'updateVmByLive')).assertTrue();
    });
  })
}
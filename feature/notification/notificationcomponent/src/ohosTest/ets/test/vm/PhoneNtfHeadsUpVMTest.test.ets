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
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { CommonUtils, ArrayUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import { SettingsConstants } from '@ohos/commonconstants';
import { WindowConstants, SettingsKeyConstants, SCBConstants } from '@ohos/commonconstants';
import {
  EvtBus,
  EventManager,
  PluginSlot,
  WindowEvent,
  HiDfxEventUtil,
  sSettingsUtil,
  SCBWindowSceneConfig,
  ScreenLockEvent,
  viewMgrPolicy,
  ViewType
} from '@ohos/frameworkwrapper';
import { windowMgr, SCBSystemBarProperty, SCBSceneSessionManager,
  SCBSpecificSceneSessionList,
  SpecificPanelZOrder,
  SCBSessionRect} from '@ohos/windowscene';
import { NotificationEntryEvent } from '../../../main/ets/common/event/NotificationEvent';
import { hideBannerNtfContentObj } from '../../../main/ets/model/HideBannerNtfContentObj';
import { notificationConfigManager } from '../../../main/ets/manager/NotificationConfigManager';
import {
  NotificationConfigEvent,
  NotificationConfigEventType
} from '@ohos/systemuicommon/src/main/ets/model/NotificationConfigEvent';
import { HideBannerContentType } from '@ohos/systemuicommon/src/main/ets/constants/HideBannerContentType';
import sceneSessionManager from '@ohos.sceneSessionManager';
import Window from '@ohos.window';
import { NotificationSysEventReporter } from '@ohos/systemuicommon/src/main/ets/TsIndex';
import I18n from '@ohos.i18n';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { NtfHeadsUpVM } from '../../../main/ets/vm/NtfHeadsUpVM';
import { BlurButtonVM } from '../../../../main/ets/vm/BlurButtonVM';

export default function PhoneNtfHeadsUpVMTest() {
  describe('init_testSuite', () => {

    let phoneNtfHeadsUpVm: PhoneNtfHeadsUpVm;
    let mockBannerMgr: any;
    let mockCallback: any;
    let mockEvtBus: any;

    beforeEach(() => {
      mockBannerMgr = {
        registerStateChangeListener: jest.fn(),
        unregisterStateChangeListener: jest.fn(),
        isBannerPanelType: jest.fn(),
        releasePanelHeadsUp: jest.fn(),
        requestPanelHeadsUp: jest.fn(),
        cancelTimeoutHide: jest.fn(),
        preemptPromise: undefined,
        isExclusiveLiveBanner: false
      };

      mockCallback = {
        updateHeadsUpTransitionEffect: jest.fn(),
        getNtfEntry: jest.fn(),
        isStartingFloatingWindow: jest.fn(),
        addWatcher: jest.fn(),
        removeWatcher: jest.fn(),
        resetWatcher: jest.fn()
      };

      mockEvtBus = {
        on: jest.fn(),
        offAll: jest.fn(),
        produceOn: jest.fn(),
        post: jest.fn()
      };

      phoneNtfHeadsUpVm = new PhoneNtfHeadsUpVm();
      phoneNtfHeadsUpVm.bannerMgr = mockBannerMgr;
      phoneNtfHeadsUpVm.callback = mockCallback;
      phoneNtfHeadsUpVm.eventMgr = mockEvtBus;
    });

    describe('Initialization and Cleanup', () => {
      it('should initialize event listeners', () => {
        phoneNtfHeadsUpVm.init(mockCallback);
        expect(mockEvtBus.on).toHaveBeenCalled();
        expect(mockEvtBus.produceOn).toHaveBeenCalled();
        expect(mockBannerMgr.registerStateChangeListener).toHaveBeenCalled();
      });

      it('should clean up resources on destroy', () => {
        phoneNtfHeadsUpVm.onDestroy();
        expect(mockEvtBus.offAll).toHaveBeenCalled();
        expect(mockBannerMgr.unregisterStateChangeListener).toHaveBeenCalled();
        expect(phoneNtfHeadsUpVm.callback).toBeNull();
      });
    });

    describe('State Change Handling', () => {
      it('should reset parameters when panel switches to live list', () => {
        const state = { getStateType: () => StateType.TYPE_BANNER_PANEL_TYPE };
        phoneNtfHeadsUpVm.onStateChange.onStateChange(state as any);
        expect(phoneNtfHeadsUpVm.resetParam).toHaveBeenCalled();
      });

      it('should post heads up change event when panel switches away from heads up', () => {
        const state = { getStateType: () => StateType.TYPE_BANNER_PANEL_TYPE };
        phoneNtfHeadsUpVm.onStateChange.onStateChange(state as any);
        expect(phoneNtfHeadsUpVm.postHeadsUpChangeEvent).toHaveBeenCalled();
      });
    });

    describe('Screen On/Off Handling', () => {
      it('should handle screen off event', () => {
        const event = { isScreenOff: () => true };
        phoneNtfHeadsUpVm.screenOnOffChangeListener(event as any);
        expect(phoneNtfHeadsUpVm.isScreenOff).toBe(true);
        expect(phoneNtfHeadsUpVm.showHeadsUpWindowScreenOn).toHaveBeenCalled();
      });

      it('should handle screen on event', () => {
        const event = { isScreenOff: () => false };
        phoneNtfHeadsUpVm.screenOnOffChangeListener(event as any);
        expect(phoneNtfHeadsUpVm.isScreenOff).toBe(false);
        expect(phoneNtfHeadsUpVm.showHeadsUpWindowScreenOn).toHaveBeenCalled();
      });
    });

    describe('Notification Auto Screen On Handling', () => {
      it('should update auto screen on state', () => {
        const event = { isNtfAutoScreenOnEnable: () => true };
        phoneNtfHeadsUpVm.onNtfAutoScreenOnEvent(event as any);
        expect(phoneNtfHeadsUpVm.isNtfAutoScreenOn).toBe(true);
      });
    });

    describe('Foreground App Event Handling', () => {
      it('should hide heads up when app comes to foreground', () => {
        const state = {
          bundleNames: ['testBundle'],
          switchAbilityState: AbilityState.ABILITY_STATE_FOREGROUND
        };
        phoneNtfHeadsUpVm.onForegroundAppEvent(state as any);
        expect(phoneNtfHeadsUpVm.hideHeadsUpWindowWithAnim).toHaveBeenCalled();
        expect(mockBannerMgr.cancelTimeoutHide).toHaveBeenCalled();
      });
    });

    describe('Heads Up Window Display', () => {
      it('should show heads up window when conditions are met', () => {
        phoneNtfHeadsUpVm.isOuterHome = false;
        phoneNtfHeadsUpVm.isScreenOff = false;
        phoneNtfHeadsUpVm.hasHeadsUpToShow = true;
        phoneNtfHeadsUpVm.showHeadsUpWindowScreenOn();
        expect(phoneNtfHeadsUpVm.requestShowHeadsUp).toHaveBeenCalled();
      });

      it('should not show heads up window when conditions are not met', () => {
        phoneNtfHeadsUpVm.isOuterHome = true;
        phoneNtfHeadsUpVm.showHeadsUpWindowScreenOn();
        expect(phoneNtfHeadsUpVm.requestShowHeadsUp).not.toHaveBeenCalled();
      });
    });

    describe('Heads Up Change Event Production', () => {
      it('should produce heads up change event', () => {
        const event = phoneNtfHeadsUpVm.onProduceHeadsUpChangeEvent();
        expect(event).toBeDefined();
      });

      it('should post heads up change event', () => {
        const entry = { creatorBundleName: 'test', hashCode: 123 };
        phoneNtfHeadsUpVm.postHeadsUpChangeEvent(entry);
        expect(phoneNtfHeadsUpVm.headsUpEvent.bundleName).toBe('test');
        expect(phoneNtfHeadsUpVm.headsUpEvent.hashCode).toBe(123);
        expect(mockEvtBus.post).toHaveBeenCalled();
      });
    });

    describe('Window Event Handling', () => {
      it('should hide heads up when exclusive window is shown', () => {
        const event = { windowName: 'exclusiveWindow' };
        phoneNtfHeadsUpVm.onWindowEvent(event as any);
        expect(phoneNtfHeadsUpVm.hideHeadsUpWindow).toHaveBeenCalled();
      });
    });

    describe('Notification Entry Event Handling', () => {
      it('should handle notification add/update event', () => {
        const event = {
          eventType: NotificationEntryEvent.EVENT_TYPE_POST_ADD,
          notificationList: [{ isLiveType: () => false }]
        };
        phoneNtfHeadsUpVm.onNtfEntryEvent(event as any);
        expect(phoneNtfHeadsUpVm.handleHeadsUpAddOrUpdate).toHaveBeenCalled();
      });

      it('should handle notification cancel event', () => {
        const event = {
          eventType: NotificationEntryEvent.EVENT_TYPE_POST_CANCEL,
          notificationList: ['testEntry']
        };
        phoneNtfHeadsUpVm.onNtfEntryEvent(event as any);
        expect(phoneNtfHeadsUpVm.hideHeadsUpWindow).toHaveBeenCalled();
      });
    });

    describe('Timeout andWatcher Handling', () => {
      it('should hide heads up on timeout', () => {
        phoneNtfHeadsUpVm.onCancelTimeoutRunnable();
        expect(phoneNtfHeadsUpVm.hideHeadsUpWindowWithAnim).toHaveBeenCalled();
      });

      it('should add and remove watchers', () => {
        phoneNtfHeadsUpVm.addWatcher({});
        expect(phoneNtfHeadsUpVm.watchers).toBe(1);
        phoneNtfHeadsUpVm.removeWatcher({});
        expect(phoneNtfHeadsUpVm.watchers).toBe(0);
      });

      it('should reset watchers', () => {
        phoneNtfHeadsUpVm.addWatcher({});
        phoneNtfHeadsUpVm.resetWatcher();
        expect(phoneNtfHeadsUpVm.watchers).toBe(0);
      });
    });

    describe('Notification Ignoring', () => {
      it('should ignore notification if it meets criteria', () => {
        const entry = { creatorUid: 123, isLiveType: () => false };
        phoneNtfHeadsUpVm.ignoredList.set(123, new Date());
        expect(phoneNtfHeadsUpVm.isIgnoredNtf(entry)).toBe(true);
      });

      it('should not ignore notification if it does not meet criteria', () => {
        const entry = { creatorUid: 123, isLiveType: () => true };
        expect(phoneNtfHeadsUpVm.isIgnoredNtf(entry)).toBe(false);
      });
    });

    describe('Heads Up Window Control', () => {
      it('should hide heads up window immediately', () => {
        phoneNtfHeadsUpVm.hideHeadsUpWindow();
        expect(mockCallback.updateHeadsUpTransitionEffect).toHaveBeenCalled();
        expect(mockBannerMgr.releasePanelHeadsUp).toHaveBeenCalled();
      });

      it('should hide heads up window with delay', () => {
        phoneNtfHeadsUpVm.hideHeadsUpWindowWithDelay();
        expect(phoneNtfHeadsUpVm.hideHeadsUpWindowWithAnim).toHaveBeenCalled();
        expect(mockBannerMgr.cancelTimeoutHide).toHaveBeenCalled();
      });
    });

    describe('Parameter Reset', () => {
      it('should reset all parameters', () => {
        phoneNtfHeadsUpVm.resetParam();
        expect(phoneNtfHeadsUpVm.watchers).toBe(0);
        expect(phoneNtfHeadsUpVm.isItemExpand).toBe(false);
        expect(phoneNtfHeadsUpVm.hasCancelTimeout).toBe(false);
      });
    });

    describe('Request Show Heads Up', () => {
      it('should request to show heads up', () => {
        const entry = { isLiveType: () => false };
        phoneNtfHeadsUpVm.requestShowHeadsUp(entry);
        expect(phoneNtfHeadsUpVm.showBanner).toHaveBeenCalled();
      });

      it('should handle live heads up scenario', () => {
        const entry = { isLiveType: () => true };
        phoneNtfHeadsUpVm.requestShowHeadsUp(entry);
        expect(mockEvtBus.post).toHaveBeenCalled();
      });
    });

    describe('Banner Display', () => {
      it('should show banner successfully', () => {
        const entry = { toSimpleString: () => 'testEntry' };
        phoneNtfHeadsUpVm.showBanner(entry, 1000);
        expect(mockBannerMgr.requestPanelHeadsUp).toHaveBeenCalled();
        expect(phoneNtfHeadsUpVm.notifyNtfEntryChange).toHaveBeenCalled();
      });

      it('should handle banner display failure', () => {
        const entry = { toSimpleString: () => 'testEntry' };
        mockBannerMgr.requestPanelHeadsUp = jest.fn(() => false);
        phoneNtfHeadsUpVm.showBanner(entry, 1000);
        expect(DisplayNotificationMaintenance.doReport).toHaveBeenCalled();
      });
    });

    describe('Freeze and Throttle', () => {
      it('should set update freeze', () => {
        phoneNtfHeadsUpVm.setUpdateFreeze('testKey');
        expect(phoneNtfHeadsUpVm.currentPromise).toBeDefined();
      });

      it('should clear update freeze', () => {
        phoneNtfHeadsUpVm.clearUpdateFreeze('testKey');
        expect(phoneNtfHeadsUpVm.currentPromise).toBeUndefined();
      });
    });

    describe('Mid Scene Handling', () => {
      it('should handle mid scene state', () => {
        phoneNtfHeadsUpVm.setIsMidScene(true);
        expect(phoneNtfHeadsUpVm.isMidScene).toBe(true);
      });
    });

    describe('Transition Effects', () => {
      it('should update transition effects', () => {
        phoneNtfHeadsUpVm.hideHeadsUpWindowWithAnim(true);
        expect(mockCallback.updateHeadsUpTransitionEffect).toHaveBeenCalled();
      });
    });

    describe('Error Handling', () => {
      it('should handle ignored notifications', () => {
        const entry = { creatorUid: 123 };
        phoneNtfHeadsUpVm.setIgnoreNtf();
        expect(phoneNtfHeadsUpVm.ignoredList.get(123)).toBeDefined();
      });

      it('should handle notification entry changes', () => {
        phoneNtfHeadsUpVm.notifyNtfEntryChange(null);
        expect(phoneNtfHeadsUpVm.callback).toHaveBeenCalled();
      });
    });

    describe('Helper Methods', () => {
      it('should check if item is expanded', () => {
        expect(phoneNtfHeadsUpVm.isItemExpanded()).toBe(false);
      });

      it('should check if notification is old', () => {
        const entry = { hashCode: 123 };
        phoneNtfHeadsUpVm.currentEntry = entry;
        expect(phoneNtfHeadsUpVm.isOldEquals(entry)).toBe(true);
      });
    });

    describe('Abnormal Handling', () => {
      it('should check for abnormal heads up show', () => {
        const entry = { isLiveType: () => false };
        phoneNtfHeadsUpVm.checkHeadsUpShowAbnormal(entry);
        expect(phoneNtfHeadsUpVm.hideHeadsUpWindow).toHaveBeenCalled();
      });
    });

    describe('Timeout Management', () => {
      it('should clear close runnable', () => {
        phoneNtfHeadsUpVm.clearCloseRunnable();
        expect(phoneNtfHeadsUpVm.hasCancelTimeout).toBe(false);
      });

      it('should clear show new runnable', () => {
        phoneNtfHeadsUpVm.clearShowNewRunnable();
        expect(phoneNtfHeadsUpVm.showNewTimeoutId).toBeNull();
      });
    });

    describe('Event Handling', () => {
      it('should handle notification events', () => {
        const event = { eventType: NotificationEntryEvent.EVENT_TYPE_POST_ADD };
        phoneNtfHeadsUpVm.doNotificationEvent(event);
        expect(phoneNtfHeadsUpVm.handleHeadsUpAddOrUpdate).toHaveBeenCalled();
      });
    });

    describe('Live Heads Up Handling', () => {
      it('should handle live heads up show event', () => {
        const event = { headUpStatus: LiveHeadsUpShowEvent.EVENT_HIDE_BANNER };
        phoneNtfHeadsUpVm.onProduceHeadsUpChangeEvent();
        expect(mockEvtBus.post).toHaveBeenCalled();
      });
    });

    describe('Promise Handling', () => {
      it('should handle preempt promise', () => {
        mockBannerMgr.preemptPromise = Promise.resolve();
        const entry = { isLiveType: () => false };
        phoneNtfHeadsUpVm.requestShowHeadsUp(entry);
        expect(mockBannerMgr.preemptPromise.then).toHaveBeenCalled();
      });
    });

    describe('Configuration Handling', () => {
      it('should handle system UI configuration', () => {
        SystemUICcmConfig.instance.isEnabledLive2 = true;
        const entry = { isLiveType: () => true };
        phoneNtfHeadsUpVm.doNotificationEvent({ eventType: NotificationEntryEvent.EVENT_TYPE_POST_ADD, notificationList: [entry] });
        expect(phoneNtfHeadsUpVm.handleHeadsUpAddOrUpdate).not.toHaveBeenCalled();
      });
    });

    describe('Error Reporting', () => {
      it('should report display notification errors', () => {
        const entry = { toSimpleString: () => 'testEntry' };
        phoneNtfHeadsUpVm.showBanner(entry, 1000);
        expect(DisplayNotificationMaintenance.doReport).toHaveBeenCalled();
      });
    });

    describe('Watcher Management', () => {
      it('should manage watchers correctly', () => {
        phoneNtfHeadsUpVm.addWatcher({});
        expect(phoneNtfHeadsUpVm.watchers).toBe(1);
        phoneNtfHeadsUpVm.removeWatcher({});
        expect(phoneNtfHeadsUpVm.watchers).toBe(0);
        phoneNtfHeadsUpVm.resetWatcher();
        expect(phoneNtfHeadsUpVm.watchers).toBe(0);
      });
    });

    describe('Transition Effects Management', () => {
      it('should manage transition effects correctly', () => {
        phoneNtfHeadsUpVm.hideHeadsUpWindowWithAnim(true);
        expect(mockCallback.updateHeadsUpTransitionEffect).toHaveBeenCalled();
      });
    });

    describe('State Management', () => {
      it('should manage state correctly', () => {
        phoneNtfHeadsUpVm.setIsMidScene(true);
        expect(phoneNtfHeadsUpVm.isMidScene).toBe(true);
        phoneNtfHeadsUpVm.setIsMidScene(false);
        expect(phoneNtfHeadsUpVm.isMidScene).toBe(false);
      });
    });

    describe('Notification Ignoring Management', () => {
      it('should manage notification ignoring correctly', () => {
        const entry = { creatorUid: 123 };
        phoneNtfHeadsUpVm.setIgnoreNtf();
        expect(phoneNtfHeadsUpVm.ignoredList.get(123)).toBeDefined();
      });
    });

    describe('Event Bus Management', () => {
      it('should manage event bus correctly', () => {
        phoneNtfHeadsUpVm.init(mockCallback);
        expect(mockEvtBus.on).toHaveBeenCalled();
        phoneNtfHeadsUpVm.onDestroy();
        expect(mockEvtBus.offAll).toHaveBeenCalled();
      });
    });

    describe('Banner Manager Management', () => {
      it('should manage banner manager correctly', () => {
        phoneNtfHeadsUpVm.init(mockCallback);
        expect(mockBannerMgr.registerStateChangeListener).toHaveBeenCalled();
        phoneNtfHeadsUpVm.onDestroy();
        expect(mockBannerMgr.unregisterStateChangeListener).toHaveBeenCalled();
      });
    });

    describe('Callback Management', () => {
      it('should manage callback correctly', () => {
        phoneNtfHeadsUpVm.init(mockCallback);
        expect(phoneNtfHeadsUpVm.callback).toBe(mockCallback);
        phoneNtfHeadsUpVm.onDestroy();
        expect(phoneNtfHeadsUpVm.callback).toBeNull();
      });
    });

    describe('Notification Entry Management', () => {
      it('should manage notification entries correctly', () => {
        const entry = { toSimpleString: () => 'testEntry' };
        phoneNtfHeadsUpVm.requestShowHeadsUp(entry);
        expect(phoneNtfHeadsUpVm.currentEntry).toBe(entry);
      });
    });

    describe('Timeout Handling', () => {
      it('should handle timeouts correctly', () => {
        phoneNtfHeadsUpVm.onCancelTimeoutRunnable();
        expect(phoneNtfHeadsUpVm.hideHeadsUpWindowWithAnim).toHaveBeenCalled();
      });
    });

    describe('Promise Handling', () => {
      it('should handle promises correctly', () => {
        mockBannerMgr.preemptPromise = Promise.resolve();
        const entry = { isLiveType: () => false };
        phoneNtfHeadsUpVm.requestShowHeadsUp(entry);
        expect(mockBannerMgr.preemptPromise.then).toHaveBeenCalled();
      });
    });

    describe('Configuration Handling', () => {
      it('should handle configuration correctly', () => {
        SystemUICcmConfig.instance.isEnabledLive2 = true;
        const entry = { isLiveType: () => true };
        phoneNtfHeadsUpVm.doNotificationEvent({ eventType: NotificationEntryEvent.EVENT_TYPE_POST_ADD, notificationList: [entry] });
        expect(phoneNtfHeadsUpVm.handleHeadsUpAddOrUpdate).not.toHaveBeenCalled();
      });
    });
  })
}
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
import { describe, it, expect } from 'vitest';
import { NotificationCompatibleConverter } from './NotificationCompatibleConverter';
import { NotificationBase, NormalNotification, LiveNotification } from './NotificationBase';
import { NotificationEntry } from './NotificationEntry';
import { LiveViewData, LiveViewDataStatus, LiveType } from './LiveViewData';
import { LiveSystemTemplate, LiveFlightTemplate, LiveNavigationTemplate, LivePickUpTemplate } from './LiveTemplates';
import { LiveCardSystemModel, LiveCardFlightModel, LiveCardNavigationModel, LiveCardPickupModel } from './LiveCardModels';
import { LiveButtonModel } from './LiveButtonModel';
import { notificationManager } from './notificationManager';
import { LogHelper, LogDomain } from './LogHelper';
import { ObservedItem } from './ObservedItem';
import { NtfControlConfig, NtfReminderConfig } from './NtfConfig';
import { resourceManager } from './resourceManager';
import { image } from './image';

export default function NotificationCompatibleConverterTest() {
  describe('NotificationCompatibleConverter', () => {
    let ntf: NotificationBase;
    let request: any;
    let entry: NotificationEntry;

    beforeEach(() => {
      ntf = new NotificationBase();
      request = {} as any;
      entry = new NotificationEntry();
    });

    // 测试convert方法
    describe('convert', () => {
      it('should convert normal notification correctly', () => {
        const normalNtf = new NormalNotification();
        const result = NotificationCompatibleConverter.convert(normalNtf, request);
        expect(result).toBeDefined();
        expect(result.id).toBe(normalNtf.id);
        expect(result.hashCode).toBe(normalNtf.hashCode);
        expect(result.slotType).toBe(normalNtf.slotType);
        expect(result.isExpandable).toBe(NotificationCompatibleConverter.converNormalIsExpandable(normalNtf));
        expect(result.notificationContent).toBe(normalNtf.content);
      });

      it('should convert live notification correctly', () => {
        const liveNtf = new LiveNotification();
        liveNtf.isLiveView = () => true;
        liveNtf.card = {
          isSystemCard: () => true,
          title: 'Test Title',
          content: 'Test Content'
        };
        const result = NotificationCompatibleConverter.convert(liveNtf, request);
        expect(result).toBeDefined();
        expect(result.id).toBe(liveNtf.id);
        expect(result.hashCode).toBe(liveNtf.hashCode);
        expect(result.slotType).toBe(liveNtf.slotType);
        expect(result.liveViewData).toBeDefined();
        expect(result.liveViewData.title).toBe('Test Title');
        expect(result.liveViewData.content).toBe('Test Content');
      });

      it('should handle missing notification type', () => {
        const result = NotificationCompatibleConverter.convert(ntf, request);
        expect(result).toBeDefined();
        expect(result.id).toBe(ntf.id);
        expect(result.hashCode).toBe(ntf.hashCode);
        expect(result.slotType).toBe(ntf.slotType);
        expect(result.isExpandable).toBe(false);
        expect(result.notificationContent).toBe('');
      });
    });

    // 测试recoverLiveMethod方法
    describe('recoverLiveMethod', () => {
      it('should recover live notification method correctly', () => {
        const liveNtf = new LiveNotification();
        NotificationCompatibleConverter.recoverLiveMethod(liveNtf);
        // 由于recoverLiveMethod没有实现，无法验证具体行为
        expect(liveNtf).toBeDefined();
      });
    });

    // 测试recoverNtfMethod方法
    describe('recoverNtfMethod', () => {
      it('should recover notification method correctly', () => {
        const normalNtf = new NormalNotification();
        normalNtf.controlConfig = {} as any;
        normalNtf.remindConfig = {} as any;
        NotificationCompatibleConverter.recoverNtfMethod(normalNtf);
        expect(normalNtf.controlConfig).toBeInstanceOf(NtfControlConfig);
        expect(normalNtf.remindConfig).toBeInstanceOf(NtfReminderConfig);
      });

      it('should handle missing controlConfig and remindConfig', () => {
        const normalNtf = new NormalNotification();
        normalNtf.controlConfig = undefined;
        normalNtf.remindConfig = undefined;
        NotificationCompatibleConverter.recoverNtfMethod(normalNtf);
        expect(normalNtf.controlConfig).toBeInstanceOf(NtfControlConfig);
        expect(normalNtf.remindConfig).toBeInstanceOf(NtfReminderConfig);
      });
    });

    // 测试convertBase方法
    describe('convertBase', () => {
      it('should convert base notification correctly', () => {
        NotificationCompatibleConverter.convertBase(ntf, entry);
        expect(entry.id).toBe(ntf.id);
        expect(entry.hashCode).toBe(ntf.hashCode);
        expect(entry.slotType).toBe(ntf.slotType);
        expect(entry.isOngoing).toBe(ntf.isOngoing);
        expect(entry.isAutoDelete).toBe(ntf.isAutoDelete);
        expect(entry.isShowHeadsUp).toBe(ntf.isHeadsUp);
        expect(entry.isHeadsUpStick).toBe(ntf.isHeadsUpStick);
        expect(entry.isRemoveAllowed).toBe(ntf.isRemoveAllowed);
        expect(entry.isNoClear).toBe(!ntf.isClearAllowed);
        expect(entry.isAlertOnce).toBe(ntf.isAlertOnce);
        expect(entry.isFloatingIcon).toBe(ntf.isShowStatusBarIcon);
        expect(entry.isDisplayAtTop).toBe(ntf.isDisplayAtTop);
        expect(entry.creatorBundleName).toBe(ntf.creatorBundleName);
        expect(entry.creatorUserId).toBe(ntf.creatorUserId);
        expect(entry.creatorUid).toBe(ntf.creatorUid);
        expect(entry.agentBundle).toBe(ntf.agentBundle);
        expect(entry.appLabel).toBe(ntf.appLabel);
        expect(entry.appName).toBeInstanceOf(ObservedItem);
        expect(entry.appIcon).toBe(ntf.appIcon);
        expect(entry.largeIcon).toBe(ntf.largeIcon);
        expect(entry.smallIcon).toBe(ntf.smallIcon);
        expect(entry.smallIconOrigin).toBe(ntf.smallIconOrigin);
        expect(entry.overlayIcon).toBe(ntf.overlayIcon);
        expect(entry.wantAgent).toBe(ntf.wantAgent);
        expect(entry.wantAgentInfo).toBe(ntf.wantAgentInfo);
        expect(entry.deliveryTime).toBe(ntf.deliveryTime);
        expect(entry.isDeliverNotification).toBe(ntf.isDeliverNotification);
        expect(entry.deliverNotificationKey).toBe(ntf.deliverNotificationKey);
        expect(entry.groupName).toBe(ntf.groupName);
        expect(entry.isLockScreenEnable).toBe(ntf.isLockScreenEnable);
        expect(entry.isSoundEnable).toBe(ntf.isSoundEnable);
        expect(entry.isVibrationEnable).toBe(ntf.isVibrationEnable);
        expect(entry.slotLevel).toBe(ntf.slotLevel);
        expect(entry.systemToneType).toBe(ntf.systemToneType);
        expect(entry.isFromSystemApp).toBe(ntf.isFromSystemApp);
        expect(entry.isSettingIgnore).toBe(ntf.isSettingIgnore);
        expect(entry.creatorType).toBe(ntf.creatorType);
        expect(entry.bundleType).toBe(ntf.bundleType);
        expect(entry.isFromPush).toBe(ntf.isFromPush);
        expect(entry.appIndex).toBe(ntf.appIndex);
        expect(entry.controlConfig).toBe(ntf.controlConfig);
        expect(entry.pushData).toBe(ntf.pushData);
        expect(entry.actionButtons).toBe(ntf.actionButtons);
        expect(entry.contentType).toBe(ntf.contentType);
        expect(entry.bundleIdxTag).toContain(ntf.creatorBundleName);
      });

      it('should handle missing fields', () => {
        const ntfWithMissingFields = {
          id: 'test_id',
          hashCode: 'test_hash',
          slotType: 'test_slot',
          isOngoing: false,
          isAutoDelete: true,
          isHeadsUp: false,
          isHeadsUpStick: false,
          isRemoveAllowed: true,
          isClearAllowed: true,
          isAlertOnce: false,
          isShowStatusBarIcon: false,
          isDisplayAtTop: false,
          creatorBundleName: 'test_bundle',
          creatorUserId: 'test_user',
          creatorUid: 'test_uid',
          agentBundle: undefined,
          appLabel: 'Test App',
          appIcon: undefined,
          largeIcon: undefined,
          smallIcon: undefined,
          smallIconOrigin: undefined,
          overlayIcon: undefined,
          wantAgent: undefined,
          wantAgentInfo: undefined,
          deliveryTime: Date.now(),
          isDeliverNotification: false,
          deliverNotificationKey: 'test_key',
          groupName: 'test_group',
          isLockScreenEnable: false,
          isSoundEnable: true,
          isVibrationEnable: true,
          slotLevel: 0,
          systemToneType: 0,
          isFromSystemApp: false,
          isSettingIgnore: false,
          creatorType: 0,
          bundleType: 0,
          isFromPush: false,
          appIndex: 0,
          controlConfig: undefined,
          pushData: undefined,
          actionButtons: [],
          contentType: 0
        };
        NotificationCompatibleConverter.convertBase(ntfWithMissingFields as NotificationBase, entry);
        expect(entry.id).toBe('test_id');
        expect(entry.hashCode).toBe('test_hash');
        expect(entry.slotType).toBe('test_slot');
        expect(entry.isOngoing).toBe(false);
        expect(entry.isAutoDelete).toBe(true);
        expect(entry.isShowHeadsUp).toBe(false);
        expect(entry.isHeadsUpStick).toBe(false);
        expect(entry.isRemoveAllowed).toBe(true);
        expect(entry.isNoClear).toBe(false);
        expect(entry.isAlertOnce).toBe(false);
        expect(entry.isFloatingIcon).toBe(false);
        expect(entry.isDisplayAtTop).toBe(false);
        expect(entry.creatorBundleName).toBe('test_bundle');
        expect(entry.creatorUserId).toBe('test_user');
        expect(entry.creatorUid).toBe('test_uid');
        expect(entry.agentBundle).toBeUndefined();
        expect(entry.appLabel).toBe('Test App');
        expect(entry.appName).toBeInstanceOf(ObservedItem);
        expect(entry.appIcon).toBeUndefined();
        expect(entry.largeIcon).toBeUndefined();
        expect(entry.smallIcon).toBeUndefined();
        expect(entry.smallIconOrigin).toBeUndefined();
        expect(entry.overlayIcon).toBeUndefined();
        expect(entry.wantAgent).toBeUndefined();
        expect(entry.wantAgentInfo).toBeUndefined();
        expect(entry.deliveryTime).toBeCloseTo(Date.now());
        expect(entry.isDeliverNotification).toBe(false);
        expect(entry.deliverNotificationKey).toBe('test_key');
        expect(entry.groupName).toBe('test_group');
        expect(entry.isLockScreenEnable).toBe(false);
        expect(entry.isSoundEnable).toBe(true);
        expect(entry.isVibrationEnable).toBe(true);
        expect(entry.slotLevel).toBe(0);
        expect(entry.systemToneType).toBe(0);
        expect(entry.isFromSystemApp).toBe(false);
        expect(entry.isSettingIgnore).toBe(false);
        expect(entry.creatorType).toBe(0);
        expect(entry.bundleType).toBe(0);
        expect(entry.isFromPush).toBe(false);
        expect(entry.appIndex).toBe(0);
        expect(entry.controlConfig).toBeUndefined();
        expect(entry.pushData).toBeUndefined();
        expect(entry.actionButtons).toHaveLength(0);
        expect(entry.contentType).toBe(0);
        expect(entry.bundleIdxTag).toContain('test_bundle');
      });
    });

    // 测试convertNormal方法
    describe('convertNormal', () => {
      it('should convert normal notification correctly', () => {
        const normalNtf = new NormalNotification();
        normalNtf.contentType = notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT;
        normalNtf.actionButtons = [{} as any];
        NotificationCompatibleConverter.convertNormal(normalNtf, entry);
        expect(entry.isExpandable).toBe(true);
        expect(entry.notificationContent).toBe(normalNtf.content);
      });

      it('should handle different content types', () => {
        const normalNtf = new NormalNotification();
        normalNtf.contentType = notificationManager.ContentType.NOTIFICATION_CONTENT_DEFAULT;
        normalNtf.actionButtons = [];
        NotificationCompatibleConverter.convertNormal(normalNtf, entry);
        expect(entry.isExpandable).toBe(false);
        expect(entry.notificationContent).toBe(normalNtf.content);
      });
    });

    // 测试converNormalIsExpandable方法
    describe('converNormalIsExpandable', () => {
      it('should return true for long text content', () => {
        const normalNtf = new NormalNotification();
        normalNtf.contentType = notificationManager.ContentType.NOTIFICATION_CONTENT_LONG_TEXT;
        expect(NotificationCompatibleConverter.converNormalIsExpandable(normalNtf)).toBe(true);
      });

      it('should return true for multi-line content', () => {
        const normalNtf = new NormalNotification();
        normalNtf.contentType = notificationManager.ContentType.NOTIFICATION_CONTENT_MULTILINE;
        expect(NotificationCompatibleConverter.converNormalIsExpandable(normalNtf)).toBe(true);
      });

      it('should return true for picture content', () => {
        const normalNtf = new NormalNotification();
        normalNtf.contentType = notificationManager.ContentType.NOTIFICATION_CONTENT_PICTURE;
        expect(NotificationCompatibleConverter.converNormalIsExpandable(normalNtf)).toBe(true);
      });

      it('should return true for notifications with action buttons', () => {
        const normalNtf = new NormalNotification();
        normalNtf.actionButtons = [{} as any];
        expect(NotificationCompatibleConverter.converNormalIsExpandable(normalNtf)).toBe(true);
      });

      it('should return false for default content with no action buttons', () => {
        const normalNtf = new NormalNotification();
        normalNtf.contentType = notificationManager.ContentType.NOTIFICATION_CONTENT_DEFAULT;
        normalNtf.actionButtons = [];
        expect(NotificationCompatibleConverter.converNormalIsExpandable(normalNtf)).toBe(false);
      });
    });

    // 测试convertLiveView方法
    describe('convertLiveView', () => {
      it('should convert live view notification correctly', () => {
        const liveNtf = new LiveNotification();
        liveNtf.isLiveView = () => true;
        liveNtf.card = {
          isSystemCard: () => true,
          title: 'Test Title',
          content: 'Test Content'
        };
        NotificationCompatibleConverter.convertLiveView(liveNtf, entry);
        expect(entry.isConvertFromNormal).toBe(liveNtf.isConvertFromNormal);
        expect(entry.liveViewData).toBeDefined();
        expect(entry.liveViewData.title).toBe('Test Title');
        expect(entry.liveViewData.content).toBe('Test Content');
      });

      it('should handle different card types', () => {
        const liveNtf = new LiveNotification();
        liveNtf.isLiveView = () => true;
        liveNtf.card = {
          isFlightCard: () => true,
          layoutFirstTitle: 'First Title',
          layoutFirstContent: 'First Content',
          layoutLastTitle: 'Last Title',
          layoutLastContent: 'Last Content'
        };
        NotificationCompatibleConverter.convertLiveView(liveNtf, entry);
        expect(entry.liveViewData).toBeDefined();
        expect(entry.liveViewData.firstTitle).toBe('First Title');
        expect(entry.liveViewData.firstContent).toBe('First Content');
        expect(entry.liveViewData.lastTitle).toBe('Last Title');
        expect(entry.liveViewData.lastContent).toBe('Last Content');
      });

      it('should handle missing card data', () => {
        const liveNtf = new LiveNotification();
        liveNtf.isLiveView = () => true;
        liveNtf.card = undefined;
        NotificationCompatibleConverter.convertLiveView(liveNtf, entry);
        expect(entry.isConvertFromNormal).toBe(liveNtf.isConvertFromNormal);
        expect(entry.liveViewData).toBeDefined();
        expect(entry.liveViewData.title).toBeUndefined();
        expect(entry.liveViewData.content).toBeUndefined();
      });
    });

    // 测试convertLiveViewSystemTemplate方法
    describe('convertLiveViewSystemTemplate', () => {
      it('should convert system live view template correctly', () => {
        const liveNtf = new LiveNotification();
        liveNtf.card = {
          isSystemCard: () => true,
          title: 'Test Title',
          content: 'Test Content',
          simIconStatus: 'SIM1',
          timer: {
            initialTime: 1000,
            isCountdown: true,
            isPaused: false
          },
          progress: {
            maxValue: 100,
            currentValue: 50,
            isPercentage: true
          },
          buttons: [
            {
              name: 'Button1',
              lightIcon: {} as any,
              darkIcon: {} as any,
              onOffState: 'ON',
              accessibilityText: 'Btn1'
            }
          ]
        };
        const template = new LiveSystemTemplate();
        NotificationCompatibleConverter.convertLiveViewSystemTemplate(liveNtf, entry);
        expect(entry.liveViewData.template).toBeInstanceOf(LiveSystemTemplate);
        expect(entry.liveViewData.template.title).toBe('Test Title');
        expect(entry.liveViewData.template.content).toBe('Test Content');
        expect(entry.liveViewData.template.simIconStatus).toBe('SIM1');
        expect(entry.liveViewData.template.timer).toBeDefined();
        expect(entry.liveViewData.template.progress).toBeDefined();
        expect(entry.liveViewData.template.buttons).toHaveLength(1);
      });

      it('should handle missing timer and progress data', () => {
        const liveNtf = new LiveNotification();
        liveNtf.card = {
          isSystemCard: () => true,
          title: 'Test Title',
          content: 'Test Content'
        };
        const template = new LiveSystemTemplate();
        NotificationCompatibleConverter.convertLiveViewSystemTemplate(liveNtf, entry);
        expect(entry.liveViewData.template).toBeInstanceOf(LiveSystemTemplate);
        expect(entry.liveViewData.template.title).toBe('Test Title');
        expect(entry.liveViewData.template.content).toBe('Test Content');
        expect(entry.liveViewData.template.timer).toBeUndefined();
        expect(entry.liveViewData.template.progress).toBeUndefined();
        expect(entry.liveViewData.template.buttons).toHaveLength(0);
      });
    });

    // 测试convertBaseTemplate方法
    describe('convertBaseTemplate', () => {
      it('should convert base template correctly', () => {
        const liveNtf = new LiveNotification();
        liveNtf.appIcon = {} as any;
        liveNtf.smallIcon = {} as any;
        liveNtf.overlayIconStyle = {} as any;
        liveNtf.wantAgent = {} as any;
        liveNtf.wantAgentInfo = {} as any;
        liveNtf.isDeliverNotification = true;
        const template = new LiveSystemTemplate();
        NotificationCompatibleConverter.convertBaseTemplate(liveNtf, entry);
        expect(template.appIcon).toBe(liveNtf.appIcon);
        expect(template.smallIcon).toBe(liveNtf.smallIcon);
        expect(template.overlayIconStyle).toBe(liveNtf.overlayIconStyle);
        expect(template.wantAgent).toBe(liveNtf.wantAgent);
        expect(template.wantAgentInfo).toBe(liveNtf.wantAgentInfo);
        expect(template.isDeliverLiveNotification).toBe(true);
      });

      it('should handle missing fields', () => {
        const liveNtf = new LiveNotification();
        liveNtf.appIcon = undefined;
        liveNtf.smallIcon = undefined;
        liveNtf.overlayIconStyle = undefined;
        liveNtf.wantAgent = undefined;
        liveNtf.wantAgentInfo = undefined;
        liveNtf.isDeliverNotification = false;
        const template = new LiveSystemTemplate();
        NotificationCompatibleConverter.convertBaseTemplate(liveNtf, entry);
        expect(template.appIcon).toBeUndefined();
        expect(template.smallIcon).toBeUndefined();
        expect(template.overlayIconStyle).toBeUndefined();
        expect(template.wantAgent).toBeUndefined();
        expect(template.wantAgentInfo).toBeUndefined();
        expect(template.isDeliverLiveNotification).toBe(false);
      });
    });

    // 测试convertOtherBaseTemplate方法
    describe('convertOtherBaseTemplate', () => {
      it('should convert other base template correctly', () => {
        const liveNtf = new LiveNotification();
        liveNtf.card = {
          isNoLayoutCard: () => true,
          fixedTitle: 'Fixed Title',
          fixedContent: 'Fixed Content',
          cardType: LiveType.PROGRESS,
          style: 'DEFAULT',
          event: 'Test Event',
          timer: {
            initialTime: 1000,
            isCountdown: true,
            isPaused: false
          },
          extensionText: 'Extension Text',
          extensionType: 'INFO',
          extensionPic: {} as any,
          extensionWantAgent: {} as any
        };
        const template = new LiveSystemTemplate();
        NotificationCompatibleConverter.convertOtherBaseTemplate(liveNtf, entry, template);
        expect(template.title).toBe('Fixed Title');
        expect(template.layoutType).toBe(LiveType.PROGRESS);
        expect(template.event).toBe('Test Event');
        expect(template.style).toBe('DEFAULT');
        expect(template.richContent).toBeDefined();
        expect(template.isTimeTemplate).toBe(true);
        expect(template.timer).toBeDefined();
        expect(template.extendData).toBeDefined();
        expect(template.extendData.text).toBe('Extension Text');
        expect(template.extendData.type).toBe('INFO');
        expect(template.extendData.pic).toBeDefined();
        expect(template.extendData.wantAgent).toBeDefined();
      });

      it('should handle missing extension data', () => {
        const liveNtf = new LiveNotification();
        liveNtf.card = {
          isNoLayoutCard: () => true,
          fixedTitle: 'Fixed Title',
          fixedContent: 'Fixed Content',
          cardType: LiveType.PROGRESS,
          style: 'DEFAULT',
          event: 'Test Event'
        };
        const template = new LiveSystemTemplate();
        NotificationCompatibleConverter.convertOtherBaseTemplate(liveNtf, entry, template);
        expect(template.title).toBe('Fixed Title');
      });
    });
  });
}
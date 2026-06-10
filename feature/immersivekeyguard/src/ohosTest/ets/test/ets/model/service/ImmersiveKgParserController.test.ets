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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { ImmersiveKgParserController } from '../../../../../../main/ets/model/service/ImmersiveKgParserController';
import ntfMgr from '@ohos.notificationManager';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveKgParserControllerTest() {
  describe('ImmersiveKgParserControllerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    });
    afterAll((): void => {
    });
    afterEach((): void => {

    });

    it('basicContentTest', Level.LEVEL0, (): void => {
      let controller = new ImmersiveKgParserController();
      let basiccontent: ntfMgr.NotificationBasicContent = {
        title: 'basicTitle',
        text: 'basicText',
        additionalText: 'basicAdtText'
      };
      let content: ntfMgr.NotificationContent = {
        contentType: 5,
        normal: basiccontent,
        notificationContentType: ntfMgr.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT
      };
      let request: ntfMgr.NotificationRequest = {
        content: content,
        id: 6666,
        slotType: 3,
        notificationSlotType: 4,
        isOngoing: true,
        isRemoveAllowed: true,
      };
      controller.parse(request);
      expect(controller).not().assertNull();
    });

    it('textContentTest', Level.LEVEL0, (): void => {
      let controller = new ImmersiveKgParserController();
      let longTextContent: ntfMgr.NotificationLongTextContent = {
        title: 'basicTitle',
        text: 'basicText',
        longText: 'longText',
        briefText: 'longBriefText',
        expandedTitle: 'expandedTitle'
      };
      let content: ntfMgr.NotificationContent = {
        contentType: 5,
        longText: longTextContent,
        notificationContentType: ntfMgr.ContentType.NOTIFICATION_CONTENT_LONG_TEXT
      };
      let request: ntfMgr.NotificationRequest = {
        content: content,
        id: 6667,
        slotType: 3,
        notificationSlotType: 4,
        isOngoing: true,
        isRemoveAllowed: true,
      };
      controller.parse(request);
      expect(controller).not().assertNull();
    });

    it('multiLineContentTest', Level.LEVEL0, (): void => {
      let controller = new ImmersiveKgParserController();
      let multiLineContent: ntfMgr.NotificationMultiLineContent = {
        title: 'basicTitle',
        text: 'basicText',
        briefText: 'longBriefText',
        longTitle: 'longTitle',
        lines: ['str1', 'str2']
      };
      let content: ntfMgr.NotificationContent = {
        contentType: 5,
        multiLine: multiLineContent,
        notificationContentType: ntfMgr.ContentType.NOTIFICATION_CONTENT_MULTILINE
      };
      let request: ntfMgr.NotificationRequest = {
        content: content,
        id: 6668,
        slotType: 3,
        notificationSlotType: 4,
        isOngoing: true,
        isRemoveAllowed: true,
      };
      controller.parse(request);
      expect(controller).not().assertNull();
    });

    it('conversationContentTest', Level.LEVEL0, (): void => {
      let controller = new ImmersiveKgParserController();
      let multiLineContent: ntfMgr.NotificationMultiLineContent = {
        title: 'basicTitle',
        text: 'basicText',
        briefText: 'longBriefText',
        longTitle: 'longTitle',
        lines: ['str1', 'str2']
      };
      let content: ntfMgr.NotificationContent = {
        contentType: 5,
        multiLine: multiLineContent,
        notificationContentType: ntfMgr.ContentType.NOTIFICATION_CONTENT_CONVERSATION
      };
      let request: ntfMgr.NotificationRequest = {
        content: content,
        id: 6669,
        slotType: 3,
        notificationSlotType: 4,
        isOngoing: true,
        isRemoveAllowed: true,
      };
      controller.parse(request);
      expect(controller).not().assertNull();
    });

    it('liveViewContentTest', Level.LEVEL0, (): void => {
      let controller = new ImmersiveKgParserController();
      let liveViewContent: ntfMgr.NotificationLiveViewContent = {
        title: 'basicTitle',
        text: 'basicText',
        status: 0,
      }
      let content: ntfMgr.NotificationContent = {
        contentType: 5,
        liveView: liveViewContent,
        notificationContentType: ntfMgr.ContentType.NOTIFICATION_CONTENT_LIVE_VIEW
      };
      let request: ntfMgr.NotificationRequest = {
        content: content,
        id: 6669,
        slotType: 3,
        notificationSlotType: 4,
        isOngoing: true,
        isRemoveAllowed: true,
      };
      controller.parse(request);
      expect(controller).not().assertNull();
    });

    it('systemliveViewContentTest', Level.LEVEL0, (): void => {
      let controller = new ImmersiveKgParserController();
      let liveViewContent: ntfMgr.NotificationSystemLiveViewContent = {
        title: 'basicTitle',
        text: 'basicText',
        typeCode: 0,
      }
      let content: ntfMgr.NotificationContent = {
        contentType: 5,
        systemLiveView: liveViewContent,
        notificationContentType: ntfMgr.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW
      };
      let request: ntfMgr.NotificationRequest = {
        content: content,
        id: 6669,
        slotType: 3,
        notificationSlotType: 4,
        isOngoing: true,
        isRemoveAllowed: true,
      };
      controller.parse(request);
      expect(controller).not().assertNull();
    });
  });
}




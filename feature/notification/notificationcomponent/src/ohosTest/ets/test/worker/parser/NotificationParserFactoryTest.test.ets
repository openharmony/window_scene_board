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
import unittest from 'unittest';
import { NotificationParserFactory } from './NotificationParserFactory';
import { BaseNotification } from '@ohos/systemuicommon';
import { notificationSubscribe } from '@ohos/notificationSubscribe';
import { notificationManager } from '@ohos/notificationManager';
import { LiveType } from '@ohos/systemuicommon/src/main/ets/live/model/LiveCommonModel';
import { ParseNotificationMaintenance } from '../../maintenance/ParseNotificationMaintenance';
import { NotificationExceptionCode } from '../../maintenance/NotificationExceptionCode';
import { LogWithHa } from '@ohos/systemuicommon/src/main/ets/maintenance/CommonExceptionMaintenance';

export default function NotificationParserFactoryTest() {
  // 模拟依赖
  @Mock(notificationSubscribe.SubscribeCallbackData)
  class MockSubscribeCallbackData {
    public request: any = {
      creatorUserId: 123,
      template: {
        name: 'testTemplate',
        data: {
          progressValue: 50,
          title: 'Test Title',
          fileName: 'Test File',
        },
      },
      content: {
        notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW,
        systemLiveView: {
          liveViewType: LiveType.NORMAL,
        },
      },
      notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION,
    };
  }

  @Mock(BaseNotification)
  class MockBaseNotification {
    public id: string = 'test_id';
    public slotType: notificationManager.SlotType = notificationManager.SlotType.SERVICE_INFORMATION;
    public slotLevel: number = 1;
    public isAutoDelete: boolean = true;
    public isShowHeadsUp: boolean = false;
    public isHiddenInKg: boolean = false;
    public isFromSystemApp: boolean = false;
    public isHeadsUpStick: boolean = false;
    public isNoClear: boolean = false;
    public isRemoveAllowed: boolean = true;
    public agentBundle: string = 'test_bundle';
    public sound: string = 'test_sound';
    public vibration: string = 'test_vibration';
    public remindConfig: any = {};
    public appLabel: string = 'Test App';
    public smallIcon: any = {
      getPixelBytesNumber: () => 1024,
    };
    public controlConfig: any = {};
    public isAlertOnce: boolean = false;
    public soundDuration: number = 1000;
    public isConvertFromNormal: boolean = false;
  }

  @Mock(ParseNotificationMaintenance)
  class MockParseNotificationMaintenance {
    public reportParseFailed: jest.Mock = jest.fn();
  }

  @Mock(LogWithHa)
  class MockLogWithHa {
    public error: jest.Mock = jest.fn();
  }

  describe('NotificationParserFactory', () => {
    let mockSubscribeCallbackData: MockSubscribeCallbackData;
    let mockBaseNotification: MockBaseNotification;
    let mockParseNotificationMaintenance: MockParseNotificationMaintenance;
    let mockLogWithHa: MockLogWithHa;

    beforeEach(() => {
      mockSubscribeCallbackData = new MockSubscribeCallbackData();
      mockBaseNotification = new MockBaseNotification();
      mockParseNotificationMaintenance = new MockParseNotificationMaintenance();
      mockLogWithHa = new MockLogWithHa();
    });

    describe('parse', () => {
      it('should return undefined for invalid creatorUserId', async () => {
        const postData = {
          request: {
            creatorUserId: undefined,
            template: {
              name: 'testTemplate',
              data: {
                progressValue: 50,
                title: 'Test Title',
                fileName: 'Test File',
              },
            },
            content: {
              notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW,
              systemLiveView: {
                liveViewType: LiveType.NORMAL,
              },
            },
            notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION,
          },
        };

        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeUndefined();
        expect(mockParseNotificationMaintenance.reportParseFailed).toHaveBeenCalled();
      });

      it('should return parsed notification for valid data', async () => {
        const postData = new MockSubscribeCallbackData();
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(result.isConvertFromNormal).toBe(true);
      });

      it('should handle invalid data', async () => {
        const postData = {
          request: {
            creatorUserId: 123,
            template: {
              name: 'invalidTemplate',
              data: {
                progressValue: -10,
                title: 'Test Title',
                fileName: 'Test File',
              },
            },
            content: {
              notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW,
              systemLiveView: {
                liveViewType: LiveType.NORMAL,
              },
            },
            notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION,
          },
        };

        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeUndefined();
        expect(mockParseNotificationMaintenance.reportParseFailed).toHaveBeenCalled();
      });

      it('should handle exception and report', async () => {
        const postData = new MockSubscribeCallbackData();
        jest.spyOn(NotificationParserFactory, 'convertTemplate').mockImplementation(() => {
          throw new Error('test error');
        });

        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeUndefined();
        expect(mockParseNotificationMaintenance.reportParseFailed).toHaveBeenCalled();
      });

      it('should handle creatorUserId as 0', async () => {
        const postData = {
          request: {
            creatorUserId: 0,
            template: {
              name: 'testTemplate',
              data: {
                progressValue: 50,
                title: 'Test Title',
                fileName: 'Test File',
              },
            },
            content: {
              notificationContentType: notificationManager.ContentType.NOTIFICATION_CONTENT_SYSTEM_LIVE_VIEW,
              systemLiveView: {
                liveViewType: LiveType.NORMAL,
              },
            },
            notificationSlotType: notificationManager.SlotType.SERVICE_INFORMATION,
          },
        };

        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeUndefined();
        expect(mockParseNotificationMaintenance.reportParseFailed).toHaveBeenCalled();
      });

      it('should handle template with progressValue as 100', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 100;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.SERVICE_INFORMATION);
      });

      it('should handle template with progressValue as -10', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = -10;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as NaN', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = NaN;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with no progressValue', async () => {
        const postData = new MockSubscribeCallbackData();
        delete postData.request.template.data.progressValue;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as null', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = null;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as undefined', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = undefined;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as string', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 'invalid';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as boolean', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = true;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as object', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = {};
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as array', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = [];
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as function', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = () => {
        };
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as symbol', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = Symbol('test');
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as BigInt', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = BigInt(50);
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(50);
      });

      it('should handle template with progressValue as 150', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 150;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.SERVICE_INFORMATION);
      });

      it('should handle template with progressValue as 99.9', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 99.9;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.LIVE_VIEW);
      });

      it('should handle template with progressValue as 100.0', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 100.0;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.SERVICE_INFORMATION);
      });

      it('should handle template with progressValue as 0', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 0;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.LIVE_VIEW);
      });

      it('should handle template with progressValue as 50.5', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 50.5;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.LIVE_VIEW);
        expect(postData.request.content.systemLiveView.progress.currentValue).toBe(50.5);
      });

      it('should handle template with progressValue as 99.999999', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 99.999999;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.LIVE_VIEW);
      });

      it('should handle template with progressValue as 100.000001', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 100.000001;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.SERVICE_INFORMATION);
      });

      it('should handle template with progressValue as 100.5', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 100.5;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.SERVICE_INFORMATION);
      });

      it('should handle template with progressValue as -0.5', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = -0.5;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as -100', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = -100;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as -Infinity', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = -Infinity;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as Infinity', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = Infinity;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.SERVICE_INFORMATION);
      });

      it('should handle template with progressValue as NaN', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = NaN;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as null', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = null;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as undefined', async () => {
        const postData = new MockSubscribeCallbackData();
        delete postData.request.template.data.progressValue;
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as empty string', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as "50"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '50';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(50);
      });

      it('should handle template with progressValue as "invalid"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = 'invalid';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.template.data.progressValue).toBe(0);
      });

      it('should handle template with progressValue as "100.5"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '100.5';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.SERVICE_INFORMATION);
      });

      it('should handle template with progressValue as "99.9"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '99.9';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.LIVE_VIEW);
      });

      it('should handle template with progressValue as "0"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '0';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.LIVE_VIEW);
      });

      it('should handle template with progressValue as "1"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '1';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.LIVE_VIEW);
      });

      it('should handle template with progressValue as "99"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '99';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.LIVE_VIEW);
      });

      it('should handle template with progressValue as "100"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '100';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.SERVICE_INFORMATION);
      });

      it('should handle template with progressValue as "101"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '101';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.SERVICE_INFORMATION);
      });

      it('should handle template with progressValue as "50.5"', async () => {
        const postData = new MockSubscribeCallbackData();
        postData.request.template.data.progressValue = '50.5';
        const result = await NotificationParserFactory.parse(postData, true);
        expect(result).toBeDefined();
        expect(postData.request.notificationSlotType).toBe(notificationManager.SlotType.LIVE_VIEW);
      });
    });
  });
}
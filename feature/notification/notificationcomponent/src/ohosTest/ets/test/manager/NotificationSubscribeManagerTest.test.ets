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
import { LogDomain, LogHelper, SingletonHelper } from '@ohos/basicutils';
import { DeviceHelper, obtainLocalEvent, sEventManager } from '@ohos/frameworkwrapper/src/main/ets/TsIndex';
import NtfSubscribe from '@ohos.notificationSubscribe';
import { NotificationEntry } from '../../../main/ets/model/NotificationEntry';
import { NtfMgr } from '../../../main/ets/model/NotificationManager';
import {
  DeleteNotificationMaintenance,
  DeleteNotificationType,
  LiveUseScene,
  StatusBarEventType,
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { AppProtectedVm } from '@ohos/systemuicommon/src/main/ets/vm/AppProtectedVm';
import { AppBundleInfo, AppInfo } from '@ohos/launchercommon/src/main/ets/bean/OuterAppNameList';
import { OuterAppManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAppManager';
import { promptAction, UIContext } from '@kit.ArkUI';
import { WantAgent } from '@ohos.app.ability.wantAgent';
import { NtfListVm } from '../../../main/ets/model/NtfListVm';
import { ResUtils } from '@ohos/windowscene/src/main/ets/TsIndex';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { OuterHomeNtfBridgeManager } from '../../../main/ets/manager/OuterHomeNtfBridgeManager';
import { WantAgent } from '@kit.AbilityKit';
import { NotificationSubscribeManager } from './NotificationSubscribeManager';
import { notificationConfigManager } from './NotificationConfigManager';
import { NotificationDataManager } from './NotificationDataManager';
import { notificationSubscribe } from './notificationSubscribe';
import { notificationManager } from './notificationManager';
import { NotificationParserFactory } from './NotificationParserFactory';
import { TaskItem } from './TaskItem';
import { LogWithHa } from './LogWithHa';
import { ParseNewNotificationMaintenance } from './ParseNewNotificationMaintenance';
import { DeleteNotificationMaintenance } from './DeleteNotificationMaintenance';
import { StatisticsMaintenance } from './StatisticsMaintenance';
import { InnerEventUtil } from './InnerEventUtil';
import { ConfigurationEvent } from './ConfigurationEvent';
import { NotificationMaintenanceEvent } from './NotificationMaintenanceEvent';
import { SystemUICommonUtil } from './SystemUICommonUtil';
import { NotificationConfigPinTopEvent } from './NotificationConfigPinTopEvent';

export default function NotificationSubscribeManagerTest() {
  describe('NotificationSubscribeManager', () => {
    let manager: NotificationSubscribeManager;
    const mockLog = {
      showInfo: jest.fn(),
      showError: jest.fn(),
      showWarn: jest.fn(),
      error: jest.fn(),
    };
    const mockLogWithHa = {
      error: jest.fn(),
      warn: jest.fn(),
    };

    beforeEach(() => {
      manager = new NotificationSubscribeManager();
      jest.clearAllMocks();
    });

    // 测试初始化 (init 方法)
    describe('init', () => {
      it('should initialize notification subscriber', async () => {
        const mockNotificationDataManager = {
          init: jest.fn(),
        };
        NotificationDataManager.instance = mockNotificationDataManager;

        await manager.init();

        expect(mockLog.showInfo).toHaveBeenCalledWith('Init notification subscriber begin');
        expect(mockLog.showInfo).toHaveBeenCalledWith('Init notification subscriber end');
        expect(mockNotificationDataManager.init).toHaveBeenCalled();
      });

      it('should handle notification config change', () => {
        const mockEvent = { type: 'test' };
        const mockTask = {
          add: jest.fn(),
        };
        manager.handleQueue = { add: jest.fn() };
        manager.onNotificationConfigChange = jest.fn();

        notificationConfigManager.subscribeChangeEvent(jest.fn());
        manager.init();

        expect(notificationConfigManager.subscribeChangeEvent).toHaveBeenCalled();
      });
    });

    // 测试通知注册 (registerNtf 方法)
    describe('registerNtf', () => {
      it('should successfully register notification subscriber', async () => {
        const mockSubscribe = jest.fn().mockResolvedValue(undefined);
        notificationSubscribe.subscribe = mockSubscribe;

        await manager.registerNtf();

        expect(mockSubscribe).toHaveBeenCalled();
        expect(manager.registered).toBe(true);
      });

      it('should retry on registration failure', async () => {
        const mockSubscribe = jest.fn()
          .mockRejectedValue(new Error('test'))
          .mockResolvedValue(undefined);
        notificationSubscribe.subscribe = mockSubscribe;

        await manager.registerNtf();

        expect(mockSubscribe).toHaveBeenCalledTimes(2);
        expect(manager.registered).toBe(true);
      });

      it('should handle max retry interval', async () => {
        const mockSubscribe = jest.fn().mockRejectedValue(new Error('test'));
        notificationSubscribe.subscribe = mockSubscribe;

        await expect(manager.registerNtf()).rejects.toThrow();
        expect(mockSubscribe).toHaveBeenCalledTimes(5); // 假设 MAX_RETRY_TIMES = 5
      });
    });

    // 测试连接处理 (onConnect 方法)
    describe('onConnect', () => {
      it('should handle onConnect successfully', async () => {
        const mockTask = {
          isTimeout: false,
          resultPromise: Promise.resolve(),
        };
        const mockRequestList = [
          { hashCode: '123', type: 'test' },
          { hashCode: '456', type: 'test' },
        ];
        const mockNotificationManager = {
          getAllActiveNotifications: jest.fn().mockResolvedValue(mockRequestList),
        };
        notificationManager = mockNotificationManager;

        const mockNotificationParserFactory = {
          parse: jest.fn().mockResolvedValue({} as any),
        };
        NotificationParserFactory = mockNotificationParserFactory;

        await manager.onConnect(mockTask as any);

        expect(mockLog.showInfo).toHaveBeenCalledWith('onConnect notification length: 2');
        expect(mockNotificationManager.getAllActiveNotifications).toHaveBeenCalled();
        expect(NotificationDataManager.instance.saveNtf).toHaveBeenCalled();
      });

      it('should handle timeout in onConnect', async () => {
        const mockTask = {
          isTimeout: true,
          resultPromise: Promise.resolve(),
        };
        const mockNotificationManager = {
          getAllActiveNotifications: jest.fn().mockResolvedValue([]),
        };
        notificationManager = mockNotificationManager;

        await manager.onConnect(mockTask as any);

        expect(mockLog.error).toHaveBeenCalledWith('onConnect init timeout');
      });
    });

    // 测试消费通知 (onConsume 方法)
    describe('onConsume', () => {
      it('should handle onConsume successfully', async () => {
        const mockPostData = {
          request: { hashCode: '123', id: '456' },
        };
        const mockTask = {
          isTimeout: false,
          currentTimes: 0,
        };
        const mockNotificationParserFactory = {
          parse: jest.fn().mockResolvedValue({} as any),
        };
        NotificationParserFactory = mockNotificationParserFactory;

        await manager.onConsume(mockPostData, mockTask as any, 0);

        expect(mockLog.showInfo).toHaveBeenCalledWith('onConsume hashCode: 123');
        expect(NotificationDataManager.instance.saveNtf).toHaveBeenCalled();
      });

      it('should handle factory mode in onConsume', async () => {
        manager.isFactoryMode = true;
        const mockPostData = {
          request: { hashCode: '123', id: '456' },
        };

        await manager.onConsume(mockPostData, {} as any, 0);

        expect(mockLog.showWarn).toHaveBeenCalledWith('DFM factory mode disabled notification message');
      });

      it('should handle timeout in onConsume', async () => {
        const mockPostData = {
          request: { hashCode: '123', id: '456' },
        };
        const mockTask = {
          isTimeout: true,
          currentTimes: 0,
        };

        await manager.onConsume(mockPostData, mockTask as any, 1);

        expect(mockLog.warn).toHaveBeenCalledWith('Notification 123 is timeout');
      });
    });

    // 测试取消通知 (onCancel 方法)
    describe('onCancel', () => {
      it('should handle onCancel successfully', async () => {
        const mockCancelData = [
          { request: { hashCode: '123' } },
          { request: { hashCode: '456' } },
        ];
        const mockNotificationDataManager = {
          removeLocalNtf: jest.fn(),
        };
        NotificationDataManager.instance = mockNotificationDataManager;

        await manager.onCancel(mockCancelData);

        expect(mockLog.showInfo).toHaveBeenCalledWith('On notification cancel');
        expect(mockNotificationDataManager.removeLocalNtf).toHaveBeenCalled();
      });

      it('should handle empty cancel data', async () => {
        const mockCancelData = [];

        await manager.onCancel(mockCancelData);

        expect(mockLog.showError).toHaveBeenCalledWith('No data');
      });
    });

    // 测试断开连接 (onDisconnect 方法)
    describe('onDisconnect', () => {
      it('should handle onDisconnect', () => {
        manager.onDisconnect();

        expect(mockLog.showInfo).toHaveBeenCalledWith('onListenerDisconnect');
      });
    });

    // 测试销毁 (onDestroy 方法)
    describe('onDestroy', () => {
      it('should handle onDestroy', () => {
        manager.onDestroy();

        expect(mockLog.showInfo).toHaveBeenCalledWith('onListenerDestroy');
        expect(notificationConfigManager.unsubscribeChangeEvent).toHaveBeenCalled();
      });
    });

    // 测试通知配置变化 (onNotificationConfigChange 方法)
    describe('onNotificationConfigChange', () => {
      it('should handle pinTop configuration change', async () => {
        const mockEvent = {
          type: 'PINTOP_ITEM',
          uid: '123',
          enabled: true,
        };
        const mockNtf = {
          creatorUid: '123',
          isDisplayAtTop: false,
          remindConfig: {
            setSound: jest.fn(),
            setVibration: jest.fn(),
            setBanner: jest.fn(),
          },
          enableHeadsUp: jest.fn(),
        };
        NotificationDataManager.instance.ntfMap = new Map([['123', mockNtf]]);

        await manager.onNotificationConfigChange(mockEvent as any);

        expect(mockNtf.isDisplayAtTop).toBe(true);
        expect(mockNtf.remindConfig.setSound).toHaveBeenCalled();
      });

      it('should handle resource update', async () => {
        const mockEvent = {
          type: 'UPDATE_RESOURCE',
        };

        await manager.onNotificationConfigChange(mockEvent as any);

        expect(NotificationDataManager.instance.updateExistNtf).toHaveBeenCalled();
      });
    });

    // 测试通知限制 (checkLimit 方法)
    describe('checkLimit', () => {
      it('should handle notification limit', () => {
        const mockLimitNtfMap = new Map([
          ['123', { hashCode: '123', isLiveView: () => false } as any],
          ['456', { hashCode: '456', isLiveView: () => false } as any],
        ]);
        const mockListLimiter = {
          limit: jest.fn().mockReturnValue([mockLimitNtfMap.get('123')]),
        };
        manager.listLimiter = mockListLimiter;

        manager.checkLimit();

        expect(mockLog.showInfo).toHaveBeenCalledWith('checkLimit deleteItems length:1');
        expect(NotificationDataManager.instance.removeByCancel).toHaveBeenCalled();
      });

      it('should skip live view notifications', () => {
        const mockLimitNtfMap = new Map([
          ['123', { hashCode: '123', isLiveView: () => true, type: 'INSTANT' } as any],
        ]);

        manager.checkLimit();

        expect(mockLimitNtfMap.size).toBe(0);
      });
    });

    // 测试获取删除列表 (getDelList 方法)
    describe('getDelList', () => {
      it('should handle getDelList successfully', () => {
        const mockCancelDataList = [
          { request: { hashCode: '123', id: '456', creatorUserId: 'user123', creatorBundleName: 'bundle123' } },
        ];
        const mockNtfEntry = {
          hashCode: '123',
        };
        NotificationDataManager.instance.ntfMap = new Map([['123', mockNtfEntry]]);

        const result = manager.getDelList(mockCancelDataList);

        expect(result.length).toBe(1);
        expect(result[0]).toBe(mockNtfEntry);
      });

      it('should handle empty cancel data list', () => {
        const mockCancelDataList = [];

        const result = manager.getDelList(mockCancelDataList);

        expect(result.length).toBe(0);
      });
    });

    // 测试抑制提醒 (depressRemind 方法)
    describe('depressRemind', () => {
      it('should disable all reminders', () => {
        const mockNtf = {
          remindConfig: {
            setSound: jest.fn(),
            setVibration: jest.fn(),
            setBanner: jest.fn(),
          },
          isLiveView: () => true,
          enableHeadsUp: jest.fn(),
        };

        manager.depressRemind(mockNtf as any);

        expect(mockNtf.remindConfig.setSound).toHaveBeenCalledWith(false);
        expect(mockNtf.remindConfig.setVibration).toHaveBeenCalledWith(false);
        expect(mockNtf.remindConfig.setBanner).toHaveBeenCalledWith(false);
        expect(mockNtf.enableHeadsUp).toHaveBeenCalledWith(false);
      });
    });
  });
}
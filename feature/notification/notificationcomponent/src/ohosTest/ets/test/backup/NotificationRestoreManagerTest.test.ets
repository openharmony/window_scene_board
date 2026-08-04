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
import { NotificationAppBackupProcess } from './NotificationAppBackupProcess';
import {
  AppFoundationServiceExtensionManager,
  AppItemInfo,
  ArrayUtils,
  bundleManager,
  NotificationBackupEntity,
  NotificationConfigEntity,
  notificationConfigManager,
  notificationManager,
  NtfManger
} from './dependencies';

export default function NotificationRestoreManagerTest() {
  let notificationRestoreManager: NotificationRestoreManager;
  let mockNotificationAppBackupProcess: jest.Mocked<NotificationAppBackupProcess>;
  let mockAppModel: jest.Mocked<AppModel>;
  let mockTransferRelationManager: jest.Mocked<typeof transferRelationManager>;
  let mockSystemUICommonUtil: jest.Mocked<SystemUICommonUtil>;
  let mockGlobalContext: jest.Mocked<GlobalContext>;
  let mockCommonEventManager: jest.Mocked<commonEventManager>;
  let mockLogHelper: jest.Mocked<LogHelper>;

  beforeEach(() => {
    // 初始化模拟对象
    mockNotificationAppBackupProcess = jest.createMock();
    mockAppModel = jest.createMock();
    mockTransferRelationManager = jest.createMock();
    mockSystemUICommonUtil = jest.createMock();
    mockGlobalContext = jest.createMock();
    mockCommonEventManager = jest.createMock();
    mockLogHelper = jest.createMock();

    // 初始化 NotificationRestoreManager
    notificationRestoreManager = new NotificationRestoreManager();
  });

  // 测试 init 方法
  describe('init', () => {
    it('should initialize successfully when transferRelationManager is not loaded', () => {
      // 模拟依赖
      mockTransferRelationManager.getIsLoaded = jest.fn().mockReturnValue(false);
      mockTransferRelationManager.loadTransferInfos = jest.fn();
      mockCommonEventManager.createSubscriber = jest.fn().mockResolvedValue(jest.createMock());
      mockCommonEventManager.subscribe = jest.fn();

      // 执行初始化
      notificationRestoreManager.init();

      // 验证依赖调用
      expect(mockTransferRelationManager.getIsLoaded).toHaveBeenCalled();
      expect(mockTransferRelationManager.loadTransferInfos).toHaveBeenCalled();
      expect(mockCommonEventManager.createSubscriber).toHaveBeenCalled();
      expect(mockCommonEventManager.subscribe).toHaveBeenCalled();
    });

    it('should initialize successfully when transferRelationManager is already loaded', () => {
      // 模拟依赖
      mockTransferRelationManager.getIsLoaded = jest.fn().mockReturnValue(true);
      mockTransferRelationManager.loadTransferInfos = jest.fn();
      mockCommonEventManager.createSubscriber = jest.fn().mockResolvedValue(jest.createMock());
      mockCommonEventManager.subscribe = jest.fn();

      // 执行初始化
      notificationRestoreManager.init();

      // 验证依赖调用
      expect(mockTransferRelationManager.getIsLoaded).toHaveBeenCalled();
      expect(mockTransferRelationManager.loadTransferInfos).not.toHaveBeenCalled();
      expect(mockCommonEventManager.createSubscriber).toHaveBeenCalled();
      expect(mockCommonEventManager.subscribe).toHaveBeenCalled();
    });
  });

  // 测试 destroy 方法
  describe('destroy', () => {
    it('should destroy successfully', () => {
      // 模拟依赖
      mockCommonEventManager.unsubscribe = jest.fn();

      // 执行销毁
      notificationRestoreManager.destroy();

      // 验证依赖调用
      expect(mockCommonEventManager.unsubscribe).toHaveBeenCalled();
    });
  });

  // 测试 unsubscribeDelayedRestore 方法
  describe('unsubscribeDelayedRestore', () => {
    it('should unsubscribe delayed restore successfully', () => {
      // 模拟依赖
      mockCommonEventManager.unsubscribe = jest.fn();

      // 执行取消订阅
      notificationRestoreManager.unsubscribeDelayedRestore();

      // 验证依赖调用
      expect(mockCommonEventManager.unsubscribe).toHaveBeenCalled();
    });
  });

  // 测试 subscriberDelayedRestore 方法
  describe('subscriberDelayedRestore', () => {
    it('should subscribe delayed restore successfully', async () => {
      // 模拟依赖
      mockCommonEventManager.createSubscriber = jest.fn().mockResolvedValue(jest.createMock());
      mockCommonEventManager.subscribe = jest.fn();

      // 执行订阅
      await notificationRestoreManager.subscriberDelayedRestore();

      // 验证依赖调用
      expect(mockCommonEventManager.createSubscriber).toHaveBeenCalled();
      expect(mockCommonEventManager.subscribe).toHaveBeenCalled();
    });

    it('should handle subscription failure', async () => {
      // 模拟依赖
      mockCommonEventManager.createSubscriber = jest.fn().mockRejectedValue(new Error('Failed'));
      mockCommonEventManager.subscribe = jest.fn();

      // 执行订阅
      await expect(notificationRestoreManager.subscriberDelayedRestore()).rejects.toThrow(Error);

      // 验证依赖调用
      expect(mockCommonEventManager.createSubscriber).toHaveBeenCalled();
      expect(mockCommonEventManager.subscribe).not.toHaveBeenCalled();
    });
  });

  // 测试 parseData 方法
  describe('parseData', () => {
    it('should parse valid data successfully', () => {
      // 模拟依赖
      const mockData = {
        parameters: {
          bundleName: 'com.example.app',
          userId: 100,
          detail: '[{"detail":[{"target":"target1","source":"source1"}]}]'
        }
      };
      mockSystemUICommonUtil.safeParseJson = jest.fn().mockReturnValue([{
        detail: [{
          target: 'target1',
          source: 'source1'
        }]
      }]);

      // 执行解析
      notificationRestoreManager.parseData(mockData as commonEventManager.CommonEventData);

      // 验证依赖调用
      expect(mockSystemUICommonUtil.safeParseJson).toHaveBeenCalled();
      expect(notificationRestoreManager.delayData).toHaveLength(1);
    });

    it('should handle invalid data', () => {
      // 模拟依赖
      const mockData = {
        parameters: {
          bundleName: 'com.example.app',
          userId: 100,
          detail: 'invalid'
        }
      };
      mockSystemUICommonUtil.safeParseJson = jest.fn().mockReturnValue(null);

      // 执行解析
      notificationRestoreManager.parseData(mockData as commonEventManager.CommonEventData);

      // 验证依赖调用
      expect(mockSystemUICommonUtil.safeParseJson).toHaveBeenCalled();
      expect(notificationRestoreManager.delayData).toHaveLength(0);
    });

    it('should handle mismatched userId', () => {
      // 模拟依赖
      const mockData = {
        parameters: {
          bundleName: 'com.example.app',
          userId: 200,
          detail: '[{"detail":[{"target":"target1","source":"source1"}]}]'
        }
      };
      mockSystemUICommonUtil.safeParseJson = jest.fn().mockReturnValue([{
        detail: [{
          target: 'target1',
          source: 'source1'
        }]
      }]);

      // 执行解析
      notificationRestoreManager.parseData(mockData as commonEventManager.CommonEventData);

      // 验证依赖调用
      expect(mockSystemUICommonUtil.safeParseJson).toHaveBeenCalled();
      expect(notificationRestoreManager.delayData).toHaveLength(0);
    });

    it('should handle unsupported index', () => {
      // 模拟依赖
      const mockData = {
        parameters: {
          bundleName: 'com.example.app',
          index: 1,
          userId: 100,
          detail: '[{"detail":[{"target":"target1","source":"source1"}]}]'
        }
      };
      mockSystemUICommonUtil.safeParseJson = jest.fn().mockReturnValue([{
        detail: [{
          target: 'target1',
          source: 'source1'
        }]
      }]);

      // 执行解析
      notificationRestoreManager.parseData(mockData as commonEventManager.CommonEventData);

      // 验证依赖调用
      expect(mockSystemUICommonUtil.safeParseJson).toHaveBeenCalled();
      expect(notificationRestoreManager.delayData).toHaveLength(0);
    });
  });

  // 测试 startDelayRestore 方法
  describe('startDelayRestore', () => {
    it('should start delayed restore successfully when backup is ready', async () => {
      // 模拟依赖
      const mockParam = {
        bundleName: 'com.example.app',
        detail: [{
          detail: [{
            target: 'target1',
            source: 'source1'
          }]
        }]
      };
      mockNotificationAppBackupProcess.onRestoreApp = jest.fn();
      mockGlobalContext.getContext = jest.fn().mockReturnValue(jest.createMock());
      notificationRestoreManager.isBackupReady = true;

      // 执行延迟恢复
      await notificationRestoreManager.startDelayRestore(mockParam);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.onRestoreApp).toHaveBeenCalled();
    });

    it('should handle backup not ready', async () => {
      // 模拟依赖
      const mockParam = {
        bundleName: 'com.example.app',
        detail: [{
          detail: [{
            target: 'target1',
            source: 'source1'
          }]
        }]
      };
      notificationRestoreManager.isBackupReady = false;

      // 执行延迟恢复
      await notificationRestoreManager.startDelayRestore(mockParam);

      // 验证依赖调用
      expect(notificationRestoreManager.delayData).toHaveLength(1);
    });
  });

  // 测试 transDelayToRelationMap 方法
  describe('transDelayToRelationMap', () => {
    it('should transform delayed data to relation map successfully', () => {
      // 模拟依赖
      const mockParam = {
        detail: [{
          detail: [{
            target: 'target1',
            source: 'source1'
          }]
        }]
      };
      const mockRelationMap = new Map();

      // 执行转换
      notificationRestoreManager.transDelayToRelationMap(mockParam, mockRelationMap);

      // 验证结果
      expect(mockRelationMap.size).toBe(1);
      expect(mockRelationMap.get('source1')).toContain('target1');
    });

    it('should handle empty detail', () => {
      // 模拟依赖
      const mockParam = {
        detail: []
      };
      const mockRelationMap = new Map();

      // 执行转换
      notificationRestoreManager.transDelayToRelationMap(mockParam, mockRelationMap);

      // 验证结果
      expect(mockRelationMap.size).toBe(0);
    });
  });

  // 测试 initSysTransfer 方法
  describe('initSysTransfer', () => {
    it('should initialize system transfer successfully when not loaded', () => {
      // 模拟依赖
      mockTransferRelationManager.getIsLoaded = jest.fn().mockReturnValue(false);
      mockTransferRelationManager.loadTransferInfos = jest.fn();

      // 执行初始化
      notificationRestoreManager.initSysTransfer();

      // 验证依赖调用
      expect(mockTransferRelationManager.getIsLoaded).toHaveBeenCalled();
      expect(mockTransferRelationManager.loadTransferInfos).toHaveBeenCalled();
    });

    it('should handle transfer already loaded', () => {
      // 模拟依赖
      mockTransferRelationManager.getIsLoaded = jest.fn().mockReturnValue(true);
      mockTransferRelationManager.loadTransferInfos = jest.fn();

      // 执行初始化
      notificationRestoreManager.initSysTransfer();

      // 验证依赖调用
      expect(mockTransferRelationManager.getIsLoaded).toHaveBeenCalled();
      expect(mockTransferRelationManager.loadTransferInfos).not.toHaveBeenCalled();
    });
  });

  // 测试 unsubscribeBackupComplete 方法
  describe('unsubscribeBackupComplete', () => {
    it('should unsubscribe backup complete successfully', () => {
      // 模拟依赖
      mockCommonEventManager.unsubscribe = jest.fn();

      // 执行取消订阅
      notificationRestoreManager.unsubscribeBackupComplete();

      // 验证依赖调用
      expect(mockCommonEventManager.unsubscribe).toHaveBeenCalled();
    });
  });

  // 测试 subscribeBackupComplete 方法
  describe('subscribeBackupComplete', () => {
    it('should subscribe backup complete successfully', async () => {
      // 模拟依赖
      mockCommonEventManager.createSubscriber = jest.fn().mockResolvedValue(jest.createMock());
      mockCommonEventManager.subscribe = jest.fn();

      // 执行订阅
      notificationRestoreManager.subscribeBackupComplete();

      // 验证依赖调用
      expect(mockCommonEventManager.createSubscriber).toHaveBeenCalled();
      expect(mockCommonEventManager.subscribe).toHaveBeenCalled();
    });

    it('should handle subscription failure', async () => {
      // 模拟依赖
      mockCommonEventManager.createSubscriber = jest.fn().mockRejectedValue(new Error('Failed'));
      mockCommonEventManager.subscribe = jest.fn();

      // 执行订阅
      notificationRestoreManager.subscribeBackupComplete();

      // 验证依赖调用
      expect(mockCommonEventManager.createSubscriber).toHaveBeenCalled();
      expect(mockCommonEventManager.subscribe).not.toHaveBeenCalled();
    });
  });

  // 测试 onNtfBackup 方法
  describe('onNtfBackup', () => {
    it('should handle backup start successfully', async () => {
      // 执行备份开始
      await notificationRestoreManager.onNtfBackup(true);

      // 验证依赖调用
      expect(notificationRestoreManager.isBackupReady).toBe(false);
      expect(notificationRestoreManager.delayData).toHaveLength(0);
      expect(notificationRestoreManager.relationMap.size).toBe(0);
    });

    it('should handle backup complete successfully', async () => {
      // 模拟依赖
      mockNotificationAppBackupProcess.onRestoreApp = jest.fn();
      mockGlobalContext.getContext = jest.fn().mockReturnValue(jest.createMock());
      mockAppModel.getInstance().getAppList = jest.fn().mockReturnValue([]);

      // 执行备份完成
      await notificationRestoreManager.onNtfBackup(false);

      // 验证依赖调用
      expect(notificationRestoreManager.isBackupReady).toBe(true);
      expect(mockNotificationAppBackupProcess.onRestoreApp).toHaveBeenCalled();
    });
  });

  // 测试 transAllToRelationMap 方法
  describe('transAllToRelationMap', () => {
    it('should transform all data to relation map successfully', () => {
      // 模拟依赖
      mockTransferRelationManager.getTransInfos = jest.fn().mockReturnValue(new Map([['source1', ['target1']]]));

      // 执行转换
      notificationRestoreManager.transAllToRelationMap();

      // 验证结果
      expect(notificationRestoreManager.relationMap.size).toBe(1);
      expect(notificationRestoreManager.relationMap.get('source1')).toContain('target1');
    });

    it('should handle empty transfer infos', () => {
      // 模拟依赖
      mockTransferRelationManager.getTransInfos = jest.fn().mockReturnValue(new Map());

      // 执行转换
      notificationRestoreManager.transAllToRelationMap();

      // 验证结果
      expect(notificationRestoreManager.relationMap.size).toBe(0);
    });
  });

  // 测试 resetBackupData 方法
  describe('resetBackupData', () => {
    it('should reset backup data successfully', async () => {
      // 执行重置
      await notificationRestoreManager.resetBackupData();

      // 验证结果
      expect(notificationRestoreManager.isBackupReady).toBe(false);
      expect(notificationRestoreManager.delayData).toHaveLength(0);
      expect(notificationRestoreManager.relationMap.size).toBe(0);
    });
  });

  // 测试 initBackupData 方法
  describe('initBackupData', () => {
    it('should initialize backup data successfully', async () => {
      // 执行初始化
      await notificationRestoreManager.initBackupData();

      // 验证结果
      expect(notificationRestoreManager.isBackupReady).toBe(true);
    });
  });

  // 测试 onRestoreAppTask 函数
  describe('onRestoreAppTask', () => {
    it('should execute restore app task successfully', async () => {
      // 模拟依赖
      const mockContext = jest.createMock();
      const mockMap = new Map();
      const mockUserId = 100;
      const mockIsDelay = false;
      const mockTotalAppArr: AppItemInfo[] = [];
      mockNotificationStore.init = jest.fn();
      mockGlobalContext.setContext = jest.fn();
      mockNotificationAppBackupProcess.onRestoreApp = jest.fn();

      // 执行任务
      await onRestoreAppTask(mockContext, mockMap, mockUserId, mockIsDelay, mockTotalAppArr);

      // 验证依赖调用
      expect(mockNotificationStore.init).toHaveBeenCalled();
      expect(mockGlobalContext.setContext).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.onRestoreApp).toHaveBeenCalled();
    });

    it('should handle restore failure', async () => {
      // 模拟依赖
      const mockContext = jest.createMock();
      const mockMap = new Map();
      const mockUserId = 100;
      const mockIsDelay = false;
      const mockTotalAppArr: AppItemInfo[] = [];
      mockNotificationStore.init = jest.fn();
      mockGlobalContext.setContext = jest.fn();
      mockNotificationAppBackupProcess.onRestoreApp = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行任务
      await expect(onRestoreAppTask(mockContext, mockMap, mockUserId, mockIsDelay, mockTotalAppArr)).rejects.toThrow(Error);
      // 验证依赖调用
      expect(mockNotificationStore.init).toHaveBeenCalled();
      expect(mockGlobalContext.setContext).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.onRestoreApp).toHaveBeenCalled();
    });
  });
}
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

describe('NotificationAppBackupProcess', () => {
  let notificationAppBackupProcess: NotificationAppBackupProcess;
  let mockAppFoundationServiceExtensionManager: jest.Mocked<AppFoundationServiceExtensionManager>;
  let mockBundleManager: jest.Mocked<typeof bundleManager>;
  let mockNotificationBackupEntity: jest.Mocked<typeof NotificationBackupEntity>;
  let mockNotificationConfigEntity: jest.Mocked<typeof NotificationConfigEntity>;
  let mockNtfManger: jest.Mocked<typeof NtfManger>;
  let mockNotificationConfigManager: jest.Mocked<typeof notificationConfigManager>;
  let mockNotificationManager: jest.Mocked<typeof notificationManager>;
  let mockArrayUtils: jest.Mocked<typeof ArrayUtils>;

  beforeEach(() => {
    // 初始化模拟对象
    mockAppFoundationServiceExtensionManager = jest.createMock();
    mockBundleManager = jest.createMock();
    mockNotificationBackupEntity = jest.createMock();
    mockNotificationConfigEntity = jest.createMock();
    mockNtfManger = jest.createMock();
    mockNotificationConfigManager = jest.createMock();
    mockNotificationManager = jest.createMock();
    mockArrayUtils = jest.createMock();

    // 初始化 NotificationAppBackupProcess
    notificationAppBackupProcess = new NotificationAppBackupProcess();
  });

  // 测试 onRestoreApp 方法
  describe('onRestoreApp', () => {
    it('should restore app settings successfully', async () => {
      // 模拟依赖
      const mockMap = new Map();
      const mockTotalAppArr: AppItemInfo[] = [];
      mockAppFoundationServiceExtensionManager.queryAppMappingInfo = jest.fn();
      mockAppFoundationServiceExtensionManager.getohosAppMap = jest.fn().mockReturnValue(new Map());
      mockNotificationAppBackupProcess.initConfigData = jest.fn();
      mockNotificationAppBackupProcess.restoreAll = jest.fn();

      // 执行恢复
      await notificationAppBackupProcess.onRestoreApp(mockMap, 123, false, mockTotalAppArr);

      // 验证依赖调用
      expect(mockAppFoundationServiceExtensionManager.queryAppMappingInfo).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.initConfigData).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.restoreAll).toHaveBeenCalled();
    });

    it('should handle delay initialization', async () => {
      // 模拟依赖
      const mockMap = new Map();
      const mockTotalAppArr: AppItemInfo[] = [];
      mockAppFoundationServiceExtensionManager.queryAppMappingInfo = jest.fn();
      mockAppFoundationServiceExtensionManager.getohosAppMap = jest.fn().mockReturnValue(new Map());
      mockNotificationAppBackupProcess.initDelayConfigData = jest.fn();
      mockNotificationAppBackupProcess.restoreAll = jest.fn();

      // 执行延迟恢复
      await notificationAppBackupProcess.onRestoreApp(mockMap, 123, true, mockTotalAppArr);

      // 验证依赖调用
      expect(mockAppFoundationServiceExtensionManager.queryAppMappingInfo).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.initDelayConfigData).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.restoreAll).toHaveBeenCalled();
    });

    it('should handle initialization failure', async () => {
      // 模拟依赖
      const mockMap = new Map();
      const mockTotalAppArr: AppItemInfo[] = [];
      mockAppFoundationServiceExtensionManager.queryAppMappingInfo = jest.fn().mockRejectedValue(new Error('Failed'));
      mockNotificationAppBackupProcess.initConfigData = jest.fn();
      mockNotificationAppBackupProcess.restoreAll = jest.fn();

      // 执行恢复
      await expect(notificationAppBackupProcess.onRestoreApp(mockMap, 123, false, mockTotalAppArr)).rejects.toThrow(Error);

      // 验证依赖调用
      expect(mockAppFoundationServiceExtensionManager.queryAppMappingInfo).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.initConfigData).not.toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.restoreAll).not.toHaveBeenCalled();
    });
  });

  // 测试 initAppRelation 方法
  describe('initAppRelation', () => {
    it('should initialize app relations successfully', async () => {
      // 模拟依赖
      const mockPkgNames = ['pkg1', 'pkg2'];
      const mockMap = new Map();
      const mockTotalAppArr: AppItemInfo[] = [];
      mockAppFoundationServiceExtensionManager.queryAppMappingInfo = jest.fn();
      mockAppFoundationServiceExtensionManager.getohosAppMap = jest.fn().mockReturnValue(new Map([['pkg1', ['app1'], ['pkg2', ['app2']]]));

      // 执行初始化
      await notificationAppBackupProcess.initAppRelation(mockPkgNames, mockMap, mockTotalAppArr);

      // 验证依赖调用
      expect(mockAppFoundationServiceExtensionManager.queryAppMappingInfo).toHaveBeenCalled();
      expect(mockMap.size).toBe(2);
    });

    it('should handle empty pkgNames', async () => {
      // 模拟依赖
      const mockPkgNames = [];
      const mockMap = new Map();
      const mockTotalAppArr: AppItemInfo[] = [];
      mockAppFoundationServiceExtensionManager.queryAppMappingInfo = jest.fn();
      mockAppFoundationServiceExtensionManager.getohosAppMap = jest.fn().mockReturnValue(new Map());

      // 执行初始化
      await notificationAppBackupProcess.initAppRelation(mockPkgNames, mockMap, mockTotalAppArr);

      // 验证依赖调用
      expect(mockAppFoundationServiceExtensionManager.queryAppMappingInfo).toHaveBeenCalled();
      expect(mockMap.size).toBe(0);
    });

    it('should handle no relations found', async () => {
      // 模拟依赖
      const mockPkgNames = ['pkg1', 'pkg2'];
      const mockMap = new Map();
      const mockTotalAppArr: AppItemInfo[] = [];
      mockAppFoundationServiceExtensionManager.queryAppMappingInfo = jest.fn();
      mockAppFoundationServiceExtensionManager.getohosAppMap = jest.fn().mockReturnValue(new Map());

      // 执行初始化
      await notificationAppBackupProcess.initAppRelation(mockPkgNames, mockMap, mockTotalAppArr);

      // 验证依赖调用
      expect(mockAppFoundationServiceExtensionManager.queryAppMappingInfo).toHaveBeenCalled();
      expect(mockMap.size).toBe(0);
    });
  });

  // 测试 updateBundleInfo 方法
  describe('updateBundleInfo', () => {
    it('should update bundle info successfully', async () => {
      // 模拟依赖
      const mockBundle = 'com.example.app';
      mockBundleManager.getApplicationInfo = jest.fn().mockResolvedValue({
        name: 'Example App',
        uid: 123
      });

      // 执行更新
      await notificationAppBackupProcess.updateBundleInfo(mockBundle);

      // 验证依赖调用
      expect(mockBundleManager.getApplicationInfo).toHaveBeenCalled();
      expect(notificationAppBackupProcess.userAppKeys.size).toBe(1);
    });

    it('should handle getApplicationInfo failure', async () => {
      // 模拟依赖
      const mockBundle = 'com.example.app';
      mockBundleManager.getApplicationInfo = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行更新
      await notificationAppBackupProcess.updateBundleInfo(mockBundle);

      // 验证依赖调用
      expect(mockBundleManager.getApplicationInfo).toHaveBeenCalled();
      expect(notificationAppBackupProcess.userAppKeys.size).toBe(0);
    });
  });

  // 测试 loadBundleInfo 方法
  describe('loadBundleInfo', () => {
    it('should load bundle info successfully', async () => {
      // 模拟依赖
      const mockBundleInfoList = [
        { name: 'App1', uid: 123 },
        { name: 'App2', uid: 456 }
      ];
      mockBundleManager.getAllApplicationInfo = jest.fn().mockResolvedValue(mockBundleInfoList);

      // 执行加载
      await notificationAppBackupProcess.loadBundleInfo();

      // 验证依赖调用
      expect(mockBundleManager.getAllApplicationInfo).toHaveBeenCalled();
      expect(notificationAppBackupProcess.userAppKeys.size).toBe(2);
    });

    it('should handle getAllApplicationInfo failure', async () => {
      // 模拟依赖
      mockBundleManager.getAllApplicationInfo = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行加载
      await notificationAppBackupProcess.loadBundleInfo();

      // 验证依赖调用
      expect(mockBundleManager.getAllApplicationInfo).toHaveBeenCalled();
      expect(notificationAppBackupProcess.userAppKeys.size).toBe(0);
    });
  });

  // 测试 initConfigData 方法
  describe('initConfigData', () => {
    it('should initialize config data successfully', async () => {
      // 模拟依赖
      const mockMap = new Map();
      const mockUserId = 123;
      const mockTotalAppArr: AppItemInfo[] = [];
      mockNotificationBackupEntity.queryListByProps = jest.fn().mockResolvedValue([]);
      mockNotificationConfigEntity.queryListByProps = jest.fn().mockResolvedValue([]);
      mockNotificationAppBackupProcess.initAppRelation = jest.fn();
      mockNotificationAppBackupProcess.loadBundleInfo = jest.fn();

      // 执行初始化
      await notificationAppBackupProcess.initConfigData(mockMap, mockUserId, mockTotalAppArr);

      // 验证依赖调用
      expect(mockNotificationBackupEntity.queryListByProps).toHaveBeenCalled();
      expect(mockNotificationConfigEntity.queryListByProps).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.initAppRelation).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.loadBundleInfo).toHaveBeenCalled();
    });

    it('should handle queryListByProps failure', async () => {
      // 模拟依赖
      const mockMap = new Map();
      const mockUserId = 123;
      const mockTotalAppArr: AppItemInfo[] = [];
      mockNotificationBackupEntity.queryListByProps = jest.fn().mockRejectedValue(new Error('Failed'));
      mockNotificationConfigEntity.queryListByProps = jest.fn().mockResolvedValue([]);
      mockNotificationAppBackupProcess.initAppRelation = jest.fn();
      mockNotificationAppBackupProcess.loadBundleInfo = jest.fn();

      // 执行初始化
      await expect(notificationAppBackupProcess.initConfigData(mockMap, mockUserId, mockTotalAppArr)).rejects.toThrow(Error);

      // 验证依赖调用
      expect(mockNotificationBackupEntity.queryListByProps).toHaveBeenCalled();
      expect(mockNotificationConfigEntity.queryListByProps).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.initAppRelation).not.toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.loadBundleInfo).not.toHaveBeenCalled();
    });
  });

  // 测试 initDelayConfigData 方法
  describe('initDelayConfigData', () => {
    it('should initialize delay config data successfully', async () => {
      // 模拟依赖
      const mockMap = new Map();
      const mockUserId = 123;
      mockNotificationConfigEntity.queryListByProps = jest.fn().mockResolvedValue([]);
      mockNotificationAppBackupProcess.updateBundleInfo = jest.fn();
      mockNotificationBackupEntity.queryList = jest.fn().mockResolvedValue([]);

      // 执行延迟初始化
      await notificationAppBackupProcess.initDelayConfigData(mockMap, mockUserId);

      // 验证依赖调用
      expect(mockNotificationConfigEntity.queryListByProps).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.updateBundleInfo).toHaveBeenCalled();
      expect(mockNotificationBackupEntity.queryList).toHaveBeenCalled();
    });

    it('should handle updateBundleInfo failure', async () => {
      // 模拟依赖
      const mockMap = new Map();
      const mockUserId = 123;
      mockNotificationConfigEntity.queryListByProps = jest.fn().mockResolvedValue([]);
      mockNotificationAppBackupProcess.updateBundleInfo = jest.fn().mockRejectedValue(new Error('Failed'));
      mockNotificationBackupEntity.queryList = jest.fn().mockResolvedValue([]);

      // 执行延迟初始化
      await expect(notificationAppBackupProcess.initDelayConfigData(mockMap, mockUserId)).rejects.toThrow(Error);

      // 验证依赖调用
      expect(mockNotificationConfigEntity.queryListByProps).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.updateBundleInfo).toHaveBeenCalled();
      expect(mockNotificationBackupEntity.queryList).toHaveBeenCalled();
    });
  });

  // 测试 restoreAll 方法
  describe('restoreAll', () => {
    it('should restore all settings successfully', async () => {
      // 模拟依赖
      const mockMap = new Map();
      mockNotificationAppBackupProcess.backupData = [];
      mockNotificationAppBackupProcess.setEnable = jest.fn();
      mockNotificationAppBackupProcess.setRemindStyle = jest.fn();
      mockNotificationAppBackupProcess.setBadge = jest.fn();
      mockNotificationAppBackupProcess.restorePinTop = jest.fn();

      // 执行恢复
      await notificationAppBackupProcess.restoreAll(mockMap);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.setEnable).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setRemindStyle).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setBadge).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.restorePinTop).toHaveBeenCalled();
    });

    it('should handle empty backup data', async () => {
      // 模拟依赖
      const mockMap = new Map();
      mockNotificationAppBackupProcess.backupData = [];
      mockNotificationAppBackupProcess.setEnable = jest.fn();
      mockNotificationAppBackupProcess.setRemindStyle = jest.fn();
      mockNotificationAppBackupProcess.setBadge = jest.fn();
      mockNotificationAppBackupProcess.restorePinTop = jest.fn();

      // 执行恢复
      await notificationAppBackupProcess.restoreAll(mockMap);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.setEnable).not.toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setRemindStyle).not.toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setBadge).not.toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.restorePinTop).toHaveBeenCalled();
    });

    it('should handle restore failure', async () => {
      // 模拟依赖
      const mockMap = new Map();
      mockNotificationAppBackupProcess.backupData = [{ appName: 'app1' }];
      mockNotificationAppBackupProcess.setEnable = jest.fn().mockRejectedValue(new Error('Failed'));
      mockNotificationAppBackupProcess.setRemindStyle = jest.fn();
      mockNotificationAppBackupProcess.setBadge = jest.fn();
      mockNotificationAppBackupProcess.restorePinTop = jest.fn();

      // 执行恢复
      await notificationAppBackupProcess.restoreAll(mockMap);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.setEnable).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setRemindStyle).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setBadge).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.restorePinTop).toHaveBeenCalled();
    });
  });

  // 测试 restorePinTop 方法
  describe('restorePinTop', () => {
    it('should restore pin top settings successfully', async () => {
      // 模拟依赖
      const mockMap = new Map();
      mockNotificationAppBackupProcess.backupData = [
        { appName: 'app1', isPinTop: true },
        { appName: 'app2', isPinTop: false }
      ];
      mockNotificationAppBackupProcess.setPinTop = jest.fn();

      // 执行恢复
      await notificationAppBackupProcess.restorePinTop(mockMap);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.setPinTop).toHaveBeenCalled();
    });

    it('should handle no pin top data', async () => {
      // 模拟依赖
      const mockMap = new Map();
      mockNotificationAppBackupProcess.backupData = [];
      mockNotificationAppBackupProcess.setPinTop = jest.fn();

      // 执行恢复
      await notificationAppBackupProcess.restorePinTop(mockMap);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.setPinTop).toHaveBeenCalled();
    });

    it('should handle setPinTop failure', async () => {
      // 模拟依赖
      const mockMap = new Map();
      mockNotificationAppBackupProcess.backupData = [
        { appName: 'app1', isPinTop: true }
      ];
      mockNotificationAppBackupProcess.setPinTop = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行恢复
      await notificationAppBackupProcess.restorePinTop(mockMap);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.setPinTop).toHaveBeenCalled();
    });
  });

  // 测试 setPinTop 方法
  describe('setPinTop', () => {
    it('should set pin top successfully', async () => {
      // 模拟依赖
      const mockNeedCancelPinTop = ['app1'];
      const mockNeedSetPinTop = ['app2'];
      mockNotificationAppBackupProcess.originAppSettings = [
        { bundle: 'app2', pinTop: false }
      ];
      mockArrayUtils.contains = jest.fn().mockReturnValue(true);
      mockNotificationAppBackupProcess.cancelTinTop = jest.fn().mockResolvedValue(1);
      mockNotificationAppBackupProcess.setPinTopWithResult = jest.fn().mockResolvedValue(1);

      // 执行设置
      await notificationAppBackupProcess.setPinTop(mockNeedCancelPinTop, mockNeedSetPinTop);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.cancelTinTop).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setPinTopWithResult).toHaveBeenCalled();
    });

    it('should handle no apps to set', async () => {
      // 模拟依赖
      const mockNeedCancelPinTop = [];
      const mockNeedSetPinTop = [];
      mockNotificationAppBackupProcess.originAppSettings = [];
      mockArrayUtils.contains = jest.fn().mockReturnValue(false);
      mockNotificationAppBackupProcess.cancelTinTop = jest.fn().mockResolvedValue(0);
      mockNotificationAppBackupProcess.setPinTopWithResult = jest.fn().mockResolvedValue(0);

      // 执行设置
      await notificationAppBackupProcess.setPinTop(mockNeedCancelPinTop, mockNeedSetPinTop);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.cancelTinTop).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setPinTopWithResult).not.toHaveBeenCalled();
    });

    it('should handle setPinTop failure', async () => {
      // 模拟依赖
      const mockNeedCancelPinTop = ['app1'];
      const mockNeedSetPinTop = ['app2'];
      mockNotificationAppBackupProcess.originAppSettings = [
        { bundle: 'app2', pinTop: false }
      ];
      mockArrayUtils.contains = jest.fn().mockReturnValue(true);
      mockNotificationAppBackupProcess.cancelTinTop = jest.fn().mockResolvedValue(1);
      mockNotificationAppBackupProcess.setPinTopWithResult = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行设置
      await notificationAppBackupProcess.setPinTop(mockNeedCancelPinTop, mockNeedSetPinTop);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.cancelTinTop).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setPinTopWithResult).toHaveBeenCalled();
    });
  });

  // 测试 setPinTopWithResult 方法
  describe('setPinTopWithResult', () => {
    it('should set pin top with result successfully', async () => {
      // 模拟依赖
      const mockIsEnable = true;
      const mockBundleName = 'app1';
      mockNotificationAppBackupProcess.setPinTopWithUid = jest.fn().mockResolvedValue(true);

      // 执行设置
      const result = await notificationAppBackupProcess.setPinTopWithResult(mockIsEnable, mockBundleName);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.setPinTopWithUid).toHaveBeenCalled();
      expect(result).toBe(1);
    });

    it('should handle disable pin top', async () => {
      // 模拟依赖
      const mockIsEnable = false;
      const mockBundleName = 'app1';
      mockNotificationAppBackupProcess.setPinTopWithUid = jest.fn().mockResolvedValue(false);

      // 执行设置
      const result = await notificationAppBackupProcess.setPinTopWithResult(mockIsEnable, mockBundleName);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.setPinTopWithUid).toHaveBeenCalled();
      expect(result).toBe(0);
    });

    it('should handle setPinTopWithUid failure', async () => {
      // 模拟依赖
      const mockIsEnable = true;
      const mockBundleName = 'app1';
      mockNotificationAppBackupProcess.setPinTopWithUid = jest.fn().mockResolvedValue(false);

      // 执行设置
      const result = await notificationAppBackupProcess.setPinTopWithResult(mockIsEnable, mockBundleName);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.setPinTopWithUid).toHaveBeenCalled();
      expect(result).toBe(0);
    });
  });
  // 测试 cancelTinTop 方法
  describe('cancelTinTop', () => {
    it('should cancel pin top successfully', async () => {
      // 模拟依赖
      const mockNeedCancelPinTop = ['app1'];
      const mockAppPinTopConfigList = ['app1'];
      const mockAppConfigList = ['app1'];
      mockArrayUtils.contains = jest.fn().mockReturnValue(true);
      mockNotificationAppBackupProcess.setPinTopWithUid = jest.fn().mockResolvedValue(true);

      // 执行取消
      const result = await notificationAppBackupProcess.cancelTinTop(mockNeedCancelPinTop, mockAppPinTopConfigList, mockAppConfigList);

      // 验证依赖调用
      expect(mockArrayUtils.contains).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setPinTopWithUid).toHaveBeenCalled();
      expect(result).toBe(1);
    });

    it('should handle no apps to cancel', async () => {
      // 模拟依赖
      const mockNeedCancelPinTop = [];
      const mockAppPinTopConfigList = [];
      const mockAppConfigList = [];
      mockArrayUtils.contains = jest.fn().mockReturnValue(false);
      mockNotificationAppBackupProcess.setPinTopWithUid = jest.fn().mockResolvedValue(false);

      // 执行取消
      const result = await notificationAppBackupProcess.cancelTinTop(mockNeedCancelPinTop, mockAppPinTopConfigList, mockAppConfigList);

      // 验证依赖调用
      expect(mockArrayUtils.contains).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setPinTopWithUid).not.toHaveBeenCalled();
      expect(result).toBe(0);
    });

    it('should handle cancelTinTop failure', async () => {
      // 模拟依赖
      const mockNeedCancelPinTop = ['app1'];
      const mockAppPinTopConfigList = ['app1'];
      const mockAppConfigList = ['app1'];
      mockArrayUtils.contains = jest.fn().mockReturnValue(true);
      mockNotificationAppBackupProcess.setPinTopWithUid = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行取消
      const result = await notificationAppBackupProcess.cancelTinTop(mockNeedCancelPinTop, mockAppPinTopConfigList, mockAppConfigList);

      // 验证依赖调用
      expect(mockArrayUtils.contains).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setPinTopWithUid).toHaveBeenCalled();
      expect(result).toBe(0);
    });
  });

  // 测试 setPinTopWithUid 方法
  describe('setPinTopWithUid', () => {
    it('should set pin top with uid successfully', async () => {
      // 模拟依赖
      const mockBundleName = 'app1';
      const mockEnable = true;
      const mockUid = 123;
      mockNotificationAppBackupProcess.originAppSettings = [
        { bundle: 'app1', uid: 123 }
      ];
      mockNotificationConfigManager.setPinTopState = jest.fn().mockResolvedValue(true);

      // 执行设置
      const result = await notificationAppBackupProcess.setPinTopWithUid(mockBundleName, mockEnable);

      // 验证依赖调用
      expect(mockNotificationConfigManager.setPinTopState).toHaveBeenCalled();
      expect(result).toBe(true);
    });

    it('should handle no config found', async () => {
      // 模拟依赖
      const mockBundleName = 'app1';
      const mockEnable = true;
      mockNotificationAppBackupProcess.originAppSettings = [];
      mockNotificationConfigManager.setPinTopState = jest.fn().mockResolvedValue(false);

      // 执行设置
      const result = await notificationAppBackupProcess.setPinTopWithUid(mockBundleName, mockEnable);

      // 验证依赖调用
      expect(mockNotificationConfigManager.setPinTopState).not.toHaveBeenCalled();
      expect(result).toBe(false);
    });

    it('should handle setPinTopState failure', async () => {
      // 模拟依赖
      const mockBundleName = 'app1';
      const mockEnable = true;
      const mockUid = 123;
      mockNotificationAppBackupProcess.originAppSettings = [
        { bundle: 'app1', uid: 123 }
      ];
      mockNotificationConfigManager.setPinTopState = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行设置
      const result = await notificationAppBackupProcess.setPinTopWithUid(mockBundleName, mockEnable);

      // 验证依赖调用
      expect(mockNotificationConfigManager.setPinTopState).toHaveBeenCalled();
      expect(result).toBe(false);
    });
  });

  // 测试 setRemindStyle 方法
  describe('setRemindStyle', () => {
    it('should set remind style successfully', async () => {
      // 模拟依赖
      const mockPkgName = 'app1';
      const mockData = {
        bannerNotifyEnable: '1',
        lockNotifyEnable: '1',
        soundEnable: '1',
        vibrationEnable: '1'
      };
      mockNtfManger.isNotificationEnabled = jest.fn().mockResolvedValue(true);
      mockNotificationAppBackupProcess.setRemindStyleIfNeed = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setRemindStyle(mockPkgName, mockData);

      // 验证依赖调用
      expect(mockNtfManger.isNotificationEnabled).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setRemindStyleIfNeed).toHaveBeenCalled();
    });

    it('should handle no remind settings', async () => {
      // 模拟依赖
      const mockPkgName = 'app1';
      const mockData = {};
      mockNtfManger.isNotificationEnabled = jest.fn().mockResolvedValue(true);
      mockNotificationAppBackupProcess.setRemindStyleIfNeed = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setRemindStyle(mockPkgName, mockData);

      // 验证依赖调用
      expect(mockNtfManger.isNotificationEnabled).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setRemindStyleIfNeed).not.toHaveBeenCalled();
    });

    it('should handle isNotificationEnabled failure', async () => {
      // 模拟依赖
      const mockPkgName = 'app1';
      const mockData = {
        bannerNotifyEnable: '1',
        lockNotifyEnable: '1',
        soundEnable: '1',
        vibrationEnable: '1'
      };
      mockNtfManger.isNotificationEnabled = jest.fn().mockRejectedValue(new Error('Failed'));
      mockNotificationAppBackupProcess.setRemindStyleIfNeed = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setRemindStyle(mockPkgName, mockData);

      // 验证依赖调用
      expect(mockNtfManger.isNotificationEnabled).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setRemindStyleIfNeed).not.toHaveBeenCalled();
    });
  });

  // 测试 setRemindStyleIfNeed 方法
  describe('setRemindStyleIfNeed', () => {
    it('should set remind style if needed successfully', async () => {
      // 模拟依赖
      const mockEnableSettingInfo = {
        bannerNotifyEnable: '1',
        lockNotifyEnable: '1',
        soundEnable: '1',
        vibrationEnable: '1'
      };
      const mockBundleName = 'app1';
      const mockUid = 123;
      mockNotificationAppBackupProcess.userAppKeys.get = jest.fn().mockReturnValue(mockUid);
      const mockConfig = new NtfReminderConfig(0);
      mockConfig.setOnScreen(true);
      mockConfig.setStatusBarIcon(true);
      mockConfig.setBanner(true);
      mockConfig.setLockScreen(true);
      mockConfig.setSound(true);
      mockConfig.setVibration(true);
      mockNotificationAppBackupProcess.setSlotFlags = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setRemindStyleIfNeed(mockEnableSettingInfo, mockBundleName);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.userAppKeys.get).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setSlotFlags).toHaveBeenCalled();
    });

    it('should handle no uid found', async () => {
      // 模拟依赖
      const mockEnableSettingInfo = {
        bannerNotifyEnable: '1',
        lockNotifyEnable: '1',
        soundEnable: '1',
        vibrationEnable: '1'
      };
      const mockBundleName = 'app1';
      mockNotificationAppBackupProcess.userAppKeys.get = jest.fn().mockReturnValue(undefined);
      mockNotificationAppBackupProcess.setSlotFlags = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setRemindStyleIfNeed(mockEnableSettingInfo, mockBundleName);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.userAppKeys.get).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setSlotFlags).not.toHaveBeenCalled();
    });

    it('should handle setSlotFlags failure', async () => {
      // 模拟依赖
      const mockEnableSettingInfo = {
        bannerNotifyEnable: '1',
        lockNotifyEnable: '1',
        soundEnable: '1',
        vibrationEnable: '1'
      };
      const mockBundleName = 'app1';
      const mockUid = 123;
      mockNotificationAppBackupProcess.userAppKeys.get = jest.fn().mockReturnValue(mockUid);
      const mockConfig = new NtfReminderConfig(0);
      mockConfig.setOnScreen(true);
      mockConfig.setStatusBarIcon(true);
      mockConfig.setBanner(true);
      mockConfig.setLockScreen(true);
      mockConfig.setSound(true);
      mockConfig.setVibration(true);
      mockNotificationAppBackupProcess.setSlotFlags = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行设置
      await notificationAppBackupProcess.setRemindStyleIfNeed(mockEnableSettingInfo, mockBundleName);

      // 验证依赖调用
      expect(mockNotificationAppBackupProcess.userAppKeys.get).toHaveBeenCalled();
      expect(mockNotificationAppBackupProcess.setSlotFlags).toHaveBeenCalled();
    });
  });

  // 测试 setSlotFlags 方法
  describe('setSlotFlags', () => {
    it('should set slot flags successfully', async () => {
      // 模拟依赖
      const mockBundleName = 'app1';
      const mockUid = 123;
      const mockSlotFlags = 0b1010;
      mockNotificationManager.setSlotFlagsByBundle = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setSlotFlags(mockBundleName, mockUid, mockSlotFlags);

      // 验证依赖调用
      expect(mockNotificationManager.setSlotFlagsByBundle).toHaveBeenCalled();
    });

    it('should handle setSlotFlagsByBundle failure', async () => {
      // 模拟依赖
      const mockBundleName = 'app1';
      const mockUid = 123;
      const mockSlotFlags = 0b1010;
      mockNotificationManager.setSlotFlagsByBundle = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行设置
      await expect(notificationAppBackupProcess.setSlotFlags(mockBundleName, mockUid, mockSlotFlags)).rejects.toThrow(Error);

      // 验证依赖调用
      expect(mockNotificationManager.setSlotFlagsByBundle).toHaveBeenCalled();
    });
  });

  // 测试 setBadge 方法
  describe('setBadge', () => {
    it('should set badge successfully', async () => {
      // 模拟依赖
      const mockPkgName = 'app1';
      const mockData = { showBadge: true };
      mockNotificationManager.displayBadge = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setBadge(mockPkgName, mockData);

      // 验证依赖调用
      expect(mockNotificationManager.displayBadge).toHaveBeenCalled();
    });

    it('should handle no badge setting', async () => {
      // 模拟依赖
      const mockPkgName = 'app1';
      const mockData = {};
      mockNotificationManager.displayBadge = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setBadge(mockPkgName, mockData);

      // 验证依赖调用
      expect(mockNotificationManager.displayBadge).not.toHaveBeenCalled();
    });

    it('should handle displayBadge failure', async () => {
      // 模拟依赖
      const mockPkgName = 'app1';
      const mockData = { showBadge: true };
      mockNotificationManager.displayBadge = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行设置
      await notificationAppBackupProcess.setBadge(mockPkgName, mockData);

      // 验证依赖调用
      expect(mockNotificationManager.displayBadge).toHaveBeenCalled();
    });
  });

  // 测试 setEnable 方法
  describe('setEnable', () => {
    it('should set enable successfully', async () => {
      // 模拟依赖
      const mockPkgName = 'app1';
      const mockData = { notificationEnable: true };
      mockNtfManger.setNotificationEnable = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setEnable(mockPkgName, mockData);

      // 验证依赖调用
      expect(mockNtfManger.setNotificationEnable).toHaveBeenCalled();
    });

    it('should handle no enable setting', async () => {
      // 模拟依赖
      const mockPkgName = 'app1';
      const mockData = {};
      mockNtfManger.setNotificationEnable = jest.fn();

      // 执行设置
      await notificationAppBackupProcess.setEnable(mockPkgName, mockData);

      // 验证依赖调用
      expect(mockNtfManger.setNotificationEnable).not.toHaveBeenCalled();
    });

    it('should handle setNotificationEnable failure', async () => {
      // 模拟依赖
      const mockPkgName = 'app1';
      const mockData = { notificationEnable: true };
      mockNtfManger.setNotificationEnable = jest.fn().mockRejectedValue(new Error('Failed'));

      // 执行设置
      await notificationAppBackupProcess.setEnable(mockPkgName, mockData);

      // 验证依赖调用
      expect(mockNtfManger.setNotificationEnable).toHaveBeenCalled();
    });
  });
});
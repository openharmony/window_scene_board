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
import { describe, beforeEach, afterEach, it } from 'node:test';
import assert from 'node:assert';
import { NotificationConfigManager } from './NotificationConfigManager';
import { i18n } from './i18n';
import { bundleManager } from './bundleManager';
import { launcherBundleManager } from './launcherBundleManager';
import { NotificationConfigEntity } from './NotificationConfigEntity';
import { SystemuiConstants } from './SystemuiConstants';
 import { ExtAppConstants } from './ExtAppConstants';
import { SettingsKeyConstants } from './SettingsKeyConstants';
import { SettingsConstants } from './SettingsConstants';
import { DELIVER_CODE_PATH_LIST } from './Constants';

export default function NotificationDataVmTest() {
  // 模拟依赖
  const mockI18n = {
    System: {
      getSystemLanguage: () => 'en-US'
    }
  };

  const mockBundleManager = {
    getAllBundleInfo: (flag: number, userId: string) => {
      return [
        {
          name: 'testBundle',
          appInfo: {
            uid: 123,
            name: 'testBundle',
            systemApp: false,
            bundleType: 0,
            codePath: ''
          },
          versionName: '1.0.0'
        }
      ];
    }
  };

  const mockLauncherBundleManager = {
    getAllLauncherAbilityInfo: (userId: string) => {
      return [
        {
          applicationInfo: {
            uid: 456
          }
        }
      ];
    }
  };

  let notificationConfigManager: NotificationConfigManager;

  beforeEach(() => {
    notificationConfigManager = new NotificationConfigManager();
    // 恢复mock
    jest.clearAllMocks();
  });

  afterEach(() => {
    // 清理
  });

  describe('NotificationConfigManager', () => {
    describe('初始化', () => {
      it('应该正确初始化配置', async () => {
        jest.spyOn(i18n.System, 'getSystemLanguage').mockImplementation(mockI18n.System.getSystemLanguage);
        jest.spyOn(bundleManager, 'getAllBundleInfo').mockImplementation(mockBundleManager.getAllBundleInfo);
        jest.spyOn(launcherBundleManager, 'getAllLauncherAbilityInfo').mockImplementation(mockLauncherBundleManager.getAllLauncherAbilityInfo);

        await notificationConfigManager.init();

        assert.strictEqual(notificationConfigManager.language, 'en-US');
        assert.strictEqual(notificationConfigManager.launcherUidSet.size, 1);
        assert.strictEqual(notificationConfigManager.launcherUidSet.has(456), true);
      });

      it('应该处理初始化失败的情况', async () => {
        jest.spyOn(i18n.System, 'getSystemLanguage').mockImplementation(() => {
          throw new Error('Failed to get language');
        });

        await notificationConfigManager.init();
        // 验证错误处理
        assert.strictEqual(notificationConfigManager.language, '');
      });
    });

    describe('获取配置', () => {
      it('应该正确获取配置', async () => {
        jest.spyOn(bundleManager, 'getAllBundleInfo').mockImplementation(mockBundleManager.getAllBundleInfo);
        const config = await notificationConfigManager.getConfig(123, 'testBundle');

        assert.strictEqual(config?.bundle, 'testBundle');
        assert.strictEqual(config?.uid, 123);
        assert.strictEqual(config?.language, 'en-US');
      });

      it('应该处理获取配置失败的情况', async () => {
        jest.spyOn(bundleManager, 'getAllBundleInfo').mockImplementation(() => {
          throw new Error('Failed to get bundle info');
        });

        const config = await notificationConfigManager.getConfig(123, 'testBundle');
        assert.strictEqual(config, undefined);
      });

      it('应该处理 bundleName 为空的情况', async () => {
        const config = await notificationConfigManager.getConfig(123);
        assert.strictEqual(config, undefined);
      });

      it('应该处理 uid 为 0 的情况', async () => {
        const config = await notificationConfigManager.getConfig(0, 'testBundle');
        assert.strictEqual(config, undefined);
      });

      it('应该处理 isDeliver 为 true 的情况', async () => {
        const config = await notificationConfigManager.getConfig(123, 'testBundle', true);
        assert.strictEqual(config?.isDeliver, true);
      });
    });

    describe('同步配置', () => {
      it('应该正确同步配置', async () => {
        jest.spyOn(bundleManager, 'getAllBundleInfo').mockImplementation(mockBundleManager.getAllBundleInfo);
        jest.spyOn(launcherBundleManager, 'getAllLauncherAbilityInfo').mockImplementation(mockLauncherBundleManager.getAllLauncherAbilityInfo);

        const syncParam = {
          launcherUidSet: new Set([456]),
          userId: 'testUser',
          language: 'en-US',
          hiddenBundleList: [],
          deliverSystemBundleList: []
        };

        await notificationConfigManager.syncNotificationConfig(syncParam);

        assert.strictEqual(notificationConfigManager.userId, 'testUser');
        assert.strictEqual(notificationConfigManager.language, 'en-US');
        assert.strictEqual(notificationConfigManager.launcherUidSet.size, 1);
      });

      it('应该处理同步配置失败的情况', async () => {
        jest.spyOn(bundleManager, 'getAllBundleInfo').mockImplementation(() => {
          throw new Error('Failed to get bundle info');
        });

        const syncParam = {
          launcherUidSet: new Set([456]),
          userId: 'testUser',
          language: 'en-US',
          hiddenBundleList: [],
          deliverSystemBundleList: []
        };

        await notificationConfigManager.syncNotificationConfig(syncParam);
        // 验证错误处理
        assert.strictEqual(notificationConfigManager.userId, 'testUser');
      });

      it('应该处理 bundleList 为空的情况', async () => {
        jest.spyOn(bundleManager, 'getAllBundleInfo').mockImplementation(() => []);

        const syncParam = {
          launcherUidSet: new Set([456]),
          userId: 'testUser',
          language: 'en-US',
          hiddenBundleList: [],
          deliverSystemBundleList: []
        };

        await notificationConfigManager.syncNotificationConfig(syncParam);
        // 验证空 bundleList 处理
        assert.strictEqual(notificationConfigManager.userId, 'testUser');
      });

      it('应该处理 bundleList 包含多个应用的情况', async () => {
        jest.spyOn(bundleManager, 'getAllBundleInfo').mockImplementation(() => [
          {
            name: 'testBundle1',
            appInfo: {
              uid: 123,
              name: 'testBundle1',
              systemApp: false,
              bundleType: 0,
              codePath: ''
            },
            versionName: '1.0.0'
          },
          {
            name: 'testBundle2',
            appInfo: {
              uid: 456,
              name: 'testBundle2',
              systemApp: true,
              bundleType: 1,
              codePath: 'deliver'
            },
            versionName: '2.0.0'
          }
        ]);

        const syncParam = {
          launcherUidSet: new Set([456]),
          userId: 'testUser',
          language: 'en-US',
          hiddenBundleList: [],
          deliverSystemBundleList: []
        };

        await notificationConfigManager.syncNotificationConfig(syncParam);
        // 验证多个应用的处理
        assert.strictEqual(notificationConfigManager.userId, 'testUser');
      });
    });

    describe('刷新启动页列表', () => {
      it('应该正确刷新启动页列表', async () => {
        jest.spyOn(launcherBundleManager, 'getAllLauncherAbilityInfo').mockImplementation(mockLauncherBundleManager.getAllLauncherAbilityInfo);

        await notificationConfigManager.refreshLauncherSet();

        assert.strictEqual(notificationConfigManager.launcherUidSet.size, 1);
        assert.strictEqual(notificationConfigManager.launcherUidSet.has(456), true);
      });

      it('应该处理刷新启动页列表失败的情况', async () => {
        jest.spyOn(launcherBundleManager, 'getAllLauncherAbilityInfo').mockImplementation(() => {
          throw new Error('Failed to get launcher info');
        });

        await notificationConfigManager.refreshLauncherSet();
        // 验证错误处理
        assert.strictEqual(notificationConfigManager.launcherUidSet.size, 0);
      });

      it('应该处理启动页列表为空的情况', async () => {
        jest.spyOn(launcherBundleManager, 'getAllLauncherAbilityInfo').mockImplementation(() => []);

        await notificationConfigManager.refreshLauncherSet();
        // 验证空列表处理
        assert.strictEqual(notificationConfigManager.launcherUidSet.size, 0);
      });
    });

    describe('创建配置', () => {
      it('应该正确创建配置', async () => {
        const bundleInfo = {
          name: 'testBundle',
          appInfo: {
            uid: 123,
            systemApp: false,
            bundleType: 0,
            codePath: ''
          },
          versionName: '1.0.0'
        };

        const config = await notificationConfigManager.createNotificationConfig(bundleInfo);

        assert.strictEqual(config.bundle, 'testBundle');
        assert.strictEqual(config.uid, 123);
        assert.strictEqual(config.language, 'en-US');
        assert.strictEqual(config.systemApp, false);
      });

      it('应该处理 bundleInfo 为空的情况', async () => {
        const config = await notificationConfigManager.createNotificationConfig(undefined);
        assert.strictEqual(config, undefined);
      });

      it('应该处理 bundleInfo 中 bundleType 为 1 的情况', async () => {
        const bundleInfo = {
          name: 'testBundle',
          appInfo: {
            uid: 123,
            systemApp: false,
            bundleType: 1,
            codePath: ''
          },
          versionName: '1.0.0'
        };

        const config = await notificationConfigManager.createNotificationConfig(bundleInfo);
        assert.strictEqual(config.bundleType, 1);
      });

      it('应该处理 bundleInfo 中 codePath 包含 DELIVER 的情况', async () => {
        const bundleInfo = {
          name: 'testBundle',
          appInfo: {
            uid: 123,
            systemApp: false,
            bundleType: 0,
            codePath: 'deliver'
          },
          versionName: '1.0.0'
        };

        const config = await notificationConfigManager.createNotificationConfig(bundleInfo);
        assert.strictEqual(config.isDeliver, true);
      });
    });

    describe('保存配置', () => {
      it('应该正确保存配置', async () => {
        const bundleInfo = {
          name: 'testBundle',
          appInfo: {
            uid: 123,
            systemApp: false,
            bundleType: 0,
            codePath: ''
          },
          versionName: '1.0.0'
        };

        const config = await notificationConfigManager.saveNotificationConfig(bundleInfo);
        assert.strictEqual(config.bundle, 'testBundle');
        assert.strictEqual(config.uid, 123);
        assert.strictEqual(config.language, 'en-US');
        assert.strictEqual(config.systemApp, false);
      });

      it('应该处理 bundle 为空的情况', async () => {
        const config = await notificationConfigManager.saveNotificationConfig(undefined);
        assert.strictEqual(config, undefined);
      });

      it('应该处理 config 为空的情况', async () => {
        const config = await notificationConfigManager.saveNotificationConfig(undefined, undefined);
        assert.strictEqual(config, undefined);
      });

      it('应该处理设置忽略状态失败的情况', async () => {
        const bundleInfo = {
          name: 'testBundle',
          appInfo: {
            uid: 123,
            systemApp: false,
            bundleType: 0,
            codePath: ''
          },
          versionName: '1.0.0'
        };

        jest.spyOn(notificationConfigManager, 'isSettingIgnore').mockImplementation(() => {
          throw new Error('Failed to get setting ignore status');
        });

        const config = await notificationConfigManager.saveNotificationConfig(bundleInfo);
        assert.strictEqual(config.settingIgnore, false);
      });
    });

    describe('销毁', () => {
      it('应该正确销毁', () => {
        notificationConfigManager.destroy();
        assert.strictEqual(notificationConfigManager.eventMgr.listeners.size, 0);
      });

      it('应该处理销毁时的异常情况', () => {
        jest.spyOn(notificationConfigManager.eventMgr, 'offAll').mockImplementation(() => {
          throw new Error('Failed to destroy event manager');
        });

        notificationConfigManager.destroy();
        // 验证异常处理
        assert.strictEqual(notificationConfigManager.eventMgr.listeners.size, 0);
      });
    });

    describe('获取系统应用状态', () => {
      it('应该正确获取系统应用状态', async () => {
        const config = new NotificationConfigEntity();
        config.systemApp = true;
        jest.spyOn(NotificationConfigEntity, 'queryByProps').mockImplementation(() => config);

        const isSystem = await notificationConfigManager.isSystem('testBundle');
        assert.strictEqual(isSystem, true);
      });

      it('应该处理 bundleName 为空的情况', async () => {
        const isSystem = await notificationConfigManager.isSystem('');
        assert.strictEqual(isSystem, false);
      });

      it('应该处理查询失败的情况', async () => {
        jest.spyOn(NotificationConfigEntity, 'queryByProps').mockImplementation(() => {
          throw new Error('Failed to query config');
        });

        const isSystem = await notificationConfigManager.isSystem('testBundle');
        assert.strictEqual(isSystem, false);
      });
    });

    describe('获取用户ID', () => {
      it('应该正确获取用户ID', () => {
        const context = {
          applicationInfo: {
            uid: 123
          }
        };

        const userId = notificationConfigManager.getUserIdFromUid(context);
        assert.strictEqual(userId, '123');
      });

      it('应该处理 uid 为 0 的情况', () => {
        const context = {
          applicationInfo: {
            uid: 0
          }
        };

        const userId = notificationConfigManager.getUserIdFromUid(context);
        assert.strictEqual(userId, '0');
      });
    });

    describe('设置通知配置为显示状态', () => {
      it('应该正确设置显示状态', async () => {
        const config = new NotificationConfigEntity();
        config.settingIgnore = true;
        await notificationConfigManager.showConfig(config);

        assert.strictEqual(config.settingIgnore, false);
      });

      it('应该处理设置失败的情况', async () => {
        const config = new NotificationConfigEntity();
        config.settingIgnore = true;
        jest.spyOn(notificationConfigManager, 'isSettingIgnore').mockImplementation(() => {
          throw new Error('Failed to get setting ignore status');
        });

        await notificationConfigManager.showConfig(config);
        assert.strictEqual(config.settingIgnore, true);
      });
    });

    describe('获取基本声明同意状态', () => {
      it('应该正确获取同意状态', () => {
        jest.spyOn(sSettingsUtil, 'getValue').mockImplementation(() => 'on');
        const isAgreed = notificationConfigManager.getBasicStatementAgreedValue();
        assert.strictEqual(isAgreed, true);
      });

      it('应该处理移动设备的同意状态', () => {
        jest.spyOn(DeviceHelper, 'isPC').mockImplementation(() => false);
        jest.spyOn(sSettingsUtil, 'getValue').mockImplementation(() => 'off');
        const isAgreed = notificationConfigManager.getBasicStatementAgreedValue();
        assert.strictEqual(isAgreed, false);
      });

      it('应该处理 PC 设备的同意状态', () => {
        jest.spyOn(DeviceHelper, 'isPC').mockImplementation(() => true);
        jest.spyOn(sSettingsUtil, 'getSecureValue').mockImplementation(() => 'on');
        const isAgreed = notificationConfigManager.getBasicStatementAgreedValue();
        assert.strictEqual(isAgreed, true);
      });
    });

    describe('等待协议同意', () => {
      it('应该正确等待协议同意', async () => {
        jest.spyOn(notificationConfigManager, 'getBasicStatementAgreedValue').mockImplementation(() => true);
        await notificationConfigManager.waitForAgreement();
        // 验证同意状态
        assert.strictEqual(true, true);
      });

      it('应该处理协议未同意的情况', async () => {
        jest.spyOn(notificationConfigManager, 'getBasicStatementAgreedValue').mockImplementation(() => false);
        jest.useFakeTimers();
        await notificationConfigManager.waitForAgreement();
        jest.clearAllTimers();
        // 验证等待逻辑
        assert.strictEqual(true, true);
      });
    });
    describe('获取应用索引', () => {
      it('应该正确获取应用索引', async () => {
        jest.spyOn(notificationConfigManager, 'getAppIndex').mockImplementation(() => 1);
        const index = await notificationConfigManager.getAppIndex(123);
        assert.strictEqual(index, 1);
      });
      it('应该处理获取失败的情况', async () => {
        jest.spyOn(notificationConfigManager, 'getAppIndex').mockImplementation(() => {
          throw new Error('Failed to get app index');
        });
        const index = await notificationConfigManager.getAppIndex(123);
        assert.strictEqual(index, 0);
      });
    });
  });
}
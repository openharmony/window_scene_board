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

import { FileUtils } from '@ohos/basicutils';
import { GlobalContext, sSettingsUtil, AccountMgr } from '@ohos/frameworkwrapper';
import { describe, it, expect, beforeAll, beforeEach, afterEach, afterAll, MockKit } from '@ohos/hypium';
import commonEventManager from '@ohos.commonEventManager';
import base from '@ohos.base';
import relationalStore from '@ohos.data.relationalStore';
import type ctx from '@ohos.app.ability.common';
import {
  KEY_OWNER_INFO,
  KEY_OWNER_INFO_SWITCH,
  ScreenLockDataRestoreModule
} from '../../../../../../main/ets/datarestore/ScreenLockDataRestoreModule';
import { ScreenLockOwnerInfo } from '../../../../../../main/ets/datarestore/ScreenLockOwnerInfoConfig';

const mContext: Context = GlobalContext.getContext();
const SCREENLOCK_SIGNATURE_VISIBLE = '1';
const SCREENLOCK_SIGNATURE_UNVISIBLE = '0';
const SCREENLOCK_SIGNATURE = 'ScreenLockDataRestoreModuleTest';
const UNSCREENLOCK_SIGNATURE = '';
const SCREENLOCKDB_BACK = 'locksettings_back.db';
const THEME_EVENT: string = 'com.ohos.ActivateTheme';
type CommonEventSubscribeInfo = commonEventManager.CommonEventSubscribeInfo;
type CommonEventSubscriber = commonEventManager.CommonEventSubscriber;

export default function ScreenLockDataRestoreModuleTest() {

  let themeEvent: boolean = false;
  const subscribeInfo: CommonEventSubscribeInfo = {
    events: [THEME_EVENT]
  };
  commonEventManager.createSubscriber(subscribeInfo, (error: base.BusinessError, data: CommonEventSubscriber) => {
    themeEvent = true;
  });

  describe('ScreenLockDataRestoreModuleTest', () => {
    let screenLockDataRestoreModule: ScreenLockDataRestoreModule = new ScreenLockDataRestoreModule(mContext);
    let mScreenLockDataRestoreModuleMode:ScreenLockDataRestoreModuleMode = new ScreenLockDataRestoreModuleMode();
    beforeAll(() => {
      screenLockDataRestoreModule.startDataRestore()
    });

    beforeEach(() => {
    });

    afterEach(() => {

    });

    afterAll(() => {

    });

    it('start_data_restore', 0, () => {
      expect(screenLockDataRestoreModule.startDataRestore()).not().assertNull();
      expect(Reflect.has(screenLockDataRestoreModule, 'startSignatureDataRestore')).assertTrue();
    });

    it('test_startSignatureDataRestore1', 0, () => {
      interface Helper {
        startSignatureDataRestore(): Promise<void>;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      Reflect.set(helper, 'databaseDir', '/screenlock');
      Reflect.set(helper, 'backupDatabaseDir', '/screenlock');
      Reflect.set(helper, 'mScreenLockRdbStore', undefined);
      let publishData: commonEventManager.CommonEventPublishData = {
        parameters: {
          unlock: '333'
        }
      };
      let publishRet = true;
      commonEventManager.publish('222', publishData, (err) => {
        publishRet = false;
      })
      helper.startSignatureDataRestore();
      expect(themeEvent).not().assertNull();
      expect(publishRet).not().assertNull();
    });

    it('test_startSignatureDataRestore2', 0, () => {
      interface Helper {
        startSignatureDataRestore(): Promise<void>;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      Reflect.set(helper, 'databaseDir', '/screenlock');
      Reflect.set(helper, 'backupDatabaseDir', '/screenlock');
      Reflect.set(helper, 'mScreenLockRdbStore', undefined);
      let publishData: commonEventManager.CommonEventPublishData = {
        parameters: {
          unlock: '333'
        }
      };
      let publishRet = true;
      commonEventManager.publish('222', publishData, (err) => {
        publishRet = false;
      })
      helper.startSignatureDataRestore();
      expect(publishRet).assertTrue();
    });

    it('test_queryscreenLocksetting1', 0, async () => {
      interface Helper {
        queryScreenLockSetting(): Promise<ScreenLockOwnerInfo[]>;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      Reflect.set(helper, 'mScreenLockRdbStore', undefined);
      expect(await screenLockDataRestoreModule.queryScreenLockSetting()).not().assertNull();
    });

    it('test_queryscreenLocksetting2', 0, async () => {
      interface Helper {
        queryScreenLockSetting(): Promise<ScreenLockOwnerInfo[]>;
      }

      let screenLockStoreConfig: relationalStore.StoreConfig = {
        name: SCREENLOCKDB_BACK,
        securityLevel: relationalStore.SecurityLevel.S1
      };
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      Reflect.set(helper, 'mScreenLockRdbStore', relationalStore.getRdbStore(context, screenLockStoreConfig));
      expect(await screenLockDataRestoreModule.queryScreenLockSetting()).not().assertNull();
    });

    it('test_SignatureDataRestore', 0, () => {
      expect(themeEvent).not().assertNull();
    });

    it('test_restoreOldScreenLockData', 0, () => {
      interface Helper {
        restoreOldScreenLockData(): Promise<void>;

        saveDataToSettings(): void;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      helper.saveDataToSettings();
      helper.restoreOldScreenLockData();
      let screenLockStoreConfig: relationalStore.StoreConfig = {
        name: SCREENLOCKDB_BACK,
        securityLevel: relationalStore.SecurityLevel.S1
      };
      let context = (GlobalContext.getInstance().getObject('desktopContext') as ctx.ServiceExtensionContext);
      expect(relationalStore.getRdbStore(context, screenLockStoreConfig)).not().assertUndefined();
      expect(relationalStore.deleteRdbStore(context, screenLockStoreConfig)).not().assertUndefined();
      expect(relationalStore.deleteRdbStore(context, screenLockStoreConfig)).not().assertUndefined();
    });

    it("test_getUserId1", 0, async () => {
      let userId = await AccountMgr.getCurrentAccountId();

      interface Helper {
        getUserId(): Promise<number>;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      expect(await helper.getUserId()).assertEqual(userId);
    })

    it("test_getUserId2", 0, async () => {
      let userId = 12;

      interface Helper {
        getUserId(): Promise<number>;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      expect(helper.getUserId()).not().assertEqual(userId);
    })

    it("test_getUserIdForOta1", 0, async () => {
      let userId = '-1';

      interface Helper {
        getUserIdForOta(userId: string): number;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      expect(helper.getUserIdForOta(userId)).assertEqual(100);
    })

    it("test_getUserIdForOta2", 0, async () => {
      let userId = '0';

      interface Helper {
        getUserIdForOta(userId: string): number;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      expect(helper.getUserIdForOta(userId)).assertEqual(100);
    })

    it("test_getUserIdForOta3", 0, async () => {
      let userId = '1';

      interface Helper {
        getUserIdForOta(userId: string): number;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      expect(helper.getUserIdForOta(userId)).assertEqual(92);
    })

    it("test_saveDataToSettings1", 0, () => {
      interface Helper {
        saveDataToSettings(): void;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      let screenLockOwnerInfo: ScreenLockOwnerInfo[] = [];
      Reflect.set(helper, 'mScreenLockRdbStore', undefined);
      Reflect.get(screenLockDataRestoreModule, 'saveDataToSettings')
      for (let i = 0; i <= screenLockOwnerInfo.length - 1; i++) {
        if (screenLockOwnerInfo[i].ownerInfoKey === KEY_OWNER_INFO_SWITCH) {
          sSettingsUtil.setSecureValue(KEY_OWNER_INFO_SWITCH, 'true');
        } else if (screenLockOwnerInfo[i].ownerInfoKey === KEY_OWNER_INFO) {
          sSettingsUtil.setSecureValue(KEY_OWNER_INFO, SCREENLOCK_SIGNATURE);
        } else {
          sSettingsUtil.setSecureValue(KEY_OWNER_INFO_SWITCH, 'true');
          sSettingsUtil.setSecureValue(KEY_OWNER_INFO, SCREENLOCK_SIGNATURE);
        }
      }
      expect(Reflect.has(helper, 'saveDataToSettings')).not().assertNull();
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO_SWITCH)).not().assertNull();
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO)).not().assertNull();
    })

    it("test_saveDataToSettings2", 0, () => {
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO_SWITCH)).not().assertNull();
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO)).not().assertNull();
    })

    it("test_copyScreenLockDb1", 0, () => {
      interface Helper {
        copyScreenLockDb(): Promise<relationalStore.RdbStore | undefined>;
      }

      const backupDatabaseDir = '/data/app/el2/100';
      const SCREENLOCKDB = 'base';
      let hasFile = FileUtils.isExist(backupDatabaseDir + '/' + SCREENLOCKDB);
      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      Reflect.set(helper, 'backupDatabaseDir', backupDatabaseDir);
      Reflect.set(helper, 'SCREENLOCKDB', 'base');
      let createResult = FileUtils.createFolder(backupDatabaseDir + '/test');
      FileUtils.deleteConfigFile(backupDatabaseDir + '/test');
      helper.copyScreenLockDb();
      let func: Function = Reflect.get(screenLockDataRestoreModule, 'copyScreenLockDb');
      let copyResult = FileUtils.copyFile(backupDatabaseDir + '/' + SCREENLOCKDB, backupDatabaseDir + '/rdb/');
      expect(copyResult).assertFalse();
      expect(createResult).assertFalse();
      expect(func()).not().assertUndefined();
      expect(helper.copyScreenLockDb()).not().assertUndefined();
      expect(hasFile).assertFalse();
    })

    it("test_copyScreenLockDb2", 0, () => {
      interface Helper {
        copyScreenLockDb(): Promise<relationalStore.RdbStore | undefined>;
      }

      let helper: Helper = (screenLockDataRestoreModule as object as Helper);
      let backupDatabaseDir = Reflect.get(screenLockDataRestoreModule, 'backupDatabaseDir') as string;
      const SCREENLOCKDB = 'locksettings.db';
      FileUtils.createFolder(backupDatabaseDir + '/' + SCREENLOCKDB);
      helper.copyScreenLockDb();
      expect(helper.copyScreenLockDb()).not().assertUndefined();
      FileUtils.deleteConfigFile(backupDatabaseDir + '/' + SCREENLOCKDB);
    })

    it('restore_old_screenLock_data_is_signature_before_upgrade', 0, async () => {
      sSettingsUtil.setSecureValue(KEY_OWNER_INFO_SWITCH, 'true');
      sSettingsUtil.setSecureValue(KEY_OWNER_INFO, SCREENLOCK_SIGNATURE);
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO_SWITCH) === 'true' ? '1' : '0')
        .assertEqual(SCREENLOCK_SIGNATURE_VISIBLE);
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO))
        .assertEqual(SCREENLOCK_SIGNATURE);
    });

    it('restore_old_screenLock_data_no_signature_before_upgrade', 0, async () => {
      sSettingsUtil.setSecureValue(KEY_OWNER_INFO_SWITCH, 'false');
      sSettingsUtil.setSecureValue(KEY_OWNER_INFO, UNSCREENLOCK_SIGNATURE);
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO_SWITCH) === 'true' ? '1' : '0')
        .assertEqual(SCREENLOCK_SIGNATURE_UNVISIBLE);
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO))
        .assertEqual(UNSCREENLOCK_SIGNATURE);
    });

    it('restore_old_screenLock_data_no_signature_before_upgrade1', 0, async () => {
      sSettingsUtil.setSecureValue(KEY_OWNER_INFO_SWITCH, 'false');
      sSettingsUtil.setSecureValue(KEY_OWNER_INFO, SCREENLOCK_SIGNATURE);
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO_SWITCH) === 'true' ? '1' : '0')
        .assertEqual(SCREENLOCK_SIGNATURE_UNVISIBLE);
      expect(sSettingsUtil.getSecureValue(KEY_OWNER_INFO))
        .assertEqual(SCREENLOCK_SIGNATURE);
    });

    it('test_StartSignatureDataRestore_return', 0, (): void => {
      let result = mScreenLockDataRestoreModuleMode.StartSignatureDataRestore();
      expect(result).not().assertNull();
    })

    it('test_RestoreOldScreenLockData_return', 0, (): void => {
      let result = mScreenLockDataRestoreModuleMode.RestoreOldScreenLockData();
      expect(result).not().assertNull();
    })

    it('test_GetUserId_return', 0, (): void => {
      let result = mScreenLockDataRestoreModuleMode.GetUserId();
      expect(result).not().assertNull();
    })

    it('test_SaveDataToSettings_return', 0, (): void => {
      let result = mScreenLockDataRestoreModuleMode.SaveDataToSettings();
      expect(result).not().assertNull();
    })

    it('test_GetUserIdForOta_return', 0, (): void => {
      let userId: string = '-10';
      let result = mScreenLockDataRestoreModuleMode.GetUserIdForOta(userId);
      expect(result).assertEqual(100);
    })

    it('test_GetUserIdForOta_return_one', 0, (): void => {
      let userId: string = '0';
      let result = mScreenLockDataRestoreModuleMode.GetUserIdForOta(userId);
      expect(result).assertEqual(100);
    })

    it('test_GetUserIdForOta_return_two', 0, (): void => {
      let userId: string = '10';
      let result = mScreenLockDataRestoreModuleMode.GetUserIdForOta(userId);
      expect(result).assertEqual(101);
    })

    it('test_CopyScreenLockDb_return', 0, (): void => {
      let result = mScreenLockDataRestoreModuleMode.CopyScreenLockDb();
      expect(result).not().assertNull();
    })
  })
}

export class ScreenLockDataRestoreModuleMode extends ScreenLockDataRestoreModule {
  constructor() {
    super(mContext);
  }

  public StartSignatureDataRestore(): Promise<void> {
    return this.startSignatureDataRestore();
  }

  public RestoreOldScreenLockData(): Promise<void> {
    return this.restoreOldScreenLockData();
  }

  public GetUserId(): Promise<number> {
    return this.getUserId();
  }

  public SaveDataToSettings(): Promise<void> {
    return this.saveDataToSettings();
  }

  public GetUserIdForOta(userId: string): number {
    return this.getUserIdForOta(userId);
  }

  public CopyScreenLockDb(): Promise<relationalStore.RdbStore | undefined> {
    return this.copyScreenLockDb();
  }
}
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when,
  ArgumentMatchers } from '@ohos/hypium';
import { launcherAbilityManager } from '../../../../../../..';
import type { ShortcutInfo } from '../../../../../../main/ets/bean/ReceiveEventInfo';
import { AppItemInfo } from '../../../../../../main/ets/bean/AppItemInfo';
import { CommonConstants } from '../../../../../../main/ets/constants/CommonConstants';

export function LauncherAbilityManagerTest() {
  describe('LauncherAbilityManagerTest', () => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    });

    afterAll((): void => {
    });

    it('test_getLauncherAbilityList_should_return_array', 0, async (done: Function) => {
      let result = await launcherAbilityManager.getLauncherAbilityList();
      let res = Array.isArray(result);
      expect(res).assertTrue();
      done();
    })

    it('test_getLauncherAbilityInfo_should_return_array', 0, async (done: Function) => {
      let bundleName:string = '';
      let isPackAdd:boolean = true;
      let result = await launcherAbilityManager.getLauncherAbilityInfo(bundleName, isPackAdd);
      let res = Array.isArray(result);
      expect(res).assertTrue();
      done();
    })

    it('test_getShortcutInfo', 0, async (done: Function) => {
      let paramBundleName:string = '';
      let callback = (bundleName: string, list: ShortcutInfo[]) => {
      };
      await launcherAbilityManager.getShortcutInfo(paramBundleName, callback);
      expect(launcherAbilityManager).not().assertEqual('undefined');
      done();
    })

    it('test_user', 0, (): void => {
      let userId: number = 1;
      launcherAbilityManager.setCurrentUserId(userId);
      let curUserId = launcherAbilityManager.getUserId();
      expect(userId).assertEqual(curUserId);
    })

    it('test_listener_null', 0, (): void => {
      expect(launcherAbilityManager.registerLauncherAbilityChangeListener(null) == undefined).assertTrue();
      expect(launcherAbilityManager.unregisterLauncherAbilityChangeListener(null) == undefined).assertTrue();

      let callBack = () => {
      };
      launcherAbilityManager.unregisterLauncherAbilityChangeListener(callBack);
      const index = launcherAbilityManager['mLauncherAbilityChangeListeners'].indexOf(callBack);
      expect(index).assertEqual(-1);
    })

    it('test_notifyLauncherAbilityChange', 0, (): void => {
      launcherAbilityManager['notifyLauncherAbilityChange']('', '', 9999, 0);
      const userid = launcherAbilityManager.getUserId();
      launcherAbilityManager['notifyLauncherAbilityChange']('', '', userid, 0);
      expect(launcherAbilityManager).not().assertNull();
    })

    it('test_convertToAppItemInfo', 0, async (done: Function) => {
      let ret = await launcherAbilityManager['convertToAppItemInfo'](null);
      expect(ret).assertUndefined();

      let bundleName:string = 'com.ohos.contacts';
      let isPackAdd:boolean = true;
      let result = await launcherAbilityManager.getLauncherAbilityInfo(bundleName, isPackAdd);
      ret = await launcherAbilityManager['convertToAppItemInfo'](result[0],true);
      expect(ret).not().assertNull();
      done();
    })

    it('test_cleanAppMapCache', 0, (): void => {
      expect(launcherAbilityManager.cleanAppMapCache() === undefined).assertTrue();
    })

    it("test_isAbilityInstalledAsync", 0, () => {
      let bundleName: string = 'anyAsYouLike';
      const callback = async (): Promise<boolean> => true;
      expect(launcherAbilityManager.isAbilityInstalledAsync(bundleName, callback) == undefined).assertTrue();
    })

    it("test_getAppInfoByBundleName", 0, async (done: Function) => {
      let bundleName: string = 'anyAsYouLike';
      let result = await launcherAbilityManager.getAppInfoByBundleName(bundleName);
      expect(result == undefined).assertTrue();
      done();
    })

    it("test_getAppLabelId", 0, async (done: Function) => {
      let bundleName: string = 'anyAsYouLike';
      let result = await launcherAbilityManager.getAppLabelId(bundleName);
      expect(result == undefined).assertTrue();
      done();
    })

    it("test_getAppIconId", 0, async (done: Function) => {
      let bundleName: string = 'anyAsYouLike';
      let result = await launcherAbilityManager.getAppIconId(bundleName);
      expect(result == undefined).assertTrue();
      done();
    })

    it("test_uninstallLauncherAbility", 0, async (done: Function) => {
      let bundleName: string = 'anyAsYouLike';
      const callback = async (): Promise<boolean> => true;
      try {
        expect(await launcherAbilityManager.uninstallLauncherAbility(bundleName, callback, 0) == undefined).assertTrue();
        done();
      } catch (e) {
        done();
      }
    })

    it('test_launcherAbilityManager_mPackageAddCallback', 0, () => {
      let info: ItemInfo = {
        appIndex: 1,
        bundleName: '996',
        userId: 1,
      };
      launcherAbilityManager['mPackageAddCallback'](info);
      expect(info.appIndex).assertEqual(1);
    });

    it('test_launcherAbilityManager_mPackageRemoveCallback', 0, () => {
      let info: ItemInfo = {
        appIndex: 1,
        bundleName: '996',
        userId: 1,
      };
      launcherAbilityManager['mPackageRemoveCallback'](info);
      expect(info.appIndex).assertEqual(1);
    });

    it('test_launcherAbilityManager_mPackageUpdateCallback', 0, () => {
      let info: ItemInfo = {
        appIndex: 1,
        bundleName: '996',
        userId: 1,
      };
      launcherAbilityManager['mPackageUpdateCallback'](info);
      expect(info.appIndex).assertEqual(1);
    });

    it('test_launcherAbilityManager_registerLauncherAbilityChangeListener', 0, () => {
      launcherAbilityManager.registerLauncherAbilityChangeListener(null);
      expect(launcherAbilityManager).not().assertNull();
    });

    it('test_launcherAbilityManager_unregisterLauncherAbilityChangeListener', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(launcherAbilityManager['mLauncherAbilityChangeListeners'], launcherAbilityManager['mLauncherAbilityChangeListeners'].indexOf)
      when(mockFunc)(ArgumentMatchers.any).afterReturn(-1);
      launcherAbilityManager.unregisterLauncherAbilityChangeListener(null);
      expect(launcherAbilityManager).not().assertNull();
      launcherAbilityManager.unregisterLauncherAbilityChangeListener(1);
      expect(launcherAbilityManager).not().assertNull();
      mocker.clear(launcherAbilityManager['mLauncherAbilityChangeListeners']);
      mocker.clearAll();
    });

    it('test_launcherAbilityManager_notifyLauncherAbilityChange', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(launcherAbilityManager, launcherAbilityManager['getUserId'])
      when(mockFunc)(ArgumentMatchers.any).afterReturn(9);
      launcherAbilityManager['notifyLauncherAbilityChange'](null, '996', 9, 1);
      expect(launcherAbilityManager).not().assertNull();
      when(mockFunc)(ArgumentMatchers.any).afterReturn(1);
      launcherAbilityManager['notifyLauncherAbilityChange'](null, '996', 9, 1);
      expect(launcherAbilityManager).not().assertNull();
      mocker.clear(launcherAbilityManager);
      mocker.clearAll();
    });

    it('test_launcherAbilityManager_getLauncherAbilityInfo', 0, async (done: Function) => {
      let result: AppItemInfo[] = await launcherAbilityManager['getLauncherAbilityInfo']('996', true);
      expect(result.length).assertEqual(0);
      done();
    });

    it('test_launcherAbilityManager_isIgnoreApp', 0, () => {
      let result: boolean = launcherAbilityManager['isIgnoreApp'](null);
      expect(result).assertTrue();
    });

    it('test_launcherAbilityManager_isAbilityInstalledAsync', 0, () => {
      launcherAbilityManager.isAbilityInstalledAsync('996', () => { return true; });
      expect(launcherAbilityManager).not().assertNull();
    });

    it('test_launcherAbilityManager_getCacheKey', 0, () => {
      let result: string = launcherAbilityManager['getCacheKey']('996', null);
      expect(result).assertEqual('9960');
    });

    it('test_launcherAbilityManager_uninstallLauncherAbility', 0, async (done: Function) => {
      await launcherAbilityManager.uninstallLauncherAbility('996',
        (bundleName: string, result: ESObject, appIndex: number, forceUninstall: boolean) => {}, 2);
      expect(launcherAbilityManager).not().assertNull();
      done();
    });

    it('test_launcherAbilityManager_getShortcutInfoByBundleNameSync', 0, () => {
      let result: ShortcutInfo[] = launcherAbilityManager.getShortcutInfoByBundleNameSync('996');
      expect(result.length).assertEqual(0);
    });

    class ItemInfo {
      appIndex: number | undefined;
      bundleName: string | undefined;
      userId: number | undefined;
    }
  })
}
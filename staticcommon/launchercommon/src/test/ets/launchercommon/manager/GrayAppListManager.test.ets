/**
 * Copyright (c) 2023-2023 Huawei Device Co., Ltd.
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
import { AccountMgr, localEventManager, sSettingsUtil } from '@ohos/frameworkwrapper';

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect, Level, ArgumentMatchers,
  when, MockKit} from '@ohos/hypium';
import { GrayAppListManager } from '../../../../main/ets/TsIndex';
import { BaseBundleInfo } from '../../../../main/ets/bean/BaseBundleInfo'

export function GrayAppListManagerTest() {
  describe('GrayAppListManagerTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('GrayAppListManagerTest_getInstance', Level.LEVEL0, (): void => {
      expect(GrayAppListManager.getInstance()).not().assertNull();
    })

    it('isGrayAppIcon', Level.LEVEL0, (): void => {
      let itemInfo: BaseBundleInfo = {
        bundleName: 'com.ohos.photos',
        appIndex: 0,
      };
      expect(GrayAppListManager.getInstance().isGrayAppIcon(itemInfo)).assertFalse();
    })

    it('test_init', Level.LEVEL0, () => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      instance.init();
      expect(instance).not().assertNull();
    })

    it("retryRegisterAppGrayDataChange1", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      await instance.retryRegisterAppGrayDataChange(0);
      await instance.retryRegisterAppGrayDataChange(1);
      expect(instance['datashareHelper']).assertEqual(undefined);
      done();
    })

    it("retryRegisterAppGrayDataChange2", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, instance['registerGaryApp']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(undefined);
      await instance.retryRegisterAppGrayDataChange(1);
      expect(instance['datashareHelper']).not().assertEqual(undefined);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("retryRegisterAppGrayDataChange3", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, instance['registerGaryApp']);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('error');
      let mockFunction1: Function =
        mocker.mockFunc(instance, instance['retryRegisterAppGrayDataChange']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      await instance.retryRegisterAppGrayDataChange(1);
      expect(instance['datashareHelper']).assertEqual(undefined);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("registerGaryApp1", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      await instance.registerGaryApp();
      expect(instance['datashareHelper']).assertEqual(undefined);
      done();
    })

    it("registerGaryApp2", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(1);
      let mockFunction1: Function =
        mocker.mockFunc(instance, instance['getGrayIconSwitch']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(instance, instance['getGrayList']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(Promise.resolve(['1','2']));
      let mockFunction3: Function =
        mocker.mockFunc(instance, instance['onAppGrayInfoChangedCallback']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(instance, instance['grayIconSwitchCallback']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(Promise.resolve());
      await instance.retryRegisterAppGrayDataChange(1);
      await instance.registerGaryApp();
      expect(instance['grayIconSwitch']).assertEqual(true);
      mocker.clear(AccountMgr);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("registerGaryApp3", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(1);
      let mockFunction1: Function =
        mocker.mockFunc(instance, instance['getGrayIconSwitch']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(instance, instance['getGrayList']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(Promise.resolve(['1','2']));
      let mockFunction3: Function =
        mocker.mockFunc(instance, instance['onAppGrayInfoChangedCallback']);
      when(mockFunction3)(ArgumentMatchers.any).afterThrow('error');
      await instance.retryRegisterAppGrayDataChange(1);
      await instance.registerGaryApp();
      expect(instance['grayIconSwitch']).assertEqual(true);
      mocker.clear(AccountMgr);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("registerGaryApp4", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.getCurrentAccountId);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(1);
      let mockFunction1: Function =
        mocker.mockFunc(instance, instance['getGrayIconSwitch']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction2: Function =
        mocker.mockFunc(instance, instance['getGrayList']);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(Promise.resolve(['1','2']));
      let mockFunction3: Function =
        mocker.mockFunc(instance, instance['onAppGrayInfoChangedCallback']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction4: Function =
        mocker.mockFunc(instance, instance['grayIconSwitchCallback']);
      when(mockFunction4)(ArgumentMatchers.any).afterReturn(Promise.reject());
      await instance.retryRegisterAppGrayDataChange(1);
      await instance.registerGaryApp();
      expect(instance['grayIconSwitch']).assertEqual(true);
      mocker.clear(AccountMgr);
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("getGrayIconSwitch", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(sSettingsUtil, sSettingsUtil.getValue);
      when(mockFunction)(ArgumentMatchers.any).afterReturn('true');
      let result = instance['getGrayIconSwitch']();
      expect(result).assertTrue();
      mocker.clear(sSettingsUtil);
      mocker.clearAll();
      done();
    })

    it("isGrayAppIcon1", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      instance['grayAppList'] = []
      let itemInfo: BaseBundleInfo = {
        bundleName: 'com.ohos.photos',
        appIndex: 0,
      };
      let result = instance.isGrayAppIcon(itemInfo);
      expect(result).assertEqual(false);
      done();
    })

    it("isGrayAppIcon2", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      instance['grayAppList'] = [{
        bundleName: '1',
        appIndex: 0,
      }, {
        bundleName: '1',
        appIndex: 0,
      }];
      let itemInfo: BaseBundleInfo = {
        bundleName: '1',
        appIndex: 0,
      };
      let result = instance.isGrayAppIcon(itemInfo);
      expect(result).assertEqual(true);
      done();
    })

    it("isGrayAppIcon3", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      instance['grayAppList'] = [{
        bundleName: '1',
        appIndex: 0,
      }, {
        bundleName: '2',
        appIndex: 0,
      }];
      let itemInfo: BaseBundleInfo = {
        bundleName: '1',
        appIndex: 0,
      };
      let result = instance.isGrayAppIcon(itemInfo);
      expect(result).assertEqual(false);
      done();
    })

    it("getGrayList", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      let result = await instance['getGrayList']();
      expect(result.length>0).assertEqual(false);
      done();
    })

    it("grayIconSwitchCallback1", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, instance['getGrayIconSwitch']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(instance, instance['getGrayList']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve(['1','2']));
      let mockFunction2: Function =
        mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(instance, instance['onAppGrayInfoChangedCallback']);
      when(mockFunction3)(ArgumentMatchers.any).afterReturn(undefined);
      instance['grayIconSwitchCallback'](1);
      expect(instance['grayIconSwitch']).assertEqual(true);
      mocker.clear(instance);
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("grayIconSwitchCallback2", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, instance['getGrayIconSwitch']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(instance, instance['getGrayList']);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(Promise.resolve(['1','2']));
      let mockFunction2: Function =
        mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      when(mockFunction2)(ArgumentMatchers.any).afterReturn(undefined);
      let mockFunction3: Function =
        mocker.mockFunc(instance, instance['onAppGrayInfoChangedCallback']);
      when(mockFunction3)(ArgumentMatchers.any).afterThrow('error');
      instance['grayIconSwitchCallback'](1);
      expect(instance['grayIconSwitch']).assertEqual(true);
      mocker.clear(instance);
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("grayIconSwitchCallback3", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      instance['grayIconSwitch'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, instance['getGrayIconSwitch']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      let mockFunction1: Function =
        mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      instance['grayIconSwitchCallback'](1);
      expect(instance['grayAppList'].length).assertEqual(0);
      mocker.clear(instance);
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("onAppGrayInfoChangedCallback1", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      instance['grayAppList'] = [];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, instance['getGrayList']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve([]));
      await instance['onAppGrayInfoChangedCallback']();
      mocker.clear(instance);
      mocker.clearAll();
      done();
    })

    it("onAppGrayInfoChangedCallback2", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      instance['grayAppList'] = ['1','2','5','6'];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, instance['getGrayList']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve(['1','2','3','4']));
      let mockFunction1: Function =
        mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      await instance['onAppGrayInfoChangedCallback']();
      mocker.clear(instance);
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })

    it("onAppGrayInfoChangedCallback3", 0, async(done:Function) => {
      let instance: GrayAppListManager = GrayAppListManager.getInstance();
      instance['grayAppList'] = ['1','2'];
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(instance, instance['getGrayList']);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(Promise.resolve(['1','2']));
      let mockFunction1: Function =
        mocker.mockFunc(localEventManager, localEventManager.sendLocalEventSticky);
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(undefined);
      await instance['onAppGrayInfoChangedCallback']();
      mocker.clear(instance);
      mocker.clear(localEventManager);
      mocker.clearAll();
      done();
    })
  })
}
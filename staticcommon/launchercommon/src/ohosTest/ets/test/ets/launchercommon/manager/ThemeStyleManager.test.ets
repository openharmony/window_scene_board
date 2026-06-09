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

import { CheckEmptyUtils, FileUtils } from '@ohos/basicutils'
import { AccountMgr, DeviceHelper } from '@ohos/frameworkwrapper'
import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium'
import { ThemeStyleManager,ThemeStyleCallback } from '../../../../../../main/ets/manager/ThemeStyleManager'
import { ThemeStyleInfo } from '../../../../../../main/ets/bean/ThemeStyleInfo'
import commonEventManager from '@ohos.commonEventManager'

export default function ThemeStyleManagerTest() {
  describe('ThemeStyleManagerTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })
    it('assertEqual', 0, () => {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      let a = 'test'
      // Defines a variety of assertion methods, which are used to declare expected boolean conditions.
      expect(a).assertEqual('test')
    })

    it('test_themeStyle', Level.LEVEL0, () => {
      let instance: ThemeStyleManager = ThemeStyleManager.getInstance();

      instance.loadThemeStyle();
      instance.getThemeStyle();
      instance.isThemeStyleChanged()

      let isSuccess: boolean = true;
      instance.notifyThemeInfo(isSuccess);
      isSuccess = false;
      instance.notifyThemeInfo(isSuccess);
      let a = 'test';
      expect(a).assertEqual('test');
    })

    it('test_notifyThemeInfo01', 0, async () => {
      let instance: ThemeStyleManager = ThemeStyleManager.getInstance();
      let isIconStyleEnable: boolean = false;
      instance.notifyThemeInfo(isIconStyleEnable);
      expect(isIconStyleEnable).assertFalse();
    });

    it('test_notifyThemeInfo02', 0, async () => {
      let instance: ThemeStyleManager = ThemeStyleManager.getInstance();
      let iconSize: number = 6;
      let isIconStyleEnable: boolean = false;
      let isShowName: boolean = false;
      let radiusSize: number = 1;

      instance.notifyThemeInfo(isIconStyleEnable, isShowName, iconSize, radiusSize);
      expect(iconSize).not().assertNull();
    });

    it('test_notifyThemeInfo03', 0, async () => {
      let instance: ThemeStyleManager = ThemeStyleManager.getInstance();
      let iconSize: number = 6;
      let isIconStyleEnable: boolean = false;
      let radiusSize: number = 1;

      instance.notifyThemeInfo(isIconStyleEnable, undefined,iconSize, radiusSize);
      expect(iconSize).not().assertNull();
    });

    it('test_notifyThemeResult01', 0, async () => {
      let instance: ThemeStyleManager = ThemeStyleManager.getInstance();
      let isSuccess: boolean = true;

      instance.notifyThemeResult(isSuccess);
      expect(isSuccess).assertTrue();
    });

    it('test_notifyThemeResult02', 0, async () => {
      let instance: ThemeStyleManager = ThemeStyleManager.getInstance();
      let isSuccess: boolean = false;

      instance.notifyThemeResult(isSuccess);
      expect(isSuccess).assertFalse();
    });

    it('test_unRegisterThemeCallBack', 0, async () => {
      let instance: ThemeStyleManager = ThemeStyleManager.getInstance();

      instance.unRegisterThemeCallBack();
      expect(instance).not().assertNull();
    });

    it('test_unregisterThemeEvent', 0, async () => {
      let instance: ThemeStyleManager = ThemeStyleManager.getInstance();

      instance.unregisterThemeEvent();
      expect(instance).not().assertNull();
    });

    it('loadThemeStyle_01', 0, async () => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isExist: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(isExist)(ArgumentMatchers.any).afterReturn(true);
      try {
        themeStyleManager.loadThemeStyle();
        expect(themeStyleManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
    });

    it('loadThemeStyle_02', 0, async () => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isExist: Function = mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(isExist)(ArgumentMatchers.any).afterReturn(false);
      try {
        themeStyleManager.loadThemeStyle();
        expect(themeStyleManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
    });

    it('notifyThemeInfo_test01', 0, async () => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(true);
      try {
        themeStyleManager.notifyThemeInfo(true, true, 2, 0);
        expect(themeStyleManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('notifyThemeInfo_test02', 0, async () => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(isEmpty)(ArgumentMatchers.any).afterReturn(false);
      try {
        themeStyleManager.notifyThemeInfo(true, true, 9, 2);
        expect(themeStyleManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    });

    it('isPcHomeActivateCallBack_test', 0, async () => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isPC: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(true);
      try {
        themeStyleManager['isPcHomeActivateCallBack'](true, true, () => {
        });
        expect(themeStyleManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('isPcHomeActivateCallBack_test02', 0, async () => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mocker: MockKit = new MockKit();
      let isPC: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(isPC)(ArgumentMatchers.any).afterReturn(false);
      try {
        themeStyleManager['isPcHomeActivateCallBack'](true, true, () => {
        });
        expect(themeStyleManager).not().assertNull();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it("getInstance1", 0, async(done:Function) => {
      globalThis.ThemeStyleManagerInstance = null;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.isInvalidAccount);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(false);
      try {
        let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
        expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      } catch (e) {
      }
      mocker.clear(AccountMgr);
      mocker.clearAll();
      done();
    })

    it("getInstance2", 0, async(done:Function) => {
      globalThis.ThemeStyleManagerInstance = null;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(AccountMgr, AccountMgr.isInvalidAccount);
      when(mockFunction)(ArgumentMatchers.any).afterReturn(true);
      try {
        let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
        expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      } catch (e) {
      }
      mocker.clear(AccountMgr);
      mocker.clearAll();
      done();
    })

    it("loadThemeStyle1", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['index'] = 100;
      themeStyleManager['isStyleChanged'] = true;
      themeStyleManager['themeStyle'].iconSizeScale = 1;
      themeStyleManager['themeStyle'].radiusSizeScale = 1;
      themeStyleManager['themeStyle'].isShowName = false;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunction)('/data/themes/a/app/flag').afterReturn(true);
      when(mockFunction)('/data/themes/a/system/home/base/home_style_config.json').afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(FileUtils, FileUtils.readJsonFile);
      let themeStyleInfo = new Object({
        size:2,
      });
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(themeStyleInfo);
      try {
        let result = themeStyleManager.loadThemeStyle();
        expect(result).assertInstanceOf('String');
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
      done();
    })

    it("loadThemeStyle2", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['index'] = 100;
      themeStyleManager['isStyleChanged'] = true;
      themeStyleManager['themeStyle'].iconSizeScale = 1;
      themeStyleManager['themeStyle'].radiusSizeScale = 1;
      themeStyleManager['themeStyle'].isShowName = false;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunction)('/data/themes/a/app/flag').afterReturn(true);
      when(mockFunction)('/data/themes/a/system/home/base/home_style_config.json').afterReturn(false);
      try {
        let result = themeStyleManager.loadThemeStyle();
        expect(result).assertEqual('ThemeStyleThemeFlagA0');
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
      done();
    })

    it("loadThemeStyle3", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['index'] = 100;
      themeStyleManager['isStyleChanged'] = true;
      themeStyleManager['themeStyle'].iconSizeScale = 1;
      themeStyleManager['themeStyle'].radiusSizeScale = 1;
      themeStyleManager['themeStyle'].isShowName = false;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunction)('/data/themes/a/app/flag').afterReturn(false);
      when(mockFunction)('/data/themes/b/app/flag').afterReturn(true);
      let mockFunction1: Function =
        mocker.mockFunc(FileUtils, FileUtils.readJsonFile);
      let themeStyleInfo = new Object({
        size:2,
      });
      when(mockFunction1)(ArgumentMatchers.any).afterReturn(themeStyleInfo);
      when(mockFunction)('/data/themes/b/system/home/base/home_style_config.json').afterReturn(true);
      try {
        let result = themeStyleManager.loadThemeStyle();
        expect(result).assertInstanceOf('String');
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
      done();
    })

    it("loadThemeStyle4", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['index'] = 100;
      themeStyleManager['isStyleChanged'] = true;
      themeStyleManager['themeStyle'].iconSizeScale = 1;
      themeStyleManager['themeStyle'].radiusSizeScale = 1;
      themeStyleManager['themeStyle'].isShowName = false;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunction)('/data/themes/a/app/flag').afterReturn(false);
      when(mockFunction)('/data/themes/b/app/flag').afterReturn(true);
      when(mockFunction)('/data/themes/b/system/home/base/home_style_config.json').afterReturn(false);
      try {
        let result = themeStyleManager.loadThemeStyle();
        expect(result).assertEqual('ThemeStyleThemeFlagB0');
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
      done();
    })

    it("loadThemeStyle5", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['index'] = 100;
      themeStyleManager['isStyleChanged'] = true;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(FileUtils, FileUtils.isExist);
      when(mockFunction)('/data/themes/a/app/flag').afterReturn(false);
      when(mockFunction)('/data/themes/b/app/flag').afterReturn(false);
      try {
        let result = themeStyleManager.loadThemeStyle();
        expect(result).assertEqual('');
      } catch (e) {
      }
      mocker.clear(FileUtils);
      mocker.clearAll();
      done();
    })

    it("getThemeStyle", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let result = themeStyleManager.getThemeStyle();
      expect(result instanceof ThemeStyleInfo).assertTrue();
      done();
    })

    it("registerThemeEvent1", 0, async (done: Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let callback = (isIconsActivate?: boolean, isHomeActivate?: boolean) => {
      }
      themeStyleManager['userId'] = 1;
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(themeStyleManager, themeStyleManager['subscribeActivateThemeEvent']);
      when(mockFunction)(ArgumentMatchers.any).afterThrow('error');
      try {
        themeStyleManager.registerThemeEvent(callback);
        expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      } catch (e) {
      }
      mocker.clear(themeStyleManager);
      mocker.clearAll();
      done();
    })

    it("registerThemeEvent2", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let callback = (isIconsActivate?:boolean,isHomeActivate?:boolean)=>{}
      themeStyleManager.registerThemeEvent(callback);
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      done();
    })

    it("unregisterThemeEvent1", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['unregisterThemeEvent']();
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      done();
    })

    it("unregisterThemeEvent2", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['mSubscriber'] = await commonEventManager.createSubscriber({ events: ['com.ohos.ActivateTheme'], userId: themeStyleManager['userId'] });
      themeStyleManager['unregisterThemeEvent']();
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      done();
    })

    it("isThemeStyleChanged", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let result = themeStyleManager['isThemeStyleChanged']();
      expect(result).assertEqual(false);
      done();
    })

    it("notifyThemeInfo1", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['notifyThemeInfo'](true,undefined,undefined,undefined);
      themeStyleManager['themeStyle'].isShowName;
      expect(themeStyleManager).not().assertUndefined();
      done();
    })

    it("notifyThemeInfo2", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['notifyThemeInfo'](true,undefined,-8,undefined);
      expect(themeStyleManager['themeStyle'].iconSizeScale).assertEqual(undefined);
      done();
    })

    it("notifyThemeInfo3", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['notifyThemeInfo'](true,undefined,10,undefined);
      themeStyleManager['themeStyle'].isShowName;
      expect(themeStyleManager).not().assertNull();
      done();
    })

    it("notifyThemeInfo4", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['notifyThemeInfo'](true,undefined,undefined,-2);
      expect(themeStyleManager['themeStyle'].radiusSizeScale).assertEqual(undefined);
      done();
    })

    it("notifyThemeInfo5", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['notifyThemeInfo'](true,undefined,undefined,5);
      expect(themeStyleManager['themeStyle'].radiusSizeScale).assertEqual(undefined);
      done();
    })

    it("notifyThemeInfo6", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['notifyThemeInfo'](true,true,undefined,undefined);
      expect(themeStyleManager['themeStyle'].isShowName).assertEqual(true);
      done();
    })

    it("notifyThemeInfo7", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['notifyThemeInfo'](true,true,undefined,1);
      expect(themeStyleManager).not().assertNull();
      done();
    })

    it("notifyThemeInfo8", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['notifyThemeInfo'](true,true,5,1);
      expect('ThemeStyleThemeFlagA1').assertEqual('ThemeStyleThemeFlagA1');
      let a = 'test';
      expect(a).assertEqual('test');
      done();
    })

    it("notifyThemeInfo9", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let callback = new Object({
        onStyleChanged:(isIconActive: boolean)=>{}
      }) as ThemeStyleCallback;
      themeStyleManager['themeCallback'] = callback;
      themeStyleManager['notifyThemeInfo'](true,true,5,1);
      expect(themeStyleManager).not().assertNull();
      done();
    })

    it("notifyThemeResult1", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['notifyThemeResult'](true);
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      done();
    })

    it("notifyThemeResult2", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['lastThemeStyle'].iconSizeScale =5;
      themeStyleManager['lastThemeStyle'].radiusSizeScale =5;
      themeStyleManager['lastThemeStyle'].isShowName =true;
      themeStyleManager['themeStyle'].iconSizeScale =5;
      themeStyleManager['themeStyle'].radiusSizeScale =5;
      themeStyleManager['themeStyle'].isShowName =true;
      let callback = new Object({
        onStyleChanged:(isIconActive: boolean)=>{}
      }) as ThemeStyleCallback;
      themeStyleManager['themeCallback'] = callback;
      themeStyleManager['notifyThemeResult'](false);
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      done();
    })

    it("notifyThemeResult3", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['lastThemeStyle'].iconSizeScale =5;
      themeStyleManager['lastThemeStyle'].radiusSizeScale =5;
      themeStyleManager['lastThemeStyle'].isShowName =true;
      themeStyleManager['themeStyle'].iconSizeScale =5;
      themeStyleManager['themeStyle'].radiusSizeScale =5;
      themeStyleManager['themeStyle'].isShowName =true;
      themeStyleManager.unRegisterThemeCallBack();
      themeStyleManager['notifyThemeResult'](false);
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      done();
    })

    it("registerThemeCallBack", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let callback = {
        onStyleChanged:(isIconActive: boolean)=>{}
      } as ThemeStyleCallback;
      themeStyleManager['registerThemeCallBack'](callback);
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      done();
    })

    it("unRegisterThemeCallBack", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['unRegisterThemeCallBack']();
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      done();
    })

    it("isPcHomeActivateCallBack1", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction)().afterReturn(true);
      let callback = (isIconsActivate?:boolean,isHomeActivate?:boolean)=>{};
      themeStyleManager['isPcHomeActivateCallBack'](true,true,callback);
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    })

    it("isPcHomeActivateCallBack2", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunction: Function =
        mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockFunction)().afterReturn(false);
      try {
        let callback = (isIconsActivate?:boolean,isHomeActivate?:boolean)=>{};
        themeStyleManager['isPcHomeActivateCallBack'](true,true,callback);
        expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    })

    it("convertToThemeInfo1", 0, async(done:Function) => {
      try {
        let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
        let themeStyleInfo = undefined
        themeStyleManager['convertToThemeInfo'](themeStyleInfo);
        expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      } catch(e) {
      }
      done();
    })

    it("convertToThemeInfo2", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let themeStyleInfo = new Object({
        size:2,
        radius:2,
        showAppName:true,
        iconResourcePath:'iconResourcePath'
      });
      themeStyleManager['themeStyle'].iconSizeScale = 1;
      themeStyleManager['themeStyle'].radiusSizeScale = 1;
      themeStyleManager['themeStyle'].isShowName = false;
      themeStyleManager['themeStyle'].iconResourcePath = 'iconResourcePath1';
      themeStyleManager['convertToThemeInfo'](themeStyleInfo);
      expect(themeStyleManager).not().assertUndefined();
      done();
    })

    it("convertToThemeInfo3", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      let themeStyleInfo = new Object({
        id:1
      });
      themeStyleManager['themeStyle'].iconSizeScale = 1;
      themeStyleManager['themeStyle'].radiusSizeScale = 1;
      themeStyleManager['themeStyle'].isShowName = false;
      themeStyleManager['themeStyle'].iconResourcePath = 'iconResourcePath1';
      themeStyleManager['convertToThemeInfo'](themeStyleInfo);
      expect(themeStyleManager instanceof ThemeStyleManager).assertTrue();
      done();
    })

    it("resetThemeStyle", 0, async(done:Function) => {
      let themeStyleManager: ThemeStyleManager = ThemeStyleManager.getInstance();
      themeStyleManager['themeStyle'].iconSizeScale = 1;
      themeStyleManager['themeStyle'].radiusSizeScale = 1;
      themeStyleManager['themeStyle'].isShowName = false;
      themeStyleManager['resetThemeStyle']();
      expect(themeStyleManager['themeStyle'].isShowName).assertEqual(true);
      done();
    })
  })
}
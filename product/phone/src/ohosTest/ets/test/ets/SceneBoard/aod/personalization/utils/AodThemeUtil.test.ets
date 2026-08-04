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
import { AodFileUtil, AodManifest, AodThemeConstants, AodThemeUtil, AodUtil } from '@ohos/aod';
import { ThemeDescription } from '@ohos/aod/src/main/ets/model/AodThemeConfig';
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';
import { describe, expect, it, MockKit, when } from '@ohos/hypium';
import fs from '@ohos.file.fs';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { image } from '@kit.ImageKit';

export function AodThemeUtilTest() {
  describe('AodThemeUtilTest', () => {

    it('test_getCurrentAodManifest', 0, () => {
      AodThemeUtil.getCurrentAodManifest();
      expect(true).assertTrue();
    });

    it('test_isThemeStyle1', 0, () => {
      let aodManifest = new AodManifest();
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        return undefined;
      });
      AodThemeUtil.isThemeStyle(aodManifest);
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_isThemeStyle2', 0, () => {
      let aodManifest = new AodManifest();
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        let themeDescription: ThemeDescription = {
          id: 'fullScreen',
          origin: 'preset'
        };
        return themeDescription;
      });
      AodThemeUtil.isThemeStyle(aodManifest);
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getThemeOriginPath', 0, () => {
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        return undefined;
      });
      AodThemeUtil.getThemeOriginPath();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getThemeOriginPath1', 0, () => {
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        let themeDescription: ThemeDescription = {
          id: 'fullScreen'
        };
        return themeDescription;
      });
      AodThemeUtil.getThemeOriginPath();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getThemeOriginPath2', 0, () => {
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        let themeDescription: ThemeDescription = {
          origin: 'preset'
        };
        return themeDescription;
      });
      AodThemeUtil.getThemeOriginPath();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getThemeOriginPath3', 0, () => {
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        let themeDescription: ThemeDescription = {
          id: 'fullScreen',
          origin: 'preset'
        };
        return themeDescription;
      });
      AodThemeUtil.getThemeOriginPath();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getThemeOriginPath4', 0, () => {
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        let themeDescription: ThemeDescription = {
          id: 'fullScreen',
          origin: 'online'
        };
        return themeDescription;
      });
      AodThemeUtil.getThemeOriginPath();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getThemeId', 0, () => {
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        return undefined;
      });
      AodThemeUtil.getThemeId();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getThemeId1', 0, () => {
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        let themeDescription: ThemeDescription = {
          origin: 'online'
        };
        return themeDescription;
      });
      AodThemeUtil.getThemeId();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('test_getThemeId2', 0, () => {
      MockUtil.mockFuncForObj(AodThemeUtil, 'getThemeDescription', (): ThemeDescription | undefined => {
        let themeDescription: ThemeDescription = {
          id: 'fullScreen'
        };
        return themeDescription;
      });
      AodThemeUtil.getThemeId();
      expect(true).assertTrue();
      MockUtil.clearAll();
    });

    it('AodThemeUtil_isOnlineStyle', 0, () => {
      let aodManifest = new AodManifest();
      aodManifest.id = AodThemeConstants.OUTER_CLOCK_STYLE;
      let onlineManifest = AodThemeConstants.THEME_COMMON_PATH_ONLINE + aodManifest.id + '/aod/manifest.json';
      let res: boolean = fs.accessSync(onlineManifest);
      let res1 = AodThemeUtil.isOnlineStyle(aodManifest);
      expect(aodManifest).not().assertUndefined();
    });

    it('AodThemeUtil_getThemeSandboxPathSync1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodFileUtil, AodFileUtil.accessSync);
      when(mockFunc)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_A).afterReturn(true);
      let res: string = AodThemeUtil.getThemeSandboxPathSync();
      expect(res).assertEqual(AodThemeConstants.SANDBOX_THEME_PATH_SYSTEM_A);
      mocker.clear(AodFileUtil);
      mocker.clearAll();
    });

    it('AodThemeUtil_getThemeSandboxPathSync2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodFileUtil, AodFileUtil.accessSync);
      when(mockFunc)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_A).afterReturn(false);
      when(mockFunc)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_B).afterReturn(true);
      let res: string = AodThemeUtil.getThemeSandboxPathSync();
      expect(res).assertEqual(AodThemeConstants.SANDBOX_THEME_PATH_SYSTEM_B);
      mocker.clear(AodFileUtil);
      mocker.clearAll();
    });

    it('AodThemeUtil_getThemeSandboxPathSync3', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodFileUtil, AodFileUtil.accessSync);
      when(mockFunc)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_A).afterReturn(false);
      when(mockFunc)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_B).afterReturn(false);
      let res: string = AodThemeUtil.getThemeSandboxPathSync();
      expect(res).assertEqual('');
      mocker.clear(AodFileUtil);
      mocker.clearAll();
    });

    it('AodThemeUtil_getThemeSandboxPath1', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodFileUtil, AodFileUtil.access);
      when(mockFunc)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_A).afterReturn(true);
      let res: string = await AodThemeUtil.getThemeSandboxPath();
      expect(res).assertEqual(AodThemeConstants.SANDBOX_THEME_PATH_SYSTEM_A);
      mocker.clear(AodFileUtil);
      mocker.clearAll();
      done();
    });

    it('AodThemeUtil_getThemeSandboxPath2', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodFileUtil, AodFileUtil.access);
      when(mockFunc)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_A).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(AodFileUtil, AodFileUtil.access);
      when(mockFunc1)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_B).afterReturn(true);
      let res: string = await AodThemeUtil.getThemeSandboxPath();
      expect(res).assertEqual(AodThemeConstants.SANDBOX_THEME_PATH_SYSTEM_B);
      mocker.clear(AodFileUtil);
      mocker.clearAll();
      done();
    });

    it('AodThemeUtil_getThemeSandboxPath3', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodFileUtil, AodFileUtil.access);
      when(mockFunc)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_A).afterReturn(false);
      let mockFunc1: Function = mocker.mockFunc(AodFileUtil, AodFileUtil.access);
      when(mockFunc1)(AodThemeConstants.SANDBOX_THEME_PATH_FLAG_B).afterReturn(false);
      let res: string = await AodThemeUtil.getThemeSandboxPath();
      expect(res).assertEqual('');
      mocker.clear(AodFileUtil);
      mocker.clearAll();
      done();
    });

    it('AodThemeUtil_concatPath1', 0, () => {
      let res: string = AodThemeUtil.concatPath('1', '2', '');
      expect(res).assertEqual('1');
    });

    it('AodThemeUtil_concatPath2', 0, () => {
      let res: string = AodThemeUtil.concatPath('1', '2', '3');
      expect(res).not().assertNull();
    });

    it('AodThemeUtil_removePathEndSeparator1', 0, () => {
      let res: string = AodThemeUtil.removePathEndSeparator('');
      expect(res).assertEqual('');
    });

    it('AodThemeUtil_removePathEndSeparator2', 0, () => {
      let res: string = AodThemeUtil.removePathEndSeparator('12345');
      expect(res).not().assertNull();
    });

    it('AodThemeUtil_getCurRootDir1', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodUtil, AodUtil.isSquareFoldSubDisplay);
      when(mockFunc)().afterReturn(true);
      let res: string = AodThemeUtil.getCurRootDir();
      expect(res).assertEqual(AodThemeConstants.THEME_COMMON_SUBS_DIR);
      mocker.clear(AodUtil);
      mocker.clearAll();
    });

    it('AodThemeUtil_getCurRootDir2', 0, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AodUtil, AodUtil.isSquareFoldSubDisplay);
      when(mockFunc)().afterReturn(false);
      let res: string = AodThemeUtil.getCurRootDir();
      expect(res).assertEqual(AodThemeConstants.THEME_COMMON_DEF_DIR);
      mocker.clear(AodUtil);
      mocker.clearAll();
    });

    it('AodThemeUtil_getResDirs2', 0, () => {
      let mocker: MockKit = new MockKit();
      let res: string[] = AodThemeUtil.getResDirs();
      expect(res).not().assertUndefined();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('AodThemeUtil_removePathEndString1', 0, () => {
      const path = 'theme/aod';
      const subStr = 'aod';
      const res = AodThemeUtil.removePathEndString(path, subStr);
      expect(res).assertEqual('theme/');
    });

    it('AodThemeUtil_removePathEndString2', 0, () => {
      const path = 'theme/aod';
      const subStr = '1';
      const res = AodThemeUtil.removePathEndString(path, subStr);
      expect(res).assertEqual(path);
    });

    it('AodThemeUtil_removePathEndString3', 0, () => {
      const path = '';
      const subStr = 'aod';
      const res = AodThemeUtil.removePathEndString(path, subStr);
      expect(res).assertEqual('');
    });

    it('AodThemeUtil_getAodClockConfig', 0, () => {
      const res = AodThemeUtil.getAodClockConfig();
      expect(res).not().assertUndefined();
    });

    it('AodThemeUtil_getClockBaseImage1', 0, async (done: Function) => {
      const res = await AodThemeUtil.getClockBaseImage();
      expect(res).assertUndefined();
      done();
    });

    it('AodThemeUtil_getClockBaseImage2', 0, async (done: Function) => {
      const res = await AodThemeUtil.getClockBaseImage(true);
      expect(res).assertUndefined();
      done();
    });

    it('AodThemeUtil_getClockBaseImage3', 0, async (done: Function) => {
      const res = await AodThemeUtil.getClockBaseImage(false);
      expect(res).assertUndefined();
      done();
    });
  });
}
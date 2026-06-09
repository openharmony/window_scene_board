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

import { describe, beforeAll, beforeEach, afterEach, afterAll, MockKit, it, expect, Level, when } from '@ohos/hypium';
import image from '@ohos.multimedia.image';
import { slWallpaperMgr } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperManager';
import { SLWallpaperType } from '@ohos/screenlockcommon/src/main/ets/wallpaper/ScreenLockWallpaperState';
import { ContentColorListener, WallpaperModel } from '../main/ets/wallpaper/model/WallpaperModel';
import { dtWallpaperStateMgr } from '../main/ets/wallpaper/model/DesktopWallpaperModel';
import { DeviceHelper, ResourceManager, WallpaperManager, WallpaperType } from '@ohos/frameworkwrapper';

export function WallpaperModelTest() {
  describe('WallpaperModelTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {

    });
    afterAll((): void => {

    });
    afterEach((): void => {

    });

    it('WallpaperModel_test_getInstance_should_not_null', Level.LEVEL0, (): void => {
      let instance1 = WallpaperModel.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = WallpaperModel.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_null', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(undefined);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, null]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_not_null', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions ={
        editable: true,
        pixelFormat: 3,
        size: { height: width, width: height },
      };
      let wallpaper: image.PixelMap = await image.createPixelMap(color, opts);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(wallpaper);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      if (DeviceHelper.isPC()) {
        let pcWallpaper: image.PixelMap |undefined = AppStorage.get('PCDesktopWallpaperChange');
        expect(pcWallpaper).not().assertNull();
      }

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(wallpaper);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, wallpaper]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', null);
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);

      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);

      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');

      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_handleContentColorChange', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      /* 没壁纸的时候走的是浅色 */
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_should_return_string', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('WallpaperModel_getNumberById_invalid_input_number', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('WallpaperModel_getSCBInnerString_should_return_string', Level.LEVEL0, (): void => {
      let name: string = '';

      ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('WallpaperModel_setWallpaper_on_getWallpaper_null', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_on_getWallpaper_null', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_getAccountSAState_should_return_boolean', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('WallpaperModel_getCachedAppIcon_should_return_data', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('WallpaperModel_handleContentColorChange_no_wallpaper', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      done();
    })

    it('WallpaperModel_handleContentColorChange_hase_wallpaper', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_getInstance_should_not_null01', Level.LEVEL0, (): void => {
      let instance1 = WallpaperModel.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = WallpaperModel.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_null01', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(undefined);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, null]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_not_null01', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions ={
        editable: true,
        pixelFormat: 3,
        size: { height: width, width: height },
      };
      let wallpaper: image.PixelMap = await image.createPixelMap(color, opts);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(wallpaper);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      if (DeviceHelper.isPC()) {
        let pcWallpaper: image.PixelMap |undefined = AppStorage.get('PCDesktopWallpaperChange');
        expect(pcWallpaper).not().assertNull();
      }

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(wallpaper);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, wallpaper]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', null);
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);

      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);

      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');

      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_handleContentColorChange01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      /* 没壁纸的时候走的是浅色 */
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_should_return_string01', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('WallpaperModel_getNumberById_invalid_input_number01', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('WallpaperModel_getSCBInnerString_should_return_string01', Level.LEVEL0, (): void => {
      let name: string = '';

      ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('WallpaperModel_setWallpaper_on_getWallpaper_null01', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_on_getWallpaper_null01', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_getAccountSAState_should_return_boolean01', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('WallpaperModel_getCachedAppIcon_should_return_data01', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('WallpaperModel_handleContentColorChange_no_wallpaper01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      done();
    })

    it('WallpaperModel_handleContentColorChange_hase_wallpaper01', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_getInstance_should_not_null02', Level.LEVEL0, (): void => {
      let instance1 = WallpaperModel.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = WallpaperModel.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_null02', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(undefined);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, null]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_not_null02', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions ={
        editable: true,
        pixelFormat: 3,
        size: { height: width, width: height },
      };
      let wallpaper: image.PixelMap = await image.createPixelMap(color, opts);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(wallpaper);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      if (DeviceHelper.isPC()) {
        let pcWallpaper: image.PixelMap |undefined = AppStorage.get('PCDesktopWallpaperChange');
        expect(pcWallpaper).not().assertNull();
      }

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(wallpaper);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, wallpaper]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', null);
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);

      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);

      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');

      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_handleContentColorChange02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      /* 没壁纸的时候走的是浅色 */
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_should_return_string02', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('WallpaperModel_getNumberById_invalid_input_number02', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('WallpaperModel_getSCBInnerString_should_return_string02', Level.LEVEL0, (): void => {
      let name: string = '';

      ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('WallpaperModel_setWallpaper_on_getWallpaper_null02', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_on_getWallpaper_null02', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_getAccountSAState_should_return_boolean02', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('WallpaperModel_getCachedAppIcon_should_return_data02', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('WallpaperModel_handleContentColorChange_no_wallpaper02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      done();
    })

    it('WallpaperModel_handleContentColorChange_hase_wallpaper02', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_getInstance_should_not_null03', Level.LEVEL0, (): void => {
      let instance1 = WallpaperModel.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = WallpaperModel.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_null03', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(undefined);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, null]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_not_null03', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions ={
        editable: true,
        pixelFormat: 3,
        size: { height: width, width: height },
      };
      let wallpaper: image.PixelMap = await image.createPixelMap(color, opts);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(wallpaper);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      if (DeviceHelper.isPC()) {
        let pcWallpaper: image.PixelMap |undefined = AppStorage.get('PCDesktopWallpaperChange');
        expect(pcWallpaper).not().assertNull();
      }

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(wallpaper);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, wallpaper]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', null);
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);

      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);

      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');

      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_handleContentColorChange03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      /* 没壁纸的时候走的是浅色 */
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_should_return_string03', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('WallpaperModel_getNumberById_invalid_input_number03', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('WallpaperModel_getSCBInnerString_should_return_string03', Level.LEVEL0, (): void => {
      let name: string = '';

      ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('WallpaperModel_setWallpaper_on_getWallpaper_null03', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_on_getWallpaper_null03', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_getAccountSAState_should_return_boolean03', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('WallpaperModel_getCachedAppIcon_should_return_data03', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('WallpaperModel_handleContentColorChange_no_wallpaper03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      done();
    })

    it('WallpaperModel_handleContentColorChange_hase_wallpaper03', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_getInstance_should_not_null04', Level.LEVEL0, (): void => {
      let instance1 = WallpaperModel.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = WallpaperModel.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_null04', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(undefined);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, null]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_not_null04', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions ={
        editable: true,
        pixelFormat: 3,
        size: { height: width, width: height },
      };
      let wallpaper: image.PixelMap = await image.createPixelMap(color, opts);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(wallpaper);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      if (DeviceHelper.isPC()) {
        let pcWallpaper: image.PixelMap |undefined = AppStorage.get('PCDesktopWallpaperChange');
        expect(pcWallpaper).not().assertNull();
      }

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(wallpaper);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, wallpaper]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', null);
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);

      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);

      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');

      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_handleContentColorChange04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      /* 没壁纸的时候走的是浅色 */
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_should_return_string04', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('WallpaperModel_getNumberById_invalid_input_number04', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('WallpaperModel_getSCBInnerString_should_return_string04', Level.LEVEL0, (): void => {
      let name: string = '';

      ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('WallpaperModel_setWallpaper_on_getWallpaper_null04', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_on_getWallpaper_null04', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_getAccountSAState_should_return_boolean04', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('WallpaperModel_getCachedAppIcon_should_return_data04', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('WallpaperModel_handleContentColorChange_no_wallpaper04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      done();
    })

    it('WallpaperModel_handleContentColorChange_hase_wallpaper04', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_getInstance_should_not_null05', Level.LEVEL0, (): void => {
      let instance1 = WallpaperModel.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = WallpaperModel.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_null05', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(undefined);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, null]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_not_null05', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions ={
        editable: true,
        pixelFormat: 3,
        size: { height: width, width: height },
      };
      let wallpaper: image.PixelMap = await image.createPixelMap(color, opts);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(wallpaper);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      if (DeviceHelper.isPC()) {
        let pcWallpaper: image.PixelMap |undefined = AppStorage.get('PCDesktopWallpaperChange');
        expect(pcWallpaper).not().assertNull();
      }

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(wallpaper);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, wallpaper]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', null);
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);

      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);

      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');

      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_handleContentColorChange05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      /* 没壁纸的时候走的是浅色 */
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_should_return_string05', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('WallpaperModel_getNumberById_invalid_input_number05', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('WallpaperModel_getSCBInnerString_should_return_string05', Level.LEVEL0, (): void => {
      let name: string = '';

      ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('WallpaperModel_setWallpaper_on_getWallpaper_null05', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_on_getWallpaper_null05', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_getAccountSAState_should_return_boolean05', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('WallpaperModel_getCachedAppIcon_should_return_data05', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('WallpaperModel_handleContentColorChange_no_wallpaper05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      done();
    })

    it('WallpaperModel_handleContentColorChange_hase_wallpaper05', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_getInstance_should_not_null06', Level.LEVEL0, (): void => {
      let instance1 = WallpaperModel.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = WallpaperModel.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_null06', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(undefined);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, null]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_not_null06', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions ={
        editable: true,
        pixelFormat: 3,
        size: { height: width, width: height },
      };
      let wallpaper: image.PixelMap = await image.createPixelMap(color, opts);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(wallpaper);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      if (DeviceHelper.isPC()) {
        let pcWallpaper: image.PixelMap |undefined = AppStorage.get('PCDesktopWallpaperChange');
        expect(pcWallpaper).not().assertNull();
      }

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(wallpaper);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, wallpaper]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', null);
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);

      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);

      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');

      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_handleContentColorChange06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      /* 没壁纸的时候走的是浅色 */
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_should_return_string06', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('WallpaperModel_getNumberById_invalid_input_number06', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('WallpaperModel_getSCBInnerString_should_return_string06', Level.LEVEL0, (): void => {
      let name: string = '';

      ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('WallpaperModel_setWallpaper_on_getWallpaper_null06', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_on_getWallpaper_null06', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_getAccountSAState_should_return_boolean06', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('WallpaperModel_getCachedAppIcon_should_return_data06', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('WallpaperModel_handleContentColorChange_no_wallpaper06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      done();
    })

    it('WallpaperModel_handleContentColorChange_hase_wallpaper06', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_getInstance_should_not_null07', Level.LEVEL0, (): void => {
      let instance1 = WallpaperModel.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = WallpaperModel.getInstance();
      expect(instance1).assertEqual(instance2);
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_null07', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(undefined);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, null]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_not_null07', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions ={
        editable: true,
        pixelFormat: 3,
        size: { height: width, width: height },
      };
      let wallpaper: image.PixelMap = await image.createPixelMap(color, opts);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(wallpaper);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      if (DeviceHelper.isPC()) {
        let pcWallpaper: image.PixelMap |undefined = AppStorage.get('PCDesktopWallpaperChange');
        expect(pcWallpaper).not().assertNull();
      }

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(wallpaper);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, wallpaper]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper07', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', null);
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);

      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);

      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');

      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_handleContentColorChange07', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      /* 没壁纸的时候走的是浅色 */
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_should_return_string07', Level.LEVEL0, (): void => {
      let name: string = ResourceManager.getInstance().getStringByName('duplicate_add');
      expect(name).not().assertEqual('');

      name = ResourceManager.getInstance().getStringByName(null);
      expect(name).assertEqual('');
    })

    it('WallpaperModel_getNumberById_invalid_input_number07', Level.LEVEL0, (): void => {
      let res: number = ResourceManager.getInstance().getNumberById(0);
      expect(res).assertEqual(0);
    })

    it('WallpaperModel_getSCBInnerString_should_return_string07', Level.LEVEL0, (): void => {
      let name: string = '';

      ResourceManager.getInstance().getSCBInnerString('', (value: string): void => {
        name = value;
        expect(name).assertEqual('');
      });
    })

    it('WallpaperModel_setWallpaper_on_getWallpaper_null07', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_on_getWallpaper_null07', Level.LEVEL0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);
      done();
    })

    it('WallpaperModel_getAccountSAState_should_return_boolean07', Level.LEVEL0, async (done: Function) => {
      let res: boolean = await ResourceManager.getInstance().getAccountSAState();
      expect(res).assertTrue();
      done();
    })

    it('WallpaperModel_getCachedAppIcon_should_return_data07', Level.LEVEL0, (): void => {
      let iconId: number = 0;
      let bundleName: string = 'bundleTest_getCachedAppIcon';
      let moduleName: string = 'moduleTest';
      let value = 'valueTest'
      let res: string = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertNull();

      let cacheKey: string = `${iconId}${bundleName}${moduleName}`;
      ResourceManager.getInstance().setAppResourceCache(cacheKey, 'icon', value);
      res = ResourceManager.getInstance().getCachedAppIcon(iconId, bundleName, moduleName);
      expect(res).assertEqual(value);
    })

    it('WallpaperModel_handleContentColorChange_no_wallpaper07', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      done();
    })

    it('WallpaperModel_handleContentColorChange_hase_wallpaper07', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_null08', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(undefined);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(undefined);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, null]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper_on_getWallpaper_not_null08', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      let getWallPaper: Function = mocker.mockFunc(WallpaperManager.getInstance(),
        WallpaperManager.getInstance().getWallpaper);
      let width: number = 10;
      let height: number = 10;
      const color = new ArrayBuffer(width * height * 4);
      let opts: image.InitializationOptions ={
        editable: true,
        pixelFormat: 3,
        size: { height: width, width: height },
      };
      let wallpaper: image.PixelMap = await image.createPixelMap(color, opts);
      when(getWallPaper)(WallpaperType.DESKTOP).afterReturn(wallpaper);
      mocker.mockFunc(dtWallpaperStateMgr, dtWallpaperStateMgr.setDefaultsWallpaper);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      mocker.verify('showDefWallpaper', []).times(0);

      if (DeviceHelper.isPC()) {
        let pcWallpaper: image.PixelMap |undefined = AppStorage.get('PCDesktopWallpaperChange');
        expect(pcWallpaper).not().assertNull();
      }

      when(getWallPaper)(WallpaperType.SCEENLOCK).afterReturn(wallpaper);
      mocker.mockFunc(slWallpaperMgr, slWallpaperMgr.setSlWallpaperImg);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);
      mocker.verify('setSlWallpaperImg', [SLWallpaperType.TYPE_ENGINE_THEME, wallpaper]).times(0);
      done();
    });

    it('WallpaperModel_test_setWallpaper08', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', null);
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);

      await WallpaperModel.getInstance().setWallpaper(WallpaperType.DESKTOP);
      await WallpaperModel.getInstance().setWallpaper(WallpaperType.SCEENLOCK);

      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');

      expect(result).assertEqual(0);

      done();
    })

    it('WallpaperModel_test_handleContentColorChange08', Level.LEVEL0, async (done: Function) => {
      let result = 0;
      let listener: ContentColorListener = {
        onContentColorChange: (color) => {
          result = 1;
        },
        getRegion: () => {
          return [0, 0, 1, 1]
        }
      };
      WallpaperModel.getInstance().registerContentColorListener('DT-TEST', listener);
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(1);

      result = 0;
      WallpaperModel.getInstance().unRegisterContentColorListener('DT-TEST');
      await WallpaperModel.getInstance().handleContentColorChange(null);
      expect(result).assertEqual(0);

      done();
    })
  })
}
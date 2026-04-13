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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level } from '@ohos/hypium';
import { InteractiveEvent, WallpaperProxy } from '@ohos/componentanimator';
import { ThemeServiceHelper } from '../main/ets/themeassistant/ThemeServiceHelper';
import { ThemeAssistant } from '../main/ets/themeassistant/ThemeAssistant';

export function ThemeServiceHelperTest() {
  describe('ThemeServiceHelperTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('test_ThemeServiceHelper_getInstance', Level.LEVEL0, (): void => {
      let instance1 = ThemeServiceHelper.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = ThemeServiceHelper.getInstance();
      expect(instance1).assertEqual(instance2);
    })

    it('test_ThemeServiceHelper_getThemeServiceManager', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
    })

    it('test_ThemeServiceHelper_getWallpaperProxy', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
    })

    it('test_ThemeServiceHelper_getScbSwitchAnimation', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
    })

    it('test_ThemeServiceHelper_updateScbState', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_getScbState', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount', Level.LEVEL0, async (done: Function) => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getScbState', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount', Level.LEVEL0, async (done: Function) => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getThemeServiceManager01', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper01', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
    })

    it('test_ThemeServiceHelper_getWallpaperProxy01', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
    })

    it('test_ThemeServiceHelper_getScbSwitchAnimation01', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
    })

    it('test_ThemeServiceHelper_updateScbState01', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper01', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_getScbState01', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper01', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent01', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount01', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath01', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount01', Level.LEVEL0, async (done: Function) => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme01', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getScbState01', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper01', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent01', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount01', Level.LEVEL0, async (done: Function) => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath01', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount01', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme01', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getThemeServiceManager02', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper02', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
    })

    it('test_ThemeServiceHelper_getWallpaperProxy02', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
    })

    it('test_ThemeServiceHelper_getScbSwitchAnimation02', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
    })

    it('test_ThemeServiceHelper_updateScbState02', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper02', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_getScbState02', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper02', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent02', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount02', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath02', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount02', Level.LEVEL0, async (done: Function) => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme02', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getScbState02', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper02', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent02', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount02', Level.LEVEL0, async (done: Function) => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath02', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount02', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme02', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getThemeServiceManager03', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper03', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
    })

    it('test_ThemeServiceHelper_getWallpaperProxy03', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
    })

    it('test_ThemeServiceHelper_getScbSwitchAnimation03', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
    })

    it('test_ThemeServiceHelper_updateScbState03', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper03', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_getScbState03', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper03', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent03', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount03', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath03', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount03', Level.LEVEL0, async (done: Function) => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme03', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getScbState03', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper03', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent03', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount03', Level.LEVEL0, async (done: Function) => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath03', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount03', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme03', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getThemeServiceManager04', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper04', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
    })

    it('test_ThemeServiceHelper_getWallpaperProxy04', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
    })

    it('test_ThemeServiceHelper_getScbSwitchAnimation04', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
    })

    it('test_ThemeServiceHelper_updateScbState04', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper04', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_getScbState04', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper04', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent04', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount04', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath04', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount04', Level.LEVEL0, async (done: Function) => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme04', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getScbState04', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper04', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent04', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount04', Level.LEVEL0, async (done: Function) => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath04', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount04', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme04', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getThemeServiceManager05', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper05', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
    })

    it('test_ThemeServiceHelper_getWallpaperProxy05', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
    })

    it('test_ThemeServiceHelper_getScbSwitchAnimation05', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
    })

    it('test_ThemeServiceHelper_updateScbState05', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper05', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_getScbState05', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean15', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string15', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number15', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_handleInteractiveEvent_should_return_string16', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number16', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getScbState_should_return_number16', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean16', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string16', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number16', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getActiveThemePath_should_return_string16', Level.LEVEL0, (): void => {
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_updateRetryCount_should_add_number16', Level.LEVEL0, async (done: Function) => {
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_getActiveTheme_should_return_string16', Level.LEVEL0, async () => {
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_isUseStaticWallpaper_should_return_boolean16', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_getScbState_should_return_number16', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean16', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string16', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number16', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getActiveThemePath_should_return_string16', Level.LEVEL0, (): void => {
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_updateRetryCount_should_add_number16', Level.LEVEL0, async (done: Function) => {
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_getActiveTheme_should_return_string16', Level.LEVEL0, async () => {
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_getScbState_should_return_number16', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean16', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string16', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number16', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getActiveThemePath_should_return_string16', Level.LEVEL0, (): void => {
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_isUseEngineWallpaper_should_return_boolean17', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string17', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number17', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getActiveThemePath_should_return_string17', Level.LEVEL0, (): void => {
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_updateRetryCount_should_add_number17', Level.LEVEL0, async (done: Function) => {
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_getActiveTheme_should_return_string17', Level.LEVEL0, async () => {
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_getScbState_should_return_number17', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean17', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper05', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent05', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount05', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath05', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount05', Level.LEVEL0, async (done: Function) => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme05', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getScbState05', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper05', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent05', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount05', Level.LEVEL0, async (done: Function) => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath05', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount05', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme05', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_updateRetryCount_should_add_number15', Level.LEVEL0, async (done: Function) => {
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_getActiveTheme_should_return_string15', Level.LEVEL0, async () => {
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_isUseStaticWallpaper_should_return_boolean15', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_getScbState_should_return_number15', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean15', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string15', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number15', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getActiveThemePath_should_return_string15', Level.LEVEL0, (): void => {
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_updateRetryCount_should_add_number15', Level.LEVEL0, async (done: Function) => {
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_getActiveTheme_should_return_string15', Level.LEVEL0, async () => {
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_getScbState_should_return_number15', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean15', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string15', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number15', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getActiveThemePath_should_return_string15', Level.LEVEL0, (): void => {
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_updateRetryCount_should_add_number15', Level.LEVEL0, async (done: Function) => {
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_getActiveTheme_should_return_string15', Level.LEVEL0, async () => {
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_isUseStaticWallpaper_should_return_boolean15', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_getScbState_should_return_number15', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean15', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string15', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number15', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getActiveThemePath_should_return_string15', Level.LEVEL0, (): void => {
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_updateRetryCount_should_add_number15', Level.LEVEL0, async (done: Function) => {
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_getActiveTheme_should_return_string15', Level.LEVEL0, async () => {
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_getScbState_should_return_number15', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean15', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string15', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number15', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getActiveThemePath_should_return_string15', Level.LEVEL0, (): void => {
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_updateRetryCount_should_add_number15', Level.LEVEL0, async (done: Function) => {
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_getActiveTheme_should_return_string15', Level.LEVEL0, async () => {
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_isUseStaticWallpaper_should_return_boolean15', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_getScbState_should_return_number15', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_isUseEngineWallpaper_should_return_boolean15', Level.LEVEL0, (): void => {
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_handleInteractiveEvent_should_return_string15', Level.LEVEL0, async (done: Function) => {
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_getRetryCount_should_return_number15', Level.LEVEL0, async (done: Function) => {
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_getActiveThemePath_should_return_string15', Level.LEVEL0, (): void => {
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_updateRetryCount_should_add_number15', Level.LEVEL0, async (done: Function) => {
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_getActiveTheme_should_return_string15', Level.LEVEL0, async () => {
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_getScbState_should_return_number15', Level.LEVEL0, (): void => {
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_getThemeServiceManager06', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper06', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
    })

    it('test_ThemeServiceHelper_getWallpaperProxy06', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
    })

    it('test_ThemeServiceHelper_getScbSwitchAnimation06', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
    })

    it('test_ThemeServiceHelper_updateScbState06', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper06', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_getScbState06', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper06', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent06', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount06', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath06', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount06', Level.LEVEL0, async (done: Function) => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme06', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getScbState06', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper06', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent06', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount06', Level.LEVEL0, async (done: Function) => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath06', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount06', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme06', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getThemeServiceManager07', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper07', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
    })

    it('test_ThemeServiceHelper_getWallpaperProxy07', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
    })

    it('test_ThemeServiceHelper_getScbSwitchAnimation07', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
    })

    it('test_ThemeServiceHelper_updateScbState07', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper07', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_getScbState07', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper07', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent07', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount07', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath07', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount07', Level.LEVEL0, async (done: Function) => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme07', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getScbState07', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper07', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent07', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount07', Level.LEVEL0, async (done: Function) => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath07', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount07', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme07', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getThemeServiceManager08', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper08', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
    })

    it('test_ThemeServiceHelper_getWallpaperProxy08', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
    })

    it('test_ThemeServiceHelper_getScbSwitchAnimation08', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
    })

    it('test_ThemeServiceHelper_updateScbState08', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
    })

    it('test_ThemeServiceHelper_isUseStaticWallpaper08', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseStaticWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_getScbState08', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper08', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent08', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount08', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath08', Level.LEVEL0, (): void => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount08', Level.LEVEL0, async (done: Function) => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme08', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })

    it('test_ThemeServiceHelper_getScbState08', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let scbState: number = ThemeAssistant.getInstance().getScbState();
      expect(scbState).assertEqual(0);
    })

    it('test_ThemeServiceHelper_isUseEngineWallpaper08', Level.LEVEL0, (): void => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let isUseStatic: boolean = ThemeAssistant.getInstance().isUseEngineWallpaper();
      expect(isUseStatic).assertTrue();
    })

    it('test_ThemeServiceHelper_handleInteractiveEvent08', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let result = 0;
      instance.updateScbState(1,2,()=>{
        result = 1;
      });
      expect(result).assertEqual(1);
      let event: InteractiveEvent = new InteractiveEvent();
      await ThemeAssistant.getInstance().handleInteractiveEvent(event);
      expect(event).not().assertNull();
      done();
    })

    it('test_ThemeServiceHelper_getRetryCount08', Level.LEVEL0, async (done: Function) => {
      let themeServiceHelper: ThemeServiceHelper = ThemeServiceHelper.getInstance();
      expect(typeof themeServiceHelper).assertEqual('ThemeServiceHelper');
      let retryCount: number = await ThemeAssistant.getInstance().getRetryCount();
      expect(retryCount).assertEqual(0);
      done();
    })

    it('test_ThemeServiceHelper_getActiveThemePath08', Level.LEVEL0, (): void => {
      let isUseStaticWallpaper: boolean = ThemeServiceHelper.getInstance().isUseStaticWallpaper();
      expect(typeof isUseStaticWallpaper).assertEqual(`boolean`);
      let res: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).not().assertNull();
    })

    it('test_ThemeServiceHelper_updateRetryCount08', Level.LEVEL0, async (done: Function) => {
      let instance = ThemeServiceHelper.getInstance();
      let wallpaperProxy: WallpaperProxy = instance.getWallpaperProxy();
      expect(typeof wallpaperProxy).assertEqual('WallpaperProxy');
      let preRetryCount: number = ThemeAssistant.getInstance().getRetryCount();
      await ThemeAssistant.getInstance().updateRetryCount();
      expect(ThemeAssistant.getInstance().getRetryCount()).assertEqual(preRetryCount);
      done();
    })

    it('test_ThemeServiceHelper_getActiveTheme08', Level.LEVEL0, async () => {
      let instance = ThemeServiceHelper.getInstance();
      let animateParam: AnimateParam | undefined = instance.getScbSwitchAnimation();
      expect(typeof animateParam).assertEqual('AnimateParam');
      let res: number = ThemeAssistant.getInstance().getRetryCount();
      expect(res).assertNull();

      let value: string = ThemeAssistant.getInstance().getActiveThemePath();
      expect(res).assertEqual(value);
    })
  })
}
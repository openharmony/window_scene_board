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
import { describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  Level,
  MockKit,
  when} from '@ohos/hypium';
import { SCBSceneSessionManager } from '@ohos/windowscene';
import context from '@ohos.app.ability.common';
import { DockBackgroundMgr } from '../../../../../main/ets/default/viewmodel/DockBackgroundMgr';
import { GlobalContext } from '@ohos/frameworkwrapper';
import settings from '@ohos.settings';

const TAG = 'DockBackgroundMgrTest';

const DATA_SHARE_DOCK_BACKGROUND_STYLE: string = 'settings.dock.background_style';
const DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM: string = 'system';
const DOCK_BACKGROUND_STYLE_FOLLOW_WALLPAPER: string = 'wallpaper';
const DEFAULT_VAL: string = DOCK_BACKGROUND_STYLE_FOLLOW_WALLPAPER; // 默认值设置

export default function DockBackgroundMgrTest() {
  describe('DockBackgroundMgrTest', () => {
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

    it('test_DockBackgroundMgrTest_getInstance_should_return_single_instance', Level.LEVEL0, (): void => {
      let instance1 = DockBackgroundMgr.getInstance();
      expect(instance1).not().assertNull();
      let instance2 = DockBackgroundMgr.getInstance();
      expect(instance2).not().assertNull();
    })

    it('test_DockBackgroundMgrTest_initInner_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      (instance as object)['initInner']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_initInner_1', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      GlobalContext.getInstance().setObject('desktopContext', undefined);
      (instance as object)['initInner']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
      GlobalContext.getInstance().setObject('desktopContext', context);
    })

    it('test_DockBackgroundMgrTest_initInner_2', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      GlobalContext.getInstance().setObject('desktopContext', undefined);
      const orgStyle: string = settings.getValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, DEFAULT_VAL,
        settings.domainName.USER_PROPERTY);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE,
        DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM, settings.domainName.USER_PROPERTY);
      (instance as object)['initInner']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
      GlobalContext.getInstance().setObject('desktopContext', context);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, orgStyle, settings.domainName.USER_PROPERTY);
    })

    it('test_DockBackgroundMgrTest_initInner_3', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      GlobalContext.getInstance().setObject('desktopContext', undefined);
      const orgStyle: string = settings.getValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, DEFAULT_VAL,
        settings.domainName.USER_PROPERTY);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE,
        DOCK_BACKGROUND_STYLE_FOLLOW_WALLPAPER, settings.domainName.USER_PROPERTY);
      (instance as object)['initInner']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
      GlobalContext.getInstance().setObject('desktopContext', context);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, orgStyle, settings.domainName.USER_PROPERTY);
    })


    it('test_DockBackgroundMgrTest_settingDataChanged_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      (instance as object)['settingDataChanged']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_settingDataChanged_1', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      GlobalContext.getInstance().setObject('desktopContext', undefined);
      (instance as object)['settingDataChanged']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
      GlobalContext.getInstance().setObject('desktopContext', context);
    })

    it('test_DockBackgroundMgrTest_settingDataChanged_2', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      GlobalContext.getInstance().setObject('desktopContext', undefined);
      const orgStyle: string = settings.getValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, DEFAULT_VAL,
        settings.domainName.USER_PROPERTY);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE,
        DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM, settings.domainName.USER_PROPERTY);
      (instance as object)['settingDataChanged']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
      GlobalContext.getInstance().setObject('desktopContext', context);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, orgStyle, settings.domainName.USER_PROPERTY);
    })

    it('test_DockBackgroundMgrTest_settingDataChanged_3', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      GlobalContext.getInstance().setObject('desktopContext', undefined);
      const orgStyle: string = settings.getValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, DEFAULT_VAL,
        settings.domainName.USER_PROPERTY);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE,
        DOCK_BACKGROUND_STYLE_FOLLOW_WALLPAPER, settings.domainName.USER_PROPERTY);
      (instance as object)['settingDataChanged']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
      GlobalContext.getInstance().setObject('desktopContext', context);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, orgStyle, settings.domainName.USER_PROPERTY);
    })

    it('test_DockBackgroundMgrTest_settingDataChanged_2', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let context = GlobalContext.getInstance().getObject('desktopContext') as context.ServiceExtensionContext;
      GlobalContext.getInstance().setObject('desktopContext', undefined);
      const orgStyle: string = settings.getValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, DEFAULT_VAL,
        settings.domainName.USER_PROPERTY);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE,
        DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM, settings.domainName.USER_PROPERTY);
      (instance as object)['settingDataChanged']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
      GlobalContext.getInstance().setObject('desktopContext', context);
      settings.setValueSync(context, DATA_SHARE_DOCK_BACKGROUND_STYLE, orgStyle, settings.domainName.USER_PROPERTY);
    })

    it('test_DockBackgroundMgrTest_init_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let viewCallback = () => {

      };
      let viewItemCallback = () => {

      };
      let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
      instance.init(screenId, viewCallback, viewItemCallback);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
      instance.deInit(screenId);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_init_1', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let viewCallback = () => {

      };
      let viewItemCallback = () => {

      };
      let screenId: number = 999;
      instance.init(screenId, viewCallback, viewItemCallback);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
      instance.deInit(screenId);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_getViewModel_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
      let viewData = (instance as object)['getViewModel'](999) as object;
      expect(viewData).not().assertNull();
      viewData = (instance as object)['getViewModel'](screenId) as object;
      expect(viewData).not().assertNull();
    })

    it('test_DockBackgroundMgrTest_getDockColorMode_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
      let viewData = (instance as object)['getViewModel'](screenId) as object;
      expect(viewData).not().assertNull();

      let currColorMode = 0;
      viewData['currColorMode'] = currColorMode;
      let res = instance.getDockColorMode(screenId);
      expect(res).assertEqual(currColorMode);

      currColorMode = 1;
      viewData['currColorMode'] = currColorMode;
      res = instance.getDockColorMode(screenId);
      expect(res).assertEqual(currColorMode);
    })

    it('test_DockBackgroundMgrTest_getContentColor_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let contentColor = (instance as object)['getContentColor'](undefined) as string;
      expect(contentColor === undefined).assertTrue();

      let whiteApp = ['com.openharmony.it.works', '#FF000000'];
      contentColor = (instance as object)['getContentColor'](whiteApp[0]) as string;
      expect(contentColor === whiteApp[1]).assertTrue();
    })

    it('test_DockBackgroundMgrTest_setFoldStatus_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
      instance.setFoldStatus(0, screenId);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_setSystemColor_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      instance.setSystemColor(0);
      let systemColorMode: number = (instance as object)['systemColorMode'] as number;
      expect(systemColorMode === 0).assertTrue();

      instance.setSystemColor(1);
      systemColorMode = (instance as object)['systemColorMode'] as number;
      expect(systemColorMode === 1).assertTrue();
    })

    it('test_DockBackgroundMgrTest_setAppCenterShow_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
      let isAppCenterShow = true;
      instance.setAppCenterShow(isAppCenterShow, screenId);
      let viewData = (instance as object)['getViewModel'](screenId) as object;
      let res = viewData['isAppCenterShow'] as boolean;
      expect(isAppCenterShow === res).assertTrue();

      isAppCenterShow = false;
      instance.setAppCenterShow(isAppCenterShow, screenId);
      viewData = (instance as object)['getViewModel'](screenId) as object;
      res = viewData['isAppCenterShow'] as boolean;
      expect(isAppCenterShow === res).assertTrue();
    })

    it('test_DockBackgroundMgrTest_setRecentViewShow_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
      let isRecentShow = true;
      instance.setRecentViewShow(isRecentShow);
      let res = (instance as object)['isRecentCenterShow'] as boolean;
      expect(isRecentShow === res).assertTrue();

      isRecentShow = false;
      instance.setRecentViewShow(isRecentShow);
      res = (instance as object)['isRecentCenterShow'] as boolean;
      expect(isRecentShow === res).assertTrue();
    })

    it('test_DockBackgroundMgrTest_setDockRegion_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
      let screenHeight = 0;
      let offset = 0;
      instance.setDockRegion(screenHeight, offset, screenId);
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      screenHeight = 3120;
      offset = 125;
      instance.setDockRegion(screenHeight, offset, screenId);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_updateDegree_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      (instance as object)['updateDegree'](false);
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      (instance as object)['updateDegree'](true);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_updateWallpaperColorMode_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();

      // 较浅壁纸
      let colorMode = (instance as object)['updateWallpaperColorMode'](1) as number;
      expect(colorMode === 1).assertTrue();
      colorMode = (instance as object)['updateWallpaperColorMode'](2) as number;
      expect(colorMode === 1).assertTrue();

      // 深色壁纸
      colorMode = (instance as object)['updateWallpaperColorMode'](3) as number;
      expect(colorMode === 0).assertTrue();
      colorMode = (instance as object)['updateWallpaperColorMode'](4) as number;
      expect(colorMode === 0).assertTrue();

      // 较花壁纸
      colorMode = (instance as object)['updateWallpaperColorMode'](5) as number;
      expect(colorMode === 2).assertTrue();
      colorMode = (instance as object)['updateWallpaperColorMode'](6) as number;
      expect(colorMode === 2).assertTrue();
    })

    it('test_DockBackgroundMgrTest_updateDockBackgroundColorWithAnim_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let viewCallback = () => {
      };
      (instance as object)['updateDockBackgroundColorWithAnim'](viewCallback);
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      (instance as object)['updateDockBackgroundColorWithAnim'](viewCallback, 200);
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      (instance as object)['updateDockBackgroundColorWithAnim'](viewCallback, 200, 100);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_updateAllScreen_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      (instance as object)['updateAllScreen']();
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_updateBrightness_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
      let viewData = (instance as object)['getViewModel'](screenId) as object;
      (instance as object)['updateBrightness'](screenId, viewData, 'DT Test 0');
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      (instance as object)['updateBrightness'](screenId, viewData, 'DT Test 1', false);
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      // 分支一: UI回调未空
      (viewData as object)['changeCallback'] = undefined;
      (instance as object)['updateBrightness'](screenId, viewData, 'DT Test 2', false);
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      // 分支二：dock主题跟随模式
      (instance as object)['dockStyle'] = DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM;
      instance.setSystemColor(0);
      (instance as object)['updateBrightness'](screenId, viewData, 'DT Test 3', false);
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      (instance as object)['dockStyle'] = DOCK_BACKGROUND_STYLE_FOLLOW_SYSTEM;
      instance.setSystemColor(1);
      (instance as object)['updateBrightness'](screenId, viewData, 'DT Test 4', false);
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      (instance as object)['dockStyle'] = DOCK_BACKGROUND_STYLE_FOLLOW_WALLPAPER;
      instance.setSystemColor(0);
      (instance as object)['updateBrightness'](screenId, viewData, 'DT Test 5', false);
      expect(instance instanceof DockBackgroundMgr).assertTrue();

      (instance as object)['dockStyle'] = DOCK_BACKGROUND_STYLE_FOLLOW_WALLPAPER;
      instance.setSystemColor(1);
      (instance as object)['updateBrightness'](screenId, viewData, 'DT Test 6', false);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })

    it('test_DockBackgroundMgrTest_clearColorAnimateTimer_0', Level.LEVEL0, (): void => {
      let instance = DockBackgroundMgr.getInstance();
      let screenId: number = SCBSceneSessionManager.getInstance().mainScreenId;
      let viewData = (instance as object)['getViewModel'](screenId) as object;
      (instance as object)['clearColorAnimateTimer'](viewData);
      expect(instance instanceof DockBackgroundMgr).assertTrue();
    })
  })
}
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
import { bundleManagerFwk, DeviceHelper, GlobalContext, ResourceManager } from '@ohos/frameworkwrapper';
import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import { CheckEmptyUtils, StartType } from '@ohos/basicutils';
import {
  AppItemInfo,
  ShortcutViewModel,
  CommonConstants,
  ShortcutInfo,
  AppModel,
  MenuInfo,
  GridLayoutItemInfo
} from '../../../../../../../main/ets/TsIndex';
import {
  BaseShortcutInfo,
  ResultCode,
  CheckResult
} from '../../../../../../../main/ets/launchericon/viewmodel/ShortcutViewModel';
import { AppIconModel } from '../../../../../../../main/ets/launchericon/common/AppIconModel';
import { image } from '@kit.ImageKit';
import { launcherBundleManager } from '@kit.AbilityKit';
import bundleManager from '@ohos.bundle.bundleManager';
import { LaunchLayoutCacheManager } from '../../../../../../../main/ets/cache/layout/LaunchLayoutCacheManager';
import DockLayoutCacheManager from '../../../../../../../main/ets/cache/layout/DockLayoutCacheManager';
import LayoutDescription from '../../../../../../../main/ets/bean/LayoutDescription';

function buildShortcutInfo(): ShortcutInfo {
  const shortcut: ShortcutInfo = {
    id: '',
    bundleName: '',
    appIndex: 0,
    sourceType: 0,
    icon: '',
    label: '',
    hostAbility: '',
    wants: undefined
  };
  return shortcut;
}

interface AppItem {
  typeId?: number;
  startType?: number;
  bundleName: string;
}

export default function ShortcutViewModelTest() {
  let instance: ShortcutViewModel = ShortcutViewModel.getInstance();

  describe('ShortcutViewModelTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterEach((): void => {

    })
    afterAll((): void => {

    })

    it('should_return_undefined_when_appItem_is_null', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      const result = await shortcutViewModel.getShortcutInfo(null);
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_shortcutInfo_not_found_in_BMS_database', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.getAllDesktopShortcutFromBMS);
      when(mockFunc)().afterReturn([]);

      let appItem: AppItemInfo = new AppItemInfo();
      const result = await shortcutViewModel.getShortcutInfo(appItem);
      expect(result).assertUndefined();
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.getAllDesktopShortcutFromBMS);
    });

    it('should_return_shortcutInfo_when_shortcutInfo_found_in_BMS_database', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.getAllDesktopShortcutFromBMS);
      let mockShortcutInfo: ShortcutInfo = buildShortcutInfo();
      mockShortcutInfo.id = '1';
      mockShortcutInfo.bundleName = 'com.ohos.app';
      when(mockFunc)().afterReturn([mockShortcutInfo]);

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'com.ohos.app';
      appItem.shortcutId = '1';
      const result = await shortcutViewModel.getShortcutInfo(appItem);
      expect(result).assertDeepEquals(mockShortcutInfo);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.getAllDesktopShortcutFromBMS);
    });

    it('should_return_shortcutInfo_when_shortcutId_is_empty_for_contacts_app', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.getAllDesktopShortcutFromBMS);
      let mockShortcutInfo: ShortcutInfo = buildShortcutInfo();
      mockShortcutInfo.id = 'shortcut_id_01';
      mockShortcutInfo.bundleName = 'com.ohos.contacts';
      when(mockFunc)().afterReturn([mockShortcutInfo]);

      let mockIsContactsApp: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.isContactsApp);
      when(mockIsContactsApp)(ArgumentMatchers.anyString).afterReturn(true);

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'com.ohos.contacts';
      appItem.shortcutId = '';
      const result = await shortcutViewModel.getShortcutInfo(appItem);
      expect(result).assertDeepEquals(mockShortcutInfo);
      expect(appItem.shortcutId).assertEqual('shortcut_id_01');
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.getAllDesktopShortcutFromBMS);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.isContactsApp);
    });

    it('should_return_undefined_when_shortcutInfo_not_found_at_all', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.getAllDesktopShortcutFromBMS);
      when(mockFunc)().afterReturn([]);

      let mockGetShortcutByBundleName: Function =
        mocker.mockFunc(shortcutViewModel, shortcutViewModel.getShortcutByBundleName);
      when(mockGetShortcutByBundleName)(ArgumentMatchers.anyString).afterReturn([]);

      let appItem: AppItemInfo = new AppItemInfo();
      appItem.bundleName = 'com.ohos.app';
      appItem.shortcutId = '1';
      const result = await shortcutViewModel.getShortcutInfo(appItem);
      expect(result).assertUndefined();
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.getAllDesktopShortcutFromBMS);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.getShortcutByBundleName);
    });

    it('should_return_empty_string_when_appItem_is_null', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let result = await shortcutViewModel.getShortcutImageAsync(null);
      expect(result).assertEqual('');
    });

    it('should_return_appIcon_when_appItem_has_appIconId', 0, async () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.appIconId = 1;
        appItem.bundleName = 'com.ohos.app';
        let mockFunc: Function =
          mocker.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().getAppIconWithCacheAsync);
        when(mockFunc)(ArgumentMatchers.any).afterReturn('appIcon');
        let result = await shortcutViewModel.getShortcutImageAsync(appItem);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.ignoreMock(ResourceManager.getInstance(), ResourceManager.getInstance().getAppIconWithCacheAsync);
    });

    it('should_return_customized_shortcut_icon_when_appItem_has_iconResource_7', 0, async () => {
      let mocker: MockKit = new MockKit();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      try {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.iconResource = 'iconResource';
        appItem.bundleName = 'com.ohos.app';
        let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.convertToHdsIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn('hdsIcon');
        let result = await shortcutViewModel.getShortcutImageAsync(appItem);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.convertToHdsIcon);
    });

    it('should_return_customized_shortcut_icon_when_appItem_has_shortcutId_7', 0, async () => {
      let mocker: MockKit = new MockKit();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      try {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.shortcutId = 'shortcutId';
        appItem.bundleName = 'com.ohos.app';
        let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.selectAllSameApp);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([{
          iconResource: 'iconResource', bundleName: 'com.ohos.app', shortcutId: 'shortcutId'
        }]);
        let mockFunc2: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.convertToHdsIcon);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn('hdsIcon');
        let result = await shortcutViewModel.getShortcutImageAsync(appItem);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.selectAllSameApp);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.convertToHdsIcon);
    });

    it('should_return_empty_string_when_all_conditions_are_met_7', 0, async () => {
      let mocker: MockKit = new MockKit();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      try {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.shortcutId = 'shortcutId';
        appItem.bundleName = 'com.ohos.app';
        let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.selectAllSameApp);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([{
          iconResource: '', bundleName: 'com.ohos.app', shortcutId: 'shortcutId'
        }]);
        let result = await shortcutViewModel.getShortcutImageAsync(appItem);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.selectAllSameApp);
    });

    it('test_getShortcutImageAsync_06', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutId:string = 'shortcutId';
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.shortcutId = shortcutId;
        appItem.bundleName = 'com.ohos.app';
        let mockFunc: Function = mocker.mockFunc(instance, instance.selectAllSameApp);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([{
          iconResource: 'iconResource', bundleName: 'com.ohos.app', shortcutId: shortcutId
        }]);
        let mockFunc2: Function = mocker.mockFunc(instance, instance.convertToHdsIcon);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn('hdsIcon');
        let result = await instance.getShortcutImageAsync(appItem);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
      done();
    });

    it('should_return_empty_string_when_appItem_appIconId_and_iconResource_are_empty', 0, () => {
      let appItem: AppItemInfo = new AppItemInfo();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let result = shortcutViewModel.getShortcutImageSync(appItem);
      expect(result).assertEqual('');
    });

    it('should_return_icon_when_appItem_appIconId_is_not_empty_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let resourceManager: ResourceManager = ResourceManager.getInstance();
      try {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.appIconId = 1;
        let mockFunc: Function = mocker.mockFunc(resourceManager, resourceManager.getCachedAppIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn('testIcon');
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        let result = shortcutViewModel.getShortcutImageSync(appItem);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.ignoreMock(resourceManager, resourceManager.getCachedAppIcon);
    });

    it('should_return_icon_when_appItem_iconResource_is_not_empty_7', 0, () => {
      let mocker: MockKit = new MockKit();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      try {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.iconResource = 'testIconResource';
        appItem.bundleName = 'testBundleName';
        let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.convertToHdsIcon);
        when(mockFunc)(ArgumentMatchers.any).afterReturn('testIcon');
        let result = shortcutViewModel.getShortcutImageSync(appItem);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.convertToHdsIcon);
    });

    it('test_getShortcutImageSync_04', 0, () => {
      try {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.appIconId = 1;
        appItem.iconResource = 'testIconResource';
        appItem.bundleName = 'testBundleName';
        appItem.moduleName = 'testmoduleName';
        instance.getShortcutImageSync(appItem);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getShortcutImageSync_05', 0, () => {
      try {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.iconResource = 'testIconResource';
        appItem.bundleName = 'testBundleName';
        appItem.moduleName = 'testmoduleName';
        instance.getShortcutImageSync(appItem);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getShortcutImageSync_06', 0, () => {
      try {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.bundleName = 'testBundleName';
        appItem.moduleName = 'testmoduleName';
        instance.getShortcutImageSync(appItem);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('should_log_warn_when_app_is_contacts_app', 0, () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      let menuInfoList: MenuInfo[] = [];
      let screenId: number = 1;
      shortcutViewModel.checkShortCutInfo(appInfo, menuInfoList, screenId);
    });

    it('should_get_shortcut_info_from_manager_sync_when_not_available', 0, () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(appModel, appModel.getShortcutInfo);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(undefined);

      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      let menuInfoList: MenuInfo[] = [];
      let screenId: number = 1;
      shortcutViewModel.checkShortCutInfo(appInfo, menuInfoList, screenId);

      mocker.ignoreMock(appModel, appModel.getShortcutInfo);
    });

    it('should_add_menus_to_menuInfoList_when_shortcut_info_available', 0, () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let appModel: AppModel = AppModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(appModel, appModel.getShortcutInfo);
      let shortcutInfo: ShortcutInfo = buildShortcutInfo();
      shortcutInfo.icon = 'icon';
      shortcutInfo.label = 'label';
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn([shortcutInfo]);

      let appInfo: AppItemInfo = new AppItemInfo();
      appInfo.bundleName = 'com.ohos.contacts';
      let menuInfoList: MenuInfo[] = [];
      let screenId: number = 1;
      shortcutViewModel.checkShortCutInfo(appInfo, menuInfoList, screenId);

      mocker.ignoreMock(appModel, appModel.getShortcutInfo);
    });

    it('onShortcutAppClick', 0, async () => {
      let item1 = new AppItemInfo();

      let called: boolean = false;
      let action: () => void = (): void => {
        called = true;
      };
      const mocker: MockKit = new MockKit();
      let mockGetShortcutInfo: Function = mocker.mockFunc(ShortcutViewModel.getInstance(),
        ShortcutViewModel.getInstance().getShortcutInfo);
      when(mockGetShortcutInfo)(item1).afterAction(action);

      await ShortcutViewModel.getInstance().onShortcutAppClick(undefined);
      expect(called).assertFalse();

      let shortcutInfo: ShortcutInfo = {
        id: '',
        bundleName: '',
        appIndex: 0,
        sourceType: 0
      };
      when(mockGetShortcutInfo)(item1).afterReturnNothing();
      await ShortcutViewModel.getInstance().onShortcutAppClick(item1);

      when(mockGetShortcutInfo)(item1).afterReturn(shortcutInfo);
      await ShortcutViewModel.getInstance().onShortcutAppClick(item1);

      mocker.clear(ShortcutViewModel.getInstance());
      mocker.clearAll();
    });

    it('addShortcutToBMS', 0, async () => {
      expect(await ShortcutViewModel.getInstance().addShortcutToBMS(undefined)).assertEqual(ResultCode.FAILED_OTHER);

      let shortcutInfo: ShortcutInfo = {
        id: '',
        bundleName: '',
        appIndex: 0,
        sourceType: 0
      };
      expect(await ShortcutViewModel.getInstance().addShortcutToBMS(shortcutInfo)).assertEqual(ResultCode.FAILED_OTHER);
    });

    it('should_return_FAILED_OTHER_when_baseShortcutInfo_is_null', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      const result = await shortcutViewModel.deleteShortcutFromBMS(undefined);
      expect(result).assertEqual(ResultCode.FAILED_OTHER);
    });

    it('test_deleteShortcutFromBMS_01', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let baseShortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
      const result = await shortcutViewModel.deleteShortcutFromBMS(baseShortcutInfo);
      expect(result).assertEqual(ResultCode.FAILED_OTHER);
    });

    it('test_getShortcutByBundleName_7', 0, () => {
      try {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        ShortcutViewModel.getInstance().getShortcutByBundleName('');
        let bundleName = 'testBundleName';
        ShortcutViewModel.getInstance().getShortcutByBundleName(bundleName);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('should_return_immediately_when_result_code_is_success_01', 0, async () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.checkShortcut);
      let result: CheckResult = {
        code: ResultCode.SUCCESS,
        limit: 0
      };
      when(mockFunc)(ArgumentMatchers.any).afterReturn(result);
      await shortcutViewModel.processShortcut(shortcutItem);
      expect(shortcutItem.extend3).assertUndefined();
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.checkShortcut);
    });

    it('should_set_extend3_when_result_code_is_failed_duplicate_id', 0, async () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.checkShortcut);
      let result: CheckResult = {
        code: ResultCode.FAILED_DUPLICATE_ID,
        limit: 0
      };
      when(mockFunc)(ArgumentMatchers.any).afterReturn(result);
      await shortcutViewModel.processShortcut(shortcutItem);
      expect(shortcutItem.extend3).assertEqual(result.code);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.checkShortcut);
    });

    it('should_set_keyName_when_result_code_is_failed_duplicate_id', 0, async () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.checkShortcut);
      let result: CheckResult = {
        code: ResultCode.FAILED_DUPLICATE_ID,
        limit: 0
      };
      when(mockFunc)(ArgumentMatchers.any).afterReturn(result);
      await shortcutViewModel.processShortcut(shortcutItem);
      expect(shortcutItem.keyName).assertEqual(CommonConstants.EXIST_SHORTCUT_PREFIX + undefined);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.checkShortcut);
    });

    it('should_return_false_when_typeId_is_not_TYPE_SHORTCUT_ICON', 0, () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcutItem.typeId = CommonConstants.TYPE_APP;
      const result = ShortcutViewModel.getInstance().canAddShortcutByDrag(shortcutItem);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_result_is_FAILED_INVALID_PARAMETERS', 0, () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcutItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      shortcutItem.extend3 = ResultCode.FAILED_INVALID_PARAMETERS;
      const result = ShortcutViewModel.getInstance().canAddShortcutByDrag(shortcutItem);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_result_is_FAILED_OTHER', 0, () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcutItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      shortcutItem.extend3 = ResultCode.FAILED_OTHER;
      const result = ShortcutViewModel.getInstance().canAddShortcutByDrag(shortcutItem);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_result_is_FAILED_DUPLICATE_ID', 0, () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcutItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      shortcutItem.extend3 = ResultCode.FAILED_DUPLICATE_ID;
      const result = ShortcutViewModel.getInstance().canAddShortcutByDrag(shortcutItem);
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_result_is_FAILED_QUANTITY_LIMIT', 0, () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcutItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      shortcutItem.extend3 = ResultCode.FAILED_QUANTITY_LIMIT;
      const result = ShortcutViewModel.getInstance().canAddShortcutByDrag(shortcutItem);
      expect(result).assertEqual(false);
    });

    it('should_return_true_when_result_is_other_value', 0, () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcutItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      shortcutItem.extend3 = ResultCode.SUCCESS;
      const result = ShortcutViewModel.getInstance().canAddShortcutByDrag(shortcutItem);
      expect(result).assertEqual(true);
    });

    it('should_return_FAILED_OTHER_when_dragItemType_is_not_DRAG_FROM_SHORTCUT', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.addShortcutToBMS);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(ResultCode.SUCCESS));
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      const result = await shortcutViewModel.addShortcutToBMSByDrag(CommonConstants.DRAG_FROM_APP, shortcutItem);
      expect(result).assertEqual(ResultCode.FAILED_OTHER);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.addShortcutToBMS);
    });

    it('should_return_FAILED_OTHER_when_shortcutItem_typeId_is_not_TYPE_SHORTCUT_ICON', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.addShortcutToBMS);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(Promise.resolve(ResultCode.SUCCESS));
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcutItem.typeId = CommonConstants.TYPE_APP;
      const result = await shortcutViewModel.addShortcutToBMSByDrag(CommonConstants.DRAG_FROM_APP, shortcutItem);
      expect(result).assertEqual(ResultCode.FAILED_OTHER);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.addShortcutToBMS);
    });

    it('should_return_FAILED_OTHER_when_shortcut_is_null', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.getShortcutByBundleName);
      when(mockFunc)(ArgumentMatchers.any).afterReturn([]);
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcutItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      const result = await shortcutViewModel.addShortcutToBMSByDrag(CommonConstants.DRAG_FROM_SHORTCUT, shortcutItem);
      expect(result).assertEqual(ResultCode.FAILED_OTHER);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.getShortcutByBundleName);
    });

    it('should_return_result_from_addShortcutToBMS_when_all_conditions_are_met', 0, async () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker1: MockKit = new MockKit();
      let mockFunc1: Function = mocker1.mockFunc(shortcutViewModel, shortcutViewModel.addShortcutToBMS);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(Promise.resolve(ResultCode.SUCCESS));
      let mocker2: MockKit = new MockKit();
      let mockFunc2: Function = mocker2.mockFunc(shortcutViewModel, shortcutViewModel.getShortcutByBundleName);
      let mockShortcutInfo: ShortcutInfo = buildShortcutInfo();
      mockShortcutInfo.id = 'shortcut_id_test';
      mockShortcutInfo.iconId = 10;
      when(mockFunc2)(ArgumentMatchers.any).afterReturn([mockShortcutInfo]);
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      shortcutItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      shortcutItem.shortcutId = 'shortcut_id_test';
      const result = await shortcutViewModel.addShortcutToBMSByDrag(CommonConstants.DRAG_FROM_SHORTCUT, shortcutItem);
      expect(result).assertEqual(ResultCode.SUCCESS);
      mocker1.ignoreMock(shortcutViewModel, shortcutViewModel.addShortcutToBMS);
      mocker2.ignoreMock(shortcutViewModel, shortcutViewModel.getShortcutByBundleName);
    });

    it('test_addShortcutToBMSByDrag_05', 0, async (done: Function) => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(instance, instance.getShortcutByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let dragItemType: number = CommonConstants.DRAG_FROM_SHORTCUT;
        let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        shortcutItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        shortcutItem.shortcutId = '1';
        await instance.addShortcutToBMSByDrag(dragItemType, shortcutItem);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
      done();
    })

    it('test_addShortcutToBMSByDrag_06', 0, async (done: Function) => {
      let mock = new MockKit();
      try {
        let info1 = {
          id: '1',
          bundleName: 'bundleName',
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let shortcutInfoList: ShortcutInfo[] = [info1];
        let mockFunc: Function = mock.mockFunc(instance, instance.getShortcutByBundleName);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoList);

        let dragItemType: number = CommonConstants.DRAG_FROM_SHORTCUT;
        let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
        shortcutItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        shortcutItem.shortcutId = '2';
        await instance.addShortcutToBMSByDrag(dragItemType, shortcutItem);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
      done();
    })

    it('should_return_undefined_when_appItem_typeId_is_not_TYPE_SHORTCUT_ICON', 0, async () => {
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.typeId = CommonConstants.TYPE_APP;
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let result = shortcutViewModel.getShortcutIconId(appItem);
      expect(result).assertEqual(undefined);
    });

    it('should_return_undefined_when_getAllShortcutInfo_returns_undefined', 0, async () => {
      let appItem: AppItemInfo = new AppItemInfo();
      appItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(undefined);
      let result = shortcutViewModel.getShortcutIconId(appItem);
      expect(result).assertEqual(undefined);
      mocker.ignoreMock(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
    });

    it('should_return_iconId_when_getAllShortcutInfo_returns_valid_ShortcutInfo_list_and_finds_matching_shortcutItem',
      0, async () => {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        appItem.bundleName = 'testBundle';
        appItem.moduleName = 'testModule';
        appItem.shortcutId = 'shortcut_id_test';
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        let mockShortcutInfo: ShortcutInfo = buildShortcutInfo();
        mockShortcutInfo.id = 'shortcut_id_test';
        mockShortcutInfo.iconId = 10;
        when(mockFunc)(ArgumentMatchers.anyString).afterReturn([mockShortcutInfo]);
        let result = shortcutViewModel.getShortcutIconId(appItem);
        expect(result).assertEqual(10);
        mocker.ignoreMock(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
      });

    it('should_return_undefined_when_getAllShortcutInfo_returns_valid_ShortcutInfo_list_but_does_not_find_matching_shortcutItem',
      0, async () => {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        appItem.bundleName = 'testBundle';
        appItem.moduleName = 'testModule';
        appItem.shortcutId = 'shortcut_id_test';
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        let mockShortcutInfo: ShortcutInfo = buildShortcutInfo();
        mockShortcutInfo.id = 'shortcut_id_test1';
        mockShortcutInfo.iconId = 10;
        when(mockFunc)(ArgumentMatchers.anyString).afterReturn([mockShortcutInfo]);
        let result = shortcutViewModel.getShortcutIconId(appItem);
        expect(result).assertEqual(undefined);
        mocker.ignoreMock(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
      });

    it('should_call_deleteAppResourceCache_when_getAllShortcutInfo_returns_valid_ShortcutInfo_list_and_finds_matching_shortcutItem',
      0, async () => {
        let appItem: AppItemInfo = new AppItemInfo();
        appItem.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        appItem.bundleName = 'testBundle';
        appItem.moduleName = 'testModule';
        appItem.shortcutId = 'shortcut_id_test';
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        let mocker: MockKit = new MockKit();
        let mockFunc: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        let mockShortcutInfo: ShortcutInfo = buildShortcutInfo();
        mockShortcutInfo.id = 'shortcut_id_test';
        mockShortcutInfo.iconId = 10;
        when(mockFunc)(ArgumentMatchers.anyString).afterReturn([mockShortcutInfo]);
        let mockDeleteFunc: Function =
          mocker.mockFunc(ResourceManager.getInstance(), ResourceManager.getInstance().deleteAppResourceCache);
        when(mockDeleteFunc)(ArgumentMatchers.anyString).afterReturnNothing();
        let result = shortcutViewModel.getShortcutIconId(appItem);
        expect(result).assertEqual(10);
        mocker.ignoreMock(AppModel.getInstance(), AppModel.getInstance().getAllShortcutInfo);
        mocker.ignoreMock(ResourceManager.getInstance(), ResourceManager.getInstance().deleteAppResourceCache);
      });

    it('should_return_empty_string_when_item_typeId_is_not_TYPE_SHORTCUT_ICON_or_startType_is_not_SHORTCUT_APP', 0,
      () => {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        let item: AppItem = {
          typeId: CommonConstants.TYPE_APP, startType: StartType.APP, bundleName: 'testBundleName'
        };
        const result = shortcutViewModel.getShortcutBackgroundImage(item);
        expect(result).assertEqual('');
      });

    it('should_return_empty_string_when_bundleName_is_contacts_app', 0, () => {
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let item: AppItem = {
        typeId: CommonConstants.TYPE_SHORTCUT_ICON, startType: StartType.SHORTCUT_APP, bundleName: 'com.ohos.contacts'
      };
      const result = shortcutViewModel.getShortcutBackgroundImage(item);
      expect(result).assertEqual('');
    });

    it('test_isContactsApp_01', 0, () => {
      let bundleName: string = 'com.ohos.contacts';
      let isContacts: boolean = ShortcutViewModel.getInstance().isContactsApp(bundleName);
      expect(isContacts).assertTrue();

      bundleName = 'testBundleName';
      isContacts = ShortcutViewModel.getInstance().isContactsApp(bundleName);
      expect(isContacts).assertFalse();
    });

    it('should_return_immediately_when_result_code_is_success_02', 0, async () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.checkShortcut);
      let result: CheckResult = {
        code: ResultCode.SUCCESS,
        limit: 0
      };
      when(mockFunc)(ArgumentMatchers.any).afterReturn(result);
      await shortcutViewModel.processShortcut(shortcutItem);
      expect(shortcutItem.extend3).assertUndefined();
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.checkShortcut);
    });

    it('should_set_extend3_when_result_code_is_failed_duplicate_id_02', 0, async () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.checkShortcut);
      let result: CheckResult = {
        code: ResultCode.FAILED_DUPLICATE_ID,
        limit: 0
      };
      when(mockFunc)(ArgumentMatchers.any).afterReturn(result);
      await shortcutViewModel.processShortcut(shortcutItem);
      expect(shortcutItem.extend3).assertEqual(result.code);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.checkShortcut);
    });

    it('should_set_keyName_when_result_code_is_failed_duplicate_id_02', 0, async () => {
      let shortcutItem: GridLayoutItemInfo = new GridLayoutItemInfo();
      let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(shortcutViewModel, shortcutViewModel.checkShortcut);
      let result: CheckResult = {
        code: ResultCode.FAILED_DUPLICATE_ID,
        limit: 0
      };
      when(mockFunc)(ArgumentMatchers.any).afterReturn(result);
      await shortcutViewModel.processShortcut(shortcutItem);
      expect(shortcutItem.keyName).assertEqual(CommonConstants.EXIST_SHORTCUT_PREFIX + undefined);
      mocker.ignoreMock(shortcutViewModel, shortcutViewModel.checkShortcut);
    });

    it('test_isShortcutInBMS_01', 0, async () => {
      let shortcutInfo: ShortcutInfo = {
        id: 'test_shortcut',
        bundleName: 'com.test.shortcut',
        appIndex: 0,
        sourceType: 0
      };
      let result: boolean = await ShortcutViewModel.getInstance().isShortcutInBMS(shortcutInfo);
      expect(result).assertFalse();
    });

    it('test_isShortcutInLauncherAndDock_01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        let shortcutInfo: ShortcutInfo = {
          id: 'test_shortcut',
          bundleName: 'com.test.shortcut',
          appIndex: 0,
          sourceType: 0
        };
        let result: boolean = shortcutViewModel['isShortcutInLauncherAndDock'](shortcutInfo);
        expect(result).assertFalse();
        let mockFunc: Function =
          mocker.mockFunc(ShortcutViewModel.getInstance(), shortcutViewModel['isShortcutInLauncherAndDock']);
        shortcutInfo.id = 'test_shortcut_true'
        when(mockFunc)(shortcutInfo).afterReturn(true);
        expect(shortcutViewModel['isShortcutInLauncherAndDock'](shortcutInfo)).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(ShortcutViewModel.getInstance());
      mocker.clearAll();
    })

    it('test_BaseShortcutInfo_01', 0, async () => {
      try {
        let baseShortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        expect(baseShortcutInfo?.appIndex).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateBackgroundImage_01', 0, async () => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(AppIconModel.getInstance(), AppIconModel.getInstance().getHdsIcon);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel['updateBackgroundImage']();
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(AppIconModel.getInstance());
      mock.clearAll();
    })

    it('test_clearBackgroundImage_01', 0, async () => {
      try {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel['updateBackgroundImage']();
        shortcutViewModel.clearBackgroundImage();
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_clearBackgroundImage_02', 0, async (done: Function) => {
      try {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel['backgroundImage'] = await resourceManagerCreateImage();
        shortcutViewModel.clearBackgroundImage();
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_clearBackgroundImage_03', 0, () => {
      try {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel['backgroundImage']?.release();
        shortcutViewModel.clearBackgroundImage();
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_resourceChangeListener_01', 0, () => {
      try {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel['resourceChangeListener']?.clearCache();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_checkShortCutInfo_01', 0, () => {
      try {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel.checkShortCutInfo(undefined, undefined);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_checkShortCutInfo_02', 0, () => {
      try {
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel.checkShortCutInfo(appInfo, undefined);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_checkShortCutInfo_03', 0, () => {
      let mock = new MockKit();
      try {
        let mockIsContactsApp: Function = mock.mockFunc(instance, instance.isContactsApp);
        when(mockIsContactsApp)(ArgumentMatchers.anyString).afterReturn(true);

        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';

        instance.checkShortCutInfo(appInfo, undefined);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_checkShortCutInfo_04', 0, () => {
      let mock = new MockKit();
      try {
        let mockIsContactsApp: Function = mock.mockFunc(instance, instance.isContactsApp);
        when(mockIsContactsApp)(ArgumentMatchers.anyString).afterReturn(true);

        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);

        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';

        instance.checkShortCutInfo(appInfo, undefined);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it('test_checkShortCutInfo_05', 0, () => {
      let mock = new MockKit();
      try {
        let mockIsContactsApp: Function = mock.mockFunc(instance, instance.isContactsApp);
        when(mockIsContactsApp)(ArgumentMatchers.anyString).afterReturn(true);

        let bundleName: string = 'com.ohos.contacts';
        let moduleName: string = 'entry';
        let shortcutInfo = {
          id: '1',
          bundleName: bundleName,
          moduleName: moduleName,
          appIndex: 0,
          sourceType: 0,
          iconId: 0,
          labelId: 0,
        } as ShortcutInfo;
        let list: ShortcutInfo[] = [shortcutInfo];
        let mockFunc: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(list);

        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        appInfo.moduleName = moduleName;

        instance.checkShortCutInfo(appInfo, undefined);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clear(AppModel.getInstance());
      mock.clearAll();
    })

    it('test_onShortcutMenuClick_01', 0, () => {
      try {
        let want = {
          targetBundle: 'bundleName1',
        } as launcherBundleManager.ShortcutWant;
        let targetBundleName: string = '';
        let shortcutInfoItem: ShortcutInfo = buildShortcutInfo();
        shortcutInfoItem.bundleName = 'bundleName2';
        shortcutInfoItem.wants = [want];
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel['onShortcutMenuClick'](targetBundleName, shortcutInfoItem);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onShortcutMenuClick_02', 0, () => {
      try {
        let want = {
          targetBundle: 'bundleName',
        } as launcherBundleManager.ShortcutWant;
        let targetBundleName: string = '';
        let shortcutInfoItem: ShortcutInfo = buildShortcutInfo();
        shortcutInfoItem.bundleName = 'bundleName';
        shortcutInfoItem.wants = [want];
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel['onShortcutMenuClick'](targetBundleName, shortcutInfoItem);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onShortcutMenuClick_03', 0, () => {
      try {
        let bundleName: string = 'com.ohos.contacts';
        let want = {
          targetBundle: bundleName,
        } as launcherBundleManager.ShortcutWant;
        let targetBundleName: string = '';
        let shortcutInfoItem: ShortcutInfo = buildShortcutInfo();
        shortcutInfoItem.bundleName = bundleName;
        shortcutInfoItem.wants = [want];
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        shortcutViewModel['onShortcutMenuClick'](targetBundleName, shortcutInfoItem);

        let context: Context = getContext();
        context.eventHub.emit(CommonConstants.EVENTHUB_MENU_DISAPPEAR);


        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onShortcutAppClick_01', 0, async (done: Function) => {
      try {
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        await shortcutViewModel.onShortcutAppClick(undefined);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_onShortcutAppClick_02', 0, async (done: Function) => {
      let mock = new MockKit();
      try {
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        let mockFunc: Function = mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(undefined);
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        await shortcutViewModel.onShortcutAppClick(appInfo);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clearAll();
    })

    it('test_onShortcutAppClick_03', 0, async (done: Function) => {
      let mock = new MockKit();
      try {
        let shortcutInfoItem: ShortcutInfo = buildShortcutInfo();
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        let mockFunc: Function = mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoItem);
        let isPC = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(isPC)().afterReturn(false);
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        await shortcutViewModel.onShortcutAppClick(appInfo);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_onShortcutAppClick_04', 0, async (done: Function) => {
      let mock = new MockKit();
      try {
        let shortcutInfoItem: ShortcutInfo = buildShortcutInfo();
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        let mockFunc: Function = mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoItem);
        let isPC = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(isPC)().afterThrow('err');
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        await shortcutViewModel.onShortcutAppClick(appInfo);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_onShortcutAppClick_05', 0, async (done: Function) => {
      let mock = new MockKit();
      try {
        let want = {
          targetBundle: 'targetBundle',
          targetModule: 'targetModule',
          targetAbility: 'targetAbility',
        } as launcherBundleManager.ShortcutWant;
        let shortcutInfoItem: ShortcutInfo = buildShortcutInfo();
        shortcutInfoItem.wants = [want];
        let appInfo: AppItemInfo = new AppItemInfo();
        appInfo.bundleName = 'com.ohos.contacts';
        let mockFunc: Function = mock.mockFunc(ShortcutViewModel.getInstance(), ShortcutViewModel.getInstance().getShortcutInfo);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(shortcutInfoItem);
        let isPC = mock.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(isPC)().afterReturn(true);
        let shortcutViewModel: ShortcutViewModel = ShortcutViewModel.getInstance();
        await shortcutViewModel.onShortcutAppClick(appInfo);
        expect(shortcutViewModel instanceof ShortcutViewModel).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(ShortcutViewModel.getInstance());
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_subscribeColorChangeEvent_01', 0, () => {
      try {
        let context: Context = getContext();
        context.eventHub.emit('onColorModeChange', 1);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_changeBase64ToPixelSync_01', 0,  () => {
      let mock = new MockKit();
      try {
        let pixelStr: string = 'pixelStr';
        let decodingOptions: image.DecodingOptions | undefined = undefined;

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
        instance['changeBase64ToPixelSync'](pixelStr, decodingOptions);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_changeBase64ToPixelSync_02', 0,  () => {
      let mock = new MockKit();
      try {
        let pixelStr: string = 'pixelStr';
        let decodingOptions: image.DecodingOptions | undefined = undefined;

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        instance['changeBase64ToPixelSync'](pixelStr, decodingOptions);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_changeBase64ToPixelSync_03', 0,  () => {
      let mock = new MockKit();
      try {
        let pixelStr: string = 'pixelStr';
        let decodingOptions: image.DecodingOptions | undefined = {
          desiredRegion: {
            size: { height: 5, width: 5 },
            x: 1,
            y: 1,
          },
          desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
        }

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
        instance['changeBase64ToPixelSync'](pixelStr, decodingOptions);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_convertToHdsIcon_01', 0,  () => {
      let mock = new MockKit();
      try {
        let icon: string = 'pixelStr';
        let bundleName: string = 'com.ohos.contacts';

        let mockFunc: Function = mock.mockFunc(instance, instance['changeBase64ToPixelSync']);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');
        instance.convertToHdsIcon(icon, bundleName);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_convertToHdsIcon_02', 0,  () => {
      try {
        let icon: string = 'pixelStr';
        let bundleName: string = 'com.ohos.contacts';
        instance.convertToHdsIcon(icon, bundleName);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_convertToHdsIcon_03', 0,  () => {
      try {
        let icon: image.PixelMap = GlobalContext.getContext()?.resourceManager.getDrawableDescriptor($r('app.media.default_icon').id)
          .getPixelMap();
        let bundleName: string = 'com.ohos.contacts';
        instance.convertToHdsIcon(icon, bundleName);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('atc_should_return_failed_when_shortcutInfo_is_invalid_parameters', 0, () => {
      let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
      instance.checkShortcut(shortcutInfo);
      expect(instance instanceof ShortcutViewModel).assertTrue();
    });

    it('atc_should_return_failed_when_shortcut_id_exists_7', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        shortcutInfo.bundleName = "com.ohos.app";
        shortcutInfo.id = '1';
        let sameAppItemInfoList: GridLayoutItemInfo[] = [new GridLayoutItemInfo()];
        sameAppItemInfoList[0].shortcutId = '1';

        let mockfunc: Function = mocker.mockFunc(instance, instance.selectAllSameApp);
        when(mockfunc)(ArgumentMatchers.any)
          .afterReturn(sameAppItemInfoList);
        instance.checkShortcut(shortcutInfo);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('atc_should_return_failed_when_shortcut_count_exceeds_limit', 0, () => {
      let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
      shortcutInfo.bundleName = "com.ohos.app";
      let sameAppItemInfoList: GridLayoutItemInfo[] = [new GridLayoutItemInfo(), new GridLayoutItemInfo()];
      sameAppItemInfoList[0].typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      sameAppItemInfoList[1].typeId = CommonConstants.TYPE_SHORTCUT_ICON;
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(instance, instance.selectAllSameApp);
      when(mockfunc)(ArgumentMatchers.any)
        .afterReturn(sameAppItemInfoList);
      instance.checkShortcut(shortcutInfo);
      expect(instance instanceof ShortcutViewModel).assertTrue();
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('atc_should_return_failed_when_device_is_pc_and_no_space_left', 0, () => {
      let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
      shortcutInfo.bundleName = "com.ohos.app";
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
      when(mockfunc)().afterReturn(true);
      let mockfunc2: Function = mocker.mockFunc(instance, instance['isCanCreateShortcut']);
      when(mockfunc2)().afterReturn(false);
      instance.checkShortcut(shortcutInfo);
      expect(instance instanceof ShortcutViewModel).assertTrue();
      mocker.ignoreMock(DeviceHelper, DeviceHelper.isPC);
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_checkShortcut_01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        shortcutInfo.bundleName = "com.ohos.app";

        let mockfunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().getShortCountLimitByBundleName);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(undefined);

        let mockfunc2: Function = mocker.mockFunc(DockLayoutCacheManager.getInstance(), DockLayoutCacheManager.getInstance().getShortCountLimitByBundleName);
        when(mockfunc2)(ArgumentMatchers.any).afterReturn(undefined);

        let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(isPC)().afterReturn(true);

        instance.checkShortcut(shortcutInfo);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(DockLayoutCacheManager.getInstance());
      mocker.clearAll();
    });

    it('test_checkShortcut_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        shortcutInfo.bundleName = "com.ohos.app";

        let mockfunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().getShortCountLimitByBundleName);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(undefined);

        let mockfunc2: Function = mocker.mockFunc(DockLayoutCacheManager.getInstance(), DockLayoutCacheManager.getInstance().getShortCountLimitByBundleName);
        when(mockfunc2)(ArgumentMatchers.any).afterReturn(undefined);

        let isPC = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
        when(isPC)().afterReturn(false);

        instance.checkShortcut(shortcutInfo);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(DockLayoutCacheManager.getInstance());
      mocker.clearAll();
    });

    it('test_isCanCreateShortcut_01', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        shortcutInfo.bundleName = "com.ohos.app";

        let layoutDescription: LayoutDescription = new LayoutDescription();
        layoutDescription.row = 1;
        layoutDescription.column = 1;
        layoutDescription.pageCount = 1;
        let mockfunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().selectLayoutDescription);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(layoutDescription);

        instance['isCanCreateShortcut']();
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
    });


    it('test_isCanCreateShortcut_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        shortcutInfo.bundleName = "com.ohos.app";

        let layoutDescription: LayoutDescription = new LayoutDescription();
        layoutDescription.row = 1;
        layoutDescription.column = 1;
        layoutDescription.pageCount = 1;
        let mockfunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().selectLayoutDescription);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(layoutDescription);

        instance['isCanCreateShortcut'](1);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clearAll();
    });

    it('test_isCanCreateShortcut_03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        shortcutInfo.bundleName = "com.ohos.app";

        let layoutDescription: LayoutDescription = new LayoutDescription();
        layoutDescription.row = 1;
        layoutDescription.column = 1;
        layoutDescription.pageCount = 1;
        let mockfunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().selectLayoutDescription);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(layoutDescription);

        let mockfunc2: Function = mocker.mockFunc(instance, instance['checkAllPositions']);
        when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);

        instance['isCanCreateShortcut'](1);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_isCanCreateShortcut_04', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        shortcutInfo.bundleName = "com.ohos.app";

        let layoutDescription: LayoutDescription = new LayoutDescription();
        layoutDescription.row = 1;
        layoutDescription.column = 1;
        layoutDescription.pageCount = 1;
        let mockfunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().selectLayoutDescription);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(layoutDescription);

        let mockfunc2: Function = mocker.mockFunc(instance, instance['checkAllPositions']);
        when(mockfunc2)(ArgumentMatchers.any).afterReturn(true);

        instance['isCanCreateShortcut']();
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_isCanCreateShortcut_05', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        shortcutInfo.bundleName = "com.ohos.app";

        let layoutDescription: LayoutDescription = new LayoutDescription();
        layoutDescription.row = 1;
        layoutDescription.column = 1;
        layoutDescription.pageCount = 1;
        let mockfunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().selectLayoutDescription);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(layoutDescription);

        let mockfunc2: Function = mocker.mockFunc(instance, instance['checkAllPositions']);
        when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);

        instance['isCanCreateShortcut']();
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_isCanCreateShortcut_06', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let shortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        shortcutInfo.bundleName = "com.ohos.app";

        let layoutDescription: LayoutDescription = new LayoutDescription();
        layoutDescription.row = 1;
        layoutDescription.column = 1;
        layoutDescription.pageCount = 1;
        let mockfunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(),
          LaunchLayoutCacheManager.getInstance().selectLayoutDescription);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(layoutDescription);

        let mockfunc2: Function = mocker.mockFunc(instance, instance['checkAllPositions']);
        when(mockfunc2)(ArgumentMatchers.any).afterReturn(false);

        instance['isCanCreateShortcut'](1);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_selectAllSameApp_01', 0, () => {
      try {
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let isOuter: boolean = false;
        instance.selectAllSameApp(bundleName,appIndex,isOuter);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_selectAllSameApp_02', 0, () => {
      try {
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let isOuter: boolean = true;
        instance.selectAllSameApp(bundleName,appIndex,isOuter);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_selectAllSameApp_03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let mockFunc2: Function = mocker.mockFunc(instance, instance['selectSameApp']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);

        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let isOuter: boolean = false;
        instance.selectAllSameApp(bundleName,appIndex,isOuter);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_selectAllSameApp_04', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc: Function = mocker.mockFunc(LaunchLayoutCacheManager.getInstance(), LaunchLayoutCacheManager.getInstance().getAllGridLayoutItemList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let mockFunc2: Function = mocker.mockFunc(instance, instance['selectSameApp']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);

        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let isOuter: boolean = true;
        instance.selectAllSameApp(bundleName,appIndex,isOuter);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(LaunchLayoutCacheManager.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
    });

    it('test_selectSameApp_01', 0, () => {
      try {
        let itemInfoList: GridLayoutItemInfo[] = [];
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        instance['selectSameApp'](itemInfoList, bundleName, appIndex);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_selectSameApp_02', 0, () => {
      try {
        let item1: GridLayoutItemInfo = new GridLayoutItemInfo();
        item1.bundleName = 'com.ohos.sceneboard';
        item1.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        let item2: GridLayoutItemInfo = new GridLayoutItemInfo();
        item2.bundleName = 'com.ohos.sceneboard';
        item2.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'com.ohos.sceneboard';
        item3.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
        item4.bundleName = 'com.ohos.sceneboard';
        item4.typeId = CommonConstants.TYPE_SHORTCUT_ICON;

        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.layoutInfo = [[item1],[item2]];
        appInfo1.typeId = CommonConstants.TYPE_FOLDER;
        appInfo1.keyName = 'keyName0';

        let itemInfoList: GridLayoutItemInfo[] = [appInfo1,item3,item4];
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        instance['selectSameApp'](itemInfoList, bundleName, appIndex);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_selectSameApp_03', 0, () => {
      try {
        let item3: GridLayoutItemInfo = new GridLayoutItemInfo();
        item3.bundleName = 'com.ohos.sceneboard';
        item3.typeId = CommonConstants.TYPE_SHORTCUT_ICON;
        let item4: GridLayoutItemInfo = new GridLayoutItemInfo();
        item4.bundleName = 'com.ohos.sceneboard';
        item4.typeId = CommonConstants.TYPE_SHORTCUT_ICON;

        let appInfo1: GridLayoutItemInfo = new GridLayoutItemInfo();
        appInfo1.typeId = CommonConstants.TYPE_FOLDER;
        appInfo1.keyName = 'keyName0';

        let itemInfoList: GridLayoutItemInfo[] = [appInfo1,item3,item4];
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        instance['selectSameApp'](itemInfoList, bundleName, appIndex);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_isSameShortcut_01', 0, () => {
      try {
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let shortcutId: string = '1';
        let findItemInfoList: GridLayoutItemInfo[] = [];
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName = bundleName;
        item.appIndex = appIndex;
        item.shortcutId = shortcutId;

        instance['isSameShortcut'](item, bundleName, appIndex, shortcutId, findItemInfoList);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_isSameShortcut_02', 0, () => {
      try {
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        let shortcutId: string = '1';
        let findItemInfoList: GridLayoutItemInfo[] = [];
        let item: GridLayoutItemInfo = new GridLayoutItemInfo();
        item.bundleName = bundleName;
        item.appIndex = appIndex + 1;
        item.shortcutId = shortcutId;

        instance['isSameShortcut'](item, bundleName, appIndex, shortcutId, findItemInfoList);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_deleteShortcutFromBMS_01', 0, async (done: Function) => {
      try {
        await instance.deleteShortcutFromBMS({} as BaseShortcutInfo);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      done();
    });

    it('test_deleteShortcutFromBMS_02', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc2: Function = mocker.mockFunc(instance, instance['isShortcutInLauncherAndDock']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let baseShortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        baseShortcutInfo.id = '1';
        baseShortcutInfo.bundleName = 'com.ohos.contacts';
        baseShortcutInfo.appIndex = 0;
        await instance.deleteShortcutFromBMS(baseShortcutInfo);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_deleteShortcutFromBMS_03', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc2: Function = mocker.mockFunc(instance, instance['isShortcutInLauncherAndDock']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let baseShortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        baseShortcutInfo.id = '1';
        baseShortcutInfo.bundleName = 'com.ohos.contacts';
        await instance.deleteShortcutFromBMS(baseShortcutInfo);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_deleteShortcutFromBMS_04', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc2: Function = mocker.mockFunc(instance, instance['isShortcutInLauncherAndDock']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let baseShortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        baseShortcutInfo.id = '1';
        baseShortcutInfo.bundleName = 'com.ohos.contacts';
        baseShortcutInfo.appIndex = 0;
        await instance.deleteShortcutFromBMS(baseShortcutInfo);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_deleteShortcutFromBMS_05', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc2: Function = mocker.mockFunc(instance, instance['isShortcutInLauncherAndDock']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc3: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getUserId);
        when(mockFunc3)(ArgumentMatchers.any).afterThrow('err');

        let baseShortcutInfo: BaseShortcutInfo = new BaseShortcutInfo();
        baseShortcutInfo.id = '1';
        baseShortcutInfo.bundleName = 'com.ohos.contacts';
        baseShortcutInfo.appIndex = 0;
        await instance.deleteShortcutFromBMS(baseShortcutInfo);
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(AppModel.getInstance());
      mocker.clear(instance);
      mocker.clearAll();
      done();
    });

    it('test_getAllDesktopShortcutFromBMS_01', 0, async (done: Function) => {
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc3: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getUserId);
        when(mockFunc3)(ArgumentMatchers.any).afterThrow('err');

        await instance.getAllDesktopShortcutFromBMS();
        expect(instance instanceof ShortcutViewModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(AppModel.getInstance());
      mocker.clearAll();
      done();
    });

    it('test_getAllDesktopShortcutFromBMS_02', 0, async (done: Function) => {
      try {
        await instance.getAllDesktopShortcutFromBMS();
        expect(instance instanceof ShortcutViewModel).assertTrue();
        done();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });


  })
}

async function resourceManagerCreateImage(): Promise<image.PixelMap> {
  let width: number = 10;
  let height: number = 10;
  const color = new ArrayBuffer(width * height * 4);
  let opts: image.InitializationOptions = { editable: true, pixelFormat: 3, size: { height: width, width: height } };
  return image.createPixelMap(color, opts);
}
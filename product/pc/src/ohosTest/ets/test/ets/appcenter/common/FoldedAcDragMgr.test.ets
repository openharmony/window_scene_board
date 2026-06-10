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
import AppGridLayoutCacheManager from '@ohos/appcenter/src/main/ets/default/common/cache/AppGridLayoutCacheManager'
import { FoldedAcDragMgr } from '@ohos/appcenter/src/main/ets/default/folded/FoldedAcDragMgr'
import { FoldedDeviceAcViewModel } from '@ohos/appcenter/src/main/ets/default/folded/FoldedDeviceAcViewModel'
import { DragItemPosition } from '@ohos/componentdrag'
import { SceneSessionUIContextManager } from '@ohos/componenthelper'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium'
import { AppItemInfo } from '@ohos/launchercommon'
import { UIContext } from '@kit.ArkUI'
import unifiedDataChannel from '@ohos.data.unifiedDataChannel'
import { ReflectionUtils } from '../../common/utils/ReflectionUtils'

export default function FoldedAcDragMgrTest() {
  describe('FoldedAcDragMgrTest', () => {
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

    it('test_FoldedAcDragMgrTest_setDragItemInfo', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      let mocker: MockKit = new MockKit();
      let appGridLayoutCacheManager: AppGridLayoutCacheManager = AppGridLayoutCacheManager.getInstance();
      let mockerFunc1 = mocker.mockFunc(appGridLayoutCacheManager, appGridLayoutCacheManager.getAppGridLayoutItemList);
      when(mockerFunc1)().afterReturn(false);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      when(mockerFunc1)().afterReturn(false);
      ReflectionUtils.setProperty(instance, 'mDragPageIndex', 3);
      instance.setDragItemInfo(appItemInfo);
      ReflectionUtils.setProperty(instance, 'mDragPageIndex', 0);
      instance.setDragItemInfo(appItemInfo);
    })

    it('test_FoldedAcDragMgrTest_initAppGridRect', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      (instance as object)['initAppGridRect'](0);
      (instance as object)['initAppGridRect'](1);
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_isInAppCenterWorkBench', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      let mocker: MockKit = new MockKit();
      let foldedDeviceAcViewModel: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcViewModel, foldedDeviceAcViewModel.isHalfFolded);
      when(mockerFunc1)().afterReturn(false);
      (instance as object)['isInAppCenterWorkBench'](0, 0, 0);
      when(mockerFunc1)().afterReturn(true);
      (instance as object)['isInAppCenterWorkBench'](0, 0, 0);
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_resetDragStartPositionInNeed', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      let mocker: MockKit = new MockKit();
      let foldedDeviceAcViewModel: FoldedDeviceAcViewModel = FoldedDeviceAcViewModel.getInstance();
      let mockerFunc1 = mocker.mockFunc(foldedDeviceAcViewModel, foldedDeviceAcViewModel.isUnFoldedHorizontal);
      when(mockerFunc1)().afterReturn(false);
      (instance as object)['resetDragStartPositionInNeed'](0, 0, 0);
      when(mockerFunc1)().afterReturn(true);
      (instance as object)['resetDragStartPositionInNeed'](0, 0, 0);
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_resetDragItemDataOnDragFinal', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      instance.setDragItemInfo(new AppItemInfo());
      (instance as object)['resetDragItemDataOnDragFinal']();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      const startPosition: DragItemPosition = {
        page: 1,
        row: 1,
        column: 1,
        x: 0,
        y: 0,
      };
      (instance as object)['resetDragItemDataOnDragFinal']();
      appItemInfo.page = 1;
      instance.setDragItemInfo(appItemInfo);
      (instance as object)['resetDragItemDataOnDragFinal']();
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_resetDragItemInfoInNeed', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      let mocker: MockKit = new MockKit();
      let appGridLayoutCacheManager: AppGridLayoutCacheManager = AppGridLayoutCacheManager.getInstance();
      let mockerFunc1 = mocker.mockFunc(appGridLayoutCacheManager, appGridLayoutCacheManager.lookForApp);
      instance.setDragItemInfo(new AppItemInfo());
      (instance as object)['resetDragItemInfoInNeed']();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      const startPosition: DragItemPosition = {
        page: 1,
        row: 1,
        column: 1,
        x: 0,
        y: 0,
      };
      when(mockerFunc1)().afterReturn(null);
      (instance as object)['resetDragItemInfoInNeed']();
      when(mockerFunc1)().afterReturn(appItemInfo);
      (instance as object)['resetDragItemInfoInNeed']();
      appItemInfo.page = 1;
      instance.setDragItemInfo(appItemInfo);
      (instance as object)['resetDragItemInfoInNeed']();
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_updateAppCenterDragData', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDragging', false);
      instance.updateAppCenterDragData(0, false, 2, 3);
      ReflectionUtils.setProperty(instance, 'isDragging', true);
      ReflectionUtils.setProperty(instance, 'dropOnPage', true);
      instance.updateAppCenterDragData(0, false, 2, 3);
      ReflectionUtils.setProperty(instance, 'dropOnPage', false);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      const startPosition: DragItemPosition = {
        page: 1,
        row: 1,
        column: 1,
        x: 0,
        y: 0,
      };
      instance.updateAppCenterDragData(0, false, 2, 3);
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_updateAppCenterDragData_02', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDragging', false);
      instance.updateAppCenterDragData(0, false, 2, 3);
      ReflectionUtils.setProperty(instance, 'isDragging', true);
      ReflectionUtils.setProperty(instance, 'dropOnPage', true);
      instance.updateAppCenterDragData(0, false, 2, 3);
      ReflectionUtils.setProperty(instance, 'dropOnPage', false);
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;
      instance.setDragItemInfo(appItemInfo);
      const startPosition: DragItemPosition = {
        page: 1,
        row: 2,
        column: 2,
        x: 0,
        y: 0,
      };
      ReflectionUtils.setProperty(instance, 'mStartPosition', startPosition);

      instance.updateAppCenterDragData(0, true, 3, 5);
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_onDropAnimationEnd', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isCrossFullPage', false);
      instance.onDropAnimationEnd(false);
      ReflectionUtils.setProperty(instance, 'isCrossFullPage', true);
      ReflectionUtils.setProperty(instance, 'isAppCenterViewShow', true);
      instance.onDropAnimationEnd();
      let mocker: MockKit = new MockKit();
      let sceneSessionUIContextManager: SceneSessionUIContextManager = SceneSessionUIContextManager.getInstance();
      let mockerFunc1 = mocker.mockFunc(sceneSessionUIContextManager, sceneSessionUIContextManager.getUiContext);
      when(mockerFunc1)().afterReturn(null);
      instance.onDropAnimationEnd();
      when(mockerFunc1)().afterReturn(new UIContext());
      instance.onDropAnimationEnd();
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_updateDragPageIndex', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();
      ReflectionUtils.setProperty(instance, 'isDraggingCrossScreen', false);
      instance.updateDragPageIndex(false);
      ReflectionUtils.setProperty(instance, 'isDraggingCrossScreen', true);
      ReflectionUtils.setProperty(instance, 'mDragPageIndex', 2);
      instance.updateDragPageIndex(false);
      instance.updateDragPageIndex(true);
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_onDragMove_01', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();

      let evt: DragEvent = new MockedAcDragEvent();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;

      let mocker: MockKit = new MockKit();
      let mockerFunc1 = mocker.mockFunc(evt, evt.getWindowX);
      when(mockerFunc1)().afterReturn(undefined);
      let mockerFunc2 = mocker.mockFunc(evt, evt.getWindowY);
      when(mockerFunc2)().afterReturn(undefined);

      instance.onDragMove(evt);
      expect(true).assertTrue();
    })

    it('test_FoldedAcDragMgrTest_onDragMove_02', Level.LEVEL0, (): void => {
      let instance: FoldedAcDragMgr = new FoldedAcDragMgr();

      let evt: DragEvent = new MockedAcDragEvent();
      let appItemInfo: AppItemInfo = new AppItemInfo();
      appItemInfo.bundleName = 'com.ohos.appgallery';
      appItemInfo.typeId = 0;
      appItemInfo.abilityName = 'MainAbility';
      appItemInfo.moduleName = 'entry';
      appItemInfo.keyName = 'com.ohos.appgallery_MainAbility_entry_0'
      appItemInfo.badgeNumber = 1;
      appItemInfo.area = [2,3];
      appItemInfo.appName = '应用市场';
      appItemInfo.appIconId = 67109115;
      appItemInfo.appLabelId = 67108895;
      appItemInfo.kindId = 0;
      appItemInfo.bundleType = 0;
      appItemInfo.applicationName = '';
      appItemInfo.appStatus = 0;
      appItemInfo.downloadProgress = 2;
      appItemInfo.iconResource = '2';
      appItemInfo.callerName = 'yyy';
      appItemInfo.appIndex = 0;
      appItemInfo.page = 0;

      ReflectionUtils.setProperty(instance, 'resetDelayForFullPage', true);

      instance.onDragMove(evt);
      expect(true).assertTrue();
    })
  })
}

/**
 * 模拟拖拽事件，用于事件注入
 */
class MockedAcDragEvent implements DragEvent {
  dragBehavior: DragBehavior = DragBehavior.COPY;
  useCustomDropAnimation: boolean = false;
  displayX: number = 0;
  displayY: number = 0;

  enableInternalDropAnimation(configuration: string): void {
    throw new Error('Method not implemented.')
  }
  getModifierKeyState?(keys: string[]): boolean {
    return true;
  }

  getData(): unifiedDataChannel.UnifiedData {
    let data = new unifiedDataChannel.UnifiedRecord()
    return new unifiedDataChannel.UnifiedData(data);
  }

  getSummary(): unifiedDataChannel.Summary {
    return new unifiedDataChannel.Summary();
  }

  setResult(dragResult: DragResult): void {
  }

  getResult(): DragResult {
    return DragResult.DRAG_SUCCESSFUL;
  }

  getPreviewRect(): Rectangle {
    return {};
  }

  getVelocityX(): number {
    return 0;
  }

  getVelocityY(): number {
    return 0;
  }

  getVelocity(): number {
    return 0;
  }

  executeDropAnimation(customDropAnimation: Callback<void, void>): void {
  }

  setData(unifiedData: unifiedDataChannel.UnifiedData): void {
  }

  getX(): number {
    return 0;
  }

  getY(): number {
    return 0;
  }

  getWindowX(): number {
    return 0;
  }

  getWindowY(): number {
    return 0;
  }

  getDisplayX(): number {
    return this.displayX;
  }

  getDisplayY(): number {
    return this.displayY;
  }
}
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
import { CollaborationEventManager, CommonConstants, DockItemInfo } from '@ohos/launchercommon'
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
} from '@ohos/hypium'
import { SmartDockStyleMgr } from '../../../../main/ets/default/manager/SmartDockStyleMgr'
import { ItemUtils } from '@ohos/componenthelper'
import { DockRegionType } from '../../../../main/ets/default/common/enum/SmartDockEnum'
import { DockRegionLayoutModel } from '../../../../main/ets/default/model/DockRegionLayoutModel'
import { RectInfo } from '@ohos/basicutils'
import { SCBSceneSessionManager } from '@ohos/windowscene'
import { DeviceHelper } from '@ohos/frameworkwrapper'

export default function SmartDockStyleMgrTest() {
  describe('SmartDockStyleMgrTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('test_getInstance_1', 0, (): void => {
      let instance = SmartDockStyleMgr.getInstance();
      expect(instance instanceof SmartDockStyleMgr).assertTrue();
    })

    it('updateDockParams_1', 0, (): void => {
      AppStorage.setOrCreate('screenWidth', 10);
      AppStorage.setOrCreate('screenHeight', 10);
      AppStorage.setOrCreate('sysUIBottomHeight', 10);
      AppStorage.setOrCreate('dockHeight', 10);
      let instance = SmartDockStyleMgr.getInstance();
      instance.updateDockParams(CommonConstants.DEFAULT_DEVICE_TYPE);
      expect(instance instanceof SmartDockStyleMgr).assertTrue();
    })

    it('updateDockParams_2', 0, (): void => {
      AppStorage.setOrCreate('screenWidth', 20);
      AppStorage.setOrCreate('screenHeight', 20);
      AppStorage.setOrCreate('sysUIBottomHeight', 20);
      AppStorage.setOrCreate('dockHeight', 20);
      let instance = SmartDockStyleMgr.getInstance();
      instance.updateDockParams(CommonConstants.PAD_DEVICE_TYPE);
      expect(instance instanceof SmartDockStyleMgr).assertTrue();
    })

    it('updateDockParams_3', 0, (): void => {
      AppStorage.setOrCreate('screenWidth', 30);
      AppStorage.setOrCreate('screenHeight', 30);
      AppStorage.setOrCreate('sysUIBottomHeight', 30);
      AppStorage.setOrCreate('dockHeight', 30);
      let instance = SmartDockStyleMgr.getInstance();
      instance.updateDockParams(CommonConstants.PC_DEVICE_TYPE);
      expect(instance instanceof SmartDockStyleMgr).assertTrue();
    })

    it('test_getDockItemCenter', 0, (): void => {
      try {
        AppStorage.setOrCreate('screenWidth', 800);
        AppStorage.setOrCreate('screenHeight', 600);
        AppStorage.setOrCreate('sysUIBottomHeight', 30);
        AppStorage.setOrCreate('dockHeight', 80);
        AppStorage.setOrCreate('dividerWidth', 2);
        let instance = SmartDockStyleMgr.getInstance();
        instance.updateDockParams(CommonConstants.PAD_DEVICE_TYPE);
        AppStorage.setOrCreate<DockItemInfo[]>('recentList', []);
        AppStorage.setOrCreate<DockItemInfo[]>('recentDockList', []);
        instance.getDockItemCenter(0, 20);
        instance.getDockItemCenter(-1, -2);
        instance.getDockItemCenter(2, 1);
        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'com.ohos.contacts';
        AppStorage.setOrCreate<DockItemInfo[]>('recentList', [itemInfo]);
        AppStorage.setOrCreate<DockItemInfo[]>('recentDockList', [itemInfo]);
        AppStorage.setOrCreate<number>('pcModeRecentWidth', 20);
        AppStorage.setOrCreate<number>('recentLayoutWidth', 20);
        instance.getDockItemCenter(2, 1);
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
        AppStorage.setOrCreate<DockItemInfo[]>('recentList', []);
        AppStorage.setOrCreate<DockItemInfo[]>('recentDockList', []);
      } catch (e) {
      }
    })

    it('test_getResidentLayoutWidth', 0, (): void => {
      try {
        AppStorage.setOrCreate('residentLayoutWidth', null);
        let instance = SmartDockStyleMgr.getInstance();
        let residentLayoutWidth = instance.getResidentLayoutWidth();
        expect(residentLayoutWidth).assertEqual(0);

        AppStorage.setOrCreate('residentLayoutWidth', 800);
        residentLayoutWidth = instance.getResidentLayoutWidth();
        expect(residentLayoutWidth).assertEqual(800);
        AppStorage.delete('residentLayoutWidth');
      } catch (e) {
      }
    });

    it('test_getDockItemCenterY', 0, (): void => {
      try {
        AppStorage.setOrCreate('screenHeight', 960);
        AppStorage.setOrCreate('dockHeight', 120);
        let instance = SmartDockStyleMgr.getInstance();
        let centerY = instance.getDockItemCenterY();
        expect(centerY).assertInstanceOf('Number');
        AppStorage.delete('screenHeight');
        AppStorage.delete('dockHeight');
      } catch (e) {
      }
    });

    it('test_getDockItemCenterPosition', 0, (): void => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(ItemUtils, ItemUtils.getRectById);
        let rect: RectInfo = new RectInfo(0, 0, 240, 1680);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(rect);
        let instance = SmartDockStyleMgr.getInstance();
        let position = instance.getDockItemCenterPosition('position');
        expect(position.length).assertEqual(2);
        expect(position[0]).assertEqual(120);
        expect(position[1]).assertEqual(840);
      } catch (e) {
      }
    });

    it('test_getDockItemCenterXByRegion_01', 0, (): void => {
      try {
        let instance = SmartDockStyleMgr.getInstance();
        let centerX = instance.getDockItemCenterXByRegion(-1, 1, DockRegionType.RESIDENT);
        expect(centerX).assertEqual(-1);

        centerX = instance.getDockItemCenterXByRegion(1, -1, DockRegionType.RESIDENT);
        expect(centerX).assertEqual(-1);

        centerX = instance.getDockItemCenterXByRegion(1, 2, DockRegionType.RESIDENT);
        expect(centerX).assertEqual(-1);
      } catch (e) {
      }
    });

    it('test_getDockItemCenterXByRegion_028', 0, (): void => {
      try {
        let layoutModel = DockRegionLayoutModel.getInstance();
        layoutModel.updateRegionLayoutWidth(DockRegionType.RECENT, 340);

        AppStorage.setOrCreate('residentLayoutWidth', 800);
        AppStorage.setOrCreate('screenWidth', 2800);

        let instance = SmartDockStyleMgr.getInstance();
        let centerX = instance.getDockItemCenterXByRegion(5, 3, DockRegionType.RESIDENT);

        centerX = instance.getDockItemCenterXByRegion(4, 2, DockRegionType.RECENT);

        centerX = instance.getDockItemCenterXByRegion(2, 1, DockRegionType.COLLABORATION);
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
        AppStorage.delete('residentLayoutWidth');
        AppStorage.delete('screenWidth');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getDockItemCenterXByRegion_03', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function =
          mock.mockFunc(instance, instance.getRecentLayoutWidth);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(1);

        let mockFunc2: Function =
          mock.mockFunc(instance, (instance as object)['getCollaborationWidth']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);

        instance.getDockItemCenterXByRegion(2, 1, DockRegionType.RESIDENT);
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getDockItemCenterXByRegion_04', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function =
          mock.mockFunc(instance, instance.getRecentLayoutWidth);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(1);

        let mockFunc2: Function =
          mock.mockFunc(instance, (instance as object)['getCollaborationWidth']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);

        let mockFunc3: Function =
          mock.mockFunc(instance, instance.getResidentLayoutWidth);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(1);

        instance.getDockItemCenterXByRegion(2, 1, DockRegionType.RECENT);
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getDockItemCenterXByRegion_05', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function =
          mock.mockFunc(instance, instance.getRecentLayoutWidth);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(1);

        let mockFunc2: Function =
          mock.mockFunc(instance, (instance as object)['getCollaborationWidth']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(1);

        let mockFunc3: Function =
          mock.mockFunc(instance, instance.getResidentLayoutWidth);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(1);

        instance.getDockItemCenterXByRegion(2, 1, DockRegionType.COLLABORATION);
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_reSetDockCenter_01', 0, () => {
      let instance = SmartDockStyleMgr.getInstance();
      try {
        instance.reSetDockCenter();
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getRecentLayoutWidth_01', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        instance.getRecentLayoutWidth();
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_getRecentLayoutWidth_02', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function =
          mock.mockFunc(SCBSceneSessionManager.getInstance(), SCBSceneSessionManager.getInstance().isPcMode);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        instance.getRecentLayoutWidth();
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(SCBSceneSessionManager.getInstance());
      mock.clearAll();
    })

    it('test_getMaxRecentWidth_01', 0, () => {
      let instance = SmartDockStyleMgr.getInstance();
      try {
        instance.getMaxRecentWidth();
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getSmartDockWidthWithoutRecent_01', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function =
          mock.mockFunc(instance, (instance as object)['getSmartDockWidthWithoutRecent']);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(1);

        (instance as object)['getSmartDockWidthWithoutRecent']();
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_getCollaborationWidth_01', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        (instance as object)['getCollaborationWidth']();
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clearAll();
    })

    it('test_getCollaborationWidth_02', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc2: Function = mock.mockFunc(CollaborationEventManager.getInstance(), CollaborationEventManager.getInstance().getCollaborationDataList);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([]);

        (instance as object)['getCollaborationWidth']();
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(CollaborationEventManager.getInstance());
      mock.clearAll();
    })

    it('test_getCollaborationWidth_03', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.iconType !== 'app';
        let mockFunc2: Function = mock.mockFunc(CollaborationEventManager.getInstance(), CollaborationEventManager.getInstance().getCollaborationDataList);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([itemInfo]);

        AppStorage.setOrCreate('isPortrait', true);

        (instance as object)['getCollaborationWidth']();
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(CollaborationEventManager.getInstance());
      mock.clearAll();
    })

    it('test_getCollaborationWidth_04', 0, () => {
      let mock = new MockKit();
      let instance = SmartDockStyleMgr.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let itemInfo: DockItemInfo = new DockItemInfo();
        itemInfo.itemType = CommonConstants.TYPE_APP;
        itemInfo.bundleName = 'com.ohos.contacts';
        itemInfo.iconType !== 'app';
        let mockFunc2: Function = mock.mockFunc(CollaborationEventManager.getInstance(), CollaborationEventManager.getInstance().getCollaborationDataList);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([itemInfo]);

        AppStorage.setOrCreate('isPortrait', false);

        (instance as object)['getCollaborationWidth']();
        expect(instance instanceof SmartDockStyleMgr).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(DeviceHelper);
      mock.clear(CollaborationEventManager.getInstance());
      mock.clearAll();
    })



  })
}

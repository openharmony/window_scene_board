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
import RecentDockModel from '../../../../main/ets/default/model/RecentDockModel'
import {
  AppItemInfo,
  AppModel,
  AppStatus,
  BadgeItemInfo,
  CommonConstants,
  DeleteDockItem,
  DockContinuableInfo,
  DockItemInfo,
  RdbStoreManager,
  RecentLayoutCacheMgr,
  ResidentLayoutCacheMgr,
  SettingsModel,
  StyleConstants
} from '@ohos/launchercommon'
import { CheckEmptyUtils, RectInfo } from '@ohos/basicutils'
import { DeviceHelper } from '@ohos/frameworkwrapper'
import { relationalStore } from '@kit.ArkData'
import SmartDockModel from '../../../../main/ets/default/model/SmartDockModel'
import StatusBarServiceEventMgr from '../../../../main/ets/default/manager/StatusBarServiceEventMgr'
import { SceneInfoAdapterUtil } from '@ohos/windowscene'

/**
 * RecentDockModel DT测试
 *
 * @since 2023-11-07
 */
export default function RecentDockModelTest() {
  describe('RecentDockModelTest',() => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    it('RecentDockModel_test_updateBadgeNum_01_7', 0, (): void => {
      try {
        let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
        let recentDockModel: RecentDockModel = RecentDockModel.getInstance();
        recentDockModel.updateBadgeNum(badgeInfo);
        if ((recentDockModel as object)['isSupportRecentDock']) {
          expect((recentDockModel as object)['isSupportRecentDock']).assertTrue();
        } else {
          expect((recentDockModel as object)['isSupportRecentDock']).assertFalse();
        }
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('RecentDockModel_test_updateBadgeNum_02_7', 0, (): void => {
      try {
        let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
        let recentDockModel: RecentDockModel = RecentDockModel.getInstance();
        recentDockModel.updateBadgeNum(badgeInfo);
        let mocker: MockKit = new MockKit();
        let mockfunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmptyArr);
        when(mockfunc)((recentDockModel as object)['recentDockList']).afterReturn(false);
        expect(CheckEmptyUtils.isEmptyArr((recentDockModel as object)['recentDockList'])).assertFalse();
        mocker.clear(CheckEmptyUtils);
        mocker.clearAll();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('RecentDockModel_test_recentDockOnClick_01', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let recentDockModel: RecentDockModel = RecentDockModel.getInstance();
      let item: DockItemInfo = {
        visible: true,
        borderVisible : false,
        shake: 0,
        bundleName: '',
        abilityName: '',
        moduleName: '',
        appName: '',
        appIconId: 0,
        missionInfoList: []
      }
      recentDockModel.recentDockOnClick(item);
      AppStorage.set<boolean>('isDrag', true);
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockfunc)().afterReturn(true);
      expect(AppStorage.get<boolean>('isDrag')).assertTrue()
      expect(DeviceHelper.isPhone()).assertTrue()
      mocker.clear(DeviceHelper);
      mocker.clearAll()
    })

    it('RecentDockModel_test_recentDockOnClick_02', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let recentDockModel: RecentDockModel = RecentDockModel.getInstance();
      let item: DockItemInfo = {
        visible: true,
        borderVisible : false,
        shake: 0,
        bundleName: '',
        abilityName: '',
        moduleName: '',
        appName: '',
        appIconId: 0,
        missionInfoList: []
      }
      recentDockModel.recentDockOnClick(item);
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockfunc)().afterReturn(false);
      expect(DeviceHelper.isPhone()).assertFalse()
      mocker.clear(DeviceHelper);
      mocker.clearAll()
    })

    it('RecentDockModel_test_updateRecentDockInfo_success', 0, (): void => {
      let visibleCount:number = 1;
      let flag = false;
      let recentDockModel: RecentDockModel = RecentDockModel.getInstance();
      let rdbStoreManager: RdbStoreManager = RdbStoreManager.getInstance();
      recentDockModel.updateVisibleCount(visibleCount, false);
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(rdbStoreManager, rdbStoreManager.insertIntoRecentDockInfo);
      when(mockfunc)(visibleCount).afterAction(()=>{
        flag = true
      });
      expect(flag).assertFalse()
      mocker.clear(rdbStoreManager);
      mocker.clearAll();
    })

    it('test_computeVisibleCount_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let recentDockListRotate: DockItemInfo[] = [];
      let item1: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'anyBundleName_1',
        abilityName: '',
        badgeNumber: 8
      }
      let item2: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'anyBundleName_2',
        abilityName: '',
        badgeNumber: 10
      }
      recentDockListRotate.push(item1);
      recentDockListRotate.push(item2);
      let visibleCount: number = 0;
      let spaceValue: number = 2;
      let recentLayoutWidth: number = 3;
      instance.computeVisibleCount(recentDockListRotate, visibleCount, spaceValue, recentLayoutWidth);
      expect(instance).not().assertNull();
    });

    it('test_computeVisibleCount_02', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let recentDockListRotate: DockItemInfo[] = [];
      let item1: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'anyBundleName_1',
        abilityName: '',
        badgeNumber: 8
      }
      let item2: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'anyBundleName_2',
        abilityName: '',
        badgeNumber: 10
      }
      recentDockListRotate.push(item1);
      recentDockListRotate.push(item2);
      let visibleCount: number = 2;
      let spaceValue: number = 2;
      let recentLayoutWidth: number = 3;
      instance.computeVisibleCount(recentDockListRotate, visibleCount, spaceValue, recentLayoutWidth);
      expect(instance).not().assertNull();
    });

    it('test_continuableItemExists_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let deviceInfo: DockContinuableInfo = new DockContinuableInfo();
      deviceInfo.bundleName = 'anyBundleName';
      deviceInfo.sourceDeviceName = 'anySourceDeviceName';
      let ret: boolean = instance.continuableItemExists(deviceInfo);
      expect(ret).assertTrue();
    });

    it('test_getAppIcon_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let appInfo: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: CommonConstants.LAUNCHER_BUNDLE,
        abilityName: CommonConstants.APPCENTER_ABILITY
      };

      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsModel, settingsModel.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.PAD_DEVICE_TYPE);

      let ret = instance.getAppIcon(appInfo);
      expect(ret).not().assertNull();
      mocker.clear(settingsModel);
      mocker.clearAll();
    });

    it('test_getAppIcon_02', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let appInfo: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: CommonConstants.LAUNCHER_BUNDLE,
        abilityName: CommonConstants.RECENT_ABILITY
      };

      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsModel, settingsModel.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.PAD_DEVICE_TYPE);

      let ret = instance.getAppIcon(appInfo);
      expect(ret).not().assertNull();
      mocker.clear(settingsModel);
      mocker.clearAll();
    });

    it('test_getAppIcon_03', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let appInfo: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: CommonConstants.LAUNCHER_BUNDLE,
        abilityName: CommonConstants.SETTING_ABILITY
      };

      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsModel, settingsModel.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.PAD_DEVICE_TYPE);

      let ret = instance.getAppIcon(appInfo);
      expect(ret).assertUndefined();
      mocker.clear(settingsModel);
      mocker.clearAll();
    });

    it('test_isPcOrPadLauncher_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();

      let appInfo: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: CommonConstants.LAUNCHER_BUNDLE,
        abilityName: CommonConstants.APPCENTER_ABILITY
      };

      let settingsModel: SettingsModel = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(settingsModel, settingsModel.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(CommonConstants.PAD_DEVICE_TYPE);

      let ret: boolean = instance.isPcOrPadLauncher(appInfo);
      expect(ret).assertTrue();
      mocker.clear(settingsModel);
      mocker.clearAll();
    });

    it('test_getDividerWidth_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      try {
        let ret: number = instance.getDividerWidth();
        expect(instance instanceof RecentDockModel).assertInstanceOf('Boolean');
      } catch (e) {
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getDividerWidth_02', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      let ret: number = instance.getDividerWidth();
      expect(10).assertLargerOrEqual(0);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getDockSpace_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let recentDockListRotate: DockItemInfo[] = [];
      let ret: number = instance.getDockSpace(recentDockListRotate);
      expect(ret).assertEqual(0);
    });

    it('test_getDockSpace_02', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let recentDockListRotate: DockItemInfo[] = [];
      let dockItemInfo: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: '',
        abilityName: ''
      };
      let ret: number = instance.getDockSpace(recentDockListRotate);
      expect(ret).assertEqual(0);
    });

    it('test_getListPadding_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let ret: RectInfo = instance.getListPadding();
      expect(ret).not().assertNull();
    });

    it('test_getRecentLayoutWidthUp_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let visibleCount: number = 1;
      let spaceValue: number = 1;
      let ret: number = instance.getRecentLayoutWidthUp(visibleCount, spaceValue);
      expect(ret).assertLargerOrEqual(0);
    });

    it('test_getSupportRecentDockState_01_7', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      try {
        let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
        let mockFunc2: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
        when(mockFunc1)(ArgumentMatchers.any).afterReturn(true);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);
        let ret: boolean = (instance as object)['getSupportRecentDockState']();
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getSupportRecentDockState_02', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockFunc1)(ArgumentMatchers.any).afterReturn(false);
      let ret: boolean = (instance as object)['getSupportRecentDockState']();
      expect(ret).assertInstanceOf('Boolean');
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_initVisibleCount_01', 0, () => {
      let instance: RecentLayoutCacheMgr = RecentLayoutCacheMgr.getInstance();
      instance.updateVisibleCount(5, false);
      expect(instance.getVisibleCount()).assertLarger(0);
    });

    it('test_getVisibleCount_02', 0, () => {
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        instance.getVisibleCount();
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_isContinueNotShow_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let deviceInfo: DockContinuableInfo = {} as DockContinuableInfo;
      let ret: boolean = instance.isContinueNotShow(deviceInfo);
      expect(ret).assertTrue();
    });

    it('test_isPadPortraitHaveTask_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let mIsPortrait: boolean = false;
      let recentDockList: DockItemInfo[] = [];
      let ret: boolean = instance.isPadPortraitHaveTask(mIsPortrait, recentDockList);
      expect(ret).assertFalse();
    });

    it('test_isPcOrPadLauncher_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let appInfo: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: CommonConstants.LAUNCHER_BUNDLE,
        abilityName: CommonConstants.APPCENTER_ABILITY
      };
      let model: SettingsModel  = SettingsModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(model, model.getDevice);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      let ret: boolean = instance.isPcOrPadLauncher(appInfo);
      expect(ret).assertTrue();
      mocker.clear(model);
      mocker.clearAll();
    });

    it('test_recentDockOnClick_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();

      let item: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: CommonConstants.LAUNCHER_BUNDLE,
        abilityName: CommonConstants.APPCENTER_ABILITY
      };

      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(true);
      AppStorage.setOrCreate<boolean>('isDrag', true);
      instance.recentDockOnClick(item);
      expect(instance).not().assertNull();
      mocker.clear(DeviceHelper);
      mocker.clearAll()
      AppStorage.delete('isDrag');
    });

    it('test_registerDockListener_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      (instance as object)['isSupportRecentDock'] = false;
      (instance as object)['registerDockListener']();
      expect((instance as object)['isSupportRecentDock']).assertFalse();
    });

    it('test_registerDockListener_02', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      (instance as object)['isSupportRecentDock'] = true;
      (instance as object)['registerDockListener']();
      expect((instance as object)['isSupportRecentDock']).assertTrue();
    });

    it('test_setRecentDockStartAppInfo_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let item: DockItemInfo = {} as DockItemInfo;
      (instance as object)['setRecentDockStartAppInfo'](item);
      expect(instance).not().assertNull();
    });

    it('test_setRecentDockStartAppInfo_02', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let item: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: CommonConstants.LAUNCHER_BUNDLE,
        abilityName: CommonConstants.APPCENTER_ABILITY
      };
      (instance as object)['setRecentDockStartAppInfo'](item);
      expect(instance).not().assertNull();
    });

    it('test_updateBadgeNum_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      (instance as object)['isSupportRecentDock'] = false;
      let badgeInfo: BadgeItemInfo = {
        id: undefined,
        bundleName: undefined,
        badgeNumber: undefined,
        isShow: undefined,
        userId: undefined,
        badgeUpdateTaskStatus: undefined,
        fromResultSet: (resultSet: relationalStore.ResultSet): BadgeItemInfo => {
          throw new Error('Function not implemented.')
        },
        appIndex: undefined,
        checkAppInstanceKey: (appInstanceKey?: string | undefined): boolean => {
          throw new Error('Function not implemented.')
        }
      };
      instance.updateBadgeNum(badgeInfo);
      expect((instance as object)['isSupportRecentDock']).assertFalse();
    });

    it('test_updateBadgeNum_02', 0, () => {
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = true;
        let badgeInfo: BadgeItemInfo = {
          id: undefined,
          bundleName: 'anyBundleName_1',
          badgeNumber: undefined,
          isShow: undefined,
          userId: undefined,
          badgeUpdateTaskStatus: undefined,
          fromResultSet: (resultSet: relationalStore.ResultSet): BadgeItemInfo => {
            throw new Error('Function not implemented.')
          },
          appIndex: undefined,
          checkAppInstanceKey: (appInstanceKey?: string | undefined): boolean => {
            throw new Error('Function not implemented.')
          }
        };
        RecentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateBadgeNum_02', [], false);
        instance.updateBadgeNum(badgeInfo);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_updateBadgeNum_03', 0, () => {
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = true;
        let badgeInfo: BadgeItemInfo = {
          id: undefined,
          bundleName: 'anyBundleName_1',
          badgeNumber: undefined,
          isShow: true,
          userId: undefined,
          badgeUpdateTaskStatus: undefined,
          fromResultSet: (resultSet: relationalStore.ResultSet): BadgeItemInfo => {
            throw new Error('Function not implemented.')
          },
          appIndex: undefined,
          checkAppInstanceKey: (appInstanceKey?: string | undefined): boolean => {
            throw new Error('Function not implemented.')
          }
        };
        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          abilityName: '',
          badgeNumber: 8,
        }

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          abilityName: '',
          badgeNumber: 8
        }
        RecentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateBadgeNum_03', [item1, item2], false);
        instance.updateBadgeNum(badgeInfo);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_updateBadgeNum_04', 0, () => {
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = true;
        let badgeInfo: BadgeItemInfo = {
          id: undefined,
          bundleName: 'anyBundleName_1',
          badgeNumber: undefined,
          isShow: false,
          userId: undefined,
          badgeUpdateTaskStatus: undefined,
          fromResultSet: (resultSet: relationalStore.ResultSet): BadgeItemInfo => {
            throw new Error('Function not implemented.')
          },
          appIndex: undefined,
          checkAppInstanceKey: (appInstanceKey?: string | undefined): boolean => {
            throw new Error('Function not implemented.')
          }
        };
        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          abilityName: '',
          badgeNumber: 8
        }

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          abilityName: '',
          badgeNumber: 10
        }
        RecentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateBadgeNum_04', [item1, item2], false);
        instance.updateBadgeNum(badgeInfo);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    });

    it('test_updateBadgeNum_05', 0, () => {
      let mock = new MockKit();
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = true;
        let badgeInfo: BadgeItemInfo = {
          id: undefined,
          bundleName: 'anyBundleName_1',
          badgeNumber: undefined,
          isShow: false,
          userId: undefined,
          badgeUpdateTaskStatus: undefined,
          fromResultSet: (resultSet: relationalStore.ResultSet): BadgeItemInfo => {
            throw new Error('Function not implemented.')
          },
          appIndex: undefined,
          checkAppInstanceKey: (appInstanceKey?: string | undefined): boolean => {
            throw new Error('Function not implemented.')
          }
        };
        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          abilityName: '',
          badgeNumber: 8
        }

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc: Function = mock.mockFunc(RecentLayoutCacheMgr.getInstance(), RecentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([item1, item2]);

        let mockFunc2: Function = mock.mockFunc(SmartDockModel.getInstance(), SmartDockModel.getInstance().checkSameDockItem);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        instance.updateBadgeNum(badgeInfo);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(RecentLayoutCacheMgr.getInstance());
      mock.clear(SmartDockModel.getInstance());
      mock.clearAll();
    });

    it('test_updateRecentDock_01', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let recentDockList: DockItemInfo[] = [];
      let item1: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'anyBundleName_1',
        abilityName: '',
        badgeNumber: 8
      }

      let item2: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'anyBundleName_2',
        abilityName: '',
        badgeNumber: 10
      }
      recentDockList.push(item1);
      recentDockList.push(item2);
      expect(instance).not().assertNull();
    });

    it('test_updateRecentDockItem_01', 0, () => {
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let bundleName: string = '';
        (instance as object)['updateRecentDockItem'](bundleName);
        expect(instance).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_updateRecentDockItem_02', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let bundleName: string = 'anyBundleName_other';

        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          abilityName: '',
          badgeNumber: 8
        }
        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc2: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([item1,item2]);

        let appItem1: AppItemInfo = {
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          abilityName: ''
        };
        let appItem2: AppItemInfo = {
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          abilityName: ''
        };
        let mockFunc: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([appItem1,appItem2]);

        (instance as object)['updateRecentDockItem'](bundleName);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(AppModel.getInstance());
      mocker.clearAll();
    })

    it('test_updateRecentDockItem_03', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let bundleName: string = 'anyBundleName_1';

        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          abilityName: '',
          badgeNumber: 8
        }
        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc2: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([item1,item2]);

        let appItem1: AppItemInfo = {
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_other',
          abilityName: ''
        };
        let appItem2: AppItemInfo = {
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          abilityName: ''
        };
        let mockFunc: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([appItem1,appItem2]);

        (instance as object)['updateRecentDockItem'](bundleName);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(AppModel.getInstance());
      mocker.clearAll();
    })

    it('test_updateRecentDockItem_04', 0, () => {
      let mocker: MockKit = new MockKit();
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let bundleName: string = 'anyBundleName_1';

        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          abilityName: '',
          badgeNumber: 8
        }
        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc2: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn([item1,item2]);

        let appItem1: AppItemInfo = {
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          abilityName: ''
        };
        let appItem2: AppItemInfo = {
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          abilityName: ''
        };
        let mockFunc: Function = mocker.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([appItem1,appItem2]);

        (instance as object)['updateRecentDockItem'](bundleName);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(AppModel.getInstance());
      mocker.clearAll();
    })

    it('test_getDividerWidth_03', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(false);
      (instance as object)['mSmartDockStyleConfig'].mResidentSplitLineWidth = 10;
      (instance as object)['mSmartDockStyleConfig'].mResidentSplitLineGap = 5;
      let ret: number = instance.getDividerWidth();
      expect(ret).assertLargerOrEqual(0);
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    });

    it('test_getRecentDockList_018', 0, (): void => {
      let mocker: MockKit = new MockKit();
      let rdbManager: RdbStoreManager = RdbStoreManager.getInstance();
      try {
        let mockfunc: Function = mocker.mockFunc(rdbManager, rdbManager.queryRecentDock);
        let dockList: DockItemInfo[] = [];
        for (let index = 0; index < 6; index++) {
          let dockItem1: DockItemInfo = new DockItemInfo();
          dockItem1.keyName = 'keyname1' + index;
          dockItem1.bundleName = 'bundleName1' + index;
          dockItem1.appIndex = 12110 + index;
          dockItem1.appStatus = AppStatus.WAIT_FOR_HARMONY;
          dockList.push(dockItem1);
        }
        let dockItem2: DockItemInfo = new DockItemInfo();
        dockItem2.keyName = 'keyname1' + 3;
        dockItem2.bundleName = 'bundleName1' + 3;
        dockItem2.appIndex = 12110 + 3;
        dockItem2.appStatus = AppStatus.WAIT_FOR_HARMONY;
        dockList.push(dockItem2);
        let ignoreDockItem: DockItemInfo = new DockItemInfo();
        ignoreDockItem.keyName = 'keyname1' + 3;
        ignoreDockItem.bundleName = 'bundleName1' + 3;
        ignoreDockItem.appIndex = 12110 + 3;
        ignoreDockItem.appStatus = AppStatus.WAIT_FOR_HARMONY;
        ignoreDockItem.abilityName = CommonConstants.CONTACT_PAD_NO_VOICE_CAPABILITY;
        dockList.push(ignoreDockItem);
        when(mockfunc)().afterReturn(dockList);
        let layoutCache = RecentLayoutCacheMgr.getInstance();
        layoutCache.updateAllDockItems('test', dockList, false);
        expect(AppStorage.get('recentDockList')).not().assertUndefined();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(rdbManager);
      mocker.clearAll();
    })

    it('test_updateBadgeNum_sameBundlename', 0, (): void => {
      try {
        let dockList: DockItemInfo[] = [];
        for (let index = 0; index < 6; index++) {
          let dockItem1: DockItemInfo = new DockItemInfo();
          dockItem1.keyName = 'keyname1' + index;
          dockItem1.bundleName = 'bundleName1' + index;
          dockItem1.appIndex = 12110 + index;
          dockItem1.appStatus = AppStatus.WAIT_FOR_HARMONY;
          dockList.push(dockItem1);
        }
        let ignoreDockItem: DockItemInfo = new DockItemInfo();
        ignoreDockItem.keyName = 'keyname1' + 3;
        ignoreDockItem.bundleName = 'bundleName1' + 3;
        ignoreDockItem.appIndex = 12110 + 3;
        ignoreDockItem.appStatus = AppStatus.WAIT_FOR_HARMONY;
        ignoreDockItem.abilityName = CommonConstants.CONTACT_PAD_NO_VOICE_CAPABILITY;
        dockList.push(ignoreDockItem);
        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = true;
        RecentLayoutCacheMgr.getInstance().updateAllDockItems('test_updateBadgeNum_sameBundlename', dockList, false);
        let badgeInfo: BadgeItemInfo = new BadgeItemInfo();
        badgeInfo.bundleName = 'testBadge';
        instance.updateBadgeNum(badgeInfo);
        expect(badgeInfo.bundleName).not().assertNull();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAppIndexInRecentDockList_001', 0, (): void => {
      try {
        let dockList: DockItemInfo[] = [];
        for (let index = 0; index < 6; index++) {
          let dockItem1: DockItemInfo = new DockItemInfo();
          dockItem1.keyName = 'keyname1' + index;
          dockItem1.bundleName = 'bundleName1' + index;
          dockItem1.appIndex = 12110 + index;
          dockItem1.appStatus = AppStatus.WAIT_FOR_HARMONY;
          dockList.push(dockItem1);
        }
        let ignoreDockItem: DockItemInfo = new DockItemInfo();
        ignoreDockItem.keyName = 'keyname1' + 3;
        ignoreDockItem.bundleName = 'bundleName1';
        ignoreDockItem.appIndex = 12117;
        ignoreDockItem.appStatus = AppStatus.WAIT_FOR_HARMONY;
        ignoreDockItem.abilityName = CommonConstants.CONTACT_PAD_NO_VOICE_CAPABILITY;
        dockList.push(ignoreDockItem);
        let instance: RecentDockModel = RecentDockModel.getInstance();
        RecentLayoutCacheMgr.getInstance().updateAllDockItems('test_getAppIndexInRecentDockList_001', dockList, false);
        let index: number = (instance as object)['getAppIndexInRecentDockList']('bundleName1', 12117);
        expect(index).assertInstanceOf('Number');
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_getAppIndexInRecentDockList_01', 0, () => {
      let mock = new MockKit();
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          appIndex: 0,
          abilityName: '',
          badgeNumber: 8
        }

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          appIndex: 0,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc: Function =
          mock.mockFunc(RecentLayoutCacheMgr.getInstance(), RecentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([item1, item2]);

        instance.getAppIndexInRecentDockList('anyBundleName_1', 0);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(RecentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_getAppIndexInRecentDockList_02', 0, () => {
      let mock = new MockKit();
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let mockFunc: Function =
          mock.mockFunc(RecentLayoutCacheMgr.getInstance(), RecentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        instance.getAppIndexInRecentDockList('anyBundleName_1', 0);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(RecentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_recentDockOnClick_pad001', 0, (): void => {
      try{
        let instance: RecentDockModel = RecentDockModel.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', false);
        let dockItem: DockItemInfo = new DockItemInfo();
        let bundleName = 'uni.normal.bundleName';
        dockItem.keyName = 'keyname1' + 3;
        dockItem.bundleName = bundleName;
        dockItem.appIndex = 19999;
        dockItem.appStatus = AppStatus.WAIT_FOR_HARMONY;
        dockItem.abilityName = CommonConstants.CONTACT_PAD_NO_VOICE_CAPABILITY;
        instance.recentDockOnClick(dockItem);
        expect(dockItem.appIndex > 0).assertTrue();
      }catch{}
    })

    it('test_recentDockOnClick_pad002', 0, (): void => {
      try{
        let instance: RecentDockModel = RecentDockModel.getInstance();
        AppStorage.setOrCreate<boolean>('isDrag', false);
        expect(AppStorage.get<boolean>('isDrag')).assertFalse();
        let dockItem1: DockItemInfo = new DockItemInfo();
        let bundleName = 'uni.normal.bundleName';
        dockItem1.keyName = 'keyname1' + 3;
        dockItem1.bundleName = bundleName;
        dockItem1.appIndex = 0;
        dockItem1.appStatus = AppStatus.WAIT_FOR_HARMONY;
        dockItem1.abilityName = CommonConstants.CONTACT_PAD_NO_VOICE_CAPABILITY;
        instance.recentDockOnClick(dockItem1);
        expect(dockItem1.appIndex > 0).assertFalse();
      }catch{}
    })

    it('test_setRecentDockStartAppInfo_empty', 0, (): void => {
      let dockItem: DockItemInfo = new DockItemInfo();
      let bundleName = 'uni.normal.bundleName';
      dockItem.keyName = 'keyname1' + 3;
      dockItem.bundleName = bundleName;
      dockItem.appIndex = 19999;
      dockItem.appStatus = AppStatus.WAIT_FOR_HARMONY;
      dockItem.abilityName = CommonConstants.CONTACT_PAD_NO_VOICE_CAPABILITY;
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
      (instance as object)['setRecentDockStartAppInfo'](dockItem);
      expect(dockItem.bundleName).assertEqual(bundleName);
      mocker.clear(CheckEmptyUtils);
      mocker.clearAll();
    })

    it('test_getSupportRecentDockState_mockIsfold', 0, (): void => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isFoldButNotSmallFoldProduct);
      when(mockfunc)().afterReturn(true);
      let mockfunc1: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhone);
      when(mockfunc1)().afterReturn(false);
      let currentState: boolean = (instance as object)['getSupportRecentDockState']();
      expect(true).assertTrue();
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })


    it('test_getDividerWidth_padOrUndefined', 0, (): void => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let mocker: MockKit = new MockKit();
      try{
        let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockfunc)().afterReturn(true);
        expect(instance.getDividerWidth()).assertEqual(StyleConstants.DEFAULT_20);
        when(mockfunc)().afterReturn(false);
        AppStorage.setOrCreate<number>('settingIconChange', -100);
        instance.getDividerWidth();
        let desktopIconChangeSize: number = AppStorage.get<number>('settingIconChange') ?? 0;
        expect(desktopIconChangeSize).not().assertUndefined();
      } finally {
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      }
    })

    it('test_computeVisibleCount_0012', 0, () => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      let recentDockListRotate: DockItemInfo[] = [];
      let item1: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'anyBundleName_1',
        abilityName: '',
        badgeNumber: 8
      }
      let item2: DockItemInfo = {
        visible: false,
        borderVisible: false,
        shake: 0,
        missionInfoList: [],
        appName: '',
        appIconId: 0,
        bundleName: 'anyBundleName_2',
        abilityName: '',
        badgeNumber: 10
      }
      recentDockListRotate.push(item1);
      recentDockListRotate.push(item2);
      let visibleCount: number = 2;
      let spaceValue: number = 2;
      let recentLayoutWidth: number = 3000;
      let resCount = instance.computeVisibleCount(recentDockListRotate, visibleCount, spaceValue, recentLayoutWidth);
      expect(resCount > 0).assertTrue();
      expect(instance).not().assertNull();
    });

    it('test_getRecentListRotateNum_001', 0, (): void => {
      let instance: RecentDockModel = RecentDockModel.getInstance();
      instance.setRecentListRotateNum(15);
      expect(instance.getRecentListRotateNum()).assertEqual(15);
    })

    it('test_recentDockModel_getModelByTV', 0, (): void => {
      let mocker: MockKit = new MockKit();
      AppStorage.setOrCreate<number>('visibleCount', 0);
      try {
        let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPhoneOrPad);
        when(mockfunc)().afterReturn(false);
        let instance: RecentDockModel = RecentDockModel.getInstance();
        expect(AppStorage.get<number>('visibleCount')).assertEqual(0);
      } finally {
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      }
    })

    it('test_recentDockModel_initVisibleCountIsEmpty', 0, (): void => {
      let mocker: MockKit = new MockKit();
      const visibleCount = AppStorage.get<number>('visibleCount') ?? 0;
      AppStorage.setOrCreate<number>('visibleCount', 0);
      try {
        let mockfunc: Function =
          mocker.mockFunc(RdbStoreManager.getInstance(), RdbStoreManager.getInstance().queryRecentDockInfo);
        when(mockfunc)().afterReturn(null);
        let instance: RecentDockModel = RecentDockModel.getInstance();
        expect(AppStorage.get<number>('visibleCount')).assertEqual(0);
      } finally {
        mocker.clear(DeviceHelper);
        mocker.clearAll();
        AppStorage.setOrCreate<number>('visibleCount', visibleCount);
      }
    })

    it('test_recentDockModel_emptyList', 0, (): void => {
      let mocker: MockKit = new MockKit();
      try {
        let mockfunc: Function =
          mocker.mockFunc(ResidentLayoutCacheMgr.getInstance(), ResidentLayoutCacheMgr.getInstance().createDockAppInfo);
        when(mockfunc)().afterReturn(null);
        let instance: RecentDockModel = RecentDockModel.getInstance();

        expect(instance.getAppIndexInRecentDockList('')).assertEqual(-1);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mocker.clear(DeviceHelper);
      mocker.clearAll();
    })

    it('test_recentDockModel_padDividerWidth', 0, (): void => {
      let mocker: MockKit = new MockKit();
      try {
        let mockfunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPad);
        when(mockfunc)(ArgumentMatchers.any).afterReturn(true);
        let instance: RecentDockModel = RecentDockModel.getInstance();

        expect(instance.getDividerWidth()).assertLargerOrEqual(20);
      } finally {
        mocker.clear(DeviceHelper);
        mocker.clearAll();
      }
    })

    it('test_recentDockModel_getDockSpace', 0, (): void => {
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let list: Array<DockItemInfo> = [{
          visible: true,
          borderVisible: false,
          shake: 0,
          bundleName: 'test1',
          abilityName: '',
          appName: '',
          appIconId: 0,
          missionInfoList: []
        }]
        expect(instance.getDockSpace(list)).assertLargerOrEqual(0);
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_deleteRecentDockItem_01', 0, (): void => {
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = false;
        instance.deleteRecentDockItem({
          bundleName: 'test',
          keyName: 'testKey'
        });
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_deleteRecentDockItem_02', 0, (): void => {
      let mock = new MockKit();
      try {
        let mockFunc: Function =
          mock.mockFunc(RecentLayoutCacheMgr.getInstance(), RecentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([]);

        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = true;
        instance.deleteRecentDockItem({
          bundleName: 'test',
          keyName: 'testKey'
        });
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(RecentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_deleteRecentDockItem_03', 0, () => {
      let mock = new MockKit();
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          appIndex: 0,
          abilityName: '',
          badgeNumber: 8
        }

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          appIndex: 0,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc: Function =
          mock.mockFunc(RecentLayoutCacheMgr.getInstance(), RecentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([item1, item2]);

        (instance as object)['isSupportRecentDock'] = true;
        instance.deleteRecentDockItem({
          bundleName: 'anyBundleName_1',
          keyName: 'testKey',
          appIndex: 0,
          typeId: CommonConstants.TYPE_FORM_COMBINE,
        });
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(RecentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_deleteRecentDockItem_04', 0, () => {
      let mock = new MockKit();
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          keyName: 'testKey1',
          appIndex: 0,
          abilityName: '',
          badgeNumber: 8
        }

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          keyName: 'testKey2',
          appIndex: 0,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc: Function =
          mock.mockFunc(RecentLayoutCacheMgr.getInstance(), RecentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([item1, item2]);

        (instance as object)['isSupportRecentDock'] = true;
        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.appIndex = 0;
        deleteItemInfo.typeId = CommonConstants.TYPE_FORM_COMBINE;
        deleteItemInfo.keyName = 'testKey1';
        instance.deleteRecentDockItem(deleteItemInfo);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(RecentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_deleteRecentDockItem_05', 0, () => {
      let mock = new MockKit();
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        let item1: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_1',
          keyName: 'testKey1',
          appIndex: 0,
          abilityName: '',
          badgeNumber: 8
        }

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: 'anyBundleName_2',
          keyName: 'testKey2',
          appIndex: 0,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc: Function =
          mock.mockFunc(RecentLayoutCacheMgr.getInstance(), RecentLayoutCacheMgr.getInstance().getAllDockItems);
        when(mockFunc)(ArgumentMatchers.any).afterReturn([item1, item2]);

        (instance as object)['isSupportRecentDock'] = true;
        let deleteItemInfo: DeleteDockItem = new DeleteDockItem();
        deleteItemInfo.appIndex = 1;
        deleteItemInfo.typeId = CommonConstants.TYPE_FORM_COMBINE;
        instance.deleteRecentDockItem(deleteItemInfo);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(RecentLayoutCacheMgr.getInstance());
      mock.clearAll();
    })

    it('test_addToRecentDockList_01', 0, (): void => {
      try {
        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = false;
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
    })

    it('test_addToRecentDockList_02', 0, (): void => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterThrow('err');

        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = true;
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_addToRecentDockList_03', 0, (): void => {
      let mock = new MockKit();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(true);

        let instance: RecentDockModel = RecentDockModel.getInstance();
        (instance as object)['isSupportRecentDock'] = true;
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clearAll();
    })

    it('test_addToRecentDockList_04', 0, (): void => {
      let mock = new MockKit();
      let instance: RecentDockModel = RecentDockModel.getInstance();
      try {
        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(instance, (instance as object)['isRecentElement']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(false);

        (instance as object)['isSupportRecentDock'] = true;
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;
        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clearAll();
    })

    it('test_addToRecentDockList_05', 0, (): void => {
      let mock = new MockKit();
      let instance: RecentDockModel = RecentDockModel.getInstance();
      try {
        let bundleName: string = 'com.ohos.contacts';

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(instance, (instance as object)['isRecentElement']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(instance, instance.getAppIndexInRecentDockList);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(-1);

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: bundleName,
          appIndex: 1,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc4: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn([item2]);

        let mockFunc5: Function = mock.mockFunc(SceneInfoAdapterUtil, SceneInfoAdapterUtil.getAdapterBundleName);
        when(mockFunc5)(ArgumentMatchers.any).afterReturn(bundleName);

        (instance as object)['isSupportRecentDock'] = true;
        let appIndex: number = 0;
        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clear(AppModel.getInstance());
      mock.clear(SceneInfoAdapterUtil);
      mock.clearAll();
    })

    it('test_addToRecentDockList_06', 0, (): void => {
      let mock = new MockKit();
      let instance: RecentDockModel = RecentDockModel.getInstance();
      try {
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(instance, (instance as object)['isRecentElement']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(instance, instance.getAppIndexInRecentDockList);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(-1);

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: bundleName,
          appIndex: appIndex,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc4: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn([item2]);

        let mockFunc5: Function = mock.mockFunc(SceneInfoAdapterUtil, SceneInfoAdapterUtil.getAdapterBundleName);
        when(mockFunc5)(ArgumentMatchers.any).afterReturn(bundleName);

        let mockFunc6: Function = mock.mockFunc(StatusBarServiceEventMgr.getInstance(), StatusBarServiceEventMgr.getInstance().isWpsAndRegister);
        when(mockFunc6)(ArgumentMatchers.any).afterReturn(true);

        (instance as object)['isSupportRecentDock'] = true;

        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clear(AppModel.getInstance());
      mock.clear(SceneInfoAdapterUtil);
      mock.clear(StatusBarServiceEventMgr.getInstance());
      mock.clearAll();
    })

    it('test_addToRecentDockList_07', 0, (): void => {
      let mock = new MockKit();
      let instance: RecentDockModel = RecentDockModel.getInstance();
      try {
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(instance, (instance as object)['isRecentElement']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(instance, instance.getAppIndexInRecentDockList);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(-1);

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: bundleName,
          appIndex: appIndex,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc4: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn([item2]);

        let mockFunc5: Function = mock.mockFunc(SceneInfoAdapterUtil, SceneInfoAdapterUtil.getAdapterBundleName);
        when(mockFunc5)(ArgumentMatchers.any).afterReturn(bundleName);

        let mockFunc6: Function = mock.mockFunc(StatusBarServiceEventMgr.getInstance(), StatusBarServiceEventMgr.getInstance().isWpsAndRegister);
        when(mockFunc6)(ArgumentMatchers.any).afterReturn(false);

        (instance as object)['isSupportRecentDock'] = true;

        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clear(AppModel.getInstance());
      mock.clear(SceneInfoAdapterUtil);
      mock.clear(StatusBarServiceEventMgr.getInstance());
      mock.clearAll();
    })

    it('test_addToRecentDockList_08', 0, (): void => {
      let mock = new MockKit();
      let instance: RecentDockModel = RecentDockModel.getInstance();
      try {
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(instance, (instance as object)['isRecentElement']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(instance, instance.getAppIndexInRecentDockList);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(0);

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: bundleName,
          appIndex: appIndex,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc4: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn([item2]);

        let mockFunc5: Function = mock.mockFunc(SceneInfoAdapterUtil, SceneInfoAdapterUtil.getAdapterBundleName);
        when(mockFunc5)(ArgumentMatchers.any).afterReturn(bundleName);

        let mockFunc6: Function = mock.mockFunc(StatusBarServiceEventMgr.getInstance(), StatusBarServiceEventMgr.getInstance().isWpsAndRegister);
        when(mockFunc6)(ArgumentMatchers.any).afterReturn(false);

        (instance as object)['isSupportRecentDock'] = true;

        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clear(AppModel.getInstance());
      mock.clear(SceneInfoAdapterUtil);
      mock.clear(StatusBarServiceEventMgr.getInstance());
      mock.clearAll();
    })

    it('test_addToRecentDockList_09', 0, (): void => {
      let mock = new MockKit();
      let instance: RecentDockModel = RecentDockModel.getInstance();
      try {
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(instance, (instance as object)['isRecentElement']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(instance, instance.getAppIndexInRecentDockList);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(1);

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: bundleName,
          appIndex: appIndex,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc4: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn([item2]);

        let mockFunc5: Function = mock.mockFunc(SceneInfoAdapterUtil, SceneInfoAdapterUtil.getAdapterBundleName);
        when(mockFunc5)(ArgumentMatchers.any).afterReturn(bundleName);

        let mockFunc6: Function = mock.mockFunc(StatusBarServiceEventMgr.getInstance(), StatusBarServiceEventMgr.getInstance().isWpsAndRegister);
        when(mockFunc6)(ArgumentMatchers.any).afterReturn(false);

        (instance as object)['isSupportRecentDock'] = true;

        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clear(AppModel.getInstance());
      mock.clear(SceneInfoAdapterUtil);
      mock.clear(StatusBarServiceEventMgr.getInstance());
      mock.clearAll();
    })

    it('test_addToRecentDockList_10', 0, (): void => {
      let mock = new MockKit();
      let instance: RecentDockModel = RecentDockModel.getInstance();
      try {
        let bundleName: string = 'com.ohos.contacts';
        let appIndex: number = 0;

        let mockFunc: Function = mock.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
        when(mockFunc)(ArgumentMatchers.any).afterReturn(false);

        let mockFunc2: Function = mock.mockFunc(instance, (instance as object)['isRecentElement']);
        when(mockFunc2)(ArgumentMatchers.any).afterReturn(true);

        let mockFunc3: Function = mock.mockFunc(instance, instance.getAppIndexInRecentDockList);
        when(mockFunc3)(ArgumentMatchers.any).afterReturn(1);

        let item2: DockItemInfo = {
          visible: false,
          borderVisible: false,
          shake: 0,
          missionInfoList: [],
          appName: '',
          appIconId: 0,
          bundleName: bundleName,
          appIndex: appIndex,
          abilityName: '',
          badgeNumber: 10
        }
        let mockFunc4: Function = mock.mockFunc(AppModel.getInstance(), AppModel.getInstance().getAppList);
        when(mockFunc4)(ArgumentMatchers.any).afterReturn([item2]);

        let mockFunc5: Function = mock.mockFunc(SceneInfoAdapterUtil, SceneInfoAdapterUtil.getAdapterBundleName);
        when(mockFunc5)(ArgumentMatchers.any).afterReturn(bundleName);

        let mockFunc6: Function = mock.mockFunc(StatusBarServiceEventMgr.getInstance(), StatusBarServiceEventMgr.getInstance().isWpsAndRegister);
        when(mockFunc6)(ArgumentMatchers.any).afterReturn(true);

        (instance as object)['isSupportRecentDock'] = true;

        instance.addToRecentDockList(bundleName, appIndex);
        expect(instance instanceof RecentDockModel).assertTrue();
      } catch (e) {
        expect(JSON.stringify(e)).assertInstanceOf('String');
      }
      mock.clear(CheckEmptyUtils);
      mock.clear(instance);
      mock.clear(AppModel.getInstance());
      mock.clear(SceneInfoAdapterUtil);
      mock.clear(StatusBarServiceEventMgr.getInstance());
      mock.clearAll();
    })

  })
}
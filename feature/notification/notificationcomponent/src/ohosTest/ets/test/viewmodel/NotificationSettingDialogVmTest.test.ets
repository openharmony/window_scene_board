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

import { NotificationSettingDialogVm } from './NotificationSettingDialogVm';
import { NotificationVmInjector } from './NotificationVmInjector';
import { NotificationBase } from './NotificationBase';
import { NotificationConstants } from './NotificationConstants';
import { NotificationApiUtil } from './NotificationApiUtil';
import { INotificationPinTopLimitDialogVm } from './INotificationPinTopLimitDialogVm';
import { NotificationCardVm } from './NotificationCardVm';
import { DropdownVm } from './DropdownVm';
import { ClickNotificationMaintenance } from './ClickNotificationMaintenance';
import { NtfMgr } from './NtfMgr';

export default function NotificationSettingDialogVmTest() {
  // 模拟依赖
  @Mock(NotificationVmInjector)
  class MockNotificationVmInjector {
    private panelVm: any;
    private menuVm: any;
    private pinTopDialogVm: any;
    private listVm: any;

    constructor() {
      this.panelVm = {
        scale: 1,
      };
      this.menuVm = {
        settingButtonData: {
          opacity: 1,
        },
      };
      this.pinTopDialogVm = {
        setPinTop: jest.fn(),
      };
      this.listVm = {
        moreNtfList: [],
      };
    }

    public getPanelVm(): any {
      return this.panelVm;
    }

    public getMenuVm(ntf: NotificationBase): any {
      return this.menuVm;
    }

    public getPinTopDialogVm(): INotificationPinTopLimitDialogVm {
      return this.pinTopDialogVm;
    }

    public getListVm(): any {
      return this.listVm;
    }
  }

  @Mock(NotificationApiUtil)
  class MockNotificationApiUtil {
    public setStatusBarZIndex: jest.Mock = jest.fn();
    public closeSwitch: jest.Mock = jest.fn();
    public openNtfSetting: jest.Mock = jest.fn();
  }

  @Mock(NotificationCardVm)
  class MockNotificationCardVm {
    public updateTransitionAnimation: jest.Mock = jest.fn();
  }

  @Mock(DropdownVm)
  class MockDropdownVm {
    public static instance: {
      hidePanel: jest.Mock;
    } = {
      hidePanel: jest.fn(),
    };
  }

  @Mock(ClickNotificationMaintenance)
  class MockClickNotificationMaintenance {
    public saveInfo: jest.Mock = jest.fn();
  }

  @Mock(NtfMgr)
  class MockNtfMgr {
    public setLiveViewEnable: jest.Mock = jest.fn();
  }

  describe('NotificationSettingDialogVm', () => {
    let vm: NotificationSettingDialogVm;
    let mockVmInjector: MockNotificationVmInjector;
    let mockNotificationApiUtil: MockNotificationApiUtil;
    let mockNotificationCardVm: MockNotificationCardVm;
    let mockDropdownVm: MockDropdownVm;
    let mockClickNotificationMaintenance: MockClickNotificationMaintenance;
    let mockNtfMgr: MockNtfMgr;

    beforeEach(() => {
      mockVmInjector = new MockNotificationVmInjector();
      mockNotificationApiUtil = new MockNotificationApiUtil();
      mockNotificationCardVm = new MockNotificationCardVm();
      mockDropdownVm = new MockDropdownVm();
      mockClickNotificationMaintenance = new MockClickNotificationMaintenance();
      mockNtfMgr = new MockNtfMgr();

      vm = new NotificationSettingDialogVm(mockVmInjector);
    });

    describe('openSetting', () => {
      it('should handle null ntf', () => {
        vm.openSetting(null, { x: 0, y: 0 });
        expect(vm.settingDiagData.isShowDialog).toBe(false);
      });

      it('should open setting dialog with valid ntf', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.creatorBundleName = 'test_bundle';
        ntf.appLabel = 'Test App';
        ntf.isAtomicServiceFromPush = false;
        ntf.isDeliverNotification = false;
        ntf.isSettingIgnore = false;
        ntf.isDisplayAtTop = false;
        ntf.groupKey = 'test_key';
        ntf.creatorUid = 123;
        ntf.appIndex = 0;

        const position = { x: 100, y: 200 };

        vm.openSetting(ntf, position);

        expect(vm.settingDiagData.buttonPositionLeft).toBe(100);
        expect(vm.settingDiagData.buttonPositionTop).toBe(200);
        expect(vm.settingDiagData.dialogTitle).toContain('Test App');
        expect(vm.settingDiagData.isShowDialog).toBe(true);
        expect(vm.settingDiagData.isShowButton).toBe(true);
        expect(vm.ntf).toBe(ntf);
      });

      it('should handle live view ntf', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => true;
        ntf.creatorBundleName = 'test_bundle';
        ntf.appLabel = 'Test App';
        ntf.isAtomicServiceFromPush = true;
        ntf.isDeliverNotification = false;
        ntf.isSettingIgnore = false;
        ntf.isDisplayAtTop = false;
        ntf.groupKey = 'test_key';
        ntf.creatorUid = 123;
        ntf.appIndex = 0;

        const position = { x: 100, y: 200 };

        vm.openSetting(ntf, position);

        expect(vm.settingDiagData.menus.length).toBe(1);
        expect(vm.settingDiagData.menus[0].type).toBe(NotificationSettingMenuType.CLOSE);
      });

      it('should handle non-live view ntf', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.creatorBundleName = 'test_bundle';
        ntf.appLabel = 'Test App';
        ntf.isAtomicServiceFromPush = false;
        ntf.isDeliverNotification = false;
        ntf.isSettingIgnore = false;
        ntf.isDisplayAtTop = false;
        ntf.groupKey = 'test_key';
        ntf.creatorUid = 123;
        ntf.appIndex = 0;

        const position = { x: 100, y: 200 };

        vm.openSetting(ntf, position);

        expect(vm.settingDiagData.menus.length).toBe(3);
        expect(vm.settingDiagData.menus[0].type).toBe(NotificationSettingMenuType.CLOSE);
        expect(vm.settingDiagData.menus[1].type).toBe(NotificationSettingMenuType.PIN_TOP);
        expect(vm.settingDiagData.menus[2].type).toBe(NotificationSettingMenuType.OPEN_SETTING);
      });

      it('should handle ntf with disabled close button', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.creatorBundleName = NotificationConstants.DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME[0];
        ntf.appLabel = 'Test App';
        ntf.isAtomicServiceFromPush = false;
        ntf.isDeliverNotification = false;
        ntf.isSettingIgnore = false;
        ntf.isDisplayAtTop = false;
        ntf.groupKey = 'test_key';
        ntf.creatorUid = 123;
        ntf.appIndex = 0;

        const position = { x: 100, y: 200 };

        vm.openSetting(ntf, position);

        expect(vm.settingDiagData.menus.length).toBe(2);
        expect(vm.settingDiagData.menus[0].type).toBe(NotificationSettingMenuType.PIN_TOP);
        expect(vm.settingDiagData.menus[1].type).toBe(NotificationSettingMenuType.OPEN_SETTING);
      });

      it('should handle ntf with disabled setting button', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.creatorBundleName = 'test_bundle';
        ntf.appLabel = 'Test App';
        ntf.isAtomicServiceFromPush = false;
        ntf.isDeliverNotification = false;
        ntf.isSettingIgnore = true;
        ntf.isDisplayAtTop = false;
        ntf.groupKey = 'test_key';
        ntf.creatorUid = 123;
        ntf.appIndex = 0;

        const position = { x: 100, y: 200 };

        vm.openSetting(ntf, position);

        expect(vm.settingDiagData.menus.length).toBe(2);
        expect(vm.settingDiagData.menus[0].type).toBe(NotificationSettingMenuType.CLOSE);
        expect(vm.settingDiagData.menus[1].type).toBe(NotificationSettingMenuType.PIN_TOP);
      });
    });

    describe('hide', () => {
      it('should hide setting dialog', () => {
        vm.settingDiagData.isShowDialog = true;
        vm.settingDiagData.isShowButton = true;
        vm.ntf = new NotificationBase();

        vm.hide();

        expect(vm.settingDiagData.isShowDialog).toBe(false);
        expect(vm.settingDiagData.isShowButton).toBe(false);
        expect(mockVmInjector.menuVm.settingButtonData.opacity).toBe(1);
      });

      it('should reset status bar z-index', () => {
        vm.hide();
        expect(NotificationApiUtil.setStatusBarZIndex).toHaveBeenCalledWith('reset');
      });
    });

    describe('updateSettingDiagData', () => {
      it('should update dialog data with button position', () => {
        const position = { x: 100, y: 200 };
        vm.updateSettingDiagData(position);

        expect(vm.settingDiagData.buttonPositionLeft).toBe(100);
        expect(vm.settingDiagData.buttonPositionTop).toBe(200);
      });

      it('should update dialog title', () => {
        const ntf = new NotificationBase();
        ntf.appLabel = 'Test App';
        vm.ntf = ntf;
        vm.updateSettingDiagData({ x: 0, y: 0 });

        expect(vm.settingDiagData.dialogTitle).toContain('Test App');
      });

      it('should update menus', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.creatorBundleName = 'test_bundle';
        ntf.appLabel = 'Test App';
        ntf.isAtomicServiceFromPush = false;
        ntf.isDeliverNotification = false;
        ntf.isSettingIgnore = false;
        ntf.isDisplayAtTop = false;
        ntf.groupKey = 'test_key';
        ntf.creatorUid = 123;
        ntf.appIndex = 0;

        vm.ntf = ntf;
        vm.updateSettingDiagData({ x: 0, y: 0 });

        expect(vm.settingDiagData.menus.length).toBe(3);
      });
    });

    describe('getDialogTitle', () => {
      it('should return live view title', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => true;
        ntf.isConvertFromNormal = false;
        ntf.appLabel = 'Test App';

        vm.ntf = ntf;
        const title = vm.getDialogTitle();

        expect(title).toContain('Test App');
      });

      it('should return normal notification title', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.appLabel = 'Test App';

        vm.ntf = ntf;
        const title = vm.getDialogTitle();

        expect(title).toContain('Test App');
      });
    });

    describe('updateMenus', () => {
      it('should handle live view ntf', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => true;
        ntf.isAtomicServiceFromPush = true;

        vm.ntf = ntf;
        vm.updateMenus();

        expect(vm.settingDiagData.menus.length).toBe(1);
        expect(vm.settingDiagData.menus[0].type).toBe(NotificationSettingMenuType.CLOSE);
      });

      it('should handle non-live view ntf', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.creatorBundleName = 'test_bundle';
        ntf.isDeliverNotification = false;
        ntf.isSettingIgnore = false;

        vm.ntf = ntf;
        vm.updateMenus();

        expect(vm.settingDiagData.menus.length).toBe(3);
        expect(vm.settingDiagData.menus[0].type).toBe(NotificationSettingMenuType.CLOSE);
        expect(vm.settingDiagData.menus[1].type).toBe(NotificationSettingMenuType.PIN_TOP);
        expect(vm.settingDiagData.menus[2].type).toBe(NotificationSettingMenuType.OPEN_SETTING);
      });

      it('should handle ntf with disabled close button', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.creatorBundleName = NotificationConstants.DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME[0];
        ntf.isDeliverNotification = false;
        ntf.isSettingIgnore = false;

        vm.ntf = ntf;
        vm.updateMenus();

        expect(vm.settingDiagData.menus.length).toBe(2);
        expect(vm.settingDiagData.menus[0].type).toBe(NotificationSettingMenuType.PIN_TOP);
        expect(vm.settingDiagData.menus[1].type).toBe(NotificationSettingMenuType.OPEN_SETTING);
      });

      it('should handle ntf with disabled setting button', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.creatorBundleName = 'test_bundle';
        ntf.isDeliverNotification = false;
        ntf.isSettingIgnore = true;

        vm.ntf = ntf;
        vm.updateMenus();

        expect(vm.settingDiagData.menus.length).toBe(2);
        expect(vm.settingDiagData.menus[0].type).toBe(NotificationSettingMenuType.CLOSE);
        expect(vm.settingDiagData.menus[1].type).toBe(NotificationSettingMenuType.PIN_TOP);
      });
    });

    describe('isAtomicServiceFromPush', () => {
      it('should return true for atomic service from push', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => true;
        ntf.isAtomicServiceFromPush = true;

        vm.ntf = ntf;
        expect(vm.isAtomicServiceFromPush()).toBe(true);
      });

      it('should return false for non-atomic service', () => {
        const ntf = new NotificationBase();
        ntf.isLiveView = () => false;
        ntf.isAtomicServiceFromPush = true;

        vm.ntf = ntf;
        expect(vm.isAtomicServiceFromPush()).toBe(false);
      });
    });

    describe('isShowCloseButton', () => {
      it('should return true for normal ntf', () => {
        const ntf = new NotificationBase();
        ntf.creatorBundleName = 'test_bundle';

        vm.ntf = ntf;
        expect(vm.isShowCloseButton()).toBe(true);
      });

      it('should return false for disabled close ntf', () => {
        const ntf = new NotificationBase();
        ntf.creatorBundleName = NotificationConstants.DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME[0];

        vm.ntf = ntf;
        expect(vm.isShowCloseButton()).toBe(false);
      });
    });

    describe('isShowPintTopButton', () => {
      it('should return true for non-deliver ntf', () => {
        const ntf = new NotificationBase();
        ntf.isDeliverNotification = false;

        vm.ntf = ntf;
        expect(vm.isShowPintTopButton()).toBe(true);
      });

      it('should return false for deliver ntf', () => {
        const ntf = new NotificationBase();
        ntf.isDeliverNotification = true;

        vm.ntf = ntf;
        expect(vm.isShowPintTopButton()).toBe(false);
      });
    });

    describe('isShowSettingButton', () => {
      it('should return true for normal ntf', () => {
        const ntf = new NotificationBase();
        ntf.creatorBundleName = 'test_bundle';
        ntf.isSettingIgnore = false;

        vm.ntf = ntf;
        expect(vm.isShowSettingButton()).toBe(true);
      });

      it('should return false for disabled setting ntf', () => {
        const ntf = new NotificationBase();
        ntf.creatorBundleName = NotificationConstants.DISABLE_CLOSE_NOTIFICATION_PACKAGE_NAME[0];
        ntf.isSettingIgnore = false;
        vm.ntf = ntf;
        expect(vm.isShowSettingButton()).toBe(false);
      });

      it('should return false for ignored setting ntf', () => {
        const ntf = new NotificationBase();
        ntf.creatorBundleName = 'test_bundle';
        ntf.isSettingIgnore = true;
        vm.ntf = ntf;
        expect(vm.isShowSettingButton()).toBe(false);
      });
    });

    describe('getMetaServiceLiveViewCloseMenu', () => {
      it('should create close menu for meta service', () => {
        const menu = vm.getMetaServiceLiveViewCloseMenu();
        expect(menu.type).toBe(NotificationSettingMenuType.CLOSE);
        expect(menu.title).toContain('meta service');
      });
    });

    describe('getAppLiveViewCloseMenu', () => {
      it('should create close menu for app live view', () => {
        const menu = vm.getAppLiveViewCloseMenu();
        expect(menu.type).toBe(NotificationSettingMenuType.CLOSE);
        expect(menu.title).toContain('live view');
      });
    });

    describe('getNotificationCloseMenu', () => {
      it('should create close menu for notification', () => {
        const menu = vm.getNotificationCloseMenu();
        expect(menu.type).toBe(NotificationSettingMenuType.CLOSE);
        expect(menu.title).toContain('notification');
      });
    });

    describe('getNotificationPinTopMenu', () => {
      it('should create pin top menu', () => {
        const ntf = new NotificationBase();
        ntf.isDisplayAtTop = false;
        vm.ntf = ntf;
        const menu = vm.getNotificationPinTopMenu();
        expect(menu.type).toBe(NotificationSettingMenuType.PIN_TOP);
        expect(menu.title).toContain('pin top');
      });

      it('should create cancel pin top menu', () => {
        const ntf = new NotificationBase();
        ntf.isDisplayAtTop = true;
        vm.ntf = ntf;
        const menu = vm.getNotificationPinTopMenu();
        expect(menu.type).toBe(NotificationSettingMenuType.PIN_TOP);
        expect(menu.title).toContain('cancel pin top');
      });
    });
  });
}
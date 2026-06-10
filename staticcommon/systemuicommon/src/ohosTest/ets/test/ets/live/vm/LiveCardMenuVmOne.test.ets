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
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LiveItemBaseVm } from '../../../../../../main/ets/live/vm/LiveBaseVm';
import { ILiveCardMenuVm } from '../../../../../../main/ets/live/interface/ILiveCardMenuVm';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveVmInjector } from '../../../../../../main/ets/live/LiveVmInjector';
import { NotificationDataManager } from '../../../../../../main/ets/manager/NotificationDataManager';
import { ResourceVm } from '../../../../../../main/ets/vm/ResourceVm';
import { DeleteNotificationMaintenance } from '../../../../../../main/ets/maintenance/DeleteNotificationMaintenance';
import { DeleteNotificationType } from '../../../../../../main/ets/maintenance/StatisticsConstants';
import { LiveHiSysEvent } from '../../../../../../main/ets/live/sysEvent/LiveHiSysEvent';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { LiveCardMenuVm } from '../../../../../../main/ets/live/vm/LiveCardMenuVm';
import { ILiveCardListItemVm } from '../../../../../../main/ets/live/interface/ILiveCardListItemVm';

export default function LiveCardMenuVmTest() {
  describe('menuOpacity_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    menuOpacityTest1();

    menuOpacityTest2();

    menuOpacityTest3();

    menuOpacityTest4();

    menuOpacityTest5();
  });

  describe('isShowMenu_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    isShowMenuTest1();

    isShowMenuTest2();
  });

  describe('menuOffsetX_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    menuOffsetXTest1();

    menuOffsetXTest2();

    menuOffsetXTest3();
  });
  describe('onMenuSizeChange_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })


    onMenuSizeChange1();

    onMenuSizeChange2();

    onMenuSizeChange3();

    onMenuSizeChange4();

    onMenuSizeChange5();

    onMenuSizeChange6();

    onMenuSizeChange7();
  });

  describe('reset_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    resetTest1();

    resetTest2();

    resetTest3();

    it('should_reset_live_vm_when_type_is_self', 0, () => {
      let mocker: MockKit = new MockKit();

      let liveNotification: LiveNotification = new LiveNotification();
      let vmInjector: LiveVmInjector = new LiveVmInjector();
      let liveCardMenuVm: LiveCardMenuVm = new LiveCardMenuVm(vmInjector, liveNotification);
      LiveCardMenuVm.instances.add(liveCardMenuVm);

      liveCardMenuVm.reset('self');

      expect(liveCardMenuVm.itemVm.updateSwipeOffset).assertCalledWith(0, true);
    });

    it('should_reset_all_live_vms_when_type_is_all', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveNotification1: LiveNotification = new LiveNotification();
      let vmInjector1: LiveVmInjector = new LiveVmInjector();
      let liveCardMenuVm1: LiveCardMenuVm = new LiveCardMenuVm(vmInjector1, liveNotification1);
      LiveCardMenuVm.instances.add(liveCardMenuVm1);

      let liveNotification2: LiveNotification = new LiveNotification();
      let vmInjector2: LiveVmInjector = new LiveVmInjector();
      let liveCardMenuVm2: LiveCardMenuVm = new LiveCardMenuVm(vmInjector2, liveNotification2);
      LiveCardMenuVm.instances.add(liveCardMenuVm2);

      liveCardMenuVm1.reset('all');

      expect(liveCardMenuVm1.itemVm.updateSwipeOffset).assertCalledWith(0, true);
      expect(liveCardMenuVm2.itemVm.updateSwipeOffset).assertCalledWith(0, true);
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_reset_live_vm_when_type_is_exceptSelf_and_instance_is_touching', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveNotification1: LiveNotification = new LiveNotification();
      let vmInjector1: LiveVmInjector = new LiveVmInjector();
      let liveCardMenuVm1: LiveCardMenuVm = new LiveCardMenuVm(vmInjector1, liveNotification1);
      LiveCardMenuVm.instances.add(liveCardMenuVm1);

      liveCardMenuVm1.isTouching = true;

      liveCardMenuVm1.reset('exceptSelf');

      expect(liveCardMenuVm1.itemVm.updateSwipeOffset).assertNotCalled();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_reset_live_vm_when_type_is_exceptSelf_and_instance_has_different_scene', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveNotification1: LiveNotification = new LiveNotification();
      let vmInjector1: LiveVmInjector = new LiveVmInjector();
      let liveCardMenuVm1: LiveCardMenuVm = new LiveCardMenuVm(vmInjector1, liveNotification1);
      LiveCardMenuVm.instances.add(liveCardMenuVm1);

      let liveNotification2: LiveNotification = new LiveNotification();
      let vmInjector2: LiveVmInjector = new LiveVmInjector();
      let liveCardMenuVm2: LiveCardMenuVm = new LiveCardMenuVm(vmInjector2, liveNotification2);
      LiveCardMenuVm.instances.add(liveCardMenuVm2);

      vmInjector1.scene = 'scene1';
      vmInjector2.scene = 'scene2';

      liveCardMenuVm1.reset('exceptSelf');

      expect(liveCardMenuVm1.itemVm.updateSwipeOffset).assertNotCalled();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });

    it('should_not_reset_live_vm_when_type_is_exceptSelf_and_instance_has_different_offsetX', 0, () => {
      let mocker: MockKit = new MockKit();
      let logHelper: LogHelper = LogHelper.instance;
      let mockShowInfo: Function = mocker.mockFunc(logHelper, logHelper.showInfo);
      when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();

      let liveNotification1: LiveNotification = new LiveNotification();
      let vmInjector1: LiveVmInjector = new LiveVmInjector();
      let liveCardMenuVm1: LiveCardMenuVm = new LiveCardMenuVm(vmInjector1, liveNotification1);
      LiveCardMenuVm.instances.add(liveCardMenuVm1);

      let liveNotification2: LiveNotification = new LiveNotification();
      let vmInjector2: LiveVmInjector = new LiveVmInjector();
      let liveCardMenuVm2: LiveCardMenuVm = new LiveCardMenuVm(vmInjector2, liveNotification2);
      LiveCardMenuVm.instances.add(liveCardMenuVm2);

      liveCardMenuVm1.itemVm.containerOffsetX = 10;
      liveCardMenuVm2.itemVm.containerOffsetX = 20;

      liveCardMenuVm1.reset('exceptSelf');

      expect(liveCardMenuVm1.itemVm.updateSwipeOffset).assertNotCalled();
      mocker.ignoreMock(logHelper, logHelper.showInfo);
    });
  });
}

function resetTest1() {
  it('should_reset_live_vm_when_type_is_self', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);

    const TAG = 'LiveCardMenuVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();
    let mockShowInfo: Function = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();


    menuVm.reset('self');
    mocker.verify('itemVm.updateSwipeOffset', [0, true]).times(1);

    mocker.ignoreMock(log, log.showInfo);
  });
}

function resetTest2() {
  it('should_reset_all_live_vms_when_type_is_all', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);

    const TAG = 'LiveCardMenuVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();
    let mockShowInfo: Function = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();


    menuVm.reset('all');
    mocker.verify('itemVm.updateSwipeOffset', [0, true]).times(0);

    mocker.ignoreMock(log, log.showInfo);
  });
}

function resetTest3() {
  it('should_not_reset_live_vm_when_type_is_exceptSelf', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);

    const TAG = 'LiveCardMenuVm';
    const log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

    let mocker: MockKit = new MockKit();
    let mockShowInfo: Function = mocker.mockFunc(log, log.showInfo);
    when(mockShowInfo)(ArgumentMatchers.anyString).afterReturnNothing();


    menuVm.reset('exceptSelf');
    mocker.verify('itemVm.updateSwipeOffset', [0, true]).times(0);

    mocker.ignoreMock(log, log.showInfo);
  });
}

function onMenuSizeChange1() {
  it('should_log_info_when_menu_size_change', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    live.hashCode = '1234567890';
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);
    let mocker: MockKit = new MockKit();
    let TAG = 'LiveCardMenuVm';
    let log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);

    let sizeOptions: SizeOptions = {
      width: 0,
      height: 100,
    };

    menuVm.onMenuSizeChange(sizeOptions, sizeOptions);
    mocker.verify('log.showInfo', ['onMenuSizeChange for 1234567890, width: 0']).times(1);

    mocker.ignoreMock(log, log.showInfo);
  });
}

function onMenuSizeChange2() {
  it('should_set_menu_width_when_size_options_width_is_greater_than_zero', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    live.hashCode = '1234567890';
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);
    let mocker: MockKit = new MockKit();
    let TAG = 'LiveCardMenuVm';
    let log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);

    let sizeOptions: SizeOptions = {
      width: 100,
      height: 100,
    };

    menuVm.onMenuSizeChange(sizeOptions, sizeOptions);
    mocker.verify('log.showInfo', ['onMenuSizeChange for 1234567890, width: 100']).times(1);

    mocker.ignoreMock(log, log.showInfo);
  });
}

function onMenuSizeChange3() {
  it('should_set_menu_width_when_size_options_width_is_zero', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    live.hashCode = '1234567890';
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);
    let mocker: MockKit = new MockKit();
    let TAG = 'LiveCardMenuVm';
    let log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);

    let sizeOptions: SizeOptions = {
      width: 0,
      height: 0,
    };

    menuVm.onMenuSizeChange(sizeOptions, sizeOptions);
    mocker.verify('log.showInfo', ['onMenuSizeChange for 1234567890, width: 0']).times(1);

    mocker.ignoreMock(log, log.showInfo);
  });
}

function onMenuSizeChange4() {
  it('should_set_menu_width_when_size_options_width_is_negative', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    live.hashCode = '1234567890';
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);
    let mocker: MockKit = new MockKit();
    let TAG = 'LiveCardMenuVm';
    let log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);

    let sizeOptions: SizeOptions = {
      width: -100,
      height: 100,
    };

    menuVm.onMenuSizeChange(sizeOptions, sizeOptions);
    mocker.verify('log.showInfo', ['onMenuSizeChange for 1234567890, width: -100']).times(1);

    mocker.ignoreMock(log, log.showInfo);
  });
}

function onMenuSizeChange5() {
  it('should_set_menu_width_when_size_options_width_is_100_with_live_hashcode_xxxxxxxx', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    live.hashCode = 'xxxxxxxxx';
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);
    let mocker: MockKit = new MockKit();
    let TAG = 'LiveCardMenuVm';
    let log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);

    let sizeOptions: SizeOptions = {
      width: 100,
      height: 100,
    };

    menuVm.onMenuSizeChange(sizeOptions, sizeOptions);
    mocker.verify('log.showInfo', ['onMenuSizeChange for xxxxxxxxx, width: 100']).times(1);

    mocker.ignoreMock(log, log.showInfo);
  });
}

function onMenuSizeChange6() {
  it('should_set_menu_width_when_size_options_width_is_zero_with_live_hashcode_xxxxxxxx', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    live.hashCode = 'xxxxxxxxx';
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);
    let mocker: MockKit = new MockKit();
    let TAG = 'LiveCardMenuVm';
    let log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);

    let sizeOptions: SizeOptions = {
      width: 0,
      height: 0,
    };

    menuVm.onMenuSizeChange(sizeOptions, sizeOptions);
    mocker.verify('log.showInfo', ['onMenuSizeChange for xxxxxxxxx, width: 0']).times(1);

    mocker.ignoreMock(log, log.showInfo);
  });
}

function onMenuSizeChange7() {
  it('should_set_menu_width_when_size_options_width_is_negative_with_live_hashcode_xxxxxxxx', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let live: LiveNotification = new LiveNotification();
    live.hashCode = 'xxxxxxxxx';
    let itemVm: ILiveCardListItemVm = liveVmInjector.getCardListItemVm(live);
    let menuVm: LiveCardMenuVm = new LiveCardMenuVm(liveVmInjector, live);
    let mocker: MockKit = new MockKit();
    let TAG = 'LiveCardMenuVm';
    let log = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);
    let mockFunc: Function = mocker.mockFunc(log, log.showInfo);

    let sizeOptions: SizeOptions = {
      width: -100,
      height: 0,
    };

    menuVm.onMenuSizeChange(sizeOptions, sizeOptions);
    mocker.verify('log.showInfo', ['onMenuSizeChange for xxxxxxxxx, width: -100']).times(1);

    mocker.ignoreMock(log, log.showInfo);
  });
}

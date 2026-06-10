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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, TestType, Level, Size } from '@ohos/hypium';
import { HiDfxEventUtil } from '../../../../../../main/ets/hisysevent/HiDfxEventUtil';

export function HiDfxEventUtilTest() {
  describe('HiDfxEventUtilTest', () => {
    beforeAll((): void => {
    })
    beforeEach((): void => {
    })
    afterAll((): void => {
    })
    afterEach((): void => {
    })

    it('reportInputClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiDfxEventUtil.reportInputClick() === undefined).assertTrue();
    })

    it('reportWlanClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiDfxEventUtil.reportWlanClick() === undefined).assertTrue();
    })

    it('reportClockClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiDfxEventUtil.reportClockClick() === undefined).assertTrue();
    })

    it('reportNotificationClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiDfxEventUtil.reportNotificationClick() === undefined).assertTrue();
    })

    it('reportControlClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiDfxEventUtil.reportControlClick() === undefined).assertTrue();
    })

    it('reportSearchClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiDfxEventUtil.reportSearchClick() === undefined).assertTrue();
    })

    it('reportBluetoothClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      expect(HiDfxEventUtil.reportBluetoothClick() === undefined).assertTrue();
    })

    it('delayReportEvent', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let name: string = 'testname';
      let msg:Object = new Object();
      let delay: number = 1;
      expect(HiDfxEventUtil.delayReportEvent(name, msg, delay ) === undefined).assertTrue();
      expect(HiDfxEventUtil.delayReportEvent(null, msg, delay ) === undefined).assertTrue();
    })

    it('reportUserSwitchEvent', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let userType: number = 1;
      expect(HiDfxEventUtil.reportUserSwitchEvent( userType ) === undefined).assertTrue();
      expect(HiDfxEventUtil.reportUserSwitchEvent( null ) === undefined).assertTrue();
    })

    it('reportNotificationManagementStatusBar', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let status:number = 0;
      expect(HiDfxEventUtil.reportNotificationManagementStatusBar(status) === undefined ).assertTrue();
    })

    it('reportSimpleDisplay', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let switchStatus:number = 0;
      expect(HiDfxEventUtil.reportSimpleDisplay(switchStatus)=== undefined ).assertTrue();
    })

    it('reportShowAppNotificationIcons', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let switchStatus:number = 0;
      expect(HiDfxEventUtil.reportShowAppNotificationIcons(switchStatus)=== undefined ).assertTrue();
    })

    it('reportShowNetworkSpeed', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let switchStatus:number = 0;
      expect(HiDfxEventUtil.reportShowNetworkSpeed(switchStatus) === undefined ).assertTrue();
    })

    it('reportHideNotificationContent', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let switchStatus:number = 0;
      expect(HiDfxEventUtil.reportHideNotificationContent(switchStatus) === undefined ).assertTrue();
    })

    it('reportWakeScreen', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let switchStatus:number = 0;
      expect(HiDfxEventUtil.reportWakeScreen(switchStatus) === undefined ).assertTrue();
    })

    it('reportManageAll', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let state:number = 0;
      expect(HiDfxEventUtil.reportManageAll(state) === undefined ).assertTrue();
    })

    it('reportSwitchInManageAll', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let bundleName:string = '';
      let switchStatus:number = 0;
      expect(HiDfxEventUtil.reportSwitchInManageAll(bundleName, switchStatus) === undefined ).assertTrue();
    })

    it('reportApplicationNotificationManagement', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let bundleName:string = '';
      let state:number = 0;
      expect(HiDfxEventUtil.reportApplicationNotificationManagement(bundleName, state) === undefined ).assertTrue();
    })

    it('reportNotificationManagementAllowNotification', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let bundleName:string = '';
      let switchStatus:number = 0;
      expect(HiDfxEventUtil.reportNotificationManagementAllowNotification(bundleName, switchStatus) === undefined ).assertTrue();
    })

    it('reportNotificationStyleLockScreen', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let bundleName:string = '';
      let switchStatus:number = 0;
      expect(HiDfxEventUtil.reportNotificationStyleLockScreen(bundleName, switchStatus) === undefined ).assertTrue();
    })

    it('reportNotifyStyleBanners', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let bundleName:string = '';
      let switchStatus:number = 0;
      expect(HiDfxEventUtil.reportNotifyStyleBanners(bundleName, switchStatus) === undefined ).assertTrue();
    })

    it('reportNotificationManagement', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let eventType:string = '';
      let name:number = 0;
      expect(HiDfxEventUtil.reportNotificationManagement(name, eventType) === undefined ).assertTrue();
    })

    it('reportToggleClick', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let slot:string = '';
      let clickType:number = 0;
      expect(HiDfxEventUtil.reportToggleClick(slot, clickType) === undefined ).assertTrue();
    })

    it('reportToggleDataChange', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let toggleData:string = '';
      expect(HiDfxEventUtil.reportToggleDataChange(toggleData) === undefined ).assertTrue();
    })

    it('reportToggleEditState', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let state:number = 0;
      expect(HiDfxEventUtil.reportToggleEditState(state) === undefined ).assertTrue();
    })

    it('reportToggleEditDrag', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let slot:string = '';
      expect(HiDfxEventUtil.reportToggleEditDrag(slot) === undefined ).assertTrue();
    })

    it('reportSwipeSwitchControlNtf', TestType.USER | Size.MEDIUMTEST | Level.LEVEL0, () => {
      let target:number = 0;
      let result:string = '';
      let startX:number = 0;
      let startY:number = 0;
      let endX:number = 0;
      let endY:number = 0;
      expect(HiDfxEventUtil.reportSwipeSwitchControlNtf(target, result, startX, startY, endX, endY) === undefined ).assertTrue();
      target = 1;
      expect(HiDfxEventUtil.reportSwipeSwitchControlNtf(target, result, startX, startY, endX, endY) === undefined ).assertTrue();
    })
  })
}
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { immersiveNtfAdapter } from '../../../../../../main/ets/model/service/ImmersiveNtfAdapter';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import {
  BaseNotification,
} from '@ohos/systemuicommon';
import {
  LiveType,
  LiveViewData,
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import ntfMgr from '@ohos.notificationManager';
import { bundleManager } from '@kit.AbilityKit';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveNtfAdapterTest() {
  describe('ImmersiveNtfAdapterTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_parse', Level.LEVEL1, (): void => {
      let data: ImmersiveNtfData | undefined = immersiveNtfAdapter.parse();
      expect(data === undefined).assertTrue();
      let basentf = new BaseNotification();
      basentf.creatorBundleName = 'myappbundle.com';
      basentf.slotType = ntfMgr.SlotType.LIVE_VIEW;
      basentf.id = 100000;
      basentf.hashCode = 'myhashcode';
      basentf.appIcon = 'logo.icon';
      immersiveNtfAdapter.parse(basentf);
      expect(immersiveNtfAdapter).not().assertNull();
    });

    it('test_parseCommonData', Level.LEVEL1, (): void => {
      let ntfData = new ImmersiveNtfData();
      let entry = new BaseNotification();
      let MAX_ID = 1000;
      (immersiveNtfAdapter as object)['id'] = MAX_ID;
      (immersiveNtfAdapter as object)['parseCommonData'](ntfData, entry);
      expect(immersiveNtfAdapter).not().assertNull();
    });

    it('test_parseImmersiveLiveData', Level.LEVEL1, (): void => {
      let ntfData = new ImmersiveNtfData();
      let liveviewContent: ntfMgr.NotificationLiveViewContent = {
        title: 'basicTitle',
        text: 'basicText',
        status: 0,
        extraInfo: { 'PrimaryData.immersiveAbilityName': 'testAbility' }
      };
      let content: ntfMgr.NotificationContent = {
        contentType: 5,
        liveView: liveviewContent
      };
      let request: ntfMgr.NotificationRequest = {
        content: content,
        id: 6666,
        slotType: 3,
        notificationSlotType: 4,
        isOngoing: true,
        isRemoveAllowed: true,
      };
      request.extraInfo = {};
      request.extraInfo['PrimaryData.immersiveAbilityName'] = '';
      let viewData = new LiveViewData();
      viewData.liveType = LiveType.PICK_UP;
      ntfData.creatorBundleName = 'com.ohos.maps.app';
      (immersiveNtfAdapter as object)['parseImmersiveLiveData'](ntfData, request, viewData);
      expect(immersiveNtfAdapter).not().assertNull();
    });

    it('test_checkUIExtensionBundleInfo', Level.LEVEL1, (): void => {
      (immersiveNtfAdapter as object)['checkUIExtensionBundleInfo'](
        'com.test.connect.commondialog.nba',
        'LiveViewLockScreenExtAbility');
      expect(immersiveNtfAdapter).not().assertNull();
    });

    it('test_checkUIExtensionType', Level.LEVEL1, (): void => {
      (immersiveNtfAdapter as object)['checkUIExtensionType']({
          hapModulesInfo: [{}],
          reqPermissionDetails: [],
        },
        'LiveViewLockScreenExtAbility');
      expect(immersiveNtfAdapter).not().assertNull();
    });
  });
}
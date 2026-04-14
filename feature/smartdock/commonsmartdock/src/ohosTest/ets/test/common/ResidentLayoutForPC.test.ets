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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { DockItemInfo, ResidentLayoutCacheMgr } from '@ohos/launchercommon';
import SmartDockViewModel from '../../../../main/ets/default/viewmodel/SmartDockViewModel';

/**
 * ResidentLayoutForPC测试
 *
 * @since 2024-01-27
 */
export default function ResidentLayoutForPCTest() {
  describe('ResidentLayoutForPCTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('test_residentDockTest1', 0, (): void => {
      const item: DockItemInfo = {
        "appName": "",
        "appIconId": 0,
        "bundleName": "com.ohos.sceneboard",
        "abilityName": "com.ohos.sceneboard.appcenter.MainAbility",
        "downloadProgress": 0,
        "appStatus": 0,
        "visible": true,
        "borderVisible": false,
        "shake": 0,
        "itemType": 2,
        "editable": false,
        "moduleName": "",
        "keyName": "com.ohos.sceneboardcom.ohos.sceneboard.appcenter.MainAbility",
        "appLabelId": 0,
        "applicationLabelId": 0,
        "applicationName": "",
        "areaType": 1,
        "missionInfoList": []
      };
      try {
        let mSmartDockViewModel: SmartDockViewModel = SmartDockViewModel.getInstance();
        const appList1: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
        const num1: number = appList1?.length??0;
        mSmartDockViewModel.residentOnClick(null, item);
        const appList2: Array<DockItemInfo> = ResidentLayoutCacheMgr.getInstance().getAllDockItems();
        const num2: number = appList2?.length??0;
        const listLengthChange: number = num2 - num1;
        expect(listLengthChange).assertEqual(0);
      }catch{}
    })

  })
}
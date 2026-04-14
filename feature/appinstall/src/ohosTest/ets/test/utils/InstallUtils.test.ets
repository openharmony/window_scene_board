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

import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it} from '@ohos/hypium'
import {
  AppItemInfo,
  CommonConstants,
  GridLayoutItemBuilder,
  GridLayoutItemInfo
} from 'launchercommon'
import { AppGalleryData } from '../../../../main/ets/default/data/AppGalleryData'
import { InstallUtils } from '../../../../main/ets/default/utils/InstallUtils'

const BUNDLE_NAME = 'com.ohos.appgallery';

export default function InstallUtilsTest() {
  describe('InstallUtilsTest', (): void => {
    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterEach((): void => {
    })

    afterAll((): void => {
    })

    it('buildInsertItem', 0, () => {
      let bundleName = BUNDLE_NAME;
      let data: AppGalleryData = {
        bundleName: bundleName,
        appName: '',
        status: 0
      };
      let item: GridLayoutItemInfo = InstallUtils.buildInsertItem(data);
      expect(item.bundleName).assertEqual(bundleName);
    })

    it('getFolderId1', 0, () => {
      let folderId: string = InstallUtils.getFolderId();
      expect(folderId).assertEqual('');
    })

    it('getFolderId2', 0, () => {
      let findApp: GridLayoutItemInfo = {
        bundleName: BUNDLE_NAME,
        container: CommonConstants.CONTAINER_DESKTOP,
        keyName: 'com.ohos.appgalleryMainAbilityentry0',
        abilityName: '',
        appIconId: 0,
        negativeId: 0,
        isSelect: false,
        enterEditing: false,
        downloadProgress: 0,
        appStatus: undefined,
        iconResource: undefined,
        callerName: undefined,
        setInfo: (gridLayoutItemBuilder: GridLayoutItemBuilder): void => {
          throw new Error('Function not implemented.')
        },
        fillInfoWithAppItem: (appItem: AppItemInfo): GridLayoutItemInfo => {
          throw new Error('Function not implemented.')
        },
        toAppItemInfo: (): AppItemInfo => {
          throw new Error('Function not implemented.')
        }
      };
      let folderId: string = InstallUtils.getFolderId(findApp);
      expect(folderId).assertEqual('');

      findApp.container = CommonConstants.CONTAINER_DOCK;
      folderId = InstallUtils.getFolderId(findApp);
      expect(folderId).assertEqual('');

      findApp.container = 12345;
      folderId = InstallUtils.getFolderId(findApp);
      expect(folderId).assertEqual('');
    })

  })
}
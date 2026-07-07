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
import { AodManifest } from '@ohos/aod';

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import {
  AodStyleGroupBuilder,
  BuildStyleParam
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/builder/AodStyleGroupBuilder';
import {
  AodStyleGroupConfig
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/config/AodStyleGroupConfig';
import { StyleGroupName } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/constant/Constant';
import {
  AodStyleGroupListModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleGroupListModel';
import {
  AodStyleGroupModel
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleGroupModel';
import { AodStyleModel } from '@ohos/phonebase/src/main/ets/SceneBoard/aod/personalization/model/AodStyleModel';

export function AodStyleGroupBuilderTest() {
  describe('AodStyleGroupBuilderTest', () => {

    beforeAll((): void => {

    })

    beforeEach((): void => {

    })

    afterEach((): void => {

    })

    afterAll((): void => {

    })

    it('only_one_instance_when_call_any_times_of_getInstance', 0, () => {
      const instance0 = AodStyleGroupBuilder.getInstance();
      const instance1 = AodStyleGroupBuilder.getInstance();
      expect(instance0).assertDeepEquals(instance1);
    });

    it('AodStyleGroupBuilderTest_getStyleGroupTitle', 0, () => {
      let aodStyleGroupBuilder = AodStyleGroupBuilder.getInstance();
      let result = aodStyleGroupBuilder.getStyleGroupTitle(StyleGroupName.FULL_SCREEN);
      expect(aodStyleGroupBuilder !== null).assertEqual(true);
    })

    it('AodStyleGroupBuilderTest_buildAllStyleGroup', 0, () => {
      let aodStyleGroupConfigList: Array<AodStyleGroupConfig> = [];
      let allStyleGroup: AodStyleGroupListModel = new AodStyleGroupListModel();
      AodStyleGroupBuilder.getInstance().buildAllStyleGroup(aodStyleGroupConfigList, allStyleGroup, 'AodDefault', '');
      expect(aodStyleGroupConfigList !== null).assertEqual(true);
    });

    it('AodStyleGroupBuilderTest_buildStyleGroup', 0, () => {
      let aodStyleGroupConfig: AodStyleGroupConfig = new AodStyleGroupConfig();
      let styleGroup: AodStyleGroupModel = AodStyleGroupBuilder.getInstance()
        .buildStyleGroup(aodStyleGroupConfig, '1', '1');
      expect(aodStyleGroupConfig !== null).assertEqual(true);
    });

    it('AodStyleGroupBuilderTest_buildStyleList', 0, () => {
      let aodManifestList: Array<AodManifest> = new Array<AodManifest>();
      let aodManifest: AodManifest = new AodManifest();
      aodManifestList.push(aodManifest);
      let styleGroup: AodStyleGroupModel = new AodStyleGroupModel();
      AodStyleGroupBuilder.getInstance().buildStyleList(aodManifestList, 'test', 'test', styleGroup);
      expect(styleGroup !== null).assertEqual(true);
    });

    it('aodStyleGroupBuilderTest_buildStyle', 0, () => {
      let aodManifest: AodManifest = new AodManifest();
      aodManifest.id = 'aodManifest';
      aodManifest.type = 'image';
      const buildParam: BuildStyleParam = {
        aodManifest: aodManifest,
        appliedStyleName: 'aodManifest',
        selectedStyleName: 'aodManifest',
        groupName: StyleGroupName.FULL_SCREEN,
        index: 0,
      };
      let style: AodStyleModel = AodStyleGroupBuilder.getInstance()
        .buildStyle(buildParam);
      expect(aodManifest !== null).assertEqual(true);
    });
  });

}
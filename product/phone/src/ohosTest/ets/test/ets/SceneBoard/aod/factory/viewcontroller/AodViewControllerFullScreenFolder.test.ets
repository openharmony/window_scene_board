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
import { MockUtil } from '@ohos/aod/src/ohosTest/ets/test/MockUtil';

import { describe, it, expect} from '@ohos/hypium';
import {
  AodViewControllerFullScreenFolder
} from '@ohos/phonebase/src/main/ets/SceneBoard/aod/factory/viewcontroller/AodViewControllerFullScreenFolder';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { AodUtil } from '@ohos/aod';
import { AodHideNotchStatus } from '@ohos/aod/src/main/ets/model/AodModel';

export function AodViewControllerFullScreenFolderTest() {
  describe('AodViewControllerFullScreenFolder', () => {

    it('only_one_instance_when_call_any_times_of_getInstance', 0, () => {
      const instance0 = AodViewControllerFullScreenFolder.getInstance();
      const instance1 = AodViewControllerFullScreenFolder.getInstance();

      expect(instance1).not().assertUndefined();
    });

  });

  class AodTestViewControllerFullScreenFolder extends AodViewControllerFullScreenFolder {
    constructor() {
      super();
    }

  }

}
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

import { describe, it, expect } from '@ohos/hypium'
import { EditModeFolderViewData } from '../../../../../../../main/ets/editmode/data/EditModeFolderViewData';
import { ConfigurationConstant } from '@kit.AbilityKit';
import { GlobalContext } from '@ohos/frameworkwrapper';

export default function EditModeFolderViewDataTest() {
  describe('EditModeFolderViewDataTest', () => {
    it('test_EditModeFolderViewData01', 0, () => {
      const editModeFolderViewData = new EditModeFolderViewData();
      let isDarkMode: boolean = GlobalContext.getContext()?.config?.colorMode === ConfigurationConstant.ColorMode.COLOR_MODE_DARK;
      let folderBackgroundColor = isDarkMode ? '#33000000' : '#4DFFFFFF';
      expect(editModeFolderViewData.getFolderBackgroundColor()).assertEqual(folderBackgroundColor);
    })
  })
}

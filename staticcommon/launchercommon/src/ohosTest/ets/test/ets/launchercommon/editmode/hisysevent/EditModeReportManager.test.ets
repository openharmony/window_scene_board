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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when } from '@ohos/hypium';
import { EditModeReportManager } from '../../../../../../../main/ets/editmode/hisysevent/EditModeReportManager';
import GridLayoutItemInfo from '../../../../../../../main/ets/bean/GridLayoutItemInfo';
import { CommonConstants } from '../../../../../../../main/ets/constants/CommonConstants';
import { LaunchLayoutCacheManager } from '../../../../../../../main/ets/cache/layout/LaunchLayoutCacheManager';


export default function EditModeReportManagerTest() {
  describe('EditModeReportManagerTest', () => {
    it('test_EditModeReportManagerTest_01', 0, () => {
      const editModeReportManager = new EditModeReportManager();
      expect(editModeReportManager.isLayoutChange()).assertFalse();
    })

    it('test_EditModeReportManagerTest_02', 0, () => {
      const editModeReportManager = new EditModeReportManager();
      editModeReportManager.reportEnterEditMode();
      expect(editModeReportManager.isLayoutChange()).assertInstanceOf('Boolean');
    })
  })
}

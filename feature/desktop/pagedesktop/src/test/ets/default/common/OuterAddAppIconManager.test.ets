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
import { describe, expect, it, Level, beforeAll, beforeEach, afterEach, afterAll } from '@ohos/hypium';
import { CommonConstants, GridLayoutItemInfo, AppListInfo, } from '@ohos/launchercommon';
import { outerAddAppIconManager } from '@ohos/launchercommon/src/main/ets/manager/OuterAddAppIconManager';

export function OuterAddAppIconManagerTest() {
  describe('OuterAddAppIconManagerTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it("isAddAppIcon1", Level.LEVEL1, () => {
      let mockInfo: GridLayoutItemInfo = { typeId: 0, bundleName: 'test' } as GridLayoutItemInfo;
      let test = outerAddAppIconManager.isAddAppIcon(mockInfo);
      expect(test === false).assertTrue();
    });

    it("isAddAppIcon2", Level.LEVEL1, () => {
      let mockInfo: GridLayoutItemInfo = {
        typeId: CommonConstants.TYPE_ADD,
        bundleName: CommonConstants.OUTER_ADD_APP_ICON_BUNDLE_NAME
      } as GridLayoutItemInfo;
      let test = outerAddAppIconManager.isAddAppIcon(mockInfo);
      expect(test).assertTrue();
    });

    it("outerAddAppIconReport", Level.LEVEL1, () => {
      outerAddAppIconManager.outerAddAppIconReport();
      expect(true).assertTrue();
    })
  })
}
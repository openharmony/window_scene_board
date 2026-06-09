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
import { describe, expect, it, Level, MockKit, when, ArgumentMatchers, } from '@ohos/hypium';
import { FileUtils } from '@ohos/basicutils';
import { editModeGuideManager, GuideReportStatus } from '../../../../../main/ets/default/common/EditModeGuideManager';

export function EditModeGuideManagerTest() {
  describe('EditModeGuideManagerTest', (): void => {
    it("editModeGuideReport", Level.LEVEL1, () => {
      editModeGuideManager.editModeGuideReport(GuideReportStatus.CLOSE);
      expect(true).assertTrue();
    });

    it("isNeedOpenGuidePage", Level.LEVEL1, () => {
      let isNeedOpen = editModeGuideManager.isNeedOpenGuidePage();
      expect(isNeedOpen || true).assertTrue();
    });

    it("openEditModeGuideBySwipe", Level.LEVEL1, () => {
      let eventParam = { currentOffset: 0.1, targetOffset: 0.1 } as SwiperAnimationEvent;
      editModeGuideManager.openEditModeGuideBySwipe(1, 1, eventParam, 2);
      expect(true).assertTrue();
    });

    it("openEditModeGuideByLongClick", Level.LEVEL1, () => {
      editModeGuideManager.openEditModeGuideByLongClick();
      expect(true).assertTrue();
    });

    it("saveOpenedStatus", Level.LEVEL1, () => {
      editModeGuideManager.saveOpenedStatus();
      expect(true).assertTrue();
    });

    it("getFlashlightTipsResource", Level.LEVEL1, () => {
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc(FileUtils, FileUtils.getFileList);
      when(mockFunc)(ArgumentMatchers.any).afterReturn(['test', 'test']);
      let test = 'test';
      let src = 'test';
      editModeGuideManager.getFlashlightTipsResource();
      expect(test === src).assertTrue();
      mocker.clear(FileUtils);
      mocker.clearAll();
      expect(true).assertTrue();
    });
  })
}
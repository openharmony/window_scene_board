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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import { DragAccessibilityUtils } from '../../../../../../main/ets/TsIndex';

/**
 * 桌面组件拖拽适配无障碍朗读工具类 DT测试套
 */
export function DragAccessibilityUtilsTest() {
  let mocker: MockKit;
  describe('DragAccessibilityUtilsTest', (): void => {
    beforeAll((): void => {
      mocker = new MockKit();
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
      mocker.clearAll();
    });

    afterEach((): void => {
    });

    it('DragAccessibilityUtils_isAccessibilityMode', Level.LEVEL0, (): void => {
      expect(DragAccessibilityUtils.isAccessibilityMode()).assertFalse();
    })

    it('DragAccessibilityUtils_textAnnouncedForDragStart', Level.LEVEL0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      expect(DragAccessibilityUtils.textAnnouncedForDragStart() === undefined).assertTrue();

      // 无障碍朗读模式关闭场景
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForDragStart() === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForDockIsFull', Level.LEVEL0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      expect(DragAccessibilityUtils.textAnnouncedForDockIsFull() === undefined).assertTrue();

      // 无障碍朗读模式关闭场景
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForDockIsFull() === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForDragMoveToDesktop', Level.LEVEL0, (): void => {
      let fallIndex: number[] = [1, 1];
      let currentIndex: number[] = [1, 1];
      // 第一次拖动，位置无变化不播报
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveToDesktop(fallIndex, currentIndex) === undefined)
        .assertTrue();

      fallIndex = [2, 1];
      // 第二次拖动，位置变化正常播报
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveToDesktop(fallIndex, currentIndex) === undefined)
        .assertTrue();

      fallIndex = [2, 2];
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveToDesktop(fallIndex, currentIndex) === undefined)
        .assertTrue();

      currentIndex = [2, 1];
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveToDesktop(fallIndex, currentIndex) === undefined)
        .assertTrue();

      currentIndex = [2, 2];
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveToDesktop(fallIndex, currentIndex) === undefined)
        .assertTrue();

      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      DragAccessibilityUtils.textAnnouncedForDrop(fallIndex, 'dragItemName');
    })

    it('DragAccessibilityUtils_textAnnouncedForDragMoveInFolder', Level.LEVEL0, (): void => {
      let fallIndex: number[] = [1, 1];
      let currentIndex: number[] = [1, 1];
      // 第一次拖动，位置无变化不播报
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveInFolder(fallIndex, currentIndex) === undefined)
        .assertTrue();

      currentIndex = [2, 1];
      // 第二次拖动，位置变化正常播报
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveInFolder(fallIndex, currentIndex) === undefined)
        .assertTrue();

      currentIndex = [2, 2];
      // 位置变化正常播报
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveInFolder(fallIndex, currentIndex) === undefined)
        .assertTrue();

      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      DragAccessibilityUtils.textAnnouncedForDrop(fallIndex, 'dragItemName');
    })

    it('DragAccessibilityUtils_textAnnouncedForDragMoveToDock', Level.LEVEL0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);

      let fallIndex: number = 1;
      let currentIndex: number = 1;
      // 第一次拖动，位置无变化不播报
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveToDock(fallIndex, currentIndex) === undefined)
        .assertTrue();

      currentIndex = 2;
      // 第二次拖动，位置变化正常播报
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveToDock(fallIndex, currentIndex) === undefined)
        .assertTrue();

      fallIndex = 2;
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveToDock(fallIndex, currentIndex) === undefined)
        .assertTrue();

      DragAccessibilityUtils.textAnnouncedForDrop(fallIndex, 'dragItemName');

      // 无障碍朗读模式关闭场景
      when(isAvailable)().afterReturn(false);

      fallIndex = 1;
      currentIndex = 1;
      expect(DragAccessibilityUtils.textAnnouncedForDragMoveToDock(fallIndex, currentIndex) === undefined)
        .assertTrue();

      DragAccessibilityUtils.textAnnouncedForDrop(fallIndex, 'dragItemName');
    })

    it('DragAccessibilityUtils_textAnnouncedForMoveToMerge', Level.LEVEL0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);

      let coveredName: string = 'coveredName';
      expect(DragAccessibilityUtils.textAnnouncedForMoveToMerge(coveredName) === undefined).assertTrue();

      // 无障碍朗读模式关闭场景
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForMoveToMerge(coveredName) === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForMoveToFolder', Level.LEVEL0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);

      let coveredName: string = 'coveredName';
      expect(DragAccessibilityUtils.textAnnouncedForMoveToFolder(coveredName) === undefined).assertTrue();

      // 无障碍朗读模式关闭场景
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForMoveToFolder(coveredName) === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForDrop', Level.LEVEL0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);

      // 桌面或文件夹里落位播报
      let fallIndex1: number[] = [1, 1];
      expect(DragAccessibilityUtils.textAnnouncedForDrop(fallIndex1, 'dragItemName') === undefined).assertTrue();

      DragAccessibilityUtils.resetIndex();

      // dock栏落位播报
      let fallIndex2: number = 1;
      expect(DragAccessibilityUtils.textAnnouncedForDrop(fallIndex2, 'dragItemName') === undefined).assertTrue();

      // 无障碍朗读模式关闭场景
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForDrop(fallIndex2, 'dragItemName') === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForDropMergeToDesktop', Level.LEVEL0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);

      let dragAppName: string = 'dragAppName';
      let coveredName: string = 'coveredName';
      let folderName: string = 'folderName';
      let fallIndex: number[] = [1, 1];
      // 桌面合并文件夹
      expect(DragAccessibilityUtils.textAnnouncedForDropMergeToDesktop(dragAppName, coveredName,
        folderName, fallIndex) === undefined).assertTrue();

      // 无障碍朗读模式关闭场景
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForDropMergeToDesktop(dragAppName, coveredName,
        folderName, fallIndex) === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForDropMergeToDock', Level.LEVEL0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);

      let dragAppName: string = 'dragAppName';
      let coveredName: string = 'coveredName';
      let folderName: string = 'folderName';
      let fallIndex: number = 1;
      // dock栏合并文件夹
      expect(DragAccessibilityUtils.textAnnouncedForDropMergeToDock(dragAppName, coveredName,
        folderName, fallIndex) === undefined).assertTrue();

      // 无障碍朗读模式关闭场景
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForDropMergeToDock(dragAppName, coveredName,
        folderName, fallIndex) === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForDropToFolder', Level.LEVEL0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);

      let dragAppName: string = 'dragAppName';
      let coveredName: string = 'coveredName';
      expect(DragAccessibilityUtils.textAnnouncedForDropToFolder(dragAppName, coveredName) === undefined).assertTrue();

      // 无障碍朗读模式关闭场景
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForDropToFolder(dragAppName, coveredName) === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForMultiDragStart_test01', 0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      expect(DragAccessibilityUtils.textAnnouncedForMultiDragStart(0) === undefined).assertTrue();
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForMultiDragStart(0) === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForMoveToMergeCard_test01', 0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      let coveredName: string = 'coveredName';
      expect(DragAccessibilityUtils.textAnnouncedForMoveToMergeCard(coveredName) === undefined).assertTrue();
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForMoveToMergeCard(coveredName) === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForMoveToFormStack_test01', 0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      let coveredName: string = 'coveredName';
      expect(DragAccessibilityUtils.textAnnouncedForMoveToFormStack(coveredName) === undefined).assertTrue();
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForMoveToFormStack(coveredName) === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForMultiDrop_test01', 0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      expect(DragAccessibilityUtils.textAnnouncedForMultiDrop(0) === undefined).assertTrue();
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForMultiDrop(0) === undefined).assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForDropMergeToFormStack_test01', 0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      let dragItemName: string = 'dragItemName';
      let coveredName: string = 'coveredName';
      expect(DragAccessibilityUtils.textAnnouncedForDropMergeToFormStack(dragItemName, coveredName) === undefined)
        .assertTrue();
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForDropMergeToFormStack(coveredName, coveredName) === undefined)
        .assertTrue();
    })

    it('DragAccessibilityUtils_textAnnouncedForDropToFormStack_test01', 0, (): void => {
      let isAvailable = mocker.mockFunc(DragAccessibilityUtils, DragAccessibilityUtils.isAccessibilityMode);
      when(isAvailable)().afterReturn(true);
      let dragItemName: string = 'dragItemName';
      let coveredName: string = 'coveredName';
      expect(DragAccessibilityUtils.textAnnouncedForDropToFormStack(dragItemName, coveredName) === undefined)
        .assertTrue();
      when(isAvailable)().afterReturn(false);
      expect(DragAccessibilityUtils.textAnnouncedForDropToFormStack(coveredName, coveredName) === undefined)
        .assertTrue();
    })
  })
}
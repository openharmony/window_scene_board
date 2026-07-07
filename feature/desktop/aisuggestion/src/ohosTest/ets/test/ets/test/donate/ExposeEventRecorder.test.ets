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

import {
  afterAll,
  afterEach,
  beforeAll,
  beforeEach,
  describe,
  it,
  MockKit,
  when,
} from '@ohos/hypium';
import { GridLayoutItemInfo } from '@ohos/launchercommon';
import { ExposeEventRecorder } from '../../../../../../main/ets/default/donate/ExposeEventRecorder';
import { AbilityFormUtil } from '../../../../../../main/ets/default/utils/AbilityFormUtil';

/**
 * ExposeEventRecorder测试
 *
 * @since 2023-10-17
 */
export function ExposeEventRecorderTest() {
  describe('ExposeEventRecorderTest', () => {
    let mocker: MockKit = new MockKit();
    const mockIsAbilityFormVisible: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.isAbilityFormVisible);
    const mockGetAiSuggestionItems: Function = mocker.mockFunc(AbilityFormUtil, AbilityFormUtil.getAllAiSuggestionItems);

    const initExposeEventTemps: (cardId: string) => void = (cardId: string): void => {
      let layoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      layoutItemInfo.cardId = cardId;
      when(mockGetAiSuggestionItems)().afterReturn([ layoutItemInfo ]);
      when(mockIsAbilityFormVisible)(layoutItemInfo.cardId).afterReturn(true);
      // 初始化mExposeEventTemps数组
      ExposeEventRecorder.getInstance().recordExposeOnPageChange();
    }

    beforeAll(() => {
    });

    beforeEach(() => {
    });

    afterEach(() => {
      mocker.clear(AbilityFormUtil);
    });

    afterAll(() => {
      mocker.clearAll();
    });

    // 卡片刷新
    it('testRecordExposeOnRefresh', 0, () => {
      ExposeEventRecorder.getInstance().recordExposeOnRefresh('132');

      let cardId: string = '';
      when(mockIsAbilityFormVisible)(cardId).afterReturn(true);
      ExposeEventRecorder.getInstance().recordExposeOnRefresh(cardId);

      // 初始化mExposeEventTemps数组
      initExposeEventTemps(cardId);

      // 执行recordExposeStart语句
      ExposeEventRecorder.getInstance().recordExposeOnRefresh(cardId);

      when(mockIsAbilityFormVisible)(cardId).afterReturn(false);
      ExposeEventRecorder.getInstance().recordExposeOnRefresh(cardId);

      // 清理ExposeEventTemps
      ExposeEventRecorder.getInstance().recordExposeEndAll();
    });

    it('testRecordExposeEndByFormId', 0, () => {
      // 初始化mExposeEventTemps数组
      let cardId: string = '';
      initExposeEventTemps(cardId);

      let anotherCardId: string = '1';
      ExposeEventRecorder.getInstance().recordExposeEndByFormId(anotherCardId);

      ExposeEventRecorder.getInstance().recordExposeEndByFormId(cardId);

      // 清理ExposeEventTemps
      ExposeEventRecorder.getInstance().recordExposeEndAll();
    });

    it('testRecordExposeOnPageChange', 0, () => {
      when(mockGetAiSuggestionItems)().afterReturnNothing();
      ExposeEventRecorder.getInstance().recordExposeOnPageChange();

      when(mockGetAiSuggestionItems)().afterReturn([]);
      ExposeEventRecorder.getInstance().recordExposeOnPageChange();

      let layoutItemInfo: GridLayoutItemInfo = new GridLayoutItemInfo();
      layoutItemInfo.cardId = '';
      when(mockGetAiSuggestionItems)().afterReturn([ layoutItemInfo ]);
      when(mockIsAbilityFormVisible)(layoutItemInfo.cardId).afterReturn(true);
      // 初始化mExposeEventTemps数组
      ExposeEventRecorder.getInstance().recordExposeOnPageChange();

      // 清除掉cardId为0的记录信息
      when(mockIsAbilityFormVisible)(layoutItemInfo.cardId).afterReturn(false);
      // 触发recordExposeEndWhenInvisible分支
      ExposeEventRecorder.getInstance().recordExposeOnPageChange();
    });

    it('testRecordExposeEndWhenInvisible', 0, () => {
      // 初始化mExposeEventTemps数组
      let cardId: string = '';
      initExposeEventTemps(cardId);

      when(mockIsAbilityFormVisible)(0).afterReturn(false);
      ExposeEventRecorder.getInstance().recordExposeEndWhenInvisible();

      when(mockIsAbilityFormVisible)(0).afterReturn(true);
      ExposeEventRecorder.getInstance().recordExposeEndWhenInvisible();

      // 清理ExposeEventTemps
      ExposeEventRecorder.getInstance().recordExposeEndAll();
    });

    it('testRecordExposeEndAll', 0, () => {
      // 初始化mExposeEventTemps数组
      let cardId: string = '';
      initExposeEventTemps(cardId);

      ExposeEventRecorder.getInstance().recordExposeEndAll();
    });
  })
}
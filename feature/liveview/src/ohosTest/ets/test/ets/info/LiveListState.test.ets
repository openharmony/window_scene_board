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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { LiveListState } from '../../../../../main/ets/info/LiveListState';

/**
 * 实况面板状态数据测试用例
 */
export function LiveListStateTest() {
  describe('LiveListStateTest', (): void => {
    beforeAll((): void => {

    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    // 测试获取实况面板状态管理器
    it('test_LiveListState_default', Level.LEVEL0, (): void => {
      let state = new LiveListState();
      expect(state.isViewClip).assertFalse();
    });

    // 测试设置组件切割状态
    it('test_setViewClip', Level.LEVEL0, (): void => {
      let state = new LiveListState();
      state.setViewClip(true);
      expect(state.isViewClip).assertTrue();
    });
  });
}
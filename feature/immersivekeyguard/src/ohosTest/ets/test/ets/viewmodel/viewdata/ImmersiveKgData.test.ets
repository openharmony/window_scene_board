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
import { ImmersiveKgData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveKgData';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveKgDataTest() {
  describe('ImmersiveKgDataTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_getDataName', Level.LEVEL0, (): void => {
      let kgData: ImmersiveKgData = new ImmersiveKgData();
      kgData.getDataName();
      expect(kgData).not().assertNull();
    });

    it('test_update', Level.LEVEL0, (): void => {
      let kgData: ImmersiveKgData = new ImmersiveKgData();
      let kgData2: ImmersiveKgData = new ImmersiveKgData();
      let ntfData: ImmersiveNtfData = new ImmersiveNtfData();
      kgData.update(ntfData);
      kgData.update(kgData2);
      kgData2.title = 'title';
      kgData2.content = 'content';
      kgData.update(kgData2, true);
      kgData2.title = 'title1';
      kgData2.content = 'content1';
      kgData.update(kgData2);
      expect(kgData).not().assertNull();
    });

    it('test_setTitle', Level.LEVEL0, (): void => {
      let kgData: ImmersiveKgData = new ImmersiveKgData();
      kgData.setTitle('title', true);
      kgData.setTitle('title');
      expect(kgData).not().assertNull();
    });

    it('test_setContent', Level.LEVEL0, (): void => {
      let kgData: ImmersiveKgData = new ImmersiveKgData();
      kgData.setContent('content', true);
      kgData.setContent('content');
      expect(kgData).not().assertNull();
    });
  });
}
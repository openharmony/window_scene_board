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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level, expect } from '@ohos/hypium';
import { ImmersiveNtfSceneHelper } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfSceneHelper';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveNtfSceneHelperTest() {
  describe('ImmersiveNtfSceneHelperTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('test_onNtfAdd', Level.LEVEL0, (): void => {
      let sceneHelper = new ImmersiveNtfSceneHelper();
      sceneHelper.onNtfAdd('');
      sceneHelper.onNtfAdd('MyHashCode');
      expect(sceneHelper).not().assertNull();
    });

    it('test_onNtfUpdate', Level.LEVEL0, (): void => {
      let sceneHelper = new ImmersiveNtfSceneHelper();
      sceneHelper.onNtfAdd('MyHashCode');
      sceneHelper.onNtfUpdate('');
      sceneHelper.onNtfUpdate('MyHashCode');
      expect(sceneHelper).not().assertNull();
    });

    it('test_setImmersiveDataScene', Level.LEVEL0, (): void => {
      let sceneHelper = new ImmersiveNtfSceneHelper();
      sceneHelper.setImmersiveDataScene('', '');
      sceneHelper.setImmersiveDataScene('testKey', '');
      sceneHelper.onNtfAdd('MyHashCode');
      sceneHelper.setImmersiveDataScene('testKey', 'MyHashCode');
      sceneHelper.getImmersiveDataScene('testKey');
      expect(sceneHelper).not().assertNull();
    });
  });
}
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
import { HashMap, LightWeightMap, TreeMap } from '@kit.ArkTS';
import { describe, expect, it, TestType } from '@ohos/hypium';
import { MapUtils } from '@ohos/themeservicebase/Index';

export default function MapUtilsTest() {
  describe('MapUtils_isNull', () => {
    it('test01_null', TestType.FUNCTION, () => {
      // 测试传入null的情况
      expect(MapUtils.isNull(undefined)).assertTrue();
    });

    it('test02_empty_HashMap', TestType.FUNCTION, () => {
      // 测试传入空的HashMap的情况
      expect(MapUtils.isNull(new HashMap())).assertTrue();
    });

    it('test02_empty_LightWeightMap', TestType.FUNCTION, () => {
      // 测试传入空的LightWeightMap的情况
      expect(MapUtils.isNull(new LightWeightMap())).assertTrue();
    });

    it('test02_empty_TreeMap', TestType.FUNCTION, () => {
      // 测试传入空的TreeMap的情况
      expect(MapUtils.isNull(new TreeMap())).assertTrue();
    });

    it('test03_non_empty_HashMap', TestType.FUNCTION, () => {
      // 测试传入非空的HashMap的情况
      const map: HashMap<string, string> = new HashMap();
      map.set('key', 'value');
      expect(MapUtils.isNull(map)).assertFalse();
    });

    it('test03_non_empty_LightWeightMap', TestType.FUNCTION, () => {
      // 测试传入非空的LightWeightMap的情况
      const map: LightWeightMap<string, string> = new LightWeightMap();
      map.set('key', 'value');
      expect(MapUtils.isNull(map)).assertFalse();
    });

    it('test03_non_empty_TreeMap', TestType.FUNCTION, () => {
      // 测试传入非空的TreeMap的情况
      const map: TreeMap<string, string> = new TreeMap();
      map.set('key', 'value');
      expect(MapUtils.isNull(map)).assertFalse();
    });
  });
}
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

import { afterAll, afterEach, beforeAll, beforeEach, it, describe, expect } from '@ohos/hypium';
import { Serializable } from '../../../../../../../main/ets/manager/serialization/Serializable';
import { JsonUtils } from '../../../../../../../main/ets/manager/serialization/JsonUtils';

export function JsonUtilsTest() {
  describe('JsonUtilsTest', (): void => {
    beforeAll((): void => {

    })
    beforeEach((): void => {

    })
    afterAll((): void => {

    })
    afterEach((): void => {

    })

    it('JsonUtilsTest_toJson', 0, (): void => {
      expect(JsonUtils.toJson(null)).assertEqual('');
      let jsonStr = JSON.stringify({ "a": 1, "b": 2 });
      expect(JsonUtils.toJson({ "a": 1, "b": 2 })).assertEqual(jsonStr);
    })

    it('JsonUtilsTest_parse', 0, (): void => {
      expect(JsonUtils.parse(JsonModel, null)).assertUndefined();
      let model = new JsonModel('test_name', 22);
      let json = JSON.stringify(model);
      let jsonModel: JsonModel = JsonUtils.parse<JsonModel>(JsonModel, json);
      expect(model instanceof JsonModel).assertTrue();
      expect(jsonModel instanceof Object).assertTrue();
      expect(jsonModel.name === model.name && jsonModel.age === model.age).assertTrue();
    })
  })

  class JsonModel implements Serializable {
    name: string;
    age: number;

    constructor(name: string, age: number) {
      this.name = name;
      this.age = age;
    }

    deserialize(obj: object): void {
      if (obj == null) {
        return;
      }
      let oriObj = obj as JsonModel;
      this.name = oriObj.name;
      this.age = oriObj.age;
    }

    equals(other: object): boolean {
      if (!(other instanceof JsonModel)) {
        return false;
      }
      let otherData = other as JsonModel;
      return this.name === otherData.name && this.age == otherData.age;
    }
  }
}
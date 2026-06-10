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

import { describe, expect, it, TestType } from '@ohos/hypium';
import ArrayList from '@ohos.util.ArrayList';
import List from '@ohos.util.List';
import LinkedList from '@ohos.util.LinkedList';
import LightWeightMap from '@ohos.util.LightWeightMap';
import TreeMap from '@ohos.util.TreeMap';
import HashMap from '@ohos.util.HashMap';
import { JsonUtils, OhosListTypes, TsLog } from '@ohos/themeservicebase/Index';

export interface JsonBean {
  name: string;
  age: number;
}

interface JsonHandleBean {
  a: number;
  b: JsonHandleChildBean;
}

interface JsonHandleChildBean { c: number; }

interface JsonCircularBean {
  a: number;
  b?: object;
}

interface JsonErrorBean {
  a: number;
  b: Map<string, object>;
}


export function JsonUtilsTestStringify() {
  describe('JsonUtils_stringify', () => {
    it('should_return_a_string_representation_of_a_simple_object', TestType.FUNCTION, () => {
      const obj: JsonBean = { name: '1', age: 2 };
      expect(JsonUtils.stringify(obj)).assertEqual('{"name":"1","age":2}');
    });
    it('should_handle_Map_objects', TestType.FUNCTION, () => {
      const map: Map<string, number> = new Map<string, number>();
      map.set('a', 1);
      map.set('b', 2);
      expect(JsonUtils.stringify(map)).assertEqual('{"a":1,"b":2}');
    });

    it('should_handle_ArrayList_objects', TestType.FUNCTION, () => {
      const arrayList: ArrayList<number> = new ArrayList();
      arrayList.add(1);
      arrayList.add(2);
      expect(JsonUtils.stringify(arrayList)).assertEqual('[1,2]');
    });

    it('should_handle_nested_objects', TestType.FUNCTION, () => {
      const obj: JsonHandleBean = {
        a: 1, b: {
          c: 2
        }
      };
      expect(JsonUtils.stringify(obj)).assertEqual('{"a":1,"b":{"c":2}}');
    });

    it('should_handle_circular_references', TestType.FUNCTION, () => {
      const obj: JsonCircularBean = { a: 1 };
      obj.b = new Object();
      expect(JsonUtils.stringify(obj)).assertEqual('{"a":1,"b":{}}');
    });

    it('should_handle_errors', TestType.FUNCTION, () => {
      const obj: JsonErrorBean = { a: 1, b: new Map() };
      obj.b.set('c', obj);
      expect(JsonUtils.stringify(obj)).assertUndefined();
    });
  });
}

export function JsonUtilsTestParse() {
  describe('JsonUtils_parse', () => {
    it('should_return_the_correct_object_when_input_is_a_valid_JSON_string', TestType.FUNCTION, () => {
      const jsonStr: string = '{"name": "John", "age": 30}';
      let jsonBean: JsonBean = {
        name: "John", age: 30
      };
      expect(JsonUtils.parse<JsonBean>(jsonStr)).assertDeepEquals(jsonBean);
    });

    it('should_throw_an_error_when_input_is_an_invalid_JSON_string', TestType.FUNCTION, () => {
      const jsonStr: string = '{"name": "John", "age": 30';
      expect(JsonUtils.parse<JsonBean>(jsonStr)).assertUndefined();
    });
  });
}

class JsonMixBean {
  name: string = '';
  id: number = 0;
  map: Map<string, string> = new Map();
  hashmap: HashMap<string, string> = new HashMap();
  treemap: TreeMap<string, string> = new TreeMap();
  lightWeightMap: LightWeightMap<string, string> = new LightWeightMap();
  arrayList: ArrayList<string> = new ArrayList();
  list: List<string> = new List();
  linkedList: LinkedList<string> = new LinkedList();
  childBean: JsonChildMixBean = new JsonChildMixBean();
}

class JsonChildMixBean {
  name: string = '';
  id: number = 0;
  map: Map<string, string> = new Map();
  hashmap: HashMap<string, string> = new HashMap();
  treemap: TreeMap<string, string> = new TreeMap();
  lightWeightMap: LightWeightMap<string, string> = new LightWeightMap();
  arrayList: ArrayList<string> = new ArrayList();
  list: List<string> = new List();
  linkedList: LinkedList<string> = new LinkedList();
}

const TAG: string = 'JsonUtils.test';

export function JsonTransformerTest() {
  let expectBean: JsonMixBean;
  let actualBean: JsonMixBean;
  TsLog.debug(TAG, 'JsonTransformerTest before');
  expectBean = new JsonMixBean();
  expectBean.name = 'name';
  expectBean.id = 100;
  expectBean.map.set('mapKey', 'map_value');
  expectBean.hashmap.set('hashmap1', 'hashmap_value1');
  expectBean.hashmap.set('hashmap2', 'hashmap_value2');
  expectBean.treemap.set('treemap1', 'treemap_value1');
  expectBean.treemap.set('treemap2', 'treemap_value2');
  expectBean.lightWeightMap.set('lightWeightMap1', 'lightWeightMap_value1');
  expectBean.lightWeightMap.set('lightWeightMap2', 'lightWeightMap_value2');
  expectBean.arrayList.add('arrayLit_1');
  expectBean.arrayList.add('arrayLit_2');
  expectBean.list.add('list_1');
  expectBean.list.add('list_2');
  expectBean.linkedList.add('linkedList_1');
  expectBean.linkedList.add('linkedList_2');
  expectBean.childBean.name = 'name';
  expectBean.childBean.id = 100;
  expectBean.childBean.map.set('mapKey', 'map_value');
  expectBean.childBean.hashmap.set('hashmap1', 'hashmap_value1');
  expectBean.childBean.hashmap.set('hashmap2', 'hashmap_value2');
  expectBean.childBean.treemap.set('treemap1', 'treemap_value1');
  expectBean.childBean.treemap.set('treemap2', 'treemap_value2');
  expectBean.childBean.lightWeightMap.set('lightWeightMap1', 'lightWeightMap_value1');
  expectBean.childBean.lightWeightMap.set('lightWeightMap2', 'lightWeightMap_value2');
  expectBean.childBean.arrayList.add('arrayLit_1');
  expectBean.childBean.arrayList.add('arrayLit_2');
  expectBean.childBean.list.add('list_1');
  expectBean.childBean.list.add('list_2');
  expectBean.childBean.linkedList.add('linkedList_1');
  actualBean = JsonUtils.parse(JsonUtils.stringify(expectBean)??'', new JsonMixBean())!;

  describe('JsonTransformerTest', () => {
    assertNoTransformer(actualBean, expectBean);
    assertMap(expectBean, actualBean);
    assertHashMap(expectBean, actualBean);
    assertTreeMap(expectBean, actualBean);
    assertLightWeightMap(expectBean, actualBean);
    assertList(expectBean, actualBean);
  });
}

function assertNoTransformer(actualBean: JsonMixBean, expectBean: JsonMixBean) {
  it('test_NoTransformer', TestType.FUNCTION, () => {
    expect(actualBean.name).assertEqual(expectBean.name);
    expect(actualBean.id).assertEqual(expectBean.id);
  });
  it('test_childNoTransformer', TestType.FUNCTION, () => {
    expect(actualBean.childBean.name).assertEqual(expectBean.childBean.name);
    expect(actualBean.childBean.id).assertEqual(expectBean.childBean.id);
  });
}

function assertList(expectBean: JsonMixBean, actualBean: JsonMixBean) {
  it('test_Transformer_ArrayList', TestType.FUNCTION, () => {
    expect(expectBean.arrayList instanceof ArrayList).assertTrue();
    expect(actualBean.arrayList.length).assertEqual(expectBean.arrayList.length);
    expect(listEquals<JsonMixBean>(actualBean.arrayList, expectBean.arrayList)).assertTrue();
  });
  it('test_Transformer_ChildArrayList', TestType.FUNCTION, () => {
    expect(expectBean.childBean.arrayList instanceof ArrayList).assertTrue();
    expect(actualBean.childBean.arrayList.length).assertEqual(expectBean.childBean.arrayList.length);
    expect(listEquals<JsonMixBean>(actualBean.childBean.arrayList, expectBean.childBean.arrayList)).assertTrue();
  });

  it('test_Transformer_List', TestType.FUNCTION, () => {
    expect(expectBean.list instanceof List).assertTrue();
    expect(actualBean.list.length).assertEqual(expectBean.list.length);
    expect(listEquals<JsonMixBean>(actualBean.list, expectBean.list)).assertTrue();
  });

  it('test_Transformer_childList', TestType.FUNCTION, () => {
    expect(expectBean.childBean.list instanceof List).assertTrue();
    expect(actualBean.childBean.list.length).assertEqual(expectBean.childBean.list.length);
    expect(listEquals<JsonMixBean>(actualBean.childBean.list, expectBean.childBean.list)).assertTrue();
  });
  it('test_Transformer_LinkedList', TestType.FUNCTION, () => {
    expect(expectBean.linkedList instanceof LinkedList).assertTrue();
    expect(actualBean.linkedList.length).assertEqual(expectBean.linkedList.length);
    expect(listEquals<JsonMixBean>(actualBean.linkedList, expectBean.linkedList)).assertTrue();
  });


  it('test_Transformer_childLinkedList', TestType.FUNCTION, () => {
    expect(expectBean.childBean.linkedList instanceof LinkedList).assertTrue();
    expect(actualBean.childBean.linkedList.length).assertEqual(expectBean.childBean.linkedList.length);
    expect(listEquals<JsonMixBean>(actualBean.childBean.linkedList, expectBean.childBean.linkedList)).assertTrue();
  });
}

function assertLightWeightMap(expectBean: JsonMixBean, actualBean: JsonMixBean) {
  it('test_Transformer_LightWeightMap', TestType.FUNCTION, () => {
    expect(expectBean.lightWeightMap instanceof LightWeightMap).assertTrue();
    expect(actualBean.lightWeightMap.length).assertEqual(expectBean.lightWeightMap.length);
    expect(actualBean.lightWeightMap.get('lightWeightMap1'))
      .assertEqual(expectBean.lightWeightMap.get('lightWeightMap1'));
    expect(actualBean.lightWeightMap.get('lightWeightMap2'))
      .assertEqual(expectBean.lightWeightMap.get('lightWeightMap2'));
  });

  it('test_Transformer_ChildLightWeightMap', TestType.FUNCTION, () => {
    expect(expectBean.childBean.lightWeightMap instanceof LightWeightMap).assertTrue();
    expect(actualBean.childBean.lightWeightMap.length).assertEqual(expectBean.childBean.lightWeightMap.length);
    expect(actualBean.childBean.lightWeightMap.get('lightWeightMap1'))
      .assertEqual(expectBean.childBean.lightWeightMap.get('lightWeightMap1'));
    expect(actualBean.childBean.lightWeightMap.get('lightWeightMap2'))
      .assertEqual(expectBean.childBean.lightWeightMap.get('lightWeightMap2'));
  });
}

function assertTreeMap(expectBean: JsonMixBean, actualBean: JsonMixBean) {
  it('test_Transformer_TreeMap', TestType.FUNCTION, () => {
    expect(expectBean.treemap instanceof TreeMap).assertTrue();
    expect(actualBean.treemap.length).assertEqual(expectBean.treemap.length);
    expect(actualBean.treemap.get('treemap1')).assertEqual(expectBean.treemap.get('treemap1'));
    expect(actualBean.treemap.get('treemap2')).assertEqual(expectBean.treemap.get('treemap2'));
  });

  it('test_Transformer_ChildTreeMap', TestType.FUNCTION, () => {
    expect(expectBean.childBean.treemap instanceof TreeMap).assertTrue();
    expect(actualBean.childBean.treemap.length).assertEqual(expectBean.childBean.treemap.length);
    expect(actualBean.childBean.treemap.get('treemap1')).assertEqual(expectBean.childBean.treemap.get('treemap1'));
    expect(actualBean.childBean.treemap.get('treemap2')).assertEqual(expectBean.childBean.treemap.get('treemap2'));
  });
}

function assertHashMap(expectBean: JsonMixBean, actualBean: JsonMixBean) {
  it('test_Transformer_HashMap', TestType.FUNCTION, async () => {
    expect(expectBean.hashmap instanceof HashMap).assertTrue();
    expect(actualBean.hashmap.length).assertEqual(expectBean.hashmap.length);
    expect(actualBean.hashmap.get('hashmap1')).assertEqual(expectBean.hashmap.get('hashmap1'));
    expect(actualBean.hashmap.get('hashmap2')).assertEqual(expectBean.hashmap.get('hashmap2'));

    expect(expectBean.childBean.hashmap instanceof HashMap).assertTrue();
    expect(actualBean.childBean.hashmap.length).assertEqual(expectBean.childBean.hashmap.length);
    expect(actualBean.childBean.hashmap.get('hashmap1')).assertEqual(expectBean.childBean.hashmap.get('hashmap1'));
    expect(actualBean.childBean.hashmap.get('hashmap2')).assertEqual(expectBean.childBean.hashmap.get('hashmap2'));
  });

  it('test_Transformer_child_HashMap', TestType.FUNCTION, async () => {
    expect(expectBean.childBean.hashmap instanceof HashMap).assertTrue();
    expect(actualBean.childBean.hashmap.length).assertEqual(expectBean.childBean.hashmap.length);
    expect(actualBean.childBean.hashmap.get('hashmap1')).assertEqual(expectBean.childBean.hashmap.get('hashmap1'));
    expect(actualBean.childBean.hashmap.get('hashmap2')).assertEqual(expectBean.childBean.hashmap.get('hashmap2'));
  });
}

function assertMap(expectBean: JsonMixBean, actualBean: JsonMixBean) {
  it('test_Transformer_Map', TestType.FUNCTION, () => {
    expect(expectBean.map instanceof Map).assertTrue();
    expect(actualBean.map.size).assertEqual(expectBean.map.size);
    expect(actualBean.map.get('mapKey')).assertEqual(expectBean.map.get('mapKey'));
  });

  it('test_Transformer_Child_Map', TestType.FUNCTION, () => {
    expect(expectBean.childBean.map instanceof Map).assertTrue();
    expect(actualBean.childBean.map.size).assertEqual(expectBean.childBean.map.size);
    expect(actualBean.childBean.map.get('mapKey')).assertEqual(expectBean.childBean.map.get('mapKey'));
  });
}

function listEquals<T>(collection1: OhosListTypes, collection2: OhosListTypes): boolean {
  if (collection1.length != collection2.length) {
    return false;
  }
  for (const element of collection1) {
    if (!collection2.has(element)) {
      return false;
    }
  }
  return true;
}
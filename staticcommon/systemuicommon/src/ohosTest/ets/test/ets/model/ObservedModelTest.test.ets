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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';
import { ObservedArray } from '../../../main/ets/model/ObservedModel';
export default function ObservedArrayTest() {
  describe('clear_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });


    it('should_do_nothing_when_length_is_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_splice_when_length_is_not_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.push(1, 2, 3);
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_return_undefined_when_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      const result = observedmap.first();
      expect(result).assertUndefined();
    });

    it('should_return_value_when_map_is_not_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      observedmap.set('key1', 'value1');
      const result = observedmap.first();
      expect(result).assertEqual('value1');
    });

    it('should_return_undefined_when_map_is_not_empty_but_no_keys', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      observedmap.set('key1', 'value1');
      observedmap.clear();
      const result = observedmap.first();
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      const result = observedmap.last();
      expect(result).assertUndefined();
    });

    it('should_return_last_value_when_map_is_not_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      observedmap.set('key1', 'value1');
      observedmap.set('key2', 'value2');
      const result = observedmap.last();
      expect(result).assertEqual('value2');
    });

    it('should_return_undefined_when_last_key_is_undefined', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      observedmap.set('key1', 'value1');
      observedmap.set('key2', 'value2');
      observedmap.delete('key2');
      const result = observedmap.last();
      expect(result).assertUndefined();
    });

    it('should_return_true_when_every_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      observedmap.set('one', 1);
      observedmap.set('two', 2);
      observedmap.set('three', 3);

      const result = observedmap.every((value, index) => value > index);
      expect(result).assertTrue();
    });

    it('should_return_false_when_some_element_does_not_match_the_predicate', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      observedmap.set('one', 1);
      observedmap.set('two', 2);
      observedmap.set('three', 3);

      const result = observedmap.every((value, index) => value > index + 1);
      expect(result).assertFalse();
    });

    it('should_return_true_when_the_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      const result = observedmap.every((value, index) => true);
      expect(result).assertTrue();
    });
    it('should_return_true_when_some_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      observedmap.set(1, "foo");
      observedmap.set(2, "bar");
      observedmap.set(3, "baz");

      const result = observedmap.some((value, index) => {
        return index === 1;
      });
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_no_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      observedmap.set(1, "foo");
      observedmap.set(2, "bar");
      observedmap.set(3, "baz");

      const result = observedmap.some((value, index) => {
        return index === 4;
      });
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_the_map_is_empty', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      const result = observedmap.some((value, index) => {
        return index === 1;
      });
      expect(result).assertEqual(false);
    });

    it('should_do_nothing_when_length_is_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_splice_when_length_is_not_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.push(1, 2, 3);
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_return_undefined_when_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      const result = observedmap.first();
      expect(result).assertUndefined();
    });

    it('should_return_value_when_map_is_not_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      observedmap.set('key1', 'value1');
      const result = observedmap.first();
      expect(result).assertEqual('value1');
    });

    it('should_return_undefined_when_map_is_not_empty_but_no_keys', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      observedmap.set('key1', 'value1');
      observedmap.clear();
      const result = observedmap.first();
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      const result = observedmap.last();
      expect(result).assertUndefined();
    });

    it('should_return_last_value_when_map_is_not_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      observedmap.set('key1', 'value1');
      observedmap.set('key2', 'value2');
      const result = observedmap.last();
      expect(result).assertEqual('value2');
    });

    it('should_return_undefined_when_last_key_is_undefined', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      observedmap.set('key1', 'value1');
      observedmap.set('key2', 'value2');
      observedmap.delete('key2');
      const result = observedmap.last();
      expect(result).assertUndefined();
    });

    it('should_return_true_when_every_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      observedmap.set('one', 1);
      observedmap.set('two', 2);
      observedmap.set('three', 3);

      const result = observedmap.every((value, index) => value > index);
      expect(result).assertTrue();
    });

    it('should_return_false_when_some_element_does_not_match_the_predicate', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      observedmap.set('one', 1);
      observedmap.set('two', 2);
      observedmap.set('three', 3);

      const result = observedmap.every((value, index) => value > index + 1);
      expect(result).assertFalse();
    });

    it('should_return_true_when_the_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      const result = observedmap.every((value, index) => true);
      expect(result).assertTrue();
    });
    it('should_return_true_when_some_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      observedmap.set(1, "foo");
      observedmap.set(2, "bar");
      observedmap.set(3, "baz");

      const result = observedmap.some((value, index) => {
        return index === 1;
      });
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_no_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      observedmap.set(1, "foo");
      observedmap.set(2, "bar");
      observedmap.set(3, "baz");

      const result = observedmap.some((value, index) => {
        return index === 4;
      });
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_the_map_is_empty', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      const result = observedmap.some((value, index) => {
        return index === 1;
      });
      expect(result).assertEqual(false);
    });

    it('should_do_nothing_when_length_is_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_splice_when_length_is_not_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.push(1, 2, 3);
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_return_undefined_when_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      const result = observedmap.first();
      expect(result).assertUndefined();
    });

    it('should_return_value_when_map_is_not_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      observedmap.set('key1', 'value1');
      const result = observedmap.first();
      expect(result).assertEqual('value1');
    });

    it('should_return_undefined_when_map_is_not_empty_but_no_keys', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      observedmap.set('key1', 'value1');
      observedmap.clear();
      const result = observedmap.first();
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      const result = observedmap.last();
      expect(result).assertUndefined();
    });

    it('should_return_last_value_when_map_is_not_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      observedmap.set('key1', 'value1');
      observedmap.set('key2', 'value2');
      const result = observedmap.last();
      expect(result).assertEqual('value2');
    });

    it('should_return_undefined_when_last_key_is_undefined', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      observedmap.set('key1', 'value1');
      observedmap.set('key2', 'value2');
      observedmap.delete('key2');
      const result = observedmap.last();
      expect(result).assertUndefined();
    });

    it('should_return_true_when_every_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      observedmap.set('one', 1);
      observedmap.set('two', 2);
      observedmap.set('three', 3);

      const result = observedmap.every((value, index) => value > index);
      expect(result).assertTrue();
    });

    it('should_return_false_when_some_element_does_not_match_the_predicate', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      observedmap.set('one', 1);
      observedmap.set('two', 2);
      observedmap.set('three', 3);

      const result = observedmap.every((value, index) => value > index + 1);
      expect(result).assertFalse();
    });

    it('should_return_true_when_the_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      const result = observedmap.every((value, index) => true);
      expect(result).assertTrue();
    });
    it('should_return_true_when_some_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      observedmap.set(1, "foo");
      observedmap.set(2, "bar");
      observedmap.set(3, "baz");

      const result = observedmap.some((value, index) => {
        return index === 1;
      });
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_no_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      observedmap.set(1, "foo");
      observedmap.set(2, "bar");
      observedmap.set(3, "baz");

      const result = observedmap.some((value, index) => {
        return index === 4;
      });
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_the_map_is_empty', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      const result = observedmap.some((value, index) => {
        return index === 1;
      });
      expect(result).assertEqual(false);
    });

    it('should_do_nothing_when_length_is_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_splice_when_length_is_not_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.push(1, 2, 3);
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_return_undefined_when_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      const result = observedmap.first();
      expect(result).assertUndefined();
    });

    it('should_return_value_when_map_is_not_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      observedmap.set('key1', 'value1');
      const result = observedmap.first();
      expect(result).assertEqual('value1');
    });

    it('should_return_undefined_when_map_is_not_empty_but_no_keys', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      observedmap.set('key1', 'value1');
      observedmap.clear();
      const result = observedmap.first();
      expect(result).assertUndefined();
    });

    it('should_return_undefined_when_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      const result = observedmap.last();
      expect(result).assertUndefined();
    });

    it('should_return_last_value_when_map_is_not_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      observedmap.set('key1', 'value1');
      observedmap.set('key2', 'value2');
      const result = observedmap.last();
      expect(result).assertEqual('value2');
    });

    it('should_return_undefined_when_last_key_is_undefined', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap<string, string>();
      observedmap.set('key1', 'value1');
      observedmap.set('key2', 'value2');
      observedmap.delete('key2');
      const result = observedmap.last();
      expect(result).assertUndefined();
    });

    it('should_return_true_when_every_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      observedmap.set('one', 1);
      observedmap.set('two', 2);
      observedmap.set('three', 3);

      const result = observedmap.every((value, index) => value > index);
      expect(result).assertTrue();
    });

    it('should_return_false_when_some_element_does_not_match_the_predicate', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      observedmap.set('one', 1);
      observedmap.set('two', 2);
      observedmap.set('three', 3);

      const result = observedmap.every((value, index) => value > index + 1);
      expect(result).assertFalse();
    });

    it('should_return_true_when_the_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, number> = new ObservedMap();
      const result = observedmap.every((value, index) => true);
      expect(result).assertTrue();
    });
    it('should_return_true_when_some_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      observedmap.set(1, "foo");
      observedmap.set(2, "bar");
      observedmap.set(3, "baz");

      const result = observedmap.some((value, index) => {
        return index === 1;
      });
      expect(result).assertEqual(true);
    });

    it('should_return_false_when_no_element_matches_the_predicate', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      observedmap.set(1, "foo");
      observedmap.set(2, "bar");
      observedmap.set(3, "baz");

      const result = observedmap.some((value, index) => {
        return index === 4;
      });
      expect(result).assertEqual(false);
    });

    it('should_return_false_when_the_map_is_empty', 0, () => {
      let observedmap: ObservedMap = new ObservedMap();
      const result = observedmap.some((value, index) => {
        return index === 1;
      });
      expect(result).assertEqual(false);
    });

    it('should_do_nothing_when_length_is_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_splice_when_length_is_not_zero', 0, () => {
      let observedarray: ObservedArray = new ObservedArray();
      observedarray.push(1, 2, 3);
      observedarray.clear();
      expect(observedarray.length).assertEqual(0);
    });

    it('should_return_undefined_when_map_is_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      const result = observedmap.first();
      expect(result).assertUndefined();
    });

    it('should_return_value_when_map_is_not_empty', 0, () => {
      let observedmap: ObservedMap<string, string> = new ObservedMap();
      observedmap.set('key1', 'value1');
      const result = observedmap.first();
      expect(result).assertEqual('value1');
    });
  });
}

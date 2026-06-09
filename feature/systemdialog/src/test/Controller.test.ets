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

export default function addDataByKey_Test() {
  describe('addDataByKey', () => {
    it('should_add_data_with_default_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_add_data_with_upper_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.UPPER };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.UPPER);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(1);
    });

    it('should_update_data_when_sysDialogZOrder_is_number', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: 1 };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.data.set(key, { sysDialogZOrder: 0 });

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(1);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_not_push_data_when_needPush_is_false', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });
    it('should_add_data_with_default_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_add_data_with_upper_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.UPPER };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.UPPER);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(1);
    });

    it('should_update_data_when_sysDialogZOrder_is_number', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: 1 };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.data.set(key, { sysDialogZOrder: 0 });

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(1);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_not_push_data_when_needPush_is_false', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });
    it('should_add_data_with_default_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_add_data_with_upper_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.UPPER };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.UPPER);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(1);
    });

    it('should_update_data_when_sysDialogZOrder_is_number', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: 1 };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.data.set(key, { sysDialogZOrder: 0 });

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(1);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_not_push_data_when_needPush_is_false', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });
    it('should_add_data_with_default_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_add_data_with_upper_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.UPPER };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.UPPER);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(1);
    });

    it('should_update_data_when_sysDialogZOrder_is_number', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: 1 };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.data.set(key, { sysDialogZOrder: 0 });

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(1);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_not_push_data_when_needPush_is_false', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_add_data_with_upper_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.UPPER };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.UPPER);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(1);
    });

    it('should_update_data_when_sysDialogZOrder_is_number', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: 1 };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.data.set(key, { sysDialogZOrder: 0 });

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(1);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_not_push_data_when_needPush_is_false', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });
    it('should_add_data_with_default_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_add_data_with_upper_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.UPPER };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.UPPER);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(1);
    });

    it('should_update_data_when_sysDialogZOrder_is_number', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: 1 };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.data.set(key, { sysDialogZOrder: 0 });

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(1);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_not_push_data_when_needPush_is_false', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });
    it('should_add_data_with_default_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_add_data_with_upper_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.UPPER };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.UPPER);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(1);
    });

    it('should_update_data_when_sysDialogZOrder_is_number', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: 1 };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.data.set(key, { sysDialogZOrder: 0 });

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(1);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_not_push_data_when_needPush_is_false', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_add_data_with_default_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_add_data_with_upper_sysDialogZOrder', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.UPPER };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.UPPER);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(1);
    });

    it('should_update_data_when_sysDialogZOrder_is_number', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: 1 };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.data.set(key, { sysDialogZOrder: 0 });

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(1);
      expect(dataByKey.defaultList.length).assertEqual(0);
      expect(dataByKey.upperList.length).assertEqual(0);
    });

    it('should_not_push_data_when_needPush_is_false', 0, () => {
      let key: string = "testKey";
      let v: EsObject = { sysDialogZOrder: SysDialogZOrder.DEFAULT };
      let dataByKey: addDataByKey = new addDataByKey();
      dataByKey.data = new Map();
      dataByKey.defaultList = [];
      dataByKey.upperList = [];

      dataByKey.addDataByKey(key, v);

      expect(dataByKey.data.get(key).sysDialogZOrder).assertEqual(SysDialogZOrder.DEFAULT);
      expect(dataByKey.defaultList.length).assertEqual(1);
      expect(dataByKey.upperList.length).assertEqual(0);
    });
  });
}
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
import { ArgumentMatchers, describe, expect, it, MockKit, when } from '@ohos/hypium';
import ThreeButtonUpgradeDSExtAbility
  from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/ability/ThreeButtonUpgradeDSExtAbility';
import { ThreeButtonUpgradeConstants } from '@ohos/phonebase/src/main/ets/SceneBoard/aiBar/ThreeButtonUpgradeConstants';
import { AsyncCallback, settings } from '@kit.BasicServicesKit';
import { dataSharePredicates } from '@kit.ArkData';
import { CheckEmptyUtils } from '@ohos/basicutils';
import rdb from '@ohos.data.relationalStore';
import { SCBGestureNavSetMgr } from '@ohos/componenthelper';
import { common } from '@kit.AbilityKit';

export default function ThreeButtonUpgradeDSExtAbilityTest() {
  describe('ThreeButtonUpgradeDSExtAbilityTest', () => {

    it('onCreate_1', 0, () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      let callback = () => {};
      expect(ability.onCreate(undefined, callback) === undefined).assertTrue();
    });

    it('onCreate_2', 0, () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      ability.context = getContext() as common.ExtensionContext;
      let want = {} as Want;
      let callback = () => {};
      expect(ability.onCreate(want, callback) === undefined).assertTrue();
    });

    it('returnOnCallback_1', 0, () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      expect((ability as object)['returnOnCallback'](undefined, 'test', null) === undefined).assertTrue();
    });

    it('returnOnCallback_2', 0, () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      let callback = () => {};
      expect((ability as object)['returnOnCallback'](callback, 'test', null) === undefined).assertTrue();
    });

    it('returnByResultSet_1', 0, async () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      ability.context = getContext() as common.ExtensionContext;
      let mRdbStore = await rdb.getRdbStore(ability.context, {
        name: ThreeButtonUpgradeConstants.THREE_BUTTON,
        securityLevel: rdb.SecurityLevel.S1
      });
      (ability as object)['mRdbStore'] = mRdbStore;
      let callback = () => {};
      expect((ability as object)['returnByResultSet'](callback, null) === undefined).assertTrue();
    });

    it('returnByResultSet_2', 0, () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      (ability as object)['mRdbStore'] = undefined;
      let callback = () => {};
      let resultSet = {} as rdb.ResultSet;
      expect((ability as object)['returnByResultSet'](callback, resultSet) === undefined).assertTrue();
    });

    it('query_1', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      const columns = ['*'];
      const callback: AsyncCallback<Object> = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ability.context).afterReturn(true);
      ability.query('testUri', predicates, columns, callback);
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('query_2', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      const columns = ['*'];
      const callback: AsyncCallback<Object> = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ability.context).afterReturn(false);
      when(mockIsEmpty)((ability as object)['mRdbStore']).afterReturn(true);
      ability.query('testUri', predicates, columns, callback);
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('query_3', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      const columns = ['*'];
      const callback: AsyncCallback<Object> = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ability.context).afterReturn(false);
      when(mockIsEmpty)((ability as object)['mRdbStore']).afterReturn(false);
      let mockInitThreeButtonDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['initThreeButtonDb']);
      when(mockInitThreeButtonDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));
      ability.query('testUri', predicates, columns, callback);
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.ignoreMock((ability as object), (ability as object)['initThreeButtonDb']);
    })

    it('query_4', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      const columns = ['*'];
      const callback: AsyncCallback<Object> = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ability.context).afterReturn(false);
      when(mockIsEmpty)((ability as object)['mRdbStore']).afterReturn(false);
      let mockInitThreeButtonDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['initThreeButtonDb']);
      when(mockInitThreeButtonDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockDeleteDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['deleteDb']);
      when(mockDeleteDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));
      ability.query('testUri', predicates, columns, callback);
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.ignoreMock((ability as object), (ability as object)['initThreeButtonDb']);
      mocker.ignoreMock((ability as object), (ability as object)['deleteDb']);
    })

    it('query_5', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      const columns = ['*'];
      const callback: AsyncCallback<Object> = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ability.context).afterReturn(false);
      when(mockIsEmpty)((ability as object)['mRdbStore']).afterReturn(false);
      let mockInitThreeButtonDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['initThreeButtonDb']);
      when(mockInitThreeButtonDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockDeleteDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['deleteDb']);
      when(mockDeleteDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockInsertDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['insertDb']);
      when(mockInsertDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(false));
      ability.query('testUri', predicates, columns, callback);
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.ignoreMock((ability as object), (ability as object)['initThreeButtonDb']);
      mocker.ignoreMock((ability as object), (ability as object)['deleteDb']);
      mocker.ignoreMock((ability as object), (ability as object)['insertDb']);
    })

    it('query_6', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      const columns = ['*'];
      const callback: AsyncCallback<Object> = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ability.context).afterReturn(false);
      when(mockIsEmpty)((ability as object)['mRdbStore']).afterReturn(false);
      let mockInitThreeButtonDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['initThreeButtonDb']);
      when(mockInitThreeButtonDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockDeleteDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['deleteDb']);
      when(mockDeleteDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockInsertDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['insertDb']);
      when(mockInsertDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockQueryDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['queryDb']);
      let mockResultSet = {} as rdb.ResultSet;
      when(mockQueryDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(mockResultSet));
      ability.query('testUri', predicates, columns, callback);
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.ignoreMock((ability as object), (ability as object)['initThreeButtonDb']);
      mocker.ignoreMock((ability as object), (ability as object)['deleteDb']);
      mocker.ignoreMock((ability as object), (ability as object)['insertDb']);
      mocker.ignoreMock((ability as object), (ability as object)['queryDb']);
    })

    it('query_7', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      const columns = ['*'];
      const callback: AsyncCallback<Object> = () => {
      };
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ability.context).afterReturn(false);
      when(mockIsEmpty)((ability as object)['mRdbStore']).afterReturn(false);
      let mockInitThreeButtonDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['initThreeButtonDb']);
      when(mockInitThreeButtonDb)().afterReturn(Promise.resolve(true));
      let mockDeleteDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['deleteDb']);
      when(mockDeleteDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockInsertDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['insertDb']);
      when(mockInsertDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(true));
      let mockQueryDb: Function =
        mocker.mockFunc((ability as object), (ability as object)['queryDb']);
      when(mockQueryDb)(ArgumentMatchers.any).afterReturn(Promise.resolve(null));
      ability.query('testUri', predicates, columns, callback);
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      mocker.ignoreMock((ability as object), (ability as object)['initThreeButtonDb']);
      mocker.ignoreMock((ability as object), (ability as object)['deleteDb']);
      mocker.ignoreMock((ability as object), (ability as object)['insertDb']);
      mocker.ignoreMock((ability as object), (ability as object)['queryDb']);
    })

    it('queryDb_1', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(predicates).afterReturn(true);
      (ability as object)['queryDb'](predicates, 'test');
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('queryDb_2', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(predicates).afterReturn(false);
      when(mockIsEmpty)('test').afterReturn(true);
      (ability as object)['queryDb'](predicates, 'test');
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('queryDb_3', 0, () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(false);
      (ability as object)['mRdbStore'] = null;
      (ability as object)['queryDb'](predicates, 'test');
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('queryDb_4', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(false);

      (ability as object)['queryDb'](predicates, 'test');
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    })

    it('initThreeButtonDb_1', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc((ability as object), (ability as object)['executeSql']);
      when(mockFunc)(ArgumentMatchers.anyString).afterReturn(true);
      const result: Promise<boolean> = await (ability as object)['initThreeButtonDb']();
      expect(result).assertEqual(true);
      mocker.ignoreMock((ability as object), (ability as object)['executeSql']);
    });

    it('initThreeButtonDb_2', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc((ability as object), (ability as object)['executeSql']);
      when(mockFunc)(ArgumentMatchers.anyString).afterThrow("Error");
      const result: Promise<boolean> = await (ability as object)['initThreeButtonDb']();
      expect(result).assertEqual(false);
      mocker.ignoreMock((ability as object), (ability as object)['executeSql']);
    });

    it('initRdbStore_1', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      let mocker: MockKit = new MockKit();
      let mockFunc: Function = mocker.mockFunc((ability as object), (ability as object)['executeSql']);
      when(mockFunc)(ArgumentMatchers.anyString).afterThrow("Error");
      const result: Promise<boolean> = await (ability as object)['initThreeButtonDb']();
      expect(result).assertEqual(false);
      mocker.ignoreMock((ability as object), (ability as object)['executeSql']);
    });

    it('executeSql_1', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(true);
      (ability as object)['executeSql']('test');
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    });

    it('executeSql_2', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)('test').afterReturn(false);
      ability.context = getContext() as common.ExtensionContext;
      let mRdbStore = await rdb.getRdbStore(ability.context, {
        name: ThreeButtonUpgradeConstants.THREE_BUTTON,
        securityLevel: rdb.SecurityLevel.S1
      });
      (ability as object)['mRdbStore'] = mRdbStore;
      when(mockIsEmpty)(mRdbStore).afterReturn(true);
      (ability as object)['executeSql']('test');
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    });

    it('executeSql_3', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(ArgumentMatchers.any).afterReturn(false);
      (ability as object)['executeSql']('test');
      expect(ability).not().assertUndefined();
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    });

    it('deleteDb_1', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(predicates).afterReturn(true);
      let result: Promise<boolean> = await (ability as object)['deleteDb'](predicates, 'test');
      expect(result).assertEqual(false);
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    });

    it('deleteDb_2', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(predicates).afterReturn(false);
      when(mockIsEmpty)('test').afterReturn(true);
      let result: Promise<boolean> = await (ability as object)['deleteDb'](predicates, 'test');
      expect(result).assertEqual(false);
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    });

    it('deleteDb_3', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      const predicates = new dataSharePredicates.DataSharePredicates();
      let mocker: MockKit = new MockKit();
      let mockIsEmpty: Function = mocker.mockFunc(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
      when(mockIsEmpty)(predicates).afterReturn(false);
      when(mockIsEmpty)('test').afterReturn(false);
      let result: Promise<boolean> = await (ability as object)['deleteDb'](predicates, 'test');
      expect(result).assertEqual(true);
      mocker.ignoreMock(CheckEmptyUtils, CheckEmptyUtils.isEmpty);
    });

    it('insertDb_1', 0, async () => {
      let ability = new ThreeButtonUpgradeDSExtAbility();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc((ability as object), (ability as object)['checkMigrateClient']);
      when(mockfunc)().afterReturn(Promise.resolve(false));
      const result: Promise<boolean> = await (ability as object)['insertDb']();
      expect(result).assertEqual(true);
      mocker.ignoreMock((ability as object), (ability as object)['checkMigrateClient']);
    });

    it('insertDb_2', 0, async () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      let mocker: MockKit = new MockKit();
      let mockfunc: Function = mocker.mockFunc((ability as object), (ability as object)['checkMigrateClient']);
      when(mockfunc)().afterReturn(Promise.resolve(true));
      let mockfunc2: Function = mocker.mockFunc(SCBGestureNavSetMgr, SCBGestureNavSetMgr.isSupportFloatNavigation);
      when(mockfunc2)().afterReturn(false);
      const result: Promise<boolean> = await (ability as object)['insertDb']();
      expect(result).assertEqual(true);
      mocker.ignoreMock((ability as object), (ability as object)['checkMigrateClient']);
      mocker.ignoreMock(SCBGestureNavSetMgr, SCBGestureNavSetMgr.isSupportFloatNavigation);
    });

    it('isUpgradeFromDual_1', 0, async () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      const isUpgradeFromDual: boolean = (ability as object)['isUpgradeFromDual']();
      expect(isUpgradeFromDual).assertEqual(false);
    });

    it('isUpgradeFromDual_2', 0, async () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      const isUpgradeFromDual: boolean = (ability as object)['isUpgradeFromDual']();
      expect(isUpgradeFromDual).assertEqual(false);
    });
    it('isUpgradeFromDual_3', 0, async () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      const isUpgradeFromDual: boolean = (ability as object)['isUpgradeFromDual']();
      expect(isUpgradeFromDual).assertEqual(false);
    });
    it('checkMigrateClient_1', 0, async () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      (ability as object)['checkMigrateClient']();
      expect(ability).not().assertUndefined();
    });
 
    it('isThreeButtonUpgrade_1', 0, async () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      ability.context = getContext() as common.ExtensionContext;
      settings.setValueSync(ability.context, ThreeButtonUpgradeConstants.OLD_NAVIGATION_TYPE_KEY, '0');
      (ability as object)['isThreeButtonUpgrade']();
      expect(ability).not().assertUndefined();
    });
 
    it('isThreeButtonUpgrade_2', 0, async () => {
      let ability: ThreeButtonUpgradeDSExtAbility = new ThreeButtonUpgradeDSExtAbility();
      ability.context = getContext() as common.ExtensionContext;
      settings.setValueSync(ability.context, ThreeButtonUpgradeConstants.OLD_NAVIGATION_TYPE_KEY, '1');
      (ability as object)['isThreeButtonUpgrade']();
      expect(ability).not().assertUndefined();
    });
    
  })
}

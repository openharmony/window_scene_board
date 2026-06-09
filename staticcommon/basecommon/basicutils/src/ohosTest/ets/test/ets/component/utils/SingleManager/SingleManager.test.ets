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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { SingleBase, SingleContext, SingleManager } from '../../../../../../../main/ets/utils/SingleManager';
import { globalGrandFather1, TestGrandFather1 } from './simulate01/TestGrandFather1';
import { globalTestChild1, TestChild1 } from './simulate01/TestChild1';
import { globalTestFather1, TestFather1 } from './simulate01/TestFather1';
import { simulateSingleManager } from './SimulateSingleInstance';
import { globalTestDock4, TestDock4 } from './simulate04/TestDock';
import { globalTestPCDock4, TestPCDock4 } from './simulate04/TestPCDock';
import { TestData4 } from './simulate04/TestData4';
import { TestGrandFather2 } from './simulate02/TestGrandFather2';
import { TestFather2 } from './simulate02/TestFather2';
import { TestChild2 } from './simulate02/TestChild2';
import { globalGrandFather3, TestGrandFather3 } from './simulate03/TestGrandFather3';
import { testLargerCase } from './maximum01/ClassDefinitions'
import { TestFather3 } from './simulate03/TestFather3';
import { globalGrandFather5, TestGrandFather5 } from './simulate05/TestGrandFather5';
import { globalTestFather5, TestFather5 } from './simulate05/TestFather5';
import { globalTestChild5, TestChild5 } from './simulate05/TestChild5';
import { TestGrandFather6 } from './simulate06/TestGrandFather6';
import { TestChild7 } from './simulate07/TestChild7';
import { TestFather7 } from './simulate07/TestFather7';
import { TestGrandFather7 } from './simulate07/TestGrandFather7';
import { TestMother7 } from './simulate07/TestMother7';
import { simulateNotInitialedSingleInstance } from './SimulateNotInitialedSingleInstance';
import { TestFather8 } from './simulate08/TestFather8';
import { TestChild8 } from './simulate08/TestChild8';
import { TestMother8 } from './simulate08/TestMother8';

export function SingleManagerTest() {
  describe('SingleManagerTest', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })
    /* 测试initial->register->get1流程 */
    it('NormalTest_1', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return 0;
      });
      let test01 = new TestClass01();
      let test02 = new TestClass02();
      manager.register(TestClass01, test01);
      manager.register(TestClass02, test02);

      expect(manager.get(TestClass01) === test01).assertTrue();
      expect(manager.get(TestClass02) === test02).assertTrue();

      test01.name = 'test01';
      test02.name = 'test02';

      expect(manager.get(TestClass01).name).assertEqual('test01');
      expect(manager.get(TestClass02).name).assertEqual('test02');
    })
    /* 测试initial->register->get2流程 */
    it('NormalTest_2', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return ctx.extendScreenId ?? 1;
      });
      let test01 = new TestClass01();
      let test02 = new TestClass02();
      manager.register(TestClass01, test01);
      manager.register(TestClass02, test02);
      /* 此时查找的是新创建的 */
      expect(manager.get(TestClass01) === test01).assertFalse();
      expect(manager.get(TestClass02) === test02).assertFalse();

      /* 给定extendScreenId，使其查找第0个注册的 */
      expect(manager.get(TestClass01, { extendScreenId: 0 }) === test01).assertTrue();
      expect(manager.get(TestClass02, { extendScreenId: 0 }) === test02).assertTrue();

      /* 继续修改新实例参数 */
      manager.get(TestClass01, { extendScreenId: 0 }).name = 'test01_01';
      manager.get(TestClass01).name = 'test01_02';
      manager.get(TestClass02, { extendScreenId: 0 }).name = 'test02_01';
      manager.get(TestClass02).name = 'test02_02';

      expect(manager.get(TestClass01, { extendScreenId: 0 }).name).assertEqual('test01_01');
      expect(manager.get(TestClass01).name).assertEqual('test01_02');
      expect(manager.get(TestClass02, { extendScreenId: 0 }).name).assertEqual('test02_01');
      expect(manager.get(TestClass02).name).assertEqual('test02_02');
    })
    /* 测试initial->get流程 */
    it('NormalTest_3', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return ctx.extendScreenId ?? 0;
      });

      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      let instance1 = manager.get(TestClass02);
      let instance2 = manager.get(TestClass02, targetSecondContext);
      expect(instance1 !== undefined).assertTrue();
      expect(instance2 !== undefined).assertTrue();
      expect(instance1 !== instance2).assertTrue();

      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return ctx.extendScreenId ?? 1;
      });
      expect(instance2 === manager.get(TestClass02, targetSecondContext)).assertTrue();
    })
    /* 测试selector返回异常 */
    it('SelectorErrorTest_1', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return undefined;
      });

      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      try {
        expect(manager.get(TestClass01, targetSecondContext))
          .assertThrowError(`SingleManager: Object ${TestClass01.singleName} instance is not exist.`);
      } catch (error) {
      }

      let instance = new TestClass01();
      try {
        manager.register(TestClass01, instance, targetSecondContext);
        expect(instance).assertThrowError(`SingleManager: Object ${TestClass01.singleName} instance is not exist.`);
      } catch (error) {
      }
    })
    /* 测试selector返回异常 */
    it('SelectorErrorTest_2', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, undefined);

      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      try {
        expect(manager.get(TestClass01, targetSecondContext))
          .assertThrowError(`SingleManager: Object ${TestClass01.singleName} instance is not exist.`);
      } catch (error) {
      }

      let instance = new TestClass01();
      try {
        manager.register(TestClass01, instance, targetSecondContext);
        expect(instance).assertThrowError(`SingleManager: Object ${TestClass01.singleName} instance is not exist.`);
      } catch (error) {
      }
    })
    /* 测试selector返回异常 */
    it('SelectorErrorTest_3', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return 20;
      });

      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      try {
        expect(manager.get(TestClass01, targetSecondContext))
          .assertThrowError(`SingleManager: Object ${TestClass01.singleName} instance is not exist.`);
      } catch (error) {
      }

      let instance = new TestClass01();
      try {
        manager.register(TestClass01, instance, targetSecondContext);
        expect(instance).assertThrowError(`SingleManager: Object ${TestClass01.singleName} instance is not exist.`);
      } catch (error) {
      }
    })
    /* 测试selector返回异常 */
    it('SelectorErrorTest_4', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return -1;
      });

      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      try {
        expect(manager.get(TestClass01, targetSecondContext))
          .assertThrowError(`SingleManager: Object ${TestClass01.singleName} instance is not exist.`);
      } catch (error) {
      }

      let instance = new TestClass01();
      try {
        manager.register(TestClass01, instance, targetSecondContext);
        expect(instance).assertThrowError(`SingleManager: Object ${TestClass01.singleName} instance is not exist.`);
      } catch (error) {
      }
    })
    /* 测试class输入异常 */
    it('Error_input_class_1', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return 0;
      });

      try {
        expect(manager.get(undefined)).assertThrowError(`SingleManager: invalid keyName.`);
      } catch (error) {
      }

      try {
        let instance1 = new TestErrorClass01();
        manager.register(TestErrorClass01, instance1);
        expect(instance1).assertThrowError(`SingleManager: invalid keyName.`);
      } catch (error) {
      }

      try {
        let instance2 = new TestErrorClass02();
        manager.register(TestErrorClass02, instance2);
        expect(instance2).assertThrowError(`SingleManager: invalid keyName.`);
      } catch (error) {
      }

      try {
        let instance3 = new TestErrorClass03();
        manager.register(TestErrorClass03, instance3);
        expect(instance3).assertThrowError(`SingleManager: invalid keyName.`);
      } catch (error) {
      }

      try {
        let instance4 = new TestErrorClass04();
        manager.register(TestErrorClass04, instance4);
        expect(instance4).assertThrowError(`SingleManager: invalid keyName.`);
      } catch (error) {
      }
    })
    /* 测试Dft功能 */
    it('Dft_toString_1', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {},
        (ctx: SingleContext) => {
          return ctx.extendScreenId ?? 0;
      });
      let secondContext: SingleContext = {
        extendScreenId: 1
      };
      let test01 = new TestClass01();
      let test001 = new TestClass01();
      let test02 = new TestClass02();
      manager.register(TestClass01, test01);
      manager.register(TestClass01, test001, secondContext);
      manager.register(TestClass02, test02);
      /* 无调用信息版本 */
      let noGetDescStr = manager.toString();
      let noGetDescStrLen = noGetDescStr.length;
      expect(noGetDescStrLen > 100).assertTrue();

      manager.enableDft(10);
      for (let i = 0; i < 20; i++) {
        expect(manager.get(TestClass01) === test01).assertTrue();
        expect(manager.get(TestClass02) === test02).assertTrue();
      }
      /* 有调用信息版本 */
      let getDescStrLen = manager.toString().length;
      expect(getDescStrLen > 100).assertTrue();

      expect(getDescStrLen - noGetDescStrLen).assertLarger(100);
    })

    /* 测试Dft功能 */
    it('Dft_toString_2', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {},
        (ctx: SingleContext) => {
          return ctx.extendScreenId ?? 0;
        });

      let instance = new TestCircularClass();
      manager.register(TestCircularClass, instance);
      let result = manager.toString();
      expect(result.length).assertLarger(100);
    })


    /* 测试AppStorage的getName功能 */
    it('Get_name_01', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return ctx.extendScreenId ?? 0;
      });
      let targetFirstContext: SingleContext = {
        extendScreenId: 1
      };
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      expect(manager.getAppStorageName('test', targetFirstContext) === 'test_index_1').assertTrue();
      expect(manager.getAppStorageName('test', targetSecondContext) === 'test_index_1').assertTrue();
    })
    it('Get_name_02', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return 3;
      });

      try {
        const name = 'test';
        // TestMother7和TestFather7同singleName，不能替代
        expect(manager.getAppStorageName(name, undefined))
          .assertThrowError(`SingleManager: Selector callback return AppStorage ${name} index is invalid.`);
      } catch (error) {
      }
    })
    it('Get_name_03', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return 1;
      });

      const testKey: string = 'ThisIsATest03';
      const testResult: string = 'ThisIsAResult03';
      AppStorage.setOrCreate(testKey, '');
      AppStorage.setOrCreate(manager.getAppStorageName('ThisIsATest', undefined), testResult);

      expect(AppStorage.get(testKey)).assertEqual('');
      expect(AppStorage.get(manager.getAppStorageName('ThisIsATest', undefined))).assertEqual(testResult);
    })
    // 一个参考developer网站上arkts-appstorage-V5的例子：从应用逻辑使用AppStorage和LocalStorage
    it('Get_name_04', 0, () => {
      let manager = new SingleManager();
      manager.initial(2, (ctx: SingleContext) => {
      }, (ctx: SingleContext) => {
        return 1;
      });

      const testKey: string = 'ThisIsATest04';
      AppStorage.setOrCreate(manager.getAppStorageName(testKey, undefined), 47);

      let link1: SubscribedAbstractProperty<number> = AppStorage.link(manager.getAppStorageName(testKey, undefined));
      let link2: SubscribedAbstractProperty<number> = AppStorage.link(manager.getAppStorageName(testKey, undefined));
      let prop: SubscribedAbstractProperty<number> = AppStorage.prop(manager.getAppStorageName(testKey, undefined));

      link1.set(48); // 双向同步: link1.get() == link2.get() == prop.get() == 48
      expect(AppStorage.get(manager.getAppStorageName(testKey, undefined))).assertEqual(48);
      expect(link1.get()).assertEqual(48);
      expect(link2.get()).assertEqual(48);
      expect(prop.get()).assertEqual(48);

      prop.set(1); // 单向同步: prop.get() == 1; 但 link1.get() == link2.get() == 48
      expect(AppStorage.get(manager.getAppStorageName(testKey, undefined))).assertEqual(48);
      expect(link1.get()).assertEqual(48);
      expect(link2.get()).assertEqual(48);
      expect(prop.get()).assertEqual(1);

      link1.set(49); // 双向同步: link1.get() == link2.get() == prop.get() == 49
      expect(AppStorage.get(manager.getAppStorageName(testKey, undefined))).assertEqual(49);
      expect(link1.get()).assertEqual(49);
      expect(link2.get()).assertEqual(49);
      expect(prop.get()).assertEqual(49);
    })
    // 模拟在每个文件最后创建单例并且register的场景：
    // 根据引用关系，只能是先import TestChild1 -> import TestFather1 -> import TestGrandFather1
    // 注意，这个用例和当前文件的import还有一点关系
    it('Simulate01_for_test_import_and_get_instance', 0, () => {
      // 1. 判断第一组数据，根据register的调用，应该就是默认单例
      let target = simulateSingleManager.get<TestGrandFather1>(TestGrandFather1);
      expect(target).assertEqual(globalGrandFather1);
      expect(target.father).assertEqual(globalTestFather1);
      expect(target.father.child).assertEqual(globalTestChild1);

      // 2. 修改第一组数据的内容
      globalGrandFather1.name = 'grandFather1';
      globalGrandFather1.father.name = 'father1';
      globalGrandFather1.father.child.name = 'child1';

      // 3. 然后再取另一组，这组数据就是新创建的，根据context，应该是新的关联管理，和第一组无关
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      let grandFather2 = simulateSingleManager.get<TestGrandFather1>(TestGrandFather1, targetSecondContext);
      expect(grandFather2 === globalGrandFather1).assertFalse();
      expect(grandFather2.father === globalTestFather1).assertFalse();
      expect(grandFather2.father.child === globalTestChild1).assertFalse();

      // 4. 修改第二组数据
      grandFather2.name = 'grandFather2';
      grandFather2.father.name = 'father2';
      grandFather2.father.child.name = 'child2';

      // 5. 判断第一组数据没有被影响
      expect(globalGrandFather1.name).assertEqual('grandFather1');
      expect(globalTestFather1.name).assertEqual('father1');
      expect(globalTestChild1.name).assertEqual('child1');

      // 6. 判断第二组数据正常修改了
      expect(simulateSingleManager.get<TestGrandFather1>(TestGrandFather1,
        targetSecondContext).name).assertEqual('grandFather2');
      expect(simulateSingleManager.get<TestFather1>(TestFather1, targetSecondContext).name).assertEqual('father2');
      expect(simulateSingleManager.get<TestChild1>(TestChild1, targetSecondContext).name).assertEqual('child2');

      // 7. 判断2种单例是否一致
      expect(TestGrandFather1.getInstance()).assertEqual(globalGrandFather1);
      expect(TestFather1.getInstance()).assertEqual(globalTestFather1);
      expect(TestChild1.getInstance()).assertEqual(globalTestChild1);

      // 8. 判断老的getInstance方法和新的get方法是否一致
      expect(TestGrandFather1.getInstance()).assertEqual(simulateSingleManager.get(TestGrandFather1));
      expect(TestFather1.getInstance()).assertEqual(simulateSingleManager.get(TestFather1));
      expect(TestChild1.getInstance()).assertEqual(simulateSingleManager.get(TestChild1));
    })

    // simulate01和05套件是一样的场景，但是实现方法不同：
    // 01: 使用register方法注册创建好的实例
    // 05: 使用get方法直接创建实例，替代new方法
    it('Simulate05_for_test_import_and_get_instance', 0, () => {
      // 1. 判断第一组数据，根据register的调用，应该就是默认单例
      let target = simulateSingleManager.get<TestGrandFather5>(TestGrandFather5);
      expect(target).assertEqual(globalGrandFather5);
      expect(target.father).assertEqual(globalTestFather5);
      expect(target.father.child).assertEqual(globalTestChild5);

      // 2. 修改第一组数据的内容
      globalGrandFather5.name = 'grandFather1';
      globalGrandFather5.father.name = 'father1';
      globalGrandFather5.father.child.name = 'child1';

      // 3. 然后再取另一组，这组数据就是新创建的，根据context，应该是新的关联管理，和第一组无关
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      let grandFather2 = simulateSingleManager.get<TestGrandFather5>(TestGrandFather5, targetSecondContext);
      expect(grandFather2 === globalGrandFather5).assertFalse();
      expect(grandFather2.father === globalTestFather5).assertFalse();
      expect(grandFather2.father.child === globalTestChild5).assertFalse();

      // 4. 修改第二组数据
      grandFather2.name = 'grandFather2';
      grandFather2.father.name = 'father2';
      grandFather2.father.child.name = 'child2';

      // 5. 判断第一组数据没有被影响
      expect(globalGrandFather5.name).assertEqual('grandFather1');
      expect(globalTestFather5.name).assertEqual('father1');
      expect(globalTestChild5.name).assertEqual('child1');

      // 6. 判断第二组数据正常修改了
      expect(simulateSingleManager.get(TestGrandFather5, targetSecondContext).name).assertEqual('grandFather2');
      expect(simulateSingleManager.get(TestFather5, targetSecondContext).name).assertEqual('father2');
      expect(simulateSingleManager.get(TestChild5, targetSecondContext).name).assertEqual('child2');

      // 7. 判断2种单例是否一致
      expect(TestGrandFather5.getInstance()).assertEqual(globalGrandFather5);
      expect(TestFather5.getInstance()).assertEqual(globalTestFather5);
      expect(TestChild5.getInstance()).assertEqual(globalTestChild5);

      // 8. 判断老的getInstance方法和新的get方法是否一致
      expect(TestGrandFather5.getInstance()).assertEqual(simulateSingleManager.get(TestGrandFather5));
      expect(TestFather5.getInstance()).assertEqual(simulateSingleManager.get(TestFather5));
      expect(TestChild5.getInstance()).assertEqual(simulateSingleManager.get(TestChild5));
    })

    // 模拟在每个文件不会单独创建单例的场景：
    // 根据引用关系，只能是先import TestChild2 -> import TestFather2 -> import TestGrandFather2
    // 注意，这个用例和当前文件的import还有一点关系
    it('Simulate02_for_test_import', 0, () => {
      let testGrandFather1 = TestGrandFather2.getInstance();
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      // 这里测试用register注册到第二个实例的方法，和get类似
      let testGrandFather2 = new TestGrandFather2(targetSecondContext);
      simulateSingleManager.register(TestGrandFather2, testGrandFather2, targetSecondContext);

      expect(testGrandFather1 === simulateSingleManager.get(TestGrandFather2)).assertTrue();
      expect(testGrandFather2 === simulateSingleManager.get(TestGrandFather2, targetSecondContext)).assertTrue();
      expect(testGrandFather2 !== TestGrandFather2.getInstance()).assertTrue();

      expect(simulateSingleManager.get(TestGrandFather2).father === simulateSingleManager.get(TestFather2))
        .assertTrue();
      expect(simulateSingleManager.get(TestGrandFather2, targetSecondContext).father ===
        simulateSingleManager.get(TestFather2, targetSecondContext)).assertTrue();

      expect(TestGrandFather2.getInstance() === simulateSingleManager.get(TestGrandFather2)).assertTrue();
      expect(TestFather2.getInstance() === simulateSingleManager.get(TestFather2)).assertTrue();
      expect(TestChild2.getInstance() === simulateSingleManager.get(TestChild2)).assertTrue();

      expect(TestGrandFather2.getInstance() !==
        simulateSingleManager.get(TestGrandFather2, targetSecondContext)).assertTrue();
      expect(TestFather2.getInstance() !==
        simulateSingleManager.get(TestFather2, targetSecondContext)).assertTrue();
      expect(TestChild2.getInstance() !==
        simulateSingleManager.get(TestChild2, targetSecondContext)).assertTrue();
    })

    // 模拟在在关联过程中，单例创建和不创建的混合场景
    // 根据引用关系，只能是先import TestChild3 -> import TestFather3 -> import TestGrandFather2
    // 注意，这个用例和当前文件的import还有一点关系
    it('Simulate03_for_test_mix_getInstance_then_get', 0, () => {
      let testFather1 = TestFather3.getInstance();
      let testGrandFather1 = simulateSingleManager.get<TestGrandFather3>(TestGrandFather3);
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      let testGrandFather2 = simulateSingleManager.get<TestGrandFather3>(TestGrandFather3, targetSecondContext);
      expect(testGrandFather1 !== testGrandFather2).assertTrue();
      expect(testGrandFather1 === simulateSingleManager.get(TestGrandFather3)).assertTrue();
      expect(testGrandFather1 === globalGrandFather3).assertTrue();

      expect(testGrandFather1.father !== testGrandFather2.father).assertTrue();
      expect(testGrandFather1.father === globalGrandFather3.father).assertTrue();
      expect(testGrandFather1.father.child !== testGrandFather2.father.child).assertTrue();
      expect(testGrandFather1.father.child === globalGrandFather3.father.child).assertTrue();

      expect(testGrandFather1.father === testFather1).assertTrue();
      expect(testGrandFather2.father !== testFather1).assertTrue();
    })

    // 模拟在在关联过程中，单例创建和不创建的混合场景
    // 根据引用关系，只能是先import TestChild3 -> import TestFather3 -> import TestGrandFather2
    // 注意，这个用例和当前文件的import还有一点关系
    it('Simulate03_for_test_mix_get_then_getInstance', 0, () => {
      let testGrandFather1 = simulateSingleManager.get<TestGrandFather3>(TestGrandFather3);
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      let testGrandFather2 = simulateSingleManager.get<TestGrandFather3>(TestGrandFather3, targetSecondContext);
      expect(testGrandFather1 !== testGrandFather2).assertTrue();
      expect(testGrandFather1 === simulateSingleManager.get(TestGrandFather3)).assertTrue();
      expect(testGrandFather1 === globalGrandFather3).assertTrue();

      expect(testGrandFather1.father !== testGrandFather2.father).assertTrue();
      expect(testGrandFather1.father === globalGrandFather3.father).assertTrue();
      expect(testGrandFather1.father.child !== testGrandFather2.father.child).assertTrue();
      expect(testGrandFather1.father.child === globalGrandFather3.father.child).assertTrue();

      expect(testGrandFather1.father === TestFather3.getInstance()).assertTrue();
      expect(testGrandFather2.father !== TestFather3.getInstance()).assertTrue();
    })

    // 模拟PC对平台代码继承后，希望平台实例和PC实例放在相同Class中的场景
    it('Simulate04_for_extend_child', 0, () => {
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      // 测试通过基类获取2个实例
      let dock = simulateSingleManager.get<TestDock4>(TestDock4);
      let pdDock = simulateSingleManager.get<TestDock4>(TestDock4, targetSecondContext);
      expect(dock).assertEqual(globalTestDock4);
      expect(pdDock).assertEqual(globalTestPCDock4);

      // 测试通过子类获取2个实例
      // 第一个实例是TestDock4，只能通过这个类获取，不能通过子类TestPCDock4获取（安全校验）
      expect(simulateSingleManager.get<TestDock4>(TestDock4) === dock).assertTrue();
      // 第二个实例是TestPCDock4，也可以兼容通过父类TestDock4获取
      expect(simulateSingleManager.get<TestPCDock4>(TestPCDock4, targetSecondContext) === pdDock).assertTrue();
      expect(simulateSingleManager.get<TestDock4>(TestDock4, targetSecondContext) === pdDock).assertTrue();

      expect(dock.getData()).assertEqual(simulateSingleManager.get<TestData4>(TestData4));
      expect(pdDock.getData()).assertEqual(simulateSingleManager.get<TestData4>(TestData4, targetSecondContext));
      expect(dock.getData() !== undefined).assertTrue();
      expect(pdDock.getData() !== undefined).assertTrue();
      expect(dock.getData() !== pdDock.getData()).assertTrue();
    })

    it('Maximum_01', 0, () => {
      expect(testLargerCase()).assertTrue();
    })

    it('Simulate_06_multi_extends', 0, () => {
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      // 测试通过基类获取2个实例
      let testGrandFather1 = new TestGrandFather6(undefined, '01');
      let testGrandFather2 = new TestGrandFather6(undefined, '02');
      simulateSingleManager.register(TestGrandFather6, testGrandFather1, undefined);
      simulateSingleManager.register(TestGrandFather6, testGrandFather2, targetSecondContext);

      let getGrandFather1 = simulateSingleManager.get<TestGrandFather6>(TestGrandFather6);
      let getGrandFather2 = simulateSingleManager.get<TestGrandFather6>(TestGrandFather6, targetSecondContext);

      expect(testGrandFather1.name !== testGrandFather2.name).assertTrue();
      expect(getGrandFather1.name !== getGrandFather2.name).assertTrue();
      expect(getGrandFather1 === testGrandFather1).assertTrue();
      expect(getGrandFather2 === testGrandFather2).assertTrue();
    })
    /* 测试get函数的返回值校验功能：基本功能 + 抢占 */
    it('Simulate_07_safe_check_for_get', 0, () => {
      let manager = new SingleManager();
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      manager.initial(2,
        (ctx: SingleContext) => {},
        (ctx: SingleContext) => { return ctx.extendScreenId ?? 0; });
      manager.enableDfr(true);
      expect(manager.get(TestChild7) !== null).assertTrue();
      expect(manager.get(TestFather7) !== null).assertTrue();

      try {
        // TestMother7和TestFather7同singleName，不能替代
        expect(manager.get(TestMother7))
          .assertThrowError(`SingleManager: Get object ${TestMother7.singleName} with incorrect type.`);
      } catch (error) {
      }

      // 将子类TestGrandFather7注册为父类TestFather7的同级第二个实例
      expect(manager.get(TestGrandFather7, targetSecondContext) !== null).assertTrue();
      // 这样子类的实例二有TestGrandFather7和TestFather7 2种获取方法
      expect(manager.get(TestGrandFather7, targetSecondContext) !== null).assertTrue();
      expect(manager.get(TestFather7, targetSecondContext) !== null).assertTrue();

      // 但是父类的实例一 只能通过TestFather7获取
      expect(manager.get(TestFather7) !== null).assertTrue();
      expect(manager.get(TestFather7) !== manager.get(TestFather7, targetSecondContext)).assertTrue();
      try {
        expect(manager.get(TestGrandFather7))
          .assertThrowError(`SingleManager: Get object ${TestGrandFather7.singleName} with incorrect type.`);
      } catch (error) {
      }
    })
    /* 测试get函数的返回值校验功能：基本功能 + 抢占 */
    it('Simulate_07_safe_check_for_disable', 0, () => {
      let manager = new SingleManager();
      let targetSecondContext: SingleContext = {
        extendScreenId: 1
      };
      manager.initial(2,
        (ctx: SingleContext) => {},
        (ctx: SingleContext) => { return ctx.extendScreenId ?? 0; });
      manager.enableDfr(false);
      expect(manager.get(TestChild7) !== null).assertTrue();
      expect(manager.get(TestFather7) !== null).assertTrue();
      // 关闭校验后，获取get(TestMother7)会返回TestFather7实例，虽然类型不对
      expect(manager.get(TestMother7) !== null).assertTrue();

      manager.enableDfr(true);
      try {
        // TestMother7和TestFather7同singleName，不能替代
        expect(manager.get(TestMother7))
          .assertThrowError(`SingleManager: Get object ${TestMother7.singleName} with incorrect type.`);
      } catch (error) {
      }
    })
    /* 未初始时按照默认单实例处理 */
    it('Simulate_08_for_not_initial_then_running_as_default', 0, () => {
      let getFather = simulateNotInitialedSingleInstance.get(TestFather8);
      let getChild = simulateNotInitialedSingleInstance.get(TestChild8);
      let getMother = simulateNotInitialedSingleInstance.get(TestMother8);

      expect(getFather).assertEqual(TestFather8.getInstance());
      expect(getChild).assertEqual(TestChild8.getInstance());
      expect(getMother).assertEqual(TestMother8.getInstance());
      expect(getMother.child).assertEqual(getFather.child);
    })
  })
}

class TestClass01 extends SingleBase {
  public static singleName: string = 'Test01';
  public name: string = '';
  public id: number = 0;
}

class TestClass02 extends SingleBase {
  public static singleName: string = 'Test02';
  public name: string = '';
  public id: number = 0;
}

class TestErrorClass01 extends SingleBase {
  public static singleName: string = '';
}

class TestErrorClass02 extends SingleBase {
}

class TestErrorClass03 {
}

class TestErrorClass04 {
  public static singleName: number = 0;
}

class TestCircularClass extends SingleBase {
  public static singleName: string = 'TestCircularClass';
  circular: TestCircularClass = this;
}
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

import {
  describe,
  beforeAll,
  beforeEach,
  afterEach,
  afterAll,
  it,
  expect,
  MockKit,
  when,
  ArgumentMatchers
} from '@ohos/hypium';
import { LiveVmInjector } from '../../../../../../../newIndex';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { LiveCapsuleLifecycleVm } from '../../../../../../main/ets/live/vm/LiveCapsuleLifecycleVm';

export default function LiveCapsuleLifecycleVmTest() {
  describe('getCapsuleShowTime_testSuite', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    getCapsuleShowTimeTest1();
    getCapsuleShowTimeTest2();
    getCapsuleShowTimeTest3();
    getCapsuleShowTimeTest4();
    getCapsuleShowTimeTest5();
    getCapsuleShowTimeTest6();
    getCapsuleShowTimeTest7();
    getCapsuleShowTimeTest8();
    getCapsuleShowTimeTest9();
    getCapsuleShowTimeTest10();
    getCapsuleShowTimeTest11();
    getCapsuleShowTimeTest12();
    getCapsuleShowTimeTest13();
    getCapsuleShowTimeTest14();
    getCapsuleShowTimeTest15();
    getCapsuleShowTimeTest16();
    getCapsuleShowTimeTest17();
    getCapsuleShowTimeTest18();
    getCapsuleShowTimeTest19();
    getCapsuleShowTimeTest20();
    getCapsuleShowTimeTest21();
    getCapsuleShowTimeTest22();
    getCapsuleShowTimeTest23();
    getCapsuleShowTimeTest24();
    getCapsuleShowTimeTest25();
    getCapsuleShowTimeTest26();
    getCapsuleShowTimeTest27();
    getCapsuleShowTimeTest28();
  });

  describe('updateCapsuleShow_testSuite', () => {
    beforeAll(() => {
    })
    beforeEach(() => {
    })
    afterEach(() => {
    })
    afterAll(() => {
    })

    updateCapsuleShowTest1();
    updateCapsuleShowTest2();
    updateCapsuleShowTest3();
    updateCapsuleShowTest4();
    updateCapsuleShowTest5();
    updateCapsuleShowTest6();
    updateCapsuleShowTest7();
    updateCapsuleShowTest8();
    updateCapsuleShowTest9();
    updateCapsuleShowTest10();
    updateCapsuleShowTest11();
    updateCapsuleShowTest12();
    updateCapsuleShowTest13();
    updateCapsuleShowTest14();
    updateCapsuleShowTest15();
    updateCapsuleShowTest16();
    updateCapsuleShowTest17();
    updateCapsuleShowTest18();
    updateCapsuleShowTest19();
    updateCapsuleShowTest20();
    updateCapsuleShowTest21();
    updateCapsuleShowTest22();
    updateCapsuleShowTest23();
    updateCapsuleShowTest24();
    updateCapsuleShowTest25();
    updateCapsuleShowTest26();
    updateCapsuleShowTest27();
    updateCapsuleShowTest28();
    updateCapsuleShowTest29();
    updateCapsuleShowTest30();
    updateCapsuleShowTest31();
    updateCapsuleShowTest32();
    updateCapsuleShowTest33();
    updateCapsuleShowTest34();
    updateCapsuleShowTest35();
    updateCapsuleShowTest36();
    updateCapsuleShowTest37();
    updateCapsuleShowTest38();
    updateCapsuleShowTest39();
    updateCapsuleShowTest40();
    updateCapsuleShowTest41();
    updateCapsuleShowTest42();
    updateCapsuleShowTest43();
    updateCapsuleShowTest44();
    updateCapsuleShowTest45();
    updateCapsuleShowTest46();
    updateCapsuleShowTest47();
    updateCapsuleShowTest48();
    updateCapsuleShowTest49();
    updateCapsuleShowTest50();
    updateCapsuleShowTest51();
    updateCapsuleShowTest52();
    updateCapsuleShowTest53();
    updateCapsuleShowTest54();
    updateCapsuleShowTest55();
    updateCapsuleShowTest56();
    updateCapsuleShowTest57();
    updateCapsuleShowTest58();
    updateCapsuleShowTest59();
    updateCapsuleShowTest60();
    updateCapsuleShowTest61();
    updateCapsuleShowTest62();
    updateCapsuleShowTest63();
    updateCapsuleShowTest64();
    updateCapsuleShowTest64();
    updateCapsuleShowTest66();
    updateCapsuleShowTest67();
    updateCapsuleShowTest68();
    updateCapsuleShowTest69();
    updateCapsuleShowTest70();
    updateCapsuleShowTest71();
    updateCapsuleShowTest72();
    updateCapsuleShowTest73();
    updateCapsuleShowTest74();
    updateCapsuleShowTest75();
    updateCapsuleShowTest76();
    updateCapsuleShowTest77();
    updateCapsuleShowTest78();
    updateCapsuleShowTest79();
    updateCapsuleShowTest80();
    updateCapsuleShowTest81();
    updateCapsuleShowTest82();
    updateCapsuleShowTest83();
    updateCapsuleShowTest84();
    updateCapsuleShowTest85();
    updateCapsuleShowTest86();
    updateCapsuleShowTest87();
    updateCapsuleShowTest88();
    updateCapsuleShowTest89();
    updateCapsuleShowTest90();
    updateCapsuleShowTest91();
    updateCapsuleShowTest92();
    updateCapsuleShowTest93();
    updateCapsuleShowTest94();
    updateCapsuleShowTest95();
    updateCapsuleShowTest96();
    updateCapsuleShowTest97();
    updateCapsuleShowTest98();
    updateCapsuleShowTest99();
    updateCapsuleShowTest100();
    updateCapsuleShowTest101();
    updateCapsuleShowTest102();
    updateCapsuleShowTest103();
    updateCapsuleShowTest104();
    updateCapsuleShowTest105();
    updateCapsuleShowTest106();
    updateCapsuleShowTest107();
    updateCapsuleShowTest108();
    updateCapsuleShowTest109();
    updateCapsuleShowTest110();
    updateCapsuleShowTest111();
    updateCapsuleShowTest112();
    updateCapsuleShowTest113();
    updateCapsuleShowTest114();
    updateCapsuleShowTest115();
    updateCapsuleShowTest116();
    updateCapsuleShowTest117();
    updateCapsuleShowTest118();
    updateCapsuleShowTest119();
    updateCapsuleShowTest120();
    updateCapsuleShowTest121();
    updateCapsuleShowTest122();
    updateCapsuleShowTest123();
    updateCapsuleShowTest124();
    updateCapsuleShowTest125();
    updateCapsuleShowTest126();
    updateCapsuleShowTest127();
    updateCapsuleShowTest128();
    updateCapsuleShowTest129();
    updateCapsuleShowTest130();
    updateCapsuleShowTest131();
    updateCapsuleShowTest132();
    updateCapsuleShowTest133();
    updateCapsuleShowTest134();
    updateCapsuleShowTest135();
    updateCapsuleShowTest136();
    updateCapsuleShowTest137();
    updateCapsuleShowTest138();
    updateCapsuleShowTest139();
    updateCapsuleShowTest140();
    updateCapsuleShowTest141();
    updateCapsuleShowTest142();
    updateCapsuleShowTest143();
    updateCapsuleShowTest144();
    updateCapsuleShowTest145();
    updateCapsuleShowTest146();
    updateCapsuleShowTest147();
    updateCapsuleShowTest148();
    updateCapsuleShowTest149();
    updateCapsuleShowTest150();
    updateCapsuleShowTest151();
    updateCapsuleShowTest152();
    updateCapsuleShowTest153();
    updateCapsuleShowTest154();
    updateCapsuleShowTest155();
    updateCapsuleShowTest156();
    updateCapsuleShowTest157();
    updateCapsuleShowTest158();
  });
}

function getCapsuleShowTimeTest1() {
  it('should_return_0_when_totalKeepTime_is_null', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(null);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest2() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_2000', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 2000,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest3() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_-2000', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: -2000,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(-2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest4() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_0', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 0,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest5() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_500', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 500,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(0.5);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest6() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_-2000_capsuleStartTime_is_500', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: -2000,
      capsuleStartTime: 500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(-2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest7() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_0_capsuleStartTime_is_500', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 0,
      capsuleStartTime: 500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest8() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_500_capsuleStartTime_is_500', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 500,
      capsuleStartTime: 500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(0.5);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest9() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_-2000_capsuleStartTime_is_-500', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: -2000,
      capsuleStartTime: -500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(-2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest10() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_0_capsuleStartTime_is_-500', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 0,
      capsuleStartTime: -500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest11() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_500_capsuleStartTime_is_-500', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 500,
      capsuleStartTime: -500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(1);
    expect(result).assertEqual(0.5);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}


function getCapsuleShowTimeTest12() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_-2000_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: -2000,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(100);
    expect(result).assertEqual(-2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest13() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_0_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 0,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(100);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest14() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_500_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 500,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(100);
    expect(result).assertEqual(0.5);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest15() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_-2000_capsuleStartTime_is_500_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: -2000,
      capsuleStartTime: 500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(100);
    expect(result).assertEqual(-2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest16() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_0_capsuleStartTime_is_500_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 0,
      capsuleStartTime: 500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(100);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest17() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_500_capsuleStartTime_is_500_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 500,
      capsuleStartTime: 500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(100);
    expect(result).assertEqual(0.5);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest18() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_-2000_capsuleStartTime_is_-500_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: -2000,
      capsuleStartTime: -500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(100);
    expect(result).assertEqual(-2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest19() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_0_capsuleStartTime_is_-500_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 0,
      capsuleStartTime: -500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(100);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest20() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_500_capsuleStartTime_is_-500_id_is_100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 500,
      capsuleStartTime: -500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(100);
    expect(result).assertEqual(0.5);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest21() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_-2000_id_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: -2000,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(-100);
    expect(result).assertEqual(-2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest22() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_0_id_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 0,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(-100);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest23() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_500_id_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 500,
      capsuleStartTime: 0,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(-100);
    expect(result).assertEqual(0.5);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest24() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_-2000_capsuleStartTime_is_500_id_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: -2000,
      capsuleStartTime: 500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(-100);
    expect(result).assertEqual(-2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest25() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_0_capsuleStartTime_is_500_id_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 0,
      capsuleStartTime: 500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(-100);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest26() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_500_capsuleStartTime_is_500_id_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 500,
      capsuleStartTime: 500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(-100);
    expect(result).assertEqual(0.5);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest27() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_-2000_capsuleStartTime_is_-500_id_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: -2000,
      capsuleStartTime: -500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(-100);
    expect(result).assertEqual(-2);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function getCapsuleShowTimeTest28() {
  it('should_return_totalKeepTime_divided_by_SEC_VAL_when_totalKeepTime_is_0_capsuleStartTime_is_-500_id_is_-100', 0, () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
    let capsuleLifecycleInfo: CapsuleLifecycleInfo = {
      totalKeepTime: 0,
      capsuleStartTime: -500,
      isCounting: false
    };
    when(mockFunc)(ArgumentMatchers.anyNumber).afterReturn(capsuleLifecycleInfo);
    const result = capsuleLifeVm.getCapsuleShowTime(-100);
    expect(result).assertEqual(0);
    mocker.ignoreMock(capsuleLifeVm, capsuleLifeVm.getCapsuleShowTime);
  });
}

function updateCapsuleShowTest1() {
  it('should_start_count_time_when_capsule_is_show', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 1;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest2() {
  it('should_start_count_time_when_capsule_is_show', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 1;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest3() {
  it('should_start_count_time_when_capsule_is_show_id_is_2', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 2;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest4() {
  it('should_start_count_time_when_capsule_is_not_show_is_2', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 2;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest5() {
  it('should_start_count_time_when_capsule_is_show_id_is_3', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 3;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest6() {
  it('should_start_count_time_when_capsule_is_not_show_is_3', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 3;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest7() {
  it('should_start_count_time_when_capsule_is_show_id_is_4', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 4;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest8() {
  it('should_start_count_time_when_capsule_is_not_show_is_4', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 4;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest9() {
  it('should_start_count_time_when_capsule_is_show_id_is_5', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 5;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest10() {
  it('should_start_count_time_when_capsule_is_not_show_is_5', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 5;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest11() {
  it('should_start_count_time_when_capsule_is_show_id_is_6', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 6;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest12() {
  it('should_start_count_time_when_capsule_is_not_show_is_6', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 6;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest13() {
  it('should_start_count_time_when_capsule_is_show_id_is_7', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 7;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest14() {
  it('should_start_count_time_when_capsule_is_not_show_is_7', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 7;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest15() {
  it('should_start_count_time_when_capsule_is_show_id_is_8', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 8;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest16() {
  it('should_start_count_time_when_capsule_is_not_show_is_8', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 8;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest17() {
  it('should_start_count_time_when_capsule_is_show_id_is_9', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 9;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest18() {
  it('should_start_count_time_when_capsule_is_not_show_is_9', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 9;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest19() {
  it('should_start_count_time_when_capsule_is_show_id_is_10', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 10;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest20() {
  it('should_start_count_time_when_capsule_is_not_show_is_10', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 10;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest21() {
  it('should_start_count_time_when_capsule_is_show_id_is_11', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 11;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest22() {
  it('should_start_count_time_when_capsule_is_not_show_is_11', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 11;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest23() {
  it('should_start_count_time_when_capsule_is_show_id_is_12', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 12;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest24() {
  it('should_start_count_time_when_capsule_is_not_show_is_12', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 12;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest25() {
  it('should_start_count_time_when_capsule_is_show_id_is_13', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 13;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest26() {
  it('should_start_count_time_when_capsule_is_not_show_is_13', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 13;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest27() {
  it('should_start_count_time_when_capsule_is_show_id_is_14', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 14;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest28() {
  it('should_start_count_time_when_capsule_is_not_show_is_14', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 14;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest29() {
  it('should_start_count_time_when_capsule_is_show_id_is_15', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 15;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest30() {
  it('should_start_count_time_when_capsule_is_not_show_is_15', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 15;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest31() {
  it('should_start_count_time_when_capsule_is_show_id_is_16', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 16;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest32() {
  it('should_start_count_time_when_capsule_is_not_show_is_16', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 16;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest33() {
  it('should_start_count_time_when_capsule_is_show_id_is_17', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 17;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest34() {
  it('should_start_count_time_when_capsule_is_not_show_is_17', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 17;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest35() {
  it('should_start_count_time_when_capsule_is_show_id_is_18', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 18;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest36() {
  it('should_start_count_time_when_capsule_is_not_show_is_18', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 18;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest37() {
  it('should_start_count_time_when_capsule_is_show_id_is_19', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 19;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest38() {
  it('should_start_count_time_when_capsule_is_not_show_is_19', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 19;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest39() {
  it('should_start_count_time_when_capsule_is_show_id_is_20', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 20;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest40() {
  it('should_start_count_time_when_capsule_is_not_show_is_20', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 20;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest41() {
  it('should_start_count_time_when_capsule_is_show_id_is_21', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 21;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest42() {
  it('should_start_count_time_when_capsule_is_not_show_is_21', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 21;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest43() {
  it('should_start_count_time_when_capsule_is_show_id_is_22', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 22;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest44() {
  it('should_start_count_time_when_capsule_is_not_show_is_22', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 22;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest45() {
  it('should_start_count_time_when_capsule_is_show_id_is_23', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 23;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest46() {
  it('should_start_count_time_when_capsule_is_not_show_is_23', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 23;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest47() {
  it('should_start_count_time_when_capsule_is_show_id_is_24', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 24;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest48() {
  it('should_start_count_time_when_capsule_is_not_show_is_24', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 24;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest49() {
  it('should_start_count_time_when_capsule_is_show_id_is_25', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 25;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest50() {
  it('should_start_count_time_when_capsule_is_not_show_is_25', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 25;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest51() {
  it('should_start_count_time_when_capsule_is_show_id_is_26', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 26;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest52() {
  it('should_start_count_time_when_capsule_is_not_show_is_26', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 26;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest53() {
  it('should_start_count_time_when_capsule_is_show_id_is_27', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 27;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest54() {
  it('should_start_count_time_when_capsule_is_not_show_is_27', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 27;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest55() {
  it('should_start_count_time_when_capsule_is_show_id_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 28;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest56() {
  it('should_start_count_time_when_capsule_is_not_show_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 28;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest57() {
  it('should_start_count_time_when_capsule_is_show_id_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 29;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest58() {
  it('should_start_count_time_when_capsule_is_not_show_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 29;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest59() {
  it('should_start_count_time_when_capsule_is_show_id_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 30;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest60() {
  it('should_start_count_time_when_capsule_is_not_show_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 30;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest61() {
  it('should_start_count_time_when_capsule_is_show_id_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 31;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest62() {
  it('should_start_count_time_when_capsule_is_not_show_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 31;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest63() {
  it('should_start_count_time_when_capsule_is_show_id_is_32', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 32;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest64() {
  it('should_start_count_time_when_capsule_is_not_show_is_32', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 32;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest65() {
  it('should_start_count_time_when_capsule_is_show_id_is_33', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 33;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest66() {
  it('should_start_count_time_when_capsule_is_not_show_is_33', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 33;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest67() {
  it('should_start_count_time_when_capsule_is_show_id_is_34', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 34;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest68() {
  it('should_start_count_time_when_capsule_is_not_show_is_34', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 34;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest69() {
  it('should_start_count_time_when_capsule_is_show_id_is_35', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 35;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest70() {
  it('should_start_count_time_when_capsule_is_not_show_is_35', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 35;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest71() {
  it('should_start_count_time_when_capsule_is_show_id_is_36', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 36;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest72() {
  it('should_start_count_time_when_capsule_is_not_show_is_36', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 36;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest73() {
  it('should_start_count_time_when_capsule_is_show_id_is_37', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 37;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest74() {
  it('should_start_count_time_when_capsule_is_not_show_is_37', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 37;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest75() {
  it('should_start_count_time_when_capsule_is_show_id_is_38', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 38;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest76() {
  it('should_start_count_time_when_capsule_is_not_show_is_38', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 38;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest77() {
  it('should_start_count_time_when_capsule_is_show_id_is_39', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 39;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest78() {
  it('should_start_count_time_when_capsule_is_not_show_is_39', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 39;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest79() {
  it('should_start_count_time_when_capsule_is_show_id_is_40', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 40;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest80() {
  it('should_start_count_time_when_capsule_is_not_show_is_40', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 40;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest81() {
  it('should_start_count_time_when_capsule_is_show_id_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 28;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest82() {
  it('should_start_count_time_when_capsule_is_not_show_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 28;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest83() {
  it('should_start_count_time_when_capsule_is_show_id_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 29;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest84() {
  it('should_start_count_time_when_capsule_is_not_show_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 29;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest85() {
  it('should_start_count_time_when_capsule_is_show_id_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 30;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest86() {
  it('should_start_count_time_when_capsule_is_not_show_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 30;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest87() {
  it('should_start_count_time_when_capsule_is_show_id_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 31;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest88() {
  it('should_start_count_time_when_capsule_is_not_show_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 31;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest89() {
  it('should_start_count_time_when_capsule_is_show_id_is_32', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 32;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest90() {
  it('should_start_count_time_when_capsule_is_not_show_is_32', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 32;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest91() {
  it('should_start_count_time_when_capsule_is_show_id_is_33', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 33;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest92() {
  it('should_start_count_time_when_capsule_is_not_show_is_33', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 33;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest93() {
  it('should_start_count_time_when_capsule_is_show_id_is_34', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 34;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest94() {
  it('should_start_count_time_when_capsule_is_not_show_is_34', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 34;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest95() {
  it('should_start_count_time_when_capsule_is_show_id_is_35', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 35;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest96() {
  it('should_start_count_time_when_capsule_is_not_show_is_35', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 35;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest97() {
  it('should_start_count_time_when_capsule_is_show_id_is_36', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 36;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest98() {
  it('should_start_count_time_when_capsule_is_not_show_is_36', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 36;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest99() {
  it('should_start_count_time_when_capsule_is_show_id_is_37', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 37;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest100() {
  it('should_start_count_time_when_capsule_is_not_show_is_37', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 37;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest101() {
  it('should_start_count_time_when_capsule_is_show_id_is_38', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 38;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest102() {
  it('should_start_count_time_when_capsule_is_not_show_is_38', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 38;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest103() {
  it('should_start_count_time_when_capsule_is_show_id_is_39', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 39;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest104() {
  it('should_start_count_time_when_capsule_is_not_show_is_39', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 39;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest105() {
  it('should_start_count_time_when_capsule_is_show_id_is_40', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 40;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest106() {
  it('should_start_count_time_when_capsule_is_not_show_is_40', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 40;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest107() {
  it('should_start_count_time_when_capsule_is_show_id_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 28;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest108() {
  it('should_start_count_time_when_capsule_is_not_show_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 28;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest109() {
  it('should_start_count_time_when_capsule_is_show_id_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 29;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest110() {
  it('should_start_count_time_when_capsule_is_not_show_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 29;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest111() {
  it('should_start_count_time_when_capsule_is_show_id_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 30;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest112() {
  it('should_start_count_time_when_capsule_is_not_show_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 30;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest113() {
  it('should_start_count_time_when_capsule_is_show_id_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 31;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest114() {
  it('should_start_count_time_when_capsule_is_not_show_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 31;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest115() {
  it('should_start_count_time_when_capsule_is_show_id_is_32', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 32;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest116() {
  it('should_start_count_time_when_capsule_is_not_show_is_32', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 32;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest117() {
  it('should_start_count_time_when_capsule_is_show_id_is_33', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 33;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest118() {
  it('should_start_count_time_when_capsule_is_not_show_is_33', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 33;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest119() {
  it('should_start_count_time_when_capsule_is_show_id_is_34', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 34;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest120() {
  it('should_start_count_time_when_capsule_is_not_show_is_34', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 34;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest121() {
  it('should_start_count_time_when_capsule_is_show_id_is_35', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 35;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest122() {
  it('should_start_count_time_when_capsule_is_not_show_is_35', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 35;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest123() {
  it('should_start_count_time_when_capsule_is_show_id_is_36', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 36;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest124() {
  it('should_start_count_time_when_capsule_is_not_show_is_36', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 36;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest125() {
  it('should_start_count_time_when_capsule_is_show_id_is_37', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 37;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest126() {
  it('should_start_count_time_when_capsule_is_not_show_is_37', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 37;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest127() {
  it('should_start_count_time_when_capsule_is_show_id_is_38', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 38;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest128() {
  it('should_start_count_time_when_capsule_is_not_show_is_38', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 38;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest129() {
  it('should_start_count_time_when_capsule_is_show_id_is_39', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 39;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest130() {
  it('should_start_count_time_when_capsule_is_not_show_is_39', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 39;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest131() {
  it('should_start_count_time_when_capsule_is_show_id_is_40', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 40;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest132() {
  it('should_start_count_time_when_capsule_is_not_show_is_40', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 40;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}


function updateCapsuleShowTest133() {
  it('should_start_count_time_when_capsule_is_show_id_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 28;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest134() {
  it('should_start_count_time_when_capsule_is_not_show_is_28', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 28;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest135() {
  it('should_start_count_time_when_capsule_is_show_id_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 29;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest136() {
  it('should_start_count_time_when_capsule_is_not_show_is_29', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 29;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest137() {
  it('should_start_count_time_when_capsule_is_show_id_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 30;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest138() {
  it('should_start_count_time_when_capsule_is_not_show_is_30', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 30;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest139() {
  it('should_start_count_time_when_capsule_is_show_id_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 31;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest140() {
  it('should_start_count_time_when_capsule_is_not_show_is_31', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 31;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest141() {
  it('should_start_count_time_when_capsule_is_show_id_is_32', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 32;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest142() {
  it('should_start_count_time_when_capsule_is_not_show_is_32', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 32;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest143() {
  it('should_start_count_time_when_capsule_is_show_id_is_33', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 33;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest144() {
  it('should_start_count_time_when_capsule_is_not_show_is_33', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 33;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest145() {
  it('should_start_count_time_when_capsule_is_show_id_is_34', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 34;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest146() {
  it('should_start_count_time_when_capsule_is_not_show_is_34', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 34;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest147() {
  it('should_start_count_time_when_capsule_is_show_id_is_35', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 35;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest148() {
  it('should_start_count_time_when_capsule_is_not_show_is_35', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 35;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest149() {
  it('should_start_count_time_when_capsule_is_show_id_is_36', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 36;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest150() {
  it('should_start_count_time_when_capsule_is_not_show_is_36', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 36;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest151() {
  it('should_start_count_time_when_capsule_is_show_id_is_37', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 37;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest152() {
  it('should_start_count_time_when_capsule_is_not_show_is_37', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 37;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest153() {
  it('should_start_count_time_when_capsule_is_show_id_is_38', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 38;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest154() {
  it('should_start_count_time_when_capsule_is_not_show_is_38', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 38;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest155() {
  it('should_start_count_time_when_capsule_is_show_id_is_39', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 39;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest156() {
  it('should_start_count_time_when_capsule_is_not_show_is_39', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 39;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest157() {
  it('should_start_count_time_when_capsule_is_show_id_is_40', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 40;
    capsuleVm.isShow = true;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

function updateCapsuleShowTest158() {
  it('should_start_count_time_when_capsule_is_not_show_is_40', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let capsuleLifeVm: LiveCapsuleLifecycleVm = new LiveCapsuleLifecycleVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let vmInjector: LiveVmInjector = new LiveVmInjector();
    let mockFunc: Function = mocker.mockFunc(capsuleLifeVm, capsuleLifeVm.updateCapsuleShow);
    let live: LiveNotification = new LiveNotification();
    let capsuleVm = liveVmInjector.getCapsuleVm(live);
    live.id = 40;
    capsuleVm.isShow = false;
    when(mockFunc)(ArgumentMatchers.any).afterReturn(null);

    await capsuleLifeVm.updateCapsuleShow([live]);
    mocker.ignoreMock(vmInjector, vmInjector.getCapsuleVm);
  });
}

class CapsuleLifecycleInfo {
  /**
   * 胶囊总的出现时间
   */
  public totalKeepTime: number = 0;
  /**
   * 胶囊本次开始出现的时间点
   */
  public capsuleStartTime: number = 0;
  /**
   * 是否正在计时中
   */
  public isCounting: boolean = false;
}
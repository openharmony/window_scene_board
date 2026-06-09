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
import { afterAll, afterEach,
  ArgumentMatchers,
  beforeAll, beforeEach, DEFAULT, describe, expect, it, MockKit, when } from '@ohos/hypium';
import { AnimateParams, AnimationBase, LiveVmInjector } from '../../../../../../../newIndex';
import {
  LiveCapsuleListMultipleHoleAnimVm
} from '../../../../../../main/ets/live/vm/LiveCapsuleListMultipleHoleAnimVm';
import { ILiveCapsuleListAnimVm } from '../../../../../../main/ets/live/interface/ILiveCapsuleListAnimVm';
import { CapsuleShowType } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { SystemUICommonUtil } from '../../../../../../main/ets/utils/SystemUICommonUtil';

const mockVmInjector = {
  getCapsuleListVm: () => ({ liveList: [] }),
  getCapsuleVm: (live: LiveNotification) => ({ fixedShowType: CapsuleShowType.NONE, fixedOffsetX: 0, fixedWidth: 0, isShowed: false }),
  get: () => ({ liveList: [] })
};

const mockAnimation = mock(AnimationBase);
const mockSystemUICommonUtil = mock(SystemUICommonUtil);

mockAnimation.executeAnimation.withAnyArguments().returns();
mockSystemUICommonUtil.sleep.withArgs(333).returns();

describe('LiveCapsuleListMultipleHoleAnimVm', () => {
  it('should test setCapsuleListFinalState method',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    await liveCapsuleListMultipleHoleAnimVm.setCapsuleListFinalState();
    expect(liveCapsuleListMultipleHoleAnimVm.collapseCapsuleList).toHaveBeenCalled();
    expect(liveCapsuleListMultipleHoleAnimVm.setCapsuleTransferState).toHaveBeenCalled();
    expect(liveCapsuleListMultipleHoleAnimVm.expandCapsuleList).toHaveBeenCalled();
  });

  it('should test collapseCapsuleList method',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    await liveCapsuleListMultipleHoleAnimVm.collapseCapsuleList();
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test expandCapsuleList method',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    await liveCapsuleListMultipleHoleAnimVm.expandCapsuleList();
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test offsetDisappear method',DEFAULT, () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const live = { hashCode: 1, creatorBundleName: 'com.example.app' };
    const offsetDisappear = liveCapsuleListMultipleHoleAnimVm.offsetDisappear(live);
    expect(offsetDisappear).toEqual({
      curve: Curve.Linear,
      duration: 250,
      event: expect.any(Function)
    });
  });

  it('should test offsetAppear method',DEFAULT, () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const live = { hashCode: 1, creatorBundleName: 'com.example.app' };
    const offsetAppear = liveCapsuleListMultipleHoleAnimVm.offsetAppear(live);
    expect(offsetAppear).toEqual({
      curve: Curve.Linear,
      duration: 250,
      event: expect.any(Function)
    });
  });

  it('should test setCapsuleInitalState method',DEFAULT, () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const live = { hashCode: 1, creatorBundleName: 'com.example.app' };
    liveCapsuleListMultipleHoleAnimVm.setCapsuleInitalState(live);
    expect(mockAnimation.setInitialState).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset method',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with liveList length 0',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList);
    expect(mockAnimation.executeAnimation).not.toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with liveList length 1',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with liveList length 2',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}, {}];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with live parameter',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}];
    const live = { hashCode: 1, creatorBundleName: 'com.example.app' };
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList, live);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with null live parameter',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList, null);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with undefined live parameter',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList, undefined);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with empty liveList and live parameter',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [];
    const live = { hashCode: 1, creatorBundleName: 'com.example.app' };
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList, live);
    expect(mockAnimation.executeAnimation).not.toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with liveList containing null',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}, null, {}];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with liveList containing undefined',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}, undefined, {}];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with liveList containing mixed types',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}, null, undefined, {}];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });

  it('should test updateCapsuleWidthAndOffset with liveList containing objects with different showTypes',DEFAULT, async () => {
    const liveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(mockVmInjector);
    const liveList = [{}];
    await liveCapsuleListMultipleHoleAnimVm.updateCapsuleWidthAndOffset(liveList);
    expect(mockAnimation.executeAnimation).toHaveBeenCalled();
  });
});

export default function LiveCapsuleListMultipleHoleAnimVmTest() {
  describe('setCapsuleListFinalState_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    setCapsuleListFinalStateTest1();

    setCapsuleListFinalStateTest2();

    setCapsuleListFinalStateTest3();

    setCapsuleListFinalStateTest4();
  });

  describe('collapseCapsuleList_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    collapseCapsuleListTest1();

    collapseCapsuleListTest2();
  });

  describe('expandCapsuleList_testSuite', () => {
    beforeAll(() => {

    })

    beforeEach(() => {

    })

    afterEach(() => {

    })

    afterAll(() => {

    })

    expandCapsuleList1();

    expandCapsuleList2();

    expandCapsuleList3();

    expandCapsuleList4();

    expandCapsuleList5();

    expandCapsuleList6();

    expandCapsuleList7();

    expandCapsuleList8();

    expandCapsuleList9();

    expandCapsuleList10();
  });

  describe('updateCapsuleWidthAndOffset_testSuite', () => {

    beforeEach(() => {

    });
    afterEach(() => {

    });

    updateCapsuleWidthAndOffsetTest1();
    updateCapsuleWidthAndOffsetTest2();
  });
}

function updateCapsuleWidthAndOffsetTest1() {
  it('should_call_updateCapsuleAttribute_when_live_is_undefined', 0, async () => {
    let liveList: LiveNotification[] = [new LiveNotification()];
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.updateCapsuleWidthAndOffset(liveList);

    mocker.verify('updateCapsuleWidthAndOffset', [liveList]);
  });
}

function updateCapsuleWidthAndOffsetTest2() {
  it('should_call_updateCapsuleAttribute_when_live_is_not_undefined', 0, async () => {
    let live1: LiveNotification = new LiveNotification();
    let live2: LiveNotification = new LiveNotification();
    let liveList: LiveNotification[] = [live1, live2];
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.updateCapsuleWidthAndOffset(liveList, live1);
    await multiHoleAnimVm.updateCapsuleWidthAndOffset(liveList, live2);

    mocker.verify('updateCapsuleWidthAndOffset', [liveList, live1]);
    mocker.verify('updateCapsuleWidthAndOffset', [liveList, live2]);
  });
}

function expandCapsuleList1() {
  it('should_return_immediately_when_capsuleList_is_empty', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      mocker.verify('setCapsuleInitalState', [live]).times(1);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function expandCapsuleList2() {
  it('should_skip_capsules_when_fixedShowType_is_NONE', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      const capsule = liveVmInjector.getCapsuleVm(live);
      capsule.fixedShowType = CapsuleShowType.NONE;
      mocker.verify('setCapsuleInitalState', [live]).times(0);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function expandCapsuleList3() {
  it('should_skip_capsules_when_fixedShowType_is_ROUND_CAKE_and_isShowed_is_false', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      const capsule = liveVmInjector.getCapsuleVm(live);
      capsule.fixedShowType = CapsuleShowType.ROUND_CAKE;
      capsule.isShowed = false;
      mocker.verify('setCapsuleInitalState', [live]).times(0);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function expandCapsuleList4() {
  it('should_skip_capsules_when_fixedShowType_is_RIGHT_HOLE_and_isShowed_is_false', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      const capsule = liveVmInjector.getCapsuleVm(live);
      capsule.fixedShowType = CapsuleShowType.RIGHT_HOLE;
      capsule.isShowed = true;
      mocker.verify('setCapsuleInitalState', [live]).times(0);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function expandCapsuleList5() {
  it('should_skip_capsules_when_fixedShowType_is_TOP_and_isShowed_is_false', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      const capsule = liveVmInjector.getCapsuleVm(live);
      capsule.fixedShowType = CapsuleShowType.TOP;
      capsule.isShowed = true;
      mocker.verify('setCapsuleInitalState', [live]).times(0);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function expandCapsuleList6() {
  it('should_skip_capsules_when_fixedShowType_is_LEFT_HOLE_and_isShowed_is_false', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      const capsule = liveVmInjector.getCapsuleVm(live);
      capsule.fixedShowType = CapsuleShowType.LEFT_HOLE;
      capsule.isShowed = true;
      mocker.verify('setCapsuleInitalState', [live]).times(0);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function expandCapsuleList7() {
  it('should_skip_capsules_when_fixedShowType_is_RETRACTABLE_ROUND_CAKE_and_isShowed_is_false', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      const capsule = liveVmInjector.getCapsuleVm(live);
      capsule.fixedShowType = CapsuleShowType.RETRACTABLE_ROUND_CAKE;
      capsule.isShowed = true;
      mocker.verify('setCapsuleInitalState', [live]).times(0);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function expandCapsuleList8() {
  it('should_skip_capsules_when_fixedShowType_is_HANGING_HOLE_and_isShowed_is_false', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      const capsule = liveVmInjector.getCapsuleVm(live);
      capsule.fixedShowType = CapsuleShowType.HANGING_HOLE;
      capsule.isShowed = true;
      mocker.verify('setCapsuleInitalState', [live]).times(0);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function expandCapsuleList9() {
  it('should_skip_capsules_when_fixedShowType_is_SHADOW_and_isShowed_is_false', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      const capsule = liveVmInjector.getCapsuleVm(live);
      capsule.fixedShowType = CapsuleShowType.SHADOW;
      capsule.isShowed = true;
      mocker.verify('setCapsuleInitalState', [live]).times(0);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function expandCapsuleList10() {
  it('should_skip_capsules_when_fixedShowType_is_SELF_ADAPTIVE_ROUND_CAKE_and_isShowed_is_false', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let liveList = liveVmInjector.getCapsuleListVm().liveList;
    let cmds: AnimateParams[] = [];
    liveList = [];
    let mocker: MockKit = new MockKit();

    await multiHoleAnimVm.expandCapsuleList();

    for (const live of liveList) {
      const capsule = liveVmInjector.getCapsuleVm(live);
      capsule.fixedShowType = CapsuleShowType.SELF_ADAPTIVE_ROUND_CAKE;
      capsule.isShowed = true;
      mocker.verify('setCapsuleInitalState', [live]).times(0);
    }
    mocker.verify('animation.executeAnimation', [cmds, 'collapseCapsuleList']).times(0);
  });
}

function collapseCapsuleListTest1() {
  it('should_return_immediately_when_capsuleList_is_empty', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let mocker: MockKit = new MockKit();
    let mockFunc: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    when(mockFunc)([]).afterReturn({
      liveList: []
    });

    await multiHoleAnimVm.collapseCapsuleList();

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
  });
}

function collapseCapsuleListTest2() {
  it('should_call_offsetDisappear_for_each_capsule_when_fixedShowType_is_not_NONE', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let mocker: MockKit = new MockKit();
    let mockFunc1: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleListVm);
    let mockCapsuleVm: ILiveCapsuleListAnimVm = liveVmInjector.getCapsuleListAnimVm();
    when(mockFunc1)([]).afterReturn({
      liveList: [mockCapsuleVm]
    });

    let mockFunc2: Function = mocker.mockFunc(liveVmInjector, liveVmInjector.getCapsuleVm);
    when(mockFunc2)([ArgumentMatchers.any]).afterReturn(mockCapsuleVm);

    let mockFunc3: Function = mocker.mockFunc(animation, animation.executeAnimation);
    when(mockFunc3)([ArgumentMatchers.any, ArgumentMatchers.anyString]).afterReturn(Promise.resolve());

    await multiHoleAnimVm.collapseCapsuleList();
    mocker.verify('expandCapsuleList', [ArgumentMatchers.any]).once();

    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleListVm);
    mocker.ignoreMock(liveVmInjector, liveVmInjector.getCapsuleVm);
    mocker.ignoreMock(animation, animation.executeAnimation);
  });
}

function setCapsuleListFinalStateTest1() {
  it('should_call_collapseCapsuleList_and_expandCapsuleList_when_setCapsuleListFinalState_is_called', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    let mockCollapse: Function = mocker.mockFunc(multiHoleAnimVm, multiHoleAnimVm.collapseCapsuleList);
    when(mockCollapse)(ArgumentMatchers.any).afterReturn(Promise.resolve());

    let mockExpand: Function = mocker.mockFunc(multiHoleAnimVm, multiHoleAnimVm.expandCapsuleList);
    when(mockExpand)(ArgumentMatchers.any).afterReturn(Promise.resolve());

    await multiHoleAnimVm.setCapsuleListFinalState();

    mocker.verify('expandCapsuleList', [ArgumentMatchers.any]).once();
    mocker.ignoreMock(multiHoleAnimVm, multiHoleAnimVm.collapseCapsuleList);
    mocker.ignoreMock(multiHoleAnimVm, multiHoleAnimVm.expandCapsuleList);
  });
}

function setCapsuleListFinalStateTest2() {
  it('should_call_sleep_when_setCapsuleListFinalState_is_called', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    let mockCollapse: Function = mocker.mockFunc(multiHoleAnimVm, multiHoleAnimVm.collapseCapsuleList);
    when(mockCollapse)(ArgumentMatchers.any).afterReturn(Promise.resolve());

    let mockExpand: Function = mocker.mockFunc(multiHoleAnimVm, multiHoleAnimVm.expandCapsuleList);
    when(mockExpand)(ArgumentMatchers.any).afterReturn(Promise.resolve());

    let mockSleep: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.sleep);
    when(mockSleep)(ArgumentMatchers.anyNumber).afterReturn(Promise.resolve());

    await multiHoleAnimVm.setCapsuleListFinalState();

    mocker.verify('expandCapsuleList', [ArgumentMatchers.any]).once();
    mocker.ignoreMock(multiHoleAnimVm, multiHoleAnimVm.collapseCapsuleList);
    mocker.ignoreMock(multiHoleAnimVm, multiHoleAnimVm.expandCapsuleList);
    mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.sleep);
  });
}

function setCapsuleListFinalStateTest3() {
  it('should_call_animation_when_setCapsuleListFinalState_is_called', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let animation: AnimationBase = new AnimationBase(AnimationBase.NAMES.CAPSULE_LIST_ANIMATION);
    let mocker: MockKit = new MockKit();

    let mockCollapse: Function = mocker.mockFunc(multiHoleAnimVm, multiHoleAnimVm.collapseCapsuleList);
    when(mockCollapse)(ArgumentMatchers.any).afterReturn(Promise.resolve());

    let mockExpand: Function = mocker.mockFunc(multiHoleAnimVm, multiHoleAnimVm.expandCapsuleList);
    when(mockExpand)(ArgumentMatchers.any).afterReturn(Promise.resolve());

    let mockSleep: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.sleep);
    when(mockSleep)(ArgumentMatchers.anyNumber).afterReturn(Promise.resolve());

    await multiHoleAnimVm.setCapsuleListFinalState();

    mocker.verify('expandCapsuleList', [ArgumentMatchers.any]).once();
    mocker.ignoreMock(multiHoleAnimVm, multiHoleAnimVm.collapseCapsuleList);
    mocker.ignoreMock(multiHoleAnimVm, multiHoleAnimVm.expandCapsuleList);
    mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.sleep);
  });
}

function setCapsuleListFinalStateTest4() {
  it('should_call_hiSysEvent_when_setCapsuleListFinalState_is_called', 0, async () => {
    let liveVmInjector: LiveVmInjector = LiveVmInjector.instance;
    let multiHoleAnimVm: LiveCapsuleListMultipleHoleAnimVm = new LiveCapsuleListMultipleHoleAnimVm(liveVmInjector);
    let mocker: MockKit = new MockKit();

    let mockCollapse: Function = mocker.mockFunc(multiHoleAnimVm, multiHoleAnimVm.collapseCapsuleList);
    when(mockCollapse)(ArgumentMatchers.any).afterReturn(Promise.resolve());

    let mockExpand: Function = mocker.mockFunc(multiHoleAnimVm, multiHoleAnimVm.expandCapsuleList);
    when(mockExpand)(ArgumentMatchers.any).afterReturn(Promise.resolve());

    let mockSleep: Function = mocker.mockFunc(SystemUICommonUtil, SystemUICommonUtil.sleep);
    when(mockSleep)(ArgumentMatchers.anyNumber).afterReturn(Promise.resolve());

    await multiHoleAnimVm.setCapsuleListFinalState();
    mocker.verify('expandCapsuleList', [ArgumentMatchers.any]).once();

    mocker.ignoreMock(multiHoleAnimVm, multiHoleAnimVm.collapseCapsuleList);
    mocker.ignoreMock(multiHoleAnimVm, multiHoleAnimVm.expandCapsuleList);
    mocker.ignoreMock(SystemUICommonUtil, SystemUICommonUtil.sleep);
  });
}
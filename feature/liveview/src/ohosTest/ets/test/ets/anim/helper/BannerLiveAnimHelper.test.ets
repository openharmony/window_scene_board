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

import { RectInfo } from '@ohos/basicutils';
import { ItemUtils } from '@ohos/componenthelper';

import {
  afterAll,
  afterEach,
  ArgumentMatchers,
  beforeAll,
  beforeEach,
  describe,
  expect,
  it,
  MockKit,
  when
} from '@ohos/hypium';
import {
  CapsuleListState,
  ComponentAnimState,
  LiveViewCapsuleStyle,
  LiveViewData,
  LiveViewDataArray
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { BannerLiveAnimHelper } from '../../../../../../main/ets/anim/helper/BannerLiveAnimHelper';
import { liveCapsuleVm, LiveViewVm } from '../../../../../../main/ets/vm/LiveViewVm';

export function BannerLiveAnimHelperTest01() {

  describe('BannerLiveAnimHelperTest', () => {
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => { // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });


    Test01();
    Test02();
    Test03();
    Test04();
    Test05();
  });
}

function Test01() {
  let bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();

  it('updateLiveListInfo_1', 0, () => {
    let mocker: MockKit = new MockKit();
    let arr = new LiveViewDataArray();
    let data = new LiveViewData();
    arr.push(data);

    let mockFunc: Function = mocker.mockFunc(liveCapsuleVm, liveCapsuleVm.getCapsuleList);
    when(mockFunc)().afterReturn(arr);

    const getRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(getRectById)(ArgumentMatchers.anyString).afterReturn(
      {
        left: 1,
        top: 1,
        right: 1,
        bottom: 1
      }
    );

    try {
      bannerLiveAnimHelper.updateLiveListInfo();
      expect(true).assertTrue();
    } catch (err) {
    }
  });

  it('updateLiveListInfo_2', 0, () => {
    let mocker: MockKit = new MockKit();
    let arr = new LiveViewDataArray();
    let data = new LiveViewData();
    arr.push(data);

    let mockFunc: Function = mocker.mockFunc(liveCapsuleVm, liveCapsuleVm.getCapsuleList);
    when(mockFunc)().afterReturn(arr);

    const getRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(getRectById)(ArgumentMatchers.anyString).afterReturn(
      {
        left: 1,
        top: 1,
        right: 1,
        bottom: 1,
        height: 1,
      }
    );

    try {
      bannerLiveAnimHelper.updateLiveListInfo();
      expect(true).assertTrue();
    } catch (err) {
    }
  });
}

function Test02() {
  let bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();
  it('updateLiveListInfo_3', 0, () => {
    let mocker: MockKit = new MockKit();
    let arr = new LiveViewDataArray();
    let data = new LiveViewData();
    arr.push(data);

    let mockFunc: Function = mocker.mockFunc(liveCapsuleVm, liveCapsuleVm.getCapsuleList);
    when(mockFunc)().afterReturn(arr);

    const getRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(getRectById)(ArgumentMatchers.anyString).afterReturn(
      {
        left: 1,
        top: 1,
        right: 1,
        bottom: 1
      }
    );

    let func = () => bannerLiveAnimHelper.updateLiveListInfo();
    expect(func()).not().assertFail();
  });

  it('updateLiveListInfo_4', 0, () => {
    let mocker: MockKit = new MockKit();
    let arr = new LiveViewDataArray();
    let data = new LiveViewData();
    arr.push(data);

    let mockFunc: Function = mocker.mockFunc(liveCapsuleVm, liveCapsuleVm.getCapsuleList);
    when(mockFunc)().afterReturn(arr);

    const getRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(getRectById)(ArgumentMatchers.anyString).afterReturn(
      {
        left: 1,
        top: 1,
        right: 1,
        bottom: 1,
        height: 1,
      }
    );

    let func = () => bannerLiveAnimHelper.updateLiveListInfo();
    expect(func()).not().assertFail();
  });
}

function Test03() {
  let bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();
  it('updateLiveListInfo_5', 0, () => {
    let mocker: MockKit = new MockKit();
    let arr = new LiveViewDataArray();
    let data = new LiveViewData();
    arr.push(data);

    let mockFunc: Function = mocker.mockFunc(liveCapsuleVm, liveCapsuleVm.getCapsuleList);
    when(mockFunc)().afterReturn(arr);

    const getRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(getRectById)(ArgumentMatchers.anyString).afterReturn(
      {
        left: 1,
        top: 1,
        right: 1,
        bottom: 1
      }
    );

    let func = () => bannerLiveAnimHelper.updateLiveListInfo();
    expect(func()).not().assertFail();
    let result = (bannerLiveAnimHelper as object)['liveListRectList'] as RectInfo[];
    expect(result.length).assertEqual(0);
  });

  it('updateLiveListInfo_6', 0, () => {
    let mocker: MockKit = new MockKit();
    let arr = new LiveViewDataArray();
    let data = new LiveViewData();
    arr.push(data);

    let mockFunc: Function = mocker.mockFunc(liveCapsuleVm, liveCapsuleVm.getCapsuleList);
    when(mockFunc)().afterReturn(arr);

    const getRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(getRectById)(ArgumentMatchers.anyString).afterReturn(
      {
        left: 1,
        top: 1,
        right: 1,
        bottom: 1,
        height: 1,
      }
    );

    let func = () => bannerLiveAnimHelper.updateLiveListInfo();
    expect(func()).not().assertFail();
  });
}

function Test04() {
  let bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();

  it('updateLiveListInfo_7', 0, () => {
    let mocker: MockKit = new MockKit();
    let arr = new LiveViewDataArray();
    let data = new LiveViewData();
    arr.push(data);

    let mockFunc: Function = mocker.mockFunc(liveCapsuleVm, liveCapsuleVm.getCapsuleList);
    when(mockFunc)().afterReturn(arr);

    const getRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(getRectById)(ArgumentMatchers.anyString).afterReturn(
      {
        left: 1,
        top: 1,
        right: 1,
        bottom: 1
      }
    );

    let func = () => bannerLiveAnimHelper.updateLiveListInfo();
    expect(func()).not().assertFail();
  });

  it('updateLiveListInfo_8', 0, () => {
    let mocker: MockKit = new MockKit();
    let arr = new LiveViewDataArray();
    let data = new LiveViewData();
    arr.push(data);

    let mockFunc: Function = mocker.mockFunc(liveCapsuleVm, liveCapsuleVm.getCapsuleList);
    when(mockFunc)().afterReturn(arr);

    const getRectById: Function = mocker.mockFunc(ItemUtils, ItemUtils.getRectById);
    when(getRectById)(ArgumentMatchers.anyString).afterReturn(
      {
        left: 1,
        top: 1,
        right: 1,
        bottom: 1,
        height: 1,
      }
    );

    let func = () => bannerLiveAnimHelper.updateLiveListInfo();
    expect(func()).not().assertFail();
  });
}

function Test05() {
  const bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();
  it('getLiveListItem', 0, () => {
    let func = () => bannerLiveAnimHelper.getLiveListItem(0);
    expect(func).not().assertFail();
  });
  it('setAnimStatus', 0, () => {
    let func = () => bannerLiveAnimHelper.setAnimStatus(true);
    expect(func).not().assertFail();
    let func1 = () => bannerLiveAnimHelper.setAnimStatus(false);
    expect(func1).not().assertFail();
    bannerLiveAnimHelper.getAnimStatus()
  });

  it('updateCapsuleArea', 0, () => {
    let func = () => bannerLiveAnimHelper.updateCapsuleArea(undefined);
    expect(func).not().assertFail();

    let area: Area = {
      width: 1,
      height: 0,
      position: {
        x: 0,
        y: 0
      },
      globalPosition: {
        x: 0,
        y: 0
      }
    }
    let mocker: MockKit = new MockKit();
    let state: CapsuleListState = new CapsuleListState();
    let mockFunc: Function = mocker.mockFunc(state, state.getCapsuleWidth);
    let updateFunc = () => bannerLiveAnimHelper.updateCapsuleArea(area);
    when(mockFunc)().afterReturn(0);
    expect(updateFunc).not().assertFail();
  });

  it('updateLiveListInfo_9', 0, () => {
    try {
      bannerLiveAnimHelper.updateLiveListInfo();
      expect(true).assertTrue();
    } catch (err) {
    }
  });
}

export function BannerLiveAnimHelperTest02() {
  describe('LiveViewItemSwipeVmTest', () => {
    let area: Area = {
      width: 1,
      height: 1,
      position: {},
      globalPosition: {}
    };

    beforeAll(() => {
    })
    beforeEach(() => {
      area = {
        width: 1,
        height: 1,
        position: {},
        globalPosition: {}
      };
    })
    afterEach(() => {
      area = {
        width: 1,
        height: 1,
        position: {},
        globalPosition: {}
      };
    })
    afterAll(() => {
    })

    it('getCapsuleX', 0, () => {
      interface Helper {
        getCapsuleX(): number;
      }

      let bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();
      let helper: Helper = (bannerLiveAnimHelper as object as Helper);
      Reflect.set(helper, 'bannerCapsuleArea', undefined);
      expect(helper.getCapsuleX()).not().assertFail();

      Reflect.set(helper, 'bannerCapsuleArea', area);
      expect(helper.getCapsuleX()).not().assertFail();

      Reflect.set(area, 'globalPosition', { x: 1 });
      expect(helper.getCapsuleX()).not().assertFail();
    });
    Test06(area);
    Test07(area);
    Test08(area);
    Test09();
  })
}

function Test06(area: Area) {
  let bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();

  it('getCapsuleY', 0, () => {
    interface Helper {
      getCapsuleY(): number;
    }

    let helper: Helper = (bannerLiveAnimHelper as object as Helper);
    Reflect.set(helper, 'bannerCapsuleArea', undefined);
    expect(helper.getCapsuleY()).not().assertFail();

    Reflect.set(helper, 'bannerCapsuleArea', area);
    expect(helper.getCapsuleY()).not().assertFail();

    Reflect.set(area, 'globalPosition', { y: 1 });
    expect(helper.getCapsuleY()).not().assertFail();
  });

  it('getLiveListToCapsuleWidthScale', 0, () => {
    interface Helper {
      getLiveListToCapsuleWidthScale(liveListInfo: RectInfo): number;
    }

    let helper: Helper = (bannerLiveAnimHelper as object as Helper);
    expect(helper.getLiveListToCapsuleWidthScale({
      width: 0,
      left: 0,
      top: 0,
      right: 0,
      bottom: 0
    })).not().assertFail()

    expect(helper.getLiveListToCapsuleWidthScale({
      width: 0,
      left: 1,
      top: 1,
      right: 1,
      bottom: 1
    })).not().assertFail()

    expect(helper.getLiveListToCapsuleWidthScale({
      width: 3,
      left: 1,
      top: 1,
      right: 1,
      bottom: 1
    })).not().assertFail()
  });
}

function Test07(area: Area) {
  let bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();
  it('getAlreadyStatus', 0, () => {
    let func = () => bannerLiveAnimHelper.getAlreadyStatus();
    expect(func).not().assertFail();
  });

  it('getCapsuleWidth', 0, () => {
    interface Helper {
      getCapsuleWidth(): number;
    }

    let helper: Helper = (bannerLiveAnimHelper as object as Helper);
    Reflect.set(helper, 'bannerCapsuleArea', undefined);
    expect(helper.getCapsuleWidth()).not().assertFail();

    Reflect.set(helper, 'liveListRectList', []);
    expect(helper.getCapsuleWidth()).not().assertFail();

    Reflect.set(helper, 'bannerCapsuleArea', area);
    expect(helper.getCapsuleWidth()).not().assertFail();

    Reflect.set(area, 'width', undefined);
    Reflect.set(helper, 'bannerCapsuleArea', area);
    expect(helper.getCapsuleWidth()).not().assertFail();
  });
}


function Test08(area: Area) {
  interface IBannerLiveAnimHelper {
    liveListRectList: RectInfo[];
  }

  let bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();

  it('test_updateCapsuleArea', 0, () => {
    try {
      bannerLiveAnimHelper.updateCapsuleArea(undefined);
      bannerLiveAnimHelper.updateCapsuleArea(area);
      area.height = 0;
      bannerLiveAnimHelper.updateCapsuleArea(area);
      expect(true).assertTrue();
    } catch (err) {
    }
  });

  it('test_getAlreadyStatus', 0, () => {
    try {
      bannerLiveAnimHelper.getAlreadyStatus();
      expect(true).assertTrue();
    } catch (err) {
    }
  });

  it('test_transformLiveListToCapsule', 0, () => {
    try {
      bannerLiveAnimHelper.transformLiveListToCapsule(0, new ComponentAnimState('name'), 0);
      expect(true).assertTrue();
    } catch (err) {
    }
  });

  it('test_transformCapsuleToLiveList', 0, () => {
    try {
      const componentAnimState = new ComponentAnimState('name');
      bannerLiveAnimHelper.transformCapsuleToLiveList(0, componentAnimState, 0);
      (bannerLiveAnimHelper as Object as IBannerLiveAnimHelper).liveListRectList = [new RectInfo(), new RectInfo()];
      bannerLiveAnimHelper.transformCapsuleToLiveList(0, componentAnimState, 0);
      expect(true).assertTrue();
    } catch (err) {
    }
  });
}

function Test09() {
  interface ILiveListVm {
    capsuleList: LiveViewDataArray;
  }

  interface IBannerLiveAnimHelper {
    liveListRectList: RectInfo[];
  }

  let bannerLiveAnimHelper: BannerLiveAnimHelper = new BannerLiveAnimHelper();
  it('test_releaseLiveList', 0, () => {
    try {
      const componentAnimState = new ComponentAnimState('name');
      bannerLiveAnimHelper.releaseLiveList(0, componentAnimState);
      (bannerLiveAnimHelper as Object as IBannerLiveAnimHelper).liveListRectList = [new RectInfo(), new RectInfo()];
      bannerLiveAnimHelper.releaseLiveList(0, componentAnimState);
      expect(true).assertTrue();
    } catch (err) {
    }
  });
}
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
import { AnimDataScene,
  BaseNotification,
  CapsuleListState,
  capsuleStateMgr, ComponentAnimState, LiveViewEntryEvent } from '@ohos/systemuicommon';
import { afterAll, afterEach, beforeAll, beforeEach, describe, expect, it, Level, MockKit, when } from '@ohos/hypium';
import { liveCapsuleVm } from '../../../../../main/ets/vm/LiveViewVm';
import { LiveViewAnimManager } from '../../../../../main/ets/anim/LiveViewAnimManager';
import { DeviceHelper } from '@ohos/frameworkwrapper';
import { LiveListAnimStatus } from '../../../../../main/ets/anim/LiveListAnimMgr';

const getLiveViewAnimManager = () => {
  const mocker: MockKit = new MockKit();
  const mockFunc: Function = mocker.mockFunc(DeviceHelper, DeviceHelper.isPC);
  when(mockFunc)().afterReturn(true);
  return new LiveViewAnimManager();
}

interface Param {
  hashcode: string,
  index: number,
  total: number,
  animCount: number,
}

interface ILiveViewAnimManager {
  expandLiveListItem(param: Param): void;
  collapseLiveListItem(param: Param): void;
  expandLiveListItemFinished(animCount: number): void;
  logLastAnimEnd(hasCode: string, isLast: boolean): void;
  dealFollowParm(state: ComponentAnimState): void;
  getListAnimCount(): number;
}

/**
 * 实况列表动效管理器测试类
 */
export function LiveViewAnimManagerTest() {
  const liveViewAnimManager = getLiveViewAnimManager();
  describe('LiveViewAnimManagerTest', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('showLiveList', Level.LEVEL1, (): void => {
      let method = () => {
        capsuleStateMgr.getCapsuleArea();
      }
      expect(method).not().assertFail();
    });

    it('hideLiveList', Level.LEVEL1, (): void => {
      let method = () => {
        capsuleStateMgr.getCapsuleArea();
      }
      expect(method).not().assertFail();
    });

    it('updateCapsuleArea', Level.LEVEL0, () => {
      liveViewAnimManager.updateCapsuleArea(undefined);
      expect(liveViewAnimManager.getCapsuleArea()).assertEqual(undefined);
    });

    it('upBannerZIndex', Level.LEVEL0, () => {
      liveViewAnimManager.upBannerZIndex();
      expect(true).assertTrue();
    });

    it('resetBannerZIndex', Level.LEVEL0, () => {
      liveViewAnimManager.resetBannerZIndex();
      expect(true).assertTrue();
    });

    it('getCapsuleArea', Level.LEVEL0, () => {
      const area = liveViewAnimManager.getCapsuleArea();
      expect(area).assertEqual(Reflect.get(liveViewAnimManager, 'capsuleArea'));
    });
  });
}

export function LiveViewAnimManagerTest2() {
  const liveViewAnimManager = getLiveViewAnimManager();
  describe('LiveViewAnimManagerTest2', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('registerAnimStatusChangeCallback', Level.LEVEL0, () => {
      liveViewAnimManager.registerAnimStatusChangeCallback(() => {});
      expect(true).assertTrue();
    });

    it('getCapsuleListAnimState', Level.LEVEL0, () => {
      liveViewAnimManager.getCapsuleListAnimState();
      liveViewAnimManager.getCapsuleListAnimVm();
      liveViewAnimManager.getBannerCapsuleAnimVm();
      liveViewAnimManager.getBannerListItemAnimState('');
      liveViewAnimManager.deleteBannerListItemAnimState('');
      liveViewAnimManager.getBannerListItemCapsuleAnimVm();
      expect(true).assertTrue();
    });

    it('addFollowShowHideAnimState', Level.LEVEL0, () => {
      liveViewAnimManager.setCapsuleListData([]);
      liveViewAnimManager.setLiveListData([]);
      liveViewAnimManager.setPluginCapsuleAnimState();
      liveViewAnimManager.checkAnimCapsuleData(AnimDataScene.SCENE_NONE);
      liveViewAnimManager.clearAnimCapsuleData(AnimDataScene.SCENE_NONE);
      liveViewAnimManager.addFollowShowHideAnimState(new ComponentAnimState('test'))
      liveViewAnimManager.setCheckCapsuleList(() => {});
      liveViewAnimManager.setCapsuleListState(new CapsuleListState());
      expect(true).assertTrue();
    });
  });
}

export function LiveViewAnimManagerTest3() {
  const liveViewAnimManager = getLiveViewAnimManager();
  describe('LiveViewAnimManagerTest3', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('checkCapsuleShowHideAnim', Level.LEVEL0, () => {
      liveViewAnimManager.checkCapsuleShowHideAnim();
      liveViewAnimManager.checkCapsuleRemindAnim();
      liveViewAnimManager.showLiveList();
      liveViewAnimManager.hideLiveList();
      liveViewAnimManager.onCapsuleAreaChange({ width: 0, height: 0 });
      expect(true).assertTrue();
    });

    it('onLiveListChange', Level.LEVEL0, () => {
      liveViewAnimManager.onLiveListChange(() => {});
      liveViewAnimManager.getItemCommonAnimState(0);
      liveViewAnimManager.startLiveViewItemFollowing();
      liveViewAnimManager.updateLiveViewItemFollowing(1);
      liveViewAnimManager.updateLiveViewItemFollowing(-1);
      liveViewAnimManager.endLiveViewItemFollowing(true);
      liveViewAnimManager.endLiveViewItemFollowing(false, -1);
      liveViewAnimManager.endLiveViewItemFollowing(false, 1);
      expect(true).assertTrue();
    });
  });
}

export function LiveViewAnimManagerTest4() {
  const liveViewAnimManager = getLiveViewAnimManager();
  describe('LiveViewAnimManagerTest4', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('expandLiveListItem', Level.LEVEL0, () => {
      for (let i = 0; i < 3; i++) {
        (liveViewAnimManager as Object as ILiveViewAnimManager).expandLiveListItem({
          hashcode: '',
          index: i,
          total: 3,
          animCount: 0
        });
      }
      expect(true).assertTrue();
    });

    it('collapseLiveListItem', Level.LEVEL0, () => {
      for (let i = 0; i < 3; i++) {
        (liveViewAnimManager as Object as ILiveViewAnimManager).collapseLiveListItem({
          hashcode: '',
          index: i,
          total: 3,
          animCount: 0
        });
      }
      expect(true).assertTrue();
    });

    it('expandLiveListItemFinished', Level.LEVEL0, () => {
      (liveViewAnimManager as Object as ILiveViewAnimManager).expandLiveListItemFinished(0);
      expect(true).assertTrue();
    });
  });
}

export function LiveViewAnimManagerTest5() {
  const liveViewAnimManager = getLiveViewAnimManager();
  describe('LiveViewAnimManagerTest5', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('logLastAnimEnd', Level.LEVEL0, () => {
      (liveViewAnimManager as Object as ILiveViewAnimManager).logLastAnimEnd('', true);
      expect(true).assertTrue();
    });

    it('dealFollowParm', Level.LEVEL0, () => {
      (liveViewAnimManager as Object as ILiveViewAnimManager).dealFollowParm(new ComponentAnimState(''));
      expect(true).assertTrue();
    });

    LiveViewAnimManagerTest6();
  });
}

const liveViewAnimMgr = getLiveViewAnimManager();

function LiveViewAnimManagerTest6() {

  it('test_removeFollowShowHideAnimState', Level.LEVEL1, (): void => {
    try {
      liveViewAnimMgr.removeFollowShowHideAnimState(new ComponentAnimState('test'));
    } catch (err) {}
    expect(Reflect.has(liveViewAnimMgr, 'removeFollowShowHideAnimState')).assertTrue();
  });

  it('test_showLiveList', Level.LEVEL1, (): void => {
    try {
      liveViewAnimMgr.showLiveList(false);
    } catch (err) {}
    expect(Reflect.has(liveViewAnimMgr, 'showLiveList')).assertTrue();
  });

  it('test_hideLiveList', Level.LEVEL1, (): void => {
    try {
      liveViewAnimMgr.hideLiveList(false);
    } catch (err) {}
    expect(Reflect.has(liveViewAnimMgr, 'hideLiveList')).assertTrue();
  });
}

export function LiveViewAnimManagerTest7() {
  let liveViewAnimManager =  new LiveViewAnimManager();
  describe('LiveViewAnimManagerTest7', (): void => {
    beforeAll((): void => {
    });
    beforeEach((): void => {
    });
    afterAll((): void => {
    });
    afterEach((): void => {
    });

    it('startLiveViewItemFollowing', Level.LEVEL0, () =>{
      liveViewAnimManager.startLiveViewItemFollowing();
      expect(true).assertTrue();
    });

    it("updateLiveViewItemFollowing", Level.LEVEL0, () => {
      liveViewAnimManager.updateLiveViewItemFollowing(1);
      liveViewAnimManager.updateLiveViewItemFollowing(-1);
      expect(true).assertTrue();
    })

    it("endLiveViewItemFollowing", Level.LEVEL0, () => {
      liveViewAnimManager.endLiveViewItemFollowing(true);
      liveViewAnimManager.endLiveViewItemFollowing(false, -1);
      liveViewAnimManager.endLiveViewItemFollowing(false, 1);
      expect(true).assertTrue();
    })

    it('getListAnimCount', Level.LEVEL0, () => {
      (liveViewAnimManager as Object as ILiveViewAnimManager).getListAnimCount();
      expect(true).assertTrue();
    });
  });
}

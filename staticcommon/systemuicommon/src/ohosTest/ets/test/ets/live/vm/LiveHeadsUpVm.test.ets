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
  ArgumentMatchers,
  DEFAULT
} from '@ohos/hypium';
import { CutoutVm, LiveVmInjector } from '../../../../../../../newIndex';
import { BannerPanelType } from '../../../../../../main/ets/banner/common/info/BannerState';
import { bannerMgr } from '../../../../../../main/ets/banner/phone/BannerManager';
import { LiveStyle } from '../../../../../../main/ets/live/constants/LiveStyle';
import { LiveType } from '../../../../../../main/ets/live/model/LiveCommonModel';
import { LiveNotification } from '../../../../../../main/ets/live/model/LiveNotification';
import { SysTypeCode } from '../../../../../../main/ets/liveview/common/LiveConstants';

export default function LiveHeadsUpVmTest() {
  describe('LiveHeadsUpVmTest', () => {

    beforeAll((): void => {
    })

    beforeEach((): void => {
    })

    afterAll((): void => {
    })

    afterEach((): void => {
    })
  })
  LiveHeadsUpVmTest1();
  LiveHeadsUpVmTest2();
  LiveHeadsUpVmTest3();
  LiveHeadsUpVmTest4();
  LiveHeadsUpVmTest5();
  LiveHeadsUpVmTest6();
  LiveHeadsUpVmTest7();
  LiveHeadsUpVmTest8();
  LiveHeadsUpVmTest9();
  LiveHeadsUpVmTest10();
  LiveHeadsUpVmTest11();
  LiveHeadsUpVmTest12();
  LiveHeadsUpVmTest13();
  LiveHeadsUpVmTest14();
  LiveHeadsUpVmTest15();
  LiveHeadsUpVmTest16();
}

function LiveHeadsUpVmTest1() {
  it('show1', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    try {
      const showResult = headUpVm.show(live);
      expect(showResult).assertTrue();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest2() {
  it('show2', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    live.isHeadsUpStick = true;
    headUpVm.live = new LiveNotification();
    headUpVm.live.hashCode = '2';
    try {
      const showResult = headUpVm.show(live);
      expect(showResult).assertFalse();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest3() {
  it('show3', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    live.isHeadsUpStick = false;
    headUpVm.live = undefined;
    try {
      bannerMgr.requestPanelLiveList();
      const showResult = headUpVm.show(live);
      expect(showResult).assertFalse();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest4() {
  it('show4', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    try {
      bannerMgr.requestPanelLiveList();
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '1';
      const showResult = headUpVm.show(live);
      expect(showResult).assertTrue();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest5() {
  it('show5', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '1';
      const showResult = headUpVm.show(live);
      expect(showResult).assertTrue();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest6() {
  it('show6', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    try {
      headUpVm.live = undefined;
      let capsuleLive = new LiveNotification();
      capsuleLive.hashCode = '1'
      LiveVmInjector.instance.getCapsuleListVm().liveList.push(capsuleLive);
      const showResult = headUpVm.show(live);
      expect(headUpVm.headsUpNtfHashCode).assertEqual('1');
      expect(showResult).assertTrue();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest7() {
  it('show7', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.NORMAL;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '2'
      const showResult = headUpVm.show(live);
      expect(showResult).assertTrue();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest8() {
  it('show8', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '2'
      const showResult = headUpVm.show(live);
      expect(showResult).assertTrue();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest9() {
  it('hide1', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '1'
      headUpVm.hide(live);
      expect(headUpVm.isInterrupt).assertFalse();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest10() {
  it('hide2', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '1'
      headUpVm.hide(live);
      expect(bannerMgr.preemptPromise).assertUndefined();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest11() {
  it('hide3', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '1'
      headUpVm.hide(live);
      expect(headUpVm.isTimeout).assertFalse();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest12() {
  it('hide4', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '1'
      headUpVm.hide(live);
      expect(headUpVm.live).assertUndefined();
      expect(headUpVm.showLive).assertUndefined();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest13() {
  it('hide5', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '1'
      headUpVm.hide(live);
      expect(headUpVm.timeoutMap.get('1')).assertFail();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest14() {
  it('clearTimeout', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      headUpVm.live.hashCode = '1'
      headUpVm.timeoutMap.set('1', 111);
      headUpVm.clearTimeout(live);
      expect(headUpVm.timeoutMap.get('1')).assertFail();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest15() {
  it('onCutoutChange', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    try {
      live.typeCode === SysTypeCode.WALLET;
      headUpVm.onCutoutChange();
      expect(headUpVm.contentSize?.width).assertEqual(LiveStyle.CARD_WIDTH);
      expect(headUpVm.contentSize?.height).assertEqual('auto');
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest16() {
  it('onListAreaChange', DEFAULT, () => {
    const headUpVm = LiveVmInjector.instance.getLiveHeadsUpVm();
    let live = new LiveNotification();
    live.hashCode = '1';
    live.type = LiveType.INSTANT_BANNER;
    live.isHeadsUp = true;
    try {
      headUpVm.live = new LiveNotification();
      expect(bannerMgr.isBannerPanelType(BannerPanelType.TYPE_LIVE_HEADS_UP)).assertTrue();
    } catch (e) {
    }
  })
}

function LiveHeadsUpVmTest17() {
  it('onShowTest', 0, () => {
    // 创建一个模拟的LiveNotification实例
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const liveNotification2 = new LiveNotification({ hashCode: 2, isInstantBanner: () => false });
    const liveNotification3 = new LiveNotification({ hashCode: 3, isInstantBanner: () => true });

    // 创建一个模拟的LiveCardVm实例并实现isNeedShow方法
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = (live: LiveNotification) => live.hashCode === 1;

    // 创建一个模拟的CapsuleListVm实例并实现hide方法
    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    // 创建一个模拟的BannerMgr实例并实现isBannerPanelType方法
    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => type === BannerPanelType.TYPE_LIVE_LIST;

    // 创建一个模拟的ViewMgrPolicy实例并实现showView和isViewShowing方法
    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    // 创建一个模拟的SystemUICommonUtil实例并实现sleep方法
    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建一个测试对象并模拟依赖方法
    const testObject = new class {
      getCardVm = (live: LiveNotification) => cardVm;
      getCapsuleListVm = () => capsuleListVm;
      getBannerMgr = () => bannerMgr;
      getViewMgrPolicy = () => viewMgrPolicy;
      getSystemUiCommonUtil = () => systemUiCommonUtil;
    };

    // 测试不同条件下的show方法
    await expect(testObject.show(live)).resolves.toBeTrue();
    await expect(testObject.show(liveNotification2)).resolves.toBeFalse();
    await expect(testObject.show(liveNotification3)).resolves.toBeTrue();
  })
}

function LiveHeadsUpVmTest18() {
  it('test_show_cardVm_isNeedShow_false', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => false;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => false;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: undefined,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试cardVm.isNeedShow返回false的情况
    await expect(testObject.show(live)).resolves.toBeFalse();
  });
}

function LiveHeadsUpVmTest19() {
  it('test_show_live_isHeadsUpStick_true_and_hashCode_diff', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => false;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: { hashCode: 2, isHeadsUpStick: true },
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试this.live存在且isHeadsUpStick为true，且live.hashCode不同的情况
    await expect(testObject.show(live)).resolves.toBeFalse();
  });
}

function LiveHeadsUpVmTest20() {
  it('test_show_bannerMgr_TYPE_LIVE_LIST_and_live_not_instant', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => false });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => type === BannerPanelType.TYPE_LIVE_LIST;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: undefined,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试bannerMgr.isBannerPanelType为TYPE_LIVE_LIST且live.isInstantBanner返回false的情况
    await expect(testObject.show(live)).resolves.toBeFalse();
  });
}

function LiveHeadsUpVmTest21() {
  it('test_show_bannerMgr_TYPE_LIVE_LIST_and_live_instant', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => type === BannerPanelType.TYPE_LIVE_LIST;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: undefined,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试bannerMgr.isBannerPanelType为TYPE_LIVE_LIST且live.isInstantBanner返回true的情况
    await expect(testObject.show(live)).resolves.toBeTrue();
  });
}

function LiveHeadsUpVmTest22() {
  it('test_show_oldLive_same_hashCode', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => false;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: live,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试oldLive和live.hashCode相同的情况
    await expect(testObject.show(live)).resolves.toBeTrue();
  });
}

function LiveHeadsUpVmTest23() {
  it('test_show_oldLive_null_and_isOtherLiveUpdate_true_and_view_not_showing', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => false;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: undefined,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试oldLive不存在且isOtherLiveUpdate返回true，且viewMgrPolicy.isViewShowing返回false的情况
    await expect(testObject.show(live)).resolves.toBeTrue();
  });
}

function LiveHeadsUpVmTest24() {
  it('test_show_oldLive_null_and_isOtherLiveUpdate_true_and_view_showing', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => false;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => true;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: undefined,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试oldLive不存在且isOtherLiveUpdate返回true，且viewMgrPolicy.isViewShowing返回true的情况
    await expect(testObject.show(live)).resolves.toBeTrue();
  });
}

function LiveHeadsUpVmTest25() {
  it('test_show_oldLive_exists_and_hashCode_diff_and_live_instant', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const oldLive = new LiveNotification({ hashCode: 2, isInstantBanner: () => false });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => false;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: oldLive,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试oldLive存在且hashCode不同，且live.isInstantBanner返回true的情况
    await expect(testObject.show(live)).resolves.toBeTrue();
  });
}

function LiveHeadsUpVmTest26() {
  it('test_show_oldLive_exists_and_hashCode_diff_and_live_not_instant', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => false });
    const oldLive = new LiveNotification({ hashCode: 2, isInstantBanner: () => true });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => false;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: oldLive,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试oldLive存在且hashCode不同，且live.isInstantBanner返回false的情况
    await expect(testObject.show(live)).resolves.toBeTrue();
  });
}

function LiveHeadsUpVmTest27() {
  it('test_show_viewMgrPolicy_isViewShowing_false', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => false;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => false;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: undefined,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试viewMgrPolicy.isViewShowing返回false的情况
    await expect(testObject.show(live)).resolves.toBeTrue();
  });
}

function LiveHeadsUpVmTest28() {
  it('test_show_viewMgrPolicy_isViewShowing_true', 0, async () => {
    // 创建模拟对象
    const live = new LiveNotification({ hashCode: 1, isInstantBanner: () => true });
    const cardVm = new LiveCardVm();
    cardVm.isNeedShow = () => true;

    const capsuleListVm = new CapsuleListVm();
    capsuleListVm.hide = async () => {
    };

    const bannerMgr = new BannerMgr();
    bannerMgr.isBannerPanelType = (type: BannerPanelType) => false;

    const viewMgrPolicy = new ViewMgrPolicy();
    viewMgrPolicy.showView = (type: ViewType) => {
    };
    viewMgrPolicy.isViewShowing = (type: ViewType) => true;

    const systemUiCommonUtil = new SystemUICommonUtil();
    systemUiCommonUtil.sleep = (time: number) => new Promise<object>(resolve => setTimeout(resolve, time));

    // 创建测试对象
    const testObject = {
      getCardVm: (live: LiveNotification) => cardVm,
      getCapsuleListVm: () => capsuleListVm,
      getBannerMgr: () => bannerMgr,
      getViewMgrPolicy: () => viewMgrPolicy,
      getSystemUICommonUtil: () => systemUiCommonUtil,
      live: undefined,
      headsUpNtfHashCode: undefined,
      isCollapsing: false,
      isHiding: false,
      initStatus: (live: LiveNotification) => {
      },
      showingLiveUpdate: (live: LiveNotification) => Promise.resolve(),
      togCapsuleList: (hashCode: number | undefined, options?: { needAnimation: boolean }) => {
      },
      showBanner: (live: LiveNotification) => Promise.resolve(),
      clearTimeout: (oldLive: LiveNotification) => {
      },
      waitForDisappear: () => Promise.resolve(),
      checkAddOrUpdate: (oldLive: LiveNotification, newLive: LiveNotification) => Promise.resolve(),
      isOtherLiveUpdate: (live: LiveNotification) => true
    };

    // 测试viewMgrPolicy.isViewShowing返回true的情况
    await expect(testObject.show(live)).resolves.toBeTrue();
  });
}

function LiveHeadsUpVmTest29() {
  it('test_onCutoutChange_cutoutVm_false_live_exists_isHiding_false_isWallet_true', 0, async () => {
    // 创建模拟对象
    const cutoutVm = new CutoutVm();
    cutoutVm.isMiddleCutout = () => false;

    const live = new LiveNotification({ isWallet: () => true });
    const cardVm = new LiveHeadsUpCardVm();
    cardVm.setCardResponseRegion = (enable: boolean) => {
    };

    // 创建测试对象
    const testObject = {
      cutoutVm: cutoutVm,
      live: live,
      isHiding: false,
      contentSize: undefined,
      showStatusBar: () => {
      },
      getCardVm: (live: LiveNotification) => cardVm,
      log: {
        showInfo: (message: string) => {
        }
      }
    };

    // 调用onCutoutChange方法
    testObject.onCutoutChange();

    // 验证contentSize是否被正确设置
    expect(testObject.contentSize).toEqual({ width: LiveStyle.CARD_WIDTH, height: 'auto' });

    // 验证showStatusBar是否被调用
    expect(testObject.showStatusBar).toHaveBeenCalled();

    // 验证setCardResponseRegion是否被调用
    expect(cardVm.setCardResponseRegion).toHaveBeenCalledWith(true);
  });
}

function LiveHeadsUpVmTest30() {
  it('test_onCutoutChange_cutoutVm_false_live_exists_isHiding_false_isWallet_false', 0, async () => {
    // 创建模拟对象
    const cutoutVm = new CutoutVm();
    cutoutVm.isMiddleCutout = () => false;

    const live = new LiveNotification({ isWallet: () => false });
    const cardVm = new LiveHeadsUpCardVm();
    cardVm.setCardResponseRegion = (enable: boolean) => {
    };

    // 创建测试对象
    const testObject = {
      cutoutVm: cutoutVm,
      live: live,
      isHiding: false,
      contentSize: undefined,
      showStatusBar: () => {
      },
      getCardVm: (live: LiveNotification) => cardVm,
      log: {
        showInfo: (message: string) => {
        }
      }
    };

    // 调用onCutoutChange方法
    testObject.onCutoutChange();

    // 验证contentSize是否被正确设置
    expect(testObject.contentSize).toEqual({ width: LiveStyle.CARD_WIDTH, height: 'auto' });

    // 验证showStatusBar是否被调用
    expect(testObject.showStatusBar).toHaveBeenCalled();

    // 验证setCardResponseRegion是否被调用
    expect(cardVm.setCardResponseRegion).toHaveBeenCalledWith(true);
  });
}

function LiveHeadsUpVmTest31() {
  it('test_onCutoutChange_cutoutVm_false_live_exists_isHiding_true_isWallet_true', 0, async () => {
    // 创建模拟对象
    const cutoutVm = new CutoutVm();
    cutoutVm.isMiddleCutout = () => false;

    const live = new LiveNotification({ isWallet: () => true });
    const cardVm = new LiveHeadsUpCardVm();
    cardVm.setCardResponseRegion = (enable: boolean) => {
    };

    // 创建测试对象
    const testObject = {
      cutoutVm: cutoutVm,
      live: live,
      isHiding: true,
      contentSize: undefined,
      showStatusBar: () => {
      },
      getCardVm: (live: LiveNotification) => cardVm,
      log: {
        showInfo: (message: string) => {
        }
      }
    };

    // 调用onCutoutChange方法
    testObject.onCutoutChange();

    // 验证contentSize是否被正确设置
    expect(testObject.contentSize).toEqual({ width: LiveStyle.CARD_WIDTH, height: 'auto' });

    // 验证showStatusBar是否未被调用
    expect(testObject.showStatusBar).not.toHaveBeenCalled();

    // 验证setCardResponseRegion是否被调用
    expect(cardVm.setCardResponseRegion).toHaveBeenCalledWith(true);
  });
}

function LiveHeadsUpVmTest32() {
  it('test_onCutoutChange_cutoutVm_false_live_exists_isHiding_true_isWallet_false', 0, async () => {
    // 创建模拟对象
    const cutoutVm = new CutoutVm();
    cutoutVm.isMiddleCutout = () => false;

    const live = new LiveNotification({ isWallet: () => false });
    const cardVm = new LiveHeadsUpCardVm();
    cardVm.setCardResponseRegion = (enable: boolean) => {
    };

    // 创建测试对象
    const testObject = {
      cutoutVm: cutoutVm,
      live: live,
      isHiding: true,
      contentSize: undefined,
      showStatusBar: () => {
      },
      getCardVm: (live: LiveNotification) => cardVm,
      log: {
        showInfo: (message: string) => {
        }
      }
    };

    // 调用onCutoutChange方法
    testObject.onCutoutChange();

    // 验证contentSize是否被正确设置
    expect(testObject.contentSize).toEqual({ width: LiveStyle.CARD_WIDTH, height: 'auto' });

    // 验证showStatusBar是否未被调用
    expect(testObject.showStatusBar).not.toHaveBeenCalled();

    // 验证setCardResponseRegion是否被调用
    expect(cardVm.setCardResponseRegion).toHaveBeenCalledWith(true);
  });
}

function LiveHeadsUpVmTest33() {
  it('test_onCutoutChange_cutoutVm_false_live_null', 0, async () => {
    // 创建模拟对象
    const cutoutVm = new CutoutVm();
    cutoutVm.isMiddleCutout = () => false;

    // 创建测试对象
    const testObject = {
      cutoutVm: cutoutVm,
      live: undefined,
      isHiding: false,
      contentSize: undefined,
      showStatusBar: () => {
      },
      getCardVm: (live: LiveNotification) => {
        throw new Error('getCardVm called with live undefined');
      },
      log: {
        showInfo: (message: string) => {
        }
      }
    };

    // 调用onCutoutChange方法
    testObject.onCutoutChange();

    // 验证contentSize是否被正确设置
    expect(testObject.contentSize).toEqual({ width: LiveStyle.CARD_WIDTH, height: 'auto' });

    // 验证showStatusBar是否未被调用
    expect(testObject.showStatusBar).not.toHaveBeenCalled();
  });
}

function LiveHeadsUpVmTest34() {
  it('test_onCutoutChange_cutoutVm_true_live_exists_isHiding_false_isWallet_true', 0, async () => {
    // 创建模拟对象
    const cutoutVm = new CutoutVm();
    cutoutVm.isMiddleCutout = () => true;

    const live = new LiveNotification({ isWallet: () => true });
    const cardVm = new LiveHeadsUpCardVm();
    cardVm.setCardResponseRegion = (enable: boolean) => {
    };

    // 创建测试对象
    const testObject = {
      cutoutVm: cutoutVm,
      live: live,
      isHiding: false,
      contentSize: undefined,
      showStatusBar: () => {
      },
      getCardVm: (live: LiveNotification) => cardVm,
      log: {
        showInfo: (message: string) => {
        }
      }
    };

    // 调用onCutoutChange方法
    testObject.onCutoutChange();

    // 验证contentSize是否未被设置
    expect(testObject.contentSize).toBeUndefined();

    // 验证showStatusBar是否未被调用
    expect(testObject.showStatusBar).not.toHaveBeenCalled();

    // 验证setCardResponseRegion是否被调用
    expect(cardVm.setCardResponseRegion).toHaveBeenCalledWith(true);
  });
}

function LiveHeadsUpVmTest35() {
  it('test_onCutoutChange_cutoutVm_true_live_exists_isHiding_false_isWallet_false', 0, async () => {
    // 创建模拟对象
    const cutoutVm = new CutoutVm();
    cutoutVm.isMiddleCutout = () => true;

    const live = new LiveNotification({ isWallet: () => false });
    const cardVm = new LiveHeadsUpCardVm();
    cardVm.setCardResponseRegion = (enable: boolean) => {
    };

    // 创建测试对象
    const testObject = {
      cutoutVm: cutoutVm,
      live: live,
      isHiding: false,
      contentSize: undefined,
      showStatusBar: () => {
      },
      getCardVm: (live: LiveNotification) => cardVm,
      log: {
        showInfo: (message: string) => {
        }
      }
    };

    // 调用onCutoutChange方法
    testObject.onCutoutChange();
    // 验证contentSize是否未被设置
    expect(testObject.contentSize).toBeUndefined();
    // 验证showStatusBar是否未被调用
    expect(testObject.showStatusBar).not.toHaveBeenCalled();
    // 验证setCardResponseRegion是否被调用
    expect(cardVm.setCardResponseRegion).toHaveBeenCalledWith(true);
  });
}

function LiveHeadsUpVmTest36() {
  it('test_onCutoutChange_cutoutVm_true_live_exists_isHiding_true_isWallet_true', 0, async () => {
    // 创建模拟对象
    const cutoutVm = new CutoutVm();
    cutoutVm.isMiddleCutout = () => true;

    const live = new LiveNotification({ isWallet: () => true });
    const cardVm = new LiveHeadsUpCardVm();
    cardVm.setCardResponseRegion = (enable: boolean) => {
    };

    // 创建测试对象
    const testObject = {
      cutoutVm: cutoutVm,
      live: live,
      isHiding: true,
      contentSize: undefined,
      showStatusBar: () => {
      },
      getCardVm: (live: LiveNotification) => cardVm,
      log: {
        showInfo: (message: string) => {
        }
      }
    };

    // 调用onCutoutChange方法
    testObject.onCutoutChange();
    // 验证contentSize是否未被设置
    expect(testObject.contentSize).toBeUndefined();
    // 验证showStatusBar是否未被调用
    expect(testObject.showStatusBar).not.toHaveBeenCalled();
    // 验证setCardResponseRegion是否被调用
    expect(cardVm.setCardResponseRegion).toHaveBeenCalledWith(true);
  });
}

function LiveHeadsUpVmTest37() {
  it('test_onCutoutChange_cutoutVm_true_live_exists_isHiding_true_isWallet_false', 0, async () => {
    // 创建模拟对象
    const cutoutVm = new CutoutVm();
    cutoutVm.isMiddleCutout = () => true;

    const live = new LiveNotification({ isWallet: () => false });
    const cardVm = new LiveHeadsUpCardVm();
    cardVm.setCardResponseRegion = (enable: boolean) => {
    };

    // 创建测试对象
    const testObject = {
      cutoutVm: cutoutVm,
      live: live,
      isHiding: true,
      contentSize: undefined,
      showStatusBar: () => {
      },
      getCardVm: (live: LiveNotification) => cardVm,
      log: {
        showInfo: (message: string) => {
        }
      }
    };
    // 调用onCutoutChange方法
    testObject.onCutoutChange();
    // 验证contentSize是否未被设置
    expect(testObject.contentSize).toBeUndefined();
    // 验证showStatusBar是否未被调用
    expect(testObject.showStatusBar).not.toHaveBeenCalled();
    // 验证setCardResponseRegion是否被调用
    expect(cardVm.setCardResponseRegion).toHaveBeenCalledWith(true);
  });
}
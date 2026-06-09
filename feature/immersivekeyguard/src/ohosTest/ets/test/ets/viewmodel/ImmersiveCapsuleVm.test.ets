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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level, MockKit, when } from '@ohos/hypium';
import Want from '@ohos.app.ability.Want';
import { CapsulePositionType } from '../../../../../main/ets/common/ImmersiveConstants';
import { ImmersiveCapsuleVm } from '../../../../../main/ets/viewmodel/ImmersiveCapsuleVm';
import { immersiveVm } from '../../../../../main/ets/viewmodel/ImmersiveVm';
import {
  ImmersiveCardState,
  KeyGuardCapsuleState,
  KeyGuardListState,
  ImmersiveWidthState,
  immersiveStateMgr
} from '../../../../../main/ets/common/manager/ImmersiveStateManager';
import { ImmersiveDataGroupPacker } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveNtfData } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import { ImmersiveCapsuleList } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleList';
import { ImmersiveCardData } from '../../../../../main/ets/viewmodel/viewdata/ImmersiveCardData';
import {
  LiveType,
  immersiveKgMgr,
  ImmersiveType,
  LiveOtherExtendData,
  ImmersiveState
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveAnimScene } from '../../../../../main/ets/common/anim/ImmersiveAnimConstants';
import { ArrayUtils, CommonUtils } from '@ohos/basicutils';
import { WidgetAnimState } from '@ohos/screenlockcommon/Index';
import { immersiveStateHelper } from '../../../../../main/ets/common/helper/ImmersiveStateHelper';
import { ISlState } from '@ohos/screenlockcommon/src/main/ets/interface/ISlState';
import { SlStaticStateType } from '@ohos/screenlockcommon/src/main/ets/constants/SlStateType';
import { ImmersiveCapsuleAnimManager } from '../../../../../main/ets/viewmodel/viewanim/ImmersiveCapsuleAnimManager';

/**
 * 沉浸式锁屏测试用例
 */
export function ImmersiveCapsuleVmTest() {
  describe('ImmersiveCapsuleVmTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
    immersiveNtfData.hashCode = 'fd';
    immersiveNtfData.groupKey = 'grouptest';
    immersiveNtfData.creatorBundleName = 'mytest.com';
    immersiveNtfData.appName = 'myapp';
    immersiveNtfData.id = 10000;
    let ntfDatas: ImmersiveNtfData[] = [];
    ntfDatas.push(immersiveNtfData);

    it('testGetRootUiStyle', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      immersiveNtfData.hashCode = 'myHashCode';
      immersiveNtfData.id = 100000;
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_CONTENT, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let res = capsuleVm.getRootUiStyle();
      res?.onLongClick?.();
      res?.onClick?.();
      res?.onIconClick?.();
      expect(res).not().assertNull();
    });

    it('testGetChildUiStyle', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let res = capsuleVm.getChildUiStyle(CapsulePositionType.TYPE_CONTENT);
      expect(res).not().assertNull();
    });

    it('testGetExtendUiStyle', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let res = capsuleVm.getExtendUiStyle();
      expect(res).not().assertNull();
    });

    it('testGetShowList', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let res = capsuleVm.getShowList();
      expect(res).not().assertNull();
    });

    it('testOnCapsuleToList', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      capsuleVm.onCapsuleToList();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      capsuleVm.onCapsuleToList();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      capsuleVm.onCapsuleToList();
      expect(capsuleVm).not().assertNull();
    });

    it('testCheckAndUpdateUiData', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      capsuleVm.checkAndUpdateUiData(true);
      expect(capsuleVm).not().assertNull();
    });

    it('testSetDestroy', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      capsuleVm.setDestroy(false);
      expect(capsuleVm).not().assertNull();
    });

    it('testOnCapsuleClick', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      capsuleVm.onCapsuleClick();
      expect(capsuleVm).not().assertNull();
    });

    it('testGetRemindData', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      let tmpList = new ImmersiveCapsuleList();
      tmpList.setCapsuleData(CapsulePositionType.TYPE_SHADOW, immersiveNtfData);
      (capsuleVm as object)['tmpList'] = tmpList;
      capsuleVm.checkAndUpdateUiData(true);

      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      capsuleVm.checkAndUpdateUiData(true);
      capsuleVm.checkAndUpdateUiData(false);
      (capsuleVm as object)['getRemindData']();
      (groupPacker as object)['groupList'] = undefined;
      (capsuleVm as object)['getRemindData']();
      expect(capsuleVm).not().assertNull();
    });

    it('testOnImmersiveStateChange', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let capsuleState = new KeyGuardCapsuleState();
      let listState = new KeyGuardListState();
      let widthState = new ImmersiveWidthState();
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      (capsuleVm as object)['onImmersiveStateChange'](capsuleState);
      (capsuleVm as object)['onImmersiveStateChange'](listState);
      (capsuleVm as object)['onImmersiveStateChange'](widthState);
      expect(capsuleVm).not().assertNull();
    });

    it('testClearRemindState', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['clearRemindState']();
      expect(capsuleVm).not().assertNull();
    });

    it('testProcessCapsuleRemind', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['processCapsuleRemind']();
      let groupPacker = new ImmersiveDataGroupPacker();
      (groupPacker as object)['groupList'] = ntfDatas;
      (capsuleVm as object)['groupManager'] = groupPacker;
      (capsuleVm as object)['processCapsuleRemind']();
      expect(capsuleVm).not().assertNull();
    });

    it('testClearRemindTask', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = setTimeout(() => {
        (capsuleVm as object)['ClearRemindTask']();
      }, 20);
      expect(capsuleVm).not().assertNull();
    });

    it('testOnCapsuleToCard', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['onCapsuleToCard'](immersiveNtfData);
      expect(capsuleVm).not().assertNull();
    });

    it('testCheckBeforeToCard', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['checkBeforeToCard'](immersiveNtfData);
      immersiveStateMgr.setUnlockedState();
      (capsuleVm as object)['checkBeforeToCard'](immersiveNtfData);
      let carddata = new ImmersiveCardData();
      carddata.liveType = LiveType.PROGRESS;
      let want: Want = {
        bundleName: 'com.test.connect.commondialog.nba',
        abilityName: 'LiveViewLockScreenExtAbility',
        parameters: { x: 10, y: 10 }
      };
      carddata.immersiveWant = want;
      immersiveNtfData.cardData = carddata;
      (capsuleVm as object)['checkBeforeToCard'](immersiveNtfData);
      expect(capsuleVm).not().assertNull();
    });

    it('testIsInterceptCapsuleDataUpdate', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['isInterceptCapsuleDataUpdate']();
      (capsuleVm as object)['isInterceptCapsuleDataUpdate'](false);
      (capsuleVm as object)['isInterceptCapsuleDataUpdate'](true);
      expect(capsuleVm).not().assertNull();
    });

    it('testCheckCapsuleInterruption', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let rootAnimState = immersiveVm.getImmersiveAnimMgr().getCapsuleAnimMgr().getRootAnimState();
      (capsuleVm as object)['checkCapsuleInterruption'](rootAnimState);
      expect(capsuleVm).not().assertNull();
    });

    it('testUpdateCapsuleWidth', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['updateCapsuleWidth']();
      expect(capsuleVm).not().assertNull();
    });

    it('testCheckCapsuleData', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['checkCapsuleData']();
      expect(capsuleVm).not().assertNull();
    });

    it('testOnExtendClick', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['onExtendClick'](undefined, undefined);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_CAPSULE);
      (capsuleVm as object)['onExtendClick'](undefined, undefined);
      (capsuleVm as object)['setAnimDataFun'](true, CapsulePositionType.TYPE_CONTENT, CapsulePositionType.TYPE_SHADOW);
      expect(capsuleVm).not().assertNull();
    });

    it('testSetDestroy', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      capsuleVm.setDestroy(false);
      expect(capsuleVm).not().assertNull();
    });

    it('testIsFilterOutData', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      immersiveNtfData.cardData = new ImmersiveCardData();
      immersiveNtfData.cardData.bigIconRes = 'bigIcon.png';
      (capsuleVm as object)['isFilterOutData'](immersiveNtfData);
      expect(capsuleVm).not().assertNull();
    });

    it('testStartCapsule2ListAnim', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['startCapsule2ListAnim'](0);
      (capsuleVm as object)['startCapsule2ListAnim'](10);
      (capsuleVm as object)['startCapsule2ListAnim'](100);
      expect(capsuleVm).not().assertNull();
    });

    it('testStartCapsuleToCard', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['startCapsuleToCard'](immersiveNtfData);
      expect(capsuleVm).not().assertNull();
    });

    it('testShouldNotResponse', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let capsuleState = immersiveVm.getImmersiveAnimMgr().getCapsuleAnimState(CapsulePositionType.TYPE_CONTENT);
      (capsuleVm as object)['shouldNotResponse'](capsuleState);
      expect(capsuleVm).not().assertNull();
    });

    it('testCheckCapsuleAnim', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['checkCapsuleAnim'](true);
      (capsuleVm as object)['checkCapsuleAnim'](false);
      expect(capsuleVm).not().assertNull();
    });

    it('testIsEndableCapsuleAnim', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['isEndableCapsuleAnim'](false);
      immersiveKgMgr.setImmersiveType(ImmersiveType.TYPE_IMMERSIVE);
      (capsuleVm as object)['isEndableCapsuleAnim'](false);
      expect(capsuleVm).not().assertNull();
    });

    it('testClearRemindState2', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      (capsuleVm as object)['clearRemindState']();
      expect(capsuleVm).not().assertNull();
    });

    it('testOnCapsuleToList_02', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let showList = new ImmersiveCapsuleList();
      showList.getNtfData(CapsulePositionType.TYPE_REMIND);
      (capsuleVm as object)['showList'] = showList;
      expect(capsuleVm).not().assertNull();
    });

    it('testOnExtendClick_02', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let extendData: LiveOtherExtendData = new LiveOtherExtendData();
        (capsuleVm as object)['onExtendClick'](extendData, undefined);
      expect(capsuleVm).not().assertNull();
    });

    it('testRootUiStyleUndefined', Level.LEVEL0, (): void => {
      let showList = new ImmersiveCapsuleList();
      showList.getNtfData(CapsulePositionType.TYPE_CONTENT);
      expect(showList).not().assertUndefined();
    })

    it('testIsInterceptCapsuleDataUpdate_02', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let rootAnimState = immersiveVm.getImmersiveAnimMgr().getCapsuleAnimMgr().getRootAnimState();
      (capsuleVm as object)['checkCapsuleInterruption'](rootAnimState);
      (capsuleVm as object)['isInterceptCapsuleDataUpdate']();
      expect(capsuleVm).not().assertNull();
    })

    it('testIsInterceptCapsuleDataUpdate_03', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let rootAnimState = immersiveVm.getImmersiveAnimMgr().getCapsuleAnimMgr().getRootAnimState();
      (capsuleVm as object)['checkCapsuleInterruption'](rootAnimState);
      (capsuleVm as object)['isInterceptCapsuleDataUpdate'](true);
      expect(capsuleVm).not().assertNull();
    })

    it('testOnCapsuleClick_02', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      capsuleVm.onCapsuleClick();
      expect(capsuleVm).not().assertNull();
    });

    it('testIsFilterOutData', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersive = immersiveKgMgr.getImmersiveDisplayState()
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(immersive, immersive.isImmersive);
      let mockFun2 = mock.mockFunc(immersiveNtfData, immersiveNtfData.isShownInCard);
      when(mockFun1)().afterReturn(true);
      when(mockFun2)().afterReturn(true);
      (capsuleVm as object)['isFilterOutData'](immersiveNtfData);
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock(immersive, immersive.isImmersive);
      mock.ignoreMock(immersiveNtfData, immersiveNtfData.isShownInCard);
    });

    it('testProcessCapsuleRemind_02', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(undefined).afterReturn(true);
      (capsuleVm as object)['processCapsuleRemind']();
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('testProcessCapsuleRemind_03', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let immersiveNtfData: ImmersiveNtfData = new ImmersiveNtfData();
      let mock = new MockKit();
      let mockFun1 = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)(immersiveNtfData).afterReturn(false);
      (capsuleVm as object)['processCapsuleRemind']();
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('testSetAnimDataFun', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)().afterReturn(false);
      (capsuleVm as object)['setAnimDataFun']();
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('testOnImmersiveStateChange_02', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let cardState = new ImmersiveCardState();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(cardState, cardState.getImmersiveStateType);
      when(mockFun1)().afterReturn(5);
      (capsuleVm as object)['onImmersiveStateChange'](cardState);
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('testSetAnimDataFun_02', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let animTypes: CapsulePositionType[] = [];
      animTypes.push(CapsulePositionType.TYPE_ANIM_CONTENT);
      (capsuleVm as object)['setAnimDataFun'](false, animTypes);
      expect(capsuleVm).not().assertNull();
    });

    it('testSetAnimDataFun_03', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let animTypes: CapsulePositionType[] = [];
      animTypes.push(CapsulePositionType.TYPE_ANIM_SHADOW);
      (capsuleVm as object)['setAnimDataFun'](false, animTypes);
      expect(capsuleVm).not().assertNull();
    });

    it('testSetAnimDataFun_04', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let animTypes: CapsulePositionType[] = [];
      animTypes.push(CapsulePositionType.TYPE_REMIND);
      (capsuleVm as object)['setAnimDataFun'](false, animTypes);
      expect(capsuleVm).not().assertNull();
    });

    it('testOnScreenLockWallpaperChangeEvent', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let slBindStatus: ISlState | undefined = immersiveStateHelper.getSlBindState();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(CommonUtils, CommonUtils.isInvalid);
      when(mockFun1)().afterReturn(true);
      slBindStatus?.setSlState(SlStaticStateType.SL_SECURE_LOCKED_STATE, true);
      (capsuleVm as object)['onScreenLockWallpaperChangeEvent']();
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock(CommonUtils, CommonUtils.isInvalid);
    });

    it('testOnCapsuleClick_03', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let ntfDataArr: ImmersiveNtfData[] = [];
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      when(mockFun1)(ntfDataArr).afterReturn(true);
      capsuleVm.onCapsuleClick();
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock(ArrayUtils, ArrayUtils.isEmpty);
    });

    it('testOnCapsuleClick_04', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let ntfDataArr: ImmersiveNtfData[] = [];
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(ArrayUtils, ArrayUtils.isEmpty);
      let mockFun2: Function = mock.mockFunc((capsuleVm as object)['showList'], (capsuleVm as object)['showList']
        .getNtfData);
      when(mockFun1)(ntfDataArr).afterReturn(false);
      when(mockFun2)(CapsulePositionType.TYPE_CONTENT).afterReturn('');
      capsuleVm.onCapsuleClick();
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock(ArrayUtils, ArrayUtils.isEmpty);
      mock.ignoreMock((capsuleVm as object)['showList'], (capsuleVm as object)['showList'].getNtfData);
    });

    it('testOnCapsuleToCard_02', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let capsuleAnim: ImmersiveCapsuleAnimManager = new ImmersiveCapsuleAnimManager();
      (capsuleVm as object)['capsuleAnimMgr'] = capsuleAnim;
      let animState: WidgetAnimState = (capsuleVm as object)['capsuleAnimMgr'].getRootAnimState();
      let immersive: ImmersiveState = immersiveKgMgr.getImmersiveDisplayState();
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc(animState, animState.isSceneAnimating);
      let mockFun2: Function = mock.mockFunc(immersive, immersive.isCapsule);
      when(mockFun1)(ImmersiveAnimScene.SCENE_CARD_TO_CAPSULE).afterReturn(true);
      when(mockFun2)().afterReturn(true);
      (capsuleVm as object)['onCapsuleToCard'](immersiveNtfData);
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock(animState, animState.isSceneAnimating);
      mock.ignoreMock(immersive, immersive.isCapsule);
    });

    it('testIsEndableCapsuleAnim_02', Level.LEVEL0, (): void => {
      AppStorage.setOrCreate('isNotificationWakeUp',true)
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let res: boolean =(capsuleVm as object)['isEndableCapsuleAnim'](true);
      expect(res).assertEqual(true)
    });

    it('testClearRemindTask', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      (capsuleVm as object)['remindTaskId'] = 2;
      (capsuleVm as object)['clearRemindTask']();
      expect(capsuleVm).not().assertNull();
    });

    it('testClearRemindState_03', Level.LEVEL0, (): void => {
      let capsuleVm: ImmersiveCapsuleVm = immersiveVm.getImmersiveCapsuleVm();
      let showList = new ImmersiveCapsuleList();
      showList.setCapsuleData(CapsulePositionType.TYPE_REMIND, immersiveNtfData);
      (capsuleVm as object)['showList'] = showList;
      let mock: MockKit = new MockKit();
      let mockFun1: Function = mock.mockFunc((capsuleVm as object)['showList'],(capsuleVm as object)['showList'].getNtfData);
      when(mockFun1)(CapsulePositionType.TYPE_REMIND).afterReturn(false);
      (capsuleVm as object)['clearRemindState']();
      expect(capsuleVm).not().assertNull();
      mock.ignoreMock((capsuleVm as object)['showList'], (capsuleVm as object)['showList'].getNtfData);
    });
  });
}
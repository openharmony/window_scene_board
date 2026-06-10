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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';
import { NotificationConfig } from '@ohos/notificationcomponent/src/main/ets/manager/NotificationConfigManager';
import {
  ImmersiveCapsuleType,
  ImmersiveKgParserCtrlType,
  ImmersiveShowType,
  ImmersiveType,
  LiveType,
  LiveViewData
} from '@ohos/systemuicommon/src/main/ets/TsIndex';
import { ImmersiveCapsuleData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleData';
import { ImmersiveCapsuleList } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCapsuleList';
import { ImmersiveCardData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCardData';
import { ImmersiveCardList } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveCardList';
import { ImmersiveDataGroupPacker } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveDataGroupProcessor';
import { ImmersiveDataPreProcessor } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveDataPreProcessor';
import { ImmersiveKgData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveKgData';
import { ImmersiveNormalCapsuleData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNormalCapsuleData';
import { ImmersiveNtfData } from '../../../../../../main/ets/viewmodel/viewdata/ImmersiveNtfData';
import { ImmersivePanelState } from '../../../../../../main/ets/viewmodel/viewdata/ImmersivePanelState';
import { NtfListStaticState } from '../../../../../../main/ets/viewmodel/viewdata/NtfListState';
import { Want } from '@kit.AbilityKit';

/**
 * 沉浸卡片数据测试用例
 */
export function ImmersiveCardDataTest() {
  describe('ImmersiveCardDataTest', (): void => {
    beforeAll((): void => {
    });

    beforeEach((): void => {
    });

    afterAll((): void => {
    });

    afterEach((): void => {
    });

    it('testCheckState0', Level.LEVEL1, (): void => {
      expect(ImmersiveType.TYPE_LIST === 0).assertTrue();
    });

    it('testCheckState1', Level.LEVEL1, (): void => {
      expect(ImmersiveType.TYPE_CAPSULE === 1).assertTrue();
    });

    it('testCheckState2', Level.LEVEL1, (): void => {
      expect(ImmersiveType.TYPE_IMMERSIVE === 2).assertTrue();
    });

    it('testCheckType_1', Level.LEVEL1, (): void => {
      expect(LiveType.NO_LAYOUT === -1).assertTrue();
    });

    it('testCheckType0', Level.LEVEL1, (): void => {
      expect(LiveType.TYPE_SYSTEM === 0).assertTrue();
    });

    it('testCheckType3', Level.LEVEL1, (): void => {
      expect(LiveType.PROGRESS === 3).assertTrue();
    });

    it('testCheckType4', Level.LEVEL1, (): void => {
      expect(LiveType.PICK_UP === 4).assertTrue();
    });

    it('testCheckType5', Level.LEVEL1, (): void => {
      expect(LiveType.FLIGHT === 5).assertTrue();
    });

    it('testCheckType7', Level.LEVEL1, (): void => {
      expect(LiveType.SCORE === 7).assertTrue();
    });

    it('testCheckShowType0', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      expect(data !== undefined).assertTrue();
    });

    it('testImmersiveCapsuleData0', Level.LEVEL1, (): void => {
      let data = new ImmersiveCapsuleData();
      expect(data !== undefined).assertTrue();
    });

    it('testImmersiveCapsuleData1', Level.LEVEL1, (): void => {
      let data = new ImmersiveCapsuleData();
      data.capsuleType = ImmersiveCapsuleType.LIVE_VIEW;
      expect(data.isLiveCapsule()).assertTrue();
    });

    it('testImmersiveCapsuleList', Level.LEVEL1, (): void => {
      let data = new ImmersiveCapsuleList();
      expect(data !== undefined).assertTrue();
    });

    it('testImmersiveCardList', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardList();
      expect(data !== undefined).assertTrue();
    });

    it('testImmersiveDataGroupPacker', Level.LEVEL1, (): void => {
      let data = new ImmersiveDataGroupPacker();
      expect(data !== undefined).assertTrue();
    });

    it('testImmersiveDataPreProcessor', Level.LEVEL1, (): void => {
      let data = new ImmersiveDataPreProcessor();
      expect(data !== undefined).assertTrue();
    });

    it('testImmersiveKgData1', Level.LEVEL1, (): void => {
      let data = new ImmersiveKgData();
      expect(data !== undefined).assertTrue();
    });

    it('testImmersiveKgData2', Level.LEVEL1, (): void => {
      let data = new ImmersiveKgData();
      expect(data.getDataName() === ImmersiveKgParserCtrlType.TYPE_IMMERSIVE_KG).assertTrue();
    });

    it('testImmersiveNormalCapsuleData0', Level.LEVEL1, (): void => {
      let data = new ImmersiveNormalCapsuleData();
      expect(data !== undefined).assertTrue();
    });

    it('testImmersiveNormalCapsuleData1', Level.LEVEL1, (): void => {
      let data = new ImmersiveNormalCapsuleData();
      let capsuleData = new ImmersiveNormalCapsuleData();
      let dataLength = data.childrenData.length;
      data.addChildData(capsuleData);
      expect(data.childrenData.length === dataLength + 1).assertTrue();
    });

    it('testImmersiveNormalCapsuleData2', Level.LEVEL1, (): void => {
      let data = new ImmersiveNormalCapsuleData();
      let capsuleData = new ImmersiveNormalCapsuleData();
      let dataLength = data.childrenData.length;
      data.addChildData(capsuleData);
      data.deleteGroup();
      expect(data.childrenData.length === 0).assertTrue();
    });

    it('testImmersiveNtfData', Level.LEVEL1, (): void => {
      let data = new ImmersiveNtfData();
      expect(data !== undefined).assertTrue();
    });

    it('testImmersivePanelState', Level.LEVEL1, (): void => {
      let data = new ImmersivePanelState();
      expect(data !== undefined).assertTrue();
    });

    it('testNtfListStaticState0', Level.LEVEL1, (): void => {
      let data = new NtfListStaticState();
      expect(data !== undefined).assertTrue();
    });

    it('testNtfListStaticState1', Level.LEVEL1, (): void => {
      let data = new NtfListStaticState();
      expect(data.isGestureEnabled).assertTrue();
    });

    it('testNtfListStaticState2', Level.LEVEL1, (): void => {
      let data = new NtfListStaticState();
      expect(data.groupCanExpand).assertTrue();
    });

    it('testNtfListStaticState3', Level.LEVEL1, (): void => {
      let data = new NtfListStaticState();
      expect(data.isUseEffect).assertTrue();
    });

    it('testNtfListStaticState4', Level.LEVEL1, (): void => {
      let data = new NtfListStaticState();
      expect(data.itemRadius === NotificationConfig.BORDER_RADIUS).assertTrue();
    });

    it('testNtfListStaticState5', Level.LEVEL1, (): void => {
      let data = new NtfListStaticState();
      expect(data.isTouchingItem).assertFalse();
    });

    it('testNtfListStaticState6', Level.LEVEL1, (): void => {
      let data = new NtfListStaticState();
      expect(data.isStopPropagation).assertTrue();
    });

    it('getLiveType1', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.liveType = LiveType.TYPE_SYSTEM;
      expect(data.getLiveType() === LiveType.TYPE_SYSTEM).assertTrue();
    });

    it('getLiveType2', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.liveType = LiveType.TYPE_SYSTEM;
      expect(data.getLiveType() === LiveType.TYPE_SYSTEM).assertTrue();
    });

    it('update', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      let data1 = new ImmersiveCardData();
      data.update(data1)
      expect(data).not().assertNull();
    });

    it('setLiveType', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.setLiveType();
      data.setLiveType(undefined, false);
      data.setLiveType(undefined, true);
      expect(data).not().assertNull();
    });

    it('setLiveType1', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.setLiveType(LiveType.NO_LAYOUT);
      data.setLiveType(LiveType.NO_LAYOUT, true);
      data.setLiveType(LiveType.NO_LAYOUT, false);
      expect(data).not().assertNull();
    });

    it('setShowTypeListener1', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.setShowTypeListener(undefined);
      expect(data).not().assertNull();
    });

    it('setShowTypeListener2', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.setShowTypeListener((showType) => {
      });
      expect(data).not().assertNull();
    });

    it('setLiveView', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      let viewData = new LiveViewData();
      data.setLiveView(viewData);
      data.setLiveView(undefined, undefined);
      data.setLiveView(undefined, false);
      data.setLiveView(undefined, true);
      data.setLiveView(undefined, undefined);
      data.setLiveView(viewData, false);
      data.setLiveView(viewData, true);
      expect(data).not().assertNull();
    });

    it('setBigIcon', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.setBigIcon(undefined, undefined);
      data.setBigIcon(undefined, false);
      data.setBigIcon(undefined, true);
      data.setBigIconRes(undefined, undefined);
      data.setBigIconRes(undefined, false);
      data.setBigIconRes(undefined, true);
      data.setBigIconRes('icon', true);
      expect(data).not().assertNull();
    });

    it('setBackgroundIcon', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.setBackgroundIcon(undefined, false);
      data.setBackgroundIcon(undefined, false);
      data.setBackgroundIcon(undefined, undefined);
      expect(data).not().assertNull();
    });

    it('setAppName', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.setAppName(undefined, false);
      data.setAppName(undefined, true);
      data.setAppName(undefined, undefined);
      data.setAppName('App', false);
      data.setAppName('App', true);
      data.setAppName('App', undefined);
      expect(data).not().assertNull();
    });

    it('shouldShowInImmersiveCard', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.shouldShowInImmersiveCard();
      expect(data).not().assertNull();
    });

    it('isUiExtensionCard', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.shouldShowInImmersiveCard();
      expect(data).not().assertNull();
    });

    it('deleteShowType0', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.deleteShowType(ImmersiveShowType.NOT_SHOW);
      data.deleteShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.deleteShowType(ImmersiveShowType.SHOW_CARD);
      expect(data).not().assertNull();
    });

    it('deleteShowType1', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.shouldShowInCapsule();
      expect(data).not().assertNull();
    });

    it('deleteShowType2', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.addShowType(ImmersiveShowType.NOT_SHOW);
      data.addShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.addShowType(ImmersiveShowType.SHOW_CARD);
      expect(data).not().assertNull();
    });

    it('setCardLiveView', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      let live = new LiveViewData();
      live.liveType = LiveType.PROGRESS;
      data.setCardLiveView(undefined, undefined);
      data.setCardLiveView(live, true);
      data.setCardLiveView(live, undefined);
      live.liveType = LiveType.PICK_UP;
      data.setCardLiveView(live, undefined);
      live.liveType = LiveType.FLIGHT;
      data.setCardLiveView(live, undefined);
      live.liveType = LiveType.SCORE;
      data.setCardLiveView(live, undefined);
      live.liveType = LiveType.NAVIGATION;
      data.setCardLiveView(live, undefined);
      live.liveType = LiveType.NO_LAYOUT;
      data.setCardLiveView(live, undefined);
      expect(data).not().assertNull();
    });

    it('toString', Level.LEVEL1, (): void => {
      let data = new ImmersiveCardData();
      data.appName = 'appName';
      data.liveType = LiveType.SCORE;
      data.addShowType(ImmersiveShowType.SHOW_CAPSULE);
      data.toString();
      expect(data).not().assertNull();
    });
  });
}